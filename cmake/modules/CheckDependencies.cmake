# ============================================================================
# Neural Studio - Dependency Verification Module
# ============================================================================
# This file checks all major dependencies before build.
# Safe to delete - project will build without this file.
#
# Usage:
#   Normal mode: include(CheckDependencies)
#   Show latest versions: cmake -DCHECK_LATEST_VERSIONS=ON ..
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

# Emscripten (if installed)
set(KNOWN_LATEST_EMSCRIPTEN "3.1.69")
# OpenUSD (if installed)
set(KNOWN_LATEST_USD "24.11")

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

# CMake version check
if(CMAKE_VERSION VERSION_LESS "3.16")
    message(STATUS "✗ CMake: ${CMAKE_VERSION} (required: 3.16+)")
    set(DEPENDENCY_CHECK_FAILED TRUE)
else()
    message(STATUS "✓ CMake: ${CMAKE_VERSION}")
    compare_version("CMake" "${CMAKE_VERSION}" "${KNOWN_LATEST_CMAKE}")
endif()

# C++ Standard check
if(CMAKE_CXX_STANDARD LESS 20)
    message(WARNING "⚠ C++ Standard: ${CMAKE_CXX_STANDARD} (recommended: 20)")
else()
    message(STATUS "✓ C++ Standard: ${CMAKE_CXX_STANDARD}")
endif()

# GCC Compiler check
message(STATUS "✓ C++ Compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    compare_version("GCC" "${CMAKE_CXX_COMPILER_VERSION}" "${KNOWN_LATEST_GCC}")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.0")
        message(WARNING "⚠ GCC version ${CMAKE_CXX_COMPILER_VERSION} is old (recommended: 9+)")
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

# Python
find_package(Python3 COMPONENTS Interpreter QUIET)
if(Python3_FOUND)
    message(STATUS "✓ Python: ${Python3_VERSION}")
    compare_version("Python" "${Python3_VERSION}" "${KNOWN_LATEST_PYTHON}")
else()
    message(WARNING "⚠ Python 3: NOT FOUND (required for OpenXR code generation)")
    set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - Python 3 required for OpenXR")
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
# Qt Framework
# ============================================================================
message(STATUS "")
message(STATUS "--- Qt Framework ---")

# First, check what's in CMAKE_PREFIX_PATH
if(CMAKE_PREFIX_PATH)
    message(STATUS "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
endif()

find_package(Qt6 QUIET COMPONENTS Core)
if(Qt6_FOUND)
    # Check Qt version - we need 6.10+
    compare_version("Qt6" "${Qt6_VERSION}" "${KNOWN_LATEST_QT}")

    if(Qt6_VERSION VERSION_LESS "6.10.0")
        message(WARNING "⚠ Qt6: Found version ${Qt6_VERSION} at ${Qt6_DIR}")
        message(WARNING "   Recommended: Qt 6.10+ for full feature support")
        message(WARNING "   This may be the system Qt instead of your custom installation")
        set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - Qt version ${Qt6_VERSION} is older than recommended (6.10+)")
    else()
        message(STATUS "✓ Qt6: ${Qt6_VERSION} at ${Qt6_DIR}")
    endif()

    # Verify it's from the expected location (not system Qt)
    string(FIND "${Qt6_DIR}" "/usr/lib" SYSTEM_QT_FOUND)
    if(NOT SYSTEM_QT_FOUND EQUAL -1)
        message(WARNING "⚠ Using SYSTEM Qt from /usr/lib instead of custom Qt installation")
        message(WARNING "   Set CMAKE_PREFIX_PATH to your Qt installation directory")
        set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - Using system Qt instead of modern Qt installation")
    endif()

    # Check for required Qt components
    set(QT_COMPONENTS Core Gui Widgets Quick Quick3D Qml SpatialAudio)
    foreach(COMPONENT ${QT_COMPONENTS})
        find_package(Qt6 QUIET COMPONENTS ${COMPONENT})
        if(Qt6${COMPONENT}_FOUND)
            message(STATUS "  ✓ Qt6${COMPONENT}")
        else()
            message(STATUS "  ✗ Qt6${COMPONENT}: NOT FOUND")
            set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - Qt6${COMPONENT} is missing")
        endif()
    endforeach()
else()
    message(STATUS "✗ Qt6: NOT FOUND")
    message(STATUS "   Please set CMAKE_PREFIX_PATH to your Qt installation")
    message(STATUS "   Example: -DCMAKE_PREFIX_PATH=/home/user/Qt/6.10.1/gcc_64")
    set(DEPENDENCY_CHECK_FAILED TRUE)
    set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - Qt6 is required (set CMAKE_PREFIX_PATH)")
endif()

# ============================================================================
# Graphics & Rendering
# ============================================================================
message(STATUS "")
message(STATUS "--- Graphics & Rendering ---")

# OpenGL
find_package(OpenGL QUIET)
if(OpenGL_FOUND)
    message(STATUS "✓ OpenGL: Found")
    if(OPENGL_INCLUDE_DIR)
        message(STATUS "  Include: ${OPENGL_INCLUDE_DIR}")
    endif()
else()
    message(STATUS "✗ OpenGL: NOT FOUND")
    set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - OpenGL is required for rendering")
endif()

# Vulkan SDK
find_package(Vulkan QUIET)
if(Vulkan_FOUND)
    message(STATUS "✓ Vulkan SDK: ${Vulkan_VERSION}")
    if(Vulkan_INCLUDE_DIRS)
        message(STATUS "  Include: ${Vulkan_INCLUDE_DIRS}")
    endif()
    if(Vulkan_LIBRARIES)
        message(STATUS "  Libraries: ${Vulkan_LIBRARIES}")
    endif()

    # Check for GLSL compiler
    if(Vulkan_GLSLC_EXECUTABLE)
        message(STATUS "  ✓ GLSL Compiler: ${Vulkan_GLSLC_EXECUTABLE}")
    else()
        message(WARNING "  ⚠ GLSL Compiler (glslc): NOT FOUND")
    endif()
else()
    message(WARNING "⚠ Vulkan SDK: NOT FOUND (optional but recommended)")
    set(DEPENDENCY_WARNINGS "${DEPENDENCY_WARNINGS}\n  - Vulkan SDK recommended for modern graphics")
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

# FFmpeg (for video processing)
if(UNIX AND NOT APPLE)
    if(DPKG_EXECUTABLE)
        check_debian_package("libavcodec-dev" "FFmpeg codec development files")
        check_debian_package("libavformat-dev" "FFmpeg format development files")
        check_debian_package("libavutil-dev" "FFmpeg util development files")
        check_debian_package("libswscale-dev" "FFmpeg swscale development files")
    endif()
endif()

# ============================================================================
# OpenXR (VR/AR)
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

# OpenXR Linux dependencies
if(UNIX AND NOT APPLE)
    check_header("X11/Xlib-xcb.h" "X11-XCB (OpenXR)")
    check_header("xcb/randr.h" "XCB RandR (OpenXR)")
endif()

# ============================================================================
# OpenUSD
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

# Check for TBB (required by USD)
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

# ============================================================================
# Machine Learning / AI
# ============================================================================
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

# WebAssembly (for WASM nodes)
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

# ============================================================================
# Rust (optional)
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
# ObjectBox (State Management)
# ============================================================================
message(STATUS "")
message(STATUS "--- State Management ---")

if(TARGET objectbox)
    message(STATUS "✓ ObjectBox: Available (FetchContent)")
else()
    message(WARNING "⚠ ObjectBox: Will be downloaded during build")
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
