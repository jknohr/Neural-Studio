import QtQuick 2.15
import QtQuick3D 1.15

Node {
    id: root
    
    property var layerData: null
    property real layerOpacity: layerData ? layerData.opacity : 1.0
    property bool layerVisible: layerData ? layerData.visible : true
    property color layerColor: layerData ? layerData.color : "white"
    property string layerName: layerData ? layerData.name : "Layer"
    property int zIndex: layerData ? layerData.zIndex : 0
    
    visible: layerVisible
    
    // Position based on zIndex (stacking in depth)
    // We stack them slightly apart on Z axis to avoid fighting, although compositing handles it.
    // In "VR" mode, we might want them arranged in a semi-circle or just stacked.
    // For this mixer view, let's stack them in depth: -zIndex * 10
    position: Qt.vector3d(0, 0, -zIndex * 20)

    // The Content Plane
    Model {
        source: "#Rectangle" // Built-in plane primitive
        scale: Qt.vector3d(1.6, 0.9, 1) // 16:9 Aspect Ratio
        
        materials: [
            DefaultMaterial {
                id: mat
                diffuseColor: root.layerColor
                opacity: root.layerOpacity
                lighting: DefaultMaterial.FragmentLighting // React to lights
                cullMode: DefaultMaterial.NoCulling
            }
        ]
        
        // Selection/Highlight effect (if selected)
        // ...
    }
    
    // Label Floating above
    Node {
        position: Qt.vector3d(0, 60, 0)
        
        // View3D can contain 2D items via Node -> but usually requires `objectName: "label"` mapping
        // or cleaner to use a separate overlay.
        // For actual 3D text, we'd use Text3D (QtQuick3D.Helpers) but let's keep it simple.
    }
}
