import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../app"

// ScenesPanel - OBS-style scenes list panel
DockPanel {
    id: scenesPanel
    
    title: "Scenes"
    
    // Scene list from controller
    property var sceneModel: ["Scene"]
    property int currentSceneIndex: 0
    
    signal sceneSelected(int index)
    signal addScene()
    signal removeScene()
    
    ListView {
        anchors.fill: parent
        model: sceneModel
        clip: true
        
        delegate: Rectangle {
            width: ListView.view.width
            height: 28
            color: index === currentSceneIndex ? "#3a6ea5" : 
                   mouseArea.containsMouse ? "#333" : "transparent"
            radius: 2
            
            Label {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: modelData
                color: "#fff"
                font.pixelSize: 12
            }
            
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sceneSelected(index)
            }
        }
    }
    
    footerComponent: Component {
        Row {
            spacing: 4
            
            ToolButton { 
                width: 24; height: 24
                onClicked: addScene()
                MaterialIcon { anchors.centerIn: parent; icon: "add"; size: 16; color: "#888" }
            }
            ToolButton { 
                width: 24; height: 24
                onClicked: removeScene()
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
