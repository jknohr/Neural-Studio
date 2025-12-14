import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

// VideoFileVR360SourceSelectorWidget - 360° VR video file picker with projection preview
// Ultra-specific name: video + file + vr360 + source + selector + widget
// Used by: VideoFileVR360 variant

Rectangle {
    id: root
    
    property string selectedFile: ""
    property string fileName: ""
    property string projectionType: "equirectangular"
    property string stereoMode: "mono"
    
    signal fileSelected(string filePath)
    
    color: "#2D2D2D"
    border.color: "#5050 50"
    border.width: 1
    radius: 5
    implicitHeight: 95
    
    FileDialog {
        id: fileDialog
        title: "Select 360° VR Video"
        nameFilters: ["360 Video (*.mp4 *.mkv)", "All files (*)"]
        
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
            spacing: 8
            
            Text {
                text: "360° VR Source"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Rectangle {
                visible: fileName !== ""
                width: 35
                height: 16
                color: "#00BCD4"
                radius: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "360°"
                    color: "white"
                    font.pixelSize: 8
                    font.bold: true
                }
            }
            
            Rectangle {
                visible: stereoMode === "stereo"
                width: 40
                height: 16
                color: "#9C27B0"
                radius: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "STEREO"
                    color: "white"
                    font.pixelSize: 7
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
                    text: fileName || "No 360° video selected"
                    color: fileName ? "#FFFFFF" : "#777777"
                    font.pixelSize: 12
                    font.bold: fileName !== ""
                    elide: Text.ElideMiddle
                }
                
                Text {
                    visible: fileName !== ""
                    text: "Projection: " + projectionType.charAt(0).toUpperCase() + projectionType.slice(1)
                    color: "#888888"
                    font.pixelSize: 10
                }
            }
            
            Button {
                width: 65
                height: 40
                text: "Browse..."
                
                background: Rectangle {
                    color: parent.hovered ? "#26C6DA" : "#00BCD4"
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
