import QtQuick
import QtQuick.Controls
import "../../app"

// FloatingPreviewWindow - Draggable, resizable source preview
// Can be positioned anywhere in the preview area
Rectangle {
    id: floatingPreview
    
    property string sourceId: ""
    property string sourceName: ""
    property string sourceType: "video"  // video, audio, 3d, etc.
    
    signal closeRequested()
    
    color: "#1a1a1a"
    border.width: 1
    border.color: dragArea.containsMouse ? "#4a9eff" : "#444"
    radius: 4
    
    implicitWidth: 200
    implicitHeight: 120
    
    // Drag to move
    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: floatingPreview
        hoverEnabled: true
    }
    
    // Preview content area
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        anchors.bottomMargin: 24
        color: "#000"
        radius: 3
        
        // Placeholder - actual preview rendered here
        Label {
            anchors.centerIn: parent
            text: sourceName || "Source"
            color: "#444"
            font.pixelSize: 11
        }
    }
    
    // Bottom bar with name
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 24
        color: "#252525"
        radius: 4
        
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 4
            color: parent.color
        }
        
        Label {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: sourceName
            color: "#888"
            font.pixelSize: 10
            elide: Text.ElideRight
        }
    }
    
    // Close button
    ToolButton {
        width: 20
        height: 20
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 2
        
        onClicked: closeRequested()
        
        MaterialIcon {
            anchors.centerIn: parent
            icon: "close"
            size: 12
            color: parent.hovered ? "#fff" : "#888"
        }
    }
    
    // Resize handle (bottom-right)
    MouseArea {
        id: resizeHandle
        width: 16
        height: 16
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        cursorShape: Qt.SizeFDiagCursor
        
        property point startPos
        property size startSize
        
        onPressed: (mouse) => {
            startPos = Qt.point(mouse.x, mouse.y)
            startSize = Qt.size(floatingPreview.width, floatingPreview.height)
        }
        
        onPositionChanged: (mouse) => {
            if (pressed) {
                floatingPreview.width = Math.max(120, startSize.width + mouse.x - startPos.x)
                floatingPreview.height = Math.max(80, startSize.height + mouse.y - startPos.y)
            }
        }
        
        // Visual indicator
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.strokeStyle = "#444"
                ctx.lineWidth = 1
                ctx.beginPath()
                ctx.moveTo(width, 0)
                ctx.lineTo(0, height)
                ctx.moveTo(width, 6)
                ctx.lineTo(6, height)
                ctx.stroke()
            }
        }
    }
}
