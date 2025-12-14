import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../app"
import "../activeui/preview"
import "../activeui/panels"
import "../activeui/controls"
import "../activeui/monitors"

// Active Frame - OBS-style live monitoring and streaming view
// Composed of modular widgets from ui/activeui/
Item {
    id: activeFrame
    
    // State properties
    property bool isStreaming: false
    property bool isRecording: false
    property bool isVirtualCamActive: false
    property string selectedSource: ""
    
    // Floating preview windows
    property var floatingPreviews: ListModel {}
    
    // Mock data - will come from controllers
    property var sceneModel: ["Scene"]
    property var sourceModel: [
        { name: "Video Capture Device (V4L2) 2", visible: true, locked: false },
        { name: "Video Capture Device (V4L2)", visible: true, locked: false }
    ]
    property var audioChannels: [
        { name: "Desktop Audio", levelL: 0.7, levelR: 0.65, muted: false },
        { name: "Mic/Aux", levelL: 0.4, levelR: 0.35, muted: false }
    ]
    
    // Register with FrameContext
    Component.onCompleted: {
        FrameContext.currentFrame = activeFrame
        FrameContext.isBlueprintMode = false
    }
    
    // Background
    Rectangle {
        anchors.fill: parent
        color: "#1e1e1e"
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // ========== MAIN PREVIEW AREA ==========
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 200
            
            // Centered main preview (16:9)
            MainPreview {
                id: mainPreview
                anchors.centerIn: parent
                width: Math.min(parent.width - 40, (parent.height - 40) * 16 / 9)
                height: width * 9 / 16
                
                isRecording: activeFrame.isRecording
                isStreaming: activeFrame.isStreaming
            }
            
            // Floating source preview windows
            Repeater {
                model: floatingPreviews
                
                FloatingPreviewWindow {
                    sourceId: model.sourceId
                    sourceName: model.sourceName
                    x: model.x
                    y: model.y
                    width: model.width || 200
                    height: model.height || 120
                    
                    onCloseRequested: floatingPreviews.remove(index)
                }
            }
        }
        
        // ========== SOURCE TOOLBAR ==========
        SourceToolbar {
            Layout.fillWidth: true
            selectedSourceName: selectedSource
            
            onPropertiesClicked: console.log("Open properties for", selectedSource)
            onFiltersClicked: console.log("Open filters for", selectedSource)
        }
        
        // ========== BOTTOM DOCK PANELS ==========
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            color: "#2a2a2a"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 4
                
                // Scenes
                ScenesPanel {
                    Layout.preferredWidth: 180
                    Layout.fillHeight: true
                    sceneModel: activeFrame.sceneModel
                    
                    onSceneSelected: (index) => console.log("Scene selected:", index)
                    onAddScene: console.log("Add scene")
                    onRemoveScene: console.log("Remove scene")
                }
                
                // Sources
                SourcesPanel {
                    Layout.preferredWidth: 220
                    Layout.fillHeight: true
                    sourceModel: activeFrame.sourceModel
                    
                    onSourceSelected: (index) => {
                        selectedSource = sourceModel[index].name
                    }
                    onToggleVisibility: (index) => {
                        sourceModel[index].visible = !sourceModel[index].visible
                        sourceModelChanged()
                    }
                    onAddSource: console.log("Add source")
                    onRemoveSource: console.log("Remove source")
                }
                
                // Audio Mixer
                AudioMixerPanel {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    channelModel: activeFrame.audioChannels
                    
                    onChannelMuteToggled: (index) => {
                        audioChannels[index].muted = !audioChannels[index].muted
                        audioChannelsChanged()
                    }
                }
                
                // Transitions
                TransitionsPanel {
                    Layout.preferredWidth: 160
                    Layout.fillHeight: true
                    
                    onTransitionChanged: (type) => console.log("Transition:", type)
                    onDurationChanged: (ms) => console.log("Duration:", ms, "ms")
                }
                
                // Controls
                ControlsPanel {
                    Layout.preferredWidth: 160
                    Layout.fillHeight: true
                    
                    isStreaming: activeFrame.isStreaming
                    isRecording: activeFrame.isRecording
                    isVirtualCamActive: activeFrame.isVirtualCamActive
                    
                    onToggleStream: activeFrame.isStreaming = !activeFrame.isStreaming
                    onToggleRecord: activeFrame.isRecording = !activeFrame.isRecording
                    onToggleVirtualCam: activeFrame.isVirtualCamActive = !activeFrame.isVirtualCamActive
                    onOpenSettings: console.log("Open settings")
                }
            }
        }
        
        // ========== STATUS BAR ==========
        StatusBar {
            Layout.fillWidth: true
            
            cpuUsage: 2.7
            elapsedTime: "00:00:00"
            fps: 30.50
            targetFps: 30.0
            isRecording: activeFrame.isRecording
            isStreaming: activeFrame.isStreaming
        }
    }
    
    // Add floating preview helper
    function addFloatingPreview(sourceId, sourceName, x, y) {
        floatingPreviews.append({
            sourceId: sourceId,
            sourceName: sourceName,
            x: x || 50,
            y: y || 50,
            width: 200,
            height: 120
        })
    }
}
