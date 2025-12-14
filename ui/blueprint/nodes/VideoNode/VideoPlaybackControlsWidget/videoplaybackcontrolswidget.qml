import QtQuick
import QtQuick.Controls

// VideoPlaybackControlsWidget - Playback controls for video playback
// Ultra-specific name: video + playback + controls + widget
// Used by: ALL video variants

Rectangle {
    id: root
    
    // Properties
    property bool isPlaying: false
    property bool isPaused: false
    property bool isLive: false  // For stream variants
    
    // Signals
    signal playClicked()
    signal pauseClicked()
    signal stopClicked()
    signal seekForward()
    signal seekBackward()
    
    color: "transparent"
    implicitHeight: 60
    
    Row {
        anchors.centerIn: parent
        spacing: 12
        
        // Seek backward button (not for live streams)
        Button {
            id: seekBackBtn
            width: 40
            height: 40
            visible: !isLive
            
            background: Rectangle {
                color: seekBackBtn.hovered ? "#555555" : "#3A3A3A"
                radius: 20
                border.color: "#606060"
                border.width: 1
            }
            
            contentItem: Text {
                text: "⏪"
                font.pixelSize: 18
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: seekBackward()
        }
        
        // Play button
        Button {
            id: playBtn
            width: 50
            height: 50
            enabled: !isPlaying
            
            background: Rectangle {
                color: playBtn.enabled ? (playBtn.hovered ? "#4CAF50" : "#2E7D32") : "#555555"
                radius: 25
                border.color: "#81C784"
                border.width: playBtn.hovered ? 2 : 1
            }
            
            contentItem: Text {
                text: "▶"
                font.pixelSize: 24
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: playClicked()
        }
        
        // Pause button
        Button {
            id: pauseBtn
            width: 50
            height: 50
            enabled: isPlaying && !isPaused
            
            background: Rectangle {
                color: pauseBtn.enabled ? (pauseBtn.hovered ? "#FF9800" : "#F57C00") : "#555555"
                radius: 25
                border.color: "#FFB74D"
                border.width: pauseBtn.hovered ? 2 : 1
            }
            
            contentItem: Text {
                text: "⏸"
                font.pixelSize: 24
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: pauseClicked()
        }
        
        // Stop button
        Button {
            id: stopBtn
            width: 50
            height: 50
            enabled: isPlaying || isPaused
            
            background: Rectangle {
                color: stopBtn.enabled ? (stopBtn.hovered ? "#F44336" : "#D32F2F") : "#555555"
                radius: 25
                border.color: "#E57373"
                border.width: stopBtn.hovered ? 2 : 1
            }
            
            contentItem: Text {
                text: "⏹"
                font.pixelSize: 24
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: stopClicked()
        }
        
        // Seek forward button (not for live streams)
        Button {
            id: seekForwardBtn
            width: 40
            height: 40
            visible: !isLive
            
            background: Rectangle {
                color: seekForwardBtn.hovered ? "#555555" : "#3A3A3A"
                radius: 20
                border.color: "#606060"
                border.width: 1
            }
            
            contentItem: Text {
                text: "⏩"
                font.pixelSize: 18
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: seekForward()
        }
    }
}
