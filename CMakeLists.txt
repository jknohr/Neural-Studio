cmake_minimum_required(VERSION 3.28)

project(neural-studio VERSION 0.1.0 LANGUAGES C CXX)

# Standard Settings
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Add custom CMake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules")

# QML Language Server support (fixes qmllint import warnings)
set(QT_QML_GENERATE_QMLLS_INI ON)

# Modules
# Modules
add_subdirectory(core)
if(NOT DISABLE_UI)
    add_subdirectory(ui)
endif()
