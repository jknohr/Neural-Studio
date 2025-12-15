#pragma once
#include <memory>
#include <vector>
#include <string>
#include <functional>
#include <objectbox.h>
#include <QObject>

namespace NeuralStudio {

/**
 * StateStore - ObjectBox C API wrapper for persistent state management
 * 
 * Handles:
 * - Broadcast platform settings
 * - Animation keyframes (time-series)
 * - 3D scene object state
 * - State sync across Blueprint ↔ Active frames
 */
class StateStore : public QObject {
	Q_OBJECT

public:
	explicit StateStore(QObject *parent = nullptr);
	~StateStore() override;

	// Initialize database
	bool initialize(const std::string &dbPath);
	void close();

	// === Broadcast Settings ===
	obx_id putSettings(const std::string &platform, int bitrate, const std::string &resolution, int framerate);
	bool getSettings(const std::string &platform, int &bitrate, std::string &resolution, int &framerate);

	// === Scene Objects ===
	struct SceneObjectData {
		obx_id id{0};
		std::string nodeId;
		std::string type;
		std::string name;
		float posX{0}, posY{0}, posZ{0};
		float rotX{0}, rotY{0}, rotZ{0};
		float scaleX{1}, scaleY{1}, scaleZ{1};
		bool enabled{true};
		std::string properties; // JSON
	};

	obx_id putSceneObject(const SceneObjectData &obj);
	bool getSceneObject(obx_id id, SceneObjectData &obj);
	bool getSceneObjectByNodeId(const std::string &nodeId, SceneObjectData &obj);
	std::vector<SceneObjectData> getAllSceneObjects();
	void deleteSceneObject(obx_id id);

	// === Animation Keyframes (Time-Series) ===
	struct KeyframeData {
		obx_id id{0};
		obx_id objectId;
		std::string nodeId;
		int64_t timestampMs;
		float posX, posY, posZ;
		float rotX, rotY, rotZ;
		float scaleX, scaleY, scaleZ;
		std::string interpolation{"linear"};
	};

	obx_id putKeyframe(const KeyframeData &kf);
	std::vector<KeyframeData> getKeyframesForObject(obx_id objectId, int64_t startTimeMs, int64_t endTimeMs);
	void deleteKeyframe(obx_id id);

signals:
	void sceneObjectChanged(const QString &nodeId);
	void keyframeAdded(quint64 objectId, qint64 timestamp);
	void settingsChanged(const QString &platform);

private:
	OBX_store *store_{nullptr};
	OBX_model *model_{nullptr};

	// Entity IDs
	obx_schema_id settingsEntityId_{1};
	obx_schema_id sceneObjectEntityId_{2};
	obx_schema_id keyframeEntityId_{3};

	// Property IDs for BroadcastSettings
	obx_schema_id settingsPlatformProp_{1};
	obx_schema_id settingsBitrateProp_{2};

	// Property IDs for SceneObject
	obx_schema_id sceneObjNodeIdProp_{1};
	obx_schema_id sceneObjTypeProp_{2};

	// Property IDs for AnimationKeyframe
	obx_schema_id keyframeObjIdProp_{1};
	obx_schema_id keyframeTimestampProp_{2};

	void createModel();
	bool createSettingsEntity();
	bool createSceneObjectEntity();
	bool createKeyframeEntity();
};

} // namespace NeuralStudio
