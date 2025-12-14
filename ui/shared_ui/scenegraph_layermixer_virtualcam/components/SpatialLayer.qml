import QtQuick
import QtQuick3D 1.15

Node {
    id: root
    
    // Data passed from controller
    property var layerData: null  
    property int nodeType: layerData ? layerData.type : 0
    property string layerName: layerData ? layerData.name : "Node"
    property real layerOpacity: layerData ? layerData.opacity : 1.0
    property bool layerVisible: layerData ? layerData.visible : true
    property color layerColor: layerData ? layerData.color : "white"
    property int zIndex: layerData ? layerData.zIndex : 0

    // Node Types enum mirroring C++
    readonly property int typeVideo: 1
    readonly property int typeAudio: 2
    readonly property int typeCamera: 3
    readonly property int type3DModel: 4
    readonly property int typeImage: 5
    readonly property int typeScript: 6
    readonly property int typeML: 7
    readonly property int typeLLM: 8
    readonly property int typeGraphics: 9

    visible: layerVisible
    position: Qt.vector3d(0, 0, -zIndex * 20)
    
    // --- 1. VISUAL: VIDEO / IMAGE / GRAPHICS ---
    // Rendered as a flat plane with texture
    Node {
        id: planeVisual
        visible: (root.nodeType === root.typeVideo || root.nodeType === root.typeImage || root.nodeType === root.typeGraphics)
        
        Model {
            source: "#Rectangle"
            scale: Qt.vector3d(1.6, 0.9, 1) // 16:9
            materials: [
                DefaultMaterial {
                    diffuseColor: root.layerColor
                    opacity: root.layerOpacity
                    // In real app, diffuseMap would be the video texture
                }
            ]
        }
    }

    // --- 2. VISUAL: AUDIO / LOGIC (Abstract) ---
    // Rendered as a floating Billboard Icon
    Node {
        id: iconVisual
        visible: (root.nodeType === root.typeAudio || root.nodeType === root.typeScript || root.nodeType === root.typeML || root.nodeType === root.typeLLM)
        
        // Face camera behavior would go here (Billboard)
        // For now, simple Sphere or Cube
        Model {
            source: "#Sphere"
            scale: Qt.vector3d(0.3, 0.3, 0.3)
            materials: [
                DefaultMaterial {
                    diffuseColor: root.layerColor
                    opacity: root.layerOpacity
                    emissiveColor: root.layerColor // Glow
                }
            ]
        }
        
        // Pulse animation for Audio "Activity"
        SequentialAnimation on scale {
            loops: Animation.Infinite
            running: root.nodeType === root.typeAudio && root.layerVisible
            Vector3dAnimation { from: Qt.vector3d(0.3,0.3,0.3); to: Qt.vector3d(0.35,0.35,0.35); duration: 400; easing.type: Easing.InOutQuad }
            Vector3dAnimation { from: Qt.vector3d(0.35,0.35,0.35); to: Qt.vector3d(0.3,0.3,0.3); duration: 400; easing.type: Easing.InOutQuad }
        }
    }

    // --- 3. VISUAL: 3D MODEL ---
    // Rendered as a placeholder 3D Mesh
    Node {
        id: meshVisual
        visible: (root.nodeType === root.type3DModel)
        
        Model {
            source: "#Cube" // Placeholder for actual .mesh
            scale: Qt.vector3d(0.8, 0.8, 0.8)
            eulerRotation.y: 45
            eulerRotation.x: 20
            materials: [
                DefaultMaterial {
                    diffuseColor: root.layerColor
                    opacity: root.layerOpacity
                    specularAmount: 1.0
                }
            ]
            
            // Spin it!
            NumberAnimation on eulerRotation.y {
                from: 0; to: 360; duration: 10000; loops: Animation.Infinite
                running: root.layerVisible
            }
        }
    }
    
    // --- 4. VISUAL: CAMERA ---
    // Rendered as a Frustum Gizmo
    Node {
        id: cameraGizmo
        visible: (root.nodeType === root.typeCamera)
        
        Model {
            source: "#Cone"
            scale: Qt.vector3d(0.5, 0.5, 0.5)
            eulerRotation.x: 90
            materials: [
                DefaultMaterial {
                    diffuseColor: "transparent"
                    emissiveColor: root.layerColor // Wireframe look
                    opacity: 0.5
                }
            ]
        }
    }

    // --- LABEL ---
    // Simple text indicator (using QML 2D overlay text functionality or text mesh)
    // For now, we skip explicit 3D text unless using QtQuick3D.Helpers Text3D
}
