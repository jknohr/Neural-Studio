import QtQuick
import QtQuick.Controls

// VideoFramePreviewWidget - Current frame display with aspect ratio control
// Ultra-specific name: video + frame + preview + widget
// Used by: ALL video variants

Rectangle {
    id: root
    
    // Properties
    property string frameSource: ""  // Image/frame source
    property real aspectRatio: 16/9
    property bool maintainAspectRatio: true
    property int currentFrameNumber: 0
    property string resolution: "1920x1080"
    property real fps: 30.0
    
    color: "#000000"
    implicitHeight: 300
    implicitWidth: maintainAspectRatio ? implicitHeight * aspectRatio : 400
    
    // Frame display
    Rectangle {
        id: frameContainer
        anchors.centerIn: parent
        width: maintainAspectRatio ? (parent.width > parent.height * aspectRatio ? parent.height * aspectRatio : parent.width) : parent.width
        height: maintainAspectRatio ? (width / aspectRatio) : parent.height
        color: "#1A1A1A"
        border.color: "#404040"
        border.width: 1
        
        // Placeholder for actual video frame (would be replaced by VideoOutput or custom renderer)
        Image {
            id: frameImage
            anchors.fill: parent
            source: frameSource
            fillMode: Image.PreserveAspectFit
            smooth: true
            
            // Placeholder text when no frame
            Text {
                visible: frameSource === ""
                anchors.centerIn: parent
                text: "No Video Frame\\n" + resolution + " @ " + fps.toFixed(2) + " fps"
                color: "#666666"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
            }
        }
        
        // Overlay info
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 8
            width: infoText.width + 16
            height: infoText.height + 8
            color: "#000000"
            opacity: 0.7
            radius: 3
            visible: frameSource !== ""
            
            Text {
                id: infoText
                anchors.centerIn: parent
                text: "Frame: " + currentFrameNumber + " | " + resolution
                color: "#FFFFFF"
                font.pixelSize: 10
                font.family: "monospace"
            }
        }
        
        // Aspect ratio indicator
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 8
            width: aspectText.width + 12
            height: aspectText.height + 6
            color: "#2196F3"
            opacity: 0.8
            radius: 3
            
            Text {
                id: aspectText
                anchors.centerIn: parent
                text: aspectRatio.toFixed(2) + ":1"
                color: "#FFFFFF"
                font.pixelSize: 9
                font.bold: true
            }
        }
    }
    
    // Grid overlay (filmmakers' tool)
    Canvas {
        id: gridOverlay
        anchors.fill: frameContainer
        opacity: 0.3
        visible: false  // Can be toggled
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.strokeStyle = "#FFFFFF"
            ctx.lineWidth = 1
            
            // Rule of thirds grid
            ctx.beginPath()
            // Vertical lines
            ctx.moveTo(width / 3, 0)
            ctx.lineTo(width / 3, height)
            ctx.moveTo(2 * width / 3, 0)
            ctx.lineTo(2 * width / 3, height)
            // Horizontal lines
            ctx.moveTo(0, height / 3)
            ctx.lineTo(width, height / 3)
            ctx.moveTo(0, 2 * height / 3)
            ctx.lineTo(width, 2 * height / 3)
            ctx.stroke()
        }
    }
}
