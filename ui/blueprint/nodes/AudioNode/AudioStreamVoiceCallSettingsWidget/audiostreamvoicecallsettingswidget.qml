import QtQuick
import QtQuick.Controls

// AudioStreamVoiceCallSettingsWidget - Voice/mic stream settings (noise gate, PTT, voice activity)
// Ultra-specific name: audio + stream + voicecall + settings + widget
// Used by: AudioStreamVoiceCall variant

Rectangle {
    id: root
    
    property bool noiseGateEnabled: true
    property real noiseGateThreshold: -40  // dB
    property bool pushToTalkEnabled: false
    property string pttKey: "Space"
    property bool voiceActivityDetection: true
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 150
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        Text {
            text: "Voice Call Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        // Noise gate
        Row {
            width: parent.width
            spacing: 10
            
            CheckBox {
                id: noiseGateCheck
                text: "Noise gate"
                checked: noiseGateEnabled
                
                contentItem: Text {
                    text: parent.text
                    color: "#CCCCCC"
                    font.pixelSize: 10
                    leftPadding: parent.indicator.width + 5
                    verticalAlignment: Text.AlignVCenter
                }
                
                onCheckedChanged: noiseGateEnabled = checked
            }
            
            Text {
                visible: noiseGateEnabled
                text: noiseGateThreshold.toFixed(0) + " dB"
                color: "#FFFFFF"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        // Push-to-talk
        Row {
            width: parent.width
            spacing: 10
            
            CheckBox {
                id: pttCheck
                text: "Push-to-talk"
                checked: pushToTalkEnabled
                
                contentItem: Text {
                    text: parent.text
                    color: "#CCCCCC"
                    font.pixelSize: 10
                    leftPadding: parent.indicator.width + 5
                    verticalAlignment: Text.AlignVCenter
                }
                
                onCheckedChanged: pushToTalkEnabled = checked
            }
            
            Button {
                visible: pushToTalkEnabled
                width: 80
                height: 24
                text: "Key: " + pttKey
                
                background: Rectangle {
                    color: parent.hovered ? "#555555" : "#3A3A3A"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 9
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
        
        // Voice activity detection
        CheckBox {
            text: "Voice activity detection"
            checked: voiceActivityDetection
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: voiceActivityDetection = checked
        }
        
        // Echo cancellation
        CheckBox {
            text: "Echo cancellation"
            checked: true
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
