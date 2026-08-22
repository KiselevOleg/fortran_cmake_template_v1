# ==========================================================
# LINT
# ==========================================================

if (ENABLE_STATIC_ANALYSIS)
    add_custom_target(lint_Fortitude_linter_f90
        COMMAND ${CMAKE_COMMAND} -E env
            PATH=${CMAKE_SOURCE_DIR}/external_dependencies/Fortitude/Fortitude_environment/bin:$ENV{PATH}
            ${CMAKE_SOURCE_DIR}/external_dependencies/Fortitude/Fortitude_environment/bin/python -m fortitude check --file-extensions=f90
        #COMMAND  fortitude check --file-extensions=f90
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/src
        COMMENT "Running lint Fortitude for f90"
    )
    add_custom_target(lint_Fortitude_linter_pf
        COMMAND ${CMAKE_COMMAND} -E env
            PATH=${CMAKE_SOURCE_DIR}/external_dependencies/Fortitude/Fortitude_environment/bin:$ENV{PATH}
            ${CMAKE_SOURCE_DIR}/external_dependencies/Fortitude/Fortitude_environment/bin/python -m fortitude check --file-extensions=pf --ignore=E001,S091
        #COMMAND  fortitude check --file-extensions=pf --ignore=E001,S091
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/src
        COMMENT "Running lint Fortitude for pf"
    )

    add_custom_target(lint_Fortran_linter
        COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/external_dependencies/fortran-syntax/check.py
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Running lint lint_Fortran"
    )

    add_custom_target(lint)
    add_dependencies(lint
        lint_Fortitude_linter_f90
        lint_Fortitude_linter_pf
        lint_Fortran_linter
    )
endif ()
