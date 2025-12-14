import QtQuick
import QtQuick.Layouts
import "../AudioGainLevelMeterWidget"
import "../AudioVolumeSliderWidget"
import "../AudioMuteButtonWidget"
import "../AudioClipMusicSourceSelectorWidget"
import "../AudioClipPlaybackControlsWidget"
import "../AudioClipTimelineScrubberWidget"
import "../AudioClipMusicSettingsWidget"

// AudioClipMusic variant node - Music file playback with BPM/key detection
// Ultra-specific name: audio + clip + music + node

Item {
    id: root
    objectName: "audioclipmusicnode"
    
    // Unique identifier from controller (UUID)
    property string nodeId: ""
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top row: Music library selector and gain meter
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            AudioClipMusicSourceSelectorWidget {
                id: musicSourceSelector
                Layout.fillWidth: true
                Layout.preferredHeight: 60
            }
            
            AudioGainLevelMeterWidget {
                id: gainMeter
                Layout.preferredWidth: 80
                Layout.fillHeight: true
            }
        }
        
        // Timeline with loop markers for beat matching
        AudioClipTimelineScrubberWidget {
            id: timelineScrubber
            Layout.fillWidth: true
            Layout.preferredHeight: 80
        }
        
        // Playback controls
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
        
        // Music-specific settings (BPM, key, loop regions)
        AudioClipMusicSettingsWidget {
            id: musicSettings
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            visible: controller.showSettings || false
        }
    }
}
