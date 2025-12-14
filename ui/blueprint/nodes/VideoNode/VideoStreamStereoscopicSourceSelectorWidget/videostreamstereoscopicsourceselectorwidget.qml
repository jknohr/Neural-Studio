import QtQuick
import QtQuick.Controls

// VideoStreamStereoscopicSourceSelectorWidget - Dual camera selector for live 3D streaming
// Ultra-specific name: video + stream + stereoscopic + source + selector + widget
// Used by: VideoStreamStereoscopic variant

Rectangle {
    id: root
    
    property string leftCamera: ""
    property string rightCamera: ""
    property var availableCameras: []
    property bool hardwareSync: false
    property real ipd: 65.0  // mm
    
    signal camerasSelected(string left, string right)
    signal refreshCameras()
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 130
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6
        
        Row {
            width: parent.width
            spacing: 8
            
            Text {
                text: "3D Stereo Camera Source"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Rectangle {
                visible: hardwareSync
                width: 50
                height: 16
                color: "#4CAF50"
                radius: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "HW SYNC"
                    color: "white"
                    font.pixelSize: 7
                    font.bold: true
                }
            }
        }
        
        // Left eye camera
        Row {
            width: parent.width
            spacing: 8
            
            Text {
                text: "Left 👁:"
                color: "#42A5F5"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 50
                font.bold: true
            }
            
            ComboBox {
                width: parent.width - 100
                model: availableCameras.length > 0 ? availableCameras : ["No cameras"]
                enabled: availableCameras.length > 0
                
                background: Rectangle {
                    color: parent.enabled ? (parent.hovered ? "#3A3A3A" : "#2D2D2D") : "#1A1A1A"
                    border.color: "#42A5F5"
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
        
        // Right eye camera
        Row {
            width: parent.width
            spacing: 8
            
            Text {
                text: "Right 👁:"
                color: "#E91E63"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 50
                font.bold: true
            }
            
            ComboBox {
                width: parent.width - 60
                model: availableCameras.length > 0 ? availableCameras : ["No cameras"]
                enabled: availableCameras.length > 0
                
                background: Rectangle {
                    color: parent.enabled ? (parent.hovered ? "#3A3A3A" : "#2D2D2D") : "#1A1A1A"
                    border.color: "#E91E63"
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
        
        // IPD display
        Row {
            spacing: 10
            
            Text {
                text: "IPD:"
                color: "#888888"
                font.pixelSize: 10
            }
            
            Text {
                text: ipd.toFixed(1) + " mm"
                color: "#FFFFFF"
                font.pixelSize: 10
                font.bold: true
            }
        }
    }
}
