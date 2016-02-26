# Author: Eugenio Marinetto [nenetto@gmail.com]

# This is an example file for a Project Configuration
# using CMake.

######################################
# Minimum version of CMake required ##
######################################
cmake_minimum_required(VERSION 3.0.2)
if(POLICY CMP0054)
  cmake_policy(SET CMP0054 NEW)
endif()

#############################
# Creation of the project  ##
#############################
set(PROJECT_NAME "BiiGOptitrack" CACHE STRING "")
project(${PROJECT_NAME})

# Version Control of the project
set (${PROJECT_NAME}_VERSION_MAJOR 2)
set (${PROJECT_NAME}_VERSION_MINOR 0)
message("Version: ${${PROJECT_NAME}_VERSION_MAJOR}.${${PROJECT_NAME}_VERSION_MINOR}")


###############################
# Options for Configuration  ##
###############################
set(${PROJECT_NAME}_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "InstaLL DIR" FORCE)
# Create an option of the project for documentation option set
option(${PROJECT_NAME}_BUILD_DOCUMENTATION "Create and install the HTML based API documentation (requires Doxygen)" OFF)
option(${PROJECT_NAME}_CMAKE_DEBUG_FLAG "Create and install the HTML based API documentation (requires Doxygen)" ON)
# Create variable for packing 
option(${PROJECT_NAME}_BUILD_PACKAGING "Support for CPack packaging" OFF)

# BiiGOptitrack Options
option(${PROJECT_NAME}_USE_FAKE_NPAPI "Fake Library NPTrackingTools" OFF)
set(${PROJECT_NAME}_ITK_EXTERNAL_DIR "NOT-FOUND" CACHE PATH "ITK DIR")
set(${PROJECT_NAME}_OpenIGTLink_EXTERNAL_DIR "NOT-FOUND" CACHE PATH "OpenIGTLink DIR")
set(${PROJECT_NAME}_tinyxml2_EXTERNAL_DIR "NOT-FOUND" CACHE PATH "timyxml2 DIR")


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

###########################
# Configure Config.cmake ##
###########################
# Include folders
set(CONF_INCLUDE_DIRS "${${PROJECT_NAME}_INSTALL_DIR}/inc")
# Include files
file(GLOB CONF_INCLUDE_FILES ${CONF_INCLUDE_DIRS}/*.h)
# Source folders
set(CONF_SOURCE_DIRS ${PROJECT_SOURCE_DIR})
# Library names
set(CONF_LIBRARY "")
# Library Folders
set(CONF_LIBRARY_DIRS "${${PROJECT_NAME}_INSTALL_DIR}/lib" "${${PROJECT_NAME}_INSTALL_DIR}/bin")
# Binary folder
set(CONF_BINARY_DIR "${PROJECT_BINARY_DIR}")
# Install folder
set(CONF_INSTALL_DIR "${${PROJECT_NAME}_INSTALL_DIR}")
# Flag for libraries
set(CONF_SHARED OFF)
# Definition of the project (options)
set(CONF_DEFINITIONS
    -DCMAKE_DEBUG_FLAG:BOOL=${${PROJECT_NAME}_CMAKE_DEBUG_FLAG})
# Executables names
set(CONF_EXECUTABLES "")
set(CONF_EXECUTABLES_DIRS "${${PROJECT_NAME}_INSTALL_DIR}/lib")

if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Creating Config File ${PROJECT_NAME}Config.cmake into ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake")
endif()
configure_file("${PROJECT_SOURCE_DIR}/CMake/Config.cmake.in" "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake" @ONLY)

###############################################
# INSTALLATION TARGET and Configuration Files #
###############################################
set(CMAKE_INSTALL_PREFIX ${${PROJECT_NAME}_INSTALL_DIR})
if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Defining Install configuration into folder: ${${PROJECT_NAME}_INSTALL_DIR}")
endif()

# Create the file
configure_file("${PROJECT_SOURCE_DIR}/CMake/Config.cmake.in" "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigInstall.cmake" @ONLY)
configure_file("${PROJECT_SOURCE_DIR}/CMake/ConfigInstall.cmake.in" "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigInstallScript.cmake" @ONLY)
configure_file("${PROJECT_SOURCE_DIR}/CMake/FilesToBeCopiedDuringInstall.cmake.in" "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigInstallFilesScript.cmake" @ONLY)
# Copy the file to the install folder
install (SCRIPT "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigInstallScript.cmake")
install (SCRIPT "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigInstallFilesScript.cmake")

if(${PROJECT_NAME}_BUILD_PACKAGING)
  set(CPACK_GENERATOR "ZIP")
  set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
  set(CPACK_PACKAGE_VENDOR "E. Marinetto")
  set(CPACK_PACKAGE_VERSION_MAJOR ${${PROJECT_NAME}_VERSION_MAJOR})
  set(CPACK_PACKAGE_VERSION_MINOR ${${PROJECT_NAME}_VERSION_MINOR})
  set(CPACK_PACKAGE_VERSION_PATCH ${${PROJECT_NAME}_VERSION_PATCH})
  set(CPACK_PACKAGE_VERSION ${${PROJECT_NAME}_VERSION})
  cma_package_projects()
endif()

# Documentation
if(${PROJECT_NAME}_BUILD_DOCUMENTATION AND NOT USE_Doxygen)
  message("${PROJECT_NAME}_BUILD_DOCUMENTATION is enabling Doxygen")
  set(USE_Doxygen ON CACHE BOOL "" FORCE)
endif()


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


# configure launcher
cma_configure_launcher("${PROJECT_SOURCE_DIR}/CMake/Launcher.cmake")

cma_launcher_target(Terminal
  NAME run_Terminal)
cma_launcher_shortcut(Terminal
  NAME Terminal)

