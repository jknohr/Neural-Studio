import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// AudioMeterChannel - Single channel in the audio mixer
// Shows stereo level meters with gradient coloring
Rectangle {
    id: meterChannel
    
    property string channelName: ""
    property real levelL: 0.0  // Left channel 0.0 - 1.0
    property real levelR: 0.0  // Right channel 0.0 - 1.0
    property bool isMuted: false
    
    signal muteToggled()
    signal volumeChanged(real value)
    
    color: "transparent"
    implicitWidth: 100
    implicitHeight: 120
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 4
        
        // Stereo meter bars
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 2
            
            // Left channel
            Rectangle {
                Layout.preferredWidth: 35
                Layout.fillHeight: true
                color: "#1a1a1a"
                radius: 2
                
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 1
                    height: Math.min(1, Math.max(0, levelL)) * (parent.height - 2)
                    radius: 2
                    
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#ff0000" }
                        GradientStop { position: 0.15; color: "#ff4400" }
                        GradientStop { position: 0.3; color: "#ffff00" }
                        GradientStop { position: 0.5; color: "#88ff00" }
                        GradientStop { position: 1.0; color: "#00aa00" }
                    }
                }
            }
            
            // Right channel
            Rectangle {
                Layout.preferredWidth: 35
                Layout.fillHeight: true
                color: "#1a1a1a"
                radius: 2
                
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 1
                    height: Math.min(1, Math.max(0, levelR)) * (parent.height - 2)
                    radius: 2
                    
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#ff0000" }
                        GradientStop { position: 0.15; color: "#ff4400" }
                        GradientStop { position: 0.3; color: "#ffff00" }
                        GradientStop { position: 0.5; color: "#88ff00" }
                        GradientStop { position: 1.0; color: "#00aa00" }
                    }
                }
            }
        }
        
        // Channel name
        Label {
            Layout.fillWidth: true
            text: channelName
            color: isMuted ? "#444" : "#888"
            font.pixelSize: 9
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
