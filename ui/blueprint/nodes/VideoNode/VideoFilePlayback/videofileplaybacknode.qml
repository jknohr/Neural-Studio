import QtQuick
import QtMultimedia
import "../VideoFilePlaybackWidget"

// VideoFilePlayback variant node - handles standard video file playback (MP4, MKV, WebM, etc.)
// Ultra-specific name: video + fileplayback + node

Item {
    id: videofileplaybacknode
    objectName: "videofileplaybacknode"
    
    anchors.fill: parent
    
    // Video file playback widget
    VideoFilePlaybackWidget {
        id: playbackWidget
        anchors.fill: parent
        
        // Connect to controller properties
        videoSource: controller.videoFilePath || ""
        autoPlay: controller.autoPlay || false
        loop: controller.loop || false
    }
    
    // Optional settings panel
    Loader {
        id: settingsLoader
        anchors.right: parent.right
        width: parent.width * 0.3
        height: parent.height
        
        active: controller.showSettings || false
        source: "../VideoFilePlaybackSettingsWidget/videofileplaybacksettingswidget.qml"
    }
}
