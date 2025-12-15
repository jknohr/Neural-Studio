#include "StateStore.h"
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include <cstring>

namespace NeuralStudio {

StateStore::StateStore(QObject *parent) : QObject(parent) {}

StateStore::~StateStore()
{
	close();
}

void StateStore::createModel()
{
	model_ = obx_model();
	if (!model_) {
		qCritical() << "Failed to create ObjectBox model";
		return;
	}

	createSettingsEntity();
	createSceneObjectEntity();
	createKeyframeEntity();
}

bool StateStore::createSettingsEntity()
{
	// BroadcastSettings entity
	obx_model_entity(model_, "BroadcastSettings", settingsEntityId_, 0);
	obx_model_property(model_, "platform", OBXPropertyType_String, settingsPlatformProp_, 0);
	obx_model_property_flags(model_, OBXPropertyFlags_INDEXED | OBXPropertyFlags_UNIQUE);

	obx_model_property(model_, "bitrate", OBXPropertyType_Int, settingsBitrateProp_, 0);
	obx_model_property(model_, "resolution", OBXPropertyType_String, 3, 0);
	obx_model_property(model_, "framerate", OBXPropertyType_Int, 4, 0);
	obx_model_property(model_, "encoder", OBXPropertyType_String, 5, 0);

	obx_model_entity_last_property_id(model_, 5, 0);
	return true;
}

bool StateStore::createSceneObjectEntity()
{
	// SceneObject entity
	obx_model_entity(model_, "SceneObject", sceneObjectEntityId_, 0);
	obx_model_property(model_, "nodeId", OBXPropertyType_String, sceneObjNodeIdProp_, 0);
	obx_model_property_flags(model_, OBXPropertyFlags_INDEXED | OBXPropertyFlags_UNIQUE);

	obx_model_property(model_, "type", OBXPropertyType_String, sceneObjTypeProp_, 0);
	obx_model_property(model_, "name", OBXPropertyType_String, 3, 0);
	obx_model_property(model_, "posX", OBXPropertyType_Float, 4, 0);
	obx_model_property(model_, "posY", OBXPropertyType_Float, 5, 0);
	obx_model_property(model_, "posZ", OBXPropertyType_Float, 6, 0);
	obx_model_property(model_, "rotX", OBXPropertyType_Float, 7, 0);
	obx_model_property(model_, "rotY", OBXPropertyType_Float, 8, 0);
	obx_model_property(model_, "rotZ", OBXPropertyType_Float, 9, 0);
	obx_model_property(model_, "scaleX", OBXPropertyType_Float, 10, 0);
	obx_model_property(model_, "scaleY", OBXPropertyType_Float, 11, 0);
	obx_model_property(model_, "scaleZ", OBXPropertyType_Float, 12, 0);
	obx_model_property(model_, "enabled", OBXPropertyType_Bool, 13, 0);
	obx_model_property(model_, "properties", OBXPropertyType_String, 14, 0);

	obx_model_entity_last_property_id(model_, 14, 0);
	return true;
}

bool StateStore::createKeyframeEntity()
{
	// AnimationKeyframe entity
	obx_model_entity(model_, "AnimationKeyframe", keyframeEntityId_, 0);
	obx_model_property(model_, "objectId", OBXPropertyType_Long, keyframeObjIdProp_, 0);
	obx_model_property_flags(model_, OBXPropertyFlags_INDEXED);

	obx_model_property(model_, "timestampMs", OBXPropertyType_Long, keyframeTimestampProp_, 0);
	obx_model_property_flags(model_, OBXPropertyFlags_INDEXED);

	obx_model_property(model_, "nodeId", OBXPropertyType_String, 3, 0);
	obx_model_property(model_, "posX", OBXPropertyType_Float, 4, 0);
	obx_model_property(model_, "posY", OBXPropertyType_Float, 5, 0);
	obx_model_property(model_, "posZ", OBXPropertyType_Float, 6, 0);
	obx_model_property(model_, "rotX", OBXPropertyType_Float, 7, 0);
	obx_model_property(model_, "rotY", OBXPropertyType_Float, 8, 0);
	obx_model_property(model_, "rotZ", OBXPropertyType_Float, 9, 0);
	obx_model_property(model_, "scaleX", OBXPropertyType_Float, 10, 0);
	obx_model_property(model_, "scaleY", OBXPropertyType_Float, 11, 0);
	obx_model_property(model_, "scaleZ", OBXPropertyType_Float, 12, 0);
	obx_model_property(model_, "interpolation", OBXPropertyType_String, 13, 0);

	obx_model_entity_last_property_id(model_, 13, 0);
	return true;
}

bool StateStore::initialize(const std::string &dbPath)
{
	// Create directory if needed
	QDir dir;
	dir.mkpath(QString::fromStdString(dbPath));

	// Create model
	createModel();
	if (!model_) {
		return false;
	}

	// Open store
	OBX_store_options *options = obx_opt();
	obx_opt_directory(options, dbPath.c_str());
	obx_opt_model(options, model_);

	store_ = obx_store_open(options);
	if (!store_) {
		int code = obx_last_error_code();
		const char *msg = obx_last_error_message();
		qCritical() << "Failed to open ObjectBox store:" << code << msg;
		return false;
	}

	qInfo() << "ObjectBox store initialized at:" << QString::fromStdString(dbPath);
	return true;
}

void StateStore::close()
{
	if (store_) {
		obx_store_close(store_);
		store_ = nullptr;
	}
}

// === Broadcast Settings Implementation ===

obx_id StateStore::putSettings(const std::string &platform, int bitrate, const std::string &resolution, int framerate)
{
	if (!store_)
		return 0;

	flatbuffers::FlatBufferBuilder fbb(256);

	auto platformStr = fbb.CreateString(platform);
	auto resolutionStr = fbb.CreateString(resolution);

	// Simple FlatBuffer construction (manual for now)
	fbb.Finish(fbb.CreateTable());

	OBX_box *box = obx_box(store_, settingsEntityId_);
	obx_id id = obx_box_put_object(box, (void *)fbb.GetBufferPointer(), fbb.GetSize());

	emit settingsChanged(QString::fromStdString(platform));
	return id;
}

// === Scene Object Implementation ===

obx_id StateStore::putSceneObject(const SceneObjectData &obj)
{
	if (!store_)
		return 0;

	flatbuffers::FlatBufferBuilder fbb(512);

	// Build FlatBuffer for SceneObject
	auto nodeIdStr = fbb.CreateString(obj.nodeId);
	auto typeStr = fbb.CreateString(obj.type);
	auto nameStr = fbb.CreateString(obj.name);
	auto propsStr = fbb.CreateString(obj.properties);

	fbb.Finish(fbb.CreateTable());

	OBX_box *box = obx_box(store_, sceneObjectEntityId_);
	obx_id id = obx_box_put_object(box, (void *)fbb.GetBufferPointer(), fbb.GetSize());

	emit sceneObjectChanged(QString::fromStdString(obj.nodeId));
	return id;
}

std::vector<StateStore::SceneObjectData> StateStore::getAllSceneObjects()
{
	std::vector<SceneObjectData> result;
	if (!store_)
		return result;

	OBX_box *box = obx_box(store_, sceneObjectEntityId_);
	OBX_bytes_array *objects = obx_box_get_all(box);

	if (objects) {
		for (size_t i = 0; i < objects->count; ++i) {
			// TODO: Parse FlatBuffer and populate SceneObjectData
			// For now, return empty vector
		}
		obx_bytes_array_free(objects);
	}

	return result;
}

// === Animation Keyframe Implementation ===

obx_id StateStore::putKeyframe(const KeyframeData &kf)
{
	if (!store_)
		return 0;

	flatbuffers::FlatBufferBuilder fbb(256);

	auto nodeIdStr = fbb.CreateString(kf.nodeId);
	auto interpStr = fbb.CreateString(kf.interpolation);

	fbb.Finish(fbb.CreateTable());

	OBX_box *box = obx_box(store_, keyframeEntityId_);
	obx_id id = obx_box_put_object(box, (void *)fbb.GetBufferPointer(), fbb.GetSize());

	emit keyframeAdded(kf.objectId, kf.timestampMs);
	return id;
}

std::vector<StateStore::KeyframeData> StateStore::getKeyframesForObject(obx_id objectId, int64_t startTimeMs,
									int64_t endTimeMs)
{

	std::vector<KeyframeData> result;
	if (!store_)
		return result;

	OBX_box *box = obx_box(store_, keyframeEntityId_);

	// Build query: objectId == objectId AND timestampMs BETWEEN start AND end
	OBX_query_builder *qb = obx_query_builder(store_, keyframeEntityId_);
	obx_qb_int_equal(qb, keyframeObjIdProp_, objectId);
	obx_qb_int_between(qb, keyframeTimestampProp_, startTimeMs, endTimeMs);

	OBX_query *query = obx_query(qb);
	OBX_bytes_array *objects = obx_query_find(query);

	if (objects) {
		for (size_t i = 0; i < objects->count; ++i) {
			// TODO: Parse FlatBuffer and populate KeyframeData
		}
		obx_bytes_array_free(objects);
	}

	obx_query_close(query);
	return result;
}

void StateStore::deleteKeyframe(obx_id id)
{
	if (!store_)
		return;

	OBX_box *box = obx_box(store_, keyframeEntityId_);
	obx_box_remove(box, id);
}

} // namespace NeuralStudio
