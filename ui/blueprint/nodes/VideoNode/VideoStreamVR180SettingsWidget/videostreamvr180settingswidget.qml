import QtQuick
import QtQuick.Controls

// VideoStreamVR180SettingsWidget - VR180 stream settings
// Used by: VideoStreamVR180 variant

Rectangle {
    id: root
    
    property real ipd: 65.0
    property bool stereoAlignment: true
    property string previewMode: "sbs"
    property bool syncFrames: true
    
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
            text: "VR180 Stream Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "IPD:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                id: ipdSlider
                width: 100
                from: 55
                to: 75
                value: ipd
                stepSize: 0.5
                
                background: Rectangle {
                    x: ipdSlider.leftPadding
                    y: ipdSlider.topPadding + ipdSlider.availableHeight / 2 - height / 2
                    width: ipdSlider.availableWidth
                    height: 4
                    radius: 2
                    color: "#404040"
                    
                    Rectangle {
                        width: ipdSlider.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color: "#9C27B0"
                    }
                }
                
                handle: Rectangle {
                    x: ipdSlider.leftPadding + ipdSlider.visualPosition * (ipdSlider.availableWidth - width)
                    y: ipdSlider.topPadding + ipdSlider.availableHeight / 2 - height / 2
                    width: 14
                    height: 14
                    radius: 7
                    color: "#9C27B0"
                }
                
                onValueChanged: ipd = value
            }
            
            Text {
                text: ipd.toFixed(1) + " mm"
                color: "#FFFFFF"
                font.pixelSize: 11
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        CheckBox {
            text: "Enable stereo alignment"
            checked: stereoAlignment
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: stereoAlignment = checked
        }
        
        CheckBox {
            text: "Sync camera frames"
            checked: syncFrames
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: syncFrames = checked
        }
    }
}
