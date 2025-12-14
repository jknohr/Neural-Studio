import QtQuick
import QtQuick.Controls

// AudioStreamSourceSelectorWidget - Generic stream URL input
// Ultra-specific name: audio + stream + source + selector + widget  
// Used by: AudioStream variant (generic network stream)

Rectangle {
    id: root
    
    property string streamUrl: ""
    property string streamProtocol: "HTTP"  // HTTP, RTSP, RTP, etc.
    
    signal urlChanged(string newUrl)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 85
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        Text {
            text: "Stream Source"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        // Protocol selector
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Protocol:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                id: protocolCombo
                width: 120
                model: ["HTTP", "HTTPS", "RTSP", "RTP", "UDP"]
                currentIndex: 0
                
                onCurrentTextChanged: streamProtocol = currentText
            }
        }
        
        // URL input
        Row {
            width: parent.width
            spacing: 5
            
            TextField {
                id: urlField
                width: parent.width - 75
                placeholderText: "Enter stream URL..."
                text: streamUrl
                
                background: Rectangle {
                    color: "#1A1A1A"
                    border.color: urlField.activeFocus ? "#2196F3" : "#404040"
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
            
            Button {
                width: 65
                height: urlField.height
                text: "Connect"
                enabled: streamUrl.length > 0
                
                background: Rectangle {
                    color: parent.enabled ? (parent.hovered ? "#43A047" : "#388E3C") : "#555555"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
