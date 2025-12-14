import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

// VideoFileSourceSelectorWidget - File picker for generic video files
// Ultra-specific name: video + file + source + selector + widget
// Used by: VideoFile variant

Rectangle {
    id: root
    
    // Properties
    property string selectedFile: ""
    property string fileName: ""
    property string fileFormat: ""
    property int fileSizeBytes: 0
    
    // Signals
    signal fileSelected(string filePath)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 70
    
    FileDialog {
        id: fileDialog
        title: "Select Video File"
        nameFilters: ["Video files (*.mp4 *.mkv *.webm *.avi *.mov *.mpeg *.flv)", "All files (*)"]
        
        onAccepted: {
            selectedFile = fileDialog.selectedFile.toString()
            fileName = selectedFile.split('/').pop().split('\\').pop()
            // Extract format from extension
            var parts = fileName.split('.')
            fileFormat = parts.length > 1 ? parts.pop().toUpperCase() : "UNKNOWN"
            fileSelected(selectedFile)
        }
    }
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        Text {
            text: "Video Source"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            width: parent.width
            spacing: 10
            
            Rectangle {
                width: parent.width - 80
                height: 30
                color: "#1A1A1A"
                border.color: "#404040"
                border.width: 1
                radius: 3
                
                Row {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 8
                    
                    Rectangle {
                        visible: fileName !== ""
                        width: 24
                        height: 18
                        color: "#2196F3"
                        radius: 2
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            anchors.centerIn: parent
                            text: fileFormat
                            color: "white"
                            font.pixelSize: 7
                            font.bold: true
                        }
                    }
                    
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: fileName || "No file selected"
                        color: fileName ? "#FFFFFF" : "#777777"
                        font.pixelSize: 11
                        elide: Text.ElideMiddle
                        width: parent.width - 50
                    }
                }
            }
            
            Button {
                width: 65
                height: 30
                text: "Browse..."
                
                background: Rectangle {
                    color: parent.hovered ? "#42A5F5" : "#2196F3"
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
