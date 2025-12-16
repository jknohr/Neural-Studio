# ============================================================================
# Neural Studio - Unified Dependency Manager
# ============================================================================
# Consolidates all dependency sources into one manageable system
# Safe to delete - will fall back to CMake defaults
# ============================================================================

message(STATUS "")
message(STATUS "╔═══════════════════════════════════════════════════════════╗")
message(STATUS "║     Neural Studio - Dependency Manager                    ║")
message(STATUS "╚═══════════════════════════════════════════════════════════╝")
message(STATUS "")

include(FetchContent)

# ============================================================================
# Configuration
# ============================================================================

# Use build_ubuntu/_deps for FetchContent downloads
set(FETCHCONTENT_BASE_DIR "${CMAKE_BINARY_DIR}/_deps")

# Status tracking
set(MANAGED_DEPENDENCIES "")
set(VENDORED_DEPENDENCIES "")
set(SYSTEM_DEPENDENCIES "")

# ============================================================================
# Helper: Declare Managed Dependency
# ============================================================================
function(declare_managed_dep NAME TYPE)
    list(APPEND MANAGED_DEPENDENCIES "${NAME}:${TYPE}")
    set(MANAGED_DEPENDENCIES "${MANAGED_DEPENDENCIES}" PARENT_SCOPE)
endfunction()

# ============================================================================
# FetchContent Dependencies (Auto-downloaded)
# ============================================================================
message(STATUS "--- FetchContent Dependencies ---")

# OpenXR - VR/AR Support
if(NOT TARGET OpenXR::openxr_loader)
    message(STATUS "Declaring OpenXR SDK...")
    FetchContent_Declare(
        OpenXR
        GIT_REPOSITORY https://github.com/KhronosGroup/OpenXR-SDK.git
        GIT_TAG release-1.1.42
    )
    declare_managed_dep("OpenXR" "FetchContent")
endif()

# ObjectBox - State Management
if(NOT TARGET objectbox)
    message(STATUS "Declaring ObjectBox...")
    FetchContent_Declare(
        objectbox
        GIT_REPOSITORY https://github.com/objectbox/objectbox-c.git
        GIT_TAG v0.21.0
    )
    set(OBJECTBOX_BUILD_SHARED OFF CACHE BOOL "Build ObjectBox as static library")
    declare_managed_dep("ObjectBox" "FetchContent")
endif()

# nlohmann_json - JSON parsing
if(NOT TARGET nlohmann_json::nlohmann_json)
    message(STATUS "Declaring nlohmann_json...")
    FetchContent_Declare(
        nlohmann_json
        GIT_REPOSITORY https://github.com/nlohmann/json.git
        GIT_TAG v3.11.3
    )
    declare_managed_dep("nlohmann_json" "FetchContent")
endif()

# Make all FetchContent dependencies available
message(STATUS "Fetching declared dependencies...")
FetchContent_MakeAvailable(OpenXR objectbox nlohmann_json)

# ============================================================================
# Vendored Dependencies (in deps/ directory)
# ============================================================================
message(STATUS "")
message(STATUS "--- Vendored Dependencies (Legacy) ---")

# GLAD - OpenGL loader
if(EXISTS "${CMAKE_SOURCE_DIR}/deps/glad")
    message(STATUS "✓ GLAD: Found in deps/")
    declare_managed_dep("GLAD" "Vendored")
else()
    message(WARNING "⚠ GLAD: NOT FOUND in deps/")
endif()

# libcaption - Closed captioning
if(EXISTS "${CMAKE_SOURCE_DIR}/deps/libcaption")
    message(STATUS "✓ libcaption: Found in deps/")
    declare_managed_dep("libcaption" "Vendored")
else()
    message(WARNING "⚠ libcaption: NOT FOUND in deps/")
endif()

# blake2 - Hashing
if(EXISTS "${CMAKE_SOURCE_DIR}/deps/blake2")
    message(STATUS "✓ blake2: Found in deps/")
    declare_managed_dep("blake2" "Vendored")
else()
    message(WARNING "⚠ blake2: NOT FOUND in deps/")
endif()

# json11 - Legacy JSON (consider removing if nlohmann_json is used)
if(EXISTS "${CMAKE_SOURCE_DIR}/deps/json11")
    message(STATUS "⚠ json11: Found (LEGACY - consider removing, using nlohmann_json)")
    declare_managed_dep("json11" "Vendored-Legacy")
endif()

# ============================================================================
# System Dependencies (find_package)
# ============================================================================
message(STATUS "")
message(STATUS "--- System Dependencies ---")

# Qt6 - UI Framework
find_package(Qt6 QUIET COMPONENTS Core)
if(Qt6_FOUND)
    message(STATUS "✓ Qt6: ${Qt6_VERSION}")
    declare_managed_dep("Qt6" "System")
else()
    message(WARNING "⚠ Qt6: NOT FOUND")
endif()

# OpenUSD - Scene Description
find_package(pxr CONFIG QUIET)
if(pxr_FOUND)
    message(STATUS "✓ OpenUSD: ${PXR_VERSION}")
    declare_managed_dep("OpenUSD" "System")
else()
    message(STATUS "  OpenUSD: Optional (not installed)")
endif()

# Vulkan SDK
find_package(Vulkan QUIET)
if(Vulkan_FOUND)
    message(STATUS "✓ Vulkan SDK: ${Vulkan_VERSION}")
    declare_managed_dep("Vulkan" "System")
else()
    message(STATUS "  Vulkan SDK: Optional")
endif()

# FFmpeg (for video processing)
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
    pkg_check_modules(FFMPEG QUIET libavcodec libavformat libavutil libswscale)
    if(FFMPEG_FOUND)
        message(STATUS "✓ FFmpeg: Found")
        declare_managed_dep("FFmpeg" "System")
    else()
        message(STATUS "  FFmpeg: Optional")
    endif()
endif()

# ============================================================================
# Dependency Summary
# ============================================================================
message(STATUS "")
message(STATUS "╔═══════════════════════════════════════════════════════════╗")
message(STATUS "║     Dependency Summary                                     ║")
message(STATUS "╚═══════════════════════════════════════════════════════════╝")

list(LENGTH MANAGED_DEPENDENCIES TOTAL_DEPS)
message(STATUS "Total managed dependencies: ${TOTAL_DEPS}")
message(STATUS "")

foreach(DEP ${MANAGED_DEPENDENCIES})
    message(STATUS "  ${DEP}")
endforeach()

message(STATUS "")
message(STATUS "Note: Vendored deps in deps/ should be migrated to FetchContent")
message(STATUS "")

# Export for use in other CMakeLists
set(NEURAL_STUDIO_DEPS_MANAGED TRUE PARENT_SCOPE)
