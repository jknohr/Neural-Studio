import QtQuick
import QtQuick3D

// SpatialText3D - Text positioned in 3D space
// Can be used for titles, overlays, labels anywhere in the scene
Node {
    id: textNode
    
    // Text content
    property string text: "Text"
    property color textColor: "#ffffff"
    property real fontSize: 48
    property string fontFamily: "Arial"
    property bool fontBold: false
    
    // Visual properties
    property real textOpacity: 1.0
    property bool textVisible: true
    property bool isSelected: false
    
    // Appearance
    property bool hasBackground: false
    property color backgroundColor: "#80000000"
    property real backgroundPadding: 20
    
    // Billboard mode - always face camera
    property bool billboardMode: false
    
    // Depth
    property int zOrder: 0
    
    signal selected()
    
    visible: textVisible
    
    // ========== TEXT RENDERING ==========
    // Qt Quick 3D doesn't have built-in 3D text, so we use a textured plane
    // The texture is generated from a QML Text element
    
    Model {
        id: textPlane
        source: "#Rectangle"
        
        // Scale based on text size
        scale: Qt.vector3d(
            textMetrics.width / 500 + 0.1,
            textMetrics.height / 500 + 0.05,
            1
        )
        
        materials: [
            PrincipledMaterial {
                id: textMaterial
                lighting: PrincipledMaterial.NoLighting
                opacity: textOpacity
                cullMode: PrincipledMaterial.NoCulling
                
                // The baseColorMap would be a texture from the text
                // For now, we use a placeholder approach
                baseColor: "transparent"
                
                baseColorMap: Texture {
                    sourceItem: textRenderer
                }
            }
        ]
    }
    
    // ========== TEXT RENDERER (Offscreen) ==========
    
    // This Item renders the text to a texture
    Item {
        id: textRenderer
        width: textMetrics.width + (hasBackground ? backgroundPadding * 2 : 0)
        height: textMetrics.height + (hasBackground ? backgroundPadding * 2 : 0)
        visible: false  // Offscreen rendering
        layer.enabled: true  // Enable texture generation
        
        // Background
        Rectangle {
            anchors.fill: parent
            color: hasBackground ? backgroundColor : "transparent"
            radius: hasBackground ? 8 : 0
        }
        
        // Text
        Text {
            id: textElement
            anchors.centerIn: parent
            text: textNode.text
            color: textColor
            font.pixelSize: fontSize
            font.family: fontFamily
            font.bold: fontBold
            
            // For high quality rendering
            renderType: Text.NativeRendering
        }
    }
    
    // Text size measurement
    TextMetrics {
        id: textMetrics
        text: textNode.text
        font.pixelSize: fontSize
        font.family: fontFamily
        font.bold: fontBold
    }
    
    // ========== SELECTION HIGHLIGHT ==========
    
    Model {
        visible: isSelected
        source: "#Rectangle"
        position: Qt.vector3d(0, 0, -1)
        scale: Qt.vector3d(
            textPlane.scale.x + 0.02,
            textPlane.scale.y + 0.02,
            1
        )
        materials: PrincipledMaterial {
            baseColor: "transparent"
            emissiveFactor: Qt.vector3d(0.3, 0.5, 1)
            emissiveColor: "#4a9eff"
            opacity: 0.5
        }
    }
}
