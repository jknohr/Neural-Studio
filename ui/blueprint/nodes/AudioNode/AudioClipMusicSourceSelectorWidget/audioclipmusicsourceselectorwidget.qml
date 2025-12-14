import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

// AudioClipMusicSourceSelectorWidget - Music library browser/file picker
// Ultra-specific name: audio + clip + music + source + selector + widget
// Used by: AudioClipMusic variant

Rectangle {
    id: root
    
    property string selectedFile: ""
    property string trackTitle: ""
    property string artist: ""
    property string bpm: ""
    
    signal fileSelected(string filePath)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 80
    
    FileDialog {
        id: musicFileDialog
        title: "Select Music Track"
        nameFilters: ["Music files (*.mp3 *.wav *.flac *.m4a *.aac *.ogg)", "All files (*)"]
        onAccepted: {
            selectedFile = musicFileDialog.selectedFile.toString()
            trackTitle = selectedFile.split('/').pop().split('\\').pop()
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
                text: "Music Track"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Text {
                text: bpm ? "♪ " + bpm + " BPM" : ""
                color: "#4CAF50"
                font.pixelSize: 10
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
                    text: trackTitle || "No track selected"
                    color: trackTitle ? "#FFFFFF" : "#777777"
                    font.pixelSize: 12
                    font.bold: true
                    elide: Text.ElideMiddle
                }
                
                Text {
                    text: artist || "Unknown Artist"
                    color: "#AAAAAA"
                    font.pixelSize: 10
                    elide: Text.ElideRight
                }
            }
            
            Button {
                width: 65
                height: 35
                text: "Browse..."
                
                background: Rectangle {
                    color: parent.hovered ? "#7C4DFF" : "#6200EA"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: musicFileDialog.open()
            }
        }
    }
}
