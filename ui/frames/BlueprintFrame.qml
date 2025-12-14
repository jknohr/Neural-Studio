import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../blueprint"
import "../app"
import "../shared_ui/managers"
import "../shared_ui/scenegraph_layermixer_virtualcam"

// Blueprint Frame - Node Graph Editor Canvas with Manager Panel
Item {
    id: blueprintFrame
    
    // Expose canvas and controller for external access
    property alias canvas: blueprintCanvas
    property alias nodeGraphController: blueprintCanvas.graphController
    
    // Register with FrameContext on creation
    Component.onCompleted: {
        FrameContext.currentFrame = blueprintFrame
        FrameContext.nodeGraphController = blueprintCanvas.graphController
        FrameContext.isBlueprintMode = true
    }
    
    // Main layout: Manager Panel + Canvas
    RowLayout {
        anchors.fill: parent
        spacing: 0
        
        // Manager Panel Dock (left side, collapsible)
        Rectangle {
            id: managerDock
            Layout.preferredWidth: FrameContext.activeManagerPanel !== "" ? 320 : 48
            Layout.fillHeight: true
            color: "#1a1a1a"
            
            Behavior on Layout.preferredWidth {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }
            
            // Manager selector (always visible)
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                
                // Manager type buttons (vertical toolbar)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: managerButtons.implicitHeight + 16
                    color: "#252525"
                    
                    Flow {
                        id: managerButtons
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        
                        Repeater {
                            model: FrameContext.managerTypes
                            
                            ToolButton {
                                width: 36
                                height: 36
                                
                                MaterialIcon {
                                    anchors.centerIn: parent
                                    icon: modelData.icon
                                    size: 20
                                    color: FrameContext.activeManagerPanel === modelData.name ? "#4a9eff" : "#888"
                                }
                                
                                ToolTip.visible: hovered
                                ToolTip.text: modelData.title
                                
                                onClicked: FrameContext.toggleManagerPanel(modelData.name)
                            }
                        }
                    }
                }
                
                // Manager panel content (shows when a manager is selected)
                Loader {
                    id: managerPanelLoader
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: FrameContext.activeManagerPanel !== ""
                    
                    source: {
                        switch (FrameContext.activeManagerPanel) {
                            case "video": return "../shared_ui/managers/VideoManager/VideoManager.qml"
                            case "audio": return "../shared_ui/managers/AudioManager/AudioManager.qml"
                            case "camera": return "../shared_ui/managers/CameraManager/CameraManager.qml"
                            case "3d": return "../shared_ui/managers/ThreeDAssetsManager/ThreeDAssetsManager.qml"
                            case "effects": return "../shared_ui/managers/EffectsManager/EffectsManager.qml"
                            case "shader": return "../shared_ui/managers/ShaderManager/ShaderManager.qml"
                            case "ml": return "../shared_ui/managers/MLManager/MLManager.qml"
                            case "llm": return "../shared_ui/managers/LLMManager/LLMManager.qml"
                            case "script": return "../shared_ui/managers/ScriptManager/ScriptManager.qml"
                            default: return ""
                        }
                    }
                    
                    onLoaded: {
                        if (item && item.controller) {
                            item.controller.graphController = blueprintCanvas.graphController
                        }
                    }
                }
            }
        }
        
        // Separator
        Rectangle {
            Layout.preferredWidth: 1
            Layout.fillHeight: true
            color: "#333"
        }
        
        // Main Blueprint Canvas
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            BlueprintCanvas {
                id: blueprintCanvas
                anchors.fill: parent
            }
            
            // SceneGraph Preview - 3D viewport showing composed scene
            SceneGraphPreview {
                id: scenePreview
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 16
                z: 100
                
                // Start smaller, user can resize
                width: 400
                height: 225
                
                activeLayerCount: blueprintCanvas.graphController ? 
                    blueprintCanvas.graphController.nodeCount : 0
                
                onToggleExpand: {
                    // Toggle between compact and full view
                    if (isExpanded) {
                        width = 400
                        height = 225
                    } else {
                        width = parent.width * 0.7
                        height = parent.height * 0.5
                    }
                    isExpanded = !isExpanded
                }
                onToggleStream: {
                    isStreaming = !isStreaming
                }
                onToggleRecord: {
                    isRecording = !isRecording
                }
            }
        }
    }
}
