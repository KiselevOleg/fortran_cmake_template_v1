# ==========================================================
# STATIC LIBRARY WIRH PACKAGE SYSTEM
# ==========================================================

get_filename_component(LIBRARY_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME_WE)

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
function(get_output_file_dir relavile_structure_file_dir output_file_dir)
  get_filename_component(fname ${relavile_structure_file_dir} NAME_WE)
  get_filename_component(fdir_absolute ${relavile_structure_file_dir} ABSOLUTE)
  file(RELATIVE_PATH fdir_rel "${CMAKE_CURRENT_SOURCE_DIR}" "${fdir_absolute}")

  get_filename_component(fdir "${fdir_rel}" DIRECTORY)
  string(REPLACE "\\" "/" fdir "${fdir}")
  string(REPLACE "/" "_" fdir "${fdir}")
  if ("${fdir}" STREQUAL "src")
    set(fdir "${LIBRARY_NAME}")
  else()
    string(SUBSTRING "${fdir}" 4 -1 fdir)
    set(fdir "${LIBRARY_NAME}_${fdir}")
  endif ()

  set(${output_file_dir} "${fdir}___${fname}" PARENT_SCOPE)
endfunction()

set(GENERATED_SRC_DIR "${CMAKE_BINARY_DIR}/package_generated/${LIBRARY_NAME}")
file(MAKE_DIRECTORY ${GENERATED_SRC_DIR})

foreach(file ${SRC_FILES})
  get_output_file_dir("${file}" output_file)

  list(FIND OUTPUT_FILE_NAMES "${output_file}" INDEX)
  if (INDEX EQUAL -1)
    message(STATUS "generate a package file ${output_file}")
  else ()
    message(FATAL_ERROR
      "several package files with the same name ${output_file} at the library ${LIBRARY_NAME}"
    )
  endif ()

  list(APPEND OUTPUT_FILE_NAMES ${module_name})
endforeach()

set(MODULE_NAMES "")
foreach(file ${SRC_FILES})
  get_filename_component(fname ${file} NAME_WE)

  list(FIND MODULE_NAMES "${fname}" INDEX)
  if (NOT (INDEX EQUAL -1))
    message(FATAL_ERROR "several files with the same name ${fname} at the library ${LIBRARY_NAME}")
  endif ()

  list(APPEND MODULE_NAMES ${fname})
endforeach()

foreach(file ${SRC_FILES})
  get_filename_component(module_name ${file} NAME_WE)
  get_output_file_dir("${file}" output_file_current)
  set(module_name_new ${output_file_current})
  set(output_file_current "${GENERATED_SRC_DIR}/${output_file_current}.f90")

  file(READ ${file} content)

  foreach(file ${SRC_FILES})
    get_filename_component(module_name ${file} NAME_WE)
    get_output_file_dir("${file}" output_file)
    set(module_name_new ${output_file})

    string(REGEX REPLACE
      "module[ ]+${module_name}([^a-zA-Z0-9_])"
      "module ${module_name_new}\\1"
      content "${content}"
    )
    string(REGEX REPLACE
      "use[ ]+${module_name}([^a-zA-Z0-9_])"
      "use ${module_name_new}\\1"
      content "${content}"
    )
  endforeach()
  foreach(file ${SRC_FILES})
    get_filename_component(module_name ${file} NAME_WE)
    get_output_file_dir("${file}" output_file)
    set(module_name_new ${output_file})

    string(REGEX REPLACE
      "submodule[ ]*\\(${module_name}\\)[ ]*([a-zA-Z0-9_])"
      "submodule\(${module_name_new}\) \\1"
      content "${content}"
    )
    string(REGEX REPLACE
      "end[ ]*submodule[ ]+${module_name}([^a-zA-Z0-9_])"
      "end submodule ${module_name_new}___\\1"
      content "${content}"
    )
  endforeach()
  foreach(file ${SRC_FILES})
    get_filename_component(module_name ${file} NAME_WE)
    get_output_file_dir("${file}" output_file)
    set(module_name_new ${output_file})

    string(REGEX REPLACE
      "submodule[ ]*\\(([a-zA-Z0-9_]+)\\)[ ]*${module_name}([^a-zA-Z0-9_])"
      "submodule\(\\1\) ${module_name_new}\\2"
      content "${content}"
    )
  endforeach()

  set(content "!> @category ${LIBRARY_NAME}\n${content}")

  file(WRITE ${output_file_current} "${content}")
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
