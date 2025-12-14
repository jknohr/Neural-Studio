# Core Module Aggregator

# Libraries - Look for USD using its native cmake config
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules")

# Use Pixar's native pxrConfig.cmake if available
find_package(pxr CONFIG QUIET HINTS $ENV{HOME}/USD /usr/local /opt/pixar)

if(pxr_FOUND)
    set(OpenUSD_FOUND TRUE)
    add_definitions(-DNEURAL_STUDIO_USE_USD)
    message(STATUS "OpenUSD Found via pxrConfig: ${PXR_VERSION}")
    message(STATUS "  Include dirs: ${PXR_INCLUDE_DIRS}")
    message(STATUS "  Libraries: ${PXR_LIBRARIES}")
else()
    # Fallback to custom finder
    find_package(OpenUSD)
    if(OpenUSD_FOUND)
        add_definitions(-DNEURAL_STUDIO_USE_USD)
        message(STATUS "OpenUSD Found (custom): ${OpenUSD_LIBRARIES}")
    else()
        message(WARNING "OpenUSD NOT found. USD integration will be disabled.")
    endif()
endif()

# Source Modules
add_subdirectory(src/scene-graph)
add_subdirectory(src/scene) # New location for SceneManager
add_subdirectory(src/pipeline) # New location for FrameRouter
add_subdirectory(src/rendering)
add_subdirectory(src/compositor)
add_subdirectory(src/audio)
# add_subdirectory(src/video) # Directory is empty
if(OpenUSD_FOUND)
    add_subdirectory(src/usd_manager)
endif()



# Updater
if(WIN32)
    add_subdirectory(updater)
endif()

# Utilities
# add_subdirectory(utilities/bpm) # Requires OBS
# add_subdirectory(utilities/frontend-utility) # If this has CMakeLists

# Scripting
# add_subdirectory(scripting/obs-scripting) # Missing OBS cmake macros
