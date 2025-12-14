import QtQuick
import QtQuick.Controls

// VideoCameraControlsWidget - PTZ camera controls
// Ultra-specific name: video + camera + controls + widget

Rectangle {
    id: root
    
    property real pan: 0.0
    property real tilt: 0.0
    property real zoom: 1.0
    property bool isPTZ: false
    
    signal panTiltChanged(real newPan, real newTilt)
    signal zoomChanged(real newZoom)
    signal resetPosition()
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 150
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        Row {
            spacing: 10
            
            Text {
                text: "PTZ Controls"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Rectangle {
                visible: isPTZ
                width: 30
                height: 16
                color: "#4CAF50"
                radius: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "PTZ"
                    color: "white"
                    font.pixelSize: 7
                    font.bold: true
                }
            }
        }
        
        // Pan/Tilt joystick
        Rectangle {
            width: 100
            height: 100
            color: "#1A1A1A"
            border.color: "#404040"
            border.width: 1
            radius: 50
            
            // Center crosshair
            Rectangle {
                anchors.centerIn: parent
                width: 2
                height: parent.height
                color: "#555555"
            }
            Rectangle {
                anchors.centerIn: parent
                width: parent.width
                height: 2
                color: "#555555"
            }
            
            // Position indicator
            Rectangle {
                id: indicator
                width: 10
                height: 10
                radius: 5
                color: "#2196F3"
                x: parent.width / 2 + (pan / 180) * (parent.width / 2) - width / 2
                y: parent.height / 2 - (tilt / 90) * (parent.height / 2) - height / 2
            }
            
            MouseArea {
                anchors.fill: parent
                
                onPressed: updatePanTilt(mouse.x, mouse.y)
                onPositionChanged: if (pressed) updatePanTilt(mouse.x, mouse.y)
                
                function updatePan Tilt(x, y) {
                    var centerX = parent.width / 2
                    var centerY = parent.height / 2
                    var radius = parent.width / 2
                    
                    var dx = x - centerX
                    var dy = centerY - y
                    
                    var distance = Math.sqrt(dx * dx + dy * dy)
                    if (distance > radius) {
                        dx = (dx / distance) * radius
                        dy = (dy / distance) * radius
                    }
                    
                    pan = (dx / radius) * 180
                    tilt = (dy / radius) * 90
                    
                    panTiltChanged(pan, tilt)
                }
            }
        }
        
        // Zoom control
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Zoom:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                id: zoomSlider
                width: parent.width - 100
                from: 1.0
                to: 10.0
                value: zoom
                stepSize: 0.1
                
                onValueChanged: {
                    zoom = value
                    zoomChanged(zoom)
                }
            }
            
            Text {
                text: zoom.toFixed(1) + "x"
                color: "#FFFFFF"
                font.pixelSize: 11
                font.bold: true
            }
        }
        
        // Reset button
        Button {
            width: parent.width
            height: 24
            text: "Reset Position"
            
            background: Rectangle {
                color: parent.hovered ? "#555555" : "#3A3A3A"
                radius: 3
            }
            
            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: {
                pan = 0
                tilt = 0
                zoom = 1.0
                resetPosition()
            }
        }
    }
}
