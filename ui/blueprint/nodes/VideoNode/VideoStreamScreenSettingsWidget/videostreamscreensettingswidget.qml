import QtQuick
import QtQuick.Controls

// VideoStreamScreenSettingsWidget - Screen capture settings
// Used by: VideoStreamScreen variant

Rectangle {
    id: root
    
    property int captureRate: 30
    property bool captureCursor: true
    property bool captureAudio: false
    property string audioSource: "system"
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 110
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6
        
        Text {
            text: "Screen Capture Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Capture Rate:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 80
                model: ["15", "30", "60"]
                currentIndex: model.indexOf(captureRate.toString())
                
                background: Rectangle {
                    color: parent.hovered ? "#3A3A3A" : "#2D2D2D"
                    border.color: "#555555"
                    border.width: 1
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.displayText + " fps"
                    color: "#FFFFFF"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 8
                }
                
                onCurrentTextChanged: captureRate = parseInt(currentText)
            }
        }
        
        CheckBox {
            text: "Show cursor in capture"
            checked: captureCursor
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: captureCursor = checked
        }
        
        CheckBox {
            text: "Capture system audio"
            checked: captureAudio
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: captureAudio = checked
        }
    }
}
