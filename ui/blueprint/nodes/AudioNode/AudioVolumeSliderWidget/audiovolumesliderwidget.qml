import QtQuick
import QtQuick.Controls

// AudioVolumeSliderWidget - Volume control slider
// Ultra-specific name: audio + volume + slider + widget
// Used by: ALL audio variants

Rectangle {
    id: root
    
    // Properties
    property real volume: 1.0  // 0.0 to 1.0
    
    // Signals
    signal volumeChanged(real newVolume)
    
    color: "transparent"
    implicitHeight: 40
    
    Column {
        anchors.fill: parent
        spacing: 5
        
        // Label
        Text {
            text: "Volume: " + Math.round(volume * 100) + "%"
            color: "#CCCCCC"
            font.pixelSize: 11
        }
        
        // Slider
        Slider {
            id: volumeSlider
            width: parent.width
            from: 0.0
            to: 1.0
            value: volume
            stepSize: 0.01
            
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
                    color: "#2196F3"
                }
            }
            
            handle: Rectangle {
                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                width: 18
                height: 18
                radius: 9
                color: volumeSlider.pressed ? "#64B5F6" : "#2196F3"
                border.color: "#BBDEFB"
                border.width: volumeSlider.hovered ? 2 : 1
            }
            
            onValueChanged: {
                volume = value
                volumeChanged(volume)
            }
        }
    }
}
