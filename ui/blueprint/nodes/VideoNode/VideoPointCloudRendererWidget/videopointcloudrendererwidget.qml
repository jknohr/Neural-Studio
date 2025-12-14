import QtQuick
import QtQuick3D

// VideoPointCloudRendererWidget - Point cloud rendering view
// Ultra-specific name: video + pointcloud + renderer + widget

Rectangle {
    id: root
    
    property var pointCloudData: []
    property real pointSize: 2.0
    property bool enable6DOF: true
    
    color: "#000000"
    implicitHeight: 400
    
    View3D {
        id: view3d
        anchors.fill: parent
        
        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Color
            clearColor: "#000000"
        }
        
        // Camera for point cloud navigation
        PerspectiveCamera {
            id: camera
            position: Qt.vector3d(0, 0, 500)
            eulerRotation: Qt.vector3d(0, 0, 0)
            fieldOfView: 60
        }
        
        // Point cloud model (simplified - would need custom geometry in production)
        Model {
            id: pointCloud
            visible: pointCloudData.length > 0
            
            // Note: In production, this would use a custom geometry
            // generator to create point cloud from data
        }
        
        DirectionalLight {
            eulerRotation: Qt.vector3d(-45, 45, 0)
            brightness: 1.0
        }
    }
    
    // Navigation controls
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        
        property real lastX: 0
        property real lastY: 0
        property real rotX: 0
        property real rotY: 0
        property real distance: 500
        
        onPressed: {
            lastX = mouseX
            lastY = mouseY
        }
        
        onPositionChanged: {
            if (pressed) {
                var deltaX = mouseX - lastX
                var deltaY = mouseY - lastY
                
                rotY += deltaX * 0.3
                rotX += deltaY * 0.3
                
                camera.eulerRotation = Qt.vector3d(rotX, rotY, 0)
                
                lastX = mouseX
                lastY = mouseY
            }
        }
        
        onWheel: {
            distance = Math.max(100, Math.min(2000, distance - wheel.angleDelta.y * 0.5))
            camera.position = Qt.vector3d(0, 0, distance)
        }
    }
    
    // Info overlay
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 10
        width: infoText.width + 16
        height: infoText.height + 12
        color: "#000000"
        opacity: 0.8
        radius: 3
        
        Column {
            id: infoText
            anchors.centerIn: parent
            spacing: 3
            
            Text {
                text: "Point Cloud Renderer"
                color: "#00E676"
                font.pixelSize: 12
                font.bold: true
            }
            
            Text {
                text: "Points: " + (pointCloudData.length / 1000000).toFixed(1) + "M"
                color: "#FFFFFF"
                font.pixelSize: 10
                font.family: "monospace"
            }
            
            Text {
                text: "6DOF: " + (enable6DOF ? "Enabled" : "Disabled")
                color: enable6DOF ? "#4CAF50" : "#888888"
                font.pixelSize: 10
            }
        }
    }
    
    // No data message
    Text {
        visible: pointCloudData.length === 0
        anchors.centerIn: parent
        text: "No point cloud data loaded"
        color: "#666666"
        font.pixelSize: 14
    }
}
