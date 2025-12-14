import QtQuick
import QtQuick.Controls

// VideoStreamNetworkSettingsWidget - Network stream settings
// Used by: VideoStreamNetwork variant

Rectangle {
    id: root
    
    property int bufferSize: 2048
    property int timeout: 5000
    property bool autoReconnect: true
    property int reconnectDelay: 3
    
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
            text: "Network Stream Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Buffer Size:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 100
                model: ["512", "1024", "2048", "4096"]
                currentIndex: model.indexOf(bufferSize.toString())
                
                background: Rectangle {
                    color: parent.hovered ? "#3A3A3A" : "#2D2D2D"
                    border.color: "#555555"
                    border.width: 1
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.displayText + " KB"
                    color: "#FFFFFF"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 8
                }
                
                onCurrentTextChanged: bufferSize = parseInt(currentText)
            }
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Timeout:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 80
                model: ["3", "5", "10", "30"]
                currentIndex: model.indexOf((timeout/1000).toString())
                
                background: Rectangle {
                    color: parent.hovered ? "#3A3A3A" : "#2D2D2D"
                    border.color: "#555555"
                    border.width: 1
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.displayText + " s"
                    color: "#FFFFFF"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 8
                }
                
                onCurrentTextChanged: timeout = parseInt(currentText) * 1000
            }
        }
        
        CheckBox {
            text: "Auto-reconnect on disconnect"
            checked: autoReconnect
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: autoReconnect = checked
        }
    }
}
