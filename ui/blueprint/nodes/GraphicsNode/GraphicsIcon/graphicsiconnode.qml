import QtQuick
import QtQuick.Layouts
import "../GraphicsIconSourceSelectorWidget"
import "../ImagePreviewWidget"
import "../ImageInfoWidget"


// GraphicsIcon variant node - Icon file display
// Ultra-specific name: graphicsicon + node

Item {
    id: root
    objectName: "graphicsiconnode"
    
    property string nodeId: ""
    property string variantType: "graphicsicon"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        GraphicsIconSourceSelectorWidget {
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
