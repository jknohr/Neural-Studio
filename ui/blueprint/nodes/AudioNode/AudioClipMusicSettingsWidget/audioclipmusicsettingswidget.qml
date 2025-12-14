import QtQuick
import QtQuick.Controls

// AudioClipMusicSettingsWidget - Music-specific settings (BPM, key, loop regions)
// Ultra-specific name: audio + clip + music + settings + widget
// Used by: AudioClipMusic variant

Rectangle {
    id: root
    
    property real bpmDetected: 0
    property string keyDetected: ""
    property bool autoBpmDetection: true
    property bool syncToMasterClock: false
    
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
            text: "Music Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        // BPM detection
        Row {
            width: parent.width
            spacing: 10
            
            CheckBox {
                id: bpmDetectCheck
                text:  "Auto-detect BPM"
                checked: autoBpmDetection
                
                contentItem: Text {
                    text: parent.text
                    color: "#CCCCCC"
                    font.pixelSize: 10
                    leftPadding: parent.indicator.width + 5
                    verticalAlignment: Text.AlignVCenter
                }
                
                onCheckedChanged: autoBpmDetection = checked
            }
            
            Text {
                visible: bpmDetected > 0
                text: "♪ " + bpmDetected.toFixed(1) + " BPM"
                color: "#4CAF50"
                font.pixelSize: 11
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        // Key detection
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Key:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: keyDetected || "Not detected"
                color: keyDetected ? "#FFFFFF" : "#777777"
                font.pixelSize: 11
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        // Sync to master clock
        CheckBox {
            text: "Sync to master clock"
            checked: syncToMasterClock
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: syncToMasterClock = checked
        }
        
        // Beat snap
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Beat snap:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                id: beatSnapCombo
                width: 120
                model: ["Off", "1/4", "1/8", "1/16", "1/32"]
                currentIndex: 0
            }
        }
    }
}
