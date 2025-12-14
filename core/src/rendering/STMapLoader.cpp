#include "STMapLoader.h"
#include "ShimQRhi.h" // Parsing Fix
#include <QImage>
#include <QFile>
#include <QDebug>

namespace NeuralStudio {
namespace Rendering {

STMapLoader::STMapLoader(QRhi *rhi, QObject *parent) : QObject(parent), m_rhi(rhi) {}

STMapLoader::~STMapLoader()
{
	// unloadAll(); // Stubbed to avoid iterator issues if definition incomplete in vector?
	// Actually map should be fine.
	unloadAll();
}

bool STMapLoader::loadSTMap(const QString &path, const QString &id)
{
	// STUBBED: RHI Missing
	qWarning() << "STMapLoader: Stubbed (RHI missing). Cannot load" << path;
	emit loadError(path, "RHI Missing");
	return false;
}

QRhiTexture *STMapLoader::getSTMap(const QString &id)
{
	auto it = m_stmaps.find(id);
	if (it != m_stmaps.end()) {
		return it->second.texture.get();
	}
	return nullptr;
}

void STMapLoader::unloadSTMap(const QString &id)
{
	auto it = m_stmaps.find(id);
	if (it != m_stmaps.end()) {
		qInfo() << "Unloaded STMap:" << id;
		m_stmaps.erase(it);
		emit stmapUnloaded(id);
	}
}

void STMapLoader::unloadAll()
{
	for (const auto &pair : m_stmaps) {
		emit stmapUnloaded(pair.first);
	}
	m_stmaps.clear();
	qInfo() << "Unloaded all STMaps";
}

bool STMapLoader::isLoaded(const QString &id) const
{
	return m_stmaps.find(id) != m_stmaps.end();
}

} // namespace Rendering
} // namespace NeuralStudio
