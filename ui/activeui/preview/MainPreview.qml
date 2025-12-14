import QtQuick
import QtQuick.Controls
import QtQuick3D

// MainPreview - Main scene graph 3D preview viewport
// The central preview showing the composed output
Rectangle {
    id: mainPreview
    
    color: "#000000"
    radius: 4
    
    property bool isRecording: false
    property bool isStreaming: false
    property alias camera: previewCamera
    
    // 3D Viewport
    View3D {
        id: viewport3d
        anchors.fill: parent
        anchors.margins: 1
        
        environment: SceneEnvironment {
            clearColor: "#000000"
            backgroundMode: SceneEnvironment.Color
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
        }
        
        PerspectiveCamera {
            id: previewCamera
            position: Qt.vector3d(0, 50, 200)
            eulerRotation.x: -5
        }
        
        DirectionalLight {
            eulerRotation.x: -30
            eulerRotation.y: -30
            ambientColor: Qt.rgba(0.2, 0.2, 0.2, 1.0)
        }
        
        // Ground plane
        Model {
            source: "#Rectangle"
            scale: Qt.vector3d(5, 5, 1)
            eulerRotation.x: -90
            materials: PrincipledMaterial {
                baseColor: "#1a1a1a"
            }
        }
        
        // TODO: Scene content from node graph rendered here
    }
    
    // Recording indicator
    Rectangle {
        visible: isRecording
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 8
        width: 60
        height: 24
        radius: 4
        color: "#cc0000"
        z: 10
        
        Row {
            anchors.centerIn: parent
            spacing: 4
            
            Rectangle {
                width: 8; height: 8; radius: 4
                color: "#fff"
                anchors.verticalCenter: parent.verticalCenter
                
                SequentialAnimation on opacity {
                    running: isRecording
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 500 }
                    NumberAnimation { to: 1.0; duration: 500 }
                }
            }
            
            Label {
                text: "REC"
                color: "#fff"
                font.pixelSize: 11
                font.bold: true
            }
        }
    }
    
    // Streaming indicator
    Rectangle {
        visible: isStreaming
        anchors.top: parent.top
        anchors.right: isRecording ? undefined : parent.right
        anchors.left: isRecording ? parent.right : undefined
        anchors.leftMargin: isRecording ? -130 : 0
        anchors.rightMargin: 8
        anchors.topMargin: 8
        width: 60
        height: 24
        radius: 4
        color: "#e53935"
        z: 10
        
        Label {
            anchors.centerIn: parent
            text: "● LIVE"
            color: "#fff"
            font.pixelSize: 11
            font.bold: true
        }
    }
}
