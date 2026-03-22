# ==========================================================
# MAIN EXECUTABLE
# ==========================================================

add_executable(main
  main.f90
)
set_target_properties(main PROPERTIES
  Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/mod/main
)

target_link_libraries(main PRIVATE jsonfortran)
add_dependencies(main jsonfortran)
target_include_directories(main PRIVATE
  $<TARGET_PROPERTY:jsonfortran,Fortran_MODULE_DIRECTORY>
)

target_link_libraries(main PRIVATE static_library_1)
target_link_libraries(main PRIVATE integral_generator)
target_link_libraries(main
  PUBLIC
    flags_features
  PRIVATE
    flags_warnings
    flags_build_type
)

set_target_properties(main PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
)
