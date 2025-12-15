# System State Conformity

> **Core Principles:** Universal IDs, Dual-Use Pattern, Intent-Based Routing

---

## Documentation Structure

**This directory contains hierarchical ID code documentation organized by the same structure as the IDs themselves.**

### Directory Layout

```
docs/id_documentation/
├── README_SYSTEM_STATE_CONFORMITY.md  ← You are here
│
├── [Species]/                          ← One folder per species code
│   ├── TYPES.md                        ← All type codes for this species
│   │                                      Lists: Code, Type, Ethnicity, Rank, Description
│   └── [Type]/                         ← One folder per type code
│       └── ARCHTYPES.md                ← All archetype codes for this type
│                                          Lists: Code, Archetype, Form, Description, Widgets
│
├── N/  (Node species)
│   ├── TYPES.md                        ← 27 node types (AN, CA, EF, GR...)
│   ├── AN/ (AudioNode type)
│   │   └── ARCHTYPES.md                ← 9 audio archetypes (AC, AF, AM...)
│   ├── CA/ (CameraNode type)
│   │   └── ARCHTYPES.md
│   └── ... (25 more type folders)
│
├── P/  (Pipeline species)
│   └── TYPES.md
├── S/  (Settings species)
│   └── TYPES.md
├── E/  (Edge species)
│   └── TYPES.md
│
└── [0-7]/  (System species: Profile, Hardware, WASM, etc.)
    └── TYPES.md
```

### Navigation Pattern

To find codes for a specific ID, follow this path:

1. **Species folder** - First character of ID
   - Example: `N` for Node IDs
2. **TYPES.md** - Lists all 2-char type codes
   - Example: `N/TYPES.md` shows `AN` = AudioNode
3. **Type folder** - Type code from ID
   - Example: `N/AN/` for AudioNode variants
4. **ARCHTYPES.md** - Lists all 4-char archetype codes
   - Example: `N/AN/ARCHTYPES.md` shows `AC` = AudioClip

**Full navigation example:**
```
ID: NANAC00-550e8400-e29b-41d4-a716-446655440000

Step 1: Species 'N' → /N/
Step 2: TYPES.md → Find 'AN' = AudioNode  
Step 3: Type 'AN' → /N/AN/
Step 4: ARCHTYPES.md → Find 'AC' = AudioClip

Result: Node, AudioNode, AudioClip
```

### File Contents

**TYPES.md Format:**
```markdown
| Code | Type | Ethnicity | Rank | Description |
|------|------|-----------|------|-------------|
| AN   | AudioNode | Source | 4 | Audio processing |
| CA   | CameraNode | Source | 4 | Camera input |
```

**ARCHTYPES.md Format:**
```markdown
| Code | Archetype | Form | Description | Widgets |
|------|-----------|------|-------------|---------|
| AC   | AudioClip | File | Pre-recorded audio | [list] |
| AS   | AudioStream | Stream | Real-time audio | [list] |
```

### AI/Search Optimization

**Keywords for discovery:** ID documentation, species codes, type codes, archetype codes, node types, audio variants, video variants, pipeline types, ID registry, structured IDs, Neural Studio IDs

**Common searches:**
- "What does `AN` mean?" → Check `N/TYPES.md`
- "What audio archetypes exist?" → Check `N/AN/ARCHTYPES.md`  
- "List all node ethnicities" → Check `N/TYPES.md` (ethnicity column)
- "How to decode `NANAC00-...`?" → Follow navigation pattern above

---

## Universal ID System

### Format

```
[Species:1][Type:2][Archetype:4]-[UUID:36]
```

**Total:** 7 prefix + 1 dash + 36 UUID = **44 characters**

### Species Codes

#### Core Entities
| Code | Species | Usage |
|------|---------|-------|
| `N` | Node | Scene graph nodes |
| `P` | Pipeline | Pipeline orchestration |
| `S` | Settings | Node variant settings |
| `E` | Edge | Graph connections |
| `C` | Controller | UI controllers |
| `R` | Rule | Connection rules |

#### Media & Assets
| Code | Species | Usage |
|------|---------|-------|
| `M` | Media | Media files (generic) |
| `A` | MediaAsset | Specific media assets |
| `O` | Model | 3D models, ML models |
| `G` | SceneGraphAsset | Scene graph assets |

#### UI & Interaction  
| Code | Species | Usage |
|------|---------|-------|
| `U` | UI | UI components (generic) |
| `L` | UIElement | Specific UI elements |
| `W` | Widget | Widgets |
| `F` | Frame | Frames (Active, Blueprint) |
| `D` | Dock | Dock panels |
| `V` | Monitor | Monitor outputs |

#### Execution & Events
| Code | Species | Usage |
|------|---------|-------|
| `T` | Task | Tasks, jobs |
| `Z` | Event | Events |
| `J` | Session | Sessions |

#### Connectivity
| Code | Species | Usage |
|------|---------|-------|
| `I` | API | API endpoints |
| `Y` | APIBinding | API bindings |
| `B` | InteractionBinding | Interaction bindings |
| `Q` | TransportStream | Transport streams |
| `K` | IPStream | IP streams |
| `H` | Bluetooth | Bluetooth connections |

#### Systems
| Code | Species | Usage |
|------|---------|-------|
| `X` | Manager | Manager instances |
| `0` | Profile | User profiles |
| `1` | Hardware | Hardware devices |

#### Advanced
| Code | Species | Usage |
|------|---------|-------|
| `2` | WASM | WebAssembly modules |
| `3` | Conversation | AI conversations |
| `4` | File | File references |
| `5` | CSP | Content Security Policy / Cloud Provider |
| `6` | CDN | Content Delivery Network |
| `7` | Extension | Extensions (reserved) |

> **All IDs are pointers to ObjectBox data** - species indicates what type of data is stored.

### Examples

```
NAUCLIP-abc123  → Node, Audio, AudioClip
PAUSTRM-def456  → Pipeline, Audio, AudioStream
SVDCAPT-ghi789  → Settings, Video, VideoCapture
EVIDATA-jkl012  → Edge, Visual, Data
```

### Benefits

✅ **Self-documenting** - Type inference from ID  
✅ **Fast filtering** - String prefix matching (no DB queries)  
✅ **Universal** - Same system for all entities  
✅ **Parseable** - Extract species/type/archetype programmatically

### Reserved UUID: Default Templates

**All-zeros UUID** = Default template for that prefix combination

```
{PREFIX}-00000000-0000-0000-0000-000000000000
```

**Examples:**
- `NANCLIP-00000000-0000-0000-0000-000000000000` = Default AudioClip settings
- `NVDCAPT-00000000-0000-0000-0000-000000000000` = Default VideoCapture settings

**Usage:**
1. **First time:** Schema creates 00000... template with hardcoded defaults
2. **New instance:** Clone settings from 00000... template (not schema!)
3. **Customize defaults:** Edit 00000... store → all future instances use new defaults
4. **Decay rule:** `NeverDecay` - default templates never auto-delete

**Benefits:**
✅ Mutable defaults (no recompilation needed)  
✅ Per-variant customization  
✅ User-friendly "Reset to Defaults" / "Save as Default" UI  
✅ No Master Schema duplication needed

---

## Dual-Use ID Pattern

**CRITICAL:** Same ID serves two purposes - **intent determines routing**

### Two Layers

Every ID points to:

1. **ObjectBox Store** → Persistent data (settings, state, topology)
2. **Runtime Object** → In-memory entity (execution, UI, physics)

### Intent-Based Routing

```cpp
string id = "NAUCLIP-550e8400-e29b-41d4-a716-446655440000";

// ============================================
// INTENT: Persistence
// ============================================
profileStore->updateNode(id, settings);        // Save to ObjectBox
pipelineStore->getConnections(id);              // Query topology
profileStore->getEdgesByNode(id);               // Load relationships

// ============================================
// INTENT: Runtime Execution
// ============================================
nodeGraph->getNode(id)->process(ctx);           // Execute processing
controllerRegistry->get(id)->setPosition(x,y);  // Update UI
nodeGraph->connectPins(id, "out", id2, "in");   // Wire nodes

// ============================================
// INTENT: Both (Lifecycle)
// ============================================
auto newId = IDGenerator::generateNode("AU", "CLIP");
nodeFactory->create(newId);                     // Runtime object
profileStore->insertNode(newId, settings);      // Persist entry

nodeGraph->removeNode(id);                      // Delete runtime
profileStore->deleteNode(id);                   // Delete persist
```

### Routing Table

| Operation | Layer | Target |
|-----------|-------|--------|
| `process()` | Runtime | Execute node |
| `setPosition()` | Runtime | UI update |
| `connectPins()` | Both | Wire + persist |
| `updateNode()` | Store | Save settings |
| `getConnections()` | Store | Query graph |
| `loadPipeline()` | Store | Restore state |

**Key:** No separate runtime/store IDs needed!

---

## ObjectBox Store Architecture

### Five-Store System

```
INDEX Store (meta-registry)
  ↓ validates IDs and provides schema paths
  
Profile Store (user workspace)
  ↓ tracks node instances
  
Node Variant Store (per instance)
  ↓ node-specific settings
  
Pipeline Store (if source node)
  ↓ topology tracking

AI Memory Store (learns patterns)
```

**Data Flow:**
1. **INDEX Store** validates ID prefix combinations
2. **Profile Store** creates GraphNode entries
3. **Node Variant Store** holds per-instance settings
4. **Pipeline Store** tracks connections (if pipeline master)
5. **AI Memory Store** learns from usage patterns

### Store Types

#### 0. INDEX Store (Meta-Registry)
**Location:** `~/.config/neural-studio/objectbox/master/index/`

**Contents:**
- `SpeciesIndex` - All 32 species codes (N, P, S, E...)
- `TypeIndex` - All type codes under species (AN, VD, CA...)
- `ArchetypeIndex` - All archetype codes under types (CLIP, STRM...)
- `SchemaIndex` - **Maps prefix → schema location** (critical!)
- `StoreInstance` - Tracks runtime store instances

**Usage:** 
- Validates IDs before creation
- Discovers schema paths for store creation
- Manages decay/lifecycle of stores
- Syncs with `docs/id_documentation/` structure
- Provides runtime type discovery

**This is the source of truth** - software queries INDEX to know what IDs are valid and where their schemas live.

#### 1. Master Store
**Location:** `~/.config/neural-studio/objectbox/master/`

**Contents:**
- `NodeEthnicity` - Rank-based categories (source=4, morphic=6, etc.)
- `ConnectionRule` - Validation rules for edge connections
- `PipelineTemplate` - Saved workflow templates
- Global configuration tables

**Usage:** Global definitions, shared across all profiles. **Does NOT contain NodeType/NodeVariant** - those are in INDEX Store!

#### 2. Profile Store
**Location:** `~/Neural-Studio/profiles/<profile_name>/objectbox/`

**Contents:**
- `GraphNode` - Node instances (references to NodeVariant via ID prefix)
- `GraphEdge` - Connections between nodes (4 edge types)
- `BroadcastSettings` - Output configurations
- `SceneObject` - 3D scene entities

**Usage:** Per-profile graph topology. Each GraphNode stores its structured ID (`NANCLIP-uuid`), position, and state. **Does NOT store settings** - those are in Node Variant Store.

#### 3. AI Memory Store
**Location:** `~/.config/neural-studio/objectbox/ai_memory/`

**Contents:**
- `GraphEvent` - Time-series user actions
- `GraphPattern` - Learned workflow patterns
- `IntentPrediction` - AI-suggested next steps

**Usage:** Cross-profile learning, pattern recognition

#### 4. Node Variant Stores (Dynamic, Per-Instance)
**Location:** `~/Neural-Studio/profiles/<profile_name>/nodes/<node_uuid>/objectbox/`

**Contents (per instance):**
- `{VariantName}Settings` - Node-specific configuration
  - Example: `AudioClipSettings`, `VideoCaptureSettings`
- `{VariantName}Pipeline` - Topology tracking (only if pipeline source node)
  - Example: `AudioClipPipeline`, `AudioStreamPipeline`

**Usage:** Per-node-instance data, loaded/unloaded on demand based on decay rules from INDEX Store.

**Schema discovery:** `IndexStore.getSchemaByPrefix("NANCLIP")` returns schema path for `AudioClipSettings.fbs`

### Store Lifecycle

```cpp
// 1. Validate ID prefix exists
auto schema = indexStore->getSchemaByPrefix("NANCLIP");
if (!schema) throw InvalidIDException("Unknown prefix");

// 2. Generate full ID
auto nodeId = IDGenerator::generateNode("AN", "CLIP");  // "NANCLIP-uuid"

// 3. Create profile entry
profileStore->insertNode(nodeId, {
    .position = {x, y, z},
    .pipelineMasterId = ""
});

// 4. Create node variant store
auto storePath = "~/Neural-Studio/profiles/gaming/nodes/" + nodeId + "/objectbox/";
auto nodeStore = StoreManager->createStore(storePath, schema->cpp_class_name);
nodeStore->saveSettings(initialSettings);

// 5. Track instance in INDEX
indexStore->insertStoreInstance(nodeId, schema->id, storePath);

// 6. If pipeline master, create pipeline store
if (isPipelineMaster(nodeId)) {
    auto pipelineSchema = indexStore->getSchemaByPrefix("PANCLIP");
    auto pipelineStore = StoreManager->createStore(storePath, pipelineSchema->cpp_class_name);
}
```

**Cleanup:**
```cpp
// Delete node
profileStore->deleteNode(nodeId);           // Remove from profile
StoreManager->deleteNodeStore(nodeId);      // Delete variant store
indexStore->deleteStoreInstance(nodeId);    // Remove from INDEX
```

---

## Pipeline Orchestration Logic

### Ethnicity Ranks

Determines pipeline master hierarchy:

| Ethnicity   | Rank | Starter? | Description      |
|-------------|------|----------|------------------|
| data        | 0    |    ✅    | Raw data sources |
| hardware    | 1    |    ✅    | Hardware I/O     |
| api         | 2    |    ✅    | External APIs    |
| grouping    | 3    |    ✅    | Container nodes  |
| source      | 4    |    ✅    | Primary sources  |
| supportive  | 5    |    ✅    | Support systems  |
| morphic     | 6    |    ❌    | Transform nodes  |
| trigger     | 9    |    ❌    | Event nodes      |
| encoding    | 60   |    ❌    | Encoders         |
| postprocess | 70   |    ❌    | Post-process     |
| analysis    | 80   |    ❌    | Analytics        |

### Pipeline Master Rules

**A node becomes Pipeline Master if:**
1. No connections on **LEFT** (visual input) AND **TOP** (audio input)
2. Ethnicity allows it (source, hardware, data, api, etc.)

**Master creates:** `{VariantName}Pipeline` store with node UUID as ID

### Edge Types (4 Tracks)

| Type | Color | Direction | Content |
|------|-------|-----------|---------|
| **Audio** | Red | Top↔Bottom | Audio stream |
| **Visual** | Blue | Left↔Right | Visual stream |
| **DataEdgeAudio** | Grey+Red | Top/Bottom | Audio metadata |
| **DataEdgeVision** | Grey+Blue | Left/Right | Visual metadata |

### Connection Logic

```cpp
// When connecting: Node A → Node B

1. Check B's inputs
   hasInputs = !getInputConnections(B).empty()
   
   if (!hasInputs && B.canBePipelineMaster()) {
       B becomes pipeline master
       createPipelineStore(B.id, B.variant)
   }

2. Get masters
   masterA = A.pipelineMasterId ?: A.id
   masterB = B.pipelineMasterId ?: B.id

3. Compare ranks
   rankA = getNode(masterA)->getEthnicityRank()
   rankB = getNode(masterB)->getEthnicityRank()
   
   if (rankA > rankB) {
       // A's master outranks - B adopts A's master
       mergePipelines(masterB → masterA)
       B.pipelineMasterId = masterA
   } else {
       // B's master outranks - A adopts B's master
       mergePipelines(masterA → masterB)
       A.pipelineMasterId = masterB
   }

4. Update pipeline store
   pipelineStore->addConnection(
       masterId, A.id, B.id, edgeType
   )
```

### Pipeline Store Schema

```flatbuffers
table AudioClipPipeline {
    id: ulong;
    pipeline_id: string;          // "PAUSTRM-uuid"
    source_master_uuid: string;   // Master node ID
    master_rank: int;             // Ethnicity rank
    
    // 4 Separate Tracks
    audio_track: string;          // JSON: [{from, to}]
    visual_track: string;
    data_audio_track: string;
    data_visual_track: string;
    
    // Context
    timeline_start_ms: long;
    scene_start_x: float;
    scene_start_y: float;
    scene_start_z: float;
    
    last_updated: long;
}
```

### Track Format (JSON)

```json
{
  "connections": [
    {
      "from_uuid": "NAUCLIP-abc123",
      "to_uuid": "NAVDFILE-def456",
      "from_port": "output",
      "to_port": "input",
      "timestamp": 1734251234
    }
  ]
}
```

---

## Implementation Guidelines

### Creating Entities

```cpp
// Generate ID
auto id = IDGenerator::generateNode("AU", "CLIP");

// Create runtime object
auto node = nodeFactory->create("AudioClip", id);
nodeGraph->addNode(node);

// Persist to store
profileStore->insertNode(id, {
    .variantId = variantId,
    .ethnicity = "source",
    .rank = 4,
    .nodeStoreRef = nodeStorePath
});

// Create node store
auto nodeStore = StoreManager::createNodeStore(id, "AudioClip");
nodeStore->saveSettings(initialSettings);
```

### Querying

```cpp
// Filter by species (no DB query!)
auto allIds = getAllIds();
auto audioNodes = allIds | filter([](auto& id) { 
    return id.starts_with("NAU"); 
});

// Filter by archetype
auto audioClips = allIds | filter([](auto& id) {
    return id.starts_with("NAUCLIP");
});

// Query store
auto settings = nodeStore->loadSettings(id);
auto connections = pipelineStore->getConnections(masterId);
```

### Lifecycle

```cpp
// Node creation → Both layers
createNode(id) {
    runtime: nodeGraph->addNode(...)
    persist: profileStore->insertNode(...)
}

// Node deletion → Both layers
deleteNode(id) {
    runtime: nodeGraph->removeNode(id)
    persist: profileStore->deleteNode(id)
    persist: StoreManager::deleteNodeStore(id)
}

// Connection → Both layers
connectNodes(idA, idB, edgeType) {
    runtime: nodeGraph->connectPins(...)
    persist: profileStore->insertEdge(...)
    persist: pipelineStore->addConnection(...)
}
```

---

## Key Takeaways

1. **One ID Rules Them All** - Same ID for ObjectBox and runtime
2. **Intent Determines Routing** - Context decides where ID resolves
3. **Self-Documenting IDs** - Parse type/variant without queries
4. **Four-Store Architecture** - Master, Profile, AI, Node Stores
5. **Pipeline Masters Auto-Detect** - Based on inputs + ethnicity
6. **Rank-Based Merging** - Higher rank pipeline wins
7. **4-Track Edge System** - Audio, Visual, DataAudio, DataVisual

---

**Version:** 1.0  
**Last Updated:** 2025-12-15
