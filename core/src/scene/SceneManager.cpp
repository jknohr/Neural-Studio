#include "SceneManager.h"
#include "../usd_manager/UsdStageManager.h"
#include <algorithm>

namespace neural_studio {

SceneManager::SceneManager()
{
	m_usdManager = new NeuralStudio::USD::UsdStageManager();
}

SceneManager::~SceneManager()
{
	delete m_usdManager;
}

uint32_t SceneManager::AddNode(const Transform &transform)
{
	return AddMeshNode(transform, 0);
}

uint32_t SceneManager::AddMeshNode(const Transform &transform, uint32_t mesh_id)
{
	return AddVideoNode(transform, mesh_id, 0);
}

uint32_t SceneManager::AddVideoNode(const Transform &transform, uint32_t mesh_id, uint32_t texture_id)
{
	// Delegate to string-based AddVideoNode with empty string (no storage)
	// Or simpler: Just keep existing logic for internal calls
	std::lock_guard<std::mutex> lock(nodes_mutex);
	uint32_t id = next_id++;
	SceneNode node;
	node.id = id;
	node.transform = transform;
	node.mesh_id = mesh_id;
	node.material_id = 0;
	node.texture_id = texture_id;
	nodes.push_back(node);
	return id;
}

uint32_t SceneManager::AddNode(const std::string &externalId, const Transform &transform)
{
	return AddMeshNode(externalId, transform, 0);
}

uint32_t SceneManager::AddMeshNode(const std::string &externalId, const Transform &transform, uint32_t mesh_id)
{
	return AddVideoNode(externalId, transform, mesh_id, 0);
}

uint32_t SceneManager::AddVideoNode(const std::string &externalId, const Transform &transform, uint32_t mesh_id,
				    uint32_t texture_id)
{
	std::lock_guard<std::mutex> lock(nodes_mutex);

	// Check if ID already exists
	if (m_externalIdMap.find(externalId) != m_externalIdMap.end()) {
		// Log warning or return existing ID
		return m_externalIdMap[externalId];
	}

	uint32_t id = next_id++;
	SceneNode node;
	node.id = id;
	node.externalId = externalId; // Store key
	node.transform = transform;
	node.mesh_id = mesh_id;
	node.material_id = 0;
	node.texture_id = texture_id;
	nodes.push_back(node);

	// Store mapping
	m_externalIdMap[externalId] = id;

	return id;
}

uint32_t SceneManager::GetNodeId(const std::string &externalId) const
{
	std::lock_guard<std::mutex> lock(nodes_mutex);
	auto it = m_externalIdMap.find(externalId);
	if (it != m_externalIdMap.end()) {
		return it->second;
	}
	return 0; // 0 is invalid ID
}

void SceneManager::RemoveNode(const std::string &externalId)
{
	uint32_t id = 0;
	{
		std::lock_guard<std::mutex> lock(nodes_mutex);
		auto it = m_externalIdMap.find(externalId);
		if (it != m_externalIdMap.end()) {
			id = it->second;
			m_externalIdMap.erase(it);
		}
	}

	if (id != 0) {
		RemoveNode(id);
	}
}

void SceneManager::RemoveNode(uint32_t id)
{
	std::lock_guard<std::mutex> lock(nodes_mutex);
	nodes.erase(std::remove_if(nodes.begin(), nodes.end(), [id](const SceneNode &node) { return node.id == id; }),
		    nodes.end());
}

void SceneManager::SetTransform(uint32_t id, const Transform &transform)
{
	std::lock_guard<std::mutex> lock(nodes_mutex);
	for (auto &node : nodes) {
		if (node.id == id) {
			node.transform = transform;

			// Sync with USD
			if (!node.externalId.empty() && m_usdManager) {
				// Convert Transform to PrimTransform
				NeuralStudio::USD::PrimTransform pt;
				pt.position[0] = transform.position[0];
				pt.position[1] = transform.position[1];
				pt.position[2] = transform.position[2];

				pt.rotation[0] = transform.rotation[0]; // w
				pt.rotation[1] = transform.rotation[1]; // x
				pt.rotation[2] = transform.rotation[2]; // y
				pt.rotation[3] =
					transform.rotation
						[3]; // z (Note: Need to check if this matches USD expectations, previously I wrote dummy euler)

				pt.scale[0] = transform.scale[0];
				pt.scale[1] = transform.scale[1];
				pt.scale[2] = transform.scale[2];

				m_usdManager->setPrimTransform(node.externalId, pt);
			}
			break;
		}
	}
}

void SceneManager::SetSemantics(uint32_t id, const SemanticData &data)
{
	std::lock_guard<std::mutex> lock(nodes_mutex);
	for (auto &node : nodes) {
		if (node.id == id) {
			node.semantics = data;
			break;
		}
	}
}

const std::vector<SceneNode> &SceneManager::GetNodes() const
{
	return nodes;
}

uint32_t SceneManager::AddMesh(const Mesh &mesh)
{
	std::lock_guard<std::mutex> lock(nodes_mutex);
	uint32_t id = next_mesh_id++;
	Mesh m = mesh;
	m.id = id;
	meshes.push_back(m);
	return id;
}

const Mesh *SceneManager::GetMesh(uint32_t id) const
{
	// Linear search for now, verify perf later
	// In real engine use map
	for (const auto &m : meshes) {
		if (m.id == id)
			return &m;
	}
	return nullptr;
}

uint32_t SceneManager::AddMaterial(const Material &material)
{
	std::lock_guard<std::mutex> lock(nodes_mutex);
	uint32_t id = next_material_id++;
	Material m = material;
	m.id = id;
	materials.push_back(m);
	return id;
}

const Material *SceneManager::GetMaterial(uint32_t id) const
{
	for (const auto &m : materials) {
		if (m.id == id)
			return &m;
	}
	return nullptr;
}

uint32_t SceneManager::AddLight(const Light &light)
{
	std::lock_guard<std::mutex> lock(nodes_mutex);
	uint32_t id = next_light_id++;
	Light l = light;
	l.id = id;
	lights.push_back(l);
	return id;
}

const std::vector<Light> &SceneManager::GetLights() const
{
	return lights;
}

void SceneManager::AddRelation(uint32_t sourceId, uint32_t targetId, RelationType type, float weight)
{
	std::lock_guard<std::mutex> lock(nodes_mutex);
	SemanticEdge edge{sourceId, targetId, type, weight};
	edges.push_back(edge);
}

const std::vector<SemanticEdge> &SceneManager::GetRelations() const
{
	return edges;
}

bool SceneManager::OpenUsdStage(const std::string &filePath)
{
	if (m_usdManager) {
		if (m_usdManager->openStage(QString::fromStdString(filePath))) {
			// Mapping Logic: Retrieve structure and populate SceneNodes
			auto prims = m_usdManager->getStageStructure();

			// Clear existing logical nodes created from previous stage?
			// For now, we append.

			for (const auto &prim : prims) {
				// Determine Type Mapping
				// UsdGeomMesh -> MeshNode
				// UsdLuxLight -> LightNode
				// UsdGeomCamera ->                // For this pass, we just create a logical node representation
				// In a full implementation, we would extract the transform and data
				Transform transform;
				auto usdXform = m_usdManager->getPrimTransform(prim.path.toStdString());

				transform.position[0] = static_cast<float>(usdXform.position[0]);
				transform.position[1] = static_cast<float>(usdXform.position[1]);
				transform.position[2] = static_cast<float>(usdXform.position[2]);

				transform.rotation[0] = static_cast<float>(usdXform.rotation[0]); // w
				transform.rotation[1] = static_cast<float>(usdXform.rotation[1]); // x
				transform.rotation[2] = static_cast<float>(usdXform.rotation[2]); // y
				transform.rotation[3] = static_cast<float>(usdXform.rotation[3]);
				std::fill_n(transform.scale, 3, 1.0f); // Default scale

				uint32_t meshId = 0;
				// Check if it is a Mesh
				if (prim.type == "Mesh") {
					auto meshData = m_usdManager->getPrimMesh(prim.path);
					if (meshData.isValid) {
						Mesh newMesh;
						newMesh.name = prim.name.toStdString();

						// Convert Flat Vectors to LibVR Structs
						for (size_t i = 0; i < meshData.vertices.size(); i += 3) {
							Vertex v;
							v.position[0] = meshData.vertices[i];
							v.position[1] = meshData.vertices[i + 1];
							v.position[2] = meshData.vertices[i + 2];

							// Naive Normal mapping (if exists)
							if (i < meshData.normals.size()) {
								v.normal[0] = meshData.normals[i];
								v.normal[1] = meshData.normals[i + 1];
								v.normal[2] = meshData.normals[i + 2];
							} else {
								v.normal[0] = 0;
								v.normal[1] = 1;
								v.normal[2] = 0;
							}
							v.uv[0] = 0;
							v.uv[1] = 0; // Placeholder UVs
							newMesh.vertices.push_back(v);
						}

						// Indices
						for (auto idx : meshData.indices) {
							newMesh.indices.push_back(idx);
						}

						meshId = AddMesh(newMesh);
					}
				}

				// Use the Prim Path as the External ID (convert QString to std::string)
				std::string primPathStr = prim.path.toStdString();
				if (meshId > 0) {
					AddMeshNode(primPathStr, transform, meshId);
				} else {
					AddNode(primPathStr, transform);
				}
			}
			return true;
		}
	}
	return false;
}

} // namespace neural_studio
