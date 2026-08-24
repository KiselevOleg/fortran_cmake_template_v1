# ==========================================================
# RUN EXECUTABLE SCIPT EACH TIME BEFORE BUILD PROJECT FOR A LIBRARY
# ==========================================================

execute_process(
    COMMAND ${CMAKE_COMMAND} -E env bash
            ${CMAKE_CURRENT_SOURCE_DIR}/${PREPARE_SCRIPT_FILE}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    RESULT_VARIABLE PREPARE_RESULT
)

if(NOT PREPARE_RESULT EQUAL 0)
    message(FATAL_ERROR "Prepare script failed with code ${PREPARE_RESULT}")
endif()

