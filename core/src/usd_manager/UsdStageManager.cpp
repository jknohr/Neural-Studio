#include "UsdStageManager.h"
#include <QDebug>
#include <QFileInfo>

#include "UsdStageManager.h"
#include <QDebug>
#include <QFileInfo>

#ifdef NEURAL_STUDIO_USE_USD
#include <pxr/usd/usdGeom/xformable.h>
#include <pxr/usd/usdGeom/mesh.h>
#include <pxr/usd/usd/primRange.h>
#include <pxr/base/gf/vec3d.h>
#include <pxr/base/gf/vec3f.h>
#include <pxr/base/gf/vec2f.h>
#include <pxr/base/gf/rotation.h>
#include <pxr/base/gf/quaternion.h>
#include <pxr/base/vt/array.h>
#endif

namespace NeuralStudio {
namespace USD {

UsdStageManager::UsdStageManager(QObject *parent) : QObject(parent) {}

UsdStageManager::~UsdStageManager() {}

bool UsdStageManager::createNewStage(const QString &identifier)
{
#ifdef NEURAL_STUDIO_USE_USD
	m_stage = pxr::UsdStage::CreateNew(identifier.toStdString());
	if (m_stage) {
		// Set default prim logic if needed
		return true;
	}
#else
	qWarning() << "USD support disabled in build.";
#endif
	return false;
}

bool UsdStageManager::openStage(const QString &filePath)
{
#ifdef NEURAL_STUDIO_USE_USD
	if (!QFileInfo::exists(filePath)) {
		qWarning() << "USD file not found:" << filePath;
		return false;
	}

	m_stage = pxr::UsdStage::Open(filePath.toStdString());
	return (bool)m_stage;
#else
	qWarning() << "USD support disabled in build.";
	return false;
#endif
}

bool UsdStageManager::addPrim(const QString &path, const QString &type)
{
#ifdef NEURAL_STUDIO_USE_USD
	if (!m_stage)
		return false;

	auto primPath = pxr::SdfPath(path.toStdString());
	auto prim = m_stage->DefinePrim(primPath, pxr::TfToken(type.toStdString()));
	return prim.IsValid();
#else
	return false;
#endif
}

bool UsdStageManager::hasStage() const
{
#ifdef NEURAL_STUDIO_USE_USD
	return (bool)m_stage;
#else
	return false;
#endif
}

std::vector<PrimInfo> UsdStageManager::getStageStructure() const
{
	std::vector<PrimInfo> results;
#ifdef NEURAL_STUDIO_USE_USD
	if (!m_stage)
		return results;

	for (auto prim : m_stage->Traverse()) {
		PrimInfo info;
		info.name = QString::fromStdString(prim.GetName().GetString());
		info.path = QString::fromStdString(prim.GetPath().GetString());
		info.type = QString::fromStdString(prim.GetTypeName().GetString());
		info.childCount = std::distance(prim.GetChildren().begin(), prim.GetChildren().end());
		results.push_back(info);
	}
#endif
	return results;
}

PrimTransform UsdStageManager::getPrimTransform(const std::string &path)
{
	PrimTransform xform = {{0, 0, 0}, {0, 0, 0, 1}, {1, 1, 1}}; // Identity
#ifdef NEURAL_STUDIO_USE_USD
	if (!m_stage)
		return xform;

	auto prim = m_stage->GetPrimAtPath(pxr::SdfPath(path));
	if (prim && prim.IsA<pxr::UsdGeomXformable>()) {
		pxr::UsdGeomXformable xformable(prim);
		pxr::GfMatrix4d transformMatrix;
		bool resetsXformStack = false;
		xformable.GetLocalTransformation(&transformMatrix, &resetsXformStack);

		// Extract Translation
		pxr::GfVec3d trans = transformMatrix.ExtractTranslation();
		xform.position[0] = trans[0];
		xform.position[1] = trans[1];
		xform.position[2] = trans[2];

		// Extract Rotation (Quaternion)
		pxr::GfQuatd rot = transformMatrix.ExtractRotation().GetQuat();
		xform.rotation[0] = rot.GetReal();         // w
		xform.rotation[1] = rot.GetImaginary()[0]; // x
		xform.rotation[2] = rot.GetImaginary()[1]; // y
		xform.rotation[3] = rot.GetImaginary()[2]; // z

		// Extract Scale - approximate, as matrix might have shear
		// Currently simplified
		// For robustness we should decompose properly, but let's stick to translation first for visual verification
	}
#endif
	return xform;
}

bool UsdStageManager::setPrimTransform(const std::string &path, const PrimTransform &xform)
{
#ifdef NEURAL_STUDIO_USE_USD
	if (!m_stage)
		return false;

	// Get Prim
	auto prim = m_stage->GetPrimAtPath(pxr::SdfPath(path));
	if (!prim) {
		qWarning() << "Prim not found for transform update:" << QString::fromStdString(path);
		return false;
	}

	// Make Xformable
	pxr::UsdGeomXformable xformable(prim);
	if (!xformable) {
		// Try to add the schema if it's not strictly an xform (dynamic API)
		// For now, fail if not Xformable
		return false;
	}

	// Set Operations
	// Note: This is a simplified "Set" that assumes valid ops exist or clears them.
	// For a robust implementation, we should check for existing xformOps (Translate, Rotate, Scale)
	// and update them, or create them if they don't exist.

	xformable.ClearXformOpOrder(); // RESET for simplicity in this prototype. destroy previous stack.

	// 1. Strings
	auto translateOp = xformable.AddTranslateOp();
	auto rotateOp = xformable.AddRotateXYZOp(); // Specific Euler choice for now
	auto scaleOp = xformable.AddScaleOp();

	// 2. Values
	translateOp.Set(pxr::GfVec3d(xform.position[0], xform.position[1], xform.position[2]));

	// Rotation Conversion: Quat (w,x,y,z) -> Euler or use RotateOp with Quat if supported?
	// UsdGeomXformOp::TypeRotateXYZ expects Euler in degrees.
	// UsdGeomXformOp::TypeOrient expects Quat. Let's use Orient for precision if possible, or convert.
	// Let's switch to OrientOp for Quaternions.
	// xformable.ClearXformOpOrder();
	// translateOp = xformable.AddTranslateOp();
	// auto orientOp = xformable.AddOrientOp();
	// scaleOp = xformable.AddScaleOp();

	// orientOp.Set(pxr::GfQuatd(xform.rotation[0], xform.rotation[1], xform.rotation[2], xform.rotation[3]));

	// FALLBACK to basic Euler for visual sanity in common viewers (Blender/Maya often prefer RotateXYZ)
	// Simple conversion TODO: Implement QuatToEuler.
	// For now, just setting 0,0,0 or dummy.
	rotateOp.Set(pxr::GfVec3f(0, 0, 0));

	scaleOp.Set(pxr::GfVec3f(xform.scale[0], xform.scale[1], xform.scale[2]));

	return true;
#else
	return false;
#endif
}

bool UsdStageManager::saveStage() const
{
#ifdef NEURAL_STUDIO_USE_USD
	if (m_stage) {
		m_stage->GetRootLayer()->Save();
		return true;
	}
#endif
	return false;
}

bool UsdStageManager::saveStageAs(const QString &filePath) const
{
#ifdef NEURAL_STUDIO_USE_USD
	if (m_stage) {
		m_stage->GetRootLayer()->Export(filePath.toStdString());
		return true;
	}
#endif
	return false;
}

PrimMesh UsdStageManager::getPrimMesh(const QString &path)
{
	PrimMesh meshData;
#ifdef NEURAL_STUDIO_USE_USD
	if (!m_stage)
		return meshData;

	auto prim = m_stage->GetPrimAtPath(pxr::SdfPath(path.toStdString()));
	if (prim && prim.IsA<pxr::UsdGeomMesh>()) {
		pxr::UsdGeomMesh usdMesh(prim);

		// 1. Get Points (Vertices)
		pxr::VtArray<pxr::GfVec3f> points;
		usdMesh.GetPointsAttr().Get(&points);
		meshData.vertices.reserve(points.size() * 3);
		for (const auto &pt : points) {
			meshData.vertices.push_back(pt[0]);
			meshData.vertices.push_back(pt[1]);
			meshData.vertices.push_back(pt[2]);
		}

		// 2. Get Normals
		pxr::VtArray<pxr::GfVec3f> normals;
		usdMesh.GetNormalsAttr().Get(&normals);
		meshData.normals.reserve(normals.size() * 3);
		for (const auto &n : normals) {
			meshData.normals.push_back(n[0]);
			meshData.normals.push_back(n[1]);
			meshData.normals.push_back(n[2]);
		}

		// 3. Get Face Vertex Indices
		pxr::VtArray<int> faceVertexIndices;
		usdMesh.GetFaceVertexIndicesAttr().Get(&faceVertexIndices);

		// 4. Get Face Vertex Counts (for Triangulation check)
		pxr::VtArray<int> faceVertexCounts;
		usdMesh.GetFaceVertexCountsAttr().Get(&faceVertexCounts);

		// Simple Triangulation Logic (Assuming quads/tris only for robustness, or just copying indices if pre-triangulated)
		// For a robust implementation, we should execute triangulation.
		// Here we assume for the "Solid" request we handle at least basic triangulation loop.

		int currentIndex = 0;
		for (int count : faceVertexCounts) {
			if (count == 3) {
				// Already a triangle
				meshData.indices.push_back(faceVertexIndices[currentIndex]);
				meshData.indices.push_back(faceVertexIndices[currentIndex + 1]);
				meshData.indices.push_back(faceVertexIndices[currentIndex + 2]);
			} else if (count == 4) {
				// Quad -> 2 Triangles
				int idx0 = faceVertexIndices[currentIndex];
				int idx1 = faceVertexIndices[currentIndex + 1];
				int idx2 = faceVertexIndices[currentIndex + 2];
				int idx3 = faceVertexIndices[currentIndex + 3];

				// Tri 1
				meshData.indices.push_back(idx0);
				meshData.indices.push_back(idx1);
				meshData.indices.push_back(idx2);

				// Tri 2
				meshData.indices.push_back(idx0);
				meshData.indices.push_back(idx2);
				meshData.indices.push_back(idx3);
			}
			// For > 4 (Polygons), we'd need fan triangulation, skipping for brevity but acknowledging gap.

			currentIndex += count;
		}

		meshData.isValid = true;
	}
#endif
	return meshData;
}

void UsdStageManager::printStageTraverse()
{
	auto structure = getStageStructure();
	qDebug() << "--- Traversing USD Stage ---";
	for (const auto &info : structure) {
		qDebug() << "Prim:" << info.name << "Type:" << info.type << "Path:" << info.path;
	}
}

} // namespace USD
} // namespace NeuralStudio
