import QtQuick
import QtQuick.Controls

// AudioClipFXSettingsWidget - Sound effects settings (trigger mode, envelope, randomization)
// Ultra-specific name: audio + clip + fx + settings + widget
// Used by: AudioClipFX variant

Rectangle {
    id: root
    
    property string triggerMode: "OneShot"  // OneShot, Loop, Toggle
    property real attackMs: 0
    property real releaseMs: 50
    property bool randomizePitch: false
    property real pitchVariation: 0.05  // ±5%
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 140
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        Text {
            text: "FX Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        // Trigger mode
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Trigger:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                id: triggerCombo
                width: 120
                model: ["One-Shot", "Loop", "Toggle"]
                currentIndex: 0
                
                onCurrentTextChanged: triggerMode = currentText.replace("-", "")
            }
        }
        
        // Envelope settings
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Attack:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                width: 100
                from: 0
                to: 500
                value: attackMs
                stepSize: 10
                onValueChanged: attackMs = value
            }
            
            Text {
                text: attackMs.toFixed(0) + "ms"
                color: "#FFFFFF"
                font.pixelSize: 9
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Release:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                width: 100
                from: 0
                to: 1000
                value: releaseMs
                stepSize: 10
                onValueChanged: releaseMs = value
            }
            
            Text {
                text: releaseMs.toFixed(0) + "ms"
                color: "#FFFFFF"
                font.pixelSize: 9
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        // Pitch randomization
        CheckBox {
            text: "Randomize pitch (±" + (pitchVariation * 100).toFixed(0) + "%)"
            checked: randomizePitch
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: randomizePitch = checked
        }
    }
}
