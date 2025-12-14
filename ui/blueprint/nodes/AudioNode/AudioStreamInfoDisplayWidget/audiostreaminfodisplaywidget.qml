import QtQuick

// AudioStreamInfoDisplayWidget - Display stream technical information
// Ultra-specific name: audio + stream + info + display + widget
// Used by: All AudioStream variants
// Shows: Codec, bitrate, sample rate, channel count

Rectangle {
    id: audiostreaminfodisplaywidget
    objectName: "audiostreaminfodisplaywidget"
    
    // Properties from stream
    property string codec: "Unknown"
    property int bitrate: 0  // kbps
    property int sampleRate: 0  // Hz
    property int channelCount: 0  // Can be 1 (mono), 2 (stereo), 6 (5.1), up to 192 (Opus multi-source)
    property string channelLayout: ""  // e.g. "Stereo", "5.1 Surround", "192 Opus Mics"
    
    color: "#2D2D2D"
    border.color: "#404040"
    border.width: 1
    radius: 5
    height: 100
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        Text {
            text: "Stream Information"
            color: "white"
            font.pixelSize: 14
            font.bold: true
        }
        
        // Codec
        Row {
            spacing: 10
            Text {
                text: "Codec:"
                color: "#888888"
                font.pixelSize: 12
                width: 80
            }
            Text {
                text: codec
                color: "#CCCCCC"
                font.pixelSize: 12
                font.family: "monospace"
            }
        }
        
        // Bitrate
        Row {
            spacing: 10
            Text {
                text: "Bitrate:"
                color: "#888888"
                font.pixelSize: 12
                width: 80
            }
            Text {
                text: bitrate > 0 ? bitrate + " kbps" : "N/A"
                color: "#CCCCCC"
                font.pixelSize: 12
                font.family: "monospace"
            }
        }
        
        // Sample Rate
        Row {
            spacing: 10
            Text {
                text: "Sample Rate:"
                color: "#888888"
                font.pixelSize: 12
                width: 80
            }
            Text {
                text: sampleRate > 0 ? (sampleRate / 1000) + " kHz" : "N/A"
                color: "#CCCCCC"
                font.pixelSize: 12
                font.family: "monospace"
            }
        }
        
        // Channel Count and Layout
        Row {
            spacing: 10
            Text {
                text: "Channels:"
                color: "#888888"
                font.pixelSize: 12
                width: 80
            }
            Text {
                text: {
                    if (channelCount === 0) return "N/A"
                    if (channelLayout !== "") return channelCount + " (" + channelLayout + ")"
                    return channelCount.toString()
                }
                color: channelCount > 8 ? "#FF9800" : "#CCCCCC"  // Highlight if many channels
                font.pixelSize: 12
                font.family: "monospace"
            }
        }
    }
}
