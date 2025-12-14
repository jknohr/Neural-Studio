import QtQuick
import QtQuick3D

// SpatialLight - Manipulable light source in the 3D workspace
// Supports: Point, Directional, Spot, and Area lights
Node {
    id: lightNode
    
    // Light properties
    property int lightType: 0  // 0=Point, 1=Directional, 2=Spot, 3=Area
    property color lightColor: "#ffffff"
    property real intensity: 1.0
    property real range: 1000  // For point/spot
    property real spotAngle: 45  // For spot only
    property bool castsShadow: true
    property bool isSelected: false
    
    // Visual gizmo visibility
    property bool showGizmo: true
    
    signal selected()
    signal transformChanged(vector3d pos, vector3d rot)
    
    // ========== ACTUAL LIGHTS ==========
    
    // Point Light
    PointLight {
        id: pointLight
        visible: lightType === 0
        color: lightColor
        brightness: intensity
        castsShadow: lightNode.castsShadow
        shadowFactor: 50
    }
    
    // Directional Light
    DirectionalLight {
        id: directionalLight
        visible: lightType === 1
        color: lightColor
        brightness: intensity
        castsShadow: lightNode.castsShadow
        shadowFactor: 50
    }
    
    // Spot Light
    SpotLight {
        id: spotLight
        visible: lightType === 2
        color: lightColor
        brightness: intensity
        coneAngle: spotAngle
        innerConeAngle: spotAngle * 0.7
        castsShadow: lightNode.castsShadow
        shadowFactor: 50
    }
    
    // ========== VISUAL GIZMOS ==========
    
    // Light icon (always faces camera - billboard)
    Node {
        id: gizmoNode
        visible: showGizmo
        
        // Light bulb/sun icon representation
        Model {
            source: "#Sphere"
            scale: Qt.vector3d(0.15, 0.15, 0.15)
            materials: PrincipledMaterial {
                baseColor: lightNode.lightColor
                emissiveFactor: Qt.vector3d(1, 1, 1)
                emissiveColor: lightNode.lightColor
            }
        }
        
        // Direction indicator for directional/spot
        Model {
            visible: lightType === 1 || lightType === 2
            source: "#Cone"
            position: Qt.vector3d(0, 0, -30)
            scale: Qt.vector3d(0.1, 0.1, 0.3)
            eulerRotation.x: -90
            materials: PrincipledMaterial {
                baseColor: lightNode.lightColor
                opacity: 0.5
            }
        }
        
        // Spot light cone visualization
        Model {
            visible: lightType === 2
            source: "#Cone"
            position: Qt.vector3d(0, 0, -60)
            scale: Qt.vector3d(0.4, 0.4, 0.8)
            eulerRotation.x: -90
            materials: PrincipledMaterial {
                baseColor: Qt.rgba(1, 1, 0.5, 0.2)
                opacity: 0.2
            }
        }
        
        // Range sphere for point lights
        Model {
            visible: lightType === 0 && isSelected
            source: "#Sphere"
            scale: Qt.vector3d(range / 100, range / 100, range / 100)
            materials: PrincipledMaterial {
                baseColor: Qt.rgba(1, 1, 0.5, 0.1)
                opacity: 0.1
            }
        }
        
        // Selection highlight
        Model {
            visible: isSelected
            source: "#Sphere"
            scale: Qt.vector3d(0.2, 0.2, 0.2)
            materials: PrincipledMaterial {
                baseColor: "transparent"
                emissiveFactor: Qt.vector3d(0, 1, 1)
                emissiveColor: "#00ffff"
            }
        }
    }
}
