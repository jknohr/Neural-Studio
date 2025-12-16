# Building Neural Studio - Dependency Analysis and Installation

**Version**: 1.0.0  
**Last Updated**: 2025-12-17

---

## Table of Contents

1. [Introduction to the Stack](#1-introduction-to-the-stack)
2. [Primary Files for the Build and Libraries](#2-primary-files-for-the-build-and-libraries)
3. [Git Ignore and VS Code Ignore](#3-git-ignore-and-vs-code-ignore)
4. [Git Actions Settings](#4-git-actions-settings)
5. [Ubuntu Dependencies and Drivers](#5-ubuntu-dependencies-and-drivers)
6. [CMake Presets Quick Reference](#6-cmake-presets-quick-reference)
7. [Quick Start](#7-quick-start)

---

## 1. Introduction to the Stack

Neural Studio is built on a modern C++20/Qt6 stack with support for:

| Technology | Purpose | Version |
|------------|---------|---------|
| **CMake** | Build system | 3.28+ |
| **Qt6** | UI framework, QML, Quick3D, SpatialAudio | 6.10+ |
| **OpenXR** | VR/AR runtime (auto-fetched) | 1.1.42 |
| **ObjectBox** | State management database (auto-fetched) | 0.21.0 |
| **nlohmann_json** | JSON parsing (auto-fetched) | 3.11.3 |
| **OpenUSD** | Scene description (optional) | 24.11 |
| **Vulkan** | GPU rendering | System |
| **CUDA** | GPU acceleration, NVENC | 12.x |
| **Corrosion** | Rust/CMake bridge (auto-fetched) | 0.5.2 |

### Build System Philosophy

1. **FetchContent First**: Core dependencies auto-download during configure
2. **System Libraries**: Graphics/drivers use system packages
3. **Feature Flags**: All major features toggled via `ENABLE_*` cache variables
4. **Presets**: Pre-configured builds for different use cases

---

## 2. Primary Files for the Build and Libraries

### CMake Modules

| File | Purpose |
|------|---------|
| [`cmake/modules/DependencyManager.cmake`](cmake/modules/DependencyManager.cmake) | **Core dependency fetching** - OpenXR, ObjectBox, nlohmann_json, Corrosion |
| [`cmake/modules/CheckDependencies.cmake`](cmake/modules/CheckDependencies.cmake) | **Validation** - Checks all deps are present with version info |
| [`cmake/modules/FindOpenUSD.cmake`](cmake/modules/FindOpenUSD.cmake) | Custom finder for OpenUSD/Pixar USD |
| [`cmake/modules/FindObjectBoxGenerator.cmake`](cmake/modules/FindObjectBoxGenerator.cmake) | ObjectBox code generator (auto-downloads) |

### Directory Structure

```
Neural-Studio/
├── CMakeLists.txt              # Main entry point
├── CMakePresets.json           # Build presets (ubuntu, release, ci, etc.)
├── cmake/modules/              # CMake finders and managers
├── core/                       # Backend C++ code
├── ui/                         # QML frontend
├── dependencies/               # Vendored and local dependencies
│   ├── blake2/                 # Hashing library
│   ├── glad/                   # OpenGL loader
│   ├── libcaption/             # Closed captioning
│   ├── rust/                   # Rust workspace (Cargo.toml)
│   └── mojo/                   # Future Mojo packages
└── build_ubuntu/               # Build output (Ninja)
    ├── _build_dependencies/    # FetchContent downloads
    ├── rust/                   # Rust build artifacts
    └── compile_commands.json   # For clangd/IDE
```

### Dependency Sources

| Category | Location | Managed By |
|----------|----------|------------|
| **Auto-fetched** | `build_*/_build_dependencies/` | `DependencyManager.cmake` via FetchContent |
| **Vendored** | `dependencies/` | Manual (legacy) |
| **Rust** | `dependencies/rust/` | Corrosion via `Cargo.toml` |
| **System** | `/usr/*`, `$HOME/Qt`, `$HOME/USD` | Package manager |

---

## 3. Git Ignore and VS Code Ignore

### `.gitignore` Key Entries

```gitignore
# Build directories
build*/
cmake-build-*/

# Auto-generated
compile_commands.json
*.autosave
*_autogen/

# IDE files
.vscode/
.idea/

# Rust artifacts (in repo, but build output ignored)
dependencies/rust/target/
```

### VS Code Settings

Key extensions:
- **clangd** (C++ language server)
- **CMake Tools** (build integration)
- **QML** (Qt language support)

> **Note**: Symlink `compile_commands.json` in project root to `build_ubuntu/compile_commands.json` for clangd.

---

## 4. Git Actions Settings

### CI Preset

The `ubuntu-ci` preset is designed for GitHub Actions:

```yaml
- name: Configure
  run: cmake --preset ubuntu-ci

- name: Build
  run: cmake --build --preset ubuntu-ci
```

CI Features:
- `CMAKE_COMPILE_WARNING_AS_ERROR`: Strict warnings
- `ENABLE_CCACHE`: Build caching
- `BUILD_FOR_DISTRIBUTION`: Release-ready

---

## 5. Ubuntu Dependencies and Drivers

### Quick Install (Ubuntu 24.04)

```bash
# Core build tools
sudo apt install build-essential cmake ninja-build git pkg-config

# Qt6 (from qt.io installer or)
sudo apt install qt6-base-dev qt6-declarative-dev qt6-quick3d-dev \
                 qt6-multimedia-dev qt6-spatial-audio-dev

# Graphics
sudo apt install libgl1-mesa-dev libvulkan-dev vulkan-headers

# X11/Wayland
sudo apt install libx11-xcb-dev libxcb-dri2-0-dev libxcb-glx0-dev \
                 libxcb-icccm4-dev libxcb-keysyms1-dev libxrandr-dev

# Audio
sudo apt install libasound2-dev libpulse-dev libpipewire-0.3-dev \
                 libjack-jackd2-dev

# FFmpeg
sudo apt install libavcodec-dev libavformat-dev libavutil-dev libswscale-dev

# Python (for build scripts)
sudo apt install python3 python3-dev python3-pip
```

### NVIDIA GPU (Optional)

```bash
# NVIDIA Driver 535+
sudo ubuntu-drivers autoinstall

# CUDA Toolkit 12.x
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt update
sudo apt install cuda-toolkit-12-6
```

### Qt6 (Recommended: Official Installer)

Download from [qt.io](https://www.qt.io/download-qt-installer) and install to `~/Qt/6.10.1/`.

The CMakePresets.json expects:
```
CMAKE_PREFIX_PATH = $HOME/Qt/6.10.1/gcc_64
```

### OpenUSD (Optional)

```bash
# Build from source
git clone https://github.com/PixarAnimationStudios/OpenUSD.git
cd OpenUSD
python3 build_scripts/build_usd.py ~/USD
```

The CMakePresets.json expects:
```
pxr_DIR = $HOME/USD
```

### Rust (Optional, for WASM plugins)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add wasm32-unknown-unknown
```

---

## 6. CMake Presets Quick Reference

| Preset | Use Case | Build Type |
|--------|----------|------------|
| `ubuntu` | **Development** - Full features, debug | Debug |
| `ubuntu-release` | Production distribution | Release |
| `ubuntu-relwithdebinfo` | Profiling | RelWithDebInfo |
| `ubuntu-ci` | GitHub Actions | RelWithDebInfo |
| `ubuntu-experimental` | Bleeding-edge (AV2, MoQ) | RelWithDebInfo |
| `ubuntu-legacy` | RTMP/SRT only, no WebTransport | Release |
| `ubuntu-minimal` | Lightweight UI only | Release |
| `ubuntu-headless` | Cloud server, no UI | Release |

### Key Feature Flags

| Flag | Default | Description |
|------|---------|-------------|
| `ENABLE_VR` | ON | VR/XR support |
| `ENABLE_WASM_PLUGINS` | ON | WebAssembly plugin runtime |
| `ENABLE_AI` | ON | AI/ML features |
| `ENABLE_OPENUSD` | ON | USD scene support |
| `ENABLE_WEBTRANSPORT` | ON | Modern streaming protocol |
| `ENABLE_8K_VR` | ON | 8K stereoscopic streaming |

---

## 7. Quick Start

```bash
# 1. Clone
git clone https://github.com/jknohr/Neural-Studio.git
cd Neural-Studio

# 2. Configure (fetches dependencies automatically)
cmake --preset ubuntu

# 3. Build
cmake --build --preset ubuntu

# 4. Run
./build_ubuntu/neural-studio
```

### Troubleshooting

| Issue | Solution |
|-------|----------|
| `Qt6 NOT FOUND` | Set `CMAKE_PREFIX_PATH` to Qt installation |
| `clangd errors` | Run `ln -s build_ubuntu/compile_commands.json .` |
| `OpenXR fetch fails` | Check internet, or set `ENABLE_OPENXR=OFF` |
| `CUDA not found` | Set `CUDAToolkit_ROOT=/usr/local/cuda` |