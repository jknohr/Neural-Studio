import QtQuick
import QtQuick.Controls

// VideoStreamConnectionStatusWidget - Live stream connection status indicator
// Ultra-specific name: video + stream + connection + status + widget
// Used by: All VideoStream variants

Rectangle {
    id: root
    
    // Properties
    property string status: "disconnected"  // "connected", "connecting", "disconnected", "error"
    property string errorMessage: ""
    property int droppedFrames: 0
    property int latencyMs: 0
    
    color: "#2D2D2D"
    border.color: statusColor
    border.width: 2
    radius: 5
    implicitHeight: 60
    
    property color statusColor: {
        switch(status) {
            case "connected": return "#4CAF50"
            case "connecting": return "#FF9800"
            case "error": return "#F44336"
            default: return "#757575"
        }
    }
    
    Row {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12
        
        // Status indicator with pulsing animation
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 20
            height: 20
            radius: 10
            color: statusColor
            
            SequentialAnimation on opacity {
                running: status === "connecting"
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 0.3; duration: 600 }
                NumberAnimation { from: 0.3; to: 1.0; duration: 600 }
            }
            
            // Inner glow for connected state
            Rectangle {
                visible: status === "connected"
                anchors.centerIn: parent
                width: 12
                height: 12
                radius: 6
                color: "#FFFFFF"
                opacity: 0.4
            }
        }
        
        // Status text and details
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 3
            
            Text {
                text: {
                    switch(status) {
                        case "connected": return "● LIVE"
                        case "connecting": return "Connecting..."
                        case "error": return "Connection Error"
                        default: return "Offline"
                    }
                }
                color: "#FFFFFF"
                font.pixelSize: 14
                font.bold: true
            }
            
            Row {
                spacing: 15
                visible: status === "connected"
                
                Text {
                    text: "Latency: " + latencyMs + "ms"
                    color: latencyMs > 100 ? "#FF9800" : "#4CAF50"
                    font.pixelSize: 10
                }
                
                Text {
                    visible: droppedFrames > 0
                    text: "Dropped: " + droppedFrames
                    color: "#F44336"
                    font.pixelSize: 10
                }
            }
            
            Text {
                visible: status === "error" && errorMessage !== ""
                text: errorMessage
                color: "#FFCCCC"
                font.pixelSize: 10
                elide: Text.ElideRight
                width: root.width - 80
            }
        }
    }
}
