import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

// VideoFileTutorialSourceSelectorWidget - Tutorial video file picker with chapter preview
// Ultra-specific name: video + file + tutorial + source + selector + widget
// Used by: VideoFileTutorial variant

Rectangle {
    id: root
    
    property string selectedFile: ""
    property string fileName: ""
    property int chapterCount: 0
    property real videoDuration: 0.0
    
    signal fileSelected(string filePath)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 90
    
    FileDialog {
        id: fileDialog
        title: "Select Tutorial Video"
        nameFilters: ["Video files (*.mp4 *.mkv *.webm)", "All files (*)"]
        
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
        
        Text {
            text: "Tutorial Source"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            width: parent.width
            spacing: 10
            
            Column {
                width: parent.width - 80
                spacing: 4
                
                Row {
                    spacing: 8
                    
                    Rectangle {
                        visible: fileName !== ""
                        width: 22
                        height: 22
                        color: "#FF6F00"
                        radius: 11
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            anchors.centerIn: parent
                            text: "🎓"
                            font.pixelSize: 14
                        }
                    }
                    
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: fileName || "No tutorial selected"
                        color: fileName ? "#FFFFFF" : "#777777"
                        font.pixelSize: 12
                        font.bold: fileName !== ""
                        elide: Text.ElideMiddle
                        width: parent.parent.width - 40
                    }
                }
                
                Row {
                    spacing: 15
                    visible: fileName !== ""
                    
                    Text {
                        text: chapterCount > 0 ? chapterCount + " chapters" : "No chapters"
                        color: chapterCount > 0 ? "#4CAF50" : "#888888"
                        font.pixelSize: 10
                    }
                    
                    Text {
                        visible: videoDuration > 0
                        text: formatDuration(videoDuration)
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
                    color: parent.hovered ? "#FF8A50" : "#FF6F00"
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
    
    function formatDuration(seconds) {
        var m = Math.floor(seconds / 60)
        var s = Math.floor(seconds % 60)
        return m + ":" + s.toString().padStart(2, '0')
    }
}
