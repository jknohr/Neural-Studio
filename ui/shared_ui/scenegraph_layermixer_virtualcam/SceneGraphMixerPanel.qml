import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../theme"

// Note: In real app, this Controller is registered in main.cpp
// For now we assume the context property "sceneGraphMixer" or we instantiate it here if registered as a type
// import NeuralStudio.UI 1.0 

Rectangle {
    id: root
    color: "#1e1e1e"
    
    // Mock controller data access for preview
    property var mockLayers: [
        {id: "1", name: "Camera 1", type: "Video", opacity: 1.0, visible: true, color: "#FF5555", zIndex: 0},
        {id: "2", name: "Overlay GFX", type: "Graphics", opacity: 0.8, visible: true, color: "#55FF55", zIndex: 1},
        {id: "3", name: "BGM", type: "Audio", opacity: 0.5, visible: true, color: "#5555FF", zIndex: -1},
        {id: "4", name: "Logo", type: "Graphics", opacity: 1.0, visible: false, color: "#FFFF55", zIndex: 2}
    ]
    
    // Split View Layout
    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal
        
        // LEFT: Scene Hierarchy
        SceneHierarchyView {
            SplitView.preferredWidth: 250
            SplitView.minimumWidth: 150
            nodeModel: root.mockLayers // Using same Mock Data
        }
        
        // CENTER/RIGHT Group
        SplitView {
            SplitView.fillWidth: true
            orientation: Qt.Vertical
            
            // TOP: Preview (3D Viewport)
            VirtualCamPreview {
                SplitView.fillHeight: true
                isConnected: true // Simulate active connection
                sceneLayers: root.mockLayers // BINDING
            }
            
            // BOTTOM: Mixer
            LayerMixerControl {
                SplitView.preferredHeight: 200
                SplitView.minimumHeight: 100
                layerModel: root.mockLayers
                
                onOpacityChanged: {
                    console.log("Opacity Changed for", id, ":", value)
                    // Update mock data locally for immediate feedback
                    for(var i=0; i<root.mockLayers.length; i++) {
                        if(root.mockLayers[i].id === id) {
                            root.mockLayers[i].opacity = value;
                            root.mockLayers = root.mockLayers // Trigger change
                            break;
                        }
                    }
                }
                
                onVisibilityToggled: {
                    console.log("Visibility Toggled for", id)
                     for(var i=0; i<root.mockLayers.length; i++) {
                        if(root.mockLayers[i].id === id) {
                            root.mockLayers[i].visible = !root.mockLayers[i].visible;
                             root.mockLayers = root.mockLayers // Trigger change
                            break;
                        }
                    }
                }
            }
        }
    }
}
