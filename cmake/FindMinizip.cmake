# MINIZIP_FOUND       - Minizip library was found
# MINIZIP_INCLUDE_DIR - Path to Minizip include directory
# MINIZIP_LIBRARIES   - List of Minizip libraries
#
# Optional:
# MINIZIP_ROOT        - Minizip installation prefix

find_package(PkgConfig QUIET)

if(PkgConfig_FOUND)
    pkg_check_modules(PC_MINIZIP QUIET minizip)
endif()

find_path(
    MINIZIP_INCLUDE_DIR
    NAMES unzip.h
    HINTS ${PC_MINIZIP_INCLUDE_DIRS} ${MINIZIP_ROOT}
    ENV MINIZIP_ROOT
    PATH_SUFFIXES minizip
)

if(MINIZIP_INCLUDE_DIR AND NOT EXISTS "${MINIZIP_INCLUDE_DIR}/zip.h")
    unset(MINIZIP_INCLUDE_DIR CACHE)
    unset(MINIZIP_INCLUDE_DIR)
endif()

find_library(
    MINIZIP_LIBRARY
    NAMES minizip
    HINTS ${PC_MINIZIP_LIBRARY_DIRS} ${MINIZIP_ROOT}
    ENV MINIZIP_ROOT
    PATH_SUFFIXES lib lib64
)

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(
    Minizip
    REQUIRED_VARS MINIZIP_LIBRARY MINIZIP_INCLUDE_DIR
)

if(MINIZIP_FOUND)
    set(MINIZIP_LIBRARIES "${MINIZIP_LIBRARY}")
    set(MINIZIP_INCLUDE_DIRS "${MINIZIP_INCLUDE_DIR}")

    if(NOT TARGET Minizip::Minizip)
        add_library(Minizip::Minizip UNKNOWN IMPORTED)

        set_target_properties(
            Minizip::Minizip
            PROPERTIES
                IMPORTED_LOCATION "${MINIZIP_LIBRARY}"
                INTERFACE_INCLUDE_DIRECTORIES "${MINIZIP_INCLUDE_DIR}"
        )
    endif()
endif()

mark_as_advanced(MINIZIP_LIBRARY MINIZIP_INCLUDE_DIR)
