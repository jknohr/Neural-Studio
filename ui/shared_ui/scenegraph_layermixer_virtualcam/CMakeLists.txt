
set(SCENEGRAPH_MIXER_UI_SRCS
    SceneGraphMixerController.cpp
    SceneGraphMixerController.h
)

add_library(scenegraph_mixer_ui STATIC ${SCENEGRAPH_MIXER_UI_SRCS})

target_link_libraries(scenegraph_mixer_ui
    PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Widgets
    Qt6::Quick3D
    Qt6::Quick3DXr
)
