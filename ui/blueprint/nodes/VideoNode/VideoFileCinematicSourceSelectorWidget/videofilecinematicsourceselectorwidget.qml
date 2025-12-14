import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

// VideoFileCinematicSourceSelectorWidget - Cinema/ProRes file picker with codec filter
// Ultra-specific name: video + file + cinematic + source + selector + widget
// Used by: VideoFileCinematic variant

Rectangle {
    id: root
    
    property string selectedFile: ""
    property string fileName: ""
    property string codec: ""
    property string colorSpace: ""
    property bool isHDR: false
    
    signal fileSelected(string filePath)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 90
    
    FileDialog {
        id: fileDialog
        title: "Select Cinema/ProRes File"
        nameFilters: [
            "Cinema files (*.prores *.dnxhd *.dng *.r3d *.braw)",
            "LOG files (*.mov *.mp4)",
            "All files (*)"
        ]
        
        onAccepted: {
            selectedFile = fileDialog.selectedFile.toString()
            fileName = selectedFile.split('/').pop().split('\\').pop()
            fileSelected(selectedFile)
        }
    }
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Cinema Source"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Rectangle {
                visible: isHDR
                width: 35
                height: 16
                color: "#FF6F00"
                radius: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "HDR"
                    color: "white"
                    font.pixelSize: 8
                    font.bold: true
                }
            }
        }
        
        Row {
            width: parent.width
            spacing: 10
            
            Column {
                width: parent.width - 80
                spacing: 3
                
                Text {
                    width: parent.width
                    text: fileName || "No cinema file selected"
                    color: fileName ? "#FFFFFF" : "#777777"
                    font.pixelSize: 12
                    font.bold: fileName !== ""
                    elide: Text.ElideMiddle
                }
                
                Row {
                    spacing: 10
                    visible: codec !== ""
                    
                    Text {
                        text: codec
                        color: "#4CAF50"
                        font.pixelSize: 10
                    }
                    
                    Text {
                        text: colorSpace
                        color: "#888888"
                        font.pixelSize: 10
                    }
                }
            }
            
            Button {
                width: 65
                height: 40
                text: "Browse..."
                
                background: Rectangle {
                    color: parent.hovered ? "#9C27B0" : "#7B1FA2"
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
    }
}
