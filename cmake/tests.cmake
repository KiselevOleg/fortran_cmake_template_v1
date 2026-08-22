# ==========================================================
# TESTS
# ==========================================================

set(DEFAULT_PFUNIT_PATH "${CMAKE_SOURCE_DIR}/external_dependencies/pFUnit/build/installed")
list(INSERT CMAKE_PREFIX_PATH 0 "${DEFAULT_PFUNIT_PATH}")
message(STATUS "CMAKE_PREFIX_PATH = ${CMAKE_PREFIX_PATH}")

if (ENABLE_TESTS)
  find_package(PFUNIT REQUIRED)
  message(STATUS "PFUnit_DIR = ${PFUNIT_DIR}")
  enable_testing()

  # cd build
  # ctest --rerun-failed --output-on-failure
  # cd ..
  add_custom_target(test_extended
    COMMAND ${CMAKE_CTEST_COMMAND} --rerun-failed --output-on-failure
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Run tests with verbose output"
  )
endif ()
