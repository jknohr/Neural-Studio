import QtQuick
import QtQuick.Layouts
import "../GraphicsImageSourceSelectorWidget"
import "../ImagePreviewWidget"
import "../ImageInfoWidget"

// GraphicsImage variant node - Generic raster image display
// Ultra-specific name: graphics + image + node
// Load and display: PNG, JPG, WEBP, BMP, GIF

Item {
    id: root
    objectName: "graphicsimagenode"
    
    property string nodeId: ""
    property string variantType: "graphicsimage"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Source selector
        GraphicsImageSourceSelectorWidget {
            id: sourceSelector
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            
            onFileSelected: {
                preview.imageSource = filePath
                console.log("Image loaded:", filePath)
            }
        }
        
        // Preview
        ImagePreviewWidget {
            id: preview
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        
        // Info
        ImageInfoWidget {
            id: info
            Layout.fillWidth: true
            Layout.preferredHeight: 140
        }
    }
}
