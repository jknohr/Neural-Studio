pragma Singleton
import QtQuick

// FrameContext - Singleton to share frame state across the app
// Provides access to current frame and node graph controller
QtObject {
    id: frameContext
    
    // Current active frame (BlueprintFrame or ActiveFrame)
    property var currentFrame: null
    
    // Node graph controller for creating/managing nodes
    property var nodeGraphController: null
    
    // Active manager panel name (empty = none shown)
    property string activeManagerPanel: ""
    
    // Whether Blueprint or Active frame is showing
    property bool isBlueprintMode: true
    
    // Show a manager panel by name
    function showManagerPanel(name) {
        activeManagerPanel = name
    }
    
    // Hide current manager panel
    function hideManagerPanel() {
        activeManagerPanel = ""
    }
    
    // Toggle manager panel
    function toggleManagerPanel(name) {
        if (activeManagerPanel === name) {
            activeManagerPanel = ""
        } else {
            activeManagerPanel = name
        }
    }
    
    // Available manager types
    readonly property var managerTypes: [
        { name: "video", title: "Video", icon: "videocam" },
        { name: "audio", title: "Audio", icon: "volume_up" },
        { name: "camera", title: "Camera", icon: "photo_camera" },
        { name: "3d", title: "3D Assets", icon: "view_in_ar" },
        { name: "effects", title: "Effects", icon: "auto_fix_high" },
        { name: "shader", title: "Shaders", icon: "gradient" },
        { name: "ml", title: "ML Models", icon: "model_training" },
        { name: "llm", title: "LLM", icon: "psychology" },
        { name: "script", title: "Scripts", icon: "code" }
    ]
}
