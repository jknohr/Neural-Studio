import QtQuick
import QtQuick.Controls

// VideoIPDAdjustmentWidget - Interpupillary distance adjustment for VR
// Ultra-specific name: video + ipd + adjustment + widget

Rectangle {
    id: root
    
    property real ipd: 65.0  // mm
    property real minIPD: 55.0
    property real maxIPD: 75.0
    
    signal ipdChanged(real newIPD)
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 100
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        Text {
            text: "IPD Adjustment"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        // IPD slider
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "👁 IPD 👁"
                color: "#CCCCCC"
                font.pixelSize: 14
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                id: ipdSlider
                width: parent.width - 150
                from: minIPD
                to: maxIPD
                value: ipd
                stepSize: 0.5
                
                background: Rectangle {
                    x: ipdSlider.leftPadding
                    y: ipdSlider.topPadding + ipdSlider.availableHeight / 2 - height / 2
                    width: ipdSlider.availableWidth
                    height: 8
                    radius: 4
                    color: "#404040"
                    
                    Rectangle {
                        width: ipdSlider.visualPosition * parent.width
                        height: parent.height
                        radius: 4
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#42A5F5" }
                            GradientStop { position: 1.0; color: "#E91E63" }
                        }
                    }
                }
                
                handle: Rectangle {
                    x: ipdSlider.leftPadding + ipdSlider.visualPosition * (ipdSlider.availableWidth - width)
                    y: ipdSlider.topPadding + ipdSlider.availableHeight / 2 - height / 2
                    width: 20
                    height: 20
                    radius: 10
                    color: ipdSlider.pressed ? "#FFFFFF" : "#9C27B0"
                    border.color: "#FFFFFF"
                    border.width: 2
                }
                
                onValueChanged: {
                    ipd = value
                    ipdChanged(ipd)
                }
            }
            
            Text {
                text: ipd.toFixed(1)
                color: "#FFFFFF"
                font.pixelSize: 16
                font.bold: true
                font.family: "monospace"
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: "mm"
                color: "#888888"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        // Quick presets
        Row {
            width: parent.width
            spacing: 8
            
            Repeater {
                model: [
                    { label: "Narrow", value: 58 },
                    { label: "Average", value: 65 },
                    { label: "Wide", value: 72 }
                ]
                
                Button {
                    width: 70
                    height: 24
                    text: modelData.label
                    
                    background: Rectangle {
                        color: Math.abs(ipd - modelData.value) < 1 ? "#9C27B0" : (parent.hovered ? "#555555" : "#3A3A3A")
                        radius: 3
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 9
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        ipd = modelData.value
                        ipdChanged(ipd)
                    }
                }
            }
        }
    }
}
