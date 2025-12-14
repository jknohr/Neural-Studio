import QtQuick
import QtQuick3D

// SpatialImage - Static image positioned in 3D space
// For graphics, overlays, logos, etc.
Node {
    id: imageNode
    
    // Image source
    property url imageSource: ""
    property string imageName: "Image"
    
    // Size (in world units, automatic from image if not set)
    property real imageWidth: 0  // 0 = auto from source
    property real imageHeight: 0  // 0 = auto from source
    property real planeScale: 1.0
    
    // Visual properties
    property real imageOpacity: 1.0
    property bool imageVisible: true
    property bool isSelected: false
    property bool preserveAspect: true
    
    // Depth
    property int zOrder: 0
    
    signal selected()
    
    visible: imageVisible
    
    // ========== IMAGE TEXTURE ==========
    
    Texture {
        id: imageTexture
        source: imageSource
    }
    
    // ========== 3D IMAGE PLANE ==========
    
    Model {
        id: imagePlane
        source: "#Rectangle"
        
        // Calculate scale from image dimensions
        scale: {
            var w = imageWidth > 0 ? imageWidth : (imageTexture.sourceSize.width || 1000)
            var h = imageHeight > 0 ? imageHeight : (imageTexture.sourceSize.height || 1000)
            
            return Qt.vector3d(
                planeScale * w / 1000,
                planeScale * h / 1000,
                1
            )
        }
        
        materials: [
            PrincipledMaterial {
                baseColorMap: imageTexture
                opacity: imageOpacity
                lighting: PrincipledMaterial.NoLighting
                cullMode: PrincipledMaterial.NoCulling
                alphaMode: PrincipledMaterial.Blend  // Support transparent PNGs
            }
        ]
    }
    
    // ========== SELECTION FRAME ==========
    
    // Selection outline
    Model {
        visible: isSelected
        source: "#Rectangle"
        position: Qt.vector3d(0, 0, -0.5)
        scale: Qt.vector3d(
            imagePlane.scale.x + 0.02,
            imagePlane.scale.y + 0.02,
            1
        )
        materials: PrincipledMaterial {
            baseColor: "transparent"
            emissiveFactor: Qt.vector3d(0.3, 0.5, 1)
            emissiveColor: "#4a9eff"
            opacity: 0.3
        }
    }
    
    // Corner handles when selected
    Repeater3D {
        model: isSelected ? 4 : 0
        
        Model {
            source: "#Cube"
            scale: Qt.vector3d(0.03, 0.03, 0.03)
            position: {
                var x = imagePlane.scale.x * 500
                var y = imagePlane.scale.y * 500
                switch (index) {
                    case 0: return Qt.vector3d(-x, y, 1)   // Top-left
                    case 1: return Qt.vector3d(x, y, 1)    // Top-right
                    case 2: return Qt.vector3d(-x, -y, 1)  // Bottom-left
                    case 3: return Qt.vector3d(x, -y, 1)   // Bottom-right
                }
            }
            materials: PrincipledMaterial {
                baseColor: "#ffffff"
                emissiveFactor: Qt.vector3d(1, 1, 1)
                emissiveColor: "#ffffff"
            }
        }
    }
}
