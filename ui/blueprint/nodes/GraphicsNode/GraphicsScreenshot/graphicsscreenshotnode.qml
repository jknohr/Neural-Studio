import QtQuick
import QtQuick.Layouts
import "../GraphicsScreenshotSourceSelectorWidget"
import "../ImagePreviewWidget"
import "../ImageInfoWidget"


// GraphicsScreenshot variant node - Screenshot capture
// Ultra-specific name: graphicsscreenshot + node

Item {
    id: root
    objectName: "graphicsscreenshotnode"
    
    property string nodeId: ""
    property string variantType: "graphicsscreenshot"
    
    anchors.fill: parent
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        GraphicsScreenshotSourceSelectorWidget {
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
