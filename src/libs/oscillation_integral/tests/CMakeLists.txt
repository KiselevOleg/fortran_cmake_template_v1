# ==========================================================
# TESTS
# ==========================================================

add_pfunit_ctest(integrating_on_uniform_3point_test
  TEST_SOURCES integrating_on_uniform_3point_test.pf
  LINK_LIBRARIES
    ${LIBRARY_NAME}
    system
    ${LIBRARY_NAME}_Error_Fns_Dawson_Intgrl_Cmplx
)
add_pfunit_ctest(integrating_on_uniform_5point_test
  TEST_SOURCES integrating_on_uniform_5point_test.pf
  LINK_LIBRARIES
    ${LIBRARY_NAME}
    system
    ${LIBRARY_NAME}_Error_Fns_Dawson_Intgrl_Cmplx
)

add_pfunit_ctest(integrating_surf_uniform_bilinear_test
  TEST_SOURCES integrating_surf_uniform_bilinear_test.pf
  LINK_LIBRARIES
    ${LIBRARY_NAME}
    system
    ${LIBRARY_NAME}_Error_Fns_Dawson_Intgrl_Cmplx
)
