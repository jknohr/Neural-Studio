cmake_minimum_required(VERSION 3.28)

# State Management Module (ObjectBox C API)
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 20)

# Find Qt
find_package(Qt6 REQUIRED COMPONENTS Core)

# Find ObjectBox Generator (auto-downloads if needed)
find_package(ObjectBoxGenerator 4.0.0 REQUIRED)

# Create state library FIRST (required by add_obx_schema)
add_library(state STATIC)

# Generate C++ binding code from ALL FlatBuffers schemas (three stores)
add_obx_schema(
    TARGET state
    SCHEMA_FILES
    # Master Store (Global Templates/Archetypes)
    schemas/master/NodeType.fbs
    schemas/master/ConnectionRule.fbs
    schemas/master/PipelineTemplate.fbs

    # Profile Store (User Data/Graphs)
    schemas/profile/GraphNode.fbs
    schemas/profile/GraphEdge.fbs
    schemas/profile/BroadcastSettings.fbs
    schemas/profile/AnimationKeyframe.fbs
    schemas/profile/SceneObject.fbs

    # AI Memory Store (Learning/Patterns)
    schemas/ai/GraphEvent.fbs
    schemas/ai/GraphPattern.fbs
    schemas/ai/IntentPrediction.fbs
    INSOURCE # Generate in source tree for visibility
    CXX_STANDARD 14
)

# Link dependencies
target_link_libraries(state
    PUBLIC
    objectbox
    Qt6::Core
)

target_include_directories(state
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_BINARY_DIR}/_build_dependencies/objectbox-download-src/include
)

# Note: Generated files per schema:
#   - <schema>.obx.hpp/.cpp
#   - objectbox-model.h (shared)
#   - objectbox-model.json (COMMIT TO GIT!)
#
# Schemas organized by store:
#   Master:  NodeType, ConnectionRule, PipelineTemplate
#   Profile: GraphNode, GraphEdge, SceneObject, BroadcastSettings, AnimationKeyframe
#   AI:      GraphEvent, GraphPattern, IntentPrediction
