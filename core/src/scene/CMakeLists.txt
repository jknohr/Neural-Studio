# Scene Module (Spatial Scene Manager)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

set(SCENE_SOURCES
    SceneManager.cpp
    OBJLoader.cpp
)

set(SCENE_HEADERS
    SceneManager.h
)

find_package(Qt6 REQUIRED COMPONENTS Core Quick3D)

add_library(nstudio-scene STATIC
    ${SCENE_SOURCES}
    ${SCENE_HEADERS}
)

# Inherit USD includes from usd_manager
target_link_libraries(nstudio-scene
    PRIVATE
    Qt6::Core
    Qt6::Quick3D
    neural_studio_usd_manager
)

target_include_directories(nstudio-scene PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    $<TARGET_PROPERTY:neural_studio_usd_manager,INCLUDE_DIRECTORIES>
)
