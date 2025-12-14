import QtQuick
import QtQuick.Layouts
import "../VideoStreamCameraSourceSelectorWidget"
import "../VideoFramePreviewWidget"
import "../VideoStreamConnectionStatusWidget"
import "../VideoStreamBufferingWidget"
import "../VideoStreamRecordingWidget"
import "../VideoCameraControlsWidget"
import "../VideoVolumeControlWidget"
import "../VideoStreamCameraSettingsWidget"

// VideoStreamCamera variant node - Live camera capture
// Ultra-specific name: video + stream + camera + node
// Input: V4L2, DirectShow, AVFoundation, custom drivers

Item {
    id: root
    objectName: "videostreamcameranode"
    
    property string nodeId: ""
    property string variantType: "videostreamcamera"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top row: Camera source and connection status
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            VideoStreamCameraSourceSelectorWidget {
                id: sourceSelector
                Layout.fillWidth: true
                Layout.preferredHeight: 75
                
                onDeviceSelected: {
                    console.log("Camera selected:", deviceId)
                }
            }
            
            VideoStreamConnectionStatusWidget {
                id: connectionStatus
                Layout.preferredWidth: 250
                Layout.preferredHeight: 60
                status: "connected"
            }
        }
        
        // Main content row: Preview and PTZ controls
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            
            // Live camera preview
            VideoFramePreviewWidget {
                id: framePreview
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                Layout.fillHeight: true
            }
            
            // PTZ camera controls (if supported)
            VideoCameraControlsWidget {
                id: cameraControls
                Layout.preferredWidth: 150
                Layout.fillHeight: true
                visible: cameraControls.isPTZ
            }
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
        
        // Camera settings
        VideoStreamCameraSettingsWidget {
            id: settingsWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            visible: controller.showSettings || false
        }
    }
}
