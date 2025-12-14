import QtQuick
import QtQuick.Controls

// VideoFileStereoscopicSettingsWidget - 3D stereoscopic settings
// Used by: VideoFileStereoscopic variant

Rectangle {
    id: root
    
    property string stereoLayout: "sbs"
    property bool eyeSwap: false
    property real ipdAdjustment: 0.0  // -10 to +10 mm
    property real convergence: 0.0
    
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
            text: "3D Stereo Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            spacing: 10
            
           Text {
                text: "Layout:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 130
                model: ["Side-by-Side", "Top-Bottom"]
                currentIndex: stereoLayout === "tb" ? 1 : 0
                
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
                
                onCurrentTextChanged: stereoLayout = currentIndex === 1 ? "tb" : "sbs"
            }
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
        
        Row {
            spacing: 10
            
            Text {
                text: "IPD Adjust:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                id: ipdSlider
                width: 100
                from: -10
                to: 10
                value: ipdAdjustment
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
                
                onValueChanged: ipdAdjustment = value
            }
            
            Text {
                text: (ipdAdjustment >= 0 ? "+" : "") + ipdAdjustment.toFixed(1) + " mm"
                color: "#FFFFFF"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
