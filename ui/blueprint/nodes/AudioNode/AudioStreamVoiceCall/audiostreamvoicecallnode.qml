import QtQuick
import QtQuick.Layouts
import "../AudioGainLevelMeterWidget"
import "../AudioVolumeSliderWidget"
import "../AudioMuteButtonWidget"
import "../AudioStreamVoiceCallSourceSelectorWidget"
import "../AudioStreamConnectionStatusWidget"
import "../AudioStreamInfoDisplayWidget"
import "../AudioStreamVoiceCallSettingsWidget"

// AudioStreamVoiceCall variant node - Real-time voice stream (microphone, VoIP)
// Ultra-specific name: audio + stream + voicecall + node

Item {
    id: root
    objectName: "audiostreamvoicecallnode"
    
    // Unique identifier from controller (UUID)
    property string nodeId: ""
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top row: Mic/VoIP selector and gain meter
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            AudioStreamVoiceCallSourceSelectorWidget {
                id: voiceCallSourceSelector
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
        
        // Voice call settings (noise gate, PTT, voice activity, device selector)
        AudioStreamVoiceCallSettingsWidget {
            id: voiceCallSettings
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            visible: controller.showSettings || false
        }
    }
}
