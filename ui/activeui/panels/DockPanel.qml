import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// DockPanel - Container for OBS-style bottom dock panels
// Usage: DockPanel { title: "Sources"; content: ListView {...}; footer: Row {...} }
Rectangle {
    id: dockPanel
    
    color: "#1e1e1e"
    radius: 4
    
    property string title: ""
    property Component footerComponent: null
    default property alias content: contentArea.data
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 2
        
        // Header
        Label {
            text: dockPanel.title
            color: "#888"
            font.pixelSize: 11
            font.bold: true
        }
        
        // Content Area
        Item {
            id: contentArea
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        
        // Footer (optional)
        Loader {
            id: footerLoader
            Layout.fillWidth: true
            Layout.preferredHeight: footerComponent ? 28 : 0
            sourceComponent: footerComponent
            visible: footerComponent !== null
        }
    }
}
