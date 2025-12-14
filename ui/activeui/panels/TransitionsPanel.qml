import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../app"

// TransitionsPanel - Scene transition controls
DockPanel {
    id: transitionsPanel
    
    title: "Scene Transitions"
    
    property var transitionTypes: ["Fade", "Cut", "Swipe", "Slide", "Stinger"]
    property int currentTransitionIndex: 0
    property int durationMs: 300
    
    signal transitionChanged(string type)
    signal durationChanged(int ms)
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 4
        
        ComboBox {
            Layout.fillWidth: true
            model: transitionTypes
            currentIndex: currentTransitionIndex
            
            onCurrentIndexChanged: {
                transitionChanged(transitionTypes[currentIndex])
            }
        }
        
        RowLayout {
            Layout.fillWidth: true
            spacing: 4
            
            Label { 
                text: "Duration:" 
                color: "#888" 
                font.pixelSize: 11 
            }
            
            SpinBox {
                Layout.fillWidth: true
                from: 0
                to: 5000
                value: durationMs
                stepSize: 50
                
                onValueChanged: durationChanged(value)
            }
            
            Label { 
                text: "ms" 
                color: "#888" 
                font.pixelSize: 11 
            }
        }
        
        Item { Layout.fillHeight: true }
    }
    
    footerComponent: Component {
        Row {
            spacing: 4
            
            ToolButton { 
                width: 24; height: 24
                MaterialIcon { anchors.centerIn: parent; icon: "add"; size: 16; color: "#888" }
            }
            ToolButton { 
                width: 24; height: 24
                MaterialIcon { anchors.centerIn: parent; icon: "more_vert"; size: 16; color: "#888" }
            }
        }
    }
}
