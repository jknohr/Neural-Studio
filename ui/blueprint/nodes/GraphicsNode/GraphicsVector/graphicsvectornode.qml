import QtQuick
import QtQuick.Layouts
import "../GraphicsVectorSourceSelectorWidget"
import "../ImagePreviewWidget"
import "../ImageInfoWidget"


// GraphicsVector variant node - SVG vector graphics display
// Ultra-specific name: graphicsvector + node

Item {
    id: root
    objectName: "graphicsvectornode"
    
    property string nodeId: ""
    property string variantType: "graphicsvector"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        GraphicsVectorSourceSelectorWidget {
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
