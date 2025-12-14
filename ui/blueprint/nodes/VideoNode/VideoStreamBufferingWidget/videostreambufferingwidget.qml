import QtQuick
import QtQuick.Controls

// VideoStreamBufferingWidget - Stream buffering status and dropped frames
// Ultra-specific name: video + stream + buffering + widget
// Used by: All VideoStream variants

Rectangle {
    id: root
    
    // Properties
    property real bufferPercentage: 0.0  // 0.0 to 100.0
    property int bufferSize: 2048  // KB
    property int droppedFrames: 0
    property bool isBuffering: false
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 70
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6
        
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Buffer Status"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Text {
                visible: isBuffering
                text: "⏳ Buffering..."
                color: "#FF9800"
                font.pixelSize: 11
                font.bold: true
                
                SequentialAnimation on opacity {
                    running: isBuffering
                    loops: Animation.Infinite
                    NumberAnimation { from: 1.0; to: 0.4; duration: 500 }
                    NumberAnimation { from: 0.4; to: 1.0; duration: 500 }
                }
            }
        }
        
        // Buffer progress bar
        Rectangle {
            width: parent.width
            height: 20
            color: "#1A1A1A"
            border.color: "#404040"
            border.width: 1
            radius: 3
            
            Rectangle {
                width: (parent.width - 2) * (bufferPercentage / 100.0)
                height: parent.height - 2
                x: 1
                y: 1
                radius: 2
                color: {
                    if (bufferPercentage < 30) return "#F44336"
                    if (bufferPercentage < 60) return "#FF9800"
                    return "#4CAF50"
                }
                
                Behavior on width {
                    NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                }
            }
            
            Text {
                anchors.centerIn: parent
                text: bufferPercentage.toFixed(0) + "%"
                color: "#FFFFFF"
                font.pixelSize: 10
                font.bold: true
            }
        }
        
        // Stats row
        Row {
            width: parent.width
            spacing: 20
            
            Text {
                text: "Buffer: " + (bufferSize / 1024).toFixed(1) + " MB"
                color: "#CCCCCC"
                font.pixelSize: 10
            }
            
            Text {
                visible: droppedFrames > 0
                text: "🔻 Dropped: " + droppedFrames + " frames"
                color: "#F44336"
                font.pixelSize: 10
                font.bold: droppedFrames > 100
            }
        }
    }
}
