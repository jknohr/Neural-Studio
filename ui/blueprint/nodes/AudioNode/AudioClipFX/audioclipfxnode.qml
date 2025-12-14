import QtQuick
import QtQuick.Layouts
import "../AudioGainLevelMeterWidget"
import "../AudioVolumeSliderWidget"
import "../AudioMuteButtonWidget"
import "../AudioClipFXSourceSelectorWidget"
import "../AudioClipPlaybackControlsWidget"
import "../AudioClipTimelineScrubberWidget"
import "../AudioClipFXSettingsWidget"

// AudioClipFX variant node - Sound effects playback with trigger modes
// Ultra-specific name: audio + clip + fx + node

Item {
    id: root
    objectName: "audioclipfxnode"
    
    // Unique identifier from controller (UUID)
    property string nodeId: ""
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top row: SFX library selector and gain meter
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            AudioClipFXSourceSelectorWidget {
                id: fxSourceSelector
                Layout.fillWidth: true
                Layout.preferredHeight: 60
            }
            
            AudioGainLevelMeterWidget {
                id: gainMeter
                Layout.preferredWidth: 80
                Layout.fillHeight: true
            }
        }
        
        // Timeline (for editing FX timing)
        AudioClipTimelineScrubberWidget {
            id: timelineScrubber
            Layout.fillWidth: true
            Layout.preferredHeight: 80
        }
        
        // Playback controls (trigger button highlighted)
        AudioClipPlaybackControlsWidget {
            id: playbackControls
            Layout.fillWidth: true
            Layout.preferredHeight: 60
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
        
        // FX-specific settings (trigger mode, envelope, randomization)
        AudioClipFXSettingsWidget {
            id: fxSettings
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            visible: controller.showSettings || false
        }
    }
}
