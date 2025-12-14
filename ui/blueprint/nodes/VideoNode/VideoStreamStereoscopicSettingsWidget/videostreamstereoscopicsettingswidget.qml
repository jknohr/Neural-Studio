import QtQuick
import QtQuick.Controls

// VideoStreamStereoscopicSettingsWidget - Live 3D stereoscopic stream settings
// Used by: VideoStreamStereoscopic variant

Rectangle {
    id: root
    
    property real ipd: 65.0
    property bool hardwareSync: false
    property real convergence: 0.0
    property bool eyeSwap: false
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 130
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6
        
        Text {
            text: "3D Stereo Stream Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "IPD:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                id: ipdSlider
                width: 100
                from: 55
                to: 75
                value: ipd
                stepSize: 0.5
                
                background: Rectangle {
                    x: ipdSlider.leftPadding
                    y: ipdSlider.topPadding + ipdSlider.availableHeight / 2 - height / 2
                    width: ipdSlider.availableWidth
                    height: 4
                    radius: 2
                    color: "#404040"
                    
                    Rectangle {
                        width: ipdSlider.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color: "#E91E63"
                    }
                }
                
                handle: Rectangle {
                    x: ipdSlider.leftPadding + ipdSlider.visualPosition * (ipdSlider.availableWidth - width)
                    y: ipdSlider.topPadding + ipdSlider.availableHeight / 2 - height / 2
                    width: 14
                    height: 14
                    radius: 7
                    color: "#E91E63"
                }
                
                onValueChanged: ipd = value
            }
            
            Text {
                text: ipd.toFixed(1) + " mm"
                color: "#FFFFFF"
                font.pixelSize: 11
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        CheckBox {
            text: "Hardware frame sync"
            checked: hardwareSync
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: hardwareSync = checked
        }
        
        CheckBox {
            text: "Swap left/right eyes"
            checked: eyeSwap
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: eyeSwap = checked
        }
    }
}
