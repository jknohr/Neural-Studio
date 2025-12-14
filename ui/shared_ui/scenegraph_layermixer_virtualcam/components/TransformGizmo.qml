import QtQuick
import QtQuick3D

// TransformGizmo - 3D manipulation handles for position, rotation, scale
// Attach to any Node to enable interactive transform editing
Node {
    id: gizmo
    
    // Mode: 0=Translate, 1=Rotate, 2=Scale
    property int mode: 0
    property bool isActive: false
    property Node targetNode: null
    
    // Axis colors
    readonly property color xColor: "#ff4444"
    readonly property color yColor: "#44ff44"
    readonly property color zColor: "#4444ff"
    readonly property color allColor: "#ffffff"
    
    signal transformStarted()
    signal transformEnded()
    signal positionChanged(vector3d delta)
    signal rotationChanged(vector3d delta)
    signal scaleChanged(vector3d delta)
    
    visible: isActive && targetNode !== null
    
    // Follow target position
    position: targetNode ? targetNode.position : Qt.vector3d(0, 0, 0)
    
    // ========== TRANSLATION GIZMO ==========
    Node {
        id: translateGizmo
        visible: mode === 0
        
        // X Axis Arrow
        Model {
            id: xArrow
            source: "#Cone"
            position: Qt.vector3d(50, 0, 0)
            scale: Qt.vector3d(0.08, 0.3, 0.08)
            eulerRotation.z: -90
            materials: PrincipledMaterial {
                baseColor: xColor
                emissiveFactor: Qt.vector3d(0.5, 0, 0)
                emissiveColor: xColor
            }
        }
        Model {
            source: "#Cylinder"
            position: Qt.vector3d(25, 0, 0)
            scale: Qt.vector3d(0.02, 50, 0.02)
            eulerRotation.z: -90
            materials: PrincipledMaterial { baseColor: xColor }
        }
        
        // Y Axis Arrow
        Model {
            id: yArrow
            source: "#Cone"
            position: Qt.vector3d(0, 50, 0)
            scale: Qt.vector3d(0.08, 0.3, 0.08)
            materials: PrincipledMaterial {
                baseColor: yColor
                emissiveFactor: Qt.vector3d(0, 0.5, 0)
                emissiveColor: yColor
            }
        }
        Model {
            source: "#Cylinder"
            position: Qt.vector3d(0, 25, 0)
            scale: Qt.vector3d(0.02, 50, 0.02)
            materials: PrincipledMaterial { baseColor: yColor }
        }
        
        // Z Axis Arrow
        Model {
            id: zArrow
            source: "#Cone"
            position: Qt.vector3d(0, 0, 50)
            scale: Qt.vector3d(0.08, 0.3, 0.08)
            eulerRotation.x: 90
            materials: PrincipledMaterial {
                baseColor: zColor
                emissiveFactor: Qt.vector3d(0, 0, 0.5)
                emissiveColor: zColor
            }
        }
        Model {
            source: "#Cylinder"
            position: Qt.vector3d(0, 0, 25)
            scale: Qt.vector3d(0.02, 50, 0.02)
            eulerRotation.x: 90
            materials: PrincipledMaterial { baseColor: zColor }
        }
        
        // Center cube (all axes)
        Model {
            source: "#Cube"
            scale: Qt.vector3d(0.1, 0.1, 0.1)
            materials: PrincipledMaterial { baseColor: allColor }
        }
    }
    
    // ========== ROTATION GIZMO ==========
    Node {
        id: rotateGizmo
        visible: mode === 1
        
        // X Rotation Ring (Torus approximated with thin cylinder ring)
        Model {
            source: "#Cylinder"
            scale: Qt.vector3d(0.5, 0.02, 0.5)
            eulerRotation.z: 90
            materials: PrincipledMaterial { baseColor: xColor }
        }
        
        // Y Rotation Ring
        Model {
            source: "#Cylinder"
            scale: Qt.vector3d(0.5, 0.02, 0.5)
            materials: PrincipledMaterial { baseColor: yColor }
        }
        
        // Z Rotation Ring
        Model {
            source: "#Cylinder"
            scale: Qt.vector3d(0.5, 0.02, 0.5)
            eulerRotation.x: 90
            materials: PrincipledMaterial { baseColor: zColor }
        }
    }
    
    // ========== SCALE GIZMO ==========
    Node {
        id: scaleGizmo
        visible: mode === 2
        
        // X Axis Scale Handle (cube at end)
        Model {
            source: "#Cube"
            position: Qt.vector3d(50, 0, 0)
            scale: Qt.vector3d(0.1, 0.1, 0.1)
            materials: PrincipledMaterial { baseColor: xColor }
        }
        Model {
            source: "#Cylinder"
            position: Qt.vector3d(25, 0, 0)
            scale: Qt.vector3d(0.015, 50, 0.015)
            eulerRotation.z: -90
            materials: PrincipledMaterial { baseColor: xColor }
        }
        
        // Y Axis Scale Handle
        Model {
            source: "#Cube"
            position: Qt.vector3d(0, 50, 0)
            scale: Qt.vector3d(0.1, 0.1, 0.1)
            materials: PrincipledMaterial { baseColor: yColor }
        }
        Model {
            source: "#Cylinder"
            position: Qt.vector3d(0, 25, 0)
            scale: Qt.vector3d(0.015, 50, 0.015)
            materials: PrincipledMaterial { baseColor: yColor }
        }
        
        // Z Axis Scale Handle
        Model {
            source: "#Cube"
            position: Qt.vector3d(0, 0, 50)
            scale: Qt.vector3d(0.1, 0.1, 0.1)
            materials: PrincipledMaterial { baseColor: zColor }
        }
        Model {
            source: "#Cylinder"
            position: Qt.vector3d(0, 0, 25)
            scale: Qt.vector3d(0.015, 50, 0.015)
            eulerRotation.x: 90
            materials: PrincipledMaterial { baseColor: zColor }
        }
        
        // Uniform scale center
        Model {
            source: "#Cube"
            scale: Qt.vector3d(0.12, 0.12, 0.12)
            materials: PrincipledMaterial { baseColor: allColor }
        }
    }
}
