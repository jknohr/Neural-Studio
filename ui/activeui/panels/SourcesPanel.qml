import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../app"

// SourcesPanel - OBS-style sources list panel
DockPanel {
    id: sourcesPanel
    
    title: "Sources"
    
    // Sources from controller
    property var sourceModel: []
    property int currentSourceIndex: -1
    
    signal sourceSelected(int index)
    signal toggleVisibility(int index)
    signal toggleLock(int index)
    signal addSource()
    signal removeSource()
    
    ListView {
        anchors.fill: parent
        model: sourceModel
        clip: true
        
        delegate: Rectangle {
            width: ListView.view.width
            height: 24
            color: index === currentSourceIndex ? "#3a6ea5" : 
                   mouseArea.containsMouse ? "#333" : "transparent"
            radius: 2
            
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 4
                anchors.rightMargin: 4
                spacing: 4
                
                // Visibility toggle
                ToolButton {
                    width: 20; height: 20
                    onClicked: toggleVisibility(index)
                    
                    MaterialIcon {
                        anchors.centerIn: parent
                        icon: modelData.visible ? "visibility" : "visibility_off"
                        size: 14
                        color: modelData.visible ? "#888" : "#444"
                    }
                }
                
                // Lock toggle
                ToolButton {
                    width: 20; height: 20
                    onClicked: toggleLock(index)
                    
                    MaterialIcon {
                        anchors.centerIn: parent
                        icon: modelData.locked ? "lock" : "lock_open"
                        size: 14
                        color: modelData.locked ? "#888" : "#444"
                    }
                }
                
                // Source name
                Label {
                    Layout.fillWidth: true
                    text: modelData.name || ""
                    color: "#ccc"
                    font.pixelSize: 11
                    elide: Text.ElideRight
                }
            }
            
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
            }
        }
    }
    
    footerComponent: Component {
        Row {
            spacing: 4
            
            ToolButton { 
                width: 24; height: 24
                onClicked: addSource()
                MaterialIcon { anchors.centerIn: parent; icon: "add"; size: 16; color: "#888" }
            }
            ToolButton { 
                width: 24; height: 24
                onClicked: removeSource()
                MaterialIcon { anchors.centerIn: parent; icon: "remove"; size: 16; color: "#888" }
            }
            ToolButton { 
                width: 24; height: 24
                MaterialIcon { anchors.centerIn: parent; icon: "arrow_upward"; size: 16; color: "#888" }
            }
            ToolButton { 
                width: 24; height: 24
                MaterialIcon { anchors.centerIn: parent; icon: "arrow_downward"; size: 16; color: "#888" }
            }
        }
    }
}
