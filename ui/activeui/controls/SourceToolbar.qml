import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// SourceToolbar - Properties/Filters toolbar above dock panels
Rectangle {
    id: sourceToolbar
    
    color: "#252525"
    implicitHeight: 32
    
    property string selectedSourceName: ""
    
    signal propertiesClicked()
    signal filtersClicked()
    
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 8
        
        Label {
            text: selectedSourceName ? selectedSourceName : "No source selected"
            color: selectedSourceName ? "#ccc" : "#888"
            font.pixelSize: 11
        }
        
        Item { Layout.fillWidth: true }
        
        Button {
            text: "Properties"
            flat: true
            font.pixelSize: 11
            enabled: selectedSourceName !== ""
            
            onClicked: propertiesClicked()
        }
        
        Button {
            text: "Filters"
            flat: true
            font.pixelSize: 11
            enabled: selectedSourceName !== ""
            
            onClicked: filtersClicked()
        }
    }
}
