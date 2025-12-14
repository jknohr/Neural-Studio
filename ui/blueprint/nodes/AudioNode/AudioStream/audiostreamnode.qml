import QtQuick
import QtQuick.Layouts
import "../AudioGainLevelMeterWidget"
import "../AudioVolumeSliderWidget"
import "../AudioMuteButtonWidget"
import "../AudioStreamSourceSelectorWidget"
import "../AudioStreamConnectionStatusWidget"
import "../AudioStreamInfoDisplayWidget"
import "../AudioStreamSettingsWidget"

// AudioStream variant node - Generic network audio stream capture
// Ultra-specific name: audio + stream + node

Item {
    id: root
    objectName: "audiostreamnode"
    
    // Unique identifier from controller (UUID)
    property string nodeId: ""
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top row: Stream URL input and gain meter
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            AudioStreamSourceSelectorWidget {
                id: streamSourceSelector
                Layout.fillWidth: true
                Layout.preferredHeight: 60
            }
            
            AudioGainLevelMeterWidget {
                id: gainMeter
                Layout.preferredWidth: 80
                Layout.fillHeight: true
            }
        }
        
        // Connection status and stream info
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            AudioStreamConnectionStatusWidget {
                id: connectionStatus
                Layout.fillWidth: true
                Layout.preferredHeight: 40
            }
            
            AudioStreamInfoDisplayWidget {
                id: streamInfo
                Layout.fillWidth: true
                Layout.preferredHeight: 100
            }
        }
        
        // Volume and mute
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            AudioVolumeSliderWidget {
                id: volumeSlider
                Layout.fillWidth: true
                Layout.preferredHeight: 80
            }
            
            AudioMuteButtonWidget {
                id: muteButton
                Layout.preferredWidth: 60
                Layout.preferredHeight: 60
            }
        }
        
        // Stream settings (buffer, reconnect, latency)
        AudioStreamSettingsWidget {
            id: streamSettings
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            visible: controller.showSettings || false
        }
    }
}
