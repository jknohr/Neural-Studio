# Neural Studio: Taxonomic ID System Architecture
## Three-Layer Biological Classification for Atomic Component Composition

**Version**: 3.0.0  
**Date**: 2025-12-17  
**Status**: Core System Architecture (DO NOT MODIFY WITHOUT APPROVAL)

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Three-Layer Taxonomic Structure](#2-three-layer-taxonomic-structure)
3. [ID Format Specification](#3-id-format-specification)
4. [Biological Classification System](#4-biological-classification-system)
5. [Atomic Component Architecture](#5-atomic-component-architecture)
6. [ObjectBox Integration](#6-objectbox-integration)
7. [Dynamic Plugin System](#7-dynamic-plugin-system)
8. [Complete Taxonomy Tables](#8-complete-taxonomy-tables)
9. [Implementation Examples](#9-implementation-examples)

---

## 1. Executive Summary

### The Problem

Traditional node systems hardcode node types, making it impossible to:
- Add new node types without recompilation
- Create custom variants dynamically
- Support third-party plugins seamlessly
- Scale to hundreds of component combinations

### The Solution: Biological Classification

Neural Studio uses a **three-layer taxonomic ID system** inspired by biological classification (Kingdom → Phylum → Species):

```
Layer 1: Species (1 char)   - What kind of entity? (Node, Pipeline, Settings)
         ↓
Layer 2: Ethnicity (2 chars) - What category? (Audio, Video, Camera)
         ↓
Layer 3: Archetype (2 chars) - What variant? (AudioClip, AudioStream)
         ↓
UUID: Unique instance identifier (36 chars)

Result: NANAC-550e8400-e29b-41d4-a716-446655440000
```

### Key Innovations

1. **Self-Describing IDs**: Parse type information without database queries
2. **Atomic Composition**: ~80 atomic components + ~280 widgets = unlimited nodes
3. **Database-Driven UI**: Widgets configured via ObjectBox entries
4. **Hot-Swappable Plugins**: Add nodes without recompilation
5. **Qt 6.10.1 Integration**: Native property binding with C++ performance

---

## 2. Three-Layer Taxonomic Structure

### Layer 1: Species (Kingdom)

**What kind of entity is this?**

```
┌─────────────────────────────────────────────────────────────┐
│  SPECIES LAYER (1 CHARACTER)                                │
│  Defines the fundamental nature of the entity               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  N  = Node (Processing entities in blueprint)              │
│  P  = Pipeline (Execution orchestration)                   │
│  S  = Settings (Configuration data)                        │
│  E  = Edge (Graph connections)                             │
│  C  = Controller (UI controllers)                          │
│  M  = Media (Media files)                                  │
│  U  = UI (User interface components)                       │
│  ... (32 total species codes)                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Example**:
- `N` = Node species → This ID represents a processing node
- `P` = Pipeline species → This ID represents pipeline orchestration
- `S` = Settings species → This ID represents configuration data

### Layer 2: Ethnicity (Phylum/Class)

**What category within the species?**

```
┌─────────────────────────────────────────────────────────────┐
│  ETHNICITY LAYER (2 CHARACTERS)                             │
│  Defines the mutualistic/tribal grouping                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Species N (Node) has multiple ethnicities:                │
│                                                             │
│  AN = AudioNode (Auditory stimuli processing)              │
│  VD = VideoNode (Visual data processing)                   │
│  CA = CameraNode (Camera input processing)                 │
│  EF = EffectsNode (Visual effects processing)              │
│  ML = MLNode (Machine learning inference)                  │
│  ... (27 total node ethnicities)                           │
│                                                             │
│  Each ethnicity has:                                       │
│  - Mutualistic Prefix: NAN (Node + Audio + Ethnicity)      │
│  - Tribe: "AuditoryStimuli" (functional grouping)          │
│  - Rank: 4 (source node capability)                        │
│  - Integration Tactics: [T, T, F, F, 4] (behavior flags)   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Example**:
- `NAN` = Node + AudioNode → Audio processing node
- `NVD` = Node + VideoNode → Video processing node
- `NCA` = Node + CameraNode → Camera input node

### Layer 3: Archetype (Species/Variant)

**What specific implementation?**

```
┌─────────────────────────────────────────────────────────────┐
│  ARCHETYPE LAYER (2 CHARACTERS)                             │
│  Defines the specific lineage/variant implementation        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Ethnicity NAN (AudioNode) has multiple archetypes:        │
│                                                             │
│  AC = AudioClip (File playback - immutable dominion)       │
│  AF = AudioClipFX (Effects processing)                     │
│  AM = AudioClipMusic (Music-specific playback)             │
│  AP = AudioClipPodcast (Podcast-specific playback)         │
│  AS = AudioStream (Live streaming - aether bubble)         │
│  SM = AudioStreamMusic (Music streaming)                   │
│  SP = AudioStreamPodcast (Podcast streaming)               │
│  AV = AudioStreamVoiceCall (Voice call streaming)          │
│                                                             │
│  Each archetype has:                                       │
│  - Symbiotic Prefix: NANAC (full classification)           │
│  - Lineage: AudioClip (variant name)                       │
│  - Niche: "ImmutableDominion" (data persistence type)      │
│  - Pedantic Variants: Vector of widget configurations      │
│  - Vector Dolled: Nested configuration arrays              │
│  - Giving Brain: AI model assignment                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Example**:
- `NANAC` = Node + AudioNode + AudioClip → Audio file playback node
- `NANAS` = Node + AudioNode + AudioStream → Audio streaming node
- `NANAV` = Node + AudioNode + AudioStreamVoiceCall → Voice call node

---

## 3. ID Format Specification

### Complete Format

```
[Species:1][Ethnicity:2][Archetype:2]-[UUID:36]

Total: 5 prefix characters + 1 dash + 36 UUID = 42 characters
```

### Parsing Rules

```cpp
struct TaxonomicID {
    char species;          // 1 char  - Index 0
    string ethnicity;      // 2 chars - Index 1-2
    string archetype;      // 2 chars - Index 3-4
    string uuid;           // 36 chars - Index 6-41 (skip dash at 5)
    
    // Derived properties
    string mutualisticPrefix;  // species + ethnicity (e.g., "NAN")
    string symbioticPrefix;    // full classification (e.g., "NANAC")
};

TaxonomicID parseID(const string& id) {
    assert(id.length() == 42);
    assert(id[5] == '-');
    
    return {
        .species = id[0],
        .ethnicity = id.substr(1, 2),
        .archetype = id.substr(3, 2),
        .uuid = id.substr(6, 36),
        .mutualisticPrefix = id.substr(0, 3),
        .symbioticPrefix = id.substr(0, 5)
    };
}
```

### ID Examples with Full Classification

```
NANAC-550e8400-e29b-41d4-a716-446655440000
│││││  └────────────────┬────────────────┘
│││││                   UUID (instance)
││││└─ Archetype: AC = AudioClip
│││└── Ethnicity: AN = AudioNode
││└─── Species: N = Node
│└──── Mutualistic Prefix: NAN
└───── Symbiotic Prefix: NANAC

Classification:
- Kingdom: Node (processing entity)
- Phylum: AudioNode (auditory stimuli)
- Class: AuditoryStimuli tribe
- Order: Source node (rank 4)
- Family: ImmutableDominion niche
- Genus: AudioClip lineage
- Species: File-based audio playback
- Instance: 550e8400-e29b-41d4-a716-446655440000
```

### Reserved UUID: Default Template

```
{PREFIX}-00000000-0000-0000-0000-000000000000
```

**Meaning**: Default configuration template for this classification

**Examples**:
```
NANAC-00000000-0000-0000-0000-000000000000  = Default AudioClip settings
NANAS-00000000-0000-0000-0000-000000000000  = Default AudioStream settings
NVDCP-00000000-0000-0000-0000-000000000000  = Default VideoCapture settings
```

**Usage**:
1. Schema initializes 000... template with hardcoded defaults
2. User creates new instance → clones settings from 000... template
3. User can customize 000... template → all future instances inherit changes
4. "Reset to Defaults" button → restore from 000... template

---

## 4. Biological Classification System

### Complete Taxonomy Table

#### Layer 1: Species (32 Codes)

| Species Code | Species Name | Domain | Description |
|--------------|--------------|--------|-------------|
| `N` | Node | Processing | Scene graph processing nodes |
| `P` | Pipeline | Orchestration | Execution pipeline management |
| `S` | Settings | Data | Configuration data stores |
| `E` | Edge | Connectivity | Graph connection definitions |
| `C` | Controller | UI | Qt controller objects |
| `R` | Rule | Validation | Connection validation rules |
| `M` | Media | Assets | Media file references |
| `A` | MediaAsset | Assets | Specific media assets |
| `O` | Model | Assets | 3D models, ML models |
| `G` | SceneGraphAsset | Assets | Scene graph asset definitions |
| `U` | UI | Interface | UI component definitions |
| `L` | UIElement | Interface | Specific UI elements |
| `W` | Widget | Interface | Widget definitions |
| `F` | Frame | Interface | Frame containers |
| `D` | Dock | Interface | Dock panel definitions |
| `V` | Monitor | Output | Monitor output configurations |
| `T` | Task | Execution | Task/job definitions |
| `Z` | Event | Execution | Event definitions |
| `J` | Session | Execution | Session management |
| `I` | API | Connectivity | API endpoint definitions |
| `Y` | APIBinding | Connectivity | API binding configurations |
| `B` | InteractionBinding | Connectivity | Interaction binding rules |
| `Q` | TransportStream | Connectivity | Transport stream definitions |
| `K` | IPStream | Connectivity | IP stream configurations |
| `H` | Bluetooth | Connectivity | Bluetooth connection configs |
| `X` | Manager | System | Manager instance definitions |
| `0` | Profile | System | User profile configurations |
| `1` | Hardware | System | Hardware device definitions |
| `2` | WASM | Advanced | WebAssembly module configs |
| `3` | Conversation | Advanced | AI conversation states |
| `4` | File | Advanced | File reference metadata |
| `5` | CSP | Advanced | Cloud/security policies |

#### Layer 2: Node Ethnicities (27 Codes)

| Ethnicity Code | Ethnicity Name | Mutualistic Prefix | Tribe | Rank | Integration Tactics |
|----------------|----------------|-------------------|-------|------|-------------------|
| `AN` | AudioNode | `NAN` | AuditoryStimuli | 4 | [true, true, false, false, 4] |
| `VD` | VideoNode | `NVD` | VisualData | 4 | [true, true, false, false, 4] |
| `CA` | CameraNode | `NCA` | CaptureApparatus | 1 | [true, false, false, false, 1] |
| `EF` | EffectsNode | `NEF` | EffectProcessing | 6 | [false, true, true, false, 6] |
| `GR` | GraphicsNode | `NGR` | GraphicalRender | 4 | [true, true, false, false, 4] |
| `SH` | ShaderNode | `NSH` | ShaderProcessing | 6 | [false, true, true, false, 6] |
| `SC` | ScriptNode | `NSC` | ScriptExecution | 5 | [true, true, true, false, 5] |
| `ML` | MLNode | `NML` | MachineLearning | 6 | [false, true, true, true, 6] |
| `AI` | AINode | `NAI` | ArtificialIntel | 6 | [false, true, true, true, 6] |
| `TR` | TransformNode | `NTR` | Transformation | 6 | [false, true, true, false, 6] |
| `FI` | FilterNode | `NFI` | FilterProcessing | 6 | [false, true, true, false, 6] |
| `CO` | CompositeNode | `NCO` | Composition | 6 | [false, true, true, false, 6] |
| `MX` | MixerNode | `NMX` | AudioVideoMix | 6 | [false, true, true, false, 6] |
| `EN` | EncoderNode | `NEN` | Encoding | 60 | [false, true, false, false, 60] |
| `DE` | DecoderNode | `NDE` | Decoding | 4 | [true, false, false, false, 4] |
| `ST` | StreamNode | `NST` | Streaming | 60 | [false, false, false, true, 60] |
| `OU` | OutputNode | `NOU` | OutputSink | 70 | [false, false, false, true, 70] |
| `IN` | InputNode | `NIN` | InputSource | 1 | [true, false, false, false, 1] |
| `DA` | DataNode | `NDA` | DataManagement | 0 | [true, false, false, false, 0] |
| `AP` | APINode | `NAP` | APIInteraction | 2 | [true, false, false, true, 2] |
| `HW` | HardwareNode | `NHW` | HardwareIO | 1 | [true, false, false, false, 1] |
| `GR` | GroupNode | `NGR` | Grouping | 3 | [true, true, true, true, 3] |
| `TG` | TriggerNode | `NTG` | EventTrigger | 9 | [false, false, true, false, 9] |
| `AN` | AnalysisNode | `NAN` | Analysis | 80 | [false, false, true, false, 80] |
| `PP` | PostProcessNode | `NPP` | PostProcessing | 70 | [false, true, true, false, 70] |
| `SU` | SupportNode | `NSU` | Support | 5 | [true, true, true, false, 5] |
| `WT` | WebTransportNode | `NWT` | WebTransport | 60 | [false, false, false, true, 60] |

**Integration Tactics Explained**:
```cpp
struct IntegrationTactics {
    bool canBeSource;         // Can generate data (no required inputs)
    bool canTransform;        // Can modify passing data
    bool requiresInput;       // Must have incoming connections
    bool isTerminal;          // Final output node
    int ethnicityRank;        // Pipeline master priority (0=highest)
};
```

#### Layer 3: AudioNode Archetypes (8 Variants)

| Archetype Code | Archetype Name | Symbiotic Prefix | Lineage | Niche | Pedantic Variants |
|----------------|----------------|-----------------|---------|-------|------------------|
| `AC` | AudioClip | `NANAC` | AudioClip | ImmutableDominion | [QtMultimedia, FFmpeg, VLC] |
| `AF` | AudioClipFX | `NANAF` | AudioClipFX | ImmutableDominion | [Reverb, EQ, Compressor, Limiter] |
| `AM` | AudioClipMusic | `NANAM` | AudioClipMusic | ImmutableDominion | [QtMultimedia, FFmpeg, TagLib] |
| `AP` | AudioClipPodcast | `NANAP` | AudioClipPodcast | ImmutableDominion | [QtMultimedia, FFmpeg, ChapterMarkers] |
| `AS` | AudioStream | `NANAS` | AudioStream | AetherBubble | [RTSP, HTTP, NDI, WebRTC] |
| `SM` | AudioStreamMusic | `NANSM` | AudioStreamMusic | AetherBubble | [Spotify, AppleMusic, Tidal, YouTube] |
| `SP` | AudioStreamPodcast | `NANSP` | AudioStreamPodcast | AetherBubble | [RSS, Spotify, ApplePodcasts] |
| `AV` | AudioStreamVoiceCall | `NANAV` | AudioStreamVoiceCall | AetherBubble | [SIP, WebRTC, Discord, Zoom] |

**Niche Definitions**:
- **ImmutableDominion**: File-based, persistent storage (clips, files)
- **AetherBubble**: Network-based, transient data (streams, APIs)
- **MorphicField**: Transformative processing (effects, filters)
- **QuantumFlux**: Real-time hardware I/O (cameras, microphones)

---

## 5. Atomic Component Architecture

### The 80+280 System

```
┌────────────────────────────────────────────────────────────┐
│  ATOMIC COMPONENTS (~80 Building Blocks)                   │
│  Pure functional units with zero dependencies              │
├────────────────────────────────────────────────────────────┤
│  - AudioBufferProcessor                                    │
│  - VideoFrameDecoder                                       │
│  - NetworkStreamReceiver                                   │
│  - FileIOHandler                                           │
│  - ComputeShaderExecutor                                   │
│  - ... (75 more atomic components)                         │
└────────────────┬───────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────┐
│  WIDGETS (~280 Configurable Components)                    │
│  Composites of atomic components with Qt UI integration    │
├────────────────────────────────────────────────────────────┤
│  AudioClipPlayerWidget:                                    │
│    - Atomic: AudioBufferProcessor                          │
│    - Atomic: FileIOHandler                                 │
│    - Qt UI: QSlider (playback position)                    │
│    - Qt UI: QPushButton (play/pause)                       │
│                                                             │
│  VideoStreamDecoderWidget:                                 │
│    - Atomic: NetworkStreamReceiver                         │
│    - Atomic: VideoFrameDecoder                             │
│    - Qt UI: QLabel (video display)                         │
│    - Qt UI: QComboBox (codec selection)                    │
│                                                             │
│  ... (278 more widgets)                                    │
└────────────────┬───────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────┐
│  NODES (Dynamically Composed from Widgets)                 │
│  Widget composition defined by Symbiotic Prefix in DB      │
├────────────────────────────────────────────────────────────┤
│  AudioClipNode (NANAC):                                    │
│    - AudioClipPlayerWidget (Qt Multimedia variant)         │
│    - AudioClipSettingsWidget                               │
│    - WaveformVisualizerWidget                              │
│    - AudioOutputSelectorWidget                             │
│                                                             │
│  VideoStreamNode (NVDST):                                  │
│    - VideoStreamDecoderWidget (FFmpeg variant)             │
│    - StreamSettingsWidget                                  │
│    - CodecConfigWidget                                     │
│    - BufferMonitorWidget                                   │
│                                                             │
│  → Configuration stored in ObjectBox                       │
│  → Composition rules defined by Pedantic Variants          │
└────────────────────────────────────────────────────────────┘
```

### Widget Composition Example

**ObjectBox Entry for NANAC (AudioClip)**:
```json
{
  "symbioticPrefix": "NANAC",
  "lineage": "AudioClip",
  "niche": "ImmutableDominion",
  "pedanticVariants": [
    {
      "provider": "QtMultimedia",
      "widgets": [
        "AudioClipPlayerWidget_QtMultimedia",
        "AudioClipSettingsWidget",
        "WaveformVisualizerWidget",
        "AudioOutputSelectorWidget"
      ],
      "layout": "vertical",
      "defaultProvider": true
    },
    {
      "provider": "FFmpeg",
      "widgets": [
        "AudioClipPlayerWidget_FFmpeg",
        "AudioClipSettingsWidget",
        "CodecConfigWidget",
        "AudioOutputSelectorWidget"
      ],
      "layout": "vertical",
      "defaultProvider": false
    },
    {
      "provider": "VLC",
      "widgets": [
        "AudioClipPlayerWidget_VLC",
        "AudioClipSettingsWidget",
        "AudioOutputSelectorWidget"
      ],
      "layout": "vertical",
      "defaultProvider": false
    }
  ],
  "vectorDolled": [
    ["QtMultimedia", "FFmpeg", "VLC"],
    ["Playback", "Settings", "Visualizer"],
    ["Core", "Extended", "Minimal"]
  ],
  "givingBrain": "AudioProcessingAI_v1"
}
```

### Dynamic Node Creation

```cpp
// 1. User drags AudioNode from AudioManager
// 2. System looks up NANAC in ObjectBox INDEX store
auto config = indexStore->getArchetypeConfig("NANAC");

// 3. Select provider (default or user choice)
auto provider = config.pedanticVariants[0];  // QtMultimedia

// 4. Instantiate widgets dynamically
QWidget* node = new QWidget();
QVBoxLayout* layout = new QVBoxLayout(node);

for (const auto& widgetName : provider.widgets) {
    QWidget* widget = WidgetFactory::create(widgetName);
    layout->addWidget(widget);
}

// 5. Generate unique ID
string nodeId = IDGenerator::generate("N", "AN", "AC");
// Result: NANAC-550e8400-e29b-41d4-a716-446655440000

// 6. Create node store
auto nodePath = "~/Neural-Studio/profiles/gaming/nodes/" + nodeId;
auto nodeStore = ObjectBox::createStore(nodePath, "AudioClipSettings");

// 7. Save initial configuration
nodeStore->put({
    .id = nodeId,
    .provider = "QtMultimedia",
    .filePath = "",
    .volume = 1.0f,
    .loop = false
});

// 8. Register in profile store
profileStore->put(GraphNode{
    .id = nodeId,
    .symbioticPrefix = "NANAC",
    .position = {100, 100, 0},
    .nodeStorePath = nodePath
});
```

---

## 6. ObjectBox Integration

### Five-Store Architecture

```
┌────────────────────────────────────────────────────────────┐
│  0. INDEX STORE (Meta-Registry)                            │
│  Location: ~/.config/neural-studio/objectbox/master/index/ │
│                                                             │
│  Tables:                                                    │
│  - SpeciesIndex (32 species codes)                         │
│  - EthnicityIndex (ethnicities per species)                │
│  - ArchetypeIndex (archetypes per ethnicity)               │
│  - SchemaIndex (symbiotic prefix → schema mapping)         │
│  - WidgetRegistry (280 widget definitions)                 │
│  - ComponentRegistry (80 atomic components)                │
│                                                             │
│  Purpose: Source of truth for all valid ID combinations    │
└────────────────────────────────────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────────────────────────┐
│  1. MASTER STORE (Global Definitions)                      │
│  Location: ~/.config/neural-studio/objectbox/master/       │
│                                                             │
│  Tables:                                                    │
│  - NodeEthnicity (rank, tribe, integration tactics)        │
│  - ConnectionRule (valid edge connections)                 │
│  - PipelineTemplate (workflow templates)                   │
│                                                             │
│  Purpose: Shared definitions across all profiles           │
└────────────────────────────────────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────────────────────────┐
│  2. PROFILE STORE (Per-User Workspace)                     │
│  Location: ~/Neural-Studio/profiles/<name>/objectbox/      │
│                                                             │
│  Tables:                                                    │
│  - GraphNode (node instance registry)                      │
│  - GraphEdge (connections between nodes)                   │
│  - BroadcastSettings (streaming configurations)            │
│  - SceneObject (3D scene entities)                         │
│                                                             │
│  Purpose: Graph topology for this profile                  │
└────────────────────────────────────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────────────────────────┐
│  3. NODE VARIANT STORES (Per-Instance)                     │
│  Location: ~/Neural-Studio/profiles/<name>/nodes/<uuid>/   │
│                                                             │
│  Tables (dynamic based on archetype):                      │
│  - AudioClipSettings (for NANAC nodes)                     │
│  - AudioStreamSettings (for NANAS nodes)                   │
│  - VideoCaptureSettings (for NVDCP nodes)                  │
│                                                             │
│  Purpose: Instance-specific configuration data             │
└────────────────────────────────────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────────────────────────┐
│  4. AI MEMORY STORE (Learning System)                      │
│  Location: ~/.config/neural-studio/objectbox/ai_memory/    │
│                                                             │
│  Tables:                                                    │
│  - GraphEvent (time-series user actions)                   │
│  - GraphPattern (learned workflows)                        │
│  - IntentPrediction (AI suggestions)                       │
│                                                             │
│  Purpose: Cross-profile pattern learning                   │
└────────────────────────────────────────────────────────────┘
```

### Schema Mapping in INDEX Store

**SchemaIndex Table**:
```flatbuffers
table SchemaIndex {
    id: ulong (key);
    symbiotic_prefix: string;      // "NANAC", "NVDCP", etc.
    species_code: string;           // "N", "P", "S", etc.
    ethnicity_code: string;         // "AN", "VD", "CA", etc.
    archetype_code: string;         // "AC", "ST", "CP", etc.
    
    // Schema locations
    settings_schema_path: string;   // "schemas/nodes/audio/AudioClipSettings.fbs"
    pipeline_schema_path: string;   // "schemas/nodes/audio/AudioClipPipeline.fbs"
    cpp_class_name: string;         // "AudioClipSettings"
    
    // Metadata
    has_pipeline: bool;             // Does this create pipeline stores?
    ethnicity_rank: int;            // Pipeline master priority
    niche: string;                  // "ImmutableDominion", "AetherBubble"
    
    // Widget composition
    widget_list: [string];          // Array of widget names
    atomic_components: [string];    // Array of atomic component names
}
```

**Example Entry**:
```json
{
  "id": 1,
  "symbiotic_prefix": "NANAC",
  "species_code": "N",
  "ethnicity_code": "AN",
  "archetype_code": "AC",
  "settings_schema_path": "schemas/nodes/audio/AudioClipSettings.fbs",
  "pipeline_schema_path": "schemas/nodes/audio/AudioClipPipeline.fbs",
  "cpp_class_name": "AudioClipSettings",
  "has_pipeline": true,
  "ethnicity_rank": 4,
  "niche": "ImmutableDominion",
  "widget_list": [
    "AudioClipPlayerWidget_QtMultimedia",
    "AudioClipSettingsWidget",
    "WaveformVisualizerWidget",
    "AudioOutputSelectorWidget"
  ],
  "atomic_components": [
    "AudioBufferProcessor",
    "FileIOHandler",
    "QtMultimediaBackend"
  ]
}
```

### Dynamic Schema Discovery

```cpp
// When creating a node
string nodeId = "NANAC-550e8400-e29b-41d4-a716-446655440000";

// 1. Parse ID
auto parsed = TaxonomicID::parse(nodeId);
// Result: {species="N", ethnicity="AN", archetype="AC", ...}

// 2. Query INDEX store
auto schema = indexStore->query()
    .equal(SchemaIndex_.symbiotic_prefix, parsed.symbioticPrefix)
    .build()
    .findFirst();

// 3. Get schema paths
string settingsSchema = schema->settings_schema_path;
string pipelineSchema = schema->pipeline_schema_path;

// 4. Create store with correct schema
auto nodeStore = StoreBuilder::buildStore(
    nodeStorePath,
    settingsSchema,
    schema->cpp_class_name
);

// 5. If pipeline node, create pipeline store
if (schema->has_pipeline && isPipelineMaster(nodeId)) {
    auto pipelineStore = StoreBuilder::buildStore(
        nodeStorePath,
        pipelineSchema,
        "AudioClipPipeline"
    );
}
```

---

## 7. Dynamic Plugin System

### The Power of Database-Driven Configuration

**Traditional System** (requires recompilation):
```cpp
// ❌ Hardcoded node types
class AudioClipNode : public BaseNode {
    // Hardcoded implementation
};

// ❌ Factory knows all types
NodeFactory::registerType("AudioClip", []() {
    return new AudioClipNode();
});
```

**Neural Studio System** (no recompilation):
```cpp
// ✅ Generic node class
class DynamicNode : public BaseNode {
    DynamicNode(const string& id) {
        // 1. Parse ID
        auto classification = TaxonomicID::parse(id);
        
        // 2. Query INDEX for configuration
        auto config = indexStore->getArchetypeConfig(
            classification.symbioticPrefix
        );
        
        // 3. Load widgets dynamically
        for (const auto& widgetName : config.widget_list) {
            auto widget = WidgetFactory::create(widgetName);
            m_widgets.push_back(widget);
        }
        
        // 4. Load atomic components
        for (const auto& componentName : config.atomic_components) {
            auto component = ComponentFactory::create(componentName);
            m_components.push_back(component);
        }
        
        // 5. Apply configuration
        applyConfiguration(config);
    }
};

// ✅ Factory creates generic nodes
NodeFactory::registerType("DynamicNode", [](const string& id) {
    return new DynamicNode(id);
});
```

### Adding a Plugin Without Recompilation

**Step 1: Add to INDEX Store**
```cpp
// Plugin developer adds entry to INDEX store
indexStore->put(SchemaIndex{
    .symbiotic_prefix = "NMY01",  // Custom plugin prefix
    .species_code = "N",
    .ethnicity_code = "MY",        // Custom ethnicity
    .archetype_code = "01",        // Custom archetype
    .settings_schema_path = "plugins/my_plugin/MyNodeSettings.fbs",
    .widget_list = {
        "MyCustomWidget",
        "MyControlPanel"
    },
    .atomic_components = {
        "MyAtomicProcessor",
        "MyDataHandler"
    }
});
```

**Step 2: Register Widgets**
```cpp
// Plugin provides widget implementation
WidgetFactory::registerWidget("MyCustomWidget", []() {
    return new MyCustomWidget();
});
```

**Step 3: User Creates Node**
```
User drags "My Plugin Node" from custom manager
  ↓
System generates ID: NMY01-550e8400-e29b-41d4-a716-446655440000
  ↓
DynamicNode class queries INDEX for "NMY01"
  ↓
Widgets loaded: MyCustomWidget, MyControlPanel
  ↓
Components loaded: MyAtomicProcessor, MyDataHandler
  ↓
Node appears in blueprint with full functionality
```

**No recompilation required!**

---

## 8. Complete Taxonomy Tables

### Species Layer (32 Codes)

| Code | Name | Domain | Description | Has Ethnicities |
|------|------|--------|-------------|----------------|
| N | Node | Processing | Scene graph nodes | Yes (27) |
| P | Pipeline | Orchestration | Pipeline management | No |
| S | Settings | Data | Configuration stores | No |
| E | Edge | Connectivity | Graph edges | No |
| C | Controller | UI | Qt controllers | No |
| R | Rule | Validation | Connection rules | No |
| M | Media | Assets | Media files | Yes |
| A | MediaAsset | Assets | Media assets | Yes |
| O | Model | Assets | 3D/ML models | Yes |
| G | SceneGraphAsset | Assets | Scene assets | No |
| U | UI | Interface | UI components | Yes |
| L | UIElement | Interface | UI elements | Yes |
| W | Widget | Interface | Widgets | Yes |
| F | Frame | Interface | Frames | No |
| D | Dock | Interface | Docks | No |
| V | Monitor | Output | Monitors | No |
| T | Task | Execution | Tasks | No |
| Z | Event | Execution | Events | No |
| J | Session | Execution | Sessions | No |
| I | API | Connectivity | APIs | Yes |
| Y | APIBinding | Connectivity | API bindings | No |
| B | InteractionBinding | Connectivity | Interaction bindings | No |
| Q | TransportStream | Connectivity | Transport streams | Yes |
| K | IPStream | Connectivity | IP streams | Yes |
| H | Bluetooth | Connectivity | Bluetooth | No |
| X | Manager | System | Managers | Yes |
| 0 | Profile | System | Profiles | No |
| 1 | Hardware | System | Hardware | Yes |
| 2 | WASM | Advanced | WASM modules | No |
| 3 | Conversation | Advanced | AI conversations | No |
| 4 | File | Advanced | File references | No |
| 5 | CSP | Advanced | Cloud/Security | No |

### Node Ethnicity Layer (27 Codes)

| Code | Name | Mutualistic | Tribe | Rank | Can Be Source | Integration Tactics |
|------|------|-------------|-------|------|---------------|---------------------|
| AN | AudioNode | NAN | AuditoryStimuli | 4 | Yes | [T,T,F,F,4] |
| VD | VideoNode | NVD | VisualData | 4 | Yes | [T,T,F,F,4] |
| CA | CameraNode | NCA | CaptureApparatus | 1 | Yes | [T,F,F,F,1] |
| EF | EffectsNode | NEF | EffectProcessing | 6 | No | [F,T,T,F,6] |
| GR | GraphicsNode | NGR | GraphicalRender | 4 | Yes | [T,T,F,F,4] |
| SH | ShaderNode | NSH | ShaderProcessing | 6 | No | [F,T,T,F,6] |
| SC | ScriptNode | NSC | ScriptExecution | 5 | Yes | [T,T,T,F,5] |
| ML | MLNode | NML | MachineLearning | 6 | No | [F,T,T,T,6] |
| AI | AINode | NAI | ArtificialIntel | 6 | No | [F,T,T,T,6] |
| TR | TransformNode | NTR | Transformation | 6 | No | [F,T,T,F,6] |
| FI | FilterNode | NFI | FilterProcessing | 6 | No | [F,T,T,F,6] |
| CO | CompositeNode | NCO | Composition | 6 | No | [F,T,T,F,6] |
| MX | MixerNode | NMX | AudioVideoMix | 6 | No | [F,T,T,F,6] |
| EN | EncoderNode | NEN | Encoding | 60 | No | [F,T,F,F,60] |
| DE | DecoderNode | NDE | Decoding | 4 | Yes | [T,F,F,F,4] |
| ST | StreamNode | NST | Streaming | 60 | No | [F,F,F,T,60] |
| OU | OutputNode | NOU | OutputSink | 70 | No | [F,F,F,T,70] |
| IN | InputNode | NIN | InputSource | 1 | Yes | [T,F,F,F,1] |
| DA | DataNode | NDA | DataManagement | 0 | Yes | [T,F,F,F,0] |
| AP | APINode | NAP | APIInteraction | 2 | Yes | [T,F,F,T,2] |
| HW | HardwareNode | NHW | HardwareIO | 1 | Yes | [T,F,F,F,1] |
| GP | GroupNode | NGP | Grouping | 3 | Yes | [T,T,T,T,3] |
| TG | TriggerNode | NTG | EventTrigger | 9 | No | [F,F,T,F,9] |
| AN | AnalysisNode | NAN | Analysis | 80 | No | [F,F,T,F,80] |
| PP | PostProcessNode | NPP | PostProcessing | 70 | No | [F,T,T,F,70] |
| SU | SupportNode | NSU | Support | 5 | Yes | [T,T,T,F,5] |
| WT | WebTransportNode | NWT | WebTransport | 60 | No | [F,F,F,T,60] |

### AudioNode Archetype Layer (8 Variants)

| Code | Name | Symbiotic | Lineage | Niche | Widgets | Atomic Components |
|------|------|-----------|---------|-------|---------|-------------------|
| AC | AudioClip | NANAC | AudioClip | ImmutableDominion | PlayerWidget, SettingsWidget, WaveformWidget | AudioBufferProcessor, FileIOHandler |
| AF | AudioClipFX | NANAF | AudioClipFX | ImmutableDominion | FXWidget, ParameterWidget | AudioEffectProcessor, DSPEngine |
| AM | AudioClipMusic | NANAM | AudioClipMusic | ImmutableDominion | PlayerWidget, TagEditorWidget, PlaylistWidget | AudioBufferProcessor, FileIOHandler, TagLibHandler |
| AP | AudioClipPodcast | NANAP | AudioClipPodcast | ImmutableDominion | PlayerWidget, ChapterWidget, TranscriptWidget | AudioBufferProcessor, FileIOHandler, ChapterParser |
| AS | AudioStream | NANAS | AudioStream | AetherBubble | StreamWidget, CodecWidget, BufferMonitorWidget | NetworkStreamReceiver, AudioBufferProcessor, CodecHandler |
| SM | AudioStreamMusic | NANSM | AudioStreamMusic | AetherBubble | StreamWidget, PlaylistWidget, RecommendationWidget | NetworkStreamReceiver, AudioBufferProcessor, APIClient |
| SP | AudioStreamPodcast | NANSP | AudioStreamPodcast | AetherBubble | StreamWidget, EpisodeListWidget, SubscriptionWidget | NetworkStreamReceiver, AudioBufferProcessor, RSSParser |
| AV | AudioStreamVoiceCall | NANAV | AudioStreamVoiceCall | AetherBubble | CallWidget, ContactListWidget, CallControlsWidget | NetworkStreamReceiver, AudioBufferProcessor, VoIPHandler |

---

## 9. Implementation Examples

### Example 1: Creating an AudioClip Node

```cpp
// User drags AudioClip from AudioManager
void AudioManager::createAudioClipNode() {
    // 1. Generate taxonomic ID
    string nodeId = IDGenerator::generateNode("AN", "AC");
    // Result: NANAC-550e8400-e29b-41d4-a716-446655440000
    
    // 2. Query INDEX for schema information
    auto schema = indexStore->query()
        .equal(SchemaIndex_.symbiotic_prefix, "NANAC")
        .build()
        .findFirst();
    
    // 3. Create GraphNode entry in Profile Store
    profileStore->put(GraphNode{
        .id = nodeId,
        .symbiotic_prefix = "NANAC",
        .position = {cursorX, cursorY, 0},
        .enabled = true,
        .pipeline_master_id = "",  // Not yet determined
        .node_store_path = ""       // Set below
    });
    
    // 4. Create Node Variant Store
    string nodePath = QString("~/Neural-Studio/profiles/%1/nodes/%2")
        .arg(currentProfile)
        .arg(QString::fromStdString(nodeId))
        .toStdString();
    
    auto nodeStore = StoreBuilder::buildStore(
        nodePath,
        schema->settings_schema_path,
        schema->cpp_class_name
    );
    
    // 5. Initialize with default settings (from 000... template)
    string defaultId = "NANAC-00000000-0000-0000-0000-000000000000";
    auto defaults = nodeStore->get(defaultId);
    
    nodeStore->put(AudioClipSettings{
        .id = nodeId,
        .clip_path = "",
        .start_time_ms = defaults->start_time_ms,
        .end_time_ms = defaults->end_time_ms,
        .volume = defaults->volume,
        .loop = defaults->loop
    });
    
    // 6. Update GraphNode with store path
    auto graphNode = profileStore->get(nodeId);
    graphNode->node_store_path = nodePath;
    profileStore->put(graphNode);
    
    // 7. Create runtime node (DynamicNode)
    auto runtimeNode = NodeFactory::create("DynamicNode", nodeId);
    nodeGraph->addNode(runtimeNode);
    
    // 8. Create UI representation
    auto nodeWidget = new BaseNode();
    nodeWidget->setNodeId(QString::fromStdString(nodeId));
    
    // 9. Load widgets based on schema
    for (const auto& widgetName : schema->widget_list) {
        auto widget = WidgetFactory::create(widgetName);
        nodeWidget->addWidget(widget);
    }
    
    // 10. Place in blueprint canvas
    blueprintCanvas->addNode(nodeWidget, cursorX, cursorY);
}
```

### Example 2: Connecting Nodes with Pipeline Master Logic

```cpp
// User connects AudioClip → AudioFX
void BlueprintCanvas::connectNodes(
    const string& sourceId,  // NANAC-550e...
    const string& targetId   // NANAF-abc1...
) {
    // 1. Parse IDs
    auto sourceTaxonomy = TaxonomicID::parse(sourceId);
    auto targetTaxonomy = TaxonomicID::parse(targetId);
    
    // 2. Get ethnicity information
    auto sourceEthnicity = indexStore->getEthnicity(sourceTaxonomy.ethnicity);
    auto targetEthnicity = indexStore->getEthnicity(targetTaxonomy.ethnicity);
    
    // 3. Check if target becomes pipeline master
    bool targetHasInputs = profileStore->hasIncomingEdges(targetId);
    
    string pipelineMasterId;
    
    if (!targetHasInputs && targetEthnicity->can_be_source) {
        // Target becomes pipeline master
        pipelineMasterId = targetId;
        
        // Create pipeline store for target
        createPipelineStore(targetId, targetTaxonomy.symbioticPrefix);
    } else {
        // Determine pipeline master by rank
        auto sourceNode = profileStore->get(sourceId);
        auto targetNode = profileStore->get(targetId);
        
        string sourceMasterId = sourceNode->pipeline_master_id.empty() 
            ? sourceId 
            : sourceNode->pipeline_master_id;
        
        string targetMasterId = targetNode->pipeline_master_id.empty()
            ? targetId
            : targetNode->pipeline_master_id;
        
        // Compare ranks
        int sourceRank = getMasterRank(sourceMasterId);
        int targetRank = getMasterRank(targetMasterId);
        
        if (sourceRank < targetRank) {
            // Source master wins (lower rank = higher priority)
            pipelineMasterId = sourceMasterId;
            
            // Merge target into source pipeline
            mergePipelines(targetMasterId, sourceMasterId);
        } else {
            // Target master wins
            pipelineMasterId = targetMasterId;
            
            // Merge source into target pipeline
            mergePipelines(sourceMasterId, targetMasterId);
        }
    }
    
    // 4. Create edge in Profile Store
    profileStore->put(GraphEdge{
        .id = generateUUID(),
        .from_node_id = sourceId,
        .to_node_id = targetId,
        .from_port = "output",
        .to_port = "input",
        .edge_type = EdgeType::Audio
    });
    
    // 5. Update pipeline store with new connection
    auto pipelineStore = getPipelineStore(pipelineMasterId);
    pipelineStore->addConnection(sourceId, targetId, EdgeType::Audio);
    
    // 6. Update runtime graph
    nodeGraph->connectPins(sourceId, "output", targetId, "input");
}
```

### Example 3: Dynamic Plugin Loading

```cpp
// Plugin developer creates custom node type
class MyPluginInstaller {
public:
    void install() {
        // 1. Register new ethnicity
        indexStore->put(EthnicityIndex{
            .ethnicity_code = "MP",  // MyPlugin
            .ethnicity_name = "MyPluginNode",
            .mutualistic_prefix = "NMP",
            .tribe = "CustomProcessing",
            .rank = 6,
            .can_be_source = false,
            .integration_tactics = {false, true, true, false, 6}
        });
        
        // 2. Register archetype
        indexStore->put(ArchetypeIndex{
            .archetype_code = "01",
            .archetype_name = "MyPluginVariant1",
            .symbiotic_prefix = "NMP01",
            .lineage = "MyPluginVariant1",
            .niche = "MorphicField"
        });
        
        // 3. Register schema
        indexStore->put(SchemaIndex{
            .symbiotic_prefix = "NMP01",
            .species_code = "N",
            .ethnicity_code = "MP",
            .archetype_code = "01",
            .settings_schema_path = "plugins/myplugin/MyPluginSettings.fbs",
            .pipeline_schema_path = "",  // Not a source node
            .cpp_class_name = "MyPluginSettings",
            .has_pipeline = false,
            .ethnicity_rank = 6,
            .niche = "MorphicField",
            .widget_list = {
                "MyCustomWidget",
                "MyControlPanel"
            },
            .atomic_components = {
                "MyAtomicProcessor"
            }
        });
        
        // 4. Register widgets
        WidgetFactory::registerWidget("MyCustomWidget", []() {
            return new MyCustomWidget();
        });
        
        WidgetFactory::registerWidget("MyControlPanel", []() {
            return new MyControlPanel();
        });
        
        // 5. Register atomic components
        ComponentFactory::registerComponent("MyAtomicProcessor", []() {
            return new MyAtomicProcessor();
        });
        
        // 6. Add to manager
        MyPluginManager* manager = new MyPluginManager();
        managerRegistry->addManager("MyPlugin", manager);
        
        // Done! Users can now drag MyPlugin nodes from MyPluginManager
    }
};

// Neural Studio main() calls plugin installer
void loadPlugins() {
    // Scan plugins directory
    QDir pluginsDir("~/.local/share/neural-studio/plugins");
    
    for (const auto& pluginFile : pluginsDir.entryList({"*.so"})) {
        // Load plugin library
        QPluginLoader loader(pluginsDir.filePath(pluginFile));
        QObject* plugin = loader.instance();
        
        if (plugin) {
            // Cast to plugin interface
            IPluginInstaller* installer = qobject_cast<IPluginInstaller*>(plugin);
            
            // Install plugin (adds INDEX entries)
            installer->install();
        }
    }
}
```

---

## Appendix A: Benefits of Taxonomic IDs

### Traditional System Problems

1. **Type Explosion**: Every node type needs a class
   - AudioClip, AudioClipMusic, AudioClipPodcast → 3 classes
   - AudioStream, AudioStreamMusic, AudioStreamPodcast, AudioStreamVoiceCall → 4 classes
   - 80 atomic components × 3 variants each = **240 classes to maintain**

2. **Factory Complexity**: Hardcoded type registration
   ```cpp
   NodeFactory::registerType("AudioClip", []() { return new AudioClip(); });
   NodeFactory::registerType("AudioClipMusic", []() { return new AudioClipMusic(); });
   // ... 238 more registrations
   ```

3. **Plugin Hell**: Third-party plugins require:
   - Recompilation of core
   - Manual factory registration
   - Version conflicts

4. **Database Chaos**: No standard ID format
   - UUIDs alone: No type information
   - String names: Inconsistent, not parseable

### Taxonomic System Benefits

1. **Single Generic Class**: One `DynamicNode` class for all types
   - Configuration driven by ObjectBox
   - No class explosion

2. **Self-Describing IDs**: Parse type information from ID string
   - `NANAC-...` = Audio file playback node
   - `NANAS-...` = Audio stream node
   - No database query needed for type detection

3. **Dynamic Composition**: Nodes assembled from widgets
   - 80 atomic components
   - 280 widgets
   - **Unlimited combinations** without recompilation

4. **Hot-Swappable Plugins**: Add INDEX entry → instant availability
   - No recompilation
   - No factory registration
   - No version conflicts

5. **Query Optimization**: Filter by string prefix
   ```cpp
   // Get all audio nodes (no database query!)
   auto audioNodes = allIds | filter([](auto& id) {
       return id.starts_with("NAN");
   });
   
   // Get all AudioClip nodes
   auto audioClips = allIds | filter([](auto& id) {
       return id.starts_with("NANAC");
   });
   ```

6. **Pipeline Master Detection**: Rank-based hierarchy
   - Source nodes (rank 4) have priority
   - Transform nodes (rank 6) adopt source masters
   - Encoder nodes (rank 60) always subordinate

7. **Biological Intuition**: Familiar classification structure
   - Kingdom → Phylum → Class → Order → Family → Genus → Species
   - Species → Ethnicity → Archetype (simplified)

---

## Appendix B: Implementation Checklist

### Phase 1: INDEX Store Setup (Week 1)
- [ ] Create SpeciesIndex table (32 species)
- [ ] Create EthnicityIndex table (27 node ethnicities + others)
- [ ] Create ArchetypeIndex table (AudioNode: 8 variants)
- [ ] Create SchemaIndex table (widget composition mappings)
- [ ] Create WidgetRegistry table (280 widgets)
- [ ] Create ComponentRegistry table (80 atomic components)

### Phase 2: Core Infrastructure (Week 2)
- [ ] Implement `TaxonomicID` parser class
- [ ] Implement `IDGenerator` with UUID generation
- [ ] Implement `WidgetFactory` with dynamic registration
- [ ] Implement `ComponentFactory` with dynamic registration
- [ ] Implement `DynamicNode` class (replaces hardcoded node classes)
- [ ] Implement `StoreBuilder` for dynamic store creation

### Phase 3: AudioNode Implementation (Week 3)
- [ ] Create 8 AudioNode archetype schemas
- [ ] Populate SchemaIndex with AudioNode entries
- [ ] Implement AudioClip widgets (3 provider variants)
- [ ] Implement AudioStream widgets (4 provider variants)
- [ ] Test node creation end-to-end
- [ ] Test pipeline master logic

### Phase 4: Plugin System (Week 4)
- [ ] Implement `IPluginInstaller` interface
- [ ] Implement plugin loader (Qt plugin system)
- [ ] Create example plugin (MyPluginNode)
- [ ] Test dynamic loading without recompilation
- [ ] Document plugin development guide

### Phase 5: Additional Node Types (Week 5-6)
- [ ] Implement VideoNode ethnicities (5 variants)
- [ ] Implement CameraNode ethnicities (3 variants)
- [ ] Implement MLNode ethnicities (4 variants)
- [ ] Populate INDEX with all node types
- [ ] Complete widget library (target: 280 widgets)

### Phase 6: Production Hardening (Week 7-8)
- [ ] Performance testing (1000+ nodes in blueprint)
- [ ] Memory leak testing
- [ ] Plugin isolation testing
- [ ] Error recovery testing
- [ ] Documentation completion

---

**End of Document**

**Maintainer**: Neural Studio Core Team  
**Last Updated**: 2025-12-17  
**Version**: 3.0.0 (Taxonomic ID System)
