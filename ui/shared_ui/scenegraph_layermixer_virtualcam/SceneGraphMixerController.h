#ifndef SCENEGRAPHMIXERCONTROLLER_H
#define SCENEGRAPHMIXERCONTROLLER_H

#pragma once
#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QTimer>
#include <QString>

namespace NeuralStudio {
namespace SceneGraph {
    class SceneGraphManager; // Forward declaration
}}

namespace NeuralStudio {
    namespace UI {

        class SceneGraphMixerController : public QObject
        {
            Q_OBJECT
            Q_PROPERTY(QVariantList rootNodes READ rootNodes NOTIFY rootNodesChanged)
            Q_PROPERTY(QVariantList layers READ layers NOTIFY layersChanged)
            Q_PROPERTY(int virtualCamStatus READ virtualCamStatus NOTIFY virtualCamStatusChanged)
            Q_PROPERTY(int stereoMode READ stereoMode WRITE setStereoMode NOTIFY stereoModeChanged)

              public:
            enum VirtualCamState {
                Disconnected,
                Connecting,
                Connected,
                Error
            };
            Q_ENUM(VirtualCamState)

            enum StereoMode {
                Mono,
                SideBySide,
                TopBottom
            };
            Q_ENUM(StereoMode)

            // NodeType enum to match backend types
            enum NodeType {
                UnknownNode,
                VideoNode,
                AudioNode,
                CameraNode,
                ThreeDModelNode,
                ImageNode,
                ScriptNode,
                MLNode,
                LLMNode,
                GraphicsNode  // General graphics
            };
            Q_ENUM(NodeType)

            explicit SceneGraphMixerController(QObject *parent = nullptr);
            ~SceneGraphMixerController() = default;

            QVariantList rootNodes() const
            {
                return m_rootNodes;
            }
            QVariantList layers() const
            {
                return m_layers;
            }
            int virtualCamStatus() const
            {
                return m_virtualCamStatus;
            }
            int stereoMode() const
            {
                return m_stereoMode;
            }
            void setStereoMode(int mode)
            {
                if (m_stereoMode != mode) {
                    m_stereoMode = mode;
                    emit stereoModeChanged();
                }
            }

            // Invokable methods for QML
            Q_INVOKABLE void setLayerOpacity(const QString &nodeId, float opacity);
            Q_INVOKABLE void setLayerZOrder(const QString &nodeId, int zIndex);
            Q_INVOKABLE void toggleLayerVisibility(const QString &nodeId);
            Q_INVOKABLE void reparentNode(const QString &childId, const QString &parentId);
            Q_INVOKABLE void toggleVirtualCam();

            // Helper
            Q_INVOKABLE QString getNodeTypeString(int typeVal) const;

            // Integration API
            void setManager(NeuralStudio::SceneGraph::SceneGraphManager *manager);
            Q_INVOKABLE void forceUpdate();  // Manual trigger from QML if needed

              signals:
            void rootNodesChanged();
            void layersChanged();
            void virtualCamStatusChanged();
            void stereoModeChanged();

              private:
            void initializeMockData();
            void updateFromBackend();  // Polling/Sync Logic

            QVariantList m_rootNodes;
            QVariantList m_layers;
            int m_virtualCamStatus = Disconnected;
            int m_stereoMode = Mono;

            // Backend Pointer
            NeuralStudio::SceneGraph::SceneGraphManager *m_manager = nullptr;
        };

    }  // namespace UI
}  // namespace NeuralStudio
