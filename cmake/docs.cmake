# ==========================================================
# DOCS
# ==========================================================

add_custom_target(project_docs
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_SOURCE_DIR}/cmake/docs_scripts/target_docs.cmake
    # COMMAND bash -c "chmod +x ${CMAKE_SOURCE_DIR}/cmake/docs_scripts/target_docs.sh; ${CMAKE_SOURCE_DIR}/cmake/docs_scripts/target_docs.sh"

    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Running ford for documentation generation"
    VERBATIM
)

#find_package(Doxygen)
#
#if (Doxygen_FOUND)
#  set(DOXYGEN_GENERATE_HTML YES)
#  set(DOXYGEN_GENERATE_MAN NO)
#  set(OPTIMIZE_FOR_FORTRAN YES)
#
#  doxygen_add_docs(
#    project_docs_doxygen
#    ${PROJECT_SOURCE_DIR}/src
#    #${PROJECT_SOURCE_DIR}
#    ALL
#  )
#endif ()
