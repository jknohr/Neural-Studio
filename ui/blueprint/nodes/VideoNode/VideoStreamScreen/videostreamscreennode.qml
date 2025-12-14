import QtQuick
import QtQuick.Layouts
import "../VideoStreamScreenSourceSelectorWidget"
import "../VideoFramePreviewWidget"
import "../VideoStreamConnectionStatusWidget"
import "../VideoStreamBufferingWidget"
import "../VideoStreamRecordingWidget"
import "../VideoStreamScreenSettingsWidget"

// VideoStreamScreen variant node - Screen/window capture
// Ultra-specific name: video + stream + screen + node
// Input: Screen capture APIs (X11, Wayland, Windows, macOS)

Item {
    id: root
    objectName: "videostreamscreennode"
    
    property string nodeId: ""
    property string variantType: "videostreamscreen"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top row: Screen source and connection status
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            VideoStreamScreenSourceSelectorWidget {
                id: sourceSelector
                Layout.fillWidth: true
                Layout.preferredHeight: 110
                
                onCaptureModeChanged: {
                    console.log("Capture mode:", mode)
                }
            }
            
            VideoStreamConnectionStatusWidget {
                id: connectionStatus
                Layout.preferredWidth: 250
                Layout.preferredHeight: 60
                status: "connected"
            }
        }
        
        // Screen capture preview
        VideoFramePreviewWidget {
            id: framePreview
            Layout.fillWidth: true
            Layout.preferredHeight: 350
            Layout.fillHeight: true
        }
        
        // Buffering status
        VideoStreamBufferingWidget {
            id: bufferingWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 70
        }
        
        // Recording control
        VideoStreamRecordingWidget {
            id: recordingWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 80
        }
        
        // Screen capture settings
        VideoStreamScreenSettingsWidget {
            id: settingsWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            visible: controller.showSettings || false
        }
    }
}
