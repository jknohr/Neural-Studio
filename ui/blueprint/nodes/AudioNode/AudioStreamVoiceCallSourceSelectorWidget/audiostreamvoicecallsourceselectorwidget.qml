import QtQuick
import QtQuick.Controls

// AudioStreamVoiceCallSourceSelectorWidget - Microphone/VoIP input selector
// Ultra-specific name: audio + stream + voicecall + source + selector + widget
// Used by: AudioStreamVoiceCall variant

Rectangle {
    id: root
    
    property string selectedDevice: ""
    property string deviceType: "Microphone"  // or "VoIP"
    property bool noiseSuppressionEnabled: true
    
    signal deviceChanged(string deviceId)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 100
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        Text {
            text: "Voice Input Source"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        // Input type selector
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Type:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                id: inputTypeCombo
                width: 150
                model: ["Microphone", "VoIP (Discord/Zoom)", "Line In", "Virtual Cable"]
                currentIndex: 0
                
                onCurrentTextChanged: deviceType = currentText
            }
        }
        
        // Device selector
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Device:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                id: deviceCombo
                width: parent.width - 70
                model: ["Default Microphone", "Headset Mic", "USB Mic", "Line In"]
                currentIndex: 0
                
                onCurrentTextChanged: {
                    selectedDevice = currentText
                    deviceChanged(selectedDevice)
                }
            }
        }
        
        // Noise suppression toggle
        CheckBox {
            text: "Enable noise suppression"
            checked: noiseSuppressionEnabled
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: noiseSuppressionEnabled = checked
        }
    }
}
