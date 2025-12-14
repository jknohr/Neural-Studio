# FindOpenUSD.cmake
# Finder for OpenUSD - supports both monolithic and modular builds

# Common installation locations including user home directory
set(_OPENUSD_SEARCH_PATHS
    $ENV{HOME}/USD
    /usr/local
    /opt/local
    /usr
    ${OPENUSD_ROOT_DIR}
)

find_path(OPENUSD_INCLUDE_DIR
    NAMES pxr/pxr.h
    PATHS ${_OPENUSD_SEARCH_PATHS}
    PATH_SUFFIXES include
)

# Try monolithic build first, then modular
find_library(OPENUSD_LIBRARY
    NAMES usd_ms usd libusd_usd usd_usd
    PATHS ${_OPENUSD_SEARCH_PATHS}
    PATH_SUFFIXES lib lib64
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(OpenUSD
    DEFAULT_MSG
    OPENUSD_LIBRARY OPENUSD_INCLUDE_DIR
)

if(OpenUSD_FOUND)
    set(OpenUSD_LIBRARIES ${OPENUSD_LIBRARY})
    set(OpenUSD_INCLUDE_DIRS ${OPENUSD_INCLUDE_DIR})

    # Get the library directory for finding additional USD libs
    get_filename_component(OPENUSD_LIBRARY_DIR ${OPENUSD_LIBRARY} DIRECTORY)

    if(NOT TARGET pxr::usd)
        add_library(pxr::usd UNKNOWN IMPORTED)
        set_target_properties(pxr::usd PROPERTIES
            IMPORTED_LOCATION "${OPENUSD_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${OPENUSD_INCLUDE_DIR}"
        )
    endif()
endif()
