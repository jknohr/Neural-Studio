# Blueprint Nodes Module
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick)

# Base Controller Library
add_library(ui-basenode STATIC
    BaseNodeController.cpp
    BaseNodeController.h
)

target_link_libraries(ui-basenode
    Qt6::Core
    Qt6::Quick
)

target_include_directories(ui-basenode PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Nodes
add_subdirectory(StitchNode)
add_subdirectory(HeadsetOutputNode)
add_subdirectory(RTXUpscaleNode)
add_subdirectory(WasmNode)
add_subdirectory(OnnxNode)
add_subdirectory(GeminiNode)
# add_subdirectory(CameraNode) # Missing CMakeLists.txt
# Add other nodes as they are migrated/created
