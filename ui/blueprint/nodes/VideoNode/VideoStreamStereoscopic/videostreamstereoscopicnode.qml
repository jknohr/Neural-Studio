import QtQuick
import QtQuick.Layouts
import "../VideoStreamStereoscopicSourceSelectorWidget"
import "../VideoStereoscopicSideBySideWidget"
import "../VideoStereoscopicTopBottomWidget"
import "../VideoStreamConnectionStatusWidget"
import "../VideoStreamBufferingWidget"
import "../VideoStreamRecordingWidget"
import "../VideoVolumeControlWidget"
import "../VideoStreamStereoscopicSettingsWidget"
import "../VideoIPDAdjustmentWidget"

// VideoStreamStereoscopic variant node - Live 3D stereoscopic stream
// Ultra-specific name: video + stream + stereoscopic + node
// Input: Dual webcams, stereo camera rigs, depth cameras

Item {
    id: root
    objectName: "videostreamstereoscopicnode"
    
    property string nodeId: ""
    property string variantType: "videostreamstereoscopic"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top row: Dual camera source and connection status
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            VideoStreamStereoscopicSourceSelectorWidget {
                id: sourceSelector
                Layout.fillWidth: true
                Layout.preferredHeight: 130
                
                onCamerasSelected: {
                    console.log("Stereo cameras:", left, right)
                }
            }
            
            VideoStreamConnectionStatusWidget {
                id: connectionStatus
                Layout.preferredWidth: 250
                Layout.preferredHeight: 60
                status: sourceSelector.hardwareSync ? "connected" : "connecting"
            }
        }
        
        // Stereoscopic view (SBS by default, can switch to TB)
        VideoStereoscopicSideBySideWidget {
            id: sbsView
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            Layout.fillHeight: true
            visible: !settingsWidget.eyeSwap  // Simple toggle for demo
        }
        
        VideoStereoscopicTopBottomWidget {
            id: tbView
            Layout.fillWidth: true
            Layout.preferredHeight: 400
            Layout.fillHeight: true
            visible: settingsWidget.eyeSwap  // Simple toggle for demo
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
                
                onIpdChanged: {
                    console.log("IPD adjusted:", newIPD)
                }
            }
        }
        
        // Stereoscopic stream settings
        VideoStreamStereoscopicSettingsWidget {
            id: settingsWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 130
            visible: controller.showSettings || false
        }
    }
}
