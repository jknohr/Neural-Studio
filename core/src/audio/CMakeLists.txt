find_package(Qt6 REQUIRED COMPONENTS Core SpatialAudio)

project(neural_studio_audio)

set(AUDIO_SOURCES
    SpatialAudioManager.cpp
    SpatialAudioManager.h
)

add_library(neural_studio_audio STATIC ${AUDIO_SOURCES})

target_link_libraries(neural_studio_audio
    PUBLIC
    Qt6::Core
    Qt6::SpatialAudio
)

target_include_directories(neural_studio_audio
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/core/include
)
