# INDEX Store Architecture

**Meta-Registry for ID System Validation and Store Management**

---

## Purpose

The INDEX Store is a **catalog database** that tracks:
1. All valid species/type/archetype combinations
2. Schema file locations for each combination
3. Decay rules and lifecycle management
4. Runtime instance tracking
5. Usage statistics

**This is the source of truth** for what IDs are valid and where their data lives.

---

## Store Location

**Master Store:** `~/.config/neural-studio/objectbox/master/index/`

**Why Master?** The INDEX Store is global, shared across all profiles, because ID definitions are universal.

---

## Schema Tables

### 1. SpeciesIndex

Tracks all 32 species codes.

| Field | Type | Description |
|-------|------|-------------|
| `s-prefix` | string | Single character: "N", "P", "S", etc. |
| `name` | string | Human name: "Node", "Pipeline" |
| `description` | string | What this species represents |
| `category` | string | "Core Entities", "Media & Assets", etc. |
| `has_types` | bool | Does this species have type codes? |
| `has_archetypes` | bool | Does this species have archetypes? |
| `default_decay` | DecayRule | Default lifecycle rule |

**Example entries:**
```cpp
SpeciesIndex("N", "Node", "Scene graph nodes", "Core Entities", true, true, ManualOnly)
SpeciesIndex("E", "Edge", "Graph connections", "Core Entities", true, false, ManualOnly)
```

---

### 2. TypeIndex

Tracks all type codes under each species.

| Field | Type | Description |
|-------|------|-------------|
| `species_id` | relation | Parent species |
| `code` | string | 2-char code: "AN", "VD", "CA" |
| `name` | string | "AudioNode", "VideoNode" |
| `ethnicity` | string | "source", "morphic" (nodes only) |
| `rank` | int | 0-200 hierarchy rank (nodes only) |
| `can_be_pipeline_starter` | bool | Can start pipeline? |
| `decay_rule` | DecayRule | Lifecycle management |
| `decay_interval_ms` | long | Auto-delete interval |

**Example entries:**
```cpp
TypeIndex(N_id, "AN", "AudioNode", "source", 4, true, ManualOnly, 0)
TypeIndex(N_id, "CA", "CameraNode", "source", 4, true, ManualOnly, 0)
TypeIndex(E_id, "AU", "AudioEdge", "", 0, false, NeverDecay, 0)
```

---

### 3. ArchetypeIndex

Tracks archetype codes under each type.

| Field | Type | Description |
|-------|------|-------------|
| `type_id` | relation | Parent type |
| `code` | string | 4-char code: "CLIP", "STRM" |
| `name` | string | "AudioClip", "AudioStream" |
| `form` | string | "File", "Stream", "API" |
| `widget_ids` | string | JSON array of widget IDs |
| `decay_rule` | DecayRule | Lifecycle management |

**Example entries:**
```cpp
ArchetypeIndex(AN_id, "CLIP", "AudioClip", "File", '["WANPL","WANSS"]', ManualOnly, 0)
ArchetypeIndex(AN_id, "STRM", "AudioStream", "Stream", '["WANCS","WANIF"]', ManualOnly, 0)
```

---

### 4. SchemaIndex

**CRITICAL TABLE** - Maps prefix combinations to schemas.

| Field | Type | Description |
|-------|------|-------------|
| `prefix` | string | "N", "NAN", "NANCLIP", "PAU" |
| `species_id` | relation | Species reference |
| `type_id` | relation | Type reference (nullable) |
| `archetype_id` | relation | Archetype reference (nullable) |
| `schema_path` | string | Path to .fbs file |
| `schema_filename` | string | Filename only |
| `cpp_header_path` | string | Generated .obx.h path |
| `cpp_source_path` | string | Generated .obx.cpp path |
| `cpp_class_name` | string | C++ class name |
| `store_type` | string | "Master", "Profile", "NodeVariant" |
| `decay_rule` | DecayRule | `x`, `0`, or interval |
| `last_accessed` | long | Usage tracking |

**Example entries:**
```cpp
SchemaIndex(
    "NAN",                                    // Prefix
    N_id, AN_id, null,                        // Species+Type (no archetype)
    "schemas/profile/GraphNode.fbs",
    "GraphNode.fbs",
    "objectbox-models/GraphNode.obx.h",
    "objectbox-models/GraphNode.obx.cpp",
    "GraphNode",
    "Profile",
    ManualOnly, 0
)

SchemaIndex(
    "NANCLIP",                                // Full prefix
    N_id, AN_id, CLIP_id,                     // Species+Type+Archetype
    "schemas/nodes/audio/AudioClipSettings.fbs",
    "AudioClipSettings.fbs",
    "objectbox-models/AudioClipSettings.obx.h",
    "objectbox-models/AudioClipSettings.obx.cpp",
    "AudioClipSettings",
    "NodeVariant",
    ManualOnly, 0
)
```

---

### 5. StoreInstance

Tracks **actual runtime instances** of stores.

| Field | Type | Description |
|-------|------|-------------|
| `instance_id` | string | Full ID: "NANCLIP-uuid" |
| `schema_id` | relation | Which schema this uses |
| `store_path` | string | Disk location |
| `is_loaded` | bool | Currently in memory? |
| `last_accessed` | long | Last use timestamp |
| `decay_rule` | DecayRule | Lifecycle rule |
| `scheduled_deletion` | long | When to auto-delete |
| `reference_count` | int | How many refs? |

**Example:**
```cpp
StoreInstance(
    "NANCLIP-550e8400-...",
    NANCLIP_schema_id,
    "~/Neural-Studio/profiles/gaming/nodes/550e8400-.../objectbox/",
    true,  // loaded
    1734251234,
    ManualOnly,
    0,  // never auto-delete
    3   // 3 references
)
```

---

## Decay Rules

```cpp
enum DecayRule {
    NeverDecay = 'x',    // Store persists forever (e.g., Master Store)
    ManualOnly = 0,      // Only deleted by explicit user action
    Interval = <ms>      // Auto-delete after interval if unused
}
```

**Examples:**
- **Master Store** → `NeverDecay` - Global definitions never auto-delete
- **Profile Store** → `ManualOnly` - Only deleted when profile deleted
- **Node Store** → `Interval(86400000)` - Delete after 24h if unused
- **Temp Pipeline** → `Interval(3600000)` - Delete after 1h if unused

---

## Usage Patterns

### 1. Validate ID

```cpp
// User creates: "NANCLIP-..."
auto schema = indexStore->getSchemaByPrefix("NANCLIP");
if (!schema) {
    throw InvalidIDException("Unknown prefix: NANCLIP");
}
// Valid! Proceed to create store
```

### 2. Find Schema Location

```cpp
auto schema = indexStore->getSchemaByPrefix("PAUSTRM");
auto schemaPath = schema->schema_path;  // "schemas/pipelines/AudioStreamPipeline.fbs"
auto cppClass = schema->cpp_class_name;  // "AudioStreamPipeline"
```

### 3. Create Store Instance

```cpp
auto id = IDGenerator::generateNode("AN", "CLIP");
auto schema = indexStore->getSchemaByPrefix("NANCLIP");

// Create ObjectBox store
auto storePath = createNodeStoreDirectory(id);
auto store = openObjectBoxStore(storePath, schema->cpp_class_name);

// Track instance
indexStore->insertStoreInstance(id, schema->id, storePath);
```

### 4. Cleanup Unused Stores

```cpp
// Background task runs periodically
auto now = getCurrentTimestamp();
auto instances = indexStore->getStoreInstancesByDecayRule(DecayRule::Interval);

for (auto& instance : instances) {
    if (instance->reference_count == 0 &&
        now - instance->last_accessed > instance->decay_interval_ms) {
        
        // Auto-delete
        deleteObjectBoxStore(instance->store_path);
        indexStore->deleteStoreInstance(instance->id);
    }
}
```

### 5. Discover Available Types

```cpp
// Get all audio node archetypes
auto audioType = indexStore->getTypeByCode("N", "AN");
auto archetypes = indexStore->getArchetypesByType(audioType->id);

for (auto& arch : archetypes) {
    cout << arch->code << " -> " << arch->name << endl;
    // CLIP -> AudioClip
    // STRM -> AudioStream
    // ...
}
```

---

## Synchronization with Documentation

The INDEX Store should be **populated from** the markdown documentation:

```cpp
// On startup or refresh
void IndexManager::syncFromDocs() {
    auto docsPath = "docs/id_documentation/";
    
    // Read N/TYPES.md
    auto nodeTypes = parseTypesMarkdown(docsPath + "N/TYPES.md");
    for (auto& type : nodeTypes) {
        indexStore->insertOrUpdateType(type.code, type.name, ...);
    }
    
    // Read N/AN/ARCHTYPES.md
    auto audioArchs = parseArchtypesMarkdown(docsPath + "N/AN/ARCHTYPES.md");
    for (auto& arch : audioArchs) {
        indexStore->insertOrUpdateArchetype(arch.code, arch.name, ...);
    }
}
```

---

## Integration Points

1. **IDGenerator** - Validates prefix exists before generating UUID
2. **StoreManager** - Looks up schema path when creating stores
3. **NodeFactory** - Discovers available node types/archetypes
4. **GarbageCollector** - Uses decay rules for cleanup
5. **UI Menus** - Populates node creation menus from INDEX

---

## Key Benefits

✅ **Single source of truth** for valid IDs  
✅ **Schema discovery** at runtime  
✅ **Automatic cleanup** of unused stores  
✅ **Usage analytics** for optimization  
✅ **Validation** before store creation  
✅ **Documentation sync** with code

---

**Version:** 1.0  
**Last Updated:** 2025-12-15
