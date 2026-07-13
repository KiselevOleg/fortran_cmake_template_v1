# ==========================================================
# LIBRARY SYSTEM
# ==========================================================

set(LIBRARY_NAME "system")

set(SRC_FILES
  src/exception/assert.f90
  src/exception/imp/assert_impl.f90
  src/exception/exception.f90
  src/exception/imp/exception_impl.f90
  src/util/dynamic_array.f90
  src/util/imp/dynamic_array_impl.f90
)

include(../../../cmake/for_libraries/generate_library_with_package.cmake)

if (ENABLE_TESTS)
  add_subdirectory(tests)
endif ()
