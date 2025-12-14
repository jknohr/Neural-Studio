import QtQuick
import QtQuick.Controls

// VideoKeyframeWidget - Keyframe management for video
// Ultra-specific name: video + keyframe + widget

Rectangle {
    id: root
    
    property var keyframes: []
    property real currentTime: 0.0
    
    signal addKeyframe(real time)
    signal removeKeyframe(int index)
    signal jumpToKeyframe(real time)
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 120
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6
        
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Keyframes"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Text {
                text: keyframes.length + " markers"
                color: "#888888"
                font.pixelSize: 10
            }
        }
        
        ScrollView {
            width: parent.width
            height: 60
            clip: true
            
            ListView {
                model: keyframes
                spacing: 3
                
                delegate: Rectangle {
                    width: parent ? parent.width : 0
                    height: 24
                    color: mouseArea.containsMouse ? "#3A3A3A" : "#2D2D2D"
                    radius: 3
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 8
                        
                        Rectangle {
                            width: 6
                            height: 6
                            radius: 3
                            color: "#FF9800"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Text {
                            text: modelData.toFixed(2) + "s"
                            color: "#FFFFFF"
                            font.pixelSize: 11
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Item { width: 1; height: 1; Layout.fillWidth: true }
                        
                        Button {
                            width: 20
                            height: 20
                            text: "×"
                            
                            background: Rectangle {
                                color: parent.hovered ? "#F44336" : "transparent"
                                radius: 2
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.pixelSize: 14
                                horizontalAlignment: Text.AlignHCenter
                            }
                            
                            onClicked: removeKeyframe(index)
                        }
                    }
                    
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: jumpToKeyframe(modelData)
                    }
                }
            }
        }
        
        Button {
            width: parent.width
            height: 28
            text: "+ Add Keyframe at Current Position"
            
            background: Rectangle {
                color: parent.hovered ? "#43A047" : "#388E3C"
                radius: 3
            }
            
            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: addKeyframe(currentTime)
        }
    }
}
