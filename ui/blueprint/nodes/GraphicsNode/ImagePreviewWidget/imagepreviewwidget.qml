import QtQuick
import QtQuick.Controls

// ImagePreviewWidget - Main image/graphics preview with pan/zoom
// Ultra-specific name: image + preview + widget

Rectangle {
    id: root
    
    // Properties
    property string imageSource: ""
    property real currentZoom: 1.0
    property real minZoom: 0.1
    property real maxZoom: 10.0
    property bool showGrid: false
    property bool showTransparency: true
    
    // Signals
    signal zoomChanged(real newZoom)
    
    color: "#1A1A1A"
    clip: true
    implicitHeight: 400
    
    // Transparency checkerboard background
    Canvas {
        id: checkerboard
        visible: showTransparency
        anchors.fill: parent
        
        onPaint: {
            var ctx = getContext("2d")
            var squareSize = 16
            
            for (var y = 0; y < height; y += squareSize) {
                for (var x = 0; x < width; x += squareSize) {
                    var isEven = ((x / squareSize) + (y / squareSize)) % 2 === 0
                    ctx.fillStyle = isEven ? "#404040" : "#303030"
                    ctx.fillRect(x, y, squareSize, squareSize)
                }
            }
        }
    }
    
    // Flickable for panning
    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: imageContainer.width * currentZoom
        contentHeight: imageContainer.height * currentZoom
        clip: true
        
        // Center content initially
        Component.onCompleted: {
            contentX = (contentWidth - width) / 2
            contentY = (contentHeight - height) / 2
        }
        
        // Image container
        Item {
            id: imageContainer
            width: imageDisplay.implicitWidth
            height: imageDisplay.implicitHeight
            scale: currentZoom
            transformOrigin: Item.TopLeft
            
            Image {
                id: imageDisplay
                source: imageSource
                fillMode: Image.PreserveAspectFit
                smooth: true
                asynchronous: true
                cache: false
                
                // Loading indicator
                BusyIndicator {
                    anchors.centerIn: parent
                    running: imageDisplay.status === Image.Loading
                    visible: running
                }
            }
            
            // Grid overlay
            Canvas {
                id: gridOverlay
                visible: showGrid
                anchors.fill: parent
                
                onPaint: {
                    if (!visible) return
                    
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.strokeStyle = "#00FF00"
                    ctx.lineWidth = 1
                    
                    // Vertical third lines
                    var thirdW = width / 3
                    ctx.beginPath()
                    ctx.moveTo(thirdW, 0)
                    ctx.lineTo(thirdW, height)
                    ctx.moveTo(thirdW * 2, 0)
                    ctx.lineTo(thirdW * 2, height)
                    ctx.stroke()
                    
                    // Horizontal third lines
                    var thirdH = height / 3
                    ctx.beginPath()
                    ctx.moveTo(0, thirdH)
                    ctx.lineTo(width, thirdH)
                    ctx.moveTo(0, thirdH * 2)
                    ctx.lineTo(width, thirdH * 2)
                    ctx.stroke()
                }
                
                onVisibleChanged: requestPaint()
            }
        }
    }
    
    // Mouse wheel zoom
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        
        onWheel: {
            var zoomFactor = wheel.angleDelta.y > 0 ? 1.1 : 0.9
            var newZoom = Math.max(minZoom, Math.min(maxZoom, currentZoom * zoomFactor))
            
            if (newZoom !== currentZoom) {
                currentZoom = newZoom
                zoomChanged(currentZoom)
            }
        }
    }
    
    // Zoom controls overlay
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        spacing: 5
        
        Button {
            width: 30
            height: 30
            text: "−"
            
            background: Rectangle {
                color: parent.hovered ? "#555555" : "#3A3A3A"
                radius: 3
                opacity: 0.9
            }
            
            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: {
                currentZoom = Math.max(minZoom, currentZoom / 1.2)
                zoomChanged(currentZoom)
            }
        }
        
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(currentZoom * 100) + "%"
            color: "white"
            font.pixelSize: 12
            font.family: "monospace"
            
            Rectangle {
                anchors.fill: parent
                anchors.margins: -4
                color: "#000000"
                opacity: 0.7
                radius: 3
                z: -1
            }
        }
        
        Button {
            width: 30
            height: 30
            text: "+"
            
            background: Rectangle {
                color: parent.hovered ? "#555555" : "#3A3A3A"
                radius: 3
                opacity: 0.9
            }
            
            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: {
                currentZoom = Math.min(maxZoom, currentZoom * 1.2)
                zoomChanged(currentZoom)
            }
        }
        
        Button {
            width: 60
            height: 30
            text: "100%"
            
            background: Rectangle {
                color: parent.hovered ? "#555555" : "#3A3A3A"
                radius: 3
                opacity: 0.9
            }
            
            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: {
                currentZoom = 1.0
                zoomChanged(1.0)
            }
        }
    }
}
