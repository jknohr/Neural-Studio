# Install script for directory: /home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/neural-studio/qml/managers" TYPE FILE FILES
    "/home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers/BaseManager.qml"
    "/home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers/CameraManager/CameraManager.qml"
    "/home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers/ThreeDAssetsManager/ThreeDAssetsManager.qml"
    "/home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers/VideoManager/VideoManager.qml"
    "/home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers/GraphicsManager/GraphicsManager.qml"
    "/home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers/AudioManager/AudioManager.qml"
    "/home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers/FontManager/FontManager.qml"
    "/home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers/ShaderManager/ShaderManager.qml"
    "/home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers/TextureManager/TextureManager.qml"
    "/home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers/EffectsManager/EffectsManager.qml"
    "/home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers/ScriptManager/ScriptManager.qml"
    "/home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers/MLManager/MLManager.qml"
    "/home/subtomic/Documents/GitHub/Neural-Studio/ui/shared_ui/managers/LLMManager/LLMManager.qml"
    )
endif()

