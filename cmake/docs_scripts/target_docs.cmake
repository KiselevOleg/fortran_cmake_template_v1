set(ORIGINAL_APP_DIR "${CMAKE_SOURCE_DIR}/src/app")
set(ORIGINAL_LIB_DIR "${CMAKE_SOURCE_DIR}/src/libs")
set(COPY_SRC_DIR "${CMAKE_SOURCE_DIR}/build/original_src_copy_for_ford/src")
set(COPY_SRC_DIR_WITHOUT_SRC "${CMAKE_SOURCE_DIR}/build/original_src_copy_for_ford")
set(NAMESPACED_SRC_DIR "${CMAKE_SOURCE_DIR}/build/namespace_generated")
set(PACKAGE_SRC_DIR "${CMAKE_SOURCE_DIR}/build/package_generated")
set(DOCS_OUTPUT_DIR "${CMAKE_SOURCE_DIR}/build/docs")

set(VENV_DIR "${CMAKE_SOURCE_DIR}/external_dependencies/Ford/Ford_environment")
set(VENV_PYTHON "${VENV_DIR}/bin/python")

message(STATUS "[project_docs] Cleaning target directories")
file(REMOVE_RECURSE "${COPY_SRC_DIR_WITHOUT_SRC}")
file(MAKE_DIRECTORY "${COPY_SRC_DIR}/libs")
file(MAKE_DIRECTORY "${COPY_SRC_DIR}/app")

message(STATUS "[project_docs] Copying sources, namespaced modules, app, and ford.md")

file(COPY "${ORIGINAL_LIB_DIR}" DESTINATION "${COPY_SRC_DIR}")

file(GLOB NAMESPACED_SUBFOLDERS LIST_DIRECTORIES true "${NAMESPACED_SRC_DIR}/*")
foreach(SUBFOLDER ${NAMESPACED_SUBFOLDERS})
    if (IS_DIRECTORY ${SUBFOLDER})
        get_filename_component(SUBNAME_DIR ${SUBFOLDER} NAME)
        set(DEST_SUBFOLDER "${COPY_SRC_DIR}/libs/${SUBNAME_DIR}")

        if (EXISTS ${DEST_SUBFOLDER})
            file(REMOVE_RECURSE "${DEST_SUBFOLDER}")
        endif ()

        file(COPY "${SUBFOLDER}" DESTINATION "${COPY_SRC_DIR}/libs")
    endif ()
endforeach()

file(GLOB PACKAGE_SUBFOLDERS LIST_DIRECTORIES true "${PACKAGE_SRC_DIR}/*")
foreach(SUBFOLDER ${PACKAGE_SUBFOLDERS})
    if (IS_DIRECTORY ${SUBFOLDER})
        get_filename_component(SUBNAME_DIR ${SUBFOLDER} NAME)
        set(DEST_SUBFOLDER "${COPY_SRC_DIR}/libs/${SUBNAME_DIR}")

        if (EXISTS ${DEST_SUBFOLDER})
            file(REMOVE_RECURSE "${DEST_SUBFOLDER}")
        endif ()

        file(COPY "${SUBFOLDER}" DESTINATION "${COPY_SRC_DIR}/libs")
    endif ()
endforeach()

file(COPY "${ORIGINAL_APP_DIR}" DESTINATION "${COPY_SRC_DIR}")

file(COPY "${CMAKE_SOURCE_DIR}/ford.md" DESTINATION "${COPY_SRC_DIR_WITHOUT_SRC}")

message(STATUS "[project_docs] Running Ford via python -m with venv")
execute_process(
    #COMMAND ${VENV_PYTHON} -m ford ./ford.md
    COMMAND ${CMAKE_COMMAND} -E env
        PATH=${VENV_DIR}/bin:$ENV{PATH}
        ${VENV_PYTHON} -m ford ./ford.md
    WORKING_DIRECTORY "${COPY_SRC_DIR_WITHOUT_SRC}"
    RESULT_VARIABLE FORD_RESULT
)

if (NOT FORD_RESULT EQUAL 0)
    message(FATAL_ERROR "Ford failed with exit code ${FORD_RESULT}")
endif ()

message(STATUS "[project_docs] Moving generated docs to ${DOCS_OUTPUT_DIR}")
file(REMOVE_RECURSE "${DOCS_OUTPUT_DIR}")
file(RENAME "${COPY_SRC_DIR_WITHOUT_SRC}/doc" "${DOCS_OUTPUT_DIR}")

message(STATUS "[project_docs] Done!")
