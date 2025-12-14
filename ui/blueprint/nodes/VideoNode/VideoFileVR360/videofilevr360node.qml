import QtQuick
import QtQuick.Layouts
import "../VideoFileVR360SourceSelectorWidget"
import "../VideoEquirectangularProjectionWidget"
import "../VideoPlaybackControlsWidget"
import "../VideoTimelineWidget"
import "../VideoVolumeControlWidget"
import "../VideoFileVR360SettingsWidget"

// VideoFileVR360 variant node - 360° VR video playback
// Ultra-specific name: video + file + vr360 + node
// Supports: 360° MP4, MKV (equirectangular)

Item {
    id: root
    objectName: "videofilevr360node"
    
    property string nodeId: ""
    property string variantType: "videofilevr360"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // VR360 source selector
        VideoFileVR360SourceSelectorWidget {
            id: sourceSelector
            Layout.fillWidth: true
            Layout.preferredHeight: 95
        }
        
        // 360° Equirectangular projection view
        VideoEquirectangularProjectionWidget {
            id: equirectView
            Layout.fillWidth: true
            Layout.preferredHeight: 400
            Layout.fillHeight: true
            
            onViewChanged: {
                console.log("VR360 view:", newYaw, newPitch)
            }
        }
        
        // Timeline
        VideoTimelineWidget {
            id: timeline
            Layout.fillWidth: true
            Layout.preferredHeight: 80
        }
        
        // Playback and volume controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            VideoPlaybackControlsWidget {
                id: playbackControls
                Layout.preferredWidth: 250
                Layout.preferredHeight: 60
            }
            
            VideoVolumeControlWidget {
                id: volumeControl
                Layout.fillWidth: true
                Layout.preferredHeight: 60
            }
        }
        
        // VR360 settings
        VideoFileVR360SettingsWidget {
            id: settingsWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 130
            visible: controller.showSettings || false
        }
    }
}
