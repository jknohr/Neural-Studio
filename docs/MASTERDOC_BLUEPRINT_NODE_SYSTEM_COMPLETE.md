# Neural Studio: Blueprint Node System - Complete Architecture
## Unified Rendering, Variant Management, and Node Foundation

**Version**: 2.0.0  
**Date**: 2025-12-17  
**Status**: Comprehensive Integration Architecture

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Three-Layer Node Architecture](#2-three-layer-node-architecture)
3. [Base Node Foundation](#3-base-node-foundation)
4. [Node Variant System](#4-node-variant-system)
5. [Rendering Pipeline Integration](#5-rendering-pipeline-integration)
6. [Complete Node Lifecycle](#6-complete-node-lifecycle)
7. [Critical Implementation Details](#7-critical-implementation-details)
8. [File Structure & Organization](#8-file-structure--organization)
9. [Implementation Roadmap](#9-implementation-roadmap)

---

## 1. Executive Summary

Neural Studio's Blueprint system is built on a **three-layer architecture** where every processing component—from video capture to AI inference to network streaming—is a **visual node** in a graph:

### Core Principles

1. **Three-Layer Design**: Backend (C++) ↔ Controller (C++ QObject) ↔ Visual (QML)
2. **Variant-Based Composition**: Function-based variants (not provider-based) with widget composition
3. **Ultra-Specific Naming**: Every file has long, contextual, grep-able names
4. **Shared Base Classes**: Common functionality implemented once, inherited everywhere
5. **Type-Safe Pins**: Compile-time C++ types + runtime validation
6. **Zero-Copy Rendering**: UMA architecture with Qt RHI (Vulkan backend)

### Innovation Summary

**Problem**: How do you create a visual programming system for VR broadcasting that's both powerful and user-friendly?

**Solution**: Three synchronized layers with variant composition:
- **Backend Layer**: Pure C++ processing nodes (GPU rendering, ML inference, encoding)
- **Controller Layer**: C++ QObject bridges with Qt property system
- **Visual Layer**: QML components with function-based variants and provider widgets

---

## 2. Three-Layer Node Architecture

### 2.1 Layer Overview

```
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 1: QML VISUAL LAYER (User Interface)                    │
│  Files: ui/blueprint/nodes/<NodeType>/<Variant>/               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  BaseNode.qml (Visual Template)                                │
│  ├── Header (title, color, icon)                               │
│  ├── Body (custom content area)                                │
│  ├── Ports (input/output pins)                                 │
│  └── Interaction (drag, select, z-order)                       │
│                                                                 │
│  Function-Based Variants:                                      │
│  ├── audiofileplaybacknode.qml                                 │
│  ├── videovr360playbacknode.qml                                │
│  └── mlvideosegmentationnode.qml                               │
│                                                                 │
│  Provider Widgets (inside variants):                           │
│  ├── qtmultimediaplayerwidget.qml                              │
│  ├── ffmpegdecoderwidget.qml                                   │
│  └── onnxmodelwidget.qml                                       │
│                                                                 │
└────────────────┬────────────────────────────────────────────────┘
                 │ Property Bindings (Qt Meta-Object System)
┌────────────────▼────────────────────────────────────────────────┐
│  LAYER 2: C++ CONTROLLER LAYER (QML Bridge)                    │
│  Files: ui/blueprint/nodes/<NodeType>Controller.h              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  BaseNodeController (QObject)                                  │
│  ├── Q_PROPERTY declarations                                   │
│  ├── Signal/slot connections                                   │
│  ├── updateBackendProperty()                                   │
│  └── Property change handlers                                  │
│                                                                 │
│  Concrete Controllers:                                         │
│  ├── AudioFilePlaybackController                               │
│  ├── VideoVR360PlaybackController                              │
│  └── MLVideoSegmentationController                             │
│                                                                 │
└────────────────┬────────────────────────────────────────────────┘
                 │ Direct C++ API Calls
┌────────────────▼────────────────────────────────────────────────┐
│  LAYER 3: C++ BACKEND LAYER (Processing Engine)                │
│  Files: core/src/scene-graph/nodes/<NodeType>/                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  BaseNodeBackend (IExecutableNode)                             │
│  ├── NodeMetadata                                              │
│  ├── Pin management (addInput/addOutput)                       │
│  ├── Type-safe data storage (std::any)                         │
│  └── process(ExecutionContext&) = 0                            │
│                                                                 │
│  Concrete Backends:                                            │
│  ├── AudioFilePlaybackNode                                     │
│  ├── VideoVR360PlaybackNode                                    │
│  ├── StereoRenderNode                                          │
│  ├── StitchNode                                                │
│  ├── OpticalFlowNode                                           │
│  └── WebTransportOutputNode                                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Data Flow Example

**Scenario**: User adjusts "Stitch Quality" slider in Blueprint editor

```
Step 1: User moves slider in QML
   ↓
StitchNode.qml (Visual Layer)
   property alias stitchQuality: qualitySlider.value
   onStitchQualityChanged: controller.quality = stitchQuality

Step 2: QML property binding triggers controller
   ↓
StitchNodeController (Controller Layer)
   void setQuality(float q) {
       m_quality = q;
       updateBackendProperty("quality", q);
       emit qualityChanged();
   }

Step 3: Controller calls backend API
   ↓
NodeExecutionGraph::updateNodeProperty(nodeId, "quality", 0.8f)
   ↓
StitchNode::setProperty("quality", 0.8f)  (Backend Layer)
   m_quality = 0.8f;  // Used in next process() call

Step 4: Next frame execution
   ↓
StitchNode::process(ExecutionContext& ctx) {
    // Uses m_quality for shader parameters
    runStitchShader(ctx.rhi, inputs, m_quality);
}
```

---

## 3. Base Node Foundation

### 3.1 Backend Base Class

**Location**: `core/src/scene-graph/BaseNodeBackend.h`

**Purpose**: Eliminate code duplication across all processing nodes

```cpp
// core/src/scene-graph/BaseNodeBackend.h
class BaseNodeBackend : public IExecutableNode {
public:
    BaseNodeBackend(const std::string& id, const std::string& typeName)
        : m_id(id), m_typeName(typeName) {}
    
    virtual ~BaseNodeBackend() = default;
    
    // IExecutableNode interface
    std::string id() const override { return m_id; }
    std::string typeName() const override { return m_typeName; }
    NodeMetadata metadata() const override { return m_metadata; }
    
    std::vector<PinDescriptor> inputs() const override { return m_inputs; }
    std::vector<PinDescriptor> outputs() const override { return m_outputs; }
    
    // Pure virtual - must be implemented by concrete nodes
    virtual ExecutionResult process(ExecutionContext& ctx) = 0;
    
    // Pin management helpers
    void addInput(const std::string& id, const std::string& name, const DataType& type) {
        m_inputs.push_back({id, name, type, PinDirection::Input});
    }
    
    void addOutput(const std::string& id, const std::string& name, const DataType& type) {
        m_outputs.push_back({id, name, type, PinDirection::Output});
    }
    
    // Type-safe data accessors
    template<typename T>
    T* getInputData(const std::string& pinId) {
        auto it = m_pinData.find(pinId);
        if (it != m_pinData.end()) {
            return std::any_cast<T>(&it->second);
        }
        return nullptr;
    }
    
    template<typename T>
    T getInputData(const std::string& pinId, const T& defaultValue) {
        if (auto* ptr = getInputData<T>(pinId)) {
            return *ptr;
        }
        return defaultValue;
    }
    
    template<typename T>
    void setOutputData(const std::string& pinId, const T& data) {
        m_pinData[pinId] = data;
    }
    
protected:
    void setMetadata(const NodeMetadata& meta) { m_metadata = meta; }
    
private:
    std::string m_id;
    std::string m_typeName;
    NodeMetadata m_metadata;
    std::vector<PinDescriptor> m_inputs;
    std::vector<PinDescriptor> m_outputs;
    std::map<std::string, std::any> m_pinData;
};
```

### 3.2 Controller Base Class

**Location**: `ui/blueprint/nodes/BaseNodeController.h`

**Purpose**: Standardize QML ↔ C++ property synchronization

```cpp
// ui/blueprint/nodes/BaseNodeController.h
class BaseNodeController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString nodeId READ nodeId WRITE setNodeId NOTIFY nodeIdChanged)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(QString variantType READ variantType NOTIFY variantTypeChanged)
    
public:
    explicit BaseNodeController(QObject* parent = nullptr)
        : QObject(parent), m_enabled(true) {}
    
    virtual ~BaseNodeController() = default;
    
    // Property getters
    QString nodeId() const { return m_nodeId; }
    bool enabled() const { return m_enabled; }
    QString variantType() const { return m_variantType; }
    
    // Property setters
    void setNodeId(const QString& id) {
        if (m_nodeId != id) {
            m_nodeId = id;
            emit nodeIdChanged();
        }
    }
    
    void setEnabled(bool enabled) {
        if (m_enabled != enabled) {
            m_enabled = enabled;
            updateBackendProperty("enabled", enabled);
            emit enabledChanged();
        }
    }
    
signals:
    void nodeIdChanged();
    void enabledChanged();
    void variantTypeChanged();
    void propertyUpdateRequested(QString nodeId, QString property, QVariant value);
    
protected:
    // Helper for derived classes
    void updateBackendProperty(const QString& property, const QVariant& value) {
        emit propertyUpdateRequested(m_nodeId, property, value);
    }
    
    void setVariantType(const QString& type) {
        if (m_variantType != type) {
            m_variantType = type;
            emit variantTypeChanged();
        }
    }
    
private:
    QString m_nodeId;
    bool m_enabled;
    QString m_variantType;
};
```

### 3.3 Visual Base Component

**Location**: `ui/blueprint/nodes/BaseNode.qml`

**Purpose**: Consistent visual appearance and interaction

```qml
// ui/blueprint/nodes/BaseNode.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 200
    height: 150
    radius: 8
    color: "#2C3E50"
    border.color: selected ? "#3498DB" : "transparent"
    border.width: 2
    
    // Public API
    property string title: "Base Node"
    property color headerColor: "#34495E"
    property alias contentItem: contentArea.children
    property bool selected: false
    property string nodeId: ""
    
    // Port configuration
    property bool showLeftPort: false      // Visual input (blue)
    property bool showRightPort: false     // Visual output (blue)
    property bool showTopPort: false       // Audio input (yellow)
    property bool showBottomPort: false    // Audio output (yellow)
    
    // Drag and drop
    property real dragStartX: 0
    property real dragStartY: 0
    
    // Header
    Rectangle {
        id: header
        width: parent.width
        height: 30
        color: headerColor
        radius: root.radius
        
        Text {
            anchors.centerIn: parent
            text: root.title
            color: "white"
            font.pixelSize: 14
            font.bold: true
        }
        
        // Corner rounding fix
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: root.radius
            color: headerColor
        }
    }
    
    // Content area
    Item {
        id: contentArea
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
    }
    
    // Universal Directional Ports
    
    // Left Port (Visual Input - Blue)
    Rectangle {
        id: leftPort
        visible: root.showLeftPort
        width: 12
        height: 12
        radius: 6
        color: "#3498DB"
        border.color: "#2980B9"
        border.width: 2
        anchors.left: parent.left
        anchors.leftMargin: -6
        anchors.verticalCenter: parent.verticalCenter
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onPressed: {
                // Signal pin connection start
                console.log("Left port pressed:", root.nodeId)
            }
        }
    }
    
    // Right Port (Visual Output - Blue)
    Rectangle {
        id: rightPort
        visible: root.showRightPort
        width: 12
        height: 12
        radius: 6
        color: "#3498DB"
        border.color: "#2980B9"
        border.width: 2
        anchors.right: parent.right
        anchors.rightMargin: -6
        anchors.verticalCenter: parent.verticalCenter
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onPressed: {
                console.log("Right port pressed:", root.nodeId)
            }
        }
    }
    
    // Top Port (Audio Input - Yellow)
    Rectangle {
        id: topPort
        visible: root.showTopPort
        width: 12
        height: 12
        radius: 6
        color: "#F39C12"
        border.color: "#D68910"
        border.width: 2
        anchors.top: parent.top
        anchors.topMargin: -6
        anchors.horizontalCenter: parent.horizontalCenter
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onPressed: {
                console.log("Top port pressed:", root.nodeId)
            }
        }
    }
    
    // Bottom Port (Audio Output - Yellow)
    Rectangle {
        id: bottomPort
        visible: root.showBottomPort
        width: 12
        height: 12
        radius: 6
        color: "#F39C12"
        border.color: "#D68910"
        border.width: 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -6
        anchors.horizontalCenter: parent.horizontalCenter
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onPressed: {
                console.log("Bottom port pressed:", root.nodeId)
            }
        }
    }
    
    // Drag and drop
    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: root
        cursorShape: Qt.OpenHandCursor
        
        onPressed: {
            root.z = 100  // Bring to front
            root.selected = true
            dragStartX = root.x
            dragStartY = root.y
            cursorShape = Qt.ClosedHandCursor
        }
        
        onReleased: {
            cursorShape = Qt.OpenHandCursor
        }
        
        onClicked: {
            root.selected = !root.selected
        }
    }
    
    // Selection glow effect
    layer.enabled: selected
    layer.effect: Glow {
        radius: 8
        samples: 16
        color: "#3498DB"
        spread: 0.5
    }
}
```

---

## 4. Node Variant System

### 4.1 Critical Design Rule: Function-Based Variants

**❌ WRONG APPROACH**: Provider-based variants
```
AudioNode/
├── QtMultimedia/         ❌ This is a PROVIDER, not a function
├── FFmpeg/               ❌ This is a PROVIDER, not a function
└── VLC/                  ❌ This is a PROVIDER, not a function
```

**✅ CORRECT APPROACH**: Function-based variants with provider widgets
```
AudioNode/
├── AudioFilePlayback/                    ✅ FUNCTION: Play audio files
│   ├── audiofileplaybacknode.qml
│   └── widgets/
│       ├── QtMultimediaPlayerWidget.qml      ← PROVIDER inside function
│       ├── FFmpegDecoderWidget.qml           ← PROVIDER inside function
│       └── VLCPlayerWidget.qml               ← PROVIDER inside function
│
├── MicrophoneInput/                      ✅ FUNCTION: Capture live mic
│   ├── microphoneinputnode.qml
│   └── widgets/
│       ├── ALSACaptureWidget.qml             ← PROVIDER inside function
│       └── PipeWireCaptureWidget.qml         ← PROVIDER inside function
│
└── AIBackgroundMusic/                    ✅ FUNCTION: Generate adaptive BGM
    ├── aibackgroundmusicnode.qml
    └── widgets/
        ├── GeminiMusicWidget.qml             ← PROVIDER inside function
        └── LocalONNXMusicWidget.qml          ← PROVIDER inside function
```

### 4.2 Naming Convention (ULTRA-SPECIFIC)

**Critical Rule**: ALL files must have long, contextual, grep-able names.

#### ✅ CORRECT Examples
```
audiofileplaybacknode.qml
audioclipplayerqtmultimediawidget.qml
videovr360equirectangularprojectionwidget.qml
mlvideosegmentationonnxmodelwidget.qml
videoscreencaptureregionselectorwidget.qml
audiomicrophoneinputcontrolswidget.qml
```

#### ❌ WRONG Examples
```
player.qml           ❌ What kind of player?
widget.qml           ❌ Meaningless
settings.qml         ❌ Settings for what?
node.qml             ❌ Which node?
controls.qml         ❌ Controls for what?
```

**Naming Formula**:
```
<NodeType><VariantFunction><ComponentType><Provider?><Purpose>.qml

Examples:
audio + fileplayback + node = audiofileplaybacknode.qml
audio + clipplayer + qtmultimedia + widget = audioclipplayerqtmultimediawidget.qml
video + vr360 + equirectangular + projection + widget = videovr360equirectangularprojectionwidget.qml
```

### 4.3 Variant Loading System

**Main Compositor** (`audionode.qml`):
```qml
// ui/blueprint/nodes/AudioNode/audionode.qml
import QtQuick 2.15
import "../" // Import BaseNode

Item {
    id: root
    
    // Property set by AudioManager when creating node
    property string variantType: "audiofileplayback"
    property string providerId: ""  // Optional: specific provider
    
    // Dynamic variant loader
    Loader {
        id: variantLoader
        anchors.fill: parent
        
        source: {
            switch(variantType) {
                case "audiofileplayback":
                    return "AudioFilePlayback/audiofileplaybacknode.qml"
                case "microphoneinput":
                    return "MicrophoneInput/microphoneinputnode.qml"
                case "aibackgroundmusic":
                    return "AIBackgroundMusic/aibackgroundmusicnode.qml"
                default:
                    console.warn("Unknown audio variant:", variantType)
                    return ""
            }
        }
        
        onLoaded: {
            console.log("Loaded audio variant:", variantType)
            if (providerId !== "") {
                item.providerId = providerId
            }
        }
    }
}
```

**Function Variant** (`AudioFilePlayback/audiofileplaybacknode.qml`):
```qml
// ui/blueprint/nodes/AudioNode/AudioFilePlayback/audiofileplaybacknode.qml
import QtQuick 2.15
import "../../" // Import BaseNode
import "../AudioClipPlayerWidget"

BaseNode {
    id: root
    title: "Audio File Playback"
    headerColor: "#E74C3C"  // Red for audio
    
    // Ports enabled
    showRightPort: true     // Visual output (waveform)
    showBottomPort: true    // Audio output
    
    // Controller
    property AudioFilePlaybackController controller: AudioFilePlaybackController {
        nodeId: root.nodeId
    }
    
    // Provider selection (optional)
    property string providerId: "qtmultimedia"  // Default provider
    
    // Load provider-specific widget
    Loader {
        id: providerWidgetLoader
        anchors.centerIn: parent
        
        source: {
            switch(providerId) {
                case "qtmultimedia":
                    return "../AudioClipPlayerWidget/audioclipplayerqtmultimediawidget.qml"
                case "ffmpeg":
                    return "../AudioClipPlayerWidget/audioclipplayerffmpegwidget.qml"
                case "vlc":
                    return "../AudioClipPlayerWidget/audioclipplayervlcwidget.qml"
                default:
                    return "../AudioClipPlayerWidget/audioclipplayerqtmultimediawidget.qml"
            }
        }
        
        onLoaded: {
            item.controller = root.controller
        }
    }
    
    // Optional: Provider selector dropdown
    ComboBox {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        
        model: ["Qt Multimedia", "FFmpeg", "VLC"]
        
        onActivated: {
            switch(currentIndex) {
                case 0: providerId = "qtmultimedia"; break
                case 1: providerId = "ffmpeg"; break
                case 2: providerId = "vlc"; break
            }
        }
    }
}
```

### 4.4 Complete Node Type Variants

#### AudioNode Variants
| Function | File | Provider Widgets | Purpose |
|----------|------|------------------|---------|
| Audio File Playback | `AudioFilePlayback/audiofileplaybacknode.qml` | QtMultimedia, FFmpeg, VLC | Play audio files |
| Microphone Input | `MicrophoneInput/microphoneinputnode.qml` | ALSA, PipeWire, JACK | Live mic capture |
| Audio Stream Capture | `AudioStreamCapture/audiostreamcapturenode.qml` | NDI, RTSP, HTTP | Network audio |
| AI Background Music | `AIBackgroundMusic/aibackgroundmusicnode.qml` | Gemini, ONNX | Adaptive BGM generation |

#### VideoNode Variants
| Function | File | Provider Widgets | Purpose |
|----------|------|------------------|---------|
| Video File Playback | `VideoFilePlayback/videofileplaybacknode.qml` | QtMultimedia, FFmpeg, VLC | Play video files |
| VR 360° Playback | `VR360Playback/vr360playbacknode.qml` | Equirectangular, Cubemap | Spherical video |
| VR 180° Playback | `VR180Playback/vr180playbacknode.qml` | Side-by-Side, Top-Bottom | Stereoscopic VR |
| Screen Capture | `ScreenCapture/screencapturenode.qml` | X11, Wayland, PipeWire | Desktop recording |

#### MLNode Variants
| Function | File | Provider Widgets | Purpose |
|----------|------|------------------|---------|
| Video Segmentation | `VideoSegmentation/videosegmentationnode.qml` | ONNX, TensorFlow, PyTorch | Semantic segmentation |
| Background Removal | `BackgroundRemoval/backgroundremovalnode.qml` | ONNX, ML Kit | Remove background |
| Gesture Recognition | `GestureRecognition/gesturerecognitionnode.qml` | MediaPipe, ONNX | Hand tracking |
| Depth Estimation | `DepthEstimation/depthestimationnode.qml` | MiDaS, DepthAnything | Monocular depth |

---

## 5. Rendering Pipeline Integration

### 5.1 Rendering Node Architecture

Rendering happens through **specialized backend nodes** in the execution graph:

```cpp
// core/src/scene-graph/nodes/RenderingNode/StereoRenderNode.h
class StereoRenderNode : public BaseNodeBackend {
public:
    StereoRenderNode(const std::string& id) : BaseNodeBackend(id, "StereoRender") {
        NodeMetadata meta;
        meta.displayName = "Stereo Renderer";
        meta.category = "Rendering/VR";
        meta.supportsGPU = true;
        setMetadata(meta);
        
        addInput("scene", "3D Scene", DataType::Scene());
        addInput("camera", "Camera", DataType::Camera());
        addInput("ipd", "IPD (m)", DataType::Scalar());
        
        addOutput("left_eye", "Left Eye", DataType::Texture2D());
        addOutput("right_eye", "Right Eye", DataType::Texture2D());
    }
    
    ExecutionResult process(ExecutionContext& ctx) override {
        auto* scene = getInputData<Scene>("scene");
        auto* camera = getInputData<Camera>("camera");
        float ipd = getInputData<float>("ipd", 0.063f);
        
        // Render left eye
        camera->setEyeOffset(-ipd / 2.0f);
        QRhiTexture* leftEye = renderSceneToTexture(ctx.rhi, scene, camera);
        
        // Render right eye
        camera->setEyeOffset(ipd / 2.0f);
        QRhiTexture* rightEye = renderSceneToTexture(ctx.rhi, scene, camera);
        
        // Reset camera
        camera->setEyeOffset(0.0f);
        
        setOutputData("left_eye", leftEye);
        setOutputData("right_eye", rightEye);
        
        return ExecutionResult::success();
    }
    
private:
    QRhiTexture* renderSceneToTexture(
        QRhi* rhi, 
        Scene* scene, 
        Camera* camera
    ) {
        // 1. Create framebuffer texture
        QRhiTexture* texture = rhi->newTexture(
            QRhiTexture::RGBA8,
            QSize(1920, 1920),
            1,
            QRhiTexture::RenderTarget
        );
        texture->create();
        
        // 2. Create render target
        QRhiTextureRenderTarget* rt = rhi->newTextureRenderTarget({texture});
        rt->create();
        
        // 3. Begin render pass
        QRhiCommandBuffer* cb = ctx.commandBuffer;
        cb->beginPass(rt, Qt::black, {1.0f, 0});
        
        // 4. Render scene geometry
        for (auto& mesh : scene->meshes) {
            renderMesh(cb, mesh, camera);
        }
        
        // 5. End pass
        cb->endPass();
        
        return texture;
    }
};
```

### 5.2 Complete Rendering Pipeline Nodes

#### Core Rendering Nodes
| Node | Backend Class | Inputs | Outputs | Purpose |
|------|---------------|--------|---------|---------|
| Camera | `CameraNode` | Transform | Camera | Virtual camera |
| Stitch | `StitchNode` | 4x Fisheye, STMap | Equirect 360° | Fisheye stitching |
| Stereo Render | `StereoRenderNode` | Scene, Camera, IPD | Left Eye, Right Eye | Dual-eye rendering |
| RTX Upscale | `RTXUpscaleNode` | Texture 4K | Texture 8K | AI upscaling |
| HDR Process | `HDRProcessNode` | Texture HDR | Texture SDR | Tone mapping |
| Preview | `PreviewNode` | Texture | Texture 1080p | Low-res preview |

#### Shader Integration

**Stitch Compute Shader** (`core/src/rendering/shaders/stitch.comp`):
```glsl
#version 450

layout(local_size_x = 16, local_size_y = 16) in;

layout(binding = 0) uniform sampler2D camera1;
layout(binding = 1) uniform sampler2D camera2;
layout(binding = 2) uniform sampler2D camera3;
layout(binding = 3) uniform sampler2D camera4;
layout(binding = 4) uniform sampler2D stmapTexture;
layout(binding = 5, rgba8) writeonly uniform image2D outputImage;

void main() {
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    vec2 uv = vec2(pixel) / vec2(imageSize(outputImage));
    
    // Load UV offset from STMap
    vec2 uvOffset = texture(stmapTexture, uv).rg;
    vec2 sourceUV = uv + uvOffset;
    
    // Determine which camera to sample from based on angle
    float angle = atan(sourceUV.y - 0.5, sourceUV.x - 0.5);
    vec4 color;
    
    if (angle < -PI/2) {
        color = texture(camera1, sourceUV);
    } else if (angle < 0) {
        color = texture(camera2, sourceUV);
    } else if (angle < PI/2) {
        color = texture(camera3, sourceUV);
    } else {
        color = texture(camera4, sourceUV);
    }
    
    imageStore(outputImage, pixel, color);
}
```

### 5.3 VR Headset Profile System

**Profile Definition** (`core/src/rendering/VRHeadsetProfile.h`):
```cpp
struct VRHeadsetProfile {
    std::string id;           // "quest3"
    std::string name;         // "Meta Quest 3"
    
    // Display
    uint32_t eyeWidth;        // 1920
    uint32_t eyeHeight;       // 1920
    float fovHorizontal;      // 110.0°
    float fovVertical;        // 96.0°
    float ipd;                // 0.063 meters
    
    // Encoding
    std::string codec;        // "h265", "av1", "av2"
    uint32_t bitrate;         // 100000 kbps
    uint32_t framerate;       // 90 Hz
    StereoFormat stereoFormat; // SIDE_BY_SIDE, TOP_BOTTOM, DUAL_STREAM
    
    // Streaming
    TransportProtocol transport;  // SRT, WEBRTC, WEBTRANSPORT
    uint16_t port;                // 9001
    bool enabled;                 // false
};
```

**Predefined Profiles**:
```cpp
// Meta Quest 3
VRHeadsetProfile quest3 = {
    .id = "quest3",
    .name = "Meta Quest 3",
    .eyeWidth = 1920,
    .eyeHeight = 1920,
    .fovHorizontal = 110.0f,
    .fovVertical = 96.0f,
    .ipd = 0.063f,
    .codec = "h265",
    .bitrate = 100000,
    .framerate = 90,
    .stereoFormat = StereoFormat::SIDE_BY_SIDE,
    .transport = TransportProtocol::WEBTRANSPORT,
    .port = 9001,
    .enabled = false
};

// Valve Index
VRHeadsetProfile valveIndex = {
    .id = "valve_index",
    .name = "Valve Index",
    .eyeWidth = 1440,
    .eyeHeight = 1600,
    .fovHorizontal = 130.0f,  // Widest FOV
    .fovVertical = 105.0f,
    .ipd = 0.063f,
    .codec = "h265",
    .bitrate = 150000,
    .framerate = 120,  // Highest framerate
    .stereoFormat = StereoFormat::SIDE_BY_SIDE,
    .transport = TransportProtocol::SRT,
    .port = 9002,
    .enabled = false
};

// HTC Vive Pro 2
VRHeadsetProfile vivePro2 = {
    .id = "vive_pro_2",
    .name = "HTC Vive Pro 2",
    .eyeWidth = 2448,  // Highest resolution
    .eyeHeight = 2448,
    .fovHorizontal = 120.0f,
    .fovVertical = 120.0f,
    .ipd = 0.063f,
    .codec = "av1",
    .bitrate = 200000,
    .framerate = 90,
    .stereoFormat = StereoFormat::DUAL_STREAM,  // AV2 multi-view
    .transport = TransportProtocol::WEBTRANSPORT,
    .port = 9003,
    .enabled = false
};
```

### 5.4 VirtualCam Multi-Profile Output

**Integration with Node Graph**:
```cpp
// core/src/compositor/VirtualCamManager.h
class VirtualCamManager {
public:
    void setGraph(NodeExecutionGraph* graph) {
        m_graph = graph;
    }
    
    void addProfile(const VRHeadsetProfile& profile) {
        m_profiles.push_back(profile);
        allocateFramebuffersForProfile(profile);
    }
    
    void renderFrame(double deltaTime) {
        // 1. Execute graph (generates left/right eye textures)
        ExecutionContext ctx;
        ctx.deltaTime = deltaTime;
        ctx.rhi = m_rhi;
        
        m_graph->execute(ctx);
        
        // 2. Get final render node output
        auto* outputNode = m_graph->getNode("stereo_render_output");
        QRhiTexture* leftEye = outputNode->getOutputData<QRhiTexture*>("left_eye");
        QRhiTexture* rightEye = outputNode->getOutputData<QRhiTexture*>("right_eye");
        
        // 3. Render for each enabled profile
        for (auto& profile : m_profiles) {
            if (!profile.enabled) continue;
            
            renderForProfile(profile, leftEye, rightEye);
        }
    }
    
private:
    NodeExecutionGraph* m_graph;
    std::vector<VRHeadsetProfile> m_profiles;
    QRhi* m_rhi;
    
    void renderForProfile(
        const VRHeadsetProfile& profile,
        QRhiTexture* leftEye,
        QRhiTexture* rightEye
    ) {
        // 1. Resize to profile resolution
        auto& fb = m_framebuffers[profile.id];
        fb.leftEye = resampleTexture(leftEye, profile.eyeWidth, profile.eyeHeight);
        fb.rightEye = resampleTexture(rightEye, profile.eyeWidth, profile.eyeHeight);
        
        // 2. Encode based on profile codec
        EncodedFrame frame;
        if (profile.codec == "h265") {
            frame = m_h265Encoder->encode(fb.leftEye, fb.rightEye, profile.stereoFormat);
        } else if (profile.codec == "av1") {
            frame = m_av1Encoder->encode(fb.leftEye, fb.rightEye, profile.stereoFormat);
        } else if (profile.codec == "av2") {
            // Use disparity map for inter-view prediction
            auto* flowNode = m_graph->getNode("optical_flow");
            MotionVectorField* vectors = flowNode->getOutputData<MotionVectorField*>("motion_vectors");
            frame = m_av2Encoder->encodeWithMetadata(fb.leftEye, fb.rightEye, vectors);
        }
        
        // 3. Stream based on profile transport
        if (profile.transport == TransportProtocol::WEBTRANSPORT) {
            m_webTransportStreamer->sendFrame(profile.id, frame);
        } else if (profile.transport == TransportProtocol::SRT) {
            m_srtStreamer->sendFrame(profile.id, frame);
        }
    }
    
    std::map<std::string, ProfileFramebuffer> m_framebuffers;
};
```

---

## 6. Complete Node Lifecycle

### 6.1 Node Creation Flow

```
Step 1: User opens AudioManager
   ↓
User selects "Audio File Playback" variant
   ↓
AudioManager calls: createNode("AudioNode", {variantType: "audiofileplayback"})
   ↓
Step 2: Graph creates backend node
   ↓
NodeExecutionGraph::addNode(std::make_shared<AudioFilePlaybackNode>("audio_001"))
   ↓
Step 3: QML creates visual node
   ↓
BlueprintCanvas instantiates: audionode.qml
   property string variantType: "audiofileplayback"
   ↓
Step 4: Variant loader activates
   ↓
Loader.source = "AudioFilePlayback/audiofileplaybacknode.qml"
   ↓
Step 5: Controller created
   ↓
AudioFilePlaybackController {
    nodeId: "audio_001"
    onPropertyChanged: updateBackend()
}
   ↓
Step 6: Node is live
   ↓
User can now:
- Drag to position
- Connect pins
- Adjust properties
- Select provider widget
```

### 6.2 Property Update Flow

```
User adjusts slider in QML → Controller setter called
   ↓
AudioFilePlaybackController::setVolume(0.8f)
   ↓
emit propertyUpdateRequested("audio_001", "volume", 0.8)
   ↓
GraphManager (Qt slot) receives signal
   ↓
m_graph->updateNodeProperty("audio_001", "volume", 0.8f)
   ↓
Backend node updated
   ↓
AudioFilePlaybackNode::setProperty("volume", 0.8f)
   m_volume = 0.8f;
   ↓
Next process() call uses new value
   ↓
AudioFilePlaybackNode::process(ctx) {
    applyVolume(m_audioBuffer, m_volume);
}
```

### 6.3 Execution Flow

```
Frame N begins
   ↓
VirtualCamManager::renderFrame(deltaTime = 1/90)
   ↓
ExecutionContext ctx;
ctx.deltaTime = 1/90;
ctx.rhi = vulkanRenderer->rhi();
   ↓
m_graph->execute(ctx);
   ↓
NodeExecutionGraph performs topological sort
   ↓
Execution order: [Camera → Stitch → OpticalFlow → StereoRender → Encoder → Stream]
   ↓
For each node in order:
   node->process(ctx);
   ↓
Example: StitchNode::process(ctx)
   1. Get input textures from pins
   2. Run compute shader (stitch.comp)
   3. Set output texture on pin
   ↓
Example: OpticalFlowNode::process(ctx)
   1. Get current + previous frame
   2. Compute motion vectors (GPU/NPU)
   3. Set vectors on BOTH outputs (encoder + client)
   ↓
Example: StereoRenderNode::process(ctx)
   1. Get scene and camera
   2. Render left eye (IPD offset)
   3. Render right eye (IPD offset)
   4. Set both textures on outputs
   ↓
Example: WebTransportOutputNode::process(ctx)
   1. Get left/right textures
   2. Get motion vectors
   3. Send metadata datagram (unreliable, high priority)
   4. Encode video with AV2 (uses motion vectors)
   5. Send video stream (reliable, ordered)
   ↓
Frame N complete
```

---

## 7. Critical Implementation Details

### 7.1 Correct Triple Buffering

**❌ WRONG (from destroyed docs)**:
```cpp
struct FramebufferSet {
    QRhiTexture* buffers[3];
    uint32_t currentBuffer = 0;
};
void swapBuffers(FramebufferSet& set) {
    set.currentBuffer = (set.currentBuffer + 1) % 3;
}
```

**✅ CORRECT**:
```cpp
struct FramebufferSet {
    QRhiTexture* buffers[3];
    std::atomic<uint32_t> writeIndex{0};
    std::atomic<uint32_t> readIndex{0};
    std::mutex swapMutex;
    
    // CPU writes to this buffer
    QRhiTexture* acquireWriteBuffer() {
        std::lock_guard lock(swapMutex);
        return buffers[writeIndex % 3];
    }
    
    // CPU finished writing
    void submitWriteBuffer() {
        writeIndex.fetch_add(1);
    }
    
    // GPU reads from this buffer
    QRhiTexture* acquireReadBuffer() {
        std::lock_guard lock(swapMutex);
        // Wait if writeIndex hasn't advanced
        while (readIndex >= writeIndex) {
            std::this_thread::yield();
        }
        return buffers[readIndex % 3];
    }
    
    // GPU finished rendering
    void releaseReadBuffer() {
        readIndex.fetch_add(1);
    }
};
```

### 7.2 Zero-Copy UMA Architecture

```cpp
// Unified Memory Address space (shared RAM/VRAM)
struct FrameBuffer {
    void* ptr;          // Pointer to UMA memory
    size_t size;        // 7680 × 4320 × 4 = 132MB per frame
    uint32_t id;        // Unique ID
    
    // No copy operations!
    FrameBuffer(const FrameBuffer&) = delete;
    FrameBuffer& operator=(const FrameBuffer&) = delete;
    
    // Only moves
    FrameBuffer(FrameBuffer&&) = default;
};

// Usage example
void processVideo(FrameBuffer& frame) {
    // Pass pointer to NPU (no copy)
    npuOpticalFlow(frame.ptr, frame.size);
    
    // Pass same pointer to encoder (no copy)
    av2Encoder->encode(frame.ptr, frame.size);
    
    // Pass same pointer to network (no copy)
    webTransportStreamer->send(frame.ptr, frame.size);
}
```

### 7.3 Pin Type Safety

```cpp
// Type-safe pin connections
class PinConnection {
public:
    bool isCompatible(const DataType& source, const DataType& dest) const {
        // 1. Exact match
        if (source == dest) return true;
        
        // 2. Any type accepts everything
        if (dest.category() == DataCategory::Composite && 
            dest.name() == "Any") {
            return true;
        }
        
        // 3. Implicit conversions
        if (source.name() == "Texture2D" && dest.name() == "VideoFrame") {
            return true;  // Texture can become VideoFrame
        }
        
        // 4. Scalar broadcast
        if (source.name() == "Scalar" && dest.name() == "Vector3") {
            return true;  // Scalar → (x, x, x)
        }
        
        return false;
    }
};
```

---

## 8. File Structure & Organization

### 8.1 Complete Directory Tree

```
Neural-Studio/
├── core/                                    # C++ Backend
│   ├── src/
│   │   ├── scene-graph/                     # Node Graph System
│   │   │   ├── IExecutableNode.h/cpp        # ✅ Interface
│   │   │   ├── NodeExecutionGraph.h/cpp     # ✅ Graph engine
│   │   │   ├── BaseNodeBackend.h/cpp        # ✅ Base backend class
│   │   │   ├── NodeFactory.h/cpp            # ✅ Plugin registration
│   │   │   ├── SceneManager.h/cpp           # ❌ MISSING (bridge to USD/rendering)
│   │   │   │
│   │   │   └── nodes/                       # Concrete node types
│   │   │       ├── AudioNode/
│   │   │       │   ├── AudioFilePlaybackNode.h/cpp
│   │   │       │   ├── MicrophoneInputNode.h/cpp
│   │   │       │   └── AudioStreamCaptureNode.h/cpp
│   │   │       │
│   │   │       ├── VideoNode/
│   │   │       │   ├── VideoFilePlaybackNode.h/cpp
│   │   │       │   ├── VR360PlaybackNode.h/cpp
│   │   │       │   └── ScreenCaptureNode.h/cpp
│   │   │       │
│   │   │       ├── CameraNode/
│   │   │       │   ├── CameraNode.h/cpp
│   │   │       │   └── StereoVRCameraNode.h/cpp
│   │   │       │
│   │   │       ├── RenderingNode/
│   │   │       │   ├── StitchNode.h/cpp             # ✅ Implemented
│   │   │       │   ├── StereoRenderNode.h/cpp       # ✅ Implemented
│   │   │       │   ├── RTXUpscaleNode.h/cpp         # ⚠️  Linux incompatible
│   │   │       │   ├── HDRProcessNode.h/cpp         # ✅ Implemented
│   │   │       │   └── PreviewNode.h/cpp            # ✅ Implemented
│   │   │       │
│   │   │       ├── MLNode/
│   │   │       │   ├── OpticalFlowNode.h/cpp        # ❌ MISSING (CRITICAL)
│   │   │       │   ├── DisparityMapNode.h/cpp       # ❌ MISSING (CRITICAL)
│   │   │       │   ├── VideoSegmentationNode.h/cpp
│   │   │       │   └── BackgroundRemovalNode.h/cpp
│   │   │       │
│   │   │       └── StreamingNode/
│   │   │           ├── WebTransportOutputNode.h/cpp # ❌ MISSING (CRITICAL)
│   │   │           ├── SRTOutputNode.h/cpp
│   │   │           ├── AV1EncoderNode.h/cpp
│   │   │           └── AV2EncoderNode.h/cpp         # ❌ MISSING
│   │   │
│   │   ├── rendering/                       # Rendering Engine
│   │   │   ├── VulkanRenderer.h/cpp         # ✅ Qt RHI wrapper
│   │   │   ├── StereoRenderer.h/cpp         # ✅ Dual-pass rendering
│   │   │   ├── FramebufferManager.h/cpp     # ⚠️  Needs triple buffer fix
│   │   │   ├── STMapLoader.h/cpp            # ✅ Fisheye calibration
│   │   │   ├── PreviewRenderer.h/cpp        # ✅ Low-res preview
│   │   │   ├── RTXUpscaler.h/cpp            # ⚠️  Use TensorRT instead
│   │   │   ├── HDRProcessor.h/cpp           # ✅ Color space conversion
│   │   │   │
│   │   │   └── shaders/
│   │   │       ├── stitch.comp              # ✅ Fisheye → Equirect
│   │   │       ├── stereo.vert              # ✅ Full-screen quad
│   │   │       ├── stereo.frag              # ✅ Stereo compositing
│   │   │       ├── hdr_tonemap.comp         # ✅ HDR tone mapping
│   │   │       └── compile_shaders.sh       # ✅ GLSL → SPIR-V
│   │   │
│   │   ├── streaming/                       # Network Transport
│   │   │   ├── WebTransportStreamer.h/cpp   # ❌ MISSING (CRITICAL)
│   │   │   ├── MoQPacketizer.h/cpp          # ❌ MISSING
│   │   │   └── SRTStreamer.h/cpp            # ⚠️  Partial
│   │   │
│   │   ├── ml/                              # ML/AI Processing
│   │   │   ├── OpticalFlowEngine.h/cpp      # ❌ MISSING (OpenCV CUDA)
│   │   │   └── DisparityEstimator.h/cpp     # ❌ MISSING (SGBM)
│   │   │
│   │   ├── usd/                             # USD Integration
│   │   │   ├── UsdStageManager.h/cpp        # ❌ MISSING (CRITICAL)
│   │   │   └── UsdConversions.h             # ❌ MISSING
│   │   │
│   │   ├── compositor/                      # VirtualCam
│   │   │   └── VirtualCamManager.h/cpp      # ✅ Multi-profile output
│   │   │
│   │   └── bridge/                          # Integration Layer
│   │       └── GraphToVirtualCamBridge.h/cpp # ❌ MISSING (CRITICAL)
│   │
│   └── CMakeLists.txt
│
├── ui/                                      # QML Frontend
│   ├── blueprint/
│   │   ├── activeframe/
│   │   │   └── ActiveFrame.qml              # ✅ Live operator view
│   │   │
│   │   ├── blueprintframe/
│   │   │   ├── BlueprintFrame.qml           # ✅ Visual graph editor
│   │   │   └── GraphCanvas.qml              # ✅ Node canvas
│   │   │
│   │   └── nodes/
│   │       ├── BaseNode.qml                 # ✅ Visual base class
│   │       ├── BaseNodeController.h         # ✅ Controller base class
│   │       │
│   │       ├── AudioNode/
│   │       │   ├── audionode.qml            # ✅ Main compositor
│   │       │   │
│   │       │   ├── AudioFilePlayback/
│   │       │   │   └── audiofileplaybacknode.qml
│   │       │   │
│   │       │   ├── MicrophoneInput/
│   │       │   │   └── microphoneinputnode.qml
│   │       │   │
│   │       │   ├── AudioClipPlayerWidget/
│   │       │   │   ├── audioclipplayerqtmultimediawidget.qml
│   │       │   │   ├── audioclipplayerffmpegwidget.qml
│   │       │   │   └── audioclipplayervlcwidget.qml
│   │       │   │
│   │       │   └── AudioClipSettingsWidget/
│   │       │       └── audioclipsettingswidget.qml
│   │       │
│   │       ├── VideoNode/
│   │       │   ├── videonode.qml
│   │       │   │
│   │       │   ├── VideoFilePlayback/
│   │       │   │   └── videofileplaybacknode.qml
│   │       │   │
│   │       │   ├── VR360Playback/
│   │       │   │   └── vr360playbacknode.qml
│   │       │   │
│   │       │   └── VideoPlayerWidget/
│   │       │       ├── videoplayerqtmultimediawidget.qml
│   │       │       └── videoplayerffmpegwidget.qml
│   │       │
│   │       ├── CameraNode/
│   │       │   └── (similar structure)
│   │       │
│   │       ├── MLNode/
│   │       │   ├── mlnode.qml
│   │       │   │
│   │       │   ├── VideoSegmentation/
│   │       │   │   ├── videosegmentationnode.qml
│   │       │   │   └── widgets/
│   │       │   │       ├── videosegmentationonnxwidget.qml
│   │       │   │       └── videosegmentationtensorflowwidget.qml
│   │       │   │
│   │       │   └── BackgroundRemoval/
│   │       │       └── backgroundremovalnode.qml
│   │       │
│   │       └── StreamingNode/
│   │           ├── streamingnode.qml
│   │           │
│   │           ├── WebTransportOutput/
│   │           │   └── webtransportoutputnode.qml
│   │           │
│   │           └── SRTOutput/
│   │               └── srtoutputnode.qml
│   │
│   └── shared_ui/
│       └── managers/
│           ├── AudioManager/                # ✅ Node factory
│           ├── VideoManager/                # ✅ Node factory
│           ├── CameraManager/
│           ├── MLManager/
│           └── StreamingManager/
│
└── rust/                                    # Rust Components
    └── webtransport/                        # ❌ MISSING (CRITICAL)
        ├── Cargo.toml
        └── src/
            ├── lib.rs
            └── ffi.rs                       # C FFI bindings
```

### 8.2 File Naming Examples

**✅ CORRECT Long Names**:
```
audiofileplaybacknode.qml
audioclipplayerqtmultimediawidget.qml
videovr360equirectangularprojectionwidget.qml
mlvideosegmentationonnxmodelwidget.qml
videoscreencaptureregionselectorwidget.qml
webtransportoutputmetadatastreamwidget.qml
```

**❌ WRONG Short Names**:
```
player.qml
widget.qml
node.qml
settings.qml
output.qml
```

---

## 9. Implementation Roadmap

### Phase 1: Critical Missing Components (Week 1-2)

**Goal**: Connect the disconnected pieces

**CRITICAL TASKS**:

1. ✅ **SceneManager** (`core/src/scene-graph/SceneManager.h/cpp`)
   - Bridges NodeExecutionGraph ↔ USD ↔ Rendering
   - Methods: `openUsdStage()`, `syncFromUsd()`, `syncToUsd()`

2. ✅ **UsdStageManager** (`core/src/usd/UsdStageManager.h/cpp`)
   - Wraps `pxr::UsdStageRefPtr`
   - Methods: `extractMesh()`, `extractTransform()`, `updatePrimTransform()`

3. ✅ **GraphToVirtualCamBridge** (`core/src/bridge/GraphToVirtualCamBridge.h/cpp`)
   - Connects NodeExecutionGraph → VirtualCamManager
   - Executes graph, extracts render outputs, feeds to multi-profile encoder

4. ✅ **Fix Triple Buffering** (`core/src/rendering/FramebufferManager.cpp`)
   - Replace wrong circular index with atomic write/read indices
   - Add mutex for swap operations

5. ✅ **WebTransportStreamer** (Rust `rust/webtransport/src/lib.rs` + C++ wrapper)
   - Rust: `wtransport` crate for QUIC/WebTransport
   - C++: FFI wrapper for integration

6. ✅ **OpticalFlowNode** (`core/src/ml/OpticalFlowNode.h/cpp`)
   - OpenCV CUDA or NPU implementation
   - Outputs motion vectors for BOTH encoder and client

7. ✅ **DisparityMapNode** (`core/src/ml/DisparityMapNode.h/cpp`)
   - SGBM algorithm for stereo depth
   - Outputs disparity map for AV2 inter-view prediction

8. ✅ **AV2EncoderNode** (`core/src/streaming/AV2EncoderNode.h/cpp`)
   - Integrate `libaom` (AVM branch)
   - Use disparity map for 50% bandwidth reduction

9. ✅ **WebTransportOutputNode** (`core/src/scene-graph/nodes/StreamingNode/WebTransportOutputNode.cpp`)
   - Send metadata datagrams (high priority, unreliable)
   - Send video streams (reliable, ordered)

**Deliverable**: Complete graph → render → encode → stream pipeline works

---

### Phase 2: Node Variant System (Week 3-4)

**Goal**: Complete function-based variant architecture

**TASKS**:

1. ✅ **Complete AudioNode Variants**
   - AudioFilePlayback (with Qt/FFmpeg/VLC widgets)
   - MicrophoneInput (with ALSA/PipeWire widgets)
   - AudioStreamCapture (with NDI/RTSP widgets)

2. ✅ **Complete VideoNode Variants**
   - VideoFilePlayback
   - VR360Playback (with Equirectangular widget)
   - VR180Playback (with SBS/TB widgets)
   - ScreenCapture (with X11/Wayland widgets)

3. ✅ **Complete MLNode Variants**
   - VideoSegmentation (with ONNX/TF/PyTorch widgets)
   - BackgroundRemoval
   - GestureRecognition
   - DepthEstimation

4. ✅ **Manager Integration**
   - Each manager becomes a variant factory
   - Dropdown selector for function variants
   - Dynamic widget loading

**Deliverable**: Full variant system with provider widgets

---

### Phase 3: USD Production Workflow (Week 5-6)

**Goal**: Complete bidirectional USD integration

**TASKS**:

1. ✅ **Transform Synchronization**
   - Signal-based change propagation
   - Graph → USD and USD → Graph

2. ✅ **USD Export**
   - Convert graph nodes to USD prims
   - Preserve node properties as USD attributes

3. ✅ **USD Import**
   - Support UsdGeomMesh, UsdGeomCamera, UsdLuxLight
   - Create corresponding graph nodes

4. ✅ **Test Workflow**:
   ```
   1. Import Blender USD scene
   2. Add ML processing nodes (segmentation)
   3. Add rendering nodes (stereo render)
   4. Export to USD with baked results
   5. Reimport in Blender
   ```

**Deliverable**: Full USD roundtrip capability

---

### Phase 4: Production Hardening (Week 7-8)

**Goal**: Stable, deployable system

**TASKS**:

1. ✅ **Performance Profiling**
   - Identify graph execution bottlenecks
   - Optimize hot paths (shader compilation, texture uploads)

2. ✅ **Error Recovery**
   - Graceful node failure handling
   - Automatic retry policies for transient errors

3. ✅ **Unit Tests**
   - 80% code coverage target
   - Integration tests for full pipeline

4. ✅ **Documentation**
   - API reference (Doxygen)
   - User guide (Markdown)
   - Video tutorials

**Deliverable**: Production-ready v1.0

---

## Appendix A: Critical Fixes Summary

| Issue | Location | Status | Priority |
|-------|----------|--------|----------|
| SceneManager missing | `core/src/scene-graph/` | ❌ Not implemented | 🔴 CRITICAL |
| UsdStageManager missing | `core/src/usd/` | ❌ Not implemented | 🔴 CRITICAL |
| GraphToVirtualCamBridge missing | `core/src/bridge/` | ❌ Not implemented | 🔴 CRITICAL |
| WebTransportStreamer missing | `rust/webtransport/` + `core/src/streaming/` | ❌ Not implemented | 🔴 CRITICAL |
| OpticalFlowNode missing | `core/src/ml/` | ❌ Not implemented | 🔴 CRITICAL |
| DisparityMapNode missing | `core/src/ml/` | ❌ Not implemented | 🔴 CRITICAL |
| AV2EncoderNode missing | `core/src/streaming/` | ❌ Not implemented | 🔴 CRITICAL |
| WebTransportOutputNode missing | `core/src/scene-graph/nodes/StreamingNode/` | ❌ Not implemented | 🔴 CRITICAL |
| Triple buffering wrong | `core/src/rendering/FramebufferManager.cpp` | ⚠️  Needs fix | 🟡 HIGH |
| RTX on Linux unsupported | `core/src/rendering/RTXUpscaler.cpp` | ⚠️  Use TensorRT | 🟡 HIGH |
| Node variants incomplete | `ui/blueprint/nodes/` | ⚠️  Partial | 🟡 HIGH |
| Provider widgets missing | `ui/blueprint/nodes/*/widgets/` | ⚠️  Partial | 🟢 MEDIUM |

---

**End of Document**

**Maintainer**: Neural Studio Team  
**Last Updated**: 2025-12-17  
**Version**: 2.0.0 (Complete Blueprint System Architecture)
