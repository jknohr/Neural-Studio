import QtQuick
import QtQuick.Controls

// VideoStereoscopicSideBySideWidget - Side-by-side stereo view
// Ultra-specific name: video + stereoscopic + sidebyside + widget

Rectangle {
    id: root
    
    property string leftEyeSource: ""
    property string rightEyeSource: ""
    property bool swapEyes: false
    
    color: "#000000"
    implicitHeight: 300
    
    Row {
        anchors.fill: parent
        spacing: 2
        
        // Left eye
        Rectangle {
            width: parent.width / 2 - 1
            height: parent.height
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
                text: "L"
                color: "#42A5F5"
                font.pixelSize: 20
                font.bold: true
            }
        }
        
        // Right eye
        Rectangle {
            width: parent.width / 2 - 1
            height: parent.height
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
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 8
                text: "R"
                color: "#E91E63"
                font.pixelSize: 20
                font.bold: true
            }
        }
    }
}
