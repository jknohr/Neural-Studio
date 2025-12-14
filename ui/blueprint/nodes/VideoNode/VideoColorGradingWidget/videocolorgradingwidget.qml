import QtQuick
import QtQuick.Controls

// VideoColorGradingWidget - Color grading controls
// Ultra-specific name: video + color + grading + widget

Rectangle {
    id: root
    
    property real lift: 0.0
    property real gamma: 1.0
    property real gain: 1.0
    property real saturation: 1.0
    property real hue: 0.0
    
    signal gradingChanged()
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 200
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        Text {
            text: "Color Grading"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        // Lift
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Lift:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                id: liftSlider
                width: parent.width - 120
                from: -1.0
                to: 1.0
                value: lift
                stepSize: 0.01
                
                onValueChanged: {
                    lift = value
                    gradingChanged()
                }
            }
            
            Text {
                text: lift.toFixed(2)
                color: "#FFFFFF"
                font.pixelSize: 10
                width: 40
            }
        }
        
        // Gamma
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Gamma:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                width: parent.width - 120
                from: 0.1
                to: 3.0
                value: gamma
                stepSize: 0.01
                
                onValueChanged: {
                    gamma = value
                    gradingChanged()
                }
            }
            
            Text {
                text: gamma.toFixed(2)
                color: "#FFFFFF"
                font.pixelSize: 10
                width: 40
            }
        }
        
        // Gain
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Gain:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                width: parent.width - 120
                from: 0.0
                to: 2.0
                value: gain
                stepSize: 0.01
                
                onValueChanged: {
                    gain = value
                    gradingChanged()
                }
            }
            
            Text {
                text: gain.toFixed(2)
                color: "#FFFFFF"
                font.pixelSize: 10
                width: 40
            }
        }
        
        // Saturation
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Saturation:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                width: parent.width - 120
                from: 0.0
                to: 2.0
                value: saturation
                stepSize: 0.01
                
                onValueChanged: {
                    saturation = value
                    gradingChanged()
                }
            }
            
            Text {
                text: saturation.toFixed(2)
                color: "#FFFFFF"
                font.pixelSize: 10
                width: 40
            }
        }
    }
}
