import QtQuick
import QtQuick.Controls

// VideoFilePointCloudSettingsWidget - Point cloud rendering settings
// Used by: VideoFilePointCloud variant

Rectangle {
    id: root
    
    property real pointSize: 2.0
    property real density: 1.0
    property string renderMode: "points"
    property bool enable6DOF: true
    
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
            text: "Point Cloud Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Point Size:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                id: sizeSlider
                width: 100
                from: 0.5
                to: 10.0
                value: pointSize
                stepSize: 0.5
                
                background: Rectangle {
                    x: sizeSlider.leftPadding
                    y: sizeSlider.topPadding + sizeSlider.availableHeight / 2 - height / 2
                    width: sizeSlider.availableWidth
                    height: 4
                    radius: 2
                    color: "#404040"
                    
                    Rectangle {
                        width: sizeSlider.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color: "#00E676"
                    }
                }
                
                handle: Rectangle {
                    x: sizeSlider.leftPadding + sizeSlider.visualPosition * (sizeSlider.availableWidth - width)
                    y: sizeSlider.topPadding + sizeSlider.availableHeight / 2 - height / 2
                    width: 14
                    height: 14
                    radius: 7
                    color: "#00E676"
                }
                
                onValueChanged: pointSize = value
            }
            
            Text {
                text: pointSize.toFixed(1) + " px"
                color: "#FFFFFF"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Render Mode:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 120
                model: ["Points", "Splats", "Mesh"]
                currentIndex: renderMode === "splats" ? 1 : (renderMode === "mesh" ? 2 : 0)
                
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
                
                onCurrentTextChanged: renderMode = currentText.toLowerCase()
            }
        }
        
        CheckBox {
            text: "Enable 6DOF navigation"
            checked: enable6DOF
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: enable6DOF = checked
        }
    }
}
