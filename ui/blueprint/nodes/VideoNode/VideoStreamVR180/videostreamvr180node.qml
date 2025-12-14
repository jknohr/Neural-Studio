import QtQuick
import QtQuick.Layouts
import "../VideoStreamVR180SourceSelectorWidget"
import "../VideoStereoscopicSideBySideWidget"
import "../VideoStreamConnectionStatusWidget"
import "../VideoStreamBufferingWidget"
import "../VideoStreamRecordingWidget"
import "../VideoVolumeControlWidget"
import "../VideoStreamVR180SettingsWidget"
import "../VideoIPDAdjustmentWidget"

// VideoStreamVR180 variant node - 180° VR live stream
// Ultra-specific name: video + stream + vr180 + node
// Input: Stereo camera pairs, VR180 cameras

Item {
    id: root
    objectName: "videostreamvr180node"
    
    property string nodeId: ""
    property string variantType: "videostreamvr180"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top row: Dual camera source and connection status
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            VideoStreamVR180SourceSelectorWidget {
                id: sourceSelector
                Layout.fillWidth: true
                Layout.preferredHeight: 115
                
                onCamerasSelected: {
                    console.log("VR180 cameras:", left, right)
                }
            }
            
            VideoStreamConnectionStatusWidget {
                id: connectionStatus
                Layout.preferredWidth: 250
                Layout.preferredHeight: 60
                status: sourceSelector.synchronized ? "connected" : "connecting"
            }
        }
        
        // Side-by-side stereo preview
        VideoStereoscopicSideBySideWidget {
            id: stereoView
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            Layout.fillHeight: true
        }
        
        // Buffering status
        VideoStreamBufferingWidget {
            id: bufferingWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 70
        }
        
        // Recording, volume, and IPD controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            VideoStreamRecordingWidget {
                id: recordingWidget
                Layout.preferredWidth: 150
                Layout.preferredHeight: 80
            }
            
            VideoVolumeControlWidget {
                id: volumeControl
                Layout.preferredWidth: 150
                Layout.preferredHeight: 80
            }
            
            VideoIPDAdjustmentWidget {
                id: ipdAdjustment
                Layout.fillWidth: true
                Layout.preferredHeight: 100
            }
        }
        
        // VR180 stream settings
        VideoStreamVR180SettingsWidget {
            id: settingsWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            visible: controller.showSettings || false
        }
    }
}
