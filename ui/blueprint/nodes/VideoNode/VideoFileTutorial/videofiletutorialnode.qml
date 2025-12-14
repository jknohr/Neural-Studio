import QtQuick
import QtQuick.Layouts
import "../VideoFileTutorialSourceSelectorWidget"
import "../VideoFramePreviewWidget"
import "../VideoPlaybackControlsWidget"
import "../VideoTimelineWidget"
import "../VideoVolumeControlWidget"
import "../VideoChapterNavigatorWidget"
import "../VideoFileTutorialSettingsWidget"

// VideoFileTutorial variant node - Educational/Tutorial videos
// Ultra-specific name: video + file + tutorial + node
// Supports: MP4, WebM, MKV with chapter markers

Item {
    id: root
    objectName: "videofiletutorialnode"
    
    property string nodeId: ""
    property string variantType: "videofiletutorial"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Source selector
        VideoFileTutorialSourceSelectorWidget {
            id: sourceSelector
            Layout.fillWidth: true
            Layout.preferredHeight: 90
        }
        
        // Main content row: Preview and chapters
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            
            // Frame preview
            VideoFramePreviewWidget {
                id: framePreview
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                Layout.fillHeight: true
            }
            
            // Chapter navigator (sidebar)
            VideoChapterNavigatorWidget {
                id: chapterNavigator
                Layout.preferredWidth: 200
                Layout.fillHeight: true
                
                onJumpToChapter: {
                    console.log("Jump to chapter:", index)
                }
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
        
        // Tutorial settings
        VideoFileTutorialSettingsWidget {
            id: settingsWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            visible: controller.showSettings || false
        }
    }
}
