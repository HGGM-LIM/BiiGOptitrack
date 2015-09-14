# Author: Eugenio Marinetto [nenetto@gmail.com]

# This is an example file for a Project Configuration
# using CMake.

######################################
# Minimum version of CMake required ##
######################################
cmake_minimum_required(VERSION 3.0.2)

#############################
# Creation of the project  ##
#############################
set(MYPROJECT_NAME "BiiGOptitrack" CACHE STRING "")
project(${MYPROJECT_NAME})

# Version Control of the project
set (${MYPROJECT_NAME}_VERSION_MAJOR 0)
set (${MYPROJECT_NAME}_VERSION_MINOR 0)
message("Version: ${${MYPROJECT_NAME}_VERSION_MAJOR}.${${MYPROJECT_NAME}_VERSION_MINOR}")


###############################
# Options for Configuration  ##
###############################
set(${PROJECT_NAME}_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "InstaLL DIR" FORCE)
# Create an option of the project for documentation option set
option(${PROJECT_NAME}_BUILD_DOCUMENTATION "Create and install the HTML based API documentation (requires Doxygen)" OFF)
option(${PROJECT_NAME}_CMAKE_DEBUG_FLAG "Create and install the HTML based API documentation (requires Doxygen)" ON)
option(${PROJECT_NAME}_USE_FAKE_NPAPI "Fake Library NPTrackingTools" ON)
set(${PROJECT_NAME}_ITK_EXTERNAL_DIR "NOTFOUND" CACHE PATH "ITK DIR")
set(${PROJECT_NAME}_OpenIGTLink_EXTERNAL_DIR "NOTFOUND" CACHE PATH "OpenIGTLink DIR")
set(${PROJECT_NAME}_tinyxml2_EXTERNAL_DIR "NOTFOUND" CACHE PATH "timyxml2 DIR")

###############################
# Look for CMakeAll          ##
###############################
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/CMake")
find_package(CMakeAll REQUIRED)


###############################
# Configure Projects         ##
###############################

file(GLOB ${PROJECT_NAME}_PROJECTS "${PROJECT_SOURCE_DIR}/Projects/*.cmake")
cma_add_projects(${${PROJECT_NAME}_PROJECTS})

cma_print_projects()
message(STATUS "${PROJECT_NAME} ${${PROJECT_NAME}_VERSION}")

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang" AND APPLE)
  set(CMAKE_CXX_FLAGS "-stdlib=libstdc++ ${CMAKE_CXX_FLAGS}")
endif()

cma_configure_projects()


# configure files
file(WRITE ${PROJECT_BINARY_DIR}/CMake.h "#ifndef __CMake_h\n#define __CMake_h\n\n")
file(WRITE ${PROJECT_BINARY_DIR}/CMake.py "")
file(WRITE ${PROJECT_BINARY_DIR}/CMake.m "")
get_cmake_property(VARIABLES VARIABLES)
foreach (KEY ${VARIABLES})
  if(KEY MATCHES "^${PROJECT_NAME}_")
    file(TO_NATIVE_PATH "${${KEY}}" VALUE)
    if(WIN32)
      string(REPLACE "\\" "\\\\" VALUE "${VALUE}")
    endif()
    file(APPEND ${PROJECT_BINARY_DIR}/CMake.h "#define ${KEY} \"${VALUE}\"\n")
    file(APPEND ${PROJECT_BINARY_DIR}/CMake.py "${KEY} = '${VALUE}'\n")
    file(APPEND ${PROJECT_BINARY_DIR}/CMake.m "${KEY} = '${VALUE}';\n")
  endif()
endforeach()
file(APPEND ${PROJECT_BINARY_DIR}/CMake.h "\n#endif  // __CMake_h\n")


