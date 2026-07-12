# ==========================================================
# LIBRARY SYSTEM
# ==========================================================

set(LIBRARY_NAME "system")

set(SRC_FILES
  src/assert.f90
  src/imp/assert_impl.f90
  src/exception.f90
  src/imp/exception_impl.f90
  src/dynamic_array.f90
  src/imp/dynamic_array_impl.f90
)

include(../../../cmake/for_libraries/generate_library_with_namespace.cmake)

if (ENABLE_TESTS)
  add_subdirectory(tests)
endif ()
