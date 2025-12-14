import QtQuick
import QtQuick.Layouts
import "../VideoFileCinematicSourceSelectorWidget"
import "../VideoFramePreviewWidget"
import "../VideoPlaybackControlsWidget"
import "../VideoTimelineWidget"
import "../VideoFrameSeekerWidget"
import "../VideoVolumeControlWidget"
import "../VideoFormatInfoWidget"
import "../VideoFileCinematicSettingsWidget"
import "../VideoColorGradingWidget"
import "../VideoKeyframeWidget"

// VideoFileCinematic variant node - Cinema/Film production video
// Ultra-specific name: video + file + cinematic + node
// Supports: ProRes, DNxHD, CinemaDNG, LOG formats, HDR content

Item {
    id: root
    objectName: "videofilecinematicnode"
    
    property string nodeId: ""
    property string variantType: "videofilecinematic"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top row: Cinema source selector and format info
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            VideoFileCinematicSourceSelectorWidget {
                id: sourceSelector
                Layout.fillWidth: true
                Layout.preferredHeight: 90
                
                onFileSelected: {
                    console.log("Cinema file selected:", filePath)
                }
            }
            
            VideoFormatInfoWidget {
                id: formatInfo
                Layout.preferredWidth: 200
                Layout.fillHeight: true
            }
        }
        
        // Frame preview
        VideoFramePreviewWidget {
            id: framePreview
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            Layout.fillHeight: true
        }
        
        // Timeline
        VideoTimelineWidget {
            id: timeline
            Layout.fillWidth: true
            Layout.preferredHeight: 80
        }
        
        // Frame seeker
        VideoFrameSeekerWidget {
            id: frameSeeker
            Layout.fillWidth: true
            Layout.preferredHeight: 65
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
        
        // Color grading controls
        VideoColorGradingWidget {
            id: colorGrading
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            visible: controller.showColorGrading || false
            
            onGradingChanged: {
                console.log("Color grading updated")
            }
        }
        
        // Cinema settings
        VideoFileCinematicSettingsWidget {
            id: settingsWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            visible: controller.showSettings || false
        }
        
        // Keyframes
        VideoKeyframeWidget {
            id: keyframeWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            visible: controller.showKeyframes || false
        }
    }
}
