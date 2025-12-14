import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick3D
import QtQuick3D.Helpers
// import QtQuick3D.Xr 1.0 // Uncomment when module is guaranteed installed
import "components"

Item {
    id: root
    property bool isConnected: controller.virtualCamStatus === 2
    
    // The "World" Content - Shared between Desktop and VR
    Node {
        id: sceneContent
        
        // --- 1. Environment ---
        DirectionalLight { eulerRotation.x: -30; eulerRotation.y: -30; brightness: 1.2; castsShadow: true }
        EnvironmentLight { brightness: 0.5 } // Ambient
        
        // --- 2. Spatial Grid (Floor) ---
        SpatialGrid { 
            visible: true 
            gridSize: 2000
            step: 100
        }

        // --- 3. Dynamic Layers (From Mixer) ---
        Repeater3D {
            model: controller.layers
            
            SpatialLayer {
                id: layerNode
                // Bind properties from the model data
                property var data: modelData
                
                position: Qt.vector3d(
                    (index - (controller.layers.length-1)/2) * 250, // Spread horizontally
                    150 + (Math.sin(index) * 50), // Waviness
                    -200 + (index * 50) // Depth Stagger
                )
                
                // Pass Data
                nodeType: data.type
                layerColor: data.color
                contentVisible: data.active
                opacity: data.opacity
            }
        }
    }

    // --- MODE A: DESKTOP MONITOR VIEW ---
    View3D {
        id: desktopView
        anchors.fill: parent
        // If XR is active, we might want to disable this or show a "Spectator" view.
        // For now, it's the primary editor view.
        
        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Color
            clearColor: "#111"
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
        }

        // Import the shared scene
        importScene: sceneContent
        
        // Editor Camera
        PerspectiveCamera {
            id: desktopCamera
            position: Qt.vector3d(0, 100, 500)
            eulerRotation.x: -10
        }
        
        // Orbit Controls for Desktop
        OrbitCameraController {
            anchors.fill: parent
            camera: desktopCamera
            origin: sceneContent
        }
    }
    
    /* 
    // --- MODE B: VR/XR HEADSET VIEW ---
    // Make this conditional or loaded dynamically to prevent crashes on non-XR systems
    XrView {
        id: xrView
        referenceSpace: XrView.Stage
        
        // Import the SAME scene content
        importScene: sceneContent
        
        // The VR Player Rig
        XrOrigin {
            id: xrOrigin
            position: Qt.vector3d(0, 0, 400) // Start player back a bit
            
            // Hands / Controllers would go here
        }
    }
    */

    // --- HUD ---
    Rectangle {
        anchors.left: parent.left; anchors.top: parent.top; anchors.margins: 20
        width: 250; height: 30; color: Qt.rgba(0,0,0,0.7); radius: 4
        RowLayout {
            anchors.fill: parent; anchors.margins: 5
            Rectangle { width: 12; height: 12; radius: 6; color: root.isConnected ? "#FF5555" : "#888" }
            Text { text: "SPATIAL CANVAS"; color: "white"; font.bold: true }
            
            Item { Layout.fillWidth: true }
            
            // Stereo/VR Indicator
            Rectangle {
                width: 60; height: 20; radius: 2
                color: controller.stereoMode === 0 ? "#444" : "#4CAF50"
                Text { 
                    anchors.centerIn: parent
                    text: controller.stereoMode === 0 ? "DESKTOP" : "VR READY"
                    font.pixelSize: 9; color: "white" 
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: controller.stereoMode = (controller.stereoMode + 1) % 2
                }
            }
        }
    }
}
