# - Try to find fts headers and libraries for alpine linux 3.3
#
# Usage of this module as follows:
#
#     find_package(Fts)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  fts_ROOT_DIR         Set this variable to the root installation of
#                            fts if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  FTS_FOUND                   System has fts libraries and headers
#  fts_LIBRARY                 The fts library
#  fts_INCLUDE_DIR             The location of fts headers



find_path(fts_ROOT_DIR
    NAMES include/fts.h
)

find_library(fts_LIBRARY
    NAMES libfts.a fts
    HINTS ${fts_ROOT_DIR}/lib
)

find_path(fts_INCLUDE_DIR
    NAMES fts.h
    HINTS ${fts_ROOT_DIR}/include
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(fts DEFAULT_MSG
    fts_LIBRARY
    fts_INCLUDE_DIR
)

mark_as_advanced(
    fts_ROOT_DIR
    fts_LIBRARY
    fts_INCLUDE_DIR
)

