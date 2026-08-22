# ==========================================================
# STATIC LIBRARY
# ==========================================================

set(LIBRARY_NAME "static_library_1")

add_library(${LIBRARY_NAME} STATIC ${SRC_FILES}
)

set_target_properties(${LIBRARY_NAME} PROPERTIES
  Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/src/libs/${LIBRARY_NAME}/include
)
target_include_directories(${LIBRARY_NAME}
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/src/libs/${LIBRARY_NAME}/include>
)

set(INCLUDE_MOD_DIR "${CMAKE_BINARY_DIR}/include_list_all")
file(MAKE_DIRECTORY ${INCLUDE_MOD_DIR})
add_custom_command(TARGET ${LIBRARY_NAME} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_directory
    "${CMAKE_BINARY_DIR}/src/libs/${LIBRARY_NAME}/include"
    "${INCLUDE_MOD_DIR}"
)

target_link_libraries(${LIBRARY_NAME}
  PUBLIC
    flags_features
  PRIVATE
    flags_warnings
    flags_build_type
)
