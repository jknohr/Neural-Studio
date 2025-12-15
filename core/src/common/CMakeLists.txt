# Common Utilities Library

add_library(common STATIC
    IDGenerator.cpp
    IDGenerator.h
)

target_include_directories(common PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Optional: Build test executable
option(BUILD_ID_GENERATOR_TEST "Build ID generator test" OFF)

if(BUILD_ID_GENERATOR_TEST)
    add_executable(test_id_generator test_id_generator.cpp)
    target_link_libraries(test_id_generator PRIVATE common)
endif()
