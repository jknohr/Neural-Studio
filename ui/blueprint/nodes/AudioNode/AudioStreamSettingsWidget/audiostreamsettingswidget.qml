import QtQuick
import QtQuick.Controls

// AudioStreamSettingsWidget - Generic stream settings (buffer, reconnect, latency)
// Ultra-specific name: audio + stream + settings + widget
// Used by: AudioStream variant (base stream settings)

Rectangle {
    id: root
    
    property int bufferSize: 2048  // samples
    property bool autoReconnect: true
    property int reconnectDelay: 5  // seconds
    property int latencyMs: 0
    
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
            text: "Stream Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        // Buffer size
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Buffer:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 120
                model: ["512", "1024", "2048", "4096", "8192"]
                currentIndex: 2
                
                onCurrentTextChanged: bufferSize = parseInt(currentText)
            }
            
            Text {
                text: "samples"
                color: "#777777"
                font.pixelSize: 9
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        // Auto reconnect
        CheckBox {
            text: "Auto-reconnect on disconnect"
            checked: autoReconnect
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: autoReconnect = checked
        }
        
        // Latency display
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Latency:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: latencyMs > 0 ? latencyMs + " ms" : "N/A"
                color: latencyMs > 100 ? "#FF9800" : "#4CAF50"
                font.pixelSize: 11
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
