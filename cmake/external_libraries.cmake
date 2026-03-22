# ==========================================================
# ADDITIONAL_LIBRARIES
# ==========================================================

set (JSONFORTRAN_ENABLE_TESTS OFF CACHE BOOL "" FORCE)
set (ENABLE_TESTS_ ENABLE_TESTS)
set (ENABLE_TESTS FALSE CACHE BOOL "" FORCE)
add_subdirectory(external_dependencies/json-fortran)
set (ENABLE_TESTS ENABLE_TESTS_)
