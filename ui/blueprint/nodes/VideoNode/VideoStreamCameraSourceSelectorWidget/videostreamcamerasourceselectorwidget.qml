import QtQuick
import QtQuick.Controls

// VideoStreamCameraSourceSelectorWidget - Camera device picker for live camera feed
// Ultra-specific name: video + stream + camera + source + selector + widget
// Used by: VideoStreamCamera variant

Rectangle {
    id: root
    
    property string selectedDevice: ""
    property string deviceName: ""
    property int deviceIndex: 0
    property var availableDevices: []
    
    signal deviceSelected(string deviceId)
    signal refreshDevices()
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 75
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Camera Device"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Rectangle {
                visible: selectedDevice !== ""
                width: 40
                height: 16
                color: "#4CAF50"
                radius: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "LIVE"
                    color: "white"
                    font.pixelSize: 7
                    font.bold: true
                }
            }
        }
        
        Row {
            width: parent.width
            spacing: 10
            
            ComboBox {
                id: deviceCombo
                width: parent.width - 50
                model: availableDevices.length > 0 ? availableDevices : ["No cameras detected"]
                currentIndex: deviceIndex
                enabled: availableDevices.length > 0
                
                background: Rectangle {
                    color: parent.enabled ? (parent.hovered ? "#3A3A3A" : "#2D2D2D") : "#1A1A1A"
                    border.color: "#555555"
                    border.width: 1
                    radius: 3
                }
                
                contentItem: Text {
                    text: deviceCombo.displayText
                    color: deviceCombo.enabled ? "#FFFFFF" : "#777777"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 8
                    elide: Text.ElideRight
                }
                
                onCurrentIndexChanged: {
                    if (availableDevices.length > 0) {
                        deviceIndex = currentIndex
                        deviceName = availableDevices[currentIndex]
                        deviceSelected(currentIndex.toString())
                    }
                }
            }
            
            Button {
                width: 35
                height: 35
                text: "🔄"
                
                background: Rectangle {
                    color: parent.hovered ? "#555555" : "#3A3A3A"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: refreshDevices()
            }
        }
    }
}
