# ==========================================================
# LIBRARY INTEGRAL_GENERATOR
# ==========================================================

set(LIBRARY_NAME "integral_generator")

set(SRC_FILES
  src/integrator.f90
  src/imp/integrator_part_obj_impl.f90
  src/imp/integrator_builder_impl.f90
  src/imp/integrator_integrate_impl.f90

  src/integration.f90

  src/integration_path_part.f90
  src/imp/integration_path_part_impl.f90
  src/integration_path_part_imp/integration_path_part_parallel_Re.f90
  src/imp/integration_path_part_imp/integration_path_part_parallel_Re_impl.f90
  src/integration_path_part_imp/integration_path_part_parallel_Im.f90
  src/imp/integration_path_part_imp/integration_path_part_parallel_Im_impl.f90
  src/integration_path_part_imp/integration_path_part_line.f90
  src/imp/integration_path_part_imp/integration_path_part_line_impl.f90
  src/integration_path_part_imp/integration_path_part_custom_curve.f90
  src/imp/integration_path_part_imp/integration_path_part_custom_curve_impl.f90

  src/integration_template.f90
  src/integration_template_imp/integration_template_recalculation.f90
  src/imp/integration_template_imp/integration_template_recalculation_impl.f90

  src/integration_element.f90
  src/integration_element_imp/integration_element_gauss3.f90
  src/imp/integration_element_imp/integration_element_gauss3_impl.f90
  src/integration_element_imp/integration_element_gauss4.f90
  src/imp/integration_element_imp/integration_element_gauss4_impl.f90
  src/integration_element_imp/integration_element_gauss5.f90
  src/imp/integration_element_imp/integration_element_gauss5_impl.f90
  src/integration_element_imp/integration_element_gauss6.f90
  src/imp/integration_element_imp/integration_element_gauss6_impl.f90
  src/integration_element_imp/integration_element_gauss7.f90
  src/imp/integration_element_imp/integration_element_gauss7_impl.f90
  src/integration_element_imp/integration_element_gauss8.f90
  src/imp/integration_element_imp/integration_element_gauss8_impl.f90
)

include(../../../cmake/for_libraries/generate_library_with_namespace.cmake)

target_link_libraries(${LIBRARY_NAME}
  PRIVATE
    system
)

if (ENABLE_TESTS)
  add_subdirectory(tests)
endif ()
