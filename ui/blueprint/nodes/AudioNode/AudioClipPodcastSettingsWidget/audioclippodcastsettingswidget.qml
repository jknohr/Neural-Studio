import QtQuick
import QtQuick.Controls

// AudioClipPodcastSettingsWidget - Podcast-specific settings (chapters, skip silence, resume)
// Ultra-specific name: audio + clip + podcast + settings + widget
// Used by: AudioClipPodcast variant

Rectangle {
    id: root
    
    property bool showChapters: true
    property bool skipSilence: false
    property bool rememberPosition: true
    property real skipSilenceThreshold: -40  // dB
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 130
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        Text {
            text: "Podcast Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        CheckBox {
            text: "Show chapters"
            checked: showChapters
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: showChapters = checked
        }
        
        CheckBox {
            text: "Skip silence automatically"
            checked: skipSilence
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: skipSilence = checked
        }
        
        CheckBox {
            text: "Remember playback position"
            checked: rememberPosition
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: rememberPosition = checked
        }
        
        // Playback speed (podcasts often played faster)
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Speed:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 100
                model: ["0.75x", "1.0x", "1.25x", "1.5x", "1.75x", "2.0x"]
                currentIndex: 1
            }
        }
    }
}
