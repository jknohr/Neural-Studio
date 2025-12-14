import QtQuick
import QtQuick.Layouts
import "../GraphicsGeneratorPatternSourceSelectorWidget"
import "../ImagePreviewWidget"
import "../ImageInfoWidget"
import "../PatternSettingsWidget"

// GraphicsGeneratorPattern variant node - Pattern generation
// Ultra-specific name: graphicsgeneratorpattern + node

Item {
    id: root
    objectName: "graphicsgeneratorpatternnode"
    
    property string nodeId: ""
    property string variantType: "graphicsgeneratorpattern"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        GraphicsGeneratorPatternSourceSelectorWidget {
            id: sourceSelector
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            
            onFileSelected: {
                preview.imageSource = filePath
            }
        }
        
        PatternSettingsWidget {
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
