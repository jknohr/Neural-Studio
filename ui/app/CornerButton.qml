import QtQuick
import QtQuick.Controls

// Reusable corner button with Material Icon
RoundButton {
    id: cornerButton
    width: 48
    height: 48
    z: 1000  // Always on top
    
    // Icon name from Google Material Symbols
    // See: https://fonts.google.com/icons
    property string iconName: ""
    property int iconSize: 24
    
    property color baseColor: "#2d2d2d"
    property color hoverColor: "#404040"
    property color pressedColor: "#505050"
    
    background: Rectangle {
        radius: width / 2
        color: cornerButton.pressed ? pressedColor : 
               cornerButton.hovered ? hoverColor : baseColor
        border.width: 1
        border.color: "#555555"
        
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
    
    contentItem: MaterialIcon {
        icon: cornerButton.iconName
        size: cornerButton.iconSize
        anchors.centerIn: parent
    }
}
