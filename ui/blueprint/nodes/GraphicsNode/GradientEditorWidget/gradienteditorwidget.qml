import QtQuick
import QtQuick.Controls

// GradientEditorWidget - Configure gradient generation
// Ultra-specific name: gradient + editor + widget

Rectangle {
    id: root
    
    property string gradientType: "linear"
    property real angle: 0
    property color startColor: "#000000"
    property color endColor: "#FFFFFF"
    
    signal gradientChanged()
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 140
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        Text {
            text: "Gradient Editor"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Type:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
            }
            
            ComboBox {
                width: 150
                model: ["Linear", "Radial", "Conic"]
                onCurrentTextChanged: {
                    gradientType = currentText.toLowerCase()
                    gradientChanged()
                }
            }
        }
        
        Row {
            spacing: 10
            visible: gradientType === "linear"
            
            Text {
                text: "Angle:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
            }
            
            Slider {
                width: 120
                from: 0
                to: 360
                value: angle
                onValueChanged: {
                    angle = value
                    gradientChanged()
                }
            }
            
            Text {
                text: angle.toFixed(0) + "°"
                color: "#FFFFFF"
                font.pixelSize: 10
            }
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Start:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
            }
            
            Rectangle {
                width: 80
                height: 30
                color: startColor
                border.color: "#FFFFFF"
                border.width: 1
                radius: 3
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: colorDialog1.open()
                }
            }
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "End:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
            }
            
            Rectangle {
                width: 80
                height: 30
                color: endColor
                border.color: "#FFFFFF"
                border.width: 1
                radius: 3
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: colorDialog2.open()
                }
            }
        }
    }
}
