# ==========================================================
# STATIC LIBRARY WITH AUTO NAMESPACE
# ==========================================================

set(LIBRARY_NAME "oscillation_integrating")

set(SRC_FILES
  src/1d_integrating/integrating_on_uniform_3point.f90
  src/1d_integrating/imp/integrating_on_uniform_3point_impl.f90

  src/1d_integrating/integrating_on_uniform_5point.f90
  src/1d_integrating/imp/integrating_on_uniform_5point_impl.f90
)

include(../../../cmake/for_libraries/generate_library_with_namespace.cmake)
set(PREPARE_SCRIPT_FILE "prepare.sh")
include(../../../cmake/for_libraries/add_build_level_prepare_script_to_library.cmake)
set(ADDITIONAL_DEPENDENCY_NAME "${LIBRARY_NAME}_Error_Fns_Dawson_Intgrl_Cmplx")
set(ADDITIONAL_DEPENDENCY_STATIC_LIBRARY_FILE
  "${CMAKE_SOURCE_DIR}/external_dependencies/Error_Fns_Dawson_Intgrl_Cmplx/build/libfaddeyeva.a"
)
set(ADDITIONAL_DEPENDENCY_INCLUDE_FOLDER
  "${CMAKE_SOURCE_DIR}/external_dependencies/Error_Fns_Dawson_Intgrl_Cmplx/build/include"
)
include(../../../cmake/for_libraries/add_local_static_dependency_to_library.cmake)

target_link_libraries(${LIBRARY_NAME}
  PRIVATE
    system
)

if (ENABLE_TESTS)
  add_subdirectory(tests)
endif ()
