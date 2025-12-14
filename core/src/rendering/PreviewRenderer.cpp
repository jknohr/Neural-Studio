#include "PreviewRenderer.h"
#include "ShimQRhi.h"
#include "VulkanRenderer.h"
#include <QDebug>

namespace NeuralStudio {
namespace Rendering {

PreviewRenderer::PreviewRenderer(VulkanRenderer *renderer, QObject *parent) : QObject(parent), m_renderer(renderer) {}

PreviewRenderer::~PreviewRenderer()
{
	releasePreviewResources();
}

bool PreviewRenderer::initialize(const PreviewConfig &config)
{
	if (m_initialized) {
		qWarning() << "PreviewRenderer already initialized";
		return true;
	}

	if (!m_renderer || !m_renderer->rhi()) {
		qCritical() << "Invalid VulkanRenderer";
		return false;
	}

	m_config = config;

	// Detect display type
	m_displayType = detectDisplayType();

	// Create preview resources
	createPreviewResources();

	m_initialized = true;
	qInfo() << "PreviewRenderer initialized";
	qInfo() << "  Resolution:" << m_config.width << "x" << m_config.height;
	qInfo() << "  Display:" << (m_displayType == DisplayType::DesktopMonitor ? "Desktop Monitor" : "VR Headset");
	qInfo() << "  Mode:"
		<< (m_config.mode == PreviewMode::Auto        ? "Auto"
		    : m_config.mode == PreviewMode::Desktop2D ? "Desktop 2D"
							      : "VR Stereo");

	return true;
}

void PreviewRenderer::renderPreview(QRhiTexture *leftEye, QRhiTexture *rightEye)
{
	if (!m_initialized || !leftEye) {
		return;
	}

	// Resolve preview mode (Auto → Desktop2D or VRStereo)
	PreviewMode actualMode = resolvePreviewMode();

	// Render based on resolved mode
	switch (actualMode) {
	case PreviewMode::Desktop2D:
		renderDesktop2D(leftEye); // Single 2D stream from left eye
		break;

	case PreviewMode::VRStereo:
		if (rightEye) {
			renderVRStereo(leftEye, rightEye); // True VR stereo
		} else {
			renderDesktop2D(leftEye); // Fallback to 2D if no right eye
		}
		break;

	case PreviewMode::Auto:
		// Should never reach here (resolved above)
		renderDesktop2D(leftEye);
		break;
	}

	emit previewRendered();
}

void PreviewRenderer::setPreviewMode(PreviewMode mode)
{
	if (m_config.mode != mode) {
		m_config.mode = mode;
		qInfo() << "Preview mode changed to:" << static_cast<int>(mode);
	}
}

bool PreviewRenderer::resize(uint32_t width, uint32_t height)
{
	if (m_config.width == width && m_config.height == height) {
		return true; // No change
	}

	m_config.width = width;
	m_config.height = height;

	// Recreate resources with new resolution
	if (m_initialized) {
		releasePreviewResources();
		createPreviewResources();
		qInfo() << "Preview resized to" << width << "x" << height;
	}

	return true;
}

void PreviewRenderer::createPreviewResources()
{
	qWarning() << "PreviewRenderer::createPreviewResources stubbed (RHI missing)";
}

void PreviewRenderer::releasePreviewResources()
{
	m_pipeline.reset();
	m_bindings.reset();
	m_previewPass.reset();
	m_previewTarget.reset();
	m_previewTexture.reset();
}

PreviewRenderer::DisplayType PreviewRenderer::detectDisplayType()
{
	// TODO: Implement actual OpenXR detection
	// For now, check if OpenXR runtime is available and VR HMD is connected

	// Placeholder logic:
	// 1. Check for OpenXR runtime
	// 2. Query connected displays
	// 3. If VR HMD detected → VRHeadset
	// 4. Otherwise → DesktopMonitor

	// Default to desktop for now
	return DisplayType::DesktopMonitor;
}

PreviewRenderer::PreviewMode PreviewRenderer::resolvePreviewMode()
{
	if (m_config.mode != PreviewMode::Auto) {
		return m_config.mode; // Use explicit mode
	}

	// Auto mode: choose based on detected display
	if (m_displayType == DisplayType::VRHeadset) {
		return PreviewMode::VRStereo;
	} else {
		return PreviewMode::Desktop2D;
	}
}

void PreviewRenderer::renderDesktop2D(QRhiTexture *leftEye)
{
	if (!m_initialized)
		return;
	qDebug() << "Rendering Desktop 2D preview (Stubbed)";
}

bool PreviewRenderer::isSBSTexture(QRhiTexture *texture)
{
	if (!texture)
		return false;

	// Detect SBS format by aspect ratio (resolution-agnostic)
	// SBS has ~2:1 aspect ratio regardless of resolution
	// Examples: 3840x2160, 1920x1080, 7680x4320, etc.
	QSize size = texture->pixelSize();
	float aspectRatio = static_cast<float>(size.width()) / static_cast<float>(size.height());

	// Check for 2:1 aspect ratio (allow 5% tolerance)
	// This works for ANY resolution SBS stream
	if (aspectRatio > 1.9f && aspectRatio < 2.1f) {
		return true; // Likely SBS format
	}

	return false;
}

void PreviewRenderer::extractLeftEyeFromSBS(QRhiTexture *sbsInput, QRhiTexture *leftOutput)
{
	QRhi *rhi = m_renderer->rhi();
	if (!rhi || !sbsInput || !leftOutput)
		return;

	// Extract left half of SBS texture
	// TODO: Implement with shader
	// Fragment shader samples from UV.x * 0.5 (left half only)
	// This gives a clean 2D view without the confusing SBS format

	qDebug() << "Extracting left eye from SBS input";
}

void PreviewRenderer::renderVRStereo(QRhiTexture *leftEye, QRhiTexture *rightEye)
{
	QRhi *rhi = m_renderer->rhi();
	if (!rhi || !m_previewTarget)
		return;

	// Render true VR stereo to connected VR headset
	// NOT side-by-side - actual dual-eye VR rendering via OpenXR
	// TODO: Implement OpenXR layer submission
	// 1. Submit left eye texture to OpenXR layer 0
	// 2. Submit right eye texture to OpenXR layer 1
	// 3. Let OpenXR runtime composite to VR HMD

	qDebug() << "Rendering VR Stereo preview (true 3D to VR headset)";
}

} // namespace Rendering
} // namespace NeuralStudio
