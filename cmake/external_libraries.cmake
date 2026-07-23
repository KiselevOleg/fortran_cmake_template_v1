# ==========================================================
# ADDITIONAL_LIBRARIES
# ==========================================================

#set (JSONFORTRAN_ENABLE_TESTS OFF CACHE BOOL "" FORCE)
#set (ENABLE_TESTS_ ENABLE_TESTS)
#set (ENABLE_TESTS FALSE CACHE BOOL "" FORCE)
#set (JSONFORTRAN_STATIC_LIBRARY_ONLY ON CACHE BOOL "" FORCE)
#add_subdirectory(external_dependencies/json-fortran)
#add_subdirectory(external_dependencies/h5fortran)
#set (ENABLE_TESTS ENABLE_TESTS_)

set(ALL_EXTERNAL_INCLUDE_DIR "${CMAKE_BINARY_DIR}/include_external_list_all")

# ==========================================================
# JSONFORTRAN
# ==========================================================
add_library(jsonfortran STATIC IMPORTED)
set_target_properties(jsonfortran PROPERTIES
    IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/external_dependencies/json-fortran/build/lib/libjsonfortran.a"
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/external_dependencies/json-fortran/build/include"
)
file(COPY "${CMAKE_SOURCE_DIR}/external_dependencies/json-fortran/build/include/"
    DESTINATION "${ALL_EXTERNAL_INCLUDE_DIR}")

# ==========================================================
# H5FORTRAN
# ==========================================================
# add_library(hdf5 STATIC IMPORTED)
# set_target_properties(hdf5 PROPERTIES
#     IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/lib/libhdf5.a"
#     INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/mod/static"
#     INTERFACE_LINK_LIBRARIES "ZLIB::ZLIB;dl;m"
# )
# add_library(hdf5_fortran STATIC IMPORTED)
# set_target_properties(hdf5_fortran PROPERTIES
#     IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/lib/libhdf5_fortran.a"
#     INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/mod/static"
#     INTERFACE_LINK_LIBRARIES "ZLIB::ZLIB;dl;m"
# )
# add_library(hdf5_hl STATIC IMPORTED)
# set_target_properties(hdf5_hl PROPERTIES
#     IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/lib/libhdf5_hl.a"
#     INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/mod/static"
#     INTERFACE_LINK_LIBRARIES "ZLIB::ZLIB;dl;m"
# )
# add_library(hdf5_hl_fortran STATIC IMPORTED)
# set_target_properties(hdf5_hl_fortran PROPERTIES
#     IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/lib/libhdf5_hl_fortran.a"
#     INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/mod/static"
#     INTERFACE_LINK_LIBRARIES "ZLIB::ZLIB;dl;m"
# )
# add_library(hdf5_f90cstub STATIC IMPORTED)
# set_target_properties(hdf5_f90cstub PROPERTIES
#     IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/lib/libhdf5_f90cstub.a"
#     INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/mod/static"
#     INTERFACE_LINK_LIBRARIES "ZLIB::ZLIB;dl;m"
# )
# add_library(hdf5_hl_f90cstub STATIC IMPORTED)
# set_target_properties(hdf5_hl_f90cstub PROPERTIES
#     IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/lib/libhdf5_hl_f90cstub.a"
#     INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/mod/static"
#     INTERFACE_LINK_LIBRARIES "ZLIB::ZLIB;dl;m"
# )
# file(COPY "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/mod/static/"
#     DESTINATION "${ALL_EXTERNAL_INCLUDE_DIR}")

# find_package(Threads REQUIRED)
# find_package(ZLIB REQUIRED)
# add_library(h5fortran STATIC IMPORTED)
# set_target_properties(h5fortran PROPERTIES
#     IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/external_dependencies/h5fortran/build/libh5fortran.a"
#     INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/external_dependencies/h5fortran/build/include"
#     INTERFACE_LINK_LIBRARIES "hdf5_hl_fortran;hdf5_hl;hdf5_fortran;hdf5;hdf5_f90cstub;hdf5_hl_f90cstub;ZLIB::ZLIB;Threads::Threads;dl;m"
# )
# file(COPY "${CMAKE_SOURCE_DIR}/external_dependencies/h5fortran/build/include/"
#     DESTINATION "${ALL_EXTERNAL_INCLUDE_DIR}")

# ==========================================================
# H5FORTRAN
# ==========================================================
list(APPEND CMAKE_PREFIX_PATH
    "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install"
)

find_package(Threads REQUIRED)
find_package(ZLIB REQUIRED)

find_package(HDF5 CONFIG REQUIRED COMPONENTS Fortran HL)

add_library(h5fortran STATIC IMPORTED GLOBAL)
set_target_properties(h5fortran PROPERTIES
    IMPORTED_LOCATION
        "${CMAKE_SOURCE_DIR}/external_dependencies/h5fortran/build/libh5fortran.a"
    INTERFACE_INCLUDE_DIRECTORIES
        "${CMAKE_SOURCE_DIR}/external_dependencies/h5fortran/build/include"
    INTERFACE_LINK_LIBRARIES
        "h5fortran;hdf5_hl_fortran-static"
)

file(COPY
    "${CMAKE_SOURCE_DIR}/external_dependencies/hdf5/build/install/mod/static/"
    DESTINATION "${ALL_EXTERNAL_INCLUDE_DIR}"
)
file(COPY
    "${CMAKE_SOURCE_DIR}/external_dependencies/h5fortran/build/include/"
    DESTINATION "${ALL_EXTERNAL_INCLUDE_DIR}"
)

# ==========================================================
# FORTRAN_REGEX
# ==========================================================

add_library(fortran_regex STATIC IMPORTED GLOBAL)
set_target_properties(fortran_regex PROPERTIES
    IMPORTED_LOCATION
        "${CMAKE_SOURCE_DIR}/external_dependencies/fortran-regex/build/release/lib/libregex.a"
    INTERFACE_INCLUDE_DIRECTORIES
        "${CMAKE_SOURCE_DIR}/external_dependencies/fortran-regex/build/release/include"
    INTERFACE_LINK_LIBRARIES
        "h5fortran;hdf5_hl_fortran-static"
)

file(COPY
    "${CMAKE_SOURCE_DIR}/external_dependencies/fortran-regex/build/release/include/"
    DESTINATION "${ALL_EXTERNAL_INCLUDE_DIR}"
)
