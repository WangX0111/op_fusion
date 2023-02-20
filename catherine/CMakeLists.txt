##===- CMakeLists.txt - op-fusion cmake root -----------------*- cmake -*-===//
##
## Configure the op-fusion build.
##
##===----------------------------------------------------------------------===//
cmake_minimum_required(VERSION 3.16...3.27)

#-------------------------------------------------------------------------------
# Project setup and globals
#-------------------------------------------------------------------------------

project(Catherine LANGUAGES CXX C)

set(CMAKE_BUILD_WITH_INSTALL_NAME_DIR ON)
set(CMAKE_CXX_STANDARD 17 CACHE STRING "C++ standard to conform to")


#-------------------------------------------------------------------------------
# MLIR/LLVM Configuration
#-------------------------------------------------------------------------------

find_package(MLIR REQUIRED CONFIG)

message(STATUS "Using MLIRConfig.cmake in: ${MLIR_DIR}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/bin)
set(LLVM_LIBRARY_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/lib)
set(MLIR_BINARY_DIR ${CMAKE_BINARY_DIR})

list(APPEND CMAKE_MODULE_PATH "${MLIR_CMAKE_DIR}")
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")

include(TableGen)
include(AddLLVM)
include(AddMLIR)
include(HandleLLVMOptions)

#-------------------------------------------------------------------------------
# Catherine configuration
#-------------------------------------------------------------------------------

# Catherine project.
set(PROJECT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(PROJECT_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/bin)
set(PROJECT_EXAMPLES_DIR ${PROJECT_SOURCE_DIR}/examples)
# set(PROJECT_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include/)
set(PROJECT_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/src/)
set(PROJECT_THIRDPARTY_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/thirdparty/include/)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

set(PROJECT_EXAMPLES OFF CACHE BOOL "Build examples")

# Add PROJECT files to the include path
# include_directories(${PROJECT_MAIN_INCLUDE_DIR})
include_directories(${PROJECT_INCLUDE_DIR})
# include_directories(${PROJECT_INCLUDE_DIR}/Interface)
include_directories(${PROJECT_INCLUDE_DIR}/Dialect)
# include_directories(${CMAKE_CURRENT_BINARY_DIR}/include/Dialect)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/src/Dialect)
# include_directories(${CMAKE_CURRENT_BINARY_DIR}/backend/include)
# include_directories(${PROJECT_SOURCE_DIR}/lib)
include_directories(${PROJECT_THIRDPARTY_INCLUDE_DIR})

# Add MLIR and LLVM headers to the include path
include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${MLIR_INCLUDE_DIRS})

link_directories(${LLVM_BUILD_LIBRARY_DIR})
add_definitions(${LLVM_DEFINITIONS})

#-------------------------------------------------------------------------------
# Hardware detection
#-------------------------------------------------------------------------------

# include(${PROJECT_SOURCE_DIR}/cmake/check_simd.cmake)
# include(${PROJECT_SOURCE_DIR}/cmake/check_toolchain.cmake)
# check_simd()
# check_toolchain()

#-------------------------------------------------------------------------------
# Antlr Configuration
#-------------------------------------------------------------------------------
# NB: currently, ANTLR is used in dsl examples only,
# however, there is a plan to use in the frontend,
# so it is kept in the top-level cmake
if(PROJECT_DSL_EXAMPLES)
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Antlr)

    # required if linking to static library
    add_definitions(-DANTLR4CPP_STATIC)

    # add external build for antlrcpp
    include(ExternalAntlr4Cpp)
    # add antrl4cpp artifacts to project environment
    include_directories(${ANTLR4_INCLUDE_DIRS})

    # set variable pointing to the antlr tool that supports C++
    # this is not required if the jar file can be found under PATH environment
    set(ANTLR_EXECUTABLE ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/antlr/antlr-4.10.1-complete.jar)
    # add macros to generate ANTLR Cpp code from grammar
    find_package(ANTLR REQUIRED)
endif()
#-------------------------------------------------------------------------------
# Directory setup
#-------------------------------------------------------------------------------

# add_subdirectory(cmake)
# add_subdirectory(include)
# add_subdirectory(lib)
add_subdirectory(src)
# add_subdirectory(tools)
# add_subdirectory(examples)
# add_subdirectory(tests)
# add_subdirectory(frontend)
# add_subdirectory(backend)
