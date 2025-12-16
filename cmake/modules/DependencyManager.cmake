# ============================================================================
# Neural Studio - Unified Dependency Manager
# ============================================================================
# Consolidates all dependency sources into one manageable system
# Safe to delete - will fall back to CMake defaults
#
# ============================================================================
# RULES FOR ADDING NEW DEPENDENCIES TO THIS FILE
# ============================================================================
#
# 1. CHECK SYSTEM FIRST - Before FetchContent, check if already installed
#    - Use if(NOT TARGET ...) to avoid re-fetching
#    - Check standard AND non-standard locations ($HOME/*, /opt/*)
#
# 2. FETCHCONTENT FOR AUTO-DOWNLOAD - Use for libraries we control
#    - Pin to specific GIT_TAG (release versions, not branches)
#    - Set FETCHCONTENT_BASE_DIR to keep downloads organized
#    - Document the version and what it's used for
#
# 3. SYSTEM PACKAGES FOR DRIVERS/GRAPHICS - Don't fetch:
#    - GPU drivers (NVIDIA, AMD, Intel)
#    - Vulkan SDK (system install preferred)
#    - Qt6 (official installer or system, not FetchContent)
#    - These require system integration, not just headers
#
# 4. RUST DEPENDENCIES - Use Corrosion bridge
#    - All Rust crates go in dependencies/rust/
#    - Workspace Cargo.toml at dependencies/rust/Cargo.toml
#    - Build artifacts go to ${CMAKE_BINARY_DIR}/rust/
#
# 5. ONE BLOCK PER DEPENDENCY - Keep organized
#    - Clear comment header with PURPOSE
#    - Check if(NOT TARGET ...) before declaring
#    - FetchContent_Declare with pinned version
#    - Call declare_managed_dep() for tracking
#
# 6. FEATURE FLAGS - Gate optional dependencies
#    - Use if(ENABLE_*) to conditionally fetch
#    - Don't waste time fetching unused deps
#
# 7. VENDORED DEPS - Legacy, migrate to FetchContent
#    - Currently in dependencies/ folder
#    - Check EXISTS before using
#    - Plan to replace with FetchContent over time
#
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

# Use build_ubuntu/_build_dependencies for FetchContent downloads
set(FETCHCONTENT_BASE_DIR "${CMAKE_BINARY_DIR}/_build_dependencies")

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
# NOTE: OpenXR SDK uses deprecated FindPythonInterp which was removed in CMake 3.27+
# We patch it at fetch time to use modern find_package(Python3 COMPONENTS Interpreter)
if(NOT TARGET OpenXR::openxr_loader)
    message(STATUS "Declaring OpenXR SDK...")

    # Create a patch script that converts deprecated PythonInterp to modern Python3
    set(OPENXR_PATCH_SCRIPT "${CMAKE_BINARY_DIR}/patch_openxr_python.cmake")
    file(WRITE ${OPENXR_PATCH_SCRIPT} [=[
        # Patch OpenXR CMakeLists.txt to use modern Python3 finding
        file(READ "${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt" OPENXR_CMAKE_CONTENT)
        
        # Replace deprecated find_package(PythonInterp 3) with modern Python3 approach
        string(REPLACE 
            "find_package(PythonInterp 3)"
            "find_package(Python3 COMPONENTS Interpreter QUIET)\nif(Python3_FOUND)\n    set(PYTHON_EXECUTABLE \${Python3_EXECUTABLE})\n    set(PYTHONINTERP_FOUND TRUE)\nendif()"
            OPENXR_CMAKE_CONTENT "${OPENXR_CMAKE_CONTENT}"
        )
        
        file(WRITE "${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt" "${OPENXR_CMAKE_CONTENT}")
        message(STATUS "Patched OpenXR: Converted deprecated PythonInterp to modern Python3")
    ]=])

    FetchContent_Declare(
        OpenXR
        GIT_REPOSITORY https://github.com/KhronosGroup/OpenXR-SDK.git
        GIT_TAG release-1.1.42
        PATCH_COMMAND ${CMAKE_COMMAND} -P ${OPENXR_PATCH_SCRIPT}
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

# Corrosion - CMake <-> Cargo bridge for Rust integration
if(ENABLE_RUST OR ENABLE_WASM_PLUGINS)
    message(STATUS "Declaring Corrosion (Rust/CMake bridge)...")
    FetchContent_Declare(
        Corrosion
        GIT_REPOSITORY https://github.com/corrosion-rs/corrosion.git
        GIT_TAG v0.5.2
    )
    declare_managed_dep("Corrosion" "FetchContent")
endif()

# Make all FetchContent dependencies available
message(STATUS "Fetching declared dependencies...")
FetchContent_MakeAvailable(OpenXR objectbox nlohmann_json)

# Corrosion must be made available separately (it modifies CMake behavior)
if(ENABLE_RUST OR ENABLE_WASM_PLUGINS)
    FetchContent_MakeAvailable(Corrosion)

    # Set Rust build output to build_*/rust/
    set(CARGO_TARGET_DIR "${CMAKE_BINARY_DIR}/rust" CACHE PATH "Rust build artifacts directory")

    # Import Rust workspace if it exists
    if(EXISTS "${CMAKE_SOURCE_DIR}/dependencies/rust/Cargo.toml")
        # Only import if there are actual crates in the workspace
        file(READ "${CMAKE_SOURCE_DIR}/dependencies/rust/Cargo.toml" RUST_WORKSPACE_CONTENT)
        string(FIND "${RUST_WORKSPACE_CONTENT}" "members = []" EMPTY_WORKSPACE)
        if(EMPTY_WORKSPACE EQUAL -1)
            corrosion_import_crate(
                MANIFEST_PATH "${CMAKE_SOURCE_DIR}/dependencies/rust/Cargo.toml"
            )
            message(STATUS "✓ Rust workspace: Imported from dependencies/rust/")
        else()
            message(STATUS "  Rust workspace: Empty (no crates defined yet)")
        endif()
    else()
        message(STATUS "  Rust workspace: Not configured")
    endif()
endif()

# ============================================================================
# Vendored Dependencies (in dependencies/ directory)
# ============================================================================
message(STATUS "")
message(STATUS "--- Vendored Dependencies (Legacy) ---")

# GLAD - OpenGL loader
if(EXISTS "${CMAKE_SOURCE_DIR}/dependencies/glad")
    message(STATUS "✓ GLAD: Found in dependencies/")
    declare_managed_dep("GLAD" "Vendored")
else()
    message(WARNING "⚠ GLAD: NOT FOUND in dependencies/")
endif()

# libcaption - Closed captioning
if(EXISTS "${CMAKE_SOURCE_DIR}/dependencies/libcaption")
    message(STATUS "✓ libcaption: Found in dependencies/")
    declare_managed_dep("libcaption" "Vendored")
else()
    message(WARNING "⚠ libcaption: NOT FOUND in dependencies/")
endif()

# blake2 - Hashing
if(EXISTS "${CMAKE_SOURCE_DIR}/dependencies/blake2")
    message(STATUS "✓ blake2: Found in dependencies/")
    declare_managed_dep("blake2" "Vendored")
else()
    message(WARNING "⚠ blake2: NOT FOUND in dependencies/")
endif()

# json11 removed - now using nlohmann_json via FetchContent

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
# NOTE: We don't call find_package(pxr) here to avoid TBB::tbb target conflict.
# The actual find_package(pxr) is called in core/CMakeLists.txt after all
# FetchContent dependencies are resolved. We just check if it's likely available.
if(EXISTS "$ENV{HOME}/USD/pxrConfig.cmake" OR EXISTS "/usr/local/pxrConfig.cmake")
    message(STATUS "✓ OpenUSD: Available (will be configured later)")
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
# Only set PARENT_SCOPE if we have a parent (i.e., called via include() from another CMakeLists)
get_directory_property(_has_parent PARENT_DIRECTORY)
if(_has_parent)
    set(NEURAL_STUDIO_DEPS_MANAGED TRUE PARENT_SCOPE)
else()
    set(NEURAL_STUDIO_DEPS_MANAGED TRUE)
endif()
