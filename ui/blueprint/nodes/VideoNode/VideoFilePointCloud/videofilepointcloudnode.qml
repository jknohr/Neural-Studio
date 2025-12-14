import QtQuick
import QtQuick.Layouts
import "../VideoFilePointCloudSourceSelectorWidget"
import "../VideoPointCloudRendererWidget"
import "../VideoPlaybackControlsWidget"
import "../VideoTimelineWidget"
import "../VideoFilePointCloudSettingsWidget"

// VideoFilePointCloud variant node - Volumetric point cloud video
// Ultra-specific name: video + file + pointcloud + node
// Supports: PLY sequences, E57, LAS, custom volumetric formats

Item {
    id: root
    objectName: "videofilepointcloudnode"
    
    property string nodeId: ""
    property string variantType: "videofilepointcloud"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Point cloud source selector
        VideoFilePointCloudSourceSelectorWidget {
            id: sourceSelector
            Layout.fillWidth: true
            Layout.preferredHeight: 100
        }
        
        // Point cloud renderer (main view)
        VideoPointCloudRendererWidget {
            id: pointCloudRenderer
            Layout.fillWidth: true
            Layout.preferredHeight: 400
            Layout.fillHeight: true
        }
        
        // Timeline
        VideoTimelineWidget {
            id: timeline
            Layout.fillWidth: true
            Layout.preferredHeight: 80
        }
        
        // Playback controls
        VideoPlaybackControlsWidget {
            id: playbackControls
            Layout.fillWidth: true
            Layout.preferredHeight: 60
        }
        
        // Point cloud settings
        VideoFilePointCloudSettingsWidget {
            id: settingsWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 130
            visible: controller.showSettings || false
        }
    }
}
