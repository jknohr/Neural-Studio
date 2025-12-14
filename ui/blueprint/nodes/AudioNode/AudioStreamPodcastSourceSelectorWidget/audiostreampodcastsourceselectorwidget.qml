import QtQuick
import QtQuick.Controls

// AudioStreamPodcastSourceSelectorWidget - Podcast stream URL input (RSS feed, live stream)
// Ultra-specific name: audio + stream + podcast + source + selector + widget
// Used by: AudioStreamPodcast variant

Rectangle {
    id: root
    
    property string streamUrl: ""
    property string showName: ""
    property string currentEpisode: ""
    property bool isLive: false
    
    signal urlChanged(string newUrl)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 95
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Podcast Stream"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Rectangle {
                visible: isLive
                width: 45
                height: 16
                radius: 3
                color: "#F44336"
                
                Text {
                    anchors.centerIn: parent
                    text: "LIVE"
                    color: "white"
                    font.pixelSize: 9
                    font.bold: true
                }
            }
        }
        
        TextField {
            id: urlField
            width: parent.width
            placeholderText: "Enter podcast stream URL or RSS feed..."
            text: streamUrl
            
            background: Rectangle {
                color: "#1A1A1A"
                border.color: urlField.activeFocus ? "#FF6F00" : "#404040"
                border.width: 1
                radius: 3
            }
            
            color: "#FFFFFF"
            font.pixelSize: 10
            
            onTextChanged: {
                streamUrl = text
                urlChanged(streamUrl)
            }
        }
        
        Column {
            width: parent.width
            spacing: 2
            
            Text {
                width: parent.width
                text: showName || "No podcast connected"
                color: showName ? "#FFFFFF" : "#777777"
                font.pixelSize: 11
                font.bold: true
                elide: Text.ElideRight
            }
            
            Text {
                visible: currentEpisode.length > 0
                width: parent.width
                text: currentEpisode
                color: "#AAAAAA"
                font.pixelSize: 9
                elide: Text.ElideRight
            }
        }
    }
}
