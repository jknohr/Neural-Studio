import QtQuick
import QtQuick.Controls

// PatternSettingsWidget - Configure pattern generation  
// Ultra-specific name: pattern + settings + widget

Rectangle {
    id: root
    
    property string patternType: "checkerboard"
    property int patternSize: 32
    property color color1: "#000000"
    property color color2: "#FFFFFF"
    
    signal patternChanged()
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 130
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        Text {
            text: "Pattern Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Pattern:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
            }
            
            ComboBox {
                width: 150
                model: ["Checkerboard", "Grid", "Stripes", "Dots"]
                onCurrentTextChanged: {
                    patternType = currentText.toLowerCase()
                    patternChanged()
                }
            }
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Size:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
            }
            
            SpinBox {
                width: 100
                from: 4
                to: 256
                value: patternSize
                onValueChanged: {
                    patternSize = value
                    patternChanged()
                }
            }
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Colors:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
            }
            
            Rectangle {
                width: 60
                height: 30
                color: color1
                border.color: "#FFFFFF"
                border.width: 1
                radius: 3
            }
            
            Rectangle {
                width: 60
                height: 30
                color: color2
                border.color: "#FFFFFF"
                border.width: 1
                radius: 3
            }
        }
    }
}
