import QtQuick
import QtQuick.Controls

// VideoTimelineWidget - Timeline scrubber with in/out points and keyframes
// Ultra-specific name: video + timeline + widget
// Used by: All VideoFile variants

Rectangle {
    id: root
    
    // Properties
    property real duration: 100.0  // Total duration in seconds
    property real position: 0.0    // Current position in seconds
    property real inPoint: 0.0     // In point for trimming
    property real outPoint: duration  // Out point for trimming
    property var keyframes: []     // Array of keyframe positions
    
    // Signals
    signal positionChanged(real newPosition)
    signal inPointChanged(real newIn)
    signal outPointChanged(real newOut)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 80
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        // Header
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Timeline"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Item { width: 1; height: 1 }
            
            Text {
                text: formatTime(position) + " / " + formatTime(duration)
                color: "#FFFFFF"  
                font.pixelSize: 11
                font.family: "monospace"
            }
            
            Item { Layout.fillWidth: true }
            
            Text {
                text: "In: " + formatTime(inPoint) + " | Out: " + formatTime(outPoint)
                color: "#4CAF50"
                font.pixelSize: 9
                font.family: "monospace"
            }
        }
        
        // Timeline track
        Rectangle {
            width: parent.width
            height: 50
            color: "#1A1A1A"
            border.color: "#404040"
            border.width: 1
            radius: 3
            
            // In/Out region highlight
            Rectangle {
                x: (inPoint / duration) * parent.width
                width: ((outPoint - inPoint) / duration) * parent.width
                height: parent.height
                color: "#2196F3"
                opacity: 0.15
                radius: 3
            }
            
            // Keyframe markers
            Repeater {
                model: keyframes
                
                Rectangle {
                    x: (modelData / duration) * parent.width - 2
                    y: parent.height - 8
                    width: 4
                    height: 8
                    color: "#FF9800"
                    
                    Rectangle {
                        width: 8
                        height: 8
                        x: -2
                        y: -4
                        rotation: 45
                        color: "#FF9800"
                    }
                }
            }
            
            // Position indicator
            Rectangle {
                x: (position / duration) * parent.width - 1
                width: 2
                height: parent.height
                color: "#FF5722"
                z: 10
                
                Rectangle {
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 10
                    height: 10
                    radius: 5
                    color: "#FF5722"
                    border.color: "#FFFFFF"
                    border.width: 1
                }
            }
            
            // In point marker
            Rectangle {
                x: (inPoint / duration) * parent.width - 1
                width: 2
                height: parent.height
                color: "#4CAF50"
                
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: 6
                    height: 6
                    color: "#4CAF50"
                }
            }
            
            // Out point marker
            Rectangle {
                x: (outPoint / duration) * parent.width - 1
                width: 2
                height: parent.height
                color: "#4CAF50"
                
                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    width: 6
                    height: 6
                    color: "#4CAF50"
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var newPos = (mouseX / width) * duration
                    position = newPos
                    positionChanged(newPos)
                }
            }
        }
    }
    
    // Helper function
    function formatTime(seconds) {
        var h = Math.floor(seconds / 3600)
        var m = Math.floor((seconds % 3600) / 60)
        var s = Math.floor(seconds % 60)
        var ms = Math.floor((seconds % 1) * 100)
        
        if (h > 0) {
            return h.toString().padStart(2, '0') + ":" + 
                   m.toString().padStart(2, '0') + ":" + 
                   s.toString().padStart(2, '0')
        }
        return m.toString().padStart(2, '0') + ":" + 
               s.toString().padStart(2, '0') + "." + 
               ms.toString().padStart(2, '0')
    }
}
