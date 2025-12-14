import QtQuick
import QtQuick.Controls

// VideoFormatInfoWidget - Display codec, resolution, framerate, bitrate info
// Ultra-specific name: video + format + info + widget
// Used by: All VideoFile variants

Rectangle {
    id: root
    
    // Properties
    property string codec: "H.264"
    property string resolution: "1920x1080"
    property real fps: 30.0
    property int bitrate: 5000  // kbps
    property string colorSpace: "sRGB"
    property int audioCh annels: 2
    property int audioSampleRate: 48000
    
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
            text: "Format Info"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        // Video info
        Row {
            spacing: 15
            
            Column {
                spacing: 3
                
                Text {
                    text: "Codec"
                    color: "#888888"
                    font.pixelSize: 9
                }
                Text {
                    text: codec
                    color: "#FFFFFF"
                    font.pixelSize: 11
                    font.bold: true
                }
            }
            
            Column {
                spacing: 3
                
                Text {
                    text: "Resolution"
                    color: "#888888"
                    font.pixelSize: 9
                }
                Text {
                    text: resolution
                    color: "#FFFFFF"
                    font.pixelSize: 11
                    font.bold: true
                }
            }
            
            Column {
                spacing: 3
                
                Text {
                    text: "FPS"
                    color: "#888888"
                    font.pixelSize: 9
                }
                Text {
                    text: fps.toFixed(2)
                    color: "#4CAF50"
                    font.pixelSize: 11
                    font.bold: true
                }
            }
        }
        
        Row {
            spacing: 15
            
            Column {
                spacing: 3
                
                Text {
                    text: "Bitrate"
                    color: "#888888"
                    font.pixelSize: 9
                }
                Text {
                    text: (bitrate / 1000).toFixed(1) + " Mbps"
                    color: "#FFFFFF"
                    font.pixelSize: 11
                    font.bold: true
                }
            }
            
            Column {
                spacing: 3
                
                Text {
                    text: "Color Space"
                    color: "#888888"
                    font.pixelSize: 9
                }
                Text {
                    text: colorSpace
                    color: "#FFFFFF"
                    font.pixelSize: 11
                    font.bold: true
                }
            }
        }
        
        // Audio info
        Row {
            spacing: 15
            
            Column {
                spacing: 3
                
                Text {
                    text: "Audio"
                    color: "#888888"
                    font.pixelSize: 9
                }
                Text {
                    text: audioChannels + " ch @ " + (audioSampleRate / 1000) + " kHz"
                    color: "#2196F3"
                    font.pixelSize: 11
                    font.bold: true
                }
            }
        }
    }
}
