import QtQuick
import QtQuick.Layouts
import "../GraphicsHDRSourceSelectorWidget"
import "../ImagePreviewWidget"
import "../ImageInfoWidget"


// GraphicsHDR variant node - HDR/EXR image display
// Ultra-specific name: graphicshdr + node

Item {
    id: root
    objectName: "graphicshdrnode"
    
    property string nodeId: ""
    property string variantType: "graphicshdr"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        GraphicsHDRSourceSelectorWidget {
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
