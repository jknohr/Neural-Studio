import QtQuick
import QtMultimedia

// Main VideoNode compositor - loads variants based on variantType property
// Follows function-based variant pattern (NOT technology-based)

Item {
    id: videonode
    
    // Properties from controller
    property string variantType: "videofileplayback"  // Default variant
    property bool showControls: true
    property bool showSettings: false
    
    anchors.fill: parent
    
    // Dynamic variant loader
    Loader {
        id: variantLoader
        anchors.fill: parent
        
        source: {
            switch(variantType) {
                case "videofileplayback": return "VideoFilePlayback/videofileplaybacknode.qml"
                case "videovr360playback": return "VideoVR360Playback/videovr360playbacknode.qml"
                case "videovr180playback": return "VideoVR180Playback/videovr180playbacknode.qml"
                case "videoscreencapture": return "VideoScreenCapture/videoscreencapturenode.qml"
                default: return ""
            }
        }
        
        onStatusChanged: {
            if (status === Loader.Error) {
                console.error("VideoNode: Failed to load variant:", variantType)
            }
        }
    }
}
