import QtQuick
import QtQuick3D
import QtMultimedia

// SpatialVideoFeed - Video/Camera feed positioned in 3D space
// Can be a live camera, video file, or any video source
Node {
    id: videoFeed
    
    // Source configuration
    property string sourceId: ""
    property string sourceName: "Video Feed"
    property int sourceType: 0  // 0=Camera, 1=VideoFile, 2=StreamURL
    property url videoUrl: ""
    property string cameraDeviceId: ""
    
    // Transform (position/rotation/scale exposed from Node)
    // Additional sizing
    property real videoWidth: 1920
    property real videoHeight: 1080
    property real planeScale: 1.0  // Additional scale multiplier
    
    // Visual properties
    property real videoOpacity: 1.0
    property bool videoVisible: true
    property bool isSelected: false
    property bool showFrame: true  // Show border frame
    
    // Depth ordering
    property int zOrder: 0
    
    signal selected()
    signal transformUpdated()
    
    visible: videoVisible
    
    // ========== VIDEO SOURCE ==========
    
    // Camera capture (for sourceType === 0)
    CaptureSession {
        id: cameraSession
        camera: Camera {
            id: cameraDevice
            active: sourceType === 0 && videoVisible
        }
        videoOutput: videoOutput
    }
    
    // Media player (for sourceType === 1 or 2)
    MediaPlayer {
        id: mediaPlayer
        source: (sourceType === 1 || sourceType === 2) ? videoUrl : ""
        videoOutput: videoOutput
        loops: MediaPlayer.Infinite
        
        Component.onCompleted: {
            if (sourceType === 1 || sourceType === 2) {
                play()
            }
        }
    }
    
    // Video output to texture
    VideoOutput {
        id: videoOutput
        visible: false  // Not rendered directly, used for texture
    }
    
    // ========== 3D VIDEO PLANE ==========
    
    Model {
        id: videoPlane
        source: "#Rectangle"
        
        // Scale based on aspect ratio
        scale: Qt.vector3d(
            planeScale * (videoWidth / 1000),
            planeScale * (videoHeight / 1000),
            1
        )
        
        materials: [
            PrincipledMaterial {
                id: videoMaterial
                baseColor: Qt.rgba(1, 1, 1, videoOpacity)
                opacity: videoOpacity
                lighting: PrincipledMaterial.NoLighting  // Video is self-lit
                cullMode: PrincipledMaterial.NoCulling  // Visible from both sides
                
                // TODO: Connect to actual video texture
                // baseColorMap: Texture { sourceItem: videoOutput }
                
                // Fallback color when no video
                baseColor: "#333333"
            }
        ]
    }
    
    // ========== FRAME BORDER ==========
    
    // Top edge
    Model {
        visible: showFrame
        source: "#Cube"
        position: Qt.vector3d(0, videoPlane.scale.y * 500 + 2, 0)
        scale: Qt.vector3d(videoPlane.scale.x * 1000 + 8, 4, 4)
        materials: PrincipledMaterial {
            baseColor: isSelected ? "#4a9eff" : "#444"
            emissiveFactor: isSelected ? Qt.vector3d(0.3, 0.5, 1) : Qt.vector3d(0, 0, 0)
            emissiveColor: "#4a9eff"
        }
    }
    
    // Bottom edge
    Model {
        visible: showFrame
        source: "#Cube"
        position: Qt.vector3d(0, -videoPlane.scale.y * 500 - 2, 0)
        scale: Qt.vector3d(videoPlane.scale.x * 1000 + 8, 4, 4)
        materials: PrincipledMaterial {
            baseColor: isSelected ? "#4a9eff" : "#444"
        }
    }
    
    // Left edge
    Model {
        visible: showFrame
        source: "#Cube"
        position: Qt.vector3d(-videoPlane.scale.x * 500 - 2, 0, 0)
        scale: Qt.vector3d(4, videoPlane.scale.y * 1000, 4)
        materials: PrincipledMaterial {
            baseColor: isSelected ? "#4a9eff" : "#444"
        }
    }
    
    // Right edge
    Model {
        visible: showFrame
        source: "#Cube"
        position: Qt.vector3d(videoPlane.scale.x * 500 + 2, 0, 0)
        scale: Qt.vector3d(4, videoPlane.scale.y * 1000, 4)
        materials: PrincipledMaterial {
            baseColor: isSelected ? "#4a9eff" : "#444"
        }
    }
    
    // ========== LABEL ==========
    
    Node {
        position: Qt.vector3d(0, videoPlane.scale.y * 500 + 20, 0)
        
        // 3D text would go here - using a simple indicator for now
        Model {
            source: "#Cube"
            scale: Qt.vector3d(0.5, 0.08, 0.02)
            materials: PrincipledMaterial {
                baseColor: "#222"
                opacity: 0.8
            }
        }
    }
}
