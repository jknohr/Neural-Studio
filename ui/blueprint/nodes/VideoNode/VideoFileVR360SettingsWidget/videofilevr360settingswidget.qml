import QtQuick
import QtQuick.Controls

// VideoFileVR360SettingsWidget - 360° VR video settings
// Used by: VideoFileVR360 variant

Rectangle {
    id: root
    
    property string projectionType: "equirectangular"
    property string stereoMode: "mono"
    property real fov: 110.0
    property bool enableHeadTracking: true
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 130
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6
        
        Text {
            text: "360° VR Settings"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Projection:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 140
                model: ["Equirectangular", "Cubemap"]
                currentIndex: projectionType === "cubemap" ? 1 : 0
                
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
                
                onCurrentTextChanged: projectionType = currentText.toLowerCase()
            }
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Stereo Mode:"
                color: "#CCCCCC"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 140
                model: ["Mono", "Top-Bottom", "Side-by-Side"]
                currentIndex: stereoMode === "tb" ? 1 : (stereoMode === "sbs" ? 2 : 0)
                
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
                    switch(currentIndex) {
                        case 1: stereoMode = "tb"; break
                        case 2: stereoMode = "sbs"; break
                        default: stereoMode = "mono"
                    }
                }
            }
        }
        
        CheckBox {
            text: "Enable head tracking"
            checked: enableHeadTracking
            
            contentItem: Text {
                text: parent.text
                color: "#CCCCCC"
                font.pixelSize: 10
                leftPadding: parent.indicator.width + 5
                verticalAlignment: Text.AlignVCenter
            }
            
            onCheckedChanged: enableHeadTracking = checked
        }
    }
}
