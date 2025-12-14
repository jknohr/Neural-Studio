import QtQuick
import QtQuick.Controls
import "../frames"
import "../panels"

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1920
    height: 1080
    minimumWidth: 1280
    minimumHeight: 720
    title: "Neural Studio"
    color: "#121212"  // Dark theme base
    
    // State: which frame is showing
    property bool showingBlueprint: true
    
    // Main Canvas Area - toggles between frames
    StackView {
        id: frameStack
        anchors.fill: parent
        initialItem: blueprintFrameComponent
        
        pushEnter: Transition {
            PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
        }
        pushExit: Transition {
            PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 200 }
        }
        popEnter: Transition {
            PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
        }
        popExit: Transition {
            PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 200 }
        }
    }
    
    Component { 
        id: blueprintFrameComponent
        BlueprintFrame {} 
    }
    Component { 
        id: activeFrameComponent
        ActiveFrame {} 
    }
    
    // === 4 CORNER BUTTONS ===
    
    // Top-Left: Toggle ViewFrame (Blueprint ↔ Active)
    CornerButton {
        id: toggleFrameBtn
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 16
        iconName: showingBlueprint ? "play_circle" : "account_tree"
        ToolTip.visible: hovered
        ToolTip.text: showingBlueprint ? "Switch to Active Frame" : "Switch to Blueprint Frame"
        onClicked: {
            showingBlueprint = !showingBlueprint
            if (showingBlueprint) {
                frameStack.replace(null, blueprintFrameComponent)
            } else {
                frameStack.replace(null, activeFrameComponent)
            }
        }
    }
    
    // Top-Right: Settings
    CornerButton {
        id: settingsBtn
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 16
        iconName: "settings"
        ToolTip.visible: hovered
        ToolTip.text: "Settings"
        onClicked: settingsPanel.toggle()
    }
    
    // Bottom-Right: AI Chat (Gemini)
    CornerButton {
        id: aiChatBtn
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 16
        iconName: "smart_toy"
        ToolTip.visible: hovered
        ToolTip.text: "AI Assistant"
        onClicked: aiChatPanel.toggle()
    }
    
    // Bottom-Left: Dock Chat (Stream Interaction)
    CornerButton {
        id: dockChatBtn
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 16
        iconName: "forum"
        ToolTip.visible: hovered
        ToolTip.text: "Dock Chat"
        onClicked: dockChatPanel.toggle()
    }
    
    // === SLIDE-OUT PANELS ===
    
    // Settings Panel (slides from right)
    SlidingPanel {
        id: settingsPanel
        edge: Qt.RightEdge
        width: 400
        
        content: SettingsPanel {
            onCloseRequested: settingsPanel.close()
        }
    }
    
    // AI Chat Panel (slides from right, below settings)
    SlidingPanel {
        id: aiChatPanel
        edge: Qt.RightEdge
        width: 420
        
        content: AIChatPanel {
            onCloseRequested: aiChatPanel.close()
        }
    }
    
    // Dock Chat Panel (slides from left)
    SlidingPanel {
        id: dockChatPanel
        edge: Qt.LeftEdge
        width: 350
        
        content: DockChatPanel {
            onCloseRequested: dockChatPanel.close()
        }
    }
    
    // Keyboard shortcuts
    Shortcut {
        sequence: "F1"
        onActivated: toggleFrameBtn.clicked()
    }
    Shortcut {
        sequence: "Ctrl+,"
        onActivated: settingsPanel.toggle()
    }
    Shortcut {
        sequence: "Ctrl+Shift+A"
        onActivated: aiChatPanel.toggle()
    }
}
