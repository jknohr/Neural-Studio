import QtQuick
import QtQuick.Controls

// VideoFileTutorialSettingsWidget - Tutorial video settings
// Used by: VideoFileTutorial variant

Rectangle {
    id: root
    
    property bool showChapters: true
    property bool skipSilence: false
    property real skipThreshold: 0.1
    property real defaultSpeed: 1.0
    
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
            text: "Tutorial Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        CheckBox {
            text: "Show chapter markers"
            checked: showChapters
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: showChapters = checked
        }
        
        CheckBox {
            text: "Auto-skip silence"
            checked: skipSilence
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: skipSilence = checked
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Default Speed:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 80
                model: ["0.75x", "1.0x", "1.25x", "1.5x", "2.0x"]
                currentIndex: 1
                
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
                
                onCurrentTextChanged: {
                    defaultSpeed = parseFloat(currentText.replace("x", ""))
                }
            }
        }
    }
}
