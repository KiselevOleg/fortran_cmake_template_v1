# ==========================================================
# STATIC LIBRARY WIRH AUTO NAMESPACE
# ==========================================================

if (NOT DEFINED OUTPUT_STRUCTURE__NAMES)
  set(OUTPUT_STRUCTURE__NAMES "")
endif ()
list(FIND OUTPUT_STRUCTURE__NAMES "${LIBRARY_NAME}" INDEX)
if (INDEX EQUAL -1)
  message(STATUS "processing ${LIBRARY_NAME}")
else ()
  message(FATAL_ERROR "several structures with the same name ${LIBRARY_NAME}")
endif ()

if (NOT DEFINED OUTPUT_FILE_NAMES)
  set(OUTPUT_FILE_NAMES "")
endif ()

set(GENERATED_SRC_DIR "${CMAKE_BINARY_DIR}/namespace_generated/${LIBRARY_NAME}")
file(MAKE_DIRECTORY ${GENERATED_SRC_DIR})

set(MODULE_DEPENDS "")
set(MODULE_FILES "")

set(MODULE_NAMES "")
foreach(file ${SRC_FILES})
  get_filename_component(fname ${file} NAME_WE)

  list(FIND MODULE_NAMES "${fname}" INDEX)
  if (INDEX EQUAL -1)
    message(STATUS "generate namespace for ${fname}")
  else ()
    message(FATAL_ERROR "several files with the same name ${fname} at the library ${LIBRARY_NAME}")
  endif ()

  list(APPEND MODULE_NAMES ${fname})



  set(output_file "${LIBRARY_NAME}___${file}")
  list(FIND OUTPUT_FILE_NAMES "${output_file}" INDEX)
  if (INDEX EQUAL -1)
    # message(STATUS "generate a file ${output_file}")
  else ()
    message(FATAL_ERROR
      "several package files with the same name ${output_file} at the library ${LIBRARY_NAME}"
    )
  endif ()

  list(APPEND OUTPUT_FILE_NAMES ${output_file})
endforeach()

foreach(file ${SRC_FILES})
  get_filename_component(fname ${file} NAME)
  set(out_file "${GENERATED_SRC_DIR}/${fname}")

  file(READ ${file} content)

  foreach(module_name ${MODULE_NAMES})
    string(REGEX REPLACE
      "module[ ]+${module_name}([^a-zA-Z0-9_])"
      "module ${LIBRARY_NAME}___${module_name}\\1"
      content "${content}"
    )
    string(REGEX REPLACE
      "use[ ]+${module_name}([^a-zA-Z0-9_])"
      "use ${LIBRARY_NAME}___${module_name}\\1"
      content "${content}"
    )
  endforeach()
  foreach(module_name ${MODULE_NAMES})
    string(REGEX REPLACE
      "submodule[ ]*\\(${module_name}\\)[ ]*([a-zA-Z0-9_])"
      "submodule\(${LIBRARY_NAME}___${module_name}\) ${LIBRARY_NAME}___\\1"
      content "${content}"
    )
    string(REGEX REPLACE
      "end[ ]*submodule[ ]+${module_name}([^a-zA-Z0-9_])"
      "end submodule ${LIBRARY_NAME}___${module_name}\\1"
      content "${content}"
    )
  endforeach()

  set(content "!> @category ${LIBRARY_NAME}\n${content}")

  file(WRITE ${out_file} "${content}")
endforeach()



file(GLOB_RECURSE GENERATED_SRC "${GENERATED_SRC_DIR}/*.f90")
if (NOT GENERATED_SRC)
  message(FATAL_ERROR "No fortran files found in ${GENERATED_SRC_DIR}")
endif ()

add_library(${LIBRARY_NAME} STATIC ${GENERATED_SRC})

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
