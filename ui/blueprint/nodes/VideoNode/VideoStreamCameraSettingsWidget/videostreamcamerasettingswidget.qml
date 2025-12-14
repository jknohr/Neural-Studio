import QtQuick
import QtQuick.Controls

// VideoStreamCameraSettingsWidget - Live camera stream settings
// Used by: VideoStreamCamera variant

Rectangle {
    id: root
    
    property string resolution: "1920x1080"
    property int fps: 30
    property int exposure: 0
    property int whiteBalance: 4000
    property bool autoExposure: true
    property bool autoWhiteBalance: true
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 150
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6
        
        Text {
            text: "Camera Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Resolution:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 130
                model: ["640x480", "1280x720", "1920x1080", "3840x2160"]
                currentIndex: model.indexOf(resolution)
                
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
                
                onCurrentTextChanged: resolution = currentText
            }
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Frame Rate:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 80
                model: ["24", "30", "60", "120"]
                currentIndex: model.indexOf(fps.toString())
                
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
                
                onCurrentTextChanged: fps = parseInt(currentText)
            }
        }
        
        CheckBox {
            text: "Auto exposure"
            checked: autoExposure
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: autoExposure = checked
        }
        
        CheckBox {
            text: "Auto white balance"
            checked: autoWhiteBalance
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: autoWhiteBalance = checked
        }
    }
}
