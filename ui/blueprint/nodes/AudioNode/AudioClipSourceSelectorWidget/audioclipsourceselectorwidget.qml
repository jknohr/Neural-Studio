import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

// AudioClipSourceSelectorWidget - File picker for audio clips
// Ultra-specific name: audio + clip + source + selector + widget
// Used by: AudioClip variant (generic file playback)

Rectangle {
    id: root
    
    // Properties
    property string selectedFile: ""
    property string fileName: ""
    
    // Signals
    signal fileSelected(string filePath)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 60
    
    FileDialog {
        id: fileDialog
        title: "Select Audio File"
        nameFilters: ["Audio files (*.mp3 *.wav *.ogg *.flac *.m4a *.aac)", "All files (*)"]
        
        onAccepted: {
            selectedFile = fileDialog.selectedFile.toString()
            // Extract filename from path
            fileName = selectedFile.split('/').pop().split('\\').pop()
            fileSelected(selectedFile)
        }
    }
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        Text {
            text: "Audio Source"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            width: parent.width
            spacing: 10
            
            Rectangle {
                width: parent.width - 80
                height: 25
                color: "#1A1A1A"
                border.color: "#404040"
                border.width: 1
                radius: 3
                
                Text {
                    anchors.fill: parent
                    anchors.margins: 5
                    text: fileName || "No file selected"
                    color: fileName ? "#FFFFFF" : "#777777"
                    font.pixelSize: 11
                    elide: Text.ElideMiddle
                    verticalAlignment: Text.AlignVCenter
                }
            }
            
            Button {
                width: 65
                height: 25
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
