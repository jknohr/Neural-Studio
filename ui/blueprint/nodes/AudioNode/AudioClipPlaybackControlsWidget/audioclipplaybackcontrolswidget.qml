import QtQuick
import QtQuick.Controls

// AudioClipPlaybackControlsWidget - Playback controls for audio clips
// Ultra-specific name: audio + clip + playback + controls + widget
// Used by: All AudioClip variants

Rectangle {
    id: root
    
    // Properties
    property bool isPlaying: false
    property bool isPaused: false
    
    // Signals
    signal playClicked()
    signal pauseClicked()
    signal stopClicked()
    
    color: "transparent"
    implicitHeight: 50
    
    Row {
        anchors.centerIn: parent
        spacing: 10
        
        // Play button
        Button {
            id: playBtn
            width: 45
            height: 45
            enabled: !isPlaying
            
            background: Rectangle {
                color: playBtn.enabled ? (playBtn.hovered ? "#4CAF50" : "#2E7D32") : "#555555"
                radius: 23
                border.color: "#81C784"
                border.width: playBtn.hovered ? 2 : 1
            }
            
            contentItem: Text {
                text: "▶"
                font.pixelSize: 20
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: playClicked()
        }
        
        // Pause button
        Button {
            id: pauseBtn
            width: 45
            height: 45
            enabled: isPlaying && !isPaused
            
            background: Rectangle {
                color: pauseBtn.enabled ? (pauseBtn.hovered ? "#FF9800" : "#F57C00") : "#555555"
                radius: 23
                border.color: "#FFB74D"
                border.width: pauseBtn.hovered ? 2 : 1
            }
            
            contentItem: Text {
                text: "⏸"
                font.pixelSize: 20
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: pauseClicked()
        }
        
        // Stop button
        Button {
            id: stopBtn
            width: 45
            height: 45
            enabled: isPlaying || isPaused
            
            background: Rectangle {
                color: stopBtn.enabled ? (stopBtn.hovered ? "#F44336" : "#D32F2F") : "#555555"
                radius: 23
                border.color: "#E57373"
                border.width: stopBtn.hovered ? 2 : 1
            }
            
            contentItem: Text {
                text: "⏹"
                font.pixelSize: 20
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: stopClicked()
        }
    }
}
