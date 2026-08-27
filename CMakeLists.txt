# =========================
# USING
# =========================

#################### INIT ##############################
# cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Release
# cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Debug
# cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Debug -DENABLE_SANITIZERS=ON
#################### USE_GENERATED_BY_CMAKE_PROJECT ##############################
# cmake --build build
# cmake --build build --target help
# cmake --build build --target all
# cmake --build build --target test
# ctest --test-dir ./build --verbose
# cmake --build build --target clean
#################### CREATE_DEPENDINCES_GRAPH ##############################
# cmake ... --graphviz=./build/depends.dotdepends.dot
# dot -Tpng -o depends.png depends.dot
#################### RUN_EXECUTABLE_BINARY ##############################
# ./build/main
#################### DELETE_ALL_GENERATED_BY_CMAKE ##############################
# rm -fr ./build

# ==========================================================
# OPTIONS
# ==========================================================

option(ENABLE_PREPROCESSOR_STATE "Enable processing preprocessor directives" OFF)
option(ENABLE_NATIVE_COMPILATION "Enable compilation only for this system (Release only)" OFF)

option(ENABLE_OPENMP "Enable OpenMP (does not work with sanitizers)" OFF)
option(ENABLE_LTO "Enable LTO (IPO)" ON)
option(ENABLE_SANITIZERS "Enable sanitizers (Debug only)(cancels openmp)" OFF)

option(ENABLE_STATIC_ANALYSIS "Enable static analysis" ON)
option(ENABLE_TESTS "Build tests" ON)

# =========================
# SETUP
# =========================

# cmake_minimum_required(VERSION 4.2.2)
cmake_minimum_required(VERSION 3.24)

if (NOT CMAKE_Fortran_COMPILER)
  find_program(CMAKE_Fortran_COMPILER gfortran)
endif ()
project(test_fortran LANGUAGES Fortran C)

if (NOT DEFINED CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Release | Debug" FORCE)
endif ()


# ==========================================================
# SETIINGS
# ==========================================================

include(cmake/add_dependencies.cmake)
include(cmake/flags.cmake)
include(cmake/docs.cmake)
include(cmake/lint.cmake)
include(cmake/tests.cmake)

include(cmake/external_libraries.cmake)

# ==========================================================
# SUB_DIRECTORIES
# ==========================================================

add_subdirectory(src/libs/system)
add_subdirectory(src/libs/integral_generator)
add_subdirectory(src/libs/oscillation_integral)
add_subdirectory(src/libs/static_library_1)
add_subdirectory(src/app)
