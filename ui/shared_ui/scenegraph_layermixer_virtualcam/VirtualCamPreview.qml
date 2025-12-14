import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick3D
import QtQuick3D.Helpers
import "components"

// VirtualCamPreview - Complete 3D Workspace for VR Streaming
// Features: Scene manipulation, lighting, transform gizmos, video-matched IBL
Item {
    id: root
    
    // Controller binding (scene graph mixer)
    property var controller: null
    property bool isConnected: controller ? controller.virtualCamStatus === 2 : false
    
    // Manager controller bindings (from parent)
    property var cameraManager: null     // CameraManagerController
    property var videoManager: null      // VideoManagerController
    property var graphicsManager: null   // GraphicsManagerController
    property var fontManager: null       // FontManagerController
    
    // Signals for requesting manager popups
    signal requestCameraManager()
    signal requestVideoManager()
    signal requestGraphicsManager()
    signal requestTextEditor()
    
    // Selection state
    property var selectedNode: null
    property int gizmoMode: 0  // 0=Translate, 1=Rotate, 2=Scale
    
    // Content lists (dynamic sources)
    property var lights: ListModel {}
    property var videoFeeds: ListModel {}
    property var texts: ListModel {}
    property var images: ListModel {}
    
    // ========== SHARED SCENE CONTENT ==========
    // This Node is shared between Desktop and XR views
    Node {
        id: sceneContent
        
        // --- 1. Environment Light Probe (IBL from video) ---
        EnvironmentLightProbe {
            id: iblProbe
            autoEstimate: true
            useVideoFeed: true
            ambientIntensity: 0.3
            
            onLightingEstimated: (direction, col, intensity) => {
                console.log("Estimated lighting:", direction, col, intensity)
            }
        }
        
        // --- 2. Default Scene Lighting ---
        DirectionalLight {
            id: keyLight
            eulerRotation.x: -30
            eulerRotation.y: -30
            brightness: 1.2
            castsShadow: true
            shadowFactor: 50
        }
        
        DirectionalLight {
            id: fillLight
            eulerRotation.x: -20
            eulerRotation.y: 120
            brightness: 0.4
            color: "#aaccff"
        }
        
        PointLight {
            id: rimLight
            position: Qt.vector3d(-200, 100, -100)
            brightness: 0.5
            color: "#ffeecc"
        }
        
        // --- 3. User-Added Lights ---
        Repeater3D {
            model: lights
            
            SpatialLight {
                lightType: model.type || 0
                lightColor: model.color || "#ffffff"
                intensity: model.intensity || 1.0
                position: model.position || Qt.vector3d(0, 100, 0)
                eulerRotation: model.rotation || Qt.vector3d(0, 0, 0)
                isSelected: selectedNode === this
                showGizmo: true
                
                onSelected: selectedNode = this
            }
        }
        
        // --- 4. Spatial Grid (Floor Reference) ---
        SpatialGrid {
            visible: true
            gridSize: 2000
            step: 100
        }
        
        // --- 5. Dynamic Layers from Mixer ---
        Repeater3D {
            model: controller ? controller.layers : []
            
            SpatialLayer {
                id: layerNode
                property var data: modelData
                
                // Default positioning - spread in 3D space
                position: Qt.vector3d(
                    (index - (controller.layers.length - 1) / 2) * 250,
                    150 + (Math.sin(index) * 50),
                    -200 + (index * 50)
                )
                
                nodeType: data.type
                layerColor: data.color
                layerVisible: data.active
                layerOpacity: data.opacity
                
                // Enable selection
                Component.onCompleted: {
                    // Mark as selectable
                }
            }
        }
        
        // --- 6. Video Feeds (camera/video sources) ---
        Repeater3D {
            model: videoFeeds
            
            SpatialVideoFeed {
                sourceId: model.id || ""
                sourceName: model.name || "Video"
                sourceType: model.type || 0
                videoUrl: model.url || ""
                position: model.position || Qt.vector3d(0, 0, 0)
                eulerRotation: model.rotation || Qt.vector3d(0, 0, 0)
                scale: model.scale || Qt.vector3d(1, 1, 1)
                videoOpacity: model.opacity || 1.0
                videoVisible: model.visible !== false
                isSelected: selectedNode === this
                zOrder: model.zOrder || 0
            }
        }
        
        // --- 7. Text Overlays ---
        Repeater3D {
            model: texts
            
            SpatialText3D {
                text: model.text || "Text"
                textColor: model.color || "#ffffff"
                fontSize: model.fontSize || 48
                position: model.position || Qt.vector3d(0, 0, 0)
                eulerRotation: model.rotation || Qt.vector3d(0, 0, 0)
                scale: model.scale || Qt.vector3d(1, 1, 1)
                textOpacity: model.opacity || 1.0
                textVisible: model.visible !== false
                hasBackground: model.hasBackground || false
                isSelected: selectedNode === this
                zOrder: model.zOrder || 0
            }
        }
        
        // --- 8. Images/Graphics ---
        Repeater3D {
            model: images
            
            SpatialImage {
                imageSource: model.source || ""
                imageName: model.name || "Image"
                position: model.position || Qt.vector3d(0, 0, 0)
                eulerRotation: model.rotation || Qt.vector3d(0, 0, 0)
                scale: model.scale || Qt.vector3d(1, 1, 1)
                imageOpacity: model.opacity || 1.0
                imageVisible: model.visible !== false
                isSelected: selectedNode === this
                zOrder: model.zOrder || 0
            }
        }
        
        // --- 9. Transform Gizmo ---
        TransformGizmo {
            id: transformGizmo
            isActive: selectedNode !== null
            targetNode: selectedNode
            mode: gizmoMode
            
            onPositionChanged: (delta) => {
                if (targetNode) {
                    targetNode.position = targetNode.position.plus(delta)
                }
            }
            onRotationChanged: (delta) => {
                if (targetNode) {
                    targetNode.eulerRotation = targetNode.eulerRotation.plus(delta)
                }
            }
            onScaleChanged: (delta) => {
                if (targetNode) {
                    targetNode.scale = targetNode.scale.plus(delta)
                }
            }
        }
    }
    
    // ========== DESKTOP VIEW (Editor) ==========
    View3D {
        id: desktopView
        anchors.fill: parent
        
        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Color
            clearColor: "#111"
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
            
            // IBL reflection map
            // lightProbe: iblProbe.envTexture
        }
        
        importScene: sceneContent
        
        // Editor Camera with orbit control
        PerspectiveCamera {
            id: desktopCamera
            position: Qt.vector3d(0, 100, 500)
            eulerRotation.x: -10
        }
        
        OrbitCameraController {
            anchors.fill: parent
            camera: desktopCamera
            origin: sceneContent
        }
    }
    
    // ========== 3D PICKING / SELECTION ==========
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                // Raycast pick
                var result = desktopView.pick(mouse.x, mouse.y)
                if (result.objectHit) {
                    // Find the SpatialLayer or SpatialLight parent
                    var obj = result.objectHit
                    while (obj && !(obj instanceof SpatialLayer) && !(obj instanceof SpatialLight)) {
                        obj = obj.parent
                    }
                    if (obj) {
                        selectedNode = obj
                    }
                } else {
                    selectedNode = null
                }
            }
        }
    }
    
    // ========== HUD OVERLAY ==========
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20
        width: hudLayout.width + 20
        height: hudLayout.height + 10
        color: Qt.rgba(0, 0, 0, 0.7)
        radius: 4
        
        RowLayout {
            id: hudLayout
            anchors.centerIn: parent
            spacing: 10
            
            // Connection indicator
            Rectangle {
                width: 12; height: 12; radius: 6
                color: root.isConnected ? "#FF5555" : "#888"
            }
            
            Label {
                text: "SPATIAL CANVAS"
                color: "white"
                font.bold: true
            }
            
            // Stereo mode
            Rectangle {
                width: 70; height: 22; radius: 2
                color: controller && controller.stereoMode !== 0 ? "#4CAF50" : "#444"
                
                Label {
                    anchors.centerIn: parent
                    text: controller && controller.stereoMode !== 0 ? "VR READY" : "DESKTOP"
                    font.pixelSize: 9
                    color: "white"
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (controller) {
                            controller.stereoMode = (controller.stereoMode + 1) % 2
                        }
                    }
                }
            }
        }
    }
    
    // ========== TOOLBAR (Gizmo Mode Selection) ==========
    Rectangle {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        width: toolbarRow.width + 20
        height: 40
        color: Qt.rgba(0, 0, 0, 0.7)
        radius: 20
        
        Row {
            id: toolbarRow
            anchors.centerIn: parent
            spacing: 8
            
            // Translate
            ToolButton {
                width: 36; height: 36
                checkable: true
                checked: gizmoMode === 0
                onClicked: gizmoMode = 0
                
                Label {
                    anchors.centerIn: parent
                    text: "↔"
                    font.pixelSize: 18
                    color: parent.checked ? "#4a9eff" : "#888"
                }
                
                ToolTip.visible: hovered
                ToolTip.text: "Move (W)"
            }
            
            // Rotate
            ToolButton {
                width: 36; height: 36
                checkable: true
                checked: gizmoMode === 1
                onClicked: gizmoMode = 1
                
                Label {
                    anchors.centerIn: parent
                    text: "↻"
                    font.pixelSize: 18
                    color: parent.checked ? "#4a9eff" : "#888"
                }
                
                ToolTip.visible: hovered
                ToolTip.text: "Rotate (E)"
            }
            
            // Scale
            ToolButton {
                width: 36; height: 36
                checkable: true
                checked: gizmoMode === 2
                onClicked: gizmoMode = 2
                
                Label {
                    anchors.centerIn: parent
                    text: "⤢"
                    font.pixelSize: 18
                    color: parent.checked ? "#4a9eff" : "#888"
                }
                
                ToolTip.visible: hovered
                ToolTip.text: "Scale (R)"
            }
            
            Rectangle { width: 1; height: 24; color: "#444" }
            
            // Add Light
            ToolButton {
                width: 36; height: 36
                onClicked: addLight()
                
                Label {
                    anchors.centerIn: parent
                    text: "💡"
                    font.pixelSize: 16
                }
                
                ToolTip.visible: hovered
                ToolTip.text: "Add Light"
            }
            
            // Add Camera
            ToolButton {
                width: 36; height: 36
                onClicked: addCamera()
                
                Label {
                    anchors.centerIn: parent
                    text: "📷"
                    font.pixelSize: 16
                }
                
                ToolTip.visible: hovered
                ToolTip.text: "Add Camera Feed"
            }
            
            // Add Video
            ToolButton {
                width: 36; height: 36
                onClicked: addVideo()
                
                Label {
                    anchors.centerIn: parent
                    text: "🎬"
                    font.pixelSize: 16
                }
                
                ToolTip.visible: hovered
                ToolTip.text: "Add Video"
            }
            
            // Add Text
            ToolButton {
                width: 36; height: 36
                onClicked: addText()
                
                Label {
                    anchors.centerIn: parent
                    text: "T"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#888"
                }
                
                ToolTip.visible: hovered
                ToolTip.text: "Add Text"
            }
            
            // Add Image
            ToolButton {
                width: 36; height: 36
                onClicked: addImage()
                
                Label {
                    anchors.centerIn: parent
                    text: "🖼"
                    font.pixelSize: 16
                }
                
                ToolTip.visible: hovered
                ToolTip.text: "Add Image"
            }
        }
    }
    
    // ========== SELECTION INFO PANEL ==========
    Rectangle {
        visible: selectedNode !== null
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        width: 200
        height: propColumn.height + 20
        color: Qt.rgba(0, 0, 0, 0.8)
        radius: 4
        
        ColumnLayout {
            id: propColumn
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8
            
            Label {
                text: "TRANSFORM"
                color: "#888"
                font.bold: true
                font.pixelSize: 10
            }
            
            // Position
            RowLayout {
                Layout.fillWidth: true
                Label { text: "Pos:"; color: "#666"; Layout.preferredWidth: 30 }
                Label {
                    text: selectedNode ? 
                        selectedNode.position.x.toFixed(0) + ", " +
                        selectedNode.position.y.toFixed(0) + ", " +
                        selectedNode.position.z.toFixed(0) : "-"
                    color: "#ccc"
                    font.pixelSize: 11
                }
            }
            
            // Rotation
            RowLayout {
                Layout.fillWidth: true
                Label { text: "Rot:"; color: "#666"; Layout.preferredWidth: 30 }
                Label {
                    text: selectedNode ?
                        selectedNode.eulerRotation.x.toFixed(0) + "°, " +
                        selectedNode.eulerRotation.y.toFixed(0) + "°, " +
                        selectedNode.eulerRotation.z.toFixed(0) + "°" : "-"
                    color: "#ccc"
                    font.pixelSize: 11
                }
            }
            
            // Scale
            RowLayout {
                Layout.fillWidth: true
                Label { text: "Scale:"; color: "#666"; Layout.preferredWidth: 30 }
                Label {
                    text: selectedNode ?
                        selectedNode.scale.x.toFixed(2) + ", " +
                        selectedNode.scale.y.toFixed(2) + ", " +
                        selectedNode.scale.z.toFixed(2) : "-"
                    color: "#ccc"
                    font.pixelSize: 11
                }
            }
        }
    }
    
    // ========== KEYBOARD SHORTCUTS ==========
    Keys.onPressed: (event) => {
        switch (event.key) {
            case Qt.Key_W: gizmoMode = 0; break  // Translate
            case Qt.Key_E: gizmoMode = 1; break  // Rotate
            case Qt.Key_R: gizmoMode = 2; break  // Scale
            case Qt.Key_Escape: selectedNode = null; break
            case Qt.Key_Delete:
                if (selectedNode) {
                    // TODO: Delete selected node
                    selectedNode = null
                }
                break
        }
    }
    focus: true
    
    // ========== FUNCTIONS ==========
    
    function addLight() {
        lights.append({
            type: 0,  // Point light
            color: "#ffffff",
            intensity: 1.0,
            position: Qt.vector3d(
                desktopCamera.position.x,
                desktopCamera.position.y + 50,
                desktopCamera.position.z - 100
            ),
            rotation: Qt.vector3d(0, 0, 0)
        })
    }
    
    // Camera - via CameraManager
    function addCamera() {
        if (cameraManager && cameraManager.availableCameras.length > 0) {
            // Use first available camera
            addCameraFromDevice(cameraManager.availableCameras[0])
        } else {
            // Request manager popup for selection
            requestCameraManager()
        }
    }
    
    function addCameraFromDevice(deviceName) {
        videoFeeds.append({
            id: "camera_" + videoFeeds.count,
            name: deviceName || "Camera " + (videoFeeds.count + 1),
            type: 0,  // Camera
            deviceId: deviceName,
            url: "",
            position: Qt.vector3d(0, 150, -200),
            rotation: Qt.vector3d(0, 0, 0),
            scale: Qt.vector3d(1, 1, 1),
            opacity: 1.0,
            visible: true,
            zOrder: videoFeeds.count
        })
    }
    
    // Video - via VideoManager or file dialog
    function addVideo() {
        if (videoManager && videoManager.availableVideos.length > 0) {
            requestVideoManager()
        } else {
            videoFileDialog.open()
        }
    }
    
    function addVideoFromPath(path, name) {
        videoFeeds.append({
            id: "video_" + videoFeeds.count,
            name: name || "Video " + (videoFeeds.count + 1),
            type: 1,  // Video file
            url: path,
            position: Qt.vector3d(100, 150, -200),
            rotation: Qt.vector3d(0, 0, 0),
            scale: Qt.vector3d(1, 1, 1),
            opacity: 1.0,
            visible: true,
            zOrder: videoFeeds.count
        })
    }
    
    // Text - inline creation then edit via properties
    function addText() {
        texts.append({
            text: "Text",
            color: "#ffffff",
            fontSize: 48,
            position: Qt.vector3d(0, 200, -100),
            rotation: Qt.vector3d(0, 0, 0),
            scale: Qt.vector3d(1, 1, 1),
            opacity: 1.0,
            visible: true,
            hasBackground: false,
            zOrder: texts.count
        })
        // Optionally signal for text editor panel
        requestTextEditor()
    }
    
    // Image - via GraphicsManager or file dialog
    function addImage() {
        if (graphicsManager && graphicsManager.availableGraphics.length > 0) {
            requestGraphicsManager()
        } else {
            imageFileDialog.open()
        }
    }
    
    function addImageFromPath(path, name) {
        images.append({
            source: path,
            name: name || "Image " + (images.count + 1),
            position: Qt.vector3d(-100, 150, -150),
            rotation: Qt.vector3d(0, 0, 0),
            scale: Qt.vector3d(1, 1, 1),
            opacity: 1.0,
            visible: true,
            zOrder: images.count
        })
    }
    
    function selectNode(node) {
        selectedNode = node
    }
    
    function clearSelection() {
        selectedNode = null
    }
    
    // ========== FILE DIALOGS ==========
    FileDialog {
        id: videoFileDialog
        title: "Select Video File"
        nameFilters: ["Video files (*.mp4 *.mov *.avi *.mkv *.webm)"]
        onAccepted: {
            var fileName = selectedFile.toString().split('/').pop()
            addVideoFromPath(selectedFile, fileName)
        }
    }
    
    FileDialog {
        id: imageFileDialog
        title: "Select Image File"
        nameFilters: ["Image files (*.png *.jpg *.jpeg *.gif *.svg *.webp)"]
        onAccepted: {
            var fileName = selectedFile.toString().split('/').pop()
            addImageFromPath(selectedFile, fileName)
        }
    }
}
