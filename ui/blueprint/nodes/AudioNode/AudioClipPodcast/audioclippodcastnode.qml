import QtQuick
import QtQuick.Layouts
import "../AudioGainLevelMeterWidget"
import "../AudioVolumeSliderWidget"
import "../AudioMuteButtonWidget"
import "../AudioClipPodcastSourceSelectorWidget"
import "../AudioClipPlaybackControlsWidget"
import "../AudioClipTimelineScrubberWidget"
import "../AudioClipPodcastSettingsWidget"

// AudioClipPodcast variant node - Podcast/voice file playback with chapters
// Ultra-specific name: audio + clip + podcast + node

Item {
    id: root
    objectName: "audioclippodcastnode"
    
    // Unique identifier from controller (UUID)
    property string nodeId: ""
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top row: Podcast file selector and gain meter
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            AudioClipPodcastSourceSelectorWidget {
                id: podcastSourceSelector
                Layout.fillWidth: true
                Layout.preferredHeight: 60
            }
            
            AudioGainLevelMeterWidget {
                id: gainMeter
                Layout.preferredWidth: 80
                Layout.fillHeight: true
            }
        }
        
        // Timeline with chapter markers
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
        
        // Podcast-specific settings (chapters, resume, silence skip)
        AudioClipPodcastSettingsWidget {
            id: podcastSettings
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            visible: controller.showSettings || false
        }
    }
}
