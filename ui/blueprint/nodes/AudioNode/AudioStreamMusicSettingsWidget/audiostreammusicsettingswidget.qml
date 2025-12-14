import QtQuick
import QtQuick.Controls

// AudioStreamMusicSettingsWidget - Music stream settings (metadata, visualization, recording)
// Ultra-specific name: audio + stream + music + settings + widget
// Used by: AudioStreamMusic variant

Rectangle {
    id: root
    
    property bool showMetadata: true
    property bool saveMetadataHistory: true
    property bool recordStream: false
    property string recordPath: ""
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 110
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        Text {
            text: "Music Stream Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        CheckBox {
            text: "Display stream metadata (title, artist)"
            checked: showMetadata
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: showMetadata = checked
        }
        
        CheckBox {
            text: "Save metadata history"
            checked: saveMetadataHistory
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: saveMetadataHistory = checked
        }
        
        CheckBox {
            text: "Record stream to file"
            checked: recordStream
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: recordStream = checked
        }
        
        // Output format
        Row {
            visible: recordStream
            width: parent.width
            spacing: 10
            
            Text {
                text: "Format:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 100
                model: ["MP3", "AAC", "FLAC", "WAV"]
                currentIndex: 0
            }
        }
    }
}
