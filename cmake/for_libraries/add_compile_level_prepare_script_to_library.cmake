# ==========================================================
# RUN EXECUTABLE SCIPT EACH TIME BEFORE COMPILE LIBRARY
# ==========================================================

add_custom_target(${LIBRARY_NAME}_prepare
  COMMAND ${CMAKE_COMMAND} -E env bash
          ${CMAKE_CURRENT_SOURCE_DIR}/${PREPARE_SCRIPT_FILE}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)
add_dependencies(${LIBRARY_NAME} ${LIBRARY_NAME}_prepare)
