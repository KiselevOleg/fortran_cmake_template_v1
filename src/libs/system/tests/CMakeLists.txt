# ==========================================================
# TESTS
# ==========================================================

add_pfunit_ctest(assert_test
  TEST_SOURCES exception/assert_test.pf
  LINK_LIBRARIES
    ${LIBRARY_NAME}
)

add_pfunit_ctest(exception_test
  TEST_SOURCES exception/exception_test.pf
  LINK_LIBRARIES
    ${LIBRARY_NAME}
)

add_pfunit_ctest(dynamic_array_test
  TEST_SOURCES util/dynamic_array_test.pf
  LINK_LIBRARIES
    ${LIBRARY_NAME}
)
