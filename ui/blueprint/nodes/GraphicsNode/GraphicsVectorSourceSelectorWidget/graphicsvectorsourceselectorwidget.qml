import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

// GraphicsVectorSourceSelectorWidget - Source file selector
// Ultra-specific name: graphicsvectorsourceselectorwidget

Rectangle {
    id: root
    
    property string selectedFile: ""
    
    signal fileSelected(string filePath)
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 70
    
    Row {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        Rectangle {
            width: 60
            height: 50
            color: "#9C27B0"
            radius: 3
            anchors.verticalCenter: parent.verticalCenter
            
            Text {
                anchors.centerIn: parent
                text: "SVG"
                color: "white"
                font.pixelSize: 10
                font.bold: true
            }
        }
        
        Column {
            width: parent.width - 140
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter
            
            Text {
                text: selectedFile || "No file selected"
                color: selectedFile ? "#FFFFFF" : "#888888"
                font.pixelSize: 11
                elide: Text.ElideMiddle
                width: parent.width
            }
            
            Text {
                text: "Formats: SVG PDF AI EPS"
                color: "#666666"
                font.pixelSize: 9
            }
        }
        
        Button {
            width: 60
            height: 50
            text: "Browse"
            anchors.verticalCenter: parent.verticalCenter
            
            background: Rectangle {
                color: parent.hovered ? "#43A047" : "#388E3C"
                radius: 3
            }
            
            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: fileDialog.open()
        }
    }
    
    FileDialog {
        id: fileDialog
        title: "Select SVG PDF AI EPS file"
        onAccepted: {
            selectedFile = selectedFile
            fileSelected(selectedFile)
        }
    }
}
