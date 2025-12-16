# ============================================================================
# Neural Studio - Dependency Verification Module
# ============================================================================
# This file checks all major dependencies before build.
# Safe to delete - project will build without this file.
#
# Usage:
#   Normal mode: include(CheckDependencies)
#   Show latest versions: cmake -DCHECK_LATEST_VERSIONS=ON ..
#
# ============================================================================
# RULES FOR ADDING NEW DEPENDENCIES TO THIS FILE
# ============================================================================
#
# 1. SYSTEM FIRST - Always check what is installed on the user's system FIRST
#    - Search standard locations: /usr, /usr/local, /opt
#    - Search non-standard locations: $HOME/*, custom paths
#    - Use find_program(), find_path(), find_library()
#
# 2. NEVER TRUST UBUNTU REPOS - Ubuntu packages are often outdated
#    - Check version AFTER finding the package
#    - Compare against KNOWN_LATEST_* or minimum required version
#    - Warn if version is too old, suggest alternative install methods
#    - Example: Ubuntu Qt6 might be 6.2 but we need 6.10+
#
# 3. VERSION COMPARISON - Always validate versions
#    - Use VERSION_LESS / VERSION_GREATER comparisons
#    - Warn if older than required minimum
#    - Log if newer than tracked latest (user has cutting-edge)
#
# 4. CHECK HEADERS - Verify headers exist at found locations
#    - Use find_path() with specific header names
#    - Check multiple possible locations (system, user home, custom)
#    - Validate the header file actually exists with EXISTS
#
# 5. CHECK LIBRARIES - Verify libraries can be linked
#    - Use find_library() to locate .so/.a files
#    - Check lib/ and lib64/ directories
#
# 6. ONE BLOCK PER SOFTWARE - Keep each dependency self-contained
#    - Clear header comment with PURPOSE, USED FOR, OPTIONAL/REQUIRED
#    - All checks for that software in one section
#    - Clear separator between sections
#
# 7. LINUX PACKAGE HINTS - Suggest apt install commands
#    - Show exact package names for Ubuntu/Debian
#    - Show alternative install methods (official installers, source builds)
#
# 8. REPORT CLEARLY - Use consistent status messages
#    - ✓ for found/success
#    - ✗ for required but missing
#    - ⚠ for optional/warnings
#
# ============================================================================

# ============================================================================
# SYSTEM SCAN - Detect YOUR actual installed versions (Baseline)
# ============================================================================
message(STATUS "Scanning system for installed versions...")

# Detect CMake version (current running version)
set(MY_CMAKE_VERSION "${CMAKE_VERSION}")

# Detect GCC version
execute_process(
    COMMAND gcc --version
    OUTPUT_VARIABLE GCC_VERSION_OUTPUT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
string(REGEX MATCH "([0-9]+\\.[0-9]+\\.[0-9]+)" MY_GCC_VERSION "${GCC_VERSION_OUTPUT}")

# Detect Clang version
execute_process(
    COMMAND clang++ --version
    OUTPUT_VARIABLE CLANG_VERSION_OUTPUT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
string(REGEX MATCH "version ([0-9]+\\.[0-9]+\\.[0-9]+)" CLANG_MATCH "${CLANG_VERSION_OUTPUT}")
set(MY_CLANG_VERSION "${CMAKE_MATCH_1}")

# Detect Python version
execute_process(
    COMMAND python3 --version
    OUTPUT_VARIABLE PYTHON_VERSION_OUTPUT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
string(REGEX MATCH "([0-9]+\\.[0-9]+\\.[0-9]+)" MY_PYTHON_VERSION "${PYTHON_VERSION_OUTPUT}")

# Detect Qt version from CMAKE_PREFIX_PATH
if(CMAKE_PREFIX_PATH)
    string(REGEX MATCH "Qt/([0-9]+\\.[0-9]+\\.[0-9]+)" QT_PATH_MATCH "${CMAKE_PREFIX_PATH}")
    if(CMAKE_MATCH_1)
        set(MY_QT_VERSION "${CMAKE_MATCH_1}")
    endif()
endif()

# Detect Vulkan version
execute_process(
    COMMAND pkg-config --modversion vulkan
    OUTPUT_VARIABLE VULKAN_VERSION_OUTPUT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
set(MY_VULKAN_VERSION "${VULKAN_VERSION_OUTPUT}")

# Detect Rust version
execute_process(
    COMMAND rustc --version
    OUTPUT_VARIABLE RUST_VERSION_OUTPUT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
string(REGEX MATCH "([0-9]+\\.[0-9]+\\.[0-9]+)" MY_RUST_VERSION "${RUST_VERSION_OUTPUT}")

# Use detected versions as baseline
set(KNOWN_LATEST_CMAKE "${MY_CMAKE_VERSION}")
set(KNOWN_LATEST_GCC "${MY_GCC_VERSION}")
set(KNOWN_LATEST_CLANG "${MY_CLANG_VERSION}")
set(KNOWN_LATEST_PYTHON "${MY_PYTHON_VERSION}")
set(KNOWN_LATEST_QT "${MY_QT_VERSION}")
set(KNOWN_LATEST_VULKAN "${MY_VULKAN_VERSION}")
set(KNOWN_LATEST_RUST "${MY_RUST_VERSION}")

# Additional versions
set(KNOWN_LATEST_OBJECTBOX "4.1.0") # State management database
set(KNOWN_LATEST_NVIDIA_DRIVER "560") # NVIDIA GPU driver (Dec 2024)
set(KNOWN_LATEST_CUDA "12.6") # CUDA Toolkit
set(KNOWN_LATEST_EMSCRIPTEN "3.1.69") # WebAssembly compiler
set(KNOWN_LATEST_USD "24.11") # Universal Scene Description

message(STATUS "")
message(STATUS "╔═══════════════════════════════════════════════════════════╗")
message(STATUS "║     Neural Studio - Dependency Verification               ║")
if(CHECK_LATEST_VERSIONS)
    message(STATUS "║              LATEST VERSIONS MODE                         ║")
endif()
message(STATUS "╚═══════════════════════════════════════════════════════════╝")
message(STATUS "")

if(CHECK_LATEST_VERSIONS)
    message(STATUS "Detected YOUR baseline versions (from system scan):")
    if(KNOWN_LATEST_CMAKE)
        message(STATUS "  CMake:      ${KNOWN_LATEST_CMAKE}")
    endif()
    if(KNOWN_LATEST_GCC)
        message(STATUS "  GCC:        ${KNOWN_LATEST_GCC}")
    endif()
    if(KNOWN_LATEST_CLANG)
        message(STATUS "  Clang:      ${KNOWN_LATEST_CLANG}")
    endif()
    if(KNOWN_LATEST_PYTHON)
        message(STATUS "  Python:     ${KNOWN_LATEST_PYTHON}")
    endif()
    if(KNOWN_LATEST_QT)
        message(STATUS "  Qt:         ${KNOWN_LATEST_QT}")
    endif()
    if(KNOWN_LATEST_VULKAN)
        message(STATUS "  Vulkan SDK: ${KNOWN_LATEST_VULKAN}")
    endif()
    if(KNOWN_LATEST_RUST)
        message(STATUS "  Rust:       ${KNOWN_LATEST_RUST}")
    endif()
    message(STATUS "")
    message(STATUS "Now checking dependencies against YOUR baseline...")
    message(STATUS "  (Will warn if anything tries to downgrade)")
    message(STATUS "")
endif()

set(DEPENDENCY_CHECK_FAILED FALSE)
set(DEPENDENCY_WARNINGS "")
set(VERSION_COMPARISON_WARNINGS "")

# ============================================================================
# Helper Functions
# ============================================================================

function(check_package PACKAGE_NAME DESCRIPTION)
    find_package(${PACKAGE_NAME} QUIET)
    if(${PACKAGE_NAME}_FOUND OR ${PACKAGE_NAME}_FOUND)
        message(STATUS "✓ ${DESCRIPTION}: FOUND")
    else()
        message(STATUS "✗ ${DESCRIPTION}: NOT FOUND")
        set(DEPENDENCY_CHECK_FAILED TRUE PARENT_SCOPE)
        set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - ${DESCRIPTION} is missing" PARENT_SCOPE)
    endif()
endfunction()

function(check_header HEADER_NAME DESCRIPTION)
    find_path(${HEADER_NAME}_INCLUDE_DIR ${HEADER_NAME})
    if(${HEADER_NAME}_INCLUDE_DIR)
        message(STATUS "✓ ${DESCRIPTION}: FOUND")
    else()
        message(WARNING "⚠ ${DESCRIPTION}: NOT FOUND (optional)")
        set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - ${DESCRIPTION} is missing (optional)" PARENT_SCOPE)
    endif()
endfunction()

function(check_program PROGRAM_NAME DESCRIPTION)
    find_program(${PROGRAM_NAME}_EXECUTABLE ${PROGRAM_NAME})
    if(${PROGRAM_NAME}_EXECUTABLE)
        message(STATUS "✓ ${DESCRIPTION}: FOUND")
    else()
        message(STATUS "✗ ${DESCRIPTION}: NOT FOUND")
        set(DEPENDENCY_CHECK_FAILED TRUE PARENT_SCOPE)
        set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - ${DESCRIPTION} is missing" PARENT_SCOPE)
    endif()
endfunction()

# Compare version with known latest and warn if outdated or being downgraded
function(compare_version COMPONENT_NAME CURRENT_VERSION KNOWN_LATEST)
    if(CHECK_LATEST_VERSIONS AND CURRENT_VERSION)
        if(CURRENT_VERSION VERSION_LESS KNOWN_LATEST)
            message(WARNING "⚠ ${COMPONENT_NAME}: ${CURRENT_VERSION} is older than latest ${KNOWN_LATEST}")
            message(WARNING "   This may be from an outdated repository!")
            set(VERSION_COMPARISON_WARNINGS "${VERSION_COMPARISON_WARNINGS}\n  - ${COMPONENT_NAME} ${CURRENT_VERSION} < ${KNOWN_LATEST} (repository may be outdated)" PARENT_SCOPE)
        elseif(CURRENT_VERSION VERSION_GREATER KNOWN_LATEST)
            message(STATUS "  ${COMPONENT_NAME}: ${CURRENT_VERSION} is NEWER than tracked latest ${KNOWN_LATEST} ✓")
        else()
            message(STATUS "  ${COMPONENT_NAME}: ${CURRENT_VERSION} matches latest ✓")
        endif()
    endif()
endfunction()

# ============================================================================
# Core Build Tools
# ============================================================================
message(STATUS "")
message(STATUS "--- Core Build Tools ---")

# CMake version check (MODERN: 3.28+ for latest features)
if(CMAKE_VERSION VERSION_LESS "3.28")
    message(FATAL_ERROR "✗ CMake ${CMAKE_VERSION} is too old")
    message(STATUS "  Required: CMake 3.28+ (current standard)")
    set(DEPENDENCY_CHECK_FAILED TRUE)
else()
    message(STATUS "✓ CMake: ${CMAKE_VERSION}")
    compare_version("CMake" "${CMAKE_VERSION}" "${KNOWN_LATEST_CMAKE}")
endif()

# C++ Standard check (TARGET: C++20 minimum, C++23 preferred)
if(NOT DEFINED CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 20)
endif()

if(CMAKE_CXX_STANDARD LESS 20)
    message(WARNING "⚠ C++ Standard: ${CMAKE_CXX_STANDARD} is outdated")
    message(STATUS "  Minimum: C++20 (target release: 2026)")
    message(STATUS "  Recommended: C++23 for modern features")
else()
    message(STATUS "✓ C++ Standard: C++${CMAKE_CXX_STANDARD}")
endif()

# GCC Compiler check (MODERN: GCC 13+ recommended for C++23 support)
message(STATUS "✓ C++ Compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    compare_version("GCC" "${CMAKE_CXX_COMPILER_VERSION}" "${KNOWN_LATEST_GCC}")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "13.0")
        message(WARNING "⚠ GCC ${CMAKE_CXX_COMPILER_VERSION} is getting old")
        message(STATUS "  Recommended: GCC 13+ (full C++23 support)")
        message(STATUS "  Your version may lack modern C++ features")
    endif()
endif()

# Clang (optional alternative compiler)
find_program(CLANG_EXECUTABLE clang++)
if(CLANG_EXECUTABLE)
    execute_process(
        COMMAND ${CLANG_EXECUTABLE} --version
        OUTPUT_VARIABLE CLANG_VERSION_OUTPUT
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    string(REGEX MATCH "clang version ([0-9]+\\.[0-9]+\\.[0-9]+)" CLANG_VERSION_MATCH "${CLANG_VERSION_OUTPUT}")
    if(CMAKE_MATCH_1)
        message(STATUS "✓ Clang: ${CMAKE_MATCH_1} (alternative compiler)")
        compare_version("Clang" "${CMAKE_MATCH_1}" "${KNOWN_LATEST_CLANG}")
    endif()
else()
    message(STATUS "  Clang: NOT FOUND (optional)")
endif()

# Make/Ninja
find_program(MAKE_EXECUTABLE make)
if(MAKE_EXECUTABLE)
    message(STATUS "✓ Make: Found")
else()
    message(WARNING "⚠ Make: NOT FOUND")
endif()

find_program(NINJA_EXECUTABLE ninja)
if(NINJA_EXECUTABLE)
    message(STATUS "✓ Ninja: Found (optional)")
endif()

# pkg-config (useful for finding libraries)
find_program(PKG_CONFIG_EXECUTABLE pkg-config)
if(PKG_CONFIG_EXECUTABLE)
    message(STATUS "✓ pkg-config: Found")
else()
    message(WARNING "⚠ pkg-config: NOT FOUND (helpful for library detection)")
endif()

# Git
find_program(GIT_EXECUTABLE git)
if(GIT_EXECUTABLE)
    message(STATUS "✓ Git: Found")
else()
    message(WARNING "⚠ Git: NOT FOUND (needed for version control)")
endif()

# ============================================================================
# Python 3 (SCRIPTING AND BUILD TOOLS)
# ============================================================================
# PURPOSE: Scripting language for build scripts and code generation
# USED FOR: OpenXR SDK code generation, build automation, development tools
# python3-dev: Required for building Python C/C++ extensions
# ============================================================================
message(STATUS "")
message(STATUS "--- Python 3 ---")

# Step 1: Find Python interpreter
find_package(Python3 COMPONENTS Interpreter QUIET)

if(Python3_FOUND)
    message(STATUS "✓ Python: ${Python3_VERSION}")
    compare_version("Python" "${Python3_VERSION}" "${KNOWN_LATEST_PYTHON}")

    # Step 2: Check interpreter path
    if(Python3_EXECUTABLE)
        message(STATUS "  ✓ Interpreter: ${Python3_EXECUTABLE}")
    endif()

    # Step 3: Check for python3-dev headers (CRITICAL for C extensions)
    if(UNIX AND NOT APPLE AND DPKG_EXECUTABLE)
        execute_process(
            COMMAND ${DPKG_EXECUTABLE} -l python3-dev
            OUTPUT_VARIABLE PYTHON_DEV_CHECK
            ERROR_QUIET
        )
        string(FIND "${PYTHON_DEV_CHECK}" "ii  python3-dev" PYTHON_DEV_PKG)

        if(NOT PYTHON_DEV_PKG EQUAL -1)
            message(STATUS "  ✓ Package: python3-dev (headers for C extensions)")
        else()
            message(WARNING "  ⚠ Package: python3-dev NOT FOUND")
            message(STATUS "    Required for building Python C extensions")
            message(STATUS "    Install: sudo apt install python3-dev")
            set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - python3-dev needed for C extensions")
        endif()
    endif()

    # Step 4: Check for pip
    find_program(PIP_EXECUTABLE pip3)
    if(PIP_EXECUTABLE)
        message(STATUS "  ✓ pip3: ${PIP_EXECUTABLE}")
    else()
        message(STATUS "    pip3: Not found")
        message(STATUS "    Install: sudo apt install python3-pip")
    endif()

    # Step 5: Verify Python.h header (if dev package check wasn't done)
    if(NOT UNIX OR APPLE)
        find_path(PYTHON_INCLUDE_DIR Python.h
            HINTS ${Python3_INCLUDE_DIRS}
            PATH_SUFFIXES python${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}
        )

        if(PYTHON_INCLUDE_DIR)
            message(STATUS "  ✓ Python.h: Found")
        else()
            message(WARNING "  ⚠ Python.h: NOT FOUND (install development headers)")
        endif()
    endif()
else()
    message(WARNING "⚠ Python 3: NOT FOUND")
    message(STATUS "")
    message(STATUS "  Install: sudo apt install python3 python3-dev python3-pip")
    message(STATUS "")
    set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - Python 3 required for build scripts")
endif()

# ============================================================================
# Linux System Libraries (OpenXR Requirements)
# ============================================================================
if(UNIX AND NOT APPLE)
    message(STATUS "")
    message(STATUS "--- Linux System Libraries (OpenXR/Graphics) ---")

    # Function to check if a library package is installed (Debian/Ubuntu)
    function(check_debian_package PACKAGE_NAME DESCRIPTION)
        find_program(DPKG_EXECUTABLE dpkg)
        if(DPKG_EXECUTABLE)
            execute_process(
                COMMAND ${DPKG_EXECUTABLE} -l ${PACKAGE_NAME}
                OUTPUT_VARIABLE DPKG_OUTPUT
                ERROR_QUIET
                OUTPUT_STRIP_TRAILING_WHITESPACE
            )
            string(FIND "${DPKG_OUTPUT}" "ii  ${PACKAGE_NAME}" PKG_INSTALLED)
            if(NOT PKG_INSTALLED EQUAL -1)
                message(STATUS "✓ ${PACKAGE_NAME}: Installed")
            else()
                message(STATUS "✗ ${PACKAGE_NAME}: NOT INSTALLED")
                set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - ${DESCRIPTION} (${PACKAGE_NAME})" PARENT_SCOPE)
            endif()
        endif()
    endfunction()

    # Mesa/OpenGL packages
    check_debian_package("libgl1-mesa-dev" "OpenGL development files")
    check_debian_package("mesa-common-dev" "Mesa common development files")

    # X11/XCB packages (required for OpenXR on Linux)
    check_debian_package("libx11-xcb-dev" "X11-XCB development files")
    check_debian_package("libxcb-dri2-0-dev" "XCB DRI2 development files")
    check_debian_package("libxcb-glx0-dev" "XCB GLX development files")
    check_debian_package("libxcb-icccm4-dev" "XCB ICCCM development files")
    check_debian_package("libxcb-keysyms1-dev" "XCB keysyms development files")
    check_debian_package("libxcb-randr0-dev" "XCB RandR development files")
    check_debian_package("libxrandr-dev" "XRandR development files")
    check_debian_package("libxxf86vm-dev" "XXF86VM development files")

    # Vulkan
    check_debian_package("libvulkan-dev" "Vulkan development files")

endif()

# ============================================================================
# Qt6 Framework (CRITICAL DEPENDENCY)
# ============================================================================
# PURPOSE: Cross-platform UI framework and application foundation
# USED FOR: QML interface, 3D rendering (Qt Quick 3D), spatial audio, widgets
# REQUIRED: This is the main application framework - cannot build without it
# ============================================================================
message(STATUS "")
message(STATUS "--- Qt6 Framework ---")

# Step 1: Check CMAKE_PREFIX_PATH
if(CMAKE_PREFIX_PATH)
    message(STATUS "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
else()
    message(WARNING "⚠ CMAKE_PREFIX_PATH not set - Qt6 may not be found")
    message(STATUS "  Set with: -DCMAKE_PREFIX_PATH=/path/to/Qt/6.10.1/gcc_64")
endif()

# Step 2: Find Qt6 Core package
find_package(Qt6 QUIET COMPONENTS Core)
if(Qt6_FOUND)
    message(STATUS "✓ Qt6 Core: ${Qt6_VERSION}")
    compare_version("Qt6" "${Qt6_VERSION}" "${KNOWN_LATEST_QT}")

    # Step 3: Version validation
    if(Qt6_VERSION VERSION_LESS "6.10.0")
        message(WARNING "  ⚠ Version: ${Qt6_VERSION} is below recommended 6.10+")
        message(STATUS "    You may be using system Qt instead of custom installation")
        set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - Qt ${Qt6_VERSION} < 6.10 (upgrade recommended)")
    else()
        message(STATUS "  ✓ Version: ${Qt6_VERSION} meets requirements")
    endif()

    # Step 4: Check installation location
    if(Qt6_DIR)
        message(STATUS "  ✓ Location: ${Qt6_DIR}")

        # Warn if using system Qt
        string(FIND "${Qt6_DIR}" "/usr/lib" SYSTEM_QT_FOUND)
        if(NOT SYSTEM_QT_FOUND EQUAL -1)
            message(WARNING "  ⚠ Using system Qt from /usr/lib (may be outdated)")
        endif()
    endif()

    # Step 5: Check required components with validation
    set(QT_CRITICAL_COMPONENTS Core Gui Widgets Quick Quick3D Qml SpatialAudio)
    set(QT_MISSING_COMPONENTS "")

    foreach(COMPONENT ${QT_CRITICAL_COMPONENTS})
        find_package(Qt6 QUIET COMPONENTS ${COMPONENT})
        if(Qt6${COMPONENT}_FOUND)
            message(STATUS "  ✓ Component: Qt6${COMPONENT}")

            # Check include directory for this component
            if(DEFINED Qt6${COMPONENT}_INCLUDE_DIRS AND EXISTS "${Qt6${COMPONENT}_INCLUDE_DIRS}")
                # Silently validated
            else()
                message(WARNING "    ⚠ Include dir missing for Qt6${COMPONENT}")
            endif()
        else()
            message(WARNING "  ✗ Component: Qt6${COMPONENT} NOT FOUND")
            list(APPEND QT_MISSING_COMPONENTS ${COMPONENT})
        endif()
    endforeach()

    # Step 6: Fatal if critical components missing
    if(QT_MISSING_COMPONENTS)
        list(LENGTH QT_MISSING_COMPONENTS MISSING_COUNT)
        message(FATAL_ERROR "Qt6: Missing ${MISSING_COUNT} critical components")
        message(STATUS "  Missing: ${QT_MISSING_COMPONENTS}")
        message(STATUS "  Install complete Qt6 6.10+ from qt.io")
        set(DEPENDENCY_CHECK_FAILED TRUE)
    endif()

    # Step 7: Check QML plugin path (important for runtime)
    if(DEFINED QT_PLUGIN_PATH OR DEFINED QT_QML_PATH)
        message(STATUS "  ✓ Qt paths configured")
    else()
        message(STATUS "    Qt runtime paths: Will use Qt6_DIR defaults")
    endif()

else()
    message(FATAL_ERROR "✗ Qt6: NOT FOUND")
    message(STATUS "")
    message(STATUS "Qt6 is REQUIRED for this project.")
    message(STATUS "")
    message(STATUS "Install Qt 6.10+ from: https://www.qt.io/download")
    message(STATUS "Then configure with:")
    message(STATUS "  cmake -DCMAKE_PREFIX_PATH=/path/to/Qt/6.10.1/gcc_64 ...")
    message(STATUS "")
    set(DEPENDENCY_CHECK_FAILED TRUE)
    set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - Qt6 is REQUIRED")
endif()

# ============================================================================
# OpenGL/Mesa (GRAPHICS RENDERING)
# ============================================================================
# PURPOSE: Cross-platform graphics API for 2D/3D rendering
# USED FOR: Fallback rendering when Vulkan unavailable, OpenGL ES for compatibility
# MESA: Open-source Linux implementation with AMD/Intel/NVIDIA drivers
# ============================================================================
message(STATUS "")
message(STATUS "--- OpenGL/Mesa ---")

# Step 1: Find OpenGL package
find_package(OpenGL QUIET)
set(OPENGL_DETECTED FALSE)

if(OpenGL_FOUND)
    message(STATUS "✓ OpenGL: Found")
    set(OPENGL_DETECTED TRUE)

    # Step 2: Check include directory
    if(OPENGL_INCLUDE_DIR AND EXISTS "${OPENGL_INCLUDE_DIR}")
        message(STATUS "  ✓ Include dir: ${OPENGL_INCLUDE_DIR}")
    else()
        message(STATUS "    Include dir: Using system default")
    endif()

    # Step 3: Verify GL headers exist
    set(GL_HEADER_LOCATIONS
        "/usr/include/GL/gl.h"
        "/usr/local/include/GL/gl.h"
        "${OPENGL_INCLUDE_DIR}/GL/gl.h"
    )

    set(GL_HEADER_FOUND FALSE)
    foreach(GL_HEADER ${GL_HEADER_LOCATIONS})
        if(EXISTS "${GL_HEADER}")
            message(STATUS "  ✓ gl.h: ${GL_HEADER}")
            set(GL_HEADER_FOUND TRUE)
            break()
        endif()
    endforeach()

    if(NOT GL_HEADER_FOUND)
        message(WARNING "  ⚠ gl.h: NOT FOUND in standard locations")
    endif()

    # Step 4: Check Mesa packages (Linux)
    if(UNIX AND NOT APPLE AND DPKG_EXECUTABLE)
        execute_process(
            COMMAND ${DPKG_EXECUTABLE} -l libgl1-mesa-dev mesa-common-dev
            OUTPUT_VARIABLE MESA_PKG_CHECK
            ERROR_QUIET
        )

        string(FIND "${MESA_PKG_CHECK}" "ii  libgl1-mesa-dev" MESA_GL_PKG)
        string(FIND "${MESA_PKG_CHECK}" "ii  mesa-common-dev" MESA_COMMON_PKG)

        if(NOT MESA_GL_PKG EQUAL -1)
            message(STATUS "  ✓ Package: libgl1-mesa-dev")
        else()
            message(STATUS "    Package: libgl1-mesa-dev not installed")
        endif()

        if(NOT MESA_COMMON_PKG EQUAL -1)
            message(STATUS "  ✓ Package: mesa-common-dev")
        else()
            message(STATUS "    Package: mesa-common-dev not installed")
        endif()
    endif()

    # Step 5: Check OpenGL library
    if(OPENGL_gl_LIBRARY AND EXISTS "${OPENGL_gl_LIBRARY}")
        message(STATUS "  ✓ Library: ${OPENGL_gl_LIBRARY}")
    elseif(OPENGL_LIBRARIES)
        message(STATUS "  ✓ Libraries: Found")
    else()
        message(WARNING "  ⚠ OpenGL library path not set")
    endif()
else()
    message(WARNING "✗ OpenGL: NOT FOUND")
    message(STATUS "")
    message(STATUS "  Install: sudo apt install libgl1-mesa-dev mesa-common-dev")
    message(STATUS "")
    set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - OpenGL is required for rendering")
endif()

# ============================================================================
# Vulkan SDK (LOCATION-AGNOSTIC CHECK)
# ============================================================================
# PURPOSE: Modern high-performance graphics API for GPU rendering
# USED FOR: VR rendering, 3D scene rendering, GPU-accelerated effects
# ALTERNATIVES: OpenGL (legacy), DirectX (Windows only)
# ============================================================================
message(STATUS "")
message(STATUS "--- Vulkan SDK ---")

# Try CMake's FindVulkan first
find_package(Vulkan QUIET)

set(VULKAN_DETECTED FALSE)
set(VULKAN_HEADER_PATH "")
set(VULKAN_LIB_PATH "")

# Method 1: CMake found it
if(Vulkan_FOUND AND DEFINED Vulkan_INCLUDE_DIR)
    set(VULKAN_DETECTED TRUE)
    set(VULKAN_HEADER_PATH "${Vulkan_INCLUDE_DIR}")
    if(DEFINED Vulkan_LIBRARY)
        set(VULKAN_LIB_PATH "${Vulkan_LIBRARY}")
    endif()
    message(STATUS "✓ Vulkan SDK: ${Vulkan_VERSION} (via FindVulkan)")
endif()

# Method 2: Manual search if CMake didn't find it
if(NOT VULKAN_DETECTED)
    # Check common header locations
    set(VULKAN_SEARCH_PATHS
        "/usr/include"
        "/usr/local/include"
        "$ENV{HOME}/VulkanSDK/*/x86_64/include"
        "$ENV{VULKAN_SDK}/include"
    )

    foreach(SEARCH_PATH ${VULKAN_SEARCH_PATHS})
        file(GLOB VULKAN_CANDIDATES "${SEARCH_PATH}/vulkan/vulkan.h")
        if(VULKAN_CANDIDATES)
            list(GET VULKAN_CANDIDATES 0 FIRST_MATCH)
            get_filename_component(VULKAN_HEADER_PATH "${FIRST_MATCH}" DIRECTORY)
            get_filename_component(VULKAN_HEADER_PATH "${VULKAN_HEADER_PATH}" DIRECTORY)
            set(VULKAN_DETECTED TRUE)
            message(STATUS "✓ Vulkan headers: Found at ${VULKAN_HEADER_PATH}")
            break()
        endif()
    endforeach()

    # Check for library
    if(VULKAN_DETECTED)
        set(VULKAN_LIB_SEARCH_PATHS
            "/usr/lib/x86_64-linux-gnu"
            "/usr/lib"
            "/usr/local/lib"
            "${VULKAN_HEADER_PATH}/../lib"
        )

        foreach(LIB_PATH ${VULKAN_LIB_SEARCH_PATHS})
            if(EXISTS "${LIB_PATH}/libvulkan.so")
                set(VULKAN_LIB_PATH "${LIB_PATH}/libvulkan.so")
                break()
            endif()
        endforeach()
    endif()
endif()

# Report findings
if(VULKAN_DETECTED)
    message(STATUS "  ✓ Headers: ${VULKAN_HEADER_PATH}/vulkan/")

    # Validate header file exists
    if(EXISTS "${VULKAN_HEADER_PATH}/vulkan/vulkan.h")
        message(STATUS "  ✓ vulkan.h: Verified")
    else()
        message(WARNING "  ⚠ vulkan.h: NOT FOUND at expected location")
    endif()

    # Check library
    if(VULKAN_LIB_PATH)
        message(STATUS "  ✓ Library: ${VULKAN_LIB_PATH}")
    else()
        message(STATUS "    Library: Not found (headers-only install)")
    endif()

    # Check packages (Debian/Ubuntu)
    if(UNIX AND NOT APPLE AND DPKG_EXECUTABLE)
        execute_process(
            COMMAND ${DPKG_EXECUTABLE} -l vulkan-headers libvulkan-dev
            OUTPUT_VARIABLE VULKAN_PKG_CHECK
            ERROR_QUIET
        )
        string(FIND "${VULKAN_PKG_CHECK}" "ii  vulkan-headers" HDR_PKG)
        string(FIND "${VULKAN_PKG_CHECK}" "ii  libvulkan-dev" DEV_PKG)

        if(NOT HDR_PKG EQUAL -1)
            message(STATUS "  ✓ Package: vulkan-headers")
        endif()
        if(NOT DEV_PKG EQUAL -1)
            message(STATUS "  ✓ Package: libvulkan-dev")
        endif()
    endif()

    # Check GLSL compiler
    find_program(GLSLC_EXECUTABLE glslc)
    if(GLSLC_EXECUTABLE)
        message(STATUS "  ✓ GLSL compiler: ${GLSLC_EXECUTABLE}")
    else()
        message(STATUS "    GLSL compiler: Not found (optional)")
    endif()
else()
    message(WARNING "⚠ Vulkan SDK: NOT FOUND")
    message(STATUS "")
    message(STATUS "  Searched in:")
    message(STATUS "    - System: /usr/include, /usr/lib")
    message(STATUS "    - LunarG: ~/VulkanSDK")
    message(STATUS "    - Custom: $VULKAN_SDK")
    message(STATUS "")
    message(STATUS "  Install options:")
    message(STATUS "    1. System: sudo apt install libvulkan-dev vulkan-headers")
    message(STATUS "    2. LunarG SDK: https://vulkan.lunarg.com/sdk/home")
    message(STATUS "")
    set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - Vulkan SDK recommended for graphics")
endif()

# Check for header files directly
check_header("vulkan/vulkan.h" "Vulkan Headers")
check_header("GL/gl.h" "OpenGL Headers")

# CUDA (optional, for GPU acceleration)
find_package(CUDA QUIET)
if(CUDA_FOUND)
    message(STATUS "✓ CUDA Toolkit: ${CUDA_VERSION}")
else()
    message(STATUS "  CUDA: NOT FOUND (optional, for GPU acceleration)")
endif()

# ----------------------------------------------------------------------------
# FFmpeg (Video/Audio Processing)
# ----------------------------------------------------------------------------
# PURPOSE: Multimedia framework for video/audio encoding/decoding
# USED FOR: Video capture, encoding, streaming, format conversion
# LIBRARIES: libavcodec (codecs), libavformat (containers), libswscale (scaling)
# ----------------------------------------------------------------------------
if(UNIX AND NOT APPLE)
    if(DPKG_EXECUTABLE)
        check_debian_package("libavcodec-dev" "FFmpeg codec development files")
        check_debian_package("libavformat-dev" "FFmpeg format development files")
        check_debian_package("libavutil-dev" "FFmpeg util development files")
        check_debian_package("libswscale-dev" "FFmpeg swscale development files")
    endif()
endif()

# ============================================================================
# OpenXR (VR/AR Framework)
# ============================================================================
# PURPOSE: Cross-platform VR/AR API standard by Khronos Group
# USED FOR: VR headset integration, motion tracking, spatial rendering
# AUTO-DOWNLOADED: Fetched via CMake FetchContent if not found
# ============================================================================
message(STATUS "")
message(STATUS "--- OpenXR (VR/AR) ---")

# Check for OpenXR in build directory (FetchContent)
if(EXISTS "${CMAKE_BINARY_DIR}/_deps/openxr-src")
    message(STATUS "✓ OpenXR: Downloaded via FetchContent")
elseif(EXISTS "${CMAKE_SOURCE_DIR}/_deps/openxr-sdk-src")
    message(STATUS "✓ OpenXR: Found in source tree")
else()
    find_package(OpenXR QUIET)
    if(OpenXR_FOUND)
        message(STATUS "✓ OpenXR: System installation found")
    else()
        message(WARNING "⚠ OpenXR: Will be downloaded during build")
    endif()
endif()

# ============================================================================
# NVIDIA GPU DRIVERS & CUDA TOOLKIT
# ============================================================================
# PURPOSE: GPU acceleration, NVENC encoding, RTX features, ML inference
# USED FOR: Hardware video encoding, AI upscaling, GPU compute, deep learning
# COMPONENTS: NVIDIA driver, CUDA Toolkit, cuDNN (optional for ML)
# MODERN: CUDA 12.x, Driver 535+, Compute Capability 7.0+
# ============================================================================
message(STATUS "")
message(STATUS "--- NVIDIA GPU & CUDA ---")

set(NVIDIA_DETECTED FALSE)
set(CUDA_DETECTED FALSE)

# Step 1: Check NVIDIA Driver via nvidia-smi
find_program(NVIDIA_SMI nvidia-smi)
if(NVIDIA_SMI)
    execute_process(
        COMMAND ${NVIDIA_SMI} --query-gpu=driver_version --format=csv,noheader
        OUTPUT_VARIABLE NVIDIA_DRIVER_VERSION
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    if(NVIDIA_DRIVER_VERSION)
        set(NVIDIA_DETECTED TRUE)
        message(STATUS "✓ NVIDIA Driver: ${NVIDIA_DRIVER_VERSION}")

        # Get GPU name
        execute_process(
            COMMAND ${NVIDIA_SMI} --query-gpu=name --format=csv,noheader
            OUTPUT_VARIABLE NVIDIA_GPU_NAME
            ERROR_QUIET
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        if(NVIDIA_GPU_NAME)
            message(STATUS "  ✓ GPU: ${NVIDIA_GPU_NAME}")
        endif()

        # Check driver version (recommend 535+ for CUDA 12)
        string(REGEX MATCH "^([0-9]+)" NVIDIA_DRIVER_MAJOR "${NVIDIA_DRIVER_VERSION}")
        if(NVIDIA_DRIVER_MAJOR LESS 535)
            message(WARNING "  ⚠ Driver ${NVIDIA_DRIVER_VERSION} is old")
            message(STATUS "    Recommended: 535+ for CUDA 12.x support")
            message(STATUS "    Update: sudo ubuntu-drivers autoinstall")
        endif()
    endif()
else()
    message(WARNING "⚠ NVIDIA Driver: NOT FOUND")
    message(STATUS "  nvidia-smi not available (no NVIDIA GPU or drivers not installed)")
endif()

# Step 2: Check CUDA Toolkit
find_program(NVCC_EXECUTABLE nvcc)
if(NVCC_EXECUTABLE)
    execute_process(
        COMMAND ${NVCC_EXECUTABLE} --version
        OUTPUT_VARIABLE NVCC_VERSION_OUTPUT
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    string(REGEX MATCH "release ([0-9]+\\.[0-9]+)" _ "${NVCC_VERSION_OUTPUT}")
    if(CMAKE_MATCH_1)
        set(CUDA_VERSION "${CMAKE_MATCH_1}")
        set(CUDA_DETECTED TRUE)
        message(STATUS "✓ CUDA Toolkit: ${CUDA_VERSION}")

        # Check CUDA version (recommend 12.x)
        if(CUDA_VERSION VERSION_LESS "12.0")
            message(WARNING "  ⚠ CUDA ${CUDA_VERSION} is outdated")
            message(STATUS "    Recommended: CUDA 12.x for modern features")
        endif()
    endif()

    # Step 3: Check CUDA installation path
    get_filename_component(CUDA_BIN_DIR "${NVCC_EXECUTABLE}" DIRECTORY)
    get_filename_component(CUDA_ROOT_DIR "${CUDA_BIN_DIR}" DIRECTORY)

    if(EXISTS "${CUDA_ROOT_DIR}/include/cuda.h")
        message(STATUS "  ✓ CUDA headers: ${CUDA_ROOT_DIR}/include")
    else()
        message(WARNING "  ⚠ CUDA headers not found at ${CUDA_ROOT_DIR}/include")
    endif()

    # Step 4: Check for CUDA libraries
    find_library(CUDA_CUDART_LIBRARY cudart
        PATHS ${CUDA_ROOT_DIR}/lib64 ${CUDA_ROOT_DIR}/lib
        NO_DEFAULT_PATH
    )

    if(CUDA_CUDART_LIBRARY)
        message(STATUS "  ✓ CUDA runtime: ${CUDA_CUDART_LIBRARY}")
    else()
        message(WARNING "  ⚠ CUDA runtime library not found")
    endif()

    # Step 5: Check compute capability (for RTX features)
    if(NVIDIA_DETECTED)
        execute_process(
            COMMAND ${NVIDIA_SMI} --query-gpu=compute_cap --format=csv,noheader
            OUTPUT_VARIABLE COMPUTE_CAPABILITY
            ERROR_QUIET
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )

        if(COMPUTE_CAPABILITY)
            message(STATUS "  ✓ Compute Capability: ${COMPUTE_CAPABILITY}")

            # RTX features need compute capability 7.0+ (Turing/Ampere/Ada)
            if(COMPUTE_CAPABILITY VERSION_LESS "7.0")
                message(WARNING "  ⚠ Compute capability ${COMPUTE_CAPABILITY} too old for RTX")
                message(STATUS "    RTX features require 7.0+ (Turing architecture or newer)")
            endif()
        endif()
    endif()
else()
    message(WARNING "⚠ CUDA Toolkit: NOT FOUND")
    message(STATUS "")
    message(STATUS "  CUDA is needed for:")
    message(STATUS "    - NVENC hardware video encoding")
    message(STATUS "    - RTX AI upscaling features")
    message(STATUS "    - GPU-accelerated ML inference")
    message(STATUS "")
    message(STATUS "  Install:")
    message(STATUS "    1. Check your CUDA version: nvcc --version")
    message(STATUS "    2. Download from: https://developer.download.nvidia.com/compute/cuda/repos/")
    message(STATUS "    3. Choose repo matching YOUR Ubuntu version (e.g., ubuntu2404)")
    message(STATUS "    4. Install:")
    message(STATUS "       wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu(VERSION)/x86_64/cuda-keyring_1.1-1_all.deb")
    message(STATUS "       sudo dpkg -i cuda-keyring_1.1-1_all.deb")
    message(STATUS "       sudo apt update")
    message(STATUS "       sudo apt install cuda-toolkit-{VERSION}-{MINOR}  # Match YOUR GPU's capability")
    message(STATUS "")
    set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - CUDA Toolkit recommended for GPU acceleration")
endif()

# Step 6: Check cuDNN (optional, for ML workloads)
find_path(CUDNN_INCLUDE_DIR cudnn.h
    PATHS /usr/include /usr/local/cuda/include ${CUDA_ROOT_DIR}/include
    PATH_SUFFIXES cudnn
)

if(CUDNN_INCLUDE_DIR)
    message(STATUS "✓ cuDNN: Found at ${CUDNN_INCLUDE_DIR}")

    # Try to get cuDNN version
    if(EXISTS "${CUDNN_INCLUDE_DIR}/cudnn_version.h")
        file(READ "${CUDNN_INCLUDE_DIR}/cudnn_version.h" CUDNN_VERSION_CONTENT)
        string(REGEX MATCH "CUDNN_MAJOR ([0-9]+)" _ "${CUDNN_VERSION_CONTENT}")
        if(CMAKE_MATCH_1)
            message(STATUS "  ✓ cuDNN version: ${CMAKE_MATCH_1}.x")
        endif()
    endif()
else()
    message(STATUS "  cuDNN: Not found (optional for ML acceleration)")
    message(STATUS "")
    message(STATUS "  cuDNN accelerates deep learning operations:")
    message(STATUS "    - Faster neural network inference")
    message(STATUS "    - Optimized CNN/RNN operations")
    message(STATUS "    - Used by ONNX Runtime, TensorFlow, PyTorch")
    message(STATUS "")
    message(STATUS "  ⚠ NOTE: This is for C++ development, NOT Python!")
    message(STATUS "  (Don't use 'pip install cudnn' - you need native libraries)")
    message(STATUS "")
    message(STATUS "  Install cuDNN C++ Libraries:")
    message(STATUS "    1. Check YOUR installed CUDA version: nvcc --version")
    message(STATUS "    2. Download from: https://developer.nvidia.com/cudnn")
    message(STATUS "    3. Choose: cuDNN version MATCHING YOUR CUDA (e.g., cuDNN 9.x for CUDA 12.x)")
    message(STATUS "    4. Extract: tar -xvf cudnn-linux-x86_64-*-archive.tar.xz")
    message(STATUS "    5. Install:")
    message(STATUS "       sudo cp cudnn-*/include/cudnn*.h /usr/local/cuda/include")
    message(STATUS "       sudo cp cudnn-*/lib/libcudnn* /usr/local/cuda/lib64")
    message(STATUS "       sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*")
    message(STATUS "")
endif()

# Step 7: Check TensorRT (optional, for optimized ML inference)
find_path(TENSORRT_INCLUDE_DIR NvInfer.h
    PATHS /usr/include /usr/local/include /opt/tensorrt/include
    PATH_SUFFIXES tensorrt x86_64-linux-gnu
)

if(TENSORRT_INCLUDE_DIR)
    message(STATUS "✓ TensorRT: Found at ${TENSORRT_INCLUDE_DIR}")

    # Try to get TensorRT version
    if(EXISTS "${TENSORRT_INCLUDE_DIR}/NvInferVersion.h")
        file(READ "${TENSORRT_INCLUDE_DIR}/NvInferVersion.h" TENSORRT_VERSION_CONTENT)
        string(REGEX MATCH "NV_TENSORRT_MAJOR ([0-9]+)" _ "${TENSORRT_VERSION_CONTENT}")
        if(CMAKE_MATCH_1)
            message(STATUS "  ✓ TensorRT version: ${CMAKE_MATCH_1}.x")
        endif()
    endif()
else()
    message(STATUS "  TensorRT: Not found (optional for optimized ML)")
    message(STATUS "")
    message(STATUS "  TensorRT provides fastest AI inference:")
    message(STATUS "    - 5-10x faster than CPU inference")
    message(STATUS "    - GPU-optimized neural networks")
    message(STATUS "    - INT8/FP16 precision optimizations")
    message(STATUS "")
    message(STATUS "  ⚠ NOTE: This is for C++ development, NOT Python!")
    message(STATUS "  (Don't use 'pip install tensorrt' - you need native C++ API)")
    message(STATUS "")
    message(STATUS "  Install TensorRT C++ Runtime:")
    message(STATUS "    1. Check YOUR installed CUDA version: nvcc --version")
    message(STATUS "    2. Download from: https://developer.nvidia.com/tensorrt")
    message(STATUS "    3. Choose: TensorRT version MATCHING YOUR CUDA (e.g., TRT 10.x for CUDA 12.x)")
    message(STATUS "    4. Either:")
    message(STATUS "       A) Debian package (recommended):")
    message(STATUS "          sudo dpkg -i nv-tensorrt-local-repo-*.deb")
    message(STATUS "          sudo cp /var/nv-tensorrt-local-repo-*/nv-*-keyring.gpg /usr/share/keyrings/")
    message(STATUS "          sudo apt update")
    message(STATUS "          sudo apt install tensorrt")
    message(STATUS "")
    message(STATUS "       B) Tar archive:")
    message(STATUS "          tar -xvf TensorRT-*.tar.gz")
    message(STATUS "          export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HOME/TensorRT-*/lib")
    message(STATUS "")
endif()

# Summary
if(NVIDIA_DETECTED AND CUDA_DETECTED)
    message(STATUS "")
    message(STATUS "✓ GPU Acceleration: READY")
    message(STATUS "  NVIDIA Driver + CUDA Toolkit detected")
elseif(NVIDIA_DETECTED AND NOT CUDA_DETECTED)
    message(WARNING "⚠ GPU Acceleration: PARTIAL")
    message(STATUS "  NVIDIA driver found, but CUDA Toolkit missing")
elseif(NOT NVIDIA_DETECTED)
    message(STATUS "")
    message(STATUS "  GPU Acceleration: Disabled (no NVIDIA GPU detected)")
    message(STATUS "  Software fallback will be used")
endif()

# OpenXR Linux dependencies
if(UNIX AND NOT APPLE)
    check_header("X11/Xlib-xcb.h" "X11-XCB (OpenXR)")
    check_header("xcb/randr.h" "XCB RandR (OpenXR)")
endif()

# ============================================================================
# OpenUSD (Universal Scene Description)
# ============================================================================
# PURPOSE: Scene description framework by Pixar for 3D content pipelines
# USED FOR: USD scene import/export, 3D asset interchange, scene composition
# OPTIONAL: Only needed if working with USD scenes
# ============================================================================
message(STATUS "")
message(STATUS "--- OpenUSD (Universal Scene Description) ---")

find_package(pxr CONFIG QUIET)
if(pxr_FOUND)
    message(STATUS "✓ OpenUSD (pxr): ${PXR_VERSION}")
    if(PXR_INCLUDE_DIRS)
        message(STATUS "  Include: ${PXR_INCLUDE_DIRS}")
    endif()
    if(PXR_LIBRARIES)
        list(LENGTH PXR_LIBRARIES PXR_LIB_COUNT)
        message(STATUS "  Libraries: ${PXR_LIB_COUNT} USD libraries found")
    endif()
else()
    # Try custom finder
    find_path(OPENUSD_INCLUDE_DIR pxr/pxr.h
        HINTS $ENV{HOME}/USD /usr/local /opt/pixar /opt/usd
        PATH_SUFFIXES include)
    if(OPENUSD_INCLUDE_DIR)
        message(STATUS "✓ OpenUSD: Found at ${OPENUSD_INCLUDE_DIR}")

        # Check for USD library
        find_library(OPENUSD_LIBRARY NAMES usd_ms usd
            HINTS ${OPENUSD_INCLUDE_DIR}/../lib ${OPENUSD_INCLUDE_DIR}/../lib64)
        if(OPENUSD_LIBRARY)
            message(STATUS "  Library: ${OPENUSD_LIBRARY}")
        endif()
    else()
        message(WARNING "⚠ OpenUSD: NOT FOUND (optional, USD features disabled)")
        message(STATUS "  Searched in: $ENV{HOME}/USD, /usr/local, /opt/pixar")
        set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - OpenUSD is optional but recommended for scene description")
    endif()
endif()

# ----------------------------------------------------------------------------
# Intel TBB (Threading Building Blocks)
# ----------------------------------------------------------------------------
# PURPOSE: High-performance parallel programming library
# USED FOR: Required dependency for OpenUSD (multi-threaded operations)
# WHO NEEDS IT: OpenUSD cannot function without TBB
# ----------------------------------------------------------------------------
find_package(TBB QUIET)
if(TBB_FOUND)
    message(STATUS "✓ Intel TBB: Found (required by USD)")
else()
    if(pxr_FOUND OR OPENUSD_INCLUDE_DIR)
        message(WARNING "⚠ Intel TBB: NOT FOUND (required for USD)")
    endif()
endif()

# ============================================================================
# Audio
# ============================================================================
message(STATUS "")
message(STATUS "--- Audio Libraries ---")

find_package(Qt6 QUIET COMPONENTS SpatialAudio)
if(Qt6SpatialAudio_FOUND)
    message(STATUS "✓ Qt6 SpatialAudio")
else()
    message(WARNING "⚠ Qt6 SpatialAudio: NOT FOUND")
endif()

# ----------------------------------------------------------------------------
# ONNX Runtime (Machine Learning Inference)
# ----------------------------------------------------------------------------
# PURPOSE: High-performance ML model inference engine
# USED FOR: Running AI models (image/video proc, style transfer, upscaling)
# OPTIONAL: Only needed for ML-powered effects and nodes
# ----------------------------------------------------------------------------
message(STATUS "")
message(STATUS "--- ML/AI Frameworks ---")

# ONNX Runtime
find_path(ONNXRUNTIME_INCLUDE_DIR onnxruntime_cxx_api.h
    HINTS
    /usr/local/include
    /opt/onnxruntime/include
    $ENV{HOME}/onnxruntime/include
    PATH_SUFFIXES onnxruntime onnxruntime/core/session)

if(ONNXRUNTIME_INCLUDE_DIR)
    message(STATUS "✓ ONNX Runtime: Headers found at ${ONNXRUNTIME_INCLUDE_DIR}")

    # Try to find the library
    find_library(ONNXRUNTIME_LIBRARY NAMES onnxruntime
        HINTS
        ${ONNXRUNTIME_INCLUDE_DIR}/../lib
        ${ONNXRUNTIME_INCLUDE_DIR}/../../lib
        /usr/local/lib
        /opt/onnxruntime/lib
        PATH_SUFFIXES onnxruntime)

    if(ONNXRUNTIME_LIBRARY)
        message(STATUS "  Library: ${ONNXRUNTIME_LIBRARY}")
    else()
        message(WARNING "  ⚠ ONNX Runtime library not found (headers only)")
    endif()
else()
    message(WARNING "⚠ ONNX Runtime: NOT FOUND (optional, for ML node support)")
    set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - ONNX Runtime is optional for ML features")
endif()

# ----------------------------------------------------------------------------
# Emscripten (WebAssembly Compiler)
# ----------------------------------------------------------------------------
# PURPOSE: Compile C/C++ to WebAssembly for browser-based nodes
# USED FOR: WASM-based effects, web deployment, portable compute nodes
# OPTIONAL: Only needed if building WebAssembly components
# ----------------------------------------------------------------------------
find_program(EMSCRIPTEN emcc)
if(EMSCRIPTEN)
    execute_process(
        COMMAND ${EMSCRIPTEN} --version
        OUTPUT_VARIABLE EMCC_VERSION_OUTPUT
        ERROR_VARIABLE EMCC_VERSION_OUTPUT
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    string(REGEX MATCH "emcc \\(.*\\) ([0-9]+\\.[0-9]+\\.[0-9]+)" EMCC_VERSION_MATCH "${EMCC_VERSION_OUTPUT}")
    if(CMAKE_MATCH_1)
        message(STATUS "✓ Emscripten: ${CMAKE_MATCH_1}")
    else()
        message(STATUS "✓ Emscripten: Found at ${EMSCRIPTEN}")
    endif()

    # Check for wasm tools
    find_program(WASM_LD wasm-ld)
    if(WASM_LD)
        message(STATUS "  ✓ wasm-ld: Found")
    endif()
else()
    message(WARNING "⚠ Emscripten: NOT FOUND (optional, for WASM support)")
    set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - Emscripten needed for WebAssembly nodes")
endif()

# ==================================================================================================================================
# Rust Toolchain (OPTIONAL)
# ============================================================================
# PURPOSE: Systems programming language for performance-critical code
# USED FOR: High-performance modules, memory-safe alternatives to C++
# OPTIONAL: Only needed if building Rust-based components
# ============================================================================
message(STATUS "")
message(STATUS "--- Rust Toolchain (Optional) ---")

find_program(CARGO cargo)
find_program(RUSTC rustc)
find_program(RUSTUP rustup)

if(CARGO AND RUSTC)
    # Get Rust version
    execute_process(
        COMMAND ${RUSTC} --version
        OUTPUT_VARIABLE RUST_VERSION
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    message(STATUS "✓ Rust: ${RUST_VERSION}")

    # Get Cargo version
    execute_process(
        COMMAND ${CARGO} --version
        OUTPUT_VARIABLE CARGO_VERSION
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    message(STATUS "  Cargo: ${CARGO_VERSION}")

    # Check for wasm32 target (needed for WASM interop)
    if(RUSTUP)
        execute_process(
            COMMAND ${RUSTUP} target list --installed
            OUTPUT_VARIABLE RUSTUP_TARGETS
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        string(FIND "${RUSTUP_TARGETS}" "wasm32-unknown-unknown" WASM32_FOUND)
        if(NOT WASM32_FOUND EQUAL -1)
            message(STATUS "  ✓ wasm32-unknown-unknown target: Installed")
        else()
            message(STATUS "  ⚠ wasm32-unknown-unknown target: NOT INSTALLED")
            message(STATUS "    Install with: rustup target add wasm32-unknown-unknown")
        endif()
    endif()

    # Check for cargo-build (useful for integration)
    find_program(CARGO_BUILD cargo-build)
    if(CARGO_BUILD)
        message(STATUS "  ✓ cargo-build: Found")
    endif()
else()
    message(WARNING "⚠ Rust: NOT FOUND (optional, for Rust-based modules)")
    set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - Rust is optional for performance-critical modules")
endif()

# ============================================================================
# ObjectBox (STATE MANAGEMENT & DATABASE)
# ============================================================================
# PURPOSE: High-performance embedded database with object-graph persistence
# USED FOR: Application state management, local data storage, sync capabilities
# MODERN: Latest version 4.1.0 (2024), uses FlatBuffers for serialization
# ============================================================================
message(STATUS "")
message(STATUS "--- ObjectBox (State Management) ---")

set(OBJECTBOX_DETECTED FALSE)

# Method 1: Check if fetched via CMake FetchContent
if(TARGET objectbox)
    set(OBJECTBOX_DETECTED TRUE)
    message(STATUS "✓ ObjectBox: Available (FetchContent)")
elseif(EXISTS "${CMAKE_BINARY_DIR}/_deps/objectbox-src")
    set(OBJECTBOX_DETECTED TRUE)
    message(STATUS "✓ ObjectBox: Downloaded via FetchContent")
endif()

# Method 2: Check system installation
if(NOT OBJECTBOX_DETECTED)
    find_path(OBJECTBOX_INCLUDE_DIR objectbox.h
        PATHS /usr/local/include /usr/include
        PATH_SUFFIXES objectbox
    )

    if(OBJECTBOX_INCLUDE_DIR)
        set(OBJECTBOX_DETECTED TRUE)
        message(STATUS "✓ ObjectBox: Found at ${OBJECTBOX_INCLUDE_DIR}")
    endif()
endif()

# Validation if detected
if(OBJECTBOX_DETECTED)
    # Check for ObjectBox Generator
    find_program(OBJECTBOX_GENERATOR objectbox-generator)
    if(OBJECTBOX_GENERATOR)
        message(STATUS "  ✓ Generator: ${OBJECTBOX_GENERATOR}")
    else()
        message(STATUS "    Generator: Auto-downloads via CMake")
    endif()

    # Check FlatBuffers (used internally by ObjectBox)
    find_program(FLATC flatc)
    if(FLATC)
        message(STATUS "  ✓ FlatBuffers compiler: Found")
    else()
        message(STATUS "    FlatBuffers: Handled internally by ObjectBox")
    endif()

    # Verify C++ standard
    if(CMAKE_CXX_STANDARD LESS 11)
        message(WARNING "  ⚠ ObjectBox requires C++11 minimum")
        message(STATUS "    Current: C++${CMAKE_CXX_STANDARD}")
    else()
        message(STATUS "  ✓ C++ Standard: C++${CMAKE_CXX_STANDARD} (meets requirement)")
    endif()
else()
    message(WARNING "⚠ ObjectBox: NOT FOUND")
    message(STATUS "")
    message(STATUS "  Setup via CMake FetchContent:")
    message(STATUS "    FetchContent_Declare(objectbox")
    message(STATUS "        GIT_REPOSITORY https://github.com/objectbox/objectbox-c.git")
    message(STATUS "        GIT_TAG v4.1.0)")
    message(STATUS "    FetchContent_MakeAvailable(objectbox)")
    message(STATUS "")
    set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - ObjectBox required for state management")
endif()

# ============================================================================
# Summary
# ============================================================================
message(STATUS "")
message(STATUS "╔═══════════════════════════════════════════════════════════╗")
if(DEPENDENCY_CHECK_FAILED)
    message(STATUS "║     DEPENDENCY CHECK: FAILED                              ║")
    message(STATUS "╚═══════════════════════════════════════════════════════════╝")
    message(STATUS "")
    message(STATUS "Missing required dependencies:${DEPENDENCY_WARNINGS}")
    message(STATUS "")
    message(FATAL_ERROR "Please install missing dependencies before building.")
else()
    message(STATUS "║     DEPENDENCY CHECK: PASSED ✓                            ║")
    message(STATUS "╚═══════════════════════════════════════════════════════════╝")
    if(DEPENDENCY_WARNINGS)
        message(STATUS "")
        message(STATUS "Optional dependencies not found:${DEPENDENCY_WARNINGS}")
        message(STATUS "")
        message(STATUS "Build will continue, but some features may be disabled.")
    endif()
    message(STATUS "")
    message(STATUS "Proceeding with build configuration...")
endif()
message(STATUS "")
