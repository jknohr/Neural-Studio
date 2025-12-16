# ObjectBox Architecture in Neural-Studio

> **Living Document:** Maps ObjectBox stores to our actual codebase architecture

---

## Architectural Hierarchy

```
Profile (gaming, podcast, etc.)
    ↓
Manager (AudioManager, VideoManager, GraphicsManager, etc.)
    ↓
NodeType (Audio, Video, Graphics - broader category)
    ↓
Node Variant (AudioClip, AudioStreamMusic, VideoCa pture - specific implementation)
    ↓
Pipeline Schema (connection topology for source nodes)
```

### Example: Complete Flow

```
Profile: "gaming"
├── AudioManager
│   ├── NodeType: "Audio"
│   │   ├── Variant: AudioClip → node_abc123
│   │   │   ├── AudioClipSettings.fbs
│   │   │   └── AudioClipPipeline.fbs (source node!)
│   │   ├── Variant: AudioClipFX → node_def456
│   │   │   └── AudioClipFXSettings.fbs (no pipeline - not source)
│   │   └── Variant: AudioStreamMusic → node_ghi789
│   │       ├── AudioStreamMusicSettings.fbs
│   │       └── AudioStreamMusicPipeline.fbs (source node!)
│   │
├── VideoManager
│   ├── NodeType: "Video"
│   │   ├── Variant: VideoCapture → node_jkl012
│   │   │   ├── VideoCaptureSettings.fbs
│   │   │   └── VideoCapturePipeline.fbs
│   │   └── Variant: VideoFile → node_mno345
│   │       ├── VideoFileSettings.fbs
│   │       └── VideoFilePipeline.fbs
│   │
└── EffectsManager
    ├── NodeType: "Effects"
    │   ├── Variant: ColorCorrection → node_pqr678
    │   │   └── ColorCorrectionSettings.fbs (never source - no pipeline)
    │   └── Variant: ChromaKey → node_stu901
    │       └── ChromaKeySettings.fbs (never source - no pipeline)
```

**Key Insight:** 
- **Profile** = User workspace boundary
- **Manager** = UI category (which panel launches nodes)
- **NodeType** = Logical grouping in Master Store
- **Node Variant** = Specific implementation with unique schema
- **Pipeline Schema** = Auto-created for source nodes (no inputs)

---

## The Four-Store System

### 1. Master Store (Global - Singleton)
**Location:** `~/.config/neural-studio/objectbox/master/`  
**Lifecycle:** Created once on install, read-only

#### Entities

**NodeType** - Base node type definitions
- Example: "AudioNode", "VideoNode", "GraphicsNode"
- Used by: All managers as base category

**NodeVariant** - Specific variant within a node type
- Example: "AudioClip", "AudioStreamMusic", "VideoCapture"
- Links to: NodeType (parent)
- Defines: Default config, ports, widgets

**ConnectionRule** - Valid connection types between variants
- Example: AudioClip.output → AudioClipFX.input
- Validates: Port types, data flow

**PipelineTemplate** - Pre-built workflows
- Example: "Podcast Setup" (AudioStream → AudioClipFX → Output)

#### Schema Files (Master)
```
schemas/master/
├── NodeType.fbs          # AudioNode, VideoNode, etc.
├── NodeVariant.fbs       # AudioClip, AudioStreamMusic, etc.
├── ConnectionRule.fbs    # Valid connections
└── PipelineTemplate.fbs  # Workflow templates
```

---

### 2. Profile Store (Per-User-Profile)
**Location:** `~/Neural-Studio/profiles/<profile_name>/objectbox/`  
**Lifecycle:** Created per profile, active while profile loaded

**THIS IS THE REGISTRY - NOT NODE DATA**

#### Entities

**GraphNode** - Node instances in blueprint
- Links to: NodeVariant (master) + Node Store UUID
- Stores: Position (x, y), name, enabled state
- Example: `{id: 1, variant_id: AudioClip, uuid: node_abc123, pos_x: 100}`

**GraphEdge** - Connections between nodes
- Relations: from_node_id, to_node_id (→ GraphNode)
- Stores: Port names, data type
- Example: `{from: node_abc123.output, to: node_def456.input}`

**BroadcastSettings** - Streaming configs
- Per profile, not per node
- Used by: StreamingManager

**SceneObject** - 3D scene objects
- Links to: GraphNode (which node controls this object)
- Syncs with: USD Stage in ActiveFrame

**AnimationKeyframe** - Timeline animations
- Time-series with id-companion
- Links to: SceneObject

#### Schema Files (Profile)
```
schemas/profile/
├── GraphNode.fbs
├── GraphEdge.fbs
├── BroadcastSettings.fbs
├── SceneObject.fbs
└── AnimationKeyframe.fbs
```

---

### 3. Node Variant Stores (Per-Instance!)
**Location:** `~/Neural-Studio/profiles/<profile>/nodes/<node_uuid>/objectbox/`  
**Lifecycle:** Created when variant instantiated, deleted when removed

**THIS IS WHERE ACTUAL NODE DATA LIVES**

#### Per-Variant Schema Structure

Each variant instance needs **2 schemas minimum**:
1. **Settings Schema** - Always present
2. **Pipeline Schema** - Only if source node (no incoming connections)

#### Example: AudioManager Variants (8 total)

##### AudioClip Variant
```
Node Store: node_abc123/objectbox/

Schemas:
├── AudioClipSettings.fbs
│   ├── clip_path: string
│   ├── start_time_ms: long
│   ├── end_time_ms: long
│   ├── volume: float
│   └── loop: bool
│
└── AudioClipPipeline.fbs (if source node!)
    ├── source_variant_id: ulong
    ├── pipeline_nodes: [ulong]  // Ordered store IDs
    ├── connection_map: string   // Simple JSON topology of store IDs (array of connections)
    └── last_updated: long
```

##### AudioClipFX Variant
```
Node Store: node_def456/objectbox/

Schemas:
├── AudioClipFXSettings.fbs
│   ├── fx_type: string          // reverb, eq, compressor
│   ├── parameters: string       // JSON config
│   ├── wet_dry: float
│   └── bypass: bool
│
└── (No pipeline - not a source)
```

##### AudioStreamMusic Variant
```
Node Store: node_ghi789/objectbox/

Schemas:
├── AudioStreamMusicSettings.fbs
│   ├── stream_url: string
│   ├── codec: string
│   ├── sample_rate: int
│   ├── buffer_size: int
│   └── reconnect: bool
│
└── AudioStreamMusicPipeline.fbs (if source!)
    ├── source_variant_id: ulong
    ├── pipeline_nodes: [ulong]
    ├── connection_map: string
    └── last_updated: long
```

#### Complete AudioManager Variant Schemas

```
schemas/nodes/audio/
├── AudioClipSettings.fbs
├── AudioClipPipeline.fbs
├── AudioClipFXSettings.fbs
├── AudioClipMusicSettings.fbs
├── AudioClipMusicPipeline.fbs
├── AudioClipPodcastSettings.fbs
├── AudioClipPodcastPipeline.fbs
├── AudioStreamSettings.fbs
├── AudioStreamPipeline.fbs
├── AudioStreamMusicSettings.fbs
├── AudioStreamMusicPipeline.fbs
├── AudioStreamPodcastSettings.fbs
├── AudioStreamPodcastPipeline.fbs
├── AudioStreamVoiceCallSettings.fbs
└── AudioStreamVoiceCallPipeline.fbs
```

#### Other Manager Variants (Future)

**VideoManager** - Variants might include:
- VideoCapture, VideoFile, VideoStream, VideoScreenCapture, VideoNDI, etc.

**GraphicsManager** - Variants might include:
- ImageStatic, ImageSequence, GraphicsOverlay, GraphicsParticles, etc.

**EffectsManager** - Variants might include:
- ColorCorrection, ChromaKey, Blur, Transform, etc.

---

### 4. AI Memory Store (Global - Learning)
**Location:** `~/.config/neural-studio/objectbox/ai_memory/`  
**Lifecycle:** Persistent, grows over time

#### Entities

**GraphEvent** - User action log (time-series)
- Logs: Every node add/delete/connect
- Stores: variant type, context hash, session

**GraphPattern** - Learned workflows
- Example: "AudioStream → AudioClipFX → Output" (frequency: 42)
- Unique: pattern_hash

**IntentPrediction** - AI suggestions
- Context → next likely variant
- Confidence scores

#### Schema Files (AI)
```
schemas/ai/
├── GraphEvent.fbs
├── GraphPattern.fbs
└── IntentPrediction.fbs
```

---

## Pipeline Schema Logic

### What is a Source Node?

**Definition:** A node with **NO incoming connections** (no edges on top/left input side)

```
✅ Source Nodes (create pipeline schema):
AudioStream ──→ (no input)
VideoCapture ──→ (no input)
ImageStatic ──→ (no input)

❌ Not Source Nodes (no pipeline schema):
AudioClipFX ←── input from AudioStream
ColorCorrection ←── input from VideoCapture
```

### When Pipeline Schema is Created

```
1. Node variant instantiated
   └─> Check incoming edges

2. If NO incoming edges (source node):
   └─> Create <VariantName>Pipeline schema

3. On every downstream connection change:
   └─> Update pipeline schema with new topology
```

### Pipeline Schema Structure

```flatbuffers
table AudioClipPipeline {
    id: ulong;
    
    /// Source node reference
    source_node_uuid: string;
    source_variant_id: ulong;
    
    /// Pipeline topology (ordered)
    pipeline_nodes: [ulong];  // Array of store IDs in order
    
    /// Connection map (simple topology structure)
    /// Stores which nodes connect to which, in order
    connection_map: string;
    
    /// Branching support
    branches: string;  // JSON array of branch paths
    
    /// Side connections
    side_inputs: string;  // JSON: which nodes connect from side
    
    /// Last update timestamp
    last_updated: long;
}
```

### Connection Map Examples

**Important:** Think of the pipeline **as a diagram** visually, but what we **store is the straight relationship data**. The connections can be unpredictable and complex.

We store:
- Which nodes connect to which
- The order/topology
- Not a literal diagram format - just the data relationships

#### Simple Linear Pipeline
```json
{
  "source": "node_abc123",
  "connections": [
    {"from": "node_abc123", "to": "node_def456"},
    {"from": "node_def456", "to": "node_ghi789"}
  ]
}
```
Visualized as a diagram: `abc123 → def456 → ghi789`

#### Branched Pipeline
```json
{
  "source": "node_abc123",
  "connections": [
    {"from": "node_abc123", "to": "node_def456"},
    {"from": "node_abc123", "to": "node_jkl012"},
    {"from": "node_def456", "to": "node_ghi789"}
  ]
}
```
Visualized as a diagram:
```
abc123 → def456 → ghi789
   └──→ jkl012
```

#### Side Connections (Modulation/Control)
```json
{
  "source": "node_abc123",
  "connections": [
    {"from": "node_abc123", "to": "node_def456"},
    {"from": "node_xyz999", "to": "node_def456", "type": "modulation"}
  ]
}
```
Visualized as a diagram:
```
abc123 → def456
           ↑
        xyz999 (side input)
```

---

## Manager → Variant → Schema Mapping

### Current Managers (ui/shared_ui/managers/)

| Manager | Variants | Settings Schemas | Pipeline Schemas |
|---------|----------|------------------|------------------|
| **AudioManager** | 8 variants | AudioClipSettings<br>AudioClipFXSettings<br>AudioClipMusicSettings<br>AudioClipPodcastSettings<br>AudioStreamSettings<br>AudioStreamMusicSettings<br>AudioStreamPodcastSettings<br>AudioStreamVoiceCallSettings | AudioClipPipeline<br>AudioClipMusicPipeline<br>AudioClipPodcastPipeline<br>AudioStreamPipeline<br>AudioStreamMusicPipeline<br>AudioStreamPodcastPipeline<br>AudioStreamVoiceCallPipeline |
| **VideoManager** | ~5 variants | VideoFileSettings<br>VideoCaptureSettings<br>etc. | VideoFilePipeline<br>VideoCapturePipeline<br>etc. |
| **GraphicsManager** | ~4 variants | ImageStaticSettings<br>GraphicsOverlaySettings<br>etc. | ImageStaticPipeline<br>GraphicsOverlayPipeline<br>etc. |
| **CameraManager** | ~3 variants | Camera3DSettings<br>CameraOrthographicSettings<br>etc. | (Cameras usually not source) |
| **EffectsManager** | ~10 variants | ColorCorrectionSettings<br>ChromaKeySettings<br>BlurSettings<br>etc. | (Effects never source) |
| **ShaderManager** | ~5 variants | CustomShaderSettings<br>etc. | (Shaders never source) |
| **ScriptManager** | ~3 variants | LuaScriptSettings<br>PythonScriptSettings<br>etc. | (Scripts modify, not source) |
| **LLMManager** | ~2 variants | LLMGeneratorSettings<br>LLMAnalyzerSettings | LLMGeneratorPipeline(maybe) |
| **MLManager** | ~3 variants | MLInferenceSettings<br>MLTrainingSettings | MLInferencePipeline(maybe) |

---

## Data Flow: Full Example

### User Creates Audio Podcast Pipeline

```
1. User opens AudioManager panel
   └─> Lists 8 available variants (from Master Store NodeVariant)

2. User drags "AudioStreamPodcast" to blueprint
   └─> BlueprintFrame creates GraphNode
       ├─ Generates UUID: node_abc123
       ├─ Links to: NodeVariant(AudioStreamPodcast)
       ├─ Writes to Profile Store:
       │   GraphNode {variant_id: AudioStreamPodcast, uuid: node_abc123}
       └─ Creates Node Store:
           ~/profiles/podcast/nodes/node_abc123/objectbox/

3. Backend initializes node store with 2 schemas:
   ├─ AudioStreamPodcast Settings.fbs
   │   └─ Default values populated
   └─ AudioStreamPodcastPipeline.fbs (CREATED - it's a source!)
       └─ Initial state: just source node

4. User opens settings widget
   └─> Binds to: node_abc123/objectbox/ AudioStreamPodcastSettings
   └─> User sets: stream_url, codec, buffer_size
   └─> Writes to node store

5. User adds "AudioClipFX" node
   └─> UUID: node_def456
   └─> Creates: AudioClipFXSettings schema only (not source)

6. User connects: AudioStreamPodcast.output → AudioClipFX.input
   └─> Creates GraphEdge in Profile Store
   └─> **Updates AudioStreamPodcastPipeline:**
       {
         source: "node_abc123",
         nodes: ["node_def456"],
         connections: ["abc123->def456"]
       }

7. User adds "Output" node
   └─> UUID: node_ghi789

8. User connects: AudioClipFX.output → Output.input
   └─> **Updates AudioStreamPodcastPipeline again:**
       {
         source: "node_abc123",
         nodes: ["node_def456", "node_ghi789"],
         connections: ["abc123->def456->ghi789"]
       }

9. Backend processes pipeline:
   ├─ Reads AudioStreamPodcastPipeline from node_abc123 store
   ├─ Iterates store IDs in order
   ├─ Loads each node's settings
   ├─ Builds processing chain
   └─> Outputs to SceneGraph → ActiveFrame
```

---

## File Structure

### Schemas Organization

```
core/src/state/schemas/
├── master/
│   ├── NodeType.fbs
│   ├── NodeVariant.fbs
│   ├── ConnectionRule.fbs
│   └── PipelineTemplate.fbs
│
├── profile/
│   ├── GraphNode.fbs
│   ├── GraphEdge.fbs
│   ├── BroadcastSettings.fbs
│   ├── SceneObject.fbs
│   └── AnimationKeyframe.fbs
│
├── nodes/
│   ├── audio/
│   │   ├── AudioClipSettings.fbs
│   │   ├── AudioClipPipeline.fbs
│   │   ├── AudioClipFXSettings.fbs
│   │   ├── AudioClipMusicSettings.fbs
│   │   ├── AudioClipMusicPipeline.fbs
│   │   ├── AudioClipPodcastSettings.fbs
│   │   ├── AudioClipPodcastPipeline.fbs
│   │   ├── AudioStreamSettings.fbs
│   │   ├── AudioStreamPipeline.fbs
│   │   ├── AudioStreamMusicSettings.fbs
│   │   ├── AudioStreamMusicPipeline.fbs
│   │   ├── AudioStreamPodcastSettings.fbs
│   │   ├── AudioStreamPodcastPipeline.fbs
│   │   ├── AudioStreamVoiceCallSettings.fbs
│   │   └── AudioStreamVoiceCallPipeline.fbs
│   │
│   ├── video/
│   │   ├── VideoCaptureSettings.fbs
│   │   ├── VideoCapturePipeline.fbs
│   │   ├── VideoFileSettings.fbs
│   │   ├── VideoFilePipeline.fbs
│   │   └── ... (more variants)
│   │
│   ├── graphics/
│   ├── effects/
│   ├── shader/
│   ├── script/
│   ├── llm/
│   └── ml/
│
└── ai/
    ├── GraphEvent.fbs
    ├── GraphPattern.fbs
    └── IntentPrediction.fbs
```

### Project Directory Structure

```
~/Neural-Studio/profiles/podcast/
├── objectbox/                  # Profile Store
│   └── data.mdb
│
└── nodes/                      # All node variant instances
    ├── node_abc123/           # AudioStreamPodcast instance
    │   └── objectbox/
    │       ├── data.mdb
    │       ├── AudioStreamPodcastSettings (table)
    │       └── AudioStreamPodcastPipeline (table)
    │
    ├── node_def456/           # AudioClipFX instance
    │   └── objectbox/
    │       ├── data.mdb
    │       └── AudioClipFXSettings (table)
    │
    └── node_ghi789/           # Output instance
        └── objectbox/
            └── ...
```

---

## Implementation Status

### ✅ Completed (Phase 1)
- Master Store base schemas (NodeType, ConnectionRule, PipelineTemplate)
- Profile Store schemas (GraphNode, GraphEdge, etc.)
- AI Memory Store schemas (GraphEvent, GraphPattern, IntentPrediction)
- All schemas compile successfully

### 🔄 Current Phase (Phase 2)
- [ ] Add NodeVariant to Master Store
- [ ] Design node variant schemas for each manager
- [ ] Implement pipeline schema structure
- [ ] Create source node detection logic

### ⏳ Planned (Phase 3+)
- [ ] AudioManager: 14 schemas (8 settings + 7 pipelines - AudioClipFX not source)
- [ ] VideoManager: Variant schemas
- [ ] GraphicsManager: Variant schemas
- [ ] EffectsManager: Settings schemas (never pipeline - not source nodes)
- [ ] Pipeline auto-update on connection changes
- [ ] StoreManager coordinator with pipeline tracking

---

## Key Design Decisions

### Why Pipeline Schemas?

**Problem:** How does a source node know its entire downstream processing chain?

**Solution:** Pipeline schema maintains materialized view of full topology
- Fast lookup (no graph traversal needed)
- Easy serialization for backend processing
- Can detect circular references
- Supports branching/merging

### Why Per-Variant Stores?

**Problem:** Different variants need completely different data structures

**Solution:** Each variant = unique schema set
- AudioClip needs: file path, trim points
- AudioStream needs: URL, codec, buffer
- No shared schema bloat
- Type-safe per variant

### Why Source Node Detection?

**Problem:** Which nodes should create pipelines?

**Solution:** Auto-detect based on incoming edges
- Simple rule: no inputs = source
- Pipelines only where needed
- Saves storage

---

**Last Updated:** 2025-12-15  
**Phase:** 1 Complete, Starting Phase 2 (Variant Schemas)  
**Next:** Design AudioManager variant schemas, implement pipeline detection
