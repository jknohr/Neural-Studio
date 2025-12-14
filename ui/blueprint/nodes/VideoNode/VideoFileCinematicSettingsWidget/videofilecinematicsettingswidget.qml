import QtQuick
import QtQuick.Controls

// VideoFileCinematicSettingsWidget - Cinema file settings with color grading
// Used by: VideoFileCinematic variant

Rectangle {
    id: root
    
    property string colorSpace: "Rec.709"
    property bool hdrEnabled: false
    property string lunFile: ""
    property int bitDepth: 10
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 120
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6
        
        Text {
            text: "Cinema Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Color Space:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 120
                model: ["Rec.709", "Rec.2020", "DCI-P3", "sRGB"]
                currentIndex: model.indexOf(colorSpace)
                
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
                
                onCurrentTextChanged: colorSpace = currentText
            }
        }
        
        CheckBox {
            text: "HDR mode"
            checked: hdrEnabled
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: hdrEnabled = checked
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Bit Depth:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 80
                model: ["8", "10", "12", "16"]
                currentIndex: model.indexOf(bitDepth.toString())
                
                background: Rectangle {
                    color: parent.hovered ? "#3A3A3A" : "#2D2D2D"
                    border.color: "#555555"
                    border.width: 1
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.displayText + " bit"
                    color: "#FFFFFF"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 8
                }
                
                onCurrentTextChanged: bitDepth = parseInt(currentText)
            }
        }
    }
}
