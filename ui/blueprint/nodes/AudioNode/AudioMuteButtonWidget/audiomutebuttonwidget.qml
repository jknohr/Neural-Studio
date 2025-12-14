import QtQuick
import QtQuick.Controls

// AudioMuteButtonWidget - Mute toggle button
// Ultra-specific name: audio + mute + button + widget
// Used by: ALL audio variants

Rectangle {
    id: root
    
    // Properties
    property bool muted: false
    
    // Signals
    signal muteToggled(bool isMuted)
    
    color: "transparent"
    implicitWidth: 60
    implicitHeight: 60
    
    Button {
        id: muteButton
        anchors.fill: parent
        
        background: Rectangle {
            color: muted ? "#F44336" : (muteButton.hovered ? "#555555" : "#3A3A3A")
            radius: 5
            border.color: muted ? "#E57373" : "#606060"
            border.width: 2
            
            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
        
        contentItem: Column {
            anchors.centerIn: parent
            spacing: 2
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: muted ? "🔇" : "🔊"
                font.pixelSize: 24
            }
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: muted ? "Muted" : "Active"
                color: "white"
                font.pixelSize: 9
            }
        }
        
        onClicked: {
            muted = !muted
            muteToggled(muted)
        }
    }
}
