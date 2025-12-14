import QtQuick
import QtQuick.Controls

// AudioStreamMusicSourceSelectorWidget - Music stream URL input (Icecast, SHOUTcast, etc.)
// Ultra-specific name: audio + stream + music + source + selector + widget
// Used by: AudioStreamMusic variant

Rectangle {
    id: root
    
    property string streamUrl: ""
    property string stationName: ""
    property string genre: ""
    property int bitrate: 0
    
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
                text: "Music Stream"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Text {
                text: genre ? "♪ " + genre : ""
                color: "#AB47BC"
                font.pixelSize: 10
            }
            
            Text {
                text: bitrate > 0 ? bitrate + " kbps" : ""
                color: "#757575"
                font.pixelSize: 9
            }
        }
        
        TextField {
            id: urlField
            width: parent.width
            placeholderText: "Enter music stream URL (Icecast, SHOUTcast, etc.)..."
            text: streamUrl
            
            background: Rectangle {
                color: "#1A1A1A"
                border.color: urlField.activeFocus ? "#9C27B0" : "#404040"
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
        
        Text {
            width: parent.width
            text: stationName || "No stream connected"
            color: stationName ? "#FFFFFF" : "#777777"
            font.pixelSize: 11
            font.bold: true
            elide: Text.ElideRight
        }
    }
}
