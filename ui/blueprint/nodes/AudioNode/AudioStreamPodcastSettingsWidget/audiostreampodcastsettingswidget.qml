import QtQuick
import QtQuick.Controls

// AudioStreamPodcastSettingsWidget - Podcast stream settings (live chapters, transcription)
// Ultra-specific name: audio + stream + podcast + settings + widget
// Used by: AudioStreamPodcast variant

Rectangle {
    id: root
    
    property bool showLiveChapters: true
    property bool autoGenerateTranscript: false
    property bool recordStream: false
    property bool speakerLabeling: false
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 120
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        Text {
            text: "Podcast Stream Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        CheckBox {
            text: "Show live chapters/segments"
            checked: showLiveChapters
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: showLiveChapters = checked
        }
        
        CheckBox {
            text: "Auto-generate transcript"
            checked: autoGenerateTranscript
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: autoGenerateTranscript = checked
        }
        
        CheckBox {
            text: "Speaker labeling (AI)"
            checked: speakerLabeling
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: speakerLabeling = checked
        }
        
        CheckBox {
            text: "Record stream"
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
    }
}
