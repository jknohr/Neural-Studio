import QtQuick
import QtQuick.Controls

// VideoStreamVR180SourceSelectorWidget - Dual camera source selector for 180° VR
// Ultra-specific name: video + stream + vr180 + source + selector + widget
// Used by: VideoStreamVR180 variant

Rectangle {
    id: root
    
    property string leftCamera: ""
    property string rightCamera: ""
    property var availableCameras: []
    property bool synchronized: false
    
    signal camerasSelected(string left, string right)
    signal refreshCameras()
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 115
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6
        
        Row {
            width: parent.width
            spacing: 8
            
            Text {
                text: "VR180 Camera Source"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Rectangle {
                visible: synchronized
                width: 40
                height: 16
                color: "#4CAF50"
                radius: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "SYNC"
                    color: "white"
                    font.pixelSize: 7
                    font.bold: true
                }
            }
        }
        
        // Left camera
        Row {
            width: parent.width
            spacing: 8
            
            Text {
                text: "Left 👁:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 50
            }
            
            ComboBox {
                width: parent.width - 100
                model: availableCameras.length > 0 ? availableCameras : ["No cameras"]
                enabled: availableCameras.length > 0
                
                background: Rectangle {
                    color: parent.enabled ? (parent.hovered ? "#3A3A3A" : "#2D2D2D") : "#1A1A1A"
                    border.color: "#555555"
                    border.width: 1
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.displayText
                    color: parent.enabled ? "#FFFFFF" : "#777777"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 8
                    elide: Text.ElideRight
                }
                
                onCurrentTextChanged: {
                    leftCamera = currentText
                    camerasSelected(leftCamera, rightCamera)
                }
            }
            
            Button {
                width: 35
                height: 30
                text: "🔄"
                
                background: Rectangle {
                    color: parent.hovered ? "#555555" : "#3A3A3A"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: refreshCameras()
            }
        }
        
        // Right camera
        Row {
            width: parent.width
            spacing: 8
            
            Text {
                text: "Right 👁:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 50
            }
            
            ComboBox {
                width: parent.width - 60
                model: availableCameras.length > 0 ? availableCameras : ["No cameras"]
                enabled: availableCameras.length > 0
                
                background: Rectangle {
                    color: parent.enabled ? (parent.hovered ? "#3A3A3A" : "#2D2D2D") : "#1A1A1A"
                    border.color: "#555555"
                    border.width: 1
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.displayText
                    color: parent.enabled ? "#FFFFFF" : "#777777"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 8
                    elide: Text.ElideRight
                }
                
                onCurrentTextChanged: {
                    rightCamera = currentText
                    camerasSelected(leftCamera, rightCamera)
                }
            }
        }
        
        Text {
            visible: leftCamera !== "" && leftCamera === rightCamera
            text: "⚠ Both cameras are the same!"
            color: "#FF5722"
            font.pixelSize: 9
            font.bold: true
        }
    }
}
