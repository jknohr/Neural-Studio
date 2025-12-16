# Neural Studio: WASM Integration SDK
## Third-Party Plugin Architecture & Integration Protocol

**Version**: 1.0.0  
**Date**: 2025-12-17  
**Status**: SDK Specification (Reference Implementation)

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Integration Philosophy](#2-integration-philosophy)
3. [WASM Container Architecture](#3-wasm-container-architecture)
4. [Integration Point Registry](#4-integration-point-registry)
5. [Blueprint System Integration](#5-blueprint-system-integration)
6. [Agentic System Integration](#6-agentic-system-integration)
7. [Streaming Service Dock Integration](#7-streaming-service-dock-integration)
8. [Browser/UI Integration](#8-browserui-integration)
9. [ML Model Integration](#9-ml-model-integration)
10. [SDK Protocol Specification](#10-sdk-protocol-specification)
11. [Example Implementations](#11-example-implementations)
12. [Security & Sandboxing](#12-security--sandboxing)

---

## 1. Executive Summary

### The Vision

**Problem**: Traditional plugin systems require:
- Native code compilation per platform (Windows, Linux, macOS)
- Direct memory access (security risk)
- Tight coupling with core software (version conflicts)
- Manual integration point discovery

**Solution**: WASM Container Architecture
- **Write Once, Run Anywhere**: WASM binary works on all platforms
- **Sandboxed Execution**: No direct memory access, controlled I/O
- **Declarative Integration**: Manifest file defines integration points
- **Automatic Discovery**: Core system reads manifest, creates connections

### Key Innovations

1. **Declarative Integration Manifest**: Plugin declares capabilities
2. **Automatic Wire-Up**: Core system connects plugin to integration points
3. **Taxonomic ID System**: Plugins use same ID format as core nodes
4. **Multi-Runtime Support**: ONNX, Gemini SDK, WasmEdge coexist
5. **Agentic Coordination**: AI system learns plugin behavior

---

## 2. Integration Philosophy

### Core Principle: "Declare, Don't Code"

**Traditional Approach** (What we're AVOIDING):
```cpp
// ❌ Plugin manually calls core APIs
class StripChatPlugin {
    void onLoad() {
        // Plugin must know internal structure
        auto dockManager = CoreAPI::getDockManager();
        auto chatDock = dockManager->createDock("StripChat");
        
        // Plugin must know blueprint structure
        auto blueprint = CoreAPI::getBlueprintEngine();
        blueprint->registerNode("StripChatOverlay");
        
        // Brittle, version-dependent
    }
};
```

**Neural Studio Approach** (What we're IMPLEMENTING):
```toml
# ✅ Plugin declares capabilities in manifest
[manifest]
name = "StripChat Integration"
version = "1.0.0"
author = "StripChat Inc."
wasm_module = "stripchat_plugin.wasm"

[integration_points]
# System automatically creates these connections

[[integration_points.blueprint_nodes]]
node_type = "NVD"  # VideoNode ethnicity
archetype = "SC"   # StripChat archetype
symbiotic_prefix = "NVDSC"
display_name = "StripChat Overlay"
widgets = ["StripChatChatWidget", "StripChatTipWidget"]

[[integration_points.docks]]
dock_id = "stripchat_chat"
dock_title = "StripChat Chat"
dock_location = "right"
browser_url = "https://stripchat.com/chat"

[[integration_points.agentic]]
intent_keywords = ["stripchat", "tip", "chat", "viewer"]
ai_capabilities = ["tip_notifications", "viewer_stats", "chat_moderation"]

[[integration_points.streaming]]
service = "stripchat"
protocol = "rtmp"
supports_metadata = true
```

**Result**: Plugin author never touches C++ core. System reads manifest, creates all integrations automatically.

---

## 3. WASM Container Architecture

### Container Structure

```
stripchat_plugin.wasm/
├── manifest.toml              # Integration point declarations
├── plugin.wasm                # WASM binary (WasmEdge runtime)
├── models/                    # Optional ML models
│   ├── tip_predictor.onnx
│   └── chat_sentiment.onnx
├── assets/                    # UI assets
│   ├── icons/
│   ├── stylesheets/
│   └── html/
└── schemas/                   # ObjectBox schema extensions
    ├── StripChatSettings.fbs
    └── StripChatPipeline.fbs
```

### Runtime Environments

Neural Studio supports **three runtime environments** for plugins:

#### 1. WasmEdge (Primary)
**Use Case**: General-purpose plugins (UI, effects, data processing)

```toml
[runtime]
type = "wasmedge"
version = "0.13.0"
features = ["wasi", "wasi-nn", "wasi-crypto"]
```

**Capabilities**:
- Full WASI support (file I/O, networking)
- WASI-NN for ML inference
- Sandboxed execution

#### 2. ONNX Runtime (ML Models)
**Use Case**: Standalone ML inference (background removal, segmentation)

```toml
[runtime]
type = "onnx"
version = "1.17.0"
model_path = "models/background_remover.onnx"
input_shape = [1, 3, 720, 1280]
output_shape = [1, 1, 720, 1280]
```

**Capabilities**:
- GPU acceleration (CUDA, DirectML, CoreML)
- Optimized inference
- No code execution (pure model)

#### 3. Gemini SDK (AI Agents)
**Use Case**: Conversational AI, content analysis, code generation

```toml
[runtime]
type = "gemini"
version = "2.0"
model = "gemini-2.0-flash-exp"
capabilities = ["vision", "code", "function_calling"]
```

**Capabilities**:
- Multimodal input (text, image, video)
- Function calling (integrate with blueprint)
- Streaming responses

### Hybrid Plugins

Plugins can use **multiple runtimes**:

```toml
[runtime]
primary = "wasmedge"           # Main plugin logic
secondary = ["onnx", "gemini"] # Additional capabilities

[[secondary_models]]
type = "onnx"
name = "face_detector"
path = "models/face_detection.onnx"

[[secondary_models]]
type = "gemini"
name = "content_analyzer"
api_key = "${GEMINI_API_KEY}"  # User provides
```

**Example Flow**:
```
User drops video into blueprint
  ↓
WasmEdge plugin receives frame
  ↓
Plugin calls ONNX face detector
  ↓
Plugin calls Gemini for content analysis
  ↓
Plugin outputs annotated frame
```

---

## 4. Integration Point Registry

### The Five Integration Categories

Every plugin must declare which systems it integrates with:

```toml
[integration_points]
# 1. Blueprint System (node graph)
blueprint = true

# 2. Agentic System (AI assistant)
agentic = true

# 3. Streaming Docks (service integrations)
streaming_docks = true

# 4. Browser/UI (custom web interfaces)
browser_ui = true

# 5. ML Pipeline (model inference)
ml_pipeline = true
```

### Integration Point Structure

```cpp
// Core system representation
struct IntegrationPoint {
    string id;                    // Unique identifier
    string plugin_id;             // Parent plugin
    IntegrationType type;         // Blueprint, Agentic, Dock, etc.
    
    // Taxonomic ID (if blueprint node)
    optional<TaxonomicID> node_id;
    
    // Connection metadata
    map<string, string> metadata;
    
    // Capability flags
    vector<string> capabilities;
    
    // Security permissions
    vector<Permission> permissions;
};

enum IntegrationType {
    BLUEPRINT_NODE,      // Creates blueprint nodes
    AGENTIC_CAPABILITY,  // Extends AI assistant
    STREAMING_DOCK,      // Service integration
    BROWSER_UI,          // Custom web UI
    ML_MODEL,            // ML inference
    DATA_SOURCE,         // External data feeds
    OUTPUT_SINK,         // Custom outputs
    EFFECT_FILTER        // Visual/audio effects
};
```

### Registration Flow

```
1. Plugin installed to: ~/.local/share/neural-studio/plugins/stripchat/
   ↓
2. Core scans manifest.toml
   ↓
3. For each [integration_points.*] section:
   a. Validate against schema
   b. Check security permissions
   c. Generate taxonomic ID (if blueprint node)
   d. Register in ObjectBox INDEX store
   ↓
4. Plugin appears in UI:
   - Blueprint: New node type in manager
   - Dock: New dock in dock manager
   - Agentic: New AI capabilities
   ↓
5. User interacts → Core routes to WASM container
```

---

## 5. Blueprint System Integration

### Declaring Blueprint Nodes

Plugins can create new node types that appear in the blueprint editor:

```toml
[[integration_points.blueprint_nodes]]
# Node classification (follows taxonomic system)
species = "N"           # Node
ethnicity = "VD"        # VideoNode
archetype = "SC"        # StripChat (custom archetype)
symbiotic_prefix = "NVDSC"  # Auto-generated: N + VD + SC

# Display information
display_name = "StripChat Overlay"
category = "Streaming Services"
icon = "assets/icons/stripchat.svg"
color = "#FF6B6B"

# Widget composition
widgets = [
    "StripChatChatWidget",
    "StripChatTipWidget",
    "StripChatViewerStatsWidget"
]

# Pin definitions (inputs/outputs)
[[integration_points.blueprint_nodes.pins]]
id = "video_in"
name = "Video Input"
direction = "input"
data_type = "Texture2D"
port_side = "left"      # Visual input

[[integration_points.blueprint_nodes.pins]]
id = "video_out"
name = "Video Output"
direction = "output"
data_type = "Texture2D"
port_side = "right"     # Visual output

[[integration_points.blueprint_nodes.pins]]
id = "chat_data"
name = "Chat Messages"
direction = "output"
data_type = "String"
port_side = "bottom"    # Data output

# Node behavior
[integration_points.blueprint_nodes.behavior]
can_be_source = false   # Requires input
ethnicity_rank = 6      # Transform node
requires_network = true
requires_auth = true
```

### WASM Execution Interface

When node processes a frame, core calls WASM function:

```rust
// Plugin implements this trait (Rust example)
#[no_mangle]
pub extern "C" fn process_frame(
    input_ptr: *const u8,
    input_len: usize,
    settings_ptr: *const u8,
    settings_len: usize,
    output_ptr: *mut u8,
    output_len: *mut usize
) -> i32 {
    // 1. Deserialize input frame
    let input_frame = unsafe {
        std::slice::from_raw_parts(input_ptr, input_len)
    };
    
    // 2. Deserialize settings (from ObjectBox)
    let settings: StripChatSettings = unsafe {
        flatbuffers::root::<StripChatSettings>(
            std::slice::from_raw_parts(settings_ptr, settings_len)
        ).unwrap()
    };
    
    // 3. Process frame
    let mut output_frame = process_video_frame(
        input_frame,
        &settings
    );
    
    // 4. Overlay chat messages
    if settings.show_chat() {
        overlay_chat_messages(&mut output_frame, &fetch_chat());
    }
    
    // 5. Write output
    unsafe {
        std::ptr::copy_nonoverlapping(
            output_frame.as_ptr(),
            output_ptr,
            output_frame.len()
        );
        *output_len = output_frame.len();
    }
    
    0  // Success
}
```

### C++ Core Integration

```cpp
// Core creates WASM node dynamically
class WasmNode : public BaseNodeBackend {
public:
    WasmNode(const string& id, const WasmPluginManifest& manifest)
        : BaseNodeBackend(id, manifest.display_name)
    {
        // Load WASM module
        m_wasmModule = WasmEdge::loadModule(manifest.wasm_module);
        
        // Create pins from manifest
        for (const auto& pin : manifest.pins) {
            if (pin.direction == "input") {
                addInput(pin.id, pin.name, DataType::fromString(pin.data_type));
            } else {
                addOutput(pin.id, pin.name, DataType::fromString(pin.data_type));
            }
        }
    }
    
    ExecutionResult process(ExecutionContext& ctx) override {
        // 1. Get input data
        auto* inputTexture = getInputData<QRhiTexture>("video_in");
        
        // 2. Serialize texture to bytes
        vector<uint8_t> inputBytes = textureToBytes(inputTexture);
        
        // 3. Load settings from ObjectBox
        auto settings = nodeStore->get(m_id);
        vector<uint8_t> settingsBytes = settings->serialize();
        
        // 4. Prepare output buffer
        vector<uint8_t> outputBytes(inputBytes.size());
        size_t outputLen = 0;
        
        // 5. Call WASM function
        auto result = m_wasmModule->call(
            "process_frame",
            inputBytes.data(), inputBytes.size(),
            settingsBytes.data(), settingsBytes.size(),
            outputBytes.data(), &outputLen
        );
        
        if (result != 0) {
            return ExecutionResult::error("WASM execution failed");
        }
        
        // 6. Convert output bytes back to texture
        QRhiTexture* outputTexture = bytesToTexture(
            outputBytes.data(), outputLen
        );
        
        setOutputData("video_out", outputTexture);
        
        return ExecutionResult::success();
    }
    
private:
    WasmEdge::Module* m_wasmModule;
};
```

### ObjectBox Schema Extension

Plugin provides custom schema for settings:

```flatbuffers
// schemas/StripChatSettings.fbs
namespace StripChat;

table StripChatSettings {
    id: string (key);
    
    // Authentication
    api_key: string;
    username: string;
    
    // Chat overlay settings
    show_chat: bool = true;
    chat_position: ChatPosition = TopRight;
    chat_opacity: float = 0.8;
    
    // Tip notifications
    show_tip_alerts: bool = true;
    min_tip_amount: int = 1;
    tip_sound: string;
    
    // Privacy
    hide_usernames: bool = false;
    block_list: [string];
}

enum ChatPosition: byte {
    TopLeft = 0,
    TopRight = 1,
    BottomLeft = 2,
    BottomRight = 3
}
```

**Core automatically**:
1. Compiles schema to C++
2. Creates ObjectBox store for plugin
3. Generates settings UI from schema
4. Serializes/deserializes for WASM calls

---

## 6. Agentic System Integration

### Declaring AI Capabilities

Plugins extend the AI assistant's knowledge:

```toml
[[integration_points.agentic]]
# Intent recognition
intent_keywords = [
    "stripchat",
    "tip",
    "donation",
    "viewer",
    "chat",
    "stream stats"
]

# AI capabilities this plugin provides
capabilities = [
    "fetch_viewer_count",
    "get_top_tippers",
    "moderate_chat",
    "analyze_sentiment",
    "predict_tip_amount"
]

# Context the AI can access
context_sources = [
    "chat_history",
    "viewer_demographics",
    "stream_metrics"
]

# Function calling interface
[integration_points.agentic.functions]

[[integration_points.agentic.functions.definitions]]
name = "get_viewer_count"
description = "Fetches current viewer count from StripChat"
parameters = {}
returns = { type = "integer" }

[[integration_points.agentic.functions.definitions]]
name = "get_top_tippers"
description = "Returns list of top tippers this stream"
parameters = { limit = { type = "integer", default = 10 } }
returns = { type = "array", items = { type = "object" } }

[[integration_points.agentic.functions.definitions]]
name = "moderate_chat"
description = "Automatically moderates chat messages"
parameters = {
    message = { type = "string" },
    user = { type = "string" },
    context = { type = "object" }
}
returns = {
    type = "object",
    properties = {
        action = { type = "string", enum = ["allow", "block", "timeout"] },
        reason = { type = "string" }
    }
}
```

### AI Assistant Flow

```
User: "How many viewers do I have on StripChat?"
  ↓
AI Agent: Recognizes intent ("stripchat" + "viewers")
  ↓
AI Agent: Checks registered capabilities
  ↓
AI Agent: Finds "get_viewer_count" from StripChat plugin
  ↓
AI Agent: Calls WASM function
  ↓
WASM Plugin: Fetches from StripChat API
  ↓
WASM Plugin: Returns { viewer_count: 1247 }
  ↓
AI Agent: "You currently have 1,247 viewers on StripChat"
```

### WASM Function Calling Interface

```rust
// Plugin implements function calling
#[no_mangle]
pub extern "C" fn call_function(
    function_name_ptr: *const u8,
    function_name_len: usize,
    params_json_ptr: *const u8,
    params_json_len: usize,
    result_ptr: *mut u8,
    result_len: *mut usize
) -> i32 {
    // 1. Parse function name
    let function_name = unsafe {
        std::str::from_utf8_unchecked(
            std::slice::from_raw_parts(function_name_ptr, function_name_len)
        )
    };
    
    // 2. Parse parameters
    let params_json = unsafe {
        std::str::from_utf8_unchecked(
            std::slice::from_raw_parts(params_json_ptr, params_json_len)
        )
    };
    let params: serde_json::Value = serde_json::from_str(params_json).unwrap();
    
    // 3. Route to function
    let result = match function_name {
        "get_viewer_count" => get_viewer_count(),
        "get_top_tippers" => get_top_tippers(
            params["limit"].as_i64().unwrap_or(10) as usize
        ),
        "moderate_chat" => moderate_chat(
            params["message"].as_str().unwrap(),
            params["user"].as_str().unwrap()
        ),
        _ => return -1  // Unknown function
    };
    
    // 4. Serialize result
    let result_json = serde_json::to_string(&result).unwrap();
    let result_bytes = result_json.as_bytes();
    
    // 5. Write output
    unsafe {
        std::ptr::copy_nonoverlapping(
            result_bytes.as_ptr(),
            result_ptr,
            result_bytes.len()
        );
        *result_len = result_bytes.len();
    }
    
    0  // Success
}

fn get_viewer_count() -> serde_json::Value {
    // Call StripChat API
    let response = http_get("https://api.stripchat.com/viewer-count");
    json!({ "viewer_count": response["count"] })
}
```

### C++ Agentic Integration

```cpp
// Core AI system routes function calls to plugins
class AgenticCoordinator {
public:
    void registerPlugin(const WasmPluginManifest& manifest) {
        for (const auto& func : manifest.agentic.functions) {
            m_functionRegistry[func.name] = {
                .plugin_id = manifest.id,
                .description = func.description,
                .parameters = func.parameters
            };
        }
    }
    
    json callFunction(const string& functionName, const json& params) {
        // 1. Find plugin that implements function
        auto it = m_functionRegistry.find(functionName);
        if (it == m_functionRegistry.end()) {
            throw FunctionNotFoundException(functionName);
        }
        
        // 2. Get plugin WASM module
        auto plugin = m_pluginManager->getPlugin(it->second.plugin_id);
        
        // 3. Serialize parameters
        string paramsJson = params.dump();
        
        // 4. Prepare result buffer
        vector<uint8_t> resultBuffer(4096);
        size_t resultLen = 0;
        
        // 5. Call WASM function
        int status = plugin->wasmModule->call(
            "call_function",
            functionName.c_str(), functionName.size(),
            paramsJson.c_str(), paramsJson.size(),
            resultBuffer.data(), &resultLen
        );
        
        if (status != 0) {
            throw WasmExecutionException("Function call failed");
        }
        
        // 6. Parse result
        string resultJson(
            reinterpret_cast<char*>(resultBuffer.data()),
            resultLen
        );
        return json::parse(resultJson);
    }
};

// AI Agent uses this
void handleUserQuery(const string& query) {
    // 1. Gemini analyzes intent
    auto intent = geminiSDK->analyzeIntent(query);
    
    // 2. Gemini decides to call function
    if (intent.requires_function_call) {
        auto result = agenticCoordinator->callFunction(
            intent.function_name,
            intent.parameters
        );
        
        // 3. Gemini formats response
        string response = geminiSDK->formatResponse(query, result);
        
        // 4. Present to user
        chatUI->addMessage(response);
    }
}
```

---

## 7. Streaming Service Dock Integration

### Declaring Streaming Docks

Plugins create docks for streaming service integrations:

```toml
[[integration_points.streaming_docks]]
# Dock configuration
dock_id = "stripchat_chat"
dock_title = "StripChat Chat"
dock_icon = "assets/icons/stripchat_chat.svg"
default_location = "right"
default_size = { width = 400, height = 600 }
resizable = true
closable = true

# Browser configuration
[integration_points.streaming_docks.browser]
url = "https://stripchat.com/chat/{username}"
user_agent = "Mozilla/5.0 (Neural Studio Chat)"
enable_javascript = true
enable_cookies = true
enable_local_storage = true

# Auth flow
[integration_points.streaming_docks.auth]
method = "oauth2"
auth_url = "https://stripchat.com/oauth/authorize"
token_url = "https://stripchat.com/oauth/token"
scopes = ["chat.read", "chat.write", "viewer.stats"]
redirect_uri = "neuralstudio://auth/stripchat"

# Message bridge (chat → blueprint)
[integration_points.streaming_docks.message_bridge]
enable = true
message_types = ["chat", "tip", "follow", "subscribe"]

[[integration_points.streaming_docks.message_bridge.mappings]]
from = "browser_message"
to = "blueprint_data"
transform = "wasm_function:parse_chat_message"
```

### Browser-WASM Bridge

```javascript
// Browser code (injected by Neural Studio)
window.NeuralStudio = {
    sendToBlueprint: function(messageType, data) {
        // Send to WASM plugin
        window.chrome.webview.postMessage({
            type: 'blueprint_message',
            plugin: 'stripchat',
            messageType: messageType,
            data: data
        });
    }
};

// StripChat chat listener
const observer = new MutationObserver((mutations) => {
    for (const mutation of mutations) {
        if (mutation.addedNodes.length > 0) {
            const chatMessage = parseChatMessage(mutation.addedNodes[0]);
            
            // Send to Neural Studio
            window.NeuralStudio.sendToBlueprint('chat_message', {
                user: chatMessage.user,
                message: chatMessage.text,
                timestamp: Date.now(),
                type: 'chat'
            });
        }
    }
});

observer.observe(
    document.querySelector('.chat-messages'),
    { childList: true }
);
```

```rust
// WASM plugin receives browser messages
#[no_mangle]
pub extern "C" fn on_browser_message(
    message_type_ptr: *const u8,
    message_type_len: usize,
    data_json_ptr: *const u8,
    data_json_len: usize
) -> i32 {
    // 1. Parse message type
    let message_type = unsafe {
        std::str::from_utf8_unchecked(
            std::slice::from_raw_parts(message_type_ptr, message_type_len)
        )
    };
    
    // 2. Parse data
    let data_json = unsafe {
        std::str::from_utf8_unchecked(
            std::slice::from_raw_parts(data_json_ptr, data_json_len)
        )
    };
    let data: ChatMessage = serde_json::from_str(data_json).unwrap();
    
    // 3. Route based on type
    match message_type {
        "chat_message" => handle_chat_message(data),
        "tip" => handle_tip(data),
        "follow" => handle_follow(data),
        _ => {}
    }
    
    0
}

fn handle_tip(data: ChatMessage) {
    // 1. Parse tip amount
    let tip_amount = data.metadata["amount"].as_f64().unwrap();
    
    // 2. Trigger visual effect in blueprint
    send_to_blueprint(json!({
        "type": "trigger_effect",
        "effect": "tip_explosion",
        "params": {
            "amount": tip_amount,
            "user": data.user
        }
    }));
    
    // 3. Log to AI system
    send_to_agentic(json!({
        "event": "tip_received",
        "user": data.user,
        "amount": tip_amount,
        "context": "live_stream"
    }));
}
```

### C++ Dock Manager Integration

```cpp
// Core creates dock from manifest
class StreamingDockManager {
public:
    void registerPluginDock(const WasmPluginManifest& manifest) {
        for (const auto& dockConfig : manifest.streaming_docks) {
            // 1. Create browser widget
            auto browser = new QWebEngineView();
            
            // 2. Configure browser
            browser->setUrl(QUrl(dockConfig.browser.url));
            browser->settings()->setAttribute(
                QWebEngineSettings::JavascriptEnabled,
                dockConfig.browser.enable_javascript
            );
            
            // 3. Inject bridge script
            browser->page()->runJavaScript(R"(
                window.NeuralStudio = {
                    sendToBluepprint: function(type, data) {
                        // C++ receives via QWebChannel
                        window.qt.neuralStudio.onMessage(type, JSON.stringify(data));
                    }
                };
            )");
            
            // 4. Connect bridge to WASM
            auto channel = new QWebChannel(browser->page());
            auto bridge = new BrowserWasmBridge(manifest.id);
            
            connect(bridge, &BrowserWasmBridge::messageReceived,
                    this, &StreamingDockManager::routeToWasm);
            
            channel->registerObject("neuralStudio", bridge);
            browser->page()->setWebChannel(channel);
            
            // 5. Create dock widget
            auto dock = new QDockWidget(
                QString::fromStdString(dockConfig.dock_title)
            );
            dock->setWidget(browser);
            
            // 6. Add to main window
            m_mainWindow->addDockWidget(
                parseDockLocation(dockConfig.default_location),
                dock
            );
        }
    }
    
private:
    void routeToWasm(const QString& pluginId, const QString& type, const QJsonObject& data) {
        // 1. Get plugin
        auto plugin = m_pluginManager->getPlugin(pluginId.toStdString());
        
        // 2. Serialize data
        string typeStr = type.toStdString();
        string dataJson = QJsonDocument(data).toJson().toStdString();
        
        // 3. Call WASM handler
        plugin->wasmModule->call(
            "on_browser_message",
            typeStr.c_str(), typeStr.size(),
            dataJson.c_str(), dataJson.size()
        );
    }
};
```

---

## 8. Browser/UI Integration

### Custom Web UI

Plugins can provide custom web interfaces embedded in Neural Studio:

```toml
[[integration_points.browser_ui]]
# UI configuration
ui_id = "stripchat_dashboard"
title = "StripChat Dashboard"
icon = "assets/icons/dashboard.svg"
location = "dock"  # or "tab", "modal", "popup"

# HTML/CSS/JS bundle
[integration_points.browser_ui.bundle]
html = "assets/html/dashboard.html"
css = "assets/css/dashboard.css"
javascript = "assets/js/dashboard.js"

# API endpoints exposed to UI
[[integration_points.browser_ui.api_endpoints]]
path = "/api/stats"
method = "GET"
wasm_handler = "get_dashboard_stats"

[[integration_points.browser_ui.api_endpoints]]
path = "/api/settings"
method = "POST"
wasm_handler = "update_settings"

# WebSocket for real-time updates
[integration_points.browser_ui.websocket]
enable = true
wasm_handler = "websocket_message"
```

### Example Dashboard HTML

```html
<!-- assets/html/dashboard.html -->
<!DOCTYPE html>
<html>
<head>
    <title>StripChat Dashboard</title>
    <link rel="stylesheet" href="dashboard.css">
</head>
<body>
    <div class="dashboard">
        <div class="stat-card">
            <h3>Current Viewers</h3>
            <div id="viewer-count" class="stat-value">---</div>
        </div>
        
        <div class="stat-card">
            <h3>Tips Today</h3>
            <div id="tips-today" class="stat-value">$---</div>
        </div>
        
        <div class="stat-card">
            <h3>New Followers</h3>
            <div id="new-followers" class="stat-value">---</div>
        </div>
        
        <div class="chart-container">
            <canvas id="viewer-chart"></canvas>
        </div>
    </div>
    
    <script src="dashboard.js"></script>
</body>
</html>
```

```javascript
// assets/js/dashboard.js
class StripChatDashboard {
    constructor() {
        // Connect to Neural Studio WebSocket
        this.ws = new WebSocket('ws://localhost:8080/plugin/stripchat');
        this.ws.onmessage = (event) => this.handleUpdate(event);
        
        // Fetch initial stats
        this.fetchStats();
        
        // Update every 5 seconds
        setInterval(() => this.fetchStats(), 5000);
    }
    
    async fetchStats() {
        // Call WASM API endpoint (routed by Neural Studio)
        const response = await fetch('/api/stats');
        const stats = await response.json();
        
        // Update UI
        document.getElementById('viewer-count').textContent = stats.viewers;
        document.getElementById('tips-today').textContent = `$${stats.tips_today}`;
        document.getElementById('new-followers').textContent = stats.new_followers;
        
        // Update chart
        this.updateChart(stats.viewer_history);
    }
    
    handleUpdate(event) {
        const update = JSON.parse(event.data);
        
        switch (update.type) {
            case 'new_tip':
                this.showTipNotification(update.data);
                break;
            case 'new_follower':
                this.showFollowerNotification(update.data);
                break;
        }
    }
}

new StripChatDashboard();
```

### WASM HTTP Handler

```rust
// Plugin handles HTTP requests from custom UI
#[no_mangle]
pub extern "C" fn handle_http_request(
    method_ptr: *const u8,
    method_len: usize,
    path_ptr: *const u8,
    path_len: usize,
    body_ptr: *const u8,
    body_len: usize,
    response_ptr: *mut u8,
    response_len: *mut usize
) -> i32 {
    // 1. Parse request
    let method = unsafe {
        std::str::from_utf8_unchecked(
            std::slice::from_raw_parts(method_ptr, method_len)
        )
    };
    let path = unsafe {
        std::str::from_utf8_unchecked(
            std::slice::from_raw_parts(path_ptr, path_len)
        )
    };
    
    // 2. Route to handler
    let response_json = match (method, path) {
        ("GET", "/api/stats") => get_dashboard_stats(),
        ("POST", "/api/settings") => {
            let body = unsafe {
                std::slice::from_raw_parts(body_ptr, body_len)
            };
            update_settings(body)
        },
        _ => json!({ "error": "Not found" })
    };
    
    // 3. Serialize response
    let response_bytes = response_json.to_string().into_bytes();
    
    // 4. Write output
    unsafe {
        std::ptr::copy_nonoverlapping(
            response_bytes.as_ptr(),
            response_ptr,
            response_bytes.len()
        );
        *response_len = response_bytes.len();
    }
    
    0
}

fn get_dashboard_stats() -> serde_json::Value {
    // Fetch from StripChat API
    let stats = fetch_stats_from_api();
    
    json!({
        "viewers": stats.current_viewers,
        "tips_today": stats.tips_today,
        "new_followers": stats.new_followers_today,
        "viewer_history": stats.viewer_history_24h
    })
}
```

---

## 9. ML Model Integration

### ONNX Model Integration

```toml
[[integration_points.ml_models]]
# Model information
model_id = "background_remover"
model_name = "Background Removal"
model_path = "models/background_removal.onnx"
runtime = "onnx"

# Model specifications
[integration_points.ml_models.input]
shape = [1, 3, 720, 1280]  # NCHW format
data_type = "float32"
preprocessing = "normalize_imagenet"

[integration_points.ml_models.output]
shape = [1, 1, 720, 1280]  # Alpha mask
data_type = "float32"
postprocessing = "threshold_0.5"

# Execution configuration
[integration_points.ml_models.execution]
device = "gpu"  # or "cpu", "npu"
precision = "fp16"  # or "fp32", "int8"
batch_size = 1
```

### Gemini SDK Integration

```toml
[[integration_points.gemini]]
# Gemini configuration
agent_id = "content_analyzer"
agent_name = "Content Analyzer"
model = "gemini-2.0-flash-exp"

# Capabilities
capabilities = [
    "vision",           # Analyze video frames
    "code",             # Generate effects code
    "function_calling"  # Interact with blueprint
]

# System instruction
system_instruction = """
You are a content analysis assistant for Neural Studio.
Analyze video frames and provide:
1. Scene description
2. Detected objects
3. Suggested effects
4. Composition recommendations
"""

# Functions this agent can call
[[integration_points.gemini.functions]]
name = "apply_effect"
description = "Apply visual effect to video"
parameters = {
    effect_name = { type = "string" },
    intensity = { type = "number", min = 0, max = 1 }
}
```

### Unified ML Interface

Core provides unified interface for all ML runtimes:

```cpp
// Core ML coordinator
class MLCoordinator {
public:
    // Load model from plugin
    void registerModel(const WasmPluginManifest& manifest) {
        for (const auto& model : manifest.ml_models) {
            if (model.runtime == "onnx") {
                registerONNXModel(model);
            } else if (model.runtime == "gemini") {
                registerGeminiAgent(model);
            }
        }
    }
    
    // Run inference (runtime-agnostic)
    Tensor run(const string& modelId, const Tensor& input) {
        auto model = m_models[modelId];
        
        switch (model->runtime) {
            case Runtime::ONNX:
                return runONNX(model, input);
            case Runtime::Gemini:
                return runGemini(model, input);
            case Runtime::WasmEdge:
                return runWasmEdge(model, input);
        }
    }
    
private:
    Tensor runONNX(const MLModel* model, const Tensor& input) {
        // 1. Create ONNX session
        auto session = Ort::Session(
            m_env,
            model->model_path.c_str(),
            m_sessionOptions
        );
        
        // 2. Run inference
        auto output = session.Run(
            Ort::RunOptions{nullptr},
            model->input_names.data(),
            &input.ortValue,
            1,
            model->output_names.data(),
            1
        );
        
        return Tensor(output[0]);
    }
    
    Tensor runGemini(const MLModel* model, const Tensor& input) {
        // 1. Convert tensor to image
        auto image = tensorToImage(input);
        
        // 2. Call Gemini API
        auto response = m_geminiClient->generateContent({
            .model = model->model_name,
            .contents = {
                Content::fromImage(image),
                Content::fromText("Analyze this frame")
            }
        });
        
        // 3. Parse response
        return parseTensorFromResponse(response);
    }
};
```

---

## 10. SDK Protocol Specification

### Plugin Manifest Schema (Full Specification)

```toml
# ============================================================================
# NEURAL STUDIO PLUGIN MANIFEST
# Version: 1.0.0
# ============================================================================

[manifest]
# Required fields
name = "Plugin Name"
version = "1.0.0"
author = "Developer/Company"
description = "Brief description of plugin functionality"
license = "MIT"  # or "Proprietary", "GPL-3.0", etc.

# Plugin identifiers
id = "com.company.plugin_name"  # Unique identifier (reverse DNS)
wasm_module = "plugin.wasm"     # Path to WASM binary

# Runtime configuration
[runtime]
type = "wasmedge"               # "wasmedge", "onnx", "gemini"
version = "0.13.0"              # Runtime version requirement
features = ["wasi", "wasi-nn"]  # Required WASM features

# Secondary runtimes (optional)
[[runtime.secondary]]
type = "onnx"
models = ["models/model1.onnx", "models/model2.onnx"]

[[runtime.secondary]]
type = "gemini"
api_key_env = "GEMINI_API_KEY"

# ============================================================================
# INTEGRATION POINTS
# ============================================================================

[integration_points]
# Enable integration categories
blueprint = true
agentic = true
streaming_docks = true
browser_ui = true
ml_pipeline = true

# ============================================================================
# BLUEPRINT NODES
# ============================================================================

[[integration_points.blueprint_nodes]]
# Taxonomic classification
species = "N"
ethnicity = "VD"  # Must be registered or custom
archetype = "XX"  # 2-char archetype code
symbiotic_prefix = "NVDXX"  # Auto-generated

# Display
display_name = "Node Display Name"
category = "Category/Subcategory"
icon = "assets/icons/node.svg"
color = "#FF6B6B"

# Widget composition
widgets = [
    "WidgetName1",
    "WidgetName2"
]

# Pins
[[integration_points.blueprint_nodes.pins]]
id = "input1"
name = "Input 1"
direction = "input"  # "input" or "output"
data_type = "Texture2D"  # Must match core types
port_side = "left"  # "left", "right", "top", "bottom"
required = true

# Behavior
[integration_points.blueprint_nodes.behavior]
can_be_source = false
ethnicity_rank = 6
requires_network = false
requires_auth = false
requires_gpu = false

# ============================================================================
# AGENTIC SYSTEM
# ============================================================================

[[integration_points.agentic]]
# Intent recognition
intent_keywords = ["keyword1", "keyword2"]

# Capabilities
capabilities = [
    "capability1",
    "capability2"
]

# Context sources
context_sources = [
    "data_source1",
    "data_source2"
]

# Functions
[[integration_points.agentic.functions.definitions]]
name = "function_name"
description = "Function description for AI"
parameters = {
    param1 = { type = "string", required = true },
    param2 = { type = "integer", default = 10 }
}
returns = { type = "object" }

# ============================================================================
# STREAMING DOCKS
# ============================================================================

[[integration_points.streaming_docks]]
dock_id = "unique_dock_id"
dock_title = "Dock Title"
dock_icon = "assets/icons/dock.svg"
default_location = "right"  # "left", "right", "top", "bottom"
default_size = { width = 400, height = 600 }

# Browser configuration
[integration_points.streaming_docks.browser]
url = "https://service.com/chat"
user_agent = "Neural Studio Chat"
enable_javascript = true
enable_cookies = true

# Authentication
[integration_points.streaming_docks.auth]
method = "oauth2"  # "oauth2", "api_key", "basic"
auth_url = "https://service.com/oauth/authorize"
token_url = "https://service.com/oauth/token"
scopes = ["scope1", "scope2"]

# Message bridge
[integration_points.streaming_docks.message_bridge]
enable = true
message_types = ["chat", "tip", "follow"]

# ============================================================================
# BROWSER UI
# ============================================================================

[[integration_points.browser_ui]]
ui_id = "unique_ui_id"
title = "UI Title"
location = "dock"  # "dock", "tab", "modal"

# HTML bundle
[integration_points.browser_ui.bundle]
html = "assets/html/ui.html"
css = "assets/css/ui.css"
javascript = "assets/js/ui.js"

# API endpoints
[[integration_points.browser_ui.api_endpoints]]
path = "/api/endpoint"
method = "GET"
wasm_handler = "handler_function"

# ============================================================================
# ML MODELS
# ============================================================================

[[integration_points.ml_models]]
model_id = "unique_model_id"
model_name = "Model Display Name"
model_path = "models/model.onnx"
runtime = "onnx"

[integration_points.ml_models.input]
shape = [1, 3, 720, 1280]
data_type = "float32"
preprocessing = "normalize_imagenet"

[integration_points.ml_models.output]
shape = [1, 1, 720, 1280]
data_type = "float32"
postprocessing = "threshold_0.5"

# ============================================================================
# PERMISSIONS
# ============================================================================

[permissions]
network = true              # Access to network
filesystem = true           # Access to filesystem
gpu = false                # GPU acceleration
microphone = false         # Microphone access
camera = false             # Camera access
screen_capture = false     # Screen capture
clipboard = false          # Clipboard access
```

### WASM Function ABI

All plugins must implement these core functions:

```rust
// ============================================================================
// MANDATORY FUNCTIONS
// ============================================================================

/// Initialize plugin
#[no_mangle]
pub extern "C" fn plugin_init(
    config_ptr: *const u8,
    config_len: usize
) -> i32;

/// Cleanup plugin
#[no_mangle]
pub extern "C" fn plugin_cleanup() -> i32;

/// Get plugin manifest (JSON)
#[no_mangle]
pub extern "C" fn plugin_get_manifest(
    manifest_ptr: *mut u8,
    manifest_len: *mut usize
) -> i32;

// ============================================================================
// BLUEPRINT NODE FUNCTIONS (if integration_points.blueprint = true)
// ============================================================================

/// Process frame/data
#[no_mangle]
pub extern "C" fn process_frame(
    input_ptr: *const u8,
    input_len: usize,
    settings_ptr: *const u8,
    settings_len: usize,
    output_ptr: *mut u8,
    output_len: *mut usize
) -> i32;

// ============================================================================
// AGENTIC FUNCTIONS (if integration_points.agentic = true)
// ============================================================================

/// Handle function call from AI
#[no_mangle]
pub extern "C" fn call_function(
    function_name_ptr: *const u8,
    function_name_len: usize,
    params_json_ptr: *const u8,
    params_json_len: usize,
    result_ptr: *mut u8,
    result_len: *mut usize
) -> i32;

// ============================================================================
// BROWSER DOCK FUNCTIONS (if integration_points.streaming_docks = true)
// ============================================================================

/// Handle message from browser
#[no_mangle]
pub extern "C" fn on_browser_message(
    message_type_ptr: *const u8,
    message_type_len: usize,
    data_json_ptr: *const u8,
    data_json_len: usize
) -> i32;

// ============================================================================
// BROWSER UI FUNCTIONS (if integration_points.browser_ui = true)
// ============================================================================

/// Handle HTTP request from custom UI
#[no_mangle]
pub extern "C" fn handle_http_request(
    method_ptr: *const u8,
    method_len: usize,
    path_ptr: *const u8,
    path_len: usize,
    body_ptr: *const u8,
    body_len: usize,
    response_ptr: *mut u8,
    response_len: *mut usize
) -> i32;

/// Handle WebSocket message
#[no_mangle]
pub extern "C" fn handle_websocket_message(
    message_ptr: *const u8,
    message_len: usize
) -> i32;
```

---

## 11. Example Implementations

### Example 1: StripChat Integration Plugin

**Directory Structure**:
```
stripchat_plugin/
├── manifest.toml
├── Cargo.toml
├── src/
│   ├── lib.rs
│   ├── blueprint.rs
│   ├── agentic.rs
│   ├── dock.rs
│   └── api.rs
├── models/
│   └── tip_predictor.onnx
├── assets/
│   ├── icons/
│   ├── html/
│   ├── css/
│   └── js/
└── schemas/
    ├── StripChatSettings.fbs
    └── StripChatPipeline.fbs
```

**manifest.toml** (abbreviated):
```toml
[manifest]
name = "StripChat Integration"
version = "1.0.0"
id = "com.stripchat.neural_studio"
wasm_module = "target/wasm32-wasi/release/stripchat_plugin.wasm"

[runtime]
type = "wasmedge"
version = "0.13.0"
features = ["wasi", "wasi-nn", "wasi-http"]

[[runtime.secondary]]
type = "onnx"
models = ["models/tip_predictor.onnx"]

[integration_points]
blueprint = true
agentic = true
streaming_docks = true
browser_ui = true

[[integration_points.blueprint_nodes]]
species = "N"
ethnicity = "VD"
archetype = "SC"
display_name = "StripChat Overlay"
widgets = ["StripChatChatWidget", "StripChatTipWidget"]

[[integration_points.streaming_docks]]
dock_id = "stripchat_chat"
dock_title = "StripChat Chat"
[integration_points.streaming_docks.browser]
url = "https://stripchat.com/chat"
```

**src/lib.rs**:
```rust
use serde::{Deserialize, Serialize};
use serde_json::json;

#[derive(Deserialize)]
struct Config {
    api_key: String,
    username: String,
}

static mut CONFIG: Option<Config> = None;

#[no_mangle]
pub extern "C" fn plugin_init(
    config_ptr: *const u8,
    config_len: usize
) -> i32 {
    let config_json = unsafe {
        std::str::from_utf8_unchecked(
            std::slice::from_raw_parts(config_ptr, config_len)
        )
    };
    
    match serde_json::from_str::<Config>(config_json) {
        Ok(config) => {
            unsafe { CONFIG = Some(config); }
            0
        },
        Err(_) => -1
    }
}

#[no_mangle]
pub extern "C" fn process_frame(
    input_ptr: *const u8,
    input_len: usize,
    settings_ptr: *const u8,
    settings_len: usize,
    output_ptr: *mut u8,
    output_len: *mut usize
) -> i32 {
    // Import from blueprint.rs
    blueprint::process_frame(
        input_ptr, input_len,
        settings_ptr, settings_len,
        output_ptr, output_len
    )
}

#[no_mangle]
pub extern "C" fn call_function(
    function_name_ptr: *const u8,
    function_name_len: usize,
    params_json_ptr: *const u8,
    params_json_len: usize,
    result_ptr: *mut u8,
    result_len: *mut usize
) -> i32 {
    // Import from agentic.rs
    agentic::call_function(
        function_name_ptr, function_name_len,
        params_json_ptr, params_json_len,
        result_ptr, result_len
    )
}

// ... more function exports
```

### Example 2: Unreal MetaHuman Integration

```toml
[manifest]
name = "Unreal MetaHuman Integration"
version = "1.0.0"
id = "com.epicgames.metahuman"
wasm_module = "metahuman_plugin.wasm"

[[integration_points.blueprint_nodes]]
species = "N"
ethnicity = "3D"  # Custom 3D node ethnicity
archetype = "MH"
display_name = "MetaHuman Avatar"

[[integration_points.agentic.functions.definitions]]
name = "animate_metahuman"
description = "Animate MetaHuman with facial expression"
parameters = {
    expression = { type = "string", enum = ["happy", "sad", "surprised"] },
    intensity = { type = "number", min = 0, max = 1 }
}
```

---

## 12. Security & Sandboxing

### WASM Sandboxing

All WASM plugins run in isolated sandboxes:

```cpp
// Core security policy
class PluginSecurityPolicy {
public:
    void enforcePolicy(const WasmPlugin* plugin) {
        // 1. Limit memory
        plugin->setMaxMemory(512 * 1024 * 1024);  // 512MB
        
        // 2. Limit execution time
        plugin->setMaxExecutionTime(100);  // 100ms per frame
        
        // 3. Network restrictions
        if (!plugin->hasPermission(Permission::Network)) {
            plugin->blockNetworkAccess();
        }
        
        // 4. Filesystem restrictions
        if (plugin->hasPermission(Permission::Filesystem)) {
            // Only allow access to plugin directory
            plugin->setFilesystemRoot(plugin->getPluginDirectory());
        } else {
            plugin->blockFilesystemAccess();
        }
        
        // 5. IPC restrictions
        plugin->allowIPCOnly({
            "blueprint_message",
            "agentic_call",
            "dock_message"
        });
    }
};
```

### Permission System

```toml
[permissions]
# Required permissions (user must approve)
network = true
filesystem = true
gpu = false
microphone = false
camera = false

# Permission explanations (shown to user)
[permissions.explanations]
network = "Access StripChat API for chat and viewer stats"
filesystem = "Save chat logs and tip history"
```

### User Approval Flow

```
1. User installs plugin
   ↓
2. Core reads manifest permissions
   ↓
3. Show permission dialog:
   "StripChat Integration requests:
    ✓ Network access (for API calls)
    ✓ Filesystem access (for logs)
    
    Grant permissions?"
   ↓
4. User approves → Plugin enabled
   User denies → Plugin disabled
```

---

## Appendix A: SDK Tooling

### Plugin Development Kit

```bash
# Install Neural Studio SDK
npm install -g @neural-studio/sdk

# Create new plugin
neural-studio-sdk init --name "My Plugin" --type streaming_dock

# Build plugin
neural-studio-sdk build

# Test plugin locally
neural-studio-sdk test

# Package for distribution
neural-studio-sdk package
```

### Template Repository

```bash
# Clone template
git clone https://github.com/neural-studio/plugin-template

# Select template type
cd plugin-template
./setup.sh

# Choose:
# 1. Blueprint Node Plugin
# 2. Streaming Dock Plugin
# 3. ML Model Plugin
# 4. Full Integration Plugin
```

---

## Appendix B: Migration Path from OBS

For developers familiar with OBS plugins:

| OBS Concept | Neural Studio Equivalent |
|-------------|-------------------------|
| Native plugin (.dll/.so) | WASM plugin (.wasm) |
| `obs_register_source()` | `[[integration_points.blueprint_nodes]]` |
| `obs_source_info` struct | Manifest TOML |
| `get_properties()` | ObjectBox schema |
| `video_render()` | `process_frame()` WASM function |
| Direct Qt widgets | Browser UI with IPC |

---

**End of Document**

**Maintainer**: Neural Studio SDK Team  
**Last Updated**: 2025-12-17  
**Version**: 1.0.0 (Initial SDK Specification)
