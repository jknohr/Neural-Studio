import QtQuick
import QtQuick.Controls

// VideoVolumeControlWidget - Audio volume control for video
// Ultra-specific name: video + volume + control + widget
// Used by: ALL video variants

Rectangle {
    id: root
    
    // Properties
    property real volume: 1.0  // 0.0 to 1.0
    property bool muted: false
    
    // Signals
    signal volumeChanged(real newVolume)
    signal muteToggled(bool isMuted)
    
    color: "transparent"
    implicitHeight: 45
    implicitWidth: 200
    
    Row {
        anchors.fill: parent
        spacing: 8
        
        // Mute button
        Button {
            id: muteBtn
            width: 40
            height: 40
            anchors.verticalCenter: parent.verticalCenter
            
            background: Rectangle {
                color: muted ? "#F44336" : (muteBtn.hovered ? "#555555" : "#3A3A3A")
                radius: 4
                border.color: muted ? "#E57373" : "#606060"
                border.width: 1
            }
            
            contentItem: Text {
                text: muted ? "🔇" : (volume > 0.5 ? "🔊" : "🔉")
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: {
                muted = !muted
                muteToggled(muted)
            }
        }
        
        // Volume slider
        Column {
            width: parent.width - 56
            anchors.verticalCenter: parent.verticalCenter
            spacing: 3
            
            Text {
                text: "Volume: " + Math.round(volume * 100) + "%"
                color: "#CCCCCC"
                font.pixelSize: 10
            }
            
            Slider {
                id: volumeSlider
                width: parent.width
                from: 0.0
                to: 1.0
                value: volume
                stepSize: 0.01
                enabled: !muted
                
                background: Rectangle {
                    x: volumeSlider.leftPadding
                    y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                    width: volumeSlider.availableWidth
                    height: 6
                    radius: 3
                    color: "#404040"
                    
                    Rectangle {
                        width: volumeSlider.visualPosition * parent.width
                        height: parent.height
                        radius: 3
                        color: muted ? "#777777" : "#2196F3"
                    }
                }
                
                handle: Rectangle {
                    x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                    y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                    width: 16
                    height: 16
                    radius: 8
                    color: muted ? "#888888" : (volumeSlider.pressed ? "#64B5F6" : "#2196F3")
                    border.color: "#BBDEFB"
                    border.width: volumeSlider.hovered ? 2 : 1
                }
                
                onValueChanged: {
                    if (!muted) {
                        volume = value
                        volumeChanged(volume)
                    }
                }
            }
        }
    }
}
