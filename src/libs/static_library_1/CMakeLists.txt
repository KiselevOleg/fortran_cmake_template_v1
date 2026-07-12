# ==========================================================
# STATIC LIBRARY WITH AUTO NAMESPACE
# ==========================================================

set(LIBRARY_NAME "static_library_1")

set(SRC_FILES
  src/math.f90
  src/functions.f90
  src/imp/math_impl.f90
  src/imp/functions_impl.f90
)

include(../../../cmake/for_libraries/generate_library_with_namespace.cmake)

target_link_libraries(${LIBRARY_NAME}
  PRIVATE
    system
)

if (ENABLE_TESTS)
  add_subdirectory(tests)
endif ()
