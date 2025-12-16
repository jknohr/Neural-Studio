# UI COMPONENT DESIGN RULES

DO NOT CHANGE ANYTHING IN THE SYSTEM OF THIS FILE NEARLY ALL THE OTHER FILES ARE WRONG... or half wrong and half right an LLM Models went crazy... 



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
|  **string**  |   **string**    |         **string**               | **Array{string}** |    **ST{UUID}**    | **array{vector{sprefix(),string({sprefix()}-0000000000000000000000000000000000000000),string},{string},{string}}**  | **Vector{StateTableID},{UUID}** |
| `"ONLYFANS"` |     `"OF"`      | `"Channel Goal, Ambition, Plan"` | `"1080P, 4k, AI"` | `"23452345634633"` | `"array{vector{sprefix(),string({sprefix()}-0000000000000000000000000000000000000000),string},{string},{string}}"` | `"Vector{StateTableID},{UUID}"` |      
| `"TikTok"`   |     `"TT"`      | `"Channel Goal, Ambition, Plan"` | `"1080P, AI"`     | `"23452345634634"` | `"string(sprefix-0000000000000000000000000000000000000000),string},{string},{string}}"` | `"Vector{StateTableID},{UUID}"` |
| `"YouTube"`  |     `"YT"`      | `"Channel Goal, Ambition, Plan"` | `"4k, VR, DRONE"` | `"23452345634635"` | `"UUID(sprefix-0000000000000000000000000000000000000000),string},{string},{string}}"` | `"Vector{StateTableID},{UUID}"` |
| `"Instagram"`|     `"IG"`      | `"Channel Goal, Ambition, Plan"` | `"FPV, 1080P, VR"`| `"23452345634636"` | `"UUID(sprefix-0000000000000000000000000000000000000000),string},{string},{string}}"` | `"Vector{StateTableID},{UUID}"` |
| `"Facebook"` |     `"FB"`      | `"Channel Goal, Ambition, Plan"` | `"4k, AI"`        | `"23452345634637"` | `"UUID(sprefix-0000000000000000000000000000000000000000),string},{string},{string}}"` | `"Vector{StateTableID},{UUID}"` |
| `"Twitter"`  |     `"TW"`      | `"Channel Goal, Ambition, Plan"` | `"AI, 4k"`        | `"23452345634638"` | `"UUID(sprefix-0000000000000000000000000000000000000000),string},{string},{string}}"` | `"Vector{StateTableID},{UUID}"` |
| `"Twitch"`   |     `"TW"`      | `"Channel Goal, Ambition, Plan"` | `"4k, PIP, GAME"` | `"23452345634639"` | `"UUID(sprefix-0000000000000000000000000000000000000000),string},{string},{string}}"` | `"Vector{StateTableID},{UUID}"` |

```cpp Example not actual code 
#include <iostream>
#include <string>
#include <boost/uuid/uuid.hpp>            // uuid class
#include <boost/uuid/uuid_generators.hpp> // generators
#include <boost/uuid/uuid_io.hpp>         // streaming operators etc.
#include <boost/lexical_cast.hpp>         // for casting string to UUID object

// Function to check and replace the placeholder UUID
std::string get_valid_agent_id(std::string loadedUuidString) {
    // 1. Define the specific placeholder used in your schema file
    const std::string PLACEHOLDER_UUID_STRING = "23452345634633"; // Example from your table

    // Check if the current value matches the placeholder
    if (loadedUuidString == PLACEHOLDER_UUID_STRING) {
        std::cout << "Placeholder detected. Generating a new unique ID." << std::endl;

        // 2. Generate a new UUID using Boost
        boost::uuids::uuid new_uuid = boost::uuids::random_generator()();

        // 3. Convert the generated UUID object back into a string format
        std::stringstream ss;
        ss << new_uuid;
        std::string generated_uuid_str = ss.str();
        
        return generated_uuid_str;
    } else {
        std::cout << "Valid existing ID found. Keeping original value." << std::endl;
        return loadedUuidString;
    }
}


// Example Usage within main() or your agent initialization function:
int main() {
    // Simulate reading the placeholder string from your flatbuffer
    std::string uuidFromSchema = "23452345634633"; 

    // Process the ID to ensure it is valid/unique
    std::string finalAgentID = get_valid_agent_id(uuidFromSchema);

    std::cout << "The final Agent ID to use is: " << finalAgentID << std::endl;

    // Example with an already valid ID:
    std::string validUuidFromSchema = "a8f1d4ae-7dec-41d0-a765-00a0c91e6bf6";
    std::string finalAgentID2 = get_valid_agent_id(validUuidFromSchema);
    std::cout << "The final Agent ID 2 to use is: " << finalAgentID2 << std::endl;

    return 0;
}
```



## Schemafile StateTable.fbs

Maps all species tables for the user with to start with Default prefix-00000 but as the user use them with the right generated uuid... 
Location will alsways be 





## Schemafile BasicUserSettings.fbs





Tracks all 32 species codes.

 id       | s-prefix | species-family  |  species description     |     Taxonomy       | Ethenic-Group                 |  
---       | -------- | --------------- | ------------------------ | -----------------  | ----------------------------- | 
s-prefix()| string   | string          | string                   |      string        | array{string}                 | 
`"N"`     | `"N"`    | `"Node"`        | What this species represe|`"Central Entities"`|`array{vector{string(string)}}`| 

---




 id                | e-prefix | EthenicType-type | Ethenicdescription |  MutalisticPrefix  |      Tribe          |   Linnage-Pedigree    |     IntarigationTactics                             | 
---                | -------- | ---------------- | ------------------ | ------------------ | ------------------- | --------------------- |  -------------------------------------------------- |
mutalisticPrefix() |  string  |     string       |       string       |       string       |      string         |       String          | Array{Boolean, Boolean, Boolean, Boolean, Int}  
`"NAN"`            | `"AU"`   | `"AudioNode"`     | What this species | `"AuditoryStimuly"`| `"AuditoryStimuly"` | represents| SourceNode|    



 id                | l-prefix |    Lineage-Archetype    |     Linneage description      |      Niche           |  symbioticPrefix  |        Pedandic-Variants                   | VectorDolled | GivingBrain |
-------------------| -------- | ----------------------- | ----------------------------- | -------------------- | ----------------- | -----------------------------------------  |  ----------- | ----------- |
SymbioticPrefix()  |  string  |           string        |           string              |     string           |   array{string}   | Lineage-Archetype{vector{Variants(string)}}| vector{vector{vector(string)}} | string     |
`"NANAC"`          | `"AC"`   |      `"AudioClip"`      |      UndefinedAudioClip       |`"ImmutibleDomionion"`| `"Core Entities"` |       `"Vector{Variants(string)}"`         | 
`"NANAF"`          | `"AF"`   |     `"AudioClipFX"`     |          SFX CLIP             |`"ImmutibleDomionion"`| `"Core Entities"` |       `"Vector{Variants(string)}"`         | 
`"NANAM"`          | `"AM"`   |    `"AudioClipMusic"`   | What this species represents  |`"ImmutibleDomionion"`| `"Core Entities"` |       `"Vector{Variants(string)}"`         | 
`"NANAP"`          | `"AP"`   |   `"AudioClipPodCast"`  | What this species represents  |`"ImmutibleDomionion"`| `"Core Entities"` |       `"Vector{Variants(string)}"`         | 
`"NANAS"`          | `"AS"`   |     `"AudioStream"`     | What this species represents  |`"AetherBubble"`      | `"Core Entities"` |       `"Vector{Variants(string)}"`         | 
`"NANSM"`          | `"SM"`   |   `"AudioStreamMusic"`  | What this species represents  |`"AetherBubble"`      | `"Core Entities"` |       `"Vector{Variants(string)}"`         | 
`"NANSP"`          | `"SP"`   | `"AudioStreamPodCast"`  | What this species represents  |`"AetherBubble"`      | `"Core Entities"` |       `"Vector{Variants(string)}"`         | 
`"NANAV"`          | `"AV"`   | `"AudioStreamVoiceCall"`| What this species represents  |`"AetherBubble"`      | `"Core Entities"` |       `"Vector{Variants(string)}"`         | 



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
