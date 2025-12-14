import QtQuick
import QtQuick.Controls

// VideoFrameSeekerWidget - Frame-by-frame navigation controls
// Ultra-specific name: video + frame + seeker + widget
// Used by: All VideoFile variants

Rectangle {
    id: root
    
    // Properties
    property int currentFrame: 0
    property int totalFrames: 3000
    property real fps: 30.0
    
    // Signals
    signal frameChanged(int newFrame)
    signal previousFrame()
    signal nextFrame()
    signal jumpToFrame(int frame)
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 65
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        // Frame counter and input
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Frame:"
                color: "#AAAAAA"
                font.pixelSize: 11
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Rectangle {
                width: 100
                height: 28
                color: "#1A1A1A"
                border.color: "#404040"
                border.width: 1
                radius: 3
                
                TextInput {
                    id: frameInput
                    anchors.fill: parent
                    anchors.margins: 6
                    text: currentFrame.toString()
                    color: "#FFFFFF"
                    font.pixelSize: 12
                    font.family: "monospace"
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    validator: IntValidator { bottom: 0; top: totalFrames }
                    
                    onAccepted: {
                        var frame = parseInt(text)
                        if (frame >= 0 && frame <= totalFrames) {
                            currentFrame = frame
                            jumpToFrame(frame)
                        }
                    }
                }
            }
            
            Text {
                text: "/ " + totalFrames
                color: "#777777"
                font.pixelSize: 11
                font.family: "monospace"
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: "@ " + fps.toFixed(2) + " fps"
                color: "#888888"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        // Frame navigation buttons
        Row {
            spacing: 8
            
            Button {
                width: 35
                height: 28
                text: "<<10"
                
                background: Rectangle {
                    color: parent.hovered ? "#555555" : "#3A3A3A"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 9
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    currentFrame = Math.max(0, currentFrame - 10)
                    jumpToFrame(currentFrame)
                }
            }
            
            Button {
                width: 30
                height: 28
                text: "◀"
                
                background: Rectangle {
                    color: parent.hovered ? "#555555" : "#3A3A3A"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    if (currentFrame > 0) {
                        currentFrame--
                        previousFrame()
                    }
                }
            }
            
            Button {
                width: 30
                height: 28
                text: "▶"
                
                background: Rectangle {
                    color: parent.hovered ? "#555555" : "#3A3A3A"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    if (currentFrame < totalFrames) {
                        currentFrame++
                        nextFrame()
                    }
                }
            }
            
            Button {
                width: 35
                height: 28
                text: "10>>"
                
                background: Rectangle {
                    color: parent.hovered ? "#555555" : "#3A3A3A"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 9
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    currentFrame = Math.min(totalFrames, currentFrame + 10)
                    jumpToFrame(currentFrame)
                }
            }
        }
    }
}
