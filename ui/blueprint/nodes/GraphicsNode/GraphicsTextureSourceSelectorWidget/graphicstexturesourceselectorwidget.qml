import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

// GraphicsTextureSourceSelectorWidget - Source file selector
// Ultra-specific name: graphicstexturesourceselectorwidget

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
            color: "#FF9800"
            radius: 3
            anchors.verticalCenter: parent.verticalCenter
            
            Text {
                anchors.centerIn: parent
                text: "PNG"
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
                text: "Formats: PNG TGA DDS KTX"
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
        title: "Select PNG TGA DDS KTX file"
        onAccepted: {
            selectedFile = selectedFile
            fileSelected(selectedFile)
        }
    }
}
