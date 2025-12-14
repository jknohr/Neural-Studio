import QtQuick
import QtQuick.Layouts
import "../GraphicsTextureSourceSelectorWidget"
import "../ImagePreviewWidget"
import "../ImageInfoWidget"


// GraphicsTexture variant node - 3D texture map display
// Ultra-specific name: graphicstexture + node

Item {
    id: root
    objectName: "graphicstexturenode"
    
    property string nodeId: ""
    property string variantType: "graphicstexture"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        GraphicsTextureSourceSelectorWidget {
            id: sourceSelector
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            
            onFileSelected: {
                preview.imageSource = filePath
            }
        }
        

        ImagePreviewWidget {
            id: preview
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        
        ImageInfoWidget {
            id: info
            Layout.fillWidth: true
            Layout.preferredHeight: 140
        }
    }
}
