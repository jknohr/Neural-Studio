import QtQuick
import QtQuick3D

// VideoEquirectangularProjectionWidget - 360° equirectangular projection view
// Ultra-specific name: video + equirectangular + projection + widget

Rectangle {
    id: root
    
    property string videoTexture: ""
    property real yaw: 0.0
    property real pitch: 0.0
    property real fov: 90.0
    
    signal viewChanged(real newYaw, real newPitch)
    
    color: "#000000"
    implicitHeight: 300
    
    View3D {
        id: view3d
        anchors.fill: parent
        
        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Color
            clearColor: "#000000"
        }
        
        PerspectiveCamera {
            id: camera
            position: Qt.vector3d(0, 0, 0)
            eulerRotation: Qt.vector3d(pitch, yaw, 0)
            fieldOfView: fov
        }
        
        Model {
            id: sphere
            source: "#Sphere"
            scale: Qt.vector3d(-100, -100, -100)  // Inverted to see inside
            
            materials: DefaultMaterial {
                diffuseMap: Texture {
                    source: videoTexture
                }
            }
        }
        
        DirectionalLight {
            eulerRotation: Qt.vector3d(-45, 0, 0)
            brightness: 1.0
        }
    }
    
    // Mouse controls
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        
        property real lastX: 0
        property real lastY: 0
        
        onPressed: {
            lastX = mouseX
            lastY = mouseY
        }
        
        onPositionChanged: {
            if (pressed) {
                var deltaX = mouseX - lastX
                var deltaY = mouseY - lastY
                
                yaw += deltaX * 0.3
                pitch = Math.max(-90, Math.min(90, pitch + deltaY * 0.3))
                
                lastX = mouseX
                lastY = mouseY
                
                viewChanged(yaw, pitch)
            }
        }
        
        onWheel: {
            fov = Math.max(30, Math.min(120, fov - wheel.angleDelta.y * 0.1))
        }
    }
    
    // Controls overlay
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        width: controlsText.width + 16
        height: controlsText.height + 12
        color: "#000000"
        opacity: 0.7
        radius: 3
        
        Text {
            id: controlsText
            anchors.centerIn: parent
            text: "Yaw: " + yaw.toFixed(1) + "° | Pitch: " + pitch.toFixed(1) + "° | FOV: " + fov.toFixed(0) + "°"
            color: "#FFFFFF"
            font.pixelSize: 10
            font.family: "monospace"
        }
    }
}
