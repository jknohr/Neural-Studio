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
            text: sourceToolbar.selectedSourceName ? sourceToolbar.selectedSourceName : "No source selected"
            color: sourceToolbar.selectedSourceName ? "#ccc" : "#888"
            font.pixelSize: 11
        }
        
        Item { Layout.fillWidth: true }
        
        Button {
            text: "Properties"
            flat: true
            font.pixelSize: 11
            enabled: sourceToolbar.selectedSourceName !== ""
            
            onClicked: sourceToolbar.propertiesClicked()
        }
        
        Button {
            text: "Filters"
            flat: true
            font.pixelSize: 11
            enabled: sourceToolbar.selectedSourceName !== ""
            
            onClicked: sourceToolbar.filtersClicked()
        }
    }
}
