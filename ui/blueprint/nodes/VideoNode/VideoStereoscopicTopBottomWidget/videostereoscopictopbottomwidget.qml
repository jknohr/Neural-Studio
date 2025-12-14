import QtQuick
import QtQuick.Controls

// VideoStereoscopicTopBottomWidget - Top-bottom stereo view
// Ultra-specific name: video + stereoscopic + topbottom + widget

Rectangle {
    id: root
    
    property string leftEyeSource: ""
    property string rightEyeSource: ""
    property bool swapEyes: false
    
    color: "#000000"
    implicitHeight: 400
    
    Column {
        anchors.fill: parent
        spacing: 2
        
        // Top (left eye)
        Rectangle {
            width: parent.width
            height: parent.height / 2 - 1
            color: "#0A0A0A"
            border.color: "#42A5F5"
            border.width: 2
            
            Image {
                anchors.fill: parent
                anchors.margins: 2
                source: swapEyes ? rightEyeSource : leftEyeSource
                fillMode: Image.PreserveAspectFit
            }
            
            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 8
                text: "L (Top)"
                color: "#42A5F5"
                font.pixelSize: 16
                font.bold: true
            }
        }
        
        // Bottom (right eye)
        Rectangle {
            width: parent.width
            height: parent.height / 2 - 1
            color: "#0A0A0A"
            border.color: "#E91E63"
            border.width: 2
            
            Image {
                anchors.fill: parent
                anchors.margins: 2
                source: swapEyes ? leftEyeSource : rightEyeSource
                fillMode: Image.PreserveAspectFit
            }
            
            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 8
                text: "R (Bottom)"
                color: "#E91E63"
                font.pixelSize: 16
                font.bold: true
            }
        }
    }
}
