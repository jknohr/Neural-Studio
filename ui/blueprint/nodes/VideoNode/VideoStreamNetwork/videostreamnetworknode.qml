import QtQuick
import QtQuick.Layouts
import "../VideoStreamNetworkSourceSelectorWidget"
import "../VideoFramePreviewWidget"
import "../VideoStreamConnectionStatusWidget"
import "../VideoStreamBufferingWidget"
import "../VideoStreamRecordingWidget"
import "../VideoVolumeControlWidget"
import "../VideoStreamNetworkSettingsWidget"

// VideoStreamNetwork variant node - Network video stream
// Ultra-specific name: video + stream + network + node
// Input: RTSP, HTTP-FLV, HLS, WebRTC

Item {
    id: root
    objectName: "videostreamnetworknode"
    
    property string nodeId: ""
    property string variantType: "videostreamnetwork"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top row: Network URL input and connection status
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            VideoStreamNetworkSourceSelectorWidget {
                id: sourceSelector
                Layout.fillWidth: true
                Layout.preferredHeight: 110
                
                onConnectToStream: {
                    console.log("Connecting to stream:", streamUrl)
                }
            }
            
            VideoStreamConnectionStatusWidget {
                id: connectionStatus
                Layout.preferredWidth: 250
                Layout.preferredHeight: 60
            }
        }
        
        // Network stream preview
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
        
        // Recording and volume controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            VideoStreamRecordingWidget {
                id: recordingWidget
                Layout.preferredWidth: 200
                Layout.preferredHeight: 80
            }
            
            VideoVolumeControlWidget {
                id: volumeControl
                Layout.fillWidth: true
                Layout.preferredHeight: 80
            }
        }
        
        // Network stream settings
        VideoStreamNetworkSettingsWidget {
            id: settingsWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            visible: controller.showSettings || false
        }
    }
}
