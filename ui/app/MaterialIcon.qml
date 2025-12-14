import QtQuick

// Google Material Symbols icon component
// Usage: MaterialIcon { icon: "settings"; size: 24 }
// Icons: https://fonts.google.com/icons
Text {
    id: materialIcon
    
    // Icon name (e.g., "settings", "home", "chat")
    property string icon: ""
    property int size: 24
    property bool filled: true  // Use filled variant
    
    // Material Symbols uses ligatures - just use the icon name as text
    text: icon
    
    font.family: "Material Symbols Rounded"
    font.pixelSize: size
    
    // Variable font settings for Material Symbols
    // FILL: 0=outlined, 1=filled
    // wght: 100-700 (weight)
    // GRAD: -25 to 200 (grade/emphasis)
    // opsz: 20-48 (optical size)
    font.weight: Font.Normal
    
    // Note: Qt 6 supports variable fonts but axis control varies
    // For filled icons, we use the filled font variant
    
    color: "#ffffff"
    opacity: 0.9
    
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
