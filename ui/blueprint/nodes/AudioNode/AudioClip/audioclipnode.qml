import QtQuick
import QtQuick.Layouts
import "../AudioGainLevelMeterWidget"
import "../AudioVolumeSliderWidget"
import "../AudioMuteButtonWidget"
import "../AudioClipSourceSelectorWidget"
import "../AudioClipPlaybackControlsWidget"
import "../AudioClipTimelineScrubberWidget"
import "../AudioClipSettingsWidget"

// AudioClip variant node - Generic audio file playback
// Ultra-specific name: audio + clip + node

Item {
    id: root
    objectName: "audioclipnode"
    
    // Unique identifier from controller (UUID)
    property string nodeId: ""
    
    anchors.fill: parent
    
    // Main layout
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top row: Source selector and gain meter
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            // Source file selector
            AudioClipSourceSelectorWidget {
                id: sourceSelector
                Layout.fillWidth: true
                Layout.preferredHeight: 60
            }
            
            // Gain level meter (visual feedback)
            AudioGainLevelMeterWidget {
                id: gainMeter
                Layout.preferredWidth: 80
                Layout.fillHeight: true
            }
        }
        
        // Timeline scrubber
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
        
        // Bottom row: Volume control and settings
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            // Volume slider
            AudioVolumeSliderWidget {
                id: volumeSlider
                Layout.fillWidth: true
                Layout.preferredHeight: 80
            }
            
            // Mute button
            AudioMuteButtonWidget {
                id: muteButton
                Layout.preferredWidth: 60
                Layout.preferredHeight: 60
            }
        }
        
        // Settings panel (collapsible)
        AudioClipSettingsWidget {
            id: settingsWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            visible: controller.showSettings || false
        }
    }
}
