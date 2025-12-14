import QtQuick
import QtQuick.Controls

// VideoFileSettingsWidget - Generic video file settings
// Ultra-specific name: video + file + settings + widget
// Used by: VideoFile variant

Rectangle {
    id: root
    
    property bool autoPlay: false
    property bool loop: false
    property real playbackSpeed: 1.0
    property int startFrame: 0
    property int endFrame: -1
    
    signal settingsChanged()
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 140
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        Text {
            text: "Playback Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        CheckBox {
            text: "Auto-play on load"
            checked: autoPlay
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: {
                autoPlay = checked
                settingsChanged()
            }
        }
        
        CheckBox {
            text: "Loop playback"
            checked: loop
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: {
                loop = checked
                settingsChanged()
            }
        }
        
        // Playback speed
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Speed:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                id: speedSlider
                width: 120
                from: 0.25
                to: 2.0
                value: playbackSpeed
                stepSize: 0.25
                
                background: Rectangle {
                    x: speedSlider.leftPadding
                    y: speedSlider.topPadding + speedSlider.availableHeight / 2 - height / 2
                    width: speedSlider.availableWidth
                    height: 4
                    radius: 2
                    color: "#404040"
                    
                    Rectangle {
                        width: speedSlider.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color: "#2196F3"
                    }
                }
                
                handle: Rectangle {
                    x: speedSlider.leftPadding + speedSlider.visualPosition * (speedSlider.availableWidth - width)
                    y: speedSlider.topPadding + speedSlider.availableHeight / 2 - height / 2
                    width: 14
                    height: 14
                    radius: 7
                    color: speedSlider.pressed ? "#64B5F6" : "#2196F3"
                }
                
                onValueChanged: {
                    playbackSpeed = value
                    settingsChanged()
                }
            }
            
            Text {
                text: playbackSpeed.toFixed(2) + "x"
                color: "#FFFFFF"
                font.pixelSize: 11
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
