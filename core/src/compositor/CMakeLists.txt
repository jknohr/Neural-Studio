find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets)

# Fetch nlohmann/json for IPC message parsing
include(FetchContent)
FetchContent_Declare(
    nlohmann_json
    GIT_REPOSITORY https://github.com/nlohmann/json.git
    GIT_TAG v3.11.3
    GIT_SHALLOW TRUE
)
FetchContent_MakeAvailable(nlohmann_json)

add_library(neural_studio_compositor STATIC
    MixerRouter.cpp
    MixerEngine.cpp
)

target_link_libraries(neural_studio_compositor PUBLIC
    Qt6::Core
    Qt6::Gui
)

target_include_directories(neural_studio_compositor PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/core/include
)

# Main Executable - DISABLED: needs OpenXRRuntime, IPCServer implementations
# Re-enable once the rendering/OpenXR backend is implemented
# add_executable(neural-studio
#     main.cpp
# )
#
# target_link_libraries(neural-studio PRIVATE
#     neural_studio_compositor
#     Qt6::Core
#     Qt6::Gui
#     Qt6::Widgets
#     nstudio-rendering
#     nstudio-scene
#     nstudio-pipeline
#     scene-graph
#     nlohmann_json::nlohmann_json
# )
