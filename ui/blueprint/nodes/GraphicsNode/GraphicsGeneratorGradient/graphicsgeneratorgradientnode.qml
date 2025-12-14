import QtQuick
import QtQuick.Layouts
import "../GraphicsGeneratorGradientSourceSelectorWidget"
import "../ImagePreviewWidget"
import "../ImageInfoWidget"
import "../GradientEditorWidget"

// GraphicsGeneratorGradient variant node - Gradient generation
// Ultra-specific name: graphicsgeneratorgradient + node

Item {
    id: root
    objectName: "graphicsgeneratorgradientnode"
    
    property string nodeId: ""
    property string variantType: "graphicsgeneratorgradient"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        GraphicsGeneratorGradientSourceSelectorWidget {
            id: sourceSelector
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            
            onFileSelected: {
                preview.imageSource = filePath
            }
        }
        
        GradientEditorWidget {
            id: extraWidget
            Layout.fillWidth: true
            Layout.preferredHeight: 140
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
