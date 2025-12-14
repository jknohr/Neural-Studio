set(USD_MANAGER_SRCS
    UsdStageManager.cpp
    UsdStageManager.h
)

set(CMAKE_AUTOMOC ON)
find_package(Qt6 REQUIRED COMPONENTS Core)

add_library(neural_studio_usd_manager STATIC ${USD_MANAGER_SRCS})

# Standard Qt Libraries
target_link_libraries(neural_studio_usd_manager
    PUBLIC
    Qt6::Core
)

# USD Linkage - targets come from pxrConfig.cmake (without pxr:: prefix)
if(OpenUSD_FOUND)
    # Make USD includes PUBLIC so they propagate to dependent targets
    target_include_directories(neural_studio_usd_manager PUBLIC ${PXR_INCLUDE_DIRS})
    target_link_libraries(neural_studio_usd_manager
        PUBLIC # Changed to PUBLIC so linking targets get USD libs too
        usd # Core USD library
        usdGeom # Geometry schemas
    )
    target_compile_definitions(neural_studio_usd_manager PUBLIC NEURAL_STUDIO_USE_USD)
endif()

# Include directories
target_include_directories(neural_studio_usd_manager
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)
