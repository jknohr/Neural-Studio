import QtQuick
import QtQuick.Controls

// AudioClipSettingsWidget - Settings panel for AudioClip variant
// Ultra-specific name: audio + clip + settings + widget
// Used by: AudioClip variant (base settings)

Rectangle {
    id: root
    
    // Properties
    property bool autoPlay: false
    property bool loop: false
    property real playbackSpeed: 1.0
    property string outputDevice: "Default"
    
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
            text: "Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        // Auto play option
        CheckBox {
            id: autoPlayCheck
            text: "Auto-play on load"
            checked: autoPlay
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 11
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: autoPlay = checked
        }
        
        // Loop option
        CheckBox {
            id: loopCheck
            text: "Loop playback"
            checked: loop
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 11
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: loop = checked
        }
        
        // Playback speed
        Row {
            spacing: 10
            
            Text {
                text: "Speed:"
                color: "#CCCCCC"
                font.pixelSize: 11
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                id: speedSlider
                from: 0.5
                to: 2.0
                value: playbackSpeed
                stepSize: 0.1
                width: 150
                
                onValueChanged: playbackSpeed = value
            }
            
            Text {
                text: playbackSpeed.toFixed(1) + "x"
                color: "#FFFFFF"
                font.pixelSize: 11
                font.family: "monospace"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
