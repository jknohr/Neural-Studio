import QtQuick
import QtQuick.Layouts
import "../VideoFileStereoscopicSourceSelectorWidget"
import "../VideoStereoscopicSideBySideWidget"
import "../VideoStereoscopicTopBottomWidget"
import "../VideoPlaybackControlsWidget"
import "../VideoTimelineWidget"
import "../VideoVolumeControlWidget"
import "../VideoFileStereoscopicSettingsWidget"
import "../VideoIPDAdjustmentWidget"

// VideoFileStereoscopic variant node - 3D stereoscopic video playback
// Ultra-specific name: video + file + stereoscopic + node
// Supports: SBS/TB MP4, MKV, 3D Blu-ray formats

Item {
    id: root
    objectName: "videofilestereoscopicnode"
    
    property string nodeId: ""
    property string variantType: "videofilestereoscopic"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Stereoscopic source selector
        VideoFileStereoscopicSourceSelectorWidget {
            id: sourceSelector
            Layout.fillWidth: true
            Layout.preferredHeight: 95
        }
        
        // Stereoscopic view (SBS or TB based on layout)
        VideoStereoscopicSideBySideWidget {
            id: sbsView
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            Layout.fillHeight: true
            visible: settingsWidget.stereoLayout === "sbs"
        }
        
        VideoStereoscopicTopBottomWidget {
            id: tbView
            Layout.fillWidth: true
            Layout.preferredHeight: 400
            Layout.fillHeight: true
            visible: settingsWidget.stereoLayout === "tb"
        }
        
        // Timeline
        VideoTimelineWidget {
            id: timeline
            Layout.fillWidth: true
            Layout.preferredHeight: 80
        }
        
        // Playback, volume, and IPD controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            VideoPlaybackControlsWidget {
                id: playbackControls
                Layout.preferredWidth: 200
                Layout.preferredHeight: 60
            }
            
            VideoVolumeControlWidget {
                id: volumeControl
                Layout.preferredWidth: 150
                Layout.preferredHeight: 60
            }
            
            VideoIPDAdjustmentWidget {
                id: ipdAdjustment
                Layout.fillWidth: true
                Layout.preferredHeight: 100
            }
        }
        
        // Stereoscopic settings
        VideoFileStereoscopicSettingsWidget {
            id: settingsWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 130
            visible: controller.showSettings || false
        }
    }
}
