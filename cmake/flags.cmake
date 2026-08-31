# ==========================================================
# FLAGS
# ==========================================================

message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")

message(STATUS "Enable Preproccessor: ${ENABLE_PREPROCESSOR_STATE}")
message(STATUS "Enable native compilation: ${ENABLE_NATIVE_COMPILATION}")

message(STATUS "Enable OpenMP: ${ENABLE_OPENMP}")
message(STATUS "Enable LTO (IPO): ${ENABLE_LTO}")
message(STATUS "Enable Sanitizers: ${ENABLE_SANITIZERS}")

message(STATUS "Enable code analysis: ${ENABLE_STATIC_ANALYSIS}")
message(STATUS "Enable testing: ${ENABLE_TESTS}")

if (ENABLE_OPENMP AND ENABLE_SANITIZERS)
  message(FATAL_ERROR "OpenMP and Sanitizers can not be enable both")
endif ()
if (ENABLE_NATIVE_COMPILATION AND NOT CMAKE_BUILD_TYPE STREQUAL "Release")
  message(FATAL_ERROR "NATIVE_COMPILATION must be only with Release")
endif ()

add_library(flags_warnings INTERFACE)
target_compile_options(flags_warnings INTERFACE
  -Wall -Wextra -pedantic-errors
  -Wconversion -Werror=conversion -Wshadow -Wuninitialized
  -Werror=implicit-interface
  -Werror=implicit-procedure
  -Werror=surprising
  -Wmaybe-uninitialized
)

add_library(flags_features INTERFACE)
target_compile_options(flags_features INTERFACE
  -std=f2018
  -fimplicit-none
  -fstack-protector-strong
  -fbacktrace
  -fno-unsafe-math-optimizations
  -ffp-contract=off
)

if (ENABLE_PREPROCESSOR_STATE)
  target_compile_options(flags_features INTERFACE $<$<COMPILE_LANGUAGE:Fortran>:-cpp>)
endif ()

if (ENABLE_OPENMP AND NOT ENABLE_SANITIZERS)
  find_package(OpenMP REQUIRED)
endif ()

add_library(flags_build_type INTERFACE)

if (CMAKE_BUILD_TYPE STREQUAL "Release")
  target_compile_options(flags_build_type INTERFACE
    -O3
    -DNDEBUG
    -finline-functions
  )

  if (ENABLE_NATIVE_COMPILATION)
    target_compile_options(flags_build_type INTERFACE -march=native)
  endif ()

  if (ENABLE_LTO)
    include(CheckIPOSupported)
    check_ipo_supported(
      RESULT ipo_supported
      OUTPUT ipo_error
      LANGUAGES Fortran
    )
    if (ipo_supported)
      set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE)
    else ()
      message(WARNING "IPO/LTO not supported: ${ipo_error}")
    endif ()
    # target_compile_options(flags_features INTERFACE
    #   -flto
    # )
  endif ()
elseif (CMAKE_BUILD_TYPE STREQUAL "Debug")
  target_compile_options(flags_build_type INTERFACE
    -Og -g
    -fcheck=all
    -finit-integer=-999
    -finit-real=snan
    -fno-omit-frame-pointer
    -ffpe-trap=invalid,zero,overflow
  )

  if (ENABLE_SANITIZERS)
    target_compile_options(flags_build_type INTERFACE
      -fsanitize=leak,address,undefined
    )
    target_link_options(flags_build_type INTERFACE
      -fsanitize=leak,address,undefined
    )
  endif ()
else ()
  message(FATAL_ERROR "Unknown build type: ${CMAKE_BUILD_TYPE}")
endif ()
