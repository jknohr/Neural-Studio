import QtQuick
import QtQuick.Controls

// VideoStreamNetworkSourceSelectorWidget - Network stream URL input with protocol selector
// Ultra-specific name: video + stream + network + source + selector + widget
// Used by: VideoStreamNetwork variant

Rectangle {
    id: root
    
    property string streamUrl: ""
    property string protocol: "RTSP"  // "RTSP", "HTTP-FLV", "HLS", "WebRTC"
    property int port: 554
    
    signal urlChanged(string url)
    signal connectToStream()
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 110
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6
        
        Text {
            text: "Network Stream Source"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        // Protocol selector
        Row {
            width: parent.width
            spacing: 8
            
            Text {
                text: "Protocol:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                id: protocolCombo
                width: 120
                model: ["RTSP", "HTTP-FLV", "HLS", "WebRTC"]
                currentIndex: {
                    switch(protocol) {
                        case "HTTP-FLV": return 1
                        case "HLS": return 2
                        case "WebRTC": return 3
                        default: return 0
                    }
                }
                
                background: Rectangle {
                    color: parent.hovered ? "#3A3A3A" : "#2D2D2D"
                    border.color: "#555555"
                    border.width: 1
                    radius: 3
                }
                
                contentItem: Text {
                    text: protocolCombo.displayText
                    color: "#FFFFFF"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 8
                }
                
                onCurrentIndexChanged: {
                    protocol = model[currentIndex]
                    // Update default port
                    switch(protocol) {
                        case "RTSP": port = 554; break
                        case "HTTP-FLV": port = 80; break
                        case "HLS": port = 80; break
                        case "WebRTC": port = 443; break
                    }
                }
            }
        }
        
        // URL input
        Row {
            width: parent.width
            spacing: 8
            
            Text {
                text: "URL:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Rectangle {
                width: parent.width - 40
                height: 30
                color: "#1A1A1A"
                border.color: "#404040"
                border.width: 1
                radius: 3
                
                TextInput {
                    id: urlInput
                    anchors.fill: parent
                    anchors.margins: 6
                    text: streamUrl
                    color: "#FFFFFF"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    selectByMouse: true
                    
                    onTextChanged: {
                        streamUrl = text
                        urlChanged(text)
                    }
                }
            }
        }
        
        // Connect button
        Button {
            width: 80
            height: 28
            text: "Connect"
            enabled: streamUrl !== ""
            
            background: Rectangle {
                color: parent.enabled ? (parent.hovered ? "#43A047" : "#388E3C") : "#555555"
                radius: 3
            }
            
            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: connectToStream()
        }
    }
}
