# ==========================================================
# MAIN EXECUTABLE
# ==========================================================

add_executable(main
  main.f90
)
set_target_properties(main PROPERTIES
  Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/include/main
)

#find_package(HDF5 REQUIRED COMPONENTS Fortran)
#target_include_directories(main PRIVATE /usr/include)
#target_link_libraries(main PRIVATE
#    ${HDF5_Fortran_LIBRARIES}
#)

#find_package(HDF5 REQUIRED CONFIG COMPONENTS Fortran)
#target_link_libraries(main PRIVATE
#  HDF5::HDF5_Fortran
#)

target_link_libraries(main PRIVATE jsonfortran)
target_link_libraries(main PRIVATE h5fortran)

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
