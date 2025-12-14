import QtQuick
import QtQuick.Layouts
import "../GraphicsGeneratorNoiseSourceSelectorWidget"
import "../ImagePreviewWidget"
import "../ImageInfoWidget"
import "../NoiseParametersWidget"

// GraphicsGeneratorNoise variant node - Procedural noise generation
// Ultra-specific name: graphicsgeneratornoise + node

Item {
    id: root
    objectName: "graphicsgeneratornoisenode"
    
    property string nodeId: ""
    property string variantType: "graphicsgeneratornoise"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        GraphicsGeneratorNoiseSourceSelectorWidget {
            id: sourceSelector
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            
            onFileSelected: {
                preview.imageSource = filePath
            }
        }
        
        NoiseParametersWidget {
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
