import QtQuick
import QtQuick.Controls

// AudioClipTimelineScrubberWidget - Timeline scrubber with loop points
// Ultra-specific name: audio + clip + timeline + scrubber + widget
// Used by: All AudioClip variants

Rectangle {
    id: root
    
    // Properties
    property real duration: 100.0  // Total duration in seconds
    property real position: 0.0    // Current position in seconds
    property real loopStart: 0.0   // Loop start in seconds
    property real loopEnd: duration  // Loop end in seconds
    property bool loopEnabled: false
    
    // Signals
    signal positionChanged(real newPosition)
    signal loopStartChanged(real newStart)
    signal loopEndChanged(real newEnd)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 80
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        // Header row
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Timeline"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            CheckBox {
                id: loopCheckbox
                text: "Loop"
                checked: loopEnabled
                
                contentItem: Text {
                    text: parent.text
                    color: "#AAAAAA"
                    font.pixelSize: 10
                    leftPadding: parent.indicator.width + 5
                    verticalAlignment: Text.AlignVCenter
                }
                
                onCheckedChanged: loopEnabled = checked
            }
            
            Text {
                text: formatTime(position) + " / " + formatTime(duration)
                color: "#CCCCCC"
                font.pixelSize: 10
                font.family: "monospace"
            }
        }
        
        // Timeline display
        Rectangle {
            width: parent.width
            height: 40
            color: "#1A1A1A"
            border.color: "#404040"
            border.width: 1
            radius: 3
            
            // Loop region highlight
            Rectangle {
                visible: loopEnabled
                x: (loopStart / duration) * parent.width
                width: ((loopEnd - loopStart) / duration) * parent.width
                height: parent.height
                color: "#2196F3"
                opacity: 0.2
                radius: 3
            }
            
            // Waveform placeholder (simplified bars)
            Row {
                anchors.fill: parent
                anchors.margins: 2
                spacing: 2
                
                Repeater {
                    model: 50
                    Rectangle {
                        width: (parent.width - 49 * 2) / 50
                        height: parent.height * (0.3 + Math.random() * 0.7)
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#4CAF50"
                        opacity: 0.3
                    }
                }
            }
            
            // Position indicator
            Rectangle {
                x: (position / duration) * parent.width - 1
                width: 2
                height: parent.height
                color: "#FF5722"
                
                Rectangle {
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 8
                    height: 8
                    radius: 4
                    color: "#FF5722"
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
    
    // Helper function to format time
    function formatTime(seconds) {
        var mins = Math.floor(seconds / 60)
        var secs = Math.floor(seconds % 60)
        return mins.toString().padStart(2, '0') + ":" + secs.toString().padStart(2, '0')
    }
}
