import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// StatusBar - Bottom status bar with CPU, time, FPS
Rectangle {
    id: statusBar
    
    color: "#1a1a1a"
    implicitHeight: 24
    
    property real cpuUsage: 0.0
    property string elapsedTime: "00:00:00"
    property real fps: 30.0
    property real targetFps: 30.0
    property bool isRecording: false
    property bool isStreaming: false
    
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 16
        
        // CPU usage
        Label {
            text: "CPU: " + cpuUsage.toFixed(1) + "%"
            color: cpuUsage > 80 ? "#ff4444" : "#666"
            font.pixelSize: 10
        }
        
        // Status indicators
        Row {
            spacing: 8
            visible: isRecording || isStreaming
            
            Rectangle {
                visible: isRecording
                width: 8; height: 8; radius: 4
                color: "#ff0000"
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Rectangle {
                visible: isStreaming
                width: 8; height: 8; radius: 4
                color: "#00ff00"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        Item { Layout.fillWidth: true }
        
        // Elapsed time
        Label {
            text: elapsedTime
            color: "#666"
            font.pixelSize: 10
            font.family: "monospace"
        }
        
        // FPS
        Label {
            text: fps.toFixed(2) + " / " + targetFps.toFixed(2) + " FPS"
            color: fps < targetFps * 0.9 ? "#ffaa00" : "#666"
            font.pixelSize: 10
        }
    }
}
