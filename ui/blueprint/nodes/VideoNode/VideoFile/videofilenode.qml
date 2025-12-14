import QtQuick
import QtQuick.Layouts
import "../VideoFileSourceSelectorWidget"
import "../VideoFramePreviewWidget"
import "../VideoPlaybackControlsWidget"
import "../VideoTimelineWidget"
import "../VideoFrameSeekerWidget"
import "../VideoVolumeControlWidget"
import "../VideoFormatInfoWidget"
import "../VideoFileSettingsWidget"
import "../VideoKeyframeWidget"

// VideoFile variant node - Generic video file playback
// Ultra-specific name: video + file + node
// Supports: MP4, MKV, WebM, AVI, MOV, MPEG formats

Item {
    id: root
    objectName: "videofilenode"
    
    // Unique identifier from controller (UUID)
    property string nodeId: ""
    property string variantType: "videofile"
    
    anchors.fill: parent
    
    // Main layout
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top row: Source selector and format info
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            // Source file selector
            VideoFileSourceSelectorWidget {
                id: sourceSelector
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                
                onFileSelected: {
                    console.log("Video file selected:", filePath)
                    // Backend will load video file
                }
            }
            
            // Format info display
            VideoFormatInfoWidget {
                id: formatInfo
                Layout.preferredWidth: 200
                Layout.fillHeight: true
            }
        }
        
        // Frame preview (main video display)
        VideoFramePreviewWidget {
            id: framePreview
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            Layout.fillHeight: true
        }
        
        // Timeline with keyframes
        VideoTimelineWidget {
            id: timeline
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            
            onPositionChanged: {
                console.log("Timeline position:", newPosition)
                // Update playback position
            }
        }
        
        // Frame-by-frame seeker
        VideoFrameSeekerWidget {
            id: frameSeeker
            Layout.fillWidth: true
            Layout.preferredHeight: 65
            
            onJumpToFrame: {
                console.log("Jump to frame:", frame)
                // Update to specific frame
            }
        }
        
        // Playback controls row
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            // Playback controls (play, pause, stop, seek)
            VideoPlaybackControlsWidget {
                id: playbackControls
                Layout.preferredWidth: 250
                Layout.preferredHeight: 60
                
                onPlay: console.log("Play video")
                onPause: console.log("Pause video")
                onStop: console.log("Stop video")
            }
            
            // Volume control
            VideoVolumeControlWidget {
                id: volumeControl
                Layout.fillWidth: true
                Layout.preferredHeight: 60
            }
        }
        
        // Settings panel (collapsible)
        VideoFileSettingsWidget {
            id: settingsWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 140
            visible: controller.showSettings || false
            
            onSettingsChanged: {
                console.log("Settings changed")
                // Apply playback settings
            }
        }
        
        // Keyframe widget (optional, collapsible)
        VideoKeyframeWidget {
            id: keyframeWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            visible: controller.showKeyframes || false
            
            onAddKeyframe: {
                console.log("Add keyframe at:", time)
                // Add keyframe marker
            }
        }
    }
}
