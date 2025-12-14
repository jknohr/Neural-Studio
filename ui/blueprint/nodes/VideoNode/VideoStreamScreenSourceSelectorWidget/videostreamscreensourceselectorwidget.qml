import QtQuick
import QtQuick.Controls

// VideoStreamScreenSourceSelectorWidget - Screen/window capture region selector
// Ultra-specific name: video + stream + screen + source + selector + widget
// Used by: VideoStreamScreen variant

Rectangle {
    id: root
    
    property string captureMode: "fullscreen"  // "fullscreen", "window", "region"
    property string selectedMonitor: "Primary"
    property string selectedWindow: ""
    property bool captureCursor: true
    
    signal captureModeChanged(string mode)
    signal monitorSelected(string monitor)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 110
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6
        
        Text {
            text: "Screen Capture Source"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        // Capture mode selector
        Row {
            width: parent.width
            spacing: 8
            
            Text {
                text: "Mode:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                id: modeCombo
                width: 150
                model: ["Full Screen", "Window", "Region"]
                currentIndex: {
                    switch(captureMode) {
                        case "window": return 1
                        case "region": return 2
                        default: return 0
                    }
                }
                
                background: Rectangle {
                    color: parent.hovered ? "#3A3A3A" : "#2D2D2D"
                    border.color: "#555555"
                    border.width: 1
                    radius: 3
                }
                
                contentItem: Text {
                    text: modeCombo.displayText
                    color: "#FFFFFF"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 8
                }
                
                onCurrentIndexChanged: {
                    switch(currentIndex) {
                        case 1: captureMode = "window"; break
                        case 2: captureMode = "region"; break
                        default: captureMode = "fullscreen"
                    }
                    captureModeChanged(captureMode)
                }
            }
        }
        
        // Monitor/Window selector
        Row {
            width: parent.width
            spacing: 8
            
            Text {
                text: captureMode === "fullscreen" ? "Monitor:" : "Window:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 150
                model: captureMode === "fullscreen" ? ["Primary Monitor", "Monitor 2", "Monitor 3"] : ["Selected Window", "Browser", "Terminal"]
                
                background: Rectangle {
                    color: parent.hovered ? "#3A3A3A" : "#2D2D2D"
                    border.color: "#555555"
                    border.width: 1
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.displayText
                    color: "#FFFFFF"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 8
                }
            }
        }
        
        // Options
        CheckBox {
            text: "Capture cursor"
            checked: captureCursor
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: captureCursor = checked
        }
    }
}
