Neural Studio - Final Repository Structure
Top-Level Organization
Neural-Studio/
├── test/                    # All test suites (unit, integration, e2e)
├── build/                   # Build artifacts and CMake configuration (Ubuntu/Pop!_OS only)
├── dependencies/            # Third-party dependencies
├── docs/                    # Documentation
├── api/                     # Public API definitions
├── core/                    # Core engine and backend systems
├── ui/                      # User interface layer
├── drivers/                 # Hardware-specific functionality bridges
├── plugins/                 # Functionality plugins (not hardware-specific) 
├── addons/                  # WASM-based user/company integrations
├── profiles/                # Device/system configuration profiles
├── models/                  # AI/ML model files
└── assets/                  # Production media and resources
Detailed Structure



UI:

``markdown
. 📂 ui
├── 📄 CMakeLists.txt
├── 📄 UI_COMPONENT_DESIGN_RULES.md
└── 📂 activeui/
│  └── 📂 controls/
│    └── 📂 ExtraModules/
│    └── 📂 MoreModules/
│    └── 📂 SceneButtons/
│    ├── 📄 SourceToolbar.qml
│    ├── 📄 StatusBar.qml
│    └── 📂 ThreeDModule/
│  └── 📂 monitors/
│    ├── 📄 AudioMeterChannel.qml
│    └── 📂 AudioMixer/
│    └── 📂 CamModule/
│    └── 📂 MonitorGrid/
│    └── 📂 MonitorWidget/
│    └── 📂 VideoModule/
│  └── 📂 panels/
│    ├── 📄 AudioMixerPanel.qml
│    ├── 📄 ControlsPanel.qml
│    ├── 📄 DockPanel.qml
│    ├── 📄 ScenesPanel.qml
│    ├── 📄 SourcesPanel.qml
│    ├── 📄 TransitionsPanel.qml
│  └── 📂 preview/
│    ├── 📄 FloatingPreviewWindow.qml
│    ├── 📄 MainPreview.qml
└── 📂 app/
│  ├── 📄 CMakeLists.txt
│  ├── 📄 CornerButton.qml
│  ├── 📄 FrameContext.qml
│  ├── 📄 MainWindow.qml
│  ├── 📄 MaterialIcon.qml
│  ├── 📄 SlidingPanel.qml
│  ├── 📄 qmldir
└── 📂 blueprint/
│  ├── 📄 BlueprintCanvas.qml
│  ├── 📄 CMakeLists.txt
│  └── 📂 core/
│    ├── 📄 CMakeLists.txt
│    ├── 📄 NodeGraphController.cpp
│    ├── 📄 NodeGraphController.h
│  └── 📂 nodes/
│    └── 📂 AudioNode/
│    ├── 📄 BaseNode.qml
│    ├── 📄 BaseNodeController.cpp
│    ├── 📄 BaseNodeController.h
│    ├── 📄 CMakeLists.txt
│    └── 📂 CameraNode/
│    └── 📂 EffectNode/
│    └── 📂 FilterNode/
│    └── 📂 FontNode/
│    └── 📂 GeminiNode/
│    └── 📂 GraphicsNode/
│    └── 📂 HeadsetOutputNode/
│    └── 📂 ImageNode/
│    └── 📂 LLMTranscriptionNode/
│    └── 📂 OnnxNode/
│    └── 📂 RTXUpscaleNode/
│    └── 📂 ScriptNode/
│    └── 📂 ShaderNode/
│    └── 📂 StitchNode/
│    └── 📂 TextureNode/
│    └── 📂 ThreeDModelNode/
│    └── 📂 TransitionNode/
│    └── 📂 VideoNode/
│    └── 📂 WasmNode/
│  └── 📂 panels/
│    └── 📂 PropertiesPanel/
│  └── 📂 preview/
│    ├── 📄 BasePreview.qml
│    ├── 📄 BasePreviewController.cpp
│    ├── 📄 BasePreviewController.h
│    ├── 📄 CMakeLists.txt
│    ├── 📄 ScenePreview.qml
│    ├── 📄 StereoPreview.qml
│  └── 📂 viewmodels/
│  └── 📂 widgets/
│    └── 📂 ConnectionItem/
│    └── 📂 NodeItem/
│    └── 📂 PortItem/
└── 📂 frames/
│  ├── 📄 ActiveFrame.qml
│  ├── 📄 BlueprintFrame.qml
│  ├── 📄 CMakeLists.txt
└── 📂 panels/
│  ├── 📄 AIChatPanel.qml
│  ├── 📄 CMakeLists.txt
│  ├── 📄 DockChatPanel.qml
│  ├── 📄 SettingsPanel.qml
└── 📂 shared_ui/
│  ├── 📄 CMakeLists.txt
│  └── 📂 components/
│  └── 📂 forms/
│  └── 📂 managers/
│    └── 📂 AudioManager/
│    ├── 📄 BaseManager.qml
│    ├── 📄 BaseManagerController.cpp
│    ├── 📄 BaseManagerController.h
│    ├── 📄 BaseManagerWidget.cpp
│    ├── 📄 BaseManagerWidget.h
│    ├── 📄 CMakeLists.txt
│    └── 📂 CameraManager/
│    └── 📂 EffectsManager/
│    └── 📂 FontManager/
│    └── 📂 GraphicsManager/
│    └── 📂 LLMManager/
│    └── 📂 MLManager/
│    ├── 📄 README_MANAGERS.md
│    └── 📂 ScriptManager/
│    └── 📂 ShaderManager/
│    └── 📂 TextureManager/
│    └── 📂 ThreeDAssetsManager/
│    └── 📂 VideoManager/
│  └── 📂 scenegraph_layermixer_virtualcam/
│    ├── 📄 CMakeLists.txt
│    ├── 📄 LayerMixerControl.qml
│    ├── 📄 SceneGraphMixerController.cpp
│    ├── 📄 SceneGraphMixerController.h
│    ├── 📄 SceneGraphMixerPanel.qml
│    ├── 📄 VirtualCamPreview.qml
│    └── 📂 components/
│  └── 📂 themes/
│  └── 📂 widgets/
│    └── 📂 properties-view/
```

Key Design Principles
Co-location: Forms, QML, and UI definitions live with the component they serve
Semantic Organization: Each top-level folder has clear semantic subfolders
Hardware vs. Functionality:
Drivers = Hardware-specific bridges
Plugins = Functionality extensions (C++)
Addons = Safe WASM integrations
Ubuntu/Pop!_OS Only: No Windows/macOS platform code
3D-First Design: Compositor supports 2D but prioritizes 3D workflows
OpenGL Legacy: Kept for backward compatibility with plugins/addons
Migration Notes
Platform-specific code → core/lib/platform/ (Ubuntu only)
Legacy Windows dependencies (w32-pthreads, libdshowcapture) → Mark for removal
Localization files → ui/shared_ui/locale/
Cryptographic keys → core/keys/
All utilities → core/utilities/ (don't over-organize)

---

## Phase 2 Module Descriptions

### core/src/rendering/ - VR Stereo Rendering Engine
Hardware-accelerated VR180/360 rendering using Qt RHI (Rendering Hardware Interface). Abstracts Vulkan, OpenGL, and Metal backends for cross-platform compatibility. Processes **4K SBS (side-by-side) input video** containing 2x 2K stereo frames. Pipeline: split SBS → STMap fisheye stitching per eye → dual-pass 3D overlay rendering (L/R with IPD offset) → composite 3D over video → **per-headset profile outputs** (Quest 3, Index, Vive Pro 2). HDR support (Rec.2020 PQ/HLG) for high-quality VR streaming.

**Key Components**: VulkanRenderer (RHI init, swap chain), StereoRenderer (SBS split, dual-pass 3D, IPD offset), FramebufferManager (per-profile FBOs), STMapLoader (TIFF UV remap), RTXUpscaler (NVIDIA AI 4K→8K), HDRProcessor (tone mapping).

**Input**: Single 4K SBS video feed (2x 2K L/R frames side-by-side) OR dual separate camera streams (AV2 multi-stream ready)  
**Output**: Multiple per-headset profile streams with 3D objects composited over stitched video