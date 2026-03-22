# ==========================================================
# COMMON DPENDENCIES
# ==========================================================

find_package(Python3 REQUIRED)

# ==========================================================
# MANUAL DPENDENCIES
# ==========================================================

function(add_external_dependency name script)
    add_custom_target(${name}
        COMMAND bash -c "chmod +x ${CMAKE_SOURCE_DIR}/cmake/add_dependencies_scripts/${script}; ${CMAKE_SOURCE_DIR}/cmake/add_dependencies_scripts/${script}"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Install external dependency ${script}"
        VERBATIM
    )
endfunction()

# install pFUnit (tests)
add_external_dependency(pFUnit_external_dependency_install pFUnit.sh)

# install Fortran linter (lint)
add_external_dependency(Fortran_linter_external_dependency_install Fortran_linter.sh)

# install Fortitude (lint)
add_external_dependency(Fortitude_external_dependency_install Fortitude.sh)

# install ford (documentation generation)
add_external_dependency(ford_external_dependency_install ford.sh)

# install json-fortran (json files interactions)
add_external_dependency(jsonfortran_external_dependency_install jsonfortran.sh)

# install all dependencies
add_custom_target(all_external_dependencies_install)
add_dependencies(all_external_dependencies_install
  pFUnit_external_dependency_install
  Fortran_linter_external_dependency_install
  Fortitude_external_dependency_install
  ford_external_dependency_install
  jsonfortran_external_dependency_install
)
