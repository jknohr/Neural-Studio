import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

// AudioClipPodcastSourceSelectorWidget - Podcast episode selector
// Ultra-specific name: audio + clip + podcast + source + selector + widget
// Used by: AudioClipPodcast variant

Rectangle {
    id: root
    
    property string selectedFile: ""
    property string episodeTitle: ""
    property string showName: ""
    property int episodeNumber: 0
    
    signal fileSelected(string filePath)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 80
    
    FileDialog {
        id: podcastFileDialog
        title: "Select Podcast Episode"
        nameFilters: ["Audio files (*.mp3 *.m4a *.ogg *.aac)", "All files (*)"]
        onAccepted: {
            selectedFile = podcastFileDialog.selectedFile.toString()
            episodeTitle = selectedFile.split('/').pop().split('\\').pop()
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
                text: "Podcast Episode"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Text {
                text: episodeNumber > 0 ? "EP " + episodeNumber : ""
                color: "#FF9800"
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
                    text: episodeTitle || "No episode selected"
                    color: episodeTitle ? "#FFFFFF" : "#777777"
                    font.pixelSize: 12
                    font.bold: true
                    elide: Text.ElideMiddle
                }
                
                Text {
                    text: showName || "Unknown Show"
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
                    color: parent.hovered ? "#FF6F00" : "#E65100"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: podcastFileDialog.open()
            }
        }
    }
}
