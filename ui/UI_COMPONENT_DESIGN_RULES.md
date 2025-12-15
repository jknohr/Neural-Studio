# UI COMPONENT DESIGN RULES


## ID SYSTEM ( THE LIFEBLOOD OF THE ENTIRE SYSTEM )

### INTRODUCTION




### PROFILES

#### INDEX DATABASE FOR SPECIES DATABASE

##### INTRODUCTION

You’re right to be frustrated — **I didn’t follow your instruction precisely**.
Thank you for your patience. I’ll fix it **exactly as you asked**, with **no extra interpretation**.

You asked for:

1. **`##### INTRODUCTION` exactly**
2. **The first table to have the fields as COLUMNS ACROSS, not rows**
3. Clean, real table formatting — nothing re-invented

Below is the corrected version.

---

##### INTRODUCTION


PROFILE DATABASE INTRODUCTION
**Launch with it schema mapping all the species, availeble in the system. If No UUID is generated is in a table it will default  to schema defaults for other UUID's that is prefix+26x0**

## SchemaFile streamingprofile.fbs
| Profile Name | Profile Anagram |       Profile Description        |    Profile TAGS   |     STATE TABLE    |   Species                                    |    basic user settings          |
| ------------ | --------------- | ---------------------------------| ----------------- | -----------------  | -------------------------------------------- | ------------------------------  |
|  **string**  |   **string**    |         **string**               | **Array{string}** |    **ST{UUID}**    | **array{vector{string},{string},{string}}**  | **Vector{StateTableID},{UUID}** |
| `"ONLYFANS"` |     `"OF"`      | `"Channel Goal, Ambition, Plan"` | `"1080P, 4k, AI"` | `"23452345634633"` | `"sprefix, speciesname, speciesdescription"` | `"Vector{StateTableID},{UUID}"` |
| `"TikTok"`   |     `"TT"`      | `"Channel Goal, Ambition, Plan"` | `"1080P, AI"`     | `"23452345634634"` | `"sprefix, speciesname, speciesdescription"` | `"Vector{StateTableID},{UUID}"` |
| `"YouTube"`  |     `"YT"`      | `"Channel Goal, Ambition, Plan"` | `"4k, VR, DRONE"` | `"23452345634635"` | `"sprefix, speciesname, speciesdescription"` | `"Vector{StateTableID},{UUID}"` |
| `"Instagram"`|     `"IG"`      | `"Channel Goal, Ambition, Plan"` | `"FPV, 1080P, VR"`| `"23452345634636"` | `"sprefix, speciesname, speciesdescription"` | `"Vector{StateTableID},{UUID}"` |
| `"Facebook"` |     `"FB"`      | `"Channel Goal, Ambition, Plan"` | `"4k, AI"`        | `"23452345634637"` | `"sprefix, speciesname, speciesdescription"` | `"Vector{StateTableID},{UUID}"` |
| `"Twitter"`  |     `"TW"`      | `"Channel Goal, Ambition, Plan"` | `"AI, 4k"`        | `"23452345634638"` | `"sprefix, speciesname, speciesdescription"` | `"Vector{StateTableID},{UUID}"` |
| `"Twitch"`   |     `"TW"`      | `"Channel Goal, Ambition, Plan"` | `"4k, PIP, GAME"` | `"23452345634639"` | `"sprefix, speciesname, speciesdescription"` | `"Vector{StateTableID},{UUID}"` |

## Schemafile StateTable.fbs





## Schemafile BasicUserSettings.fbs





Tracks all 32 species codes.

| s-prefix | species name    | species description                  | category          | has_types | has_archetypes | default_decay          |
| -------- | --------------- | ------------------------------------ | ----------------- | --------- | -------------- | ---------------------- |
| string   | string          | string                               | string            | bool      | bool           | DecayRule              |
| `"N"`    | `"Node"`        | What this species represents         | `"Core Entities"` | true      | false          | Default lifecycle rule |

---


##### COLUMN 1

##### COLUMN 2

##### COLUMN 3

##### COLUMN 4

##### COLUMN 5

---

### SPECIES

**S-PREFIX (1 CHARACTER)**

#### INDEX DATABASE for SPECIES DATABASE.

---

## Universal ID System

### Format

```
[Species:1][Type:2][Archetype:4]-[UUID:36]
```

**Total:** 7 prefix + 1 dash + 36 UUID = **44 characters**

---

## Species Codes

### Core Entities

| Code | Species    | Usage                  |
| ---- | ---------- | ---------------------- |
| `N`  | Node       | Scene graph nodes      |
| `P`  | Pipeline   | Pipeline orchestration |
| `S`  | Settings   | Node variant settings  |
| `E`  | Edge       | Graph connections      |
| `C`  | Controller | UI controllers         |
| `R`  | Rule       | Connection rules       |

### Media & Assets

| Code | Species         | Usage                 |
| ---- | --------------- | --------------------- |
| `M`  | Media           | Media files (generic) |
| `A`  | MediaAsset      | Specific media assets |
| `O`  | Model           | 3D models, ML models  |
| `G`  | SceneGraphAsset | Scene graph assets    |

### UI & Interaction

| Code | Species   | Usage                      |
| ---- | --------- | -------------------------- |
| `U`  | UI        | UI components (generic)    |
| `L`  | UIElement | Specific UI elements       |
| `W`  | Widget    | Widgets                    |
| `F`  | Frame     | Frames (Active, Blueprint) |
| `D`  | Dock      | Dock panels                |
| `V`  | Monitor   | Monitor outputs            |

### Execution & Events

| Code | Species | Usage       |
| ---- | ------- | ----------- |
| `T`  | Task    | Tasks, jobs |
| `Z`  | Event   | Events      |
| `J`  | Session | Sessions    |

### Connectivity

| Code | Species            | Usage                 |
| ---- | ------------------ | --------------------- |
| `I`  | API                | API endpoints         |
| `Y`  | APIBinding         | API bindings          |
| `B`  | InteractionBinding | Interaction bindings  |
| `Q`  | TransportStream    | Transport streams     |
| `K`  | IPStream           | IP streams            |
| `H`  | Bluetooth          | Bluetooth connections |

### Systems

| Code | Species  | Usage             |
| ---- | -------- | ----------------- |
| `X`  | Manager  | Manager instances |
| `0`  | Profile  | User profiles     |
| `1`  | Hardware | Hardware devices  |

### Advanced

| Code | Species      | Usage                                    |
| ---- | ------------ | ---------------------------------------- |
| `2`  | WASM         | WebAssembly modules                      |
| `3`  | Conversation | AI conversations                         |
| `4`  | File         | File references                          |
| `5`  | CSP          | Content Security Policy / Cloud Provider |
| `6`  | CDN          | Content Delivery Network                 |
| `7`  | Extension    | Extensions (reserved)                    |

---

If **anything is still not exactly how you want it**, tell me *what line* or *what table* and I’ll correct only that — no reinterpretation.


##### COLUMN 1

##### COLUMN 2

##### COLUMN 3

##### COLUMN 4

##### COLUMN 5

### SPECIES

S-PREFIX (1 CHARACTER)

#### INDEX DATABASE for SPECIES DATABASE.


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

### TYPES

### ARCHETYPES

### SCHEMAS

### STORES

### INSTANCES

### DECAY

### USAGE

### VALIDATION against elements.

### 


## APP Elements ( Main Entrypoint)

## SHARED UI Elements ( Reusable Components  shared across all frames.)

### components

### widgets 

### forms

### managers

### schenegraph

### menus



## GLOBAL UI Elements ( These are the components that are used outside of the other frames.)



## Active Frame ( Classic OBS Broadcast UI Mixed with 3d Schenegraph )

### controls  ( These are the controls that are used in the active frame.)

### monitors ( These are the monitors that are used in the active frame.)

### panels ( displays that are used in the active frame.)

### preview ( These are the preview windows that are used in the active frame. of various sources and feeds)




## blueprint Elements

### node elements

### connection elements

### edge elements

### form elements

## Evolution Forge Elements

### settings menu elements

### profile selection elements

### theme selector changes

### defaults






## frames Elements

### blueprint frame elements

### active frame elements

### evolution forge frame elements

## panels elements

### port_chat

### agent_chat

##

