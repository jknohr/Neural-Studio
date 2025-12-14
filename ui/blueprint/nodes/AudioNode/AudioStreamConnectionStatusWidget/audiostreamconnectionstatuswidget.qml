import QtQuick
import QtQuick.Controls

// AudioStreamConnectionStatusWidget - Stream connection status indicator
// Ultra-specific name: audio + stream + connection + status + widget
// Used by: All AudioStream variants

Rectangle {
    id: root
    
    // Properties
    property string status: "disconnected"  // "connected", "connecting", "disconnected", "error"
    property string errorMessage: ""
    
    color: "#2D2D2D"
    border.color: statusColor
    border.width: 2
    radius: 5
    implicitHeight: 50
    
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
        anchors.margins: 10
        spacing: 10
        
        // Status indicator
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 16
            height: 16
            radius: 8
            color: statusColor
            
            // Pulsing animation when connecting
            SequentialAnimation on opacity {
                running: status === "connecting"
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 0.3; duration: 600 }
                NumberAnimation { from: 0.3; to: 1.0; duration: 600 }
            }
        }
        
        // Status text
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2
            
            Text {
                text: {
                    switch(status) {
                        case "connected": return "Connected"
                        case "connecting": return "Connecting..."
                        case "error": return "Connection Error"
                        default: return "Disconnected"
                    }
                }
                color: "white"
                font.pixelSize: 14
                font.bold: true
            }
            
            Text {
                visible: status === "error" && errorMessage !== ""
                text: errorMessage
                color: "#FFCCCC"
                font.pixelSize: 10
                elide: Text.ElideRight
                width: root.width - 60
            }
        }
    }
}
