# Author: Eugenio Marinetto [nenetto@gmail.com]

#### Code SRC and inc
# Change your src files into src folder
# Change your header files into inc folder

#### Installed files
# The project will create an install folder after compilation
# All files into install folder will be copied there too.


######################################
# Minimum version of CMake required ##
######################################

# Minimum version of CMake required
cmake_minimum_required (VERSION 3.0.2)

#############################
# Creation of the project  ##
#############################
set(PROJECT_NAME "BiiGOptitrackControl")
project(${PROJECT_NAME})

# Version Control of the project
set (${PROJECT_NAME}_VERSION_MAJOR 0)
set (${PROJECT_NAME}_VERSION_MINOR 0)
message("Version: ${${PROJECT_NAME}_VERSION_MAJOR}.${${PROJECT_NAME}_VERSION_MINOR}")


###############################
# Options for Configuration  ##
###############################
set(${PROJECT_NAME}_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "InstaLL DIR")
# Create an option of the project for documentation option set
option(${PROJECT_NAME}_BUILD_DOCUMENTATION "Create and install the HTML based API documentation (requires Doxygen)" OFF)
option(${PROJECT_NAME}_CMAKE_DEBUG_FLAG "Create and install the HTML based API documentation (requires Doxygen)" ON)
#set(${PROJECT_NAME}_LIB_BIN "NONE" CACHE PATH "Library to link to" FORCE)
set(NPTrackingTools_DIR "NOTFOUND" CACHE PATH "NPTrackingTools folder")
set(tinyxml2_DIR "NOTFOUND" CACHE PATH "tinyxml2 folder")
set(ITK_DIR "NOTFOUND" CACHE PATH "ITK folder")

# Create  library
option(${PROJECT_NAME}_BUILD_SHARED "Determines if the library is a shared library or not" FALSE)

if(${PROJECT_NAME}_BUILD_SHARED)
    set(${PROJECT_NAME}_BUILD_SHARED_FLAG 1)
else()
    set(${PROJECT_NAME}_BUILD_SHARED_FLAG 0)
endif()

if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    set(${PROJECT_NAME}_CMAKE_DEBUG 1)
else()
    set(${PROJECT_NAME}_CMAKE_DEBUG 0)
endif()


if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("Configuring Project: ${PROJECT_NAME}")
    message("    Extra Variables already set thanks to project command")
    message("         Extra Variables already set thanks to project command:")
    message("         PROJECT_NAME: ${PROJECT_NAME}")
    message("         PROJECT_SOURCE_DIR: ${PROJECT_SOURCE_DIR}")
    message("         PROJECT_BINARY_DIR: ${PROJECT_BINARY_DIR}")
    message("         ${PROJECT_NAME}_SOURCE_DIR: ${${PROJECT_NAME}_SOURCE_DIR}")
    message("         ${PROJECT_NAME}_BINARY_DIR: ${${PROJECT_NAME}_BINARY_DIR}")

    message("         CMAKE_PROJECT_NAME: ${CMAKE_PROJECT_NAME}")
    message("         CMAKE_SOURCE_DIR: ${CMAKE_SOURCE_DIR}")
    message("         CMAKE_BINARY_DIR: ${CMAKE_BINARY_DIR}")
    message("         CMAKE_COMMAND: ${CMAKE_COMMAND}")
    message("         CMAKE_CURRENT_SOURCE_DIR: ${CMAKE_CURRENT_SOURCE_DIR}")
    message("         CMAKE_CURRENT_BINARY_DIR: ${CMAKE_CURRENT_BINARY_DIR}")
    message("         CMAKE_CURRENT_LIST_FILE: ${CMAKE_CURRENT_LIST_FILE}")
    message("         CMAKE_CURRENT_LIST_DIR: ${CMAKE_CURRENT_LIST_DIR}")
    message("         CMAKE_CURRENT_LIST_LINE: ${CMAKE_CURRENT_LIST_LINE}")
    message("         CMAKE_FILES_DIRECTORY: ${CMAKE_FILES_DIRECTORY}")
    message("         CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")
    message("         CMAKE_ROOT: ${CMAKE_ROOT}")
endif()


###########################################
# Create files during configuration time ##
###########################################
configure_file (
  "${PROJECT_SOURCE_DIR}/CMake/Config.h.in"
  "${PROJECT_BINARY_DIR}/CmakeFilesHeader/BiiGOptitrackControlConfig.h"
  FORCE)
if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Creating configuration file Config.h in ${PROJECT_BINARY_DIR}/CmakeFilesHeader/BiiGOptitrackControlConfig.h")
endif()

#################################
# Add cpp that project contain ##
#################################
file(GLOB ${PROJECT_NAME}_SOURCE_FILES ${PROJECT_SOURCE_DIR}/src/*.*)
if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Adding source files: ${${PROJECT_NAME}_SOURCE_FILES}")
endif()

######################################
# Add headers that project contain  ##
######################################
file(GLOB ${PROJECT_NAME}_SOURCE_HDR_FILES ${PROJECT_SOURCE_DIR}/inc/*.h)
if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Adding header files: ${${PROJECT_NAME}_SOURCE_HDR_FILES}")
endif()

# Headers created during confirugation time
file(GLOB ${PROJECT_NAME}_CMAKE_HDR_FILES ${PROJECT_BINARY_DIR}/CmakeFilesHeader/*.h)
if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Adding Configured header files: ${${PROJECT_NAME}_CMAKE_HDR_FILES}")
endif()

# Join all headers together
list(APPEND ${PROJECT_NAME}_HDR_FILES ${${PROJECT_NAME}_SOURCE_HDR_FILES} ${${PROJECT_NAME}_CMAKE_HDR_FILES})
if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Total header list: ${${PROJECT_NAME}_HDR_FILES}")
endif()

###############################
# Configure Project includes ##
###############################
include_directories(${PROJECT_SOURCE_DIR}/inc)
if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Adding include folder")
endif()

include_directories(${PROJECT_BINARY_DIR}/CmakeFilesHeader)
if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Adding Configured header folder: ${PROJECT_BINARY_DIR}/CmakeFilesHeader")
endif()

#########################
# Configure Library ##
#########################
if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Creating Library: ${PROJECT_NAME} using sources ${${PROJECT_NAME}_SOURCE_FILES} and ${${PROJECT_NAME}_HDR_FILES}")
endif()

if(${PROJECT_NAME}_BUILD_SHARED)

    if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
        message("    Creating Library: ${PROJECT_NAME} SHARED")
    endif()

    add_library(${PROJECT_NAME} SHARED ${${PROJECT_NAME}_SOURCE_FILES} ${${PROJECT_NAME}_HDR_FILES})

    ###########################################
    # Create header for exports              ##
    ###########################################
    include (GenerateExportHeader)
    # We generate the Exports header using the name of the library
    generate_export_header(${PROJECT_NAME}
                 BASE_NAME ${PROJECT_NAME}
                 EXPORT_MACRO_NAME ${PROJECT_NAME}_EXPORT
                 EXPORT_FILE_NAME ${PROJECT_BINARY_DIR}/CmakeFilesHeader/${PROJECT_NAME}_Export.h
                 STATIC_DEFINE ${PROJECT_NAME}_BUILT_AS_STATIC
    )

list(APPEND ${PROJECT_NAME}_HDR_FILES ${PROJECT_BINARY_DIR}/CmakeFilesHeader/${PROJECT_NAME}_Export.h)

else()

    if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
        message("    Creating Library: ${PROJECT_NAME} STATIC")
    endif()

    add_library(${PROJECT_NAME} STATIC ${${PROJECT_NAME}_SOURCE_FILES} ${${PROJECT_NAME}_HDR_FILES})
endif()

set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE CXX)



# Add Export header to the HDR files
# Join all headers together and make them public.
set(${PROJECT_NAME}_PUBLIC_HEADERS ${${PROJECT_NAME}_HDR_FILES})

# The minimum option for public header
#set(${PROJECT_NAME}_PUBLIC_HEADERS
#    ${PROJECT_SOURCE_DIR}/inc/BiiGOptitrackControlPublicHeader.h
#    ${PROJECT_BINARY_DIR}/CmakeFilesHeader/${PROJECT_NAME}_Export.h
#    ${PROJECT_BINARY_DIR}/CmakeFilesHeader/BiiGOptitrackControlConfig.h)

set_target_properties(${PROJECT_NAME} PROPERTIES PUBLIC_HEADER "${${PROJECT_NAME}_PUBLIC_HEADERS}")


if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Creating Exports file ${PROJECT_NAME}_Export.h in ${PROJECT_BINARY_DIR}/CmakeFilesHeader/${PROJECT_NAME}_Export.h")
endif()


###########################
# Configure Config.cmake ##
###########################
# Include folders
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/inc" "${PROJECT_BINARY_DIR}/CmakeFilesHeader")
# Source folders
set(CONF_SOURCE_DIRS ${PROJECT_SOURCE_DIR})
# Library names
set(CONF_LIBRARY ${PROJECT_NAME})
# Library Folders
set(CONF_LIBRARY_DIRS "${${PROJECT_NAME}_INSTALL_DIR}/lib" "${${PROJECT_NAME}_INSTALL_DIR}/bin")
# Binary folder
set(CONF_BINARY_DIR "${PROJECT_BINARY_DIR}")
# Build folder
set(CONF_BUILD_DIR "${PROJECT_BINARY_DIR}")
# Install folder
set(CONF_INSTALL_DIR "${${PROJECT_NAME}_INSTALL_DIR}")
# Flag for libraries
set(CONF_SHARED ON)
# Definition of the project (options)
set(CONF_DEFINITIONS
    -DCMAKE_DEBUG_FLAG:BOOL=${${PROJECT_NAME}_CMAKE_DEBUG_FLAG})
# Executables names
set(CONF_EXECUTABLES "")
set(CONF_EXECUTABLES_DIRS "")

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

##################################################
# Config File if INSTALL target and installation #
##################################################

install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}-targets
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        PUBLIC_HEADER DESTINATION inc
        )


#################################################################
# Config File that will be used if the package is not installed #
#################################################################

export(TARGETS ${PROJECT_NAME} FILE "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake")
export(PACKAGE ${PROJECT_NAME})
##############################################
# Configure Config.cmake for install folder ##
##############################################
# Include folders
set(CONF_INCLUDE_DIRS "${${PROJECT_NAME}_INSTALL_DIR}/inc")
# Source folders
set(CONF_SOURCE_DIRS "")
# Library names
set(CONF_LIBRARY ${PROJECT_NAME})
# Library Folders
set(CONF_LIBRARY_DIRS "${${PROJECT_NAME}_INSTALL_DIR}/lib" "${${PROJECT_NAME}_INSTALL_DIR}/bin")
# Binary folder
set(CONF_BINARY_DIR "${${PROJECT_NAME}_INSTALL_DIR}/bin")
# Build folder
set(CONF_BUILD_DIR "${PROJECT_BINARY_DIR}")
# Install folder
set(CONF_INSTALL_DIR "${${PROJECT_NAME}_INSTALL_DIR}")
# Flag for libraries
set(CONF_SHARED ${${PROJECT_NAME}_BUILD_SHARED})
# Definition of the project (options)
set(CONF_DEFINITIONS
    -DCMAKE_DEBUG_FLAG:BOOL=${${PROJECT_NAME}_CMAKE_DEBUG_FLAG})
# Executables names
set(CONF_EXECUTABLES_DIRS "install/bin")

if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Creating Config File ${PROJECT_NAME}Config.cmake into ${${PROJECT_NAME}_INSTALL_DIR}/${PROJECT_NAME}Config.cmake")
endif()
# Create the file
configure_file("${PROJECT_SOURCE_DIR}/CMake/Config.cmake.in" "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigInstall.cmake" @ONLY)
configure_file("${PROJECT_SOURCE_DIR}/CMake/ConfigInstall.cmake.in" "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigInstallScript.cmake" @ONLY)
configure_file("${PROJECT_SOURCE_DIR}/CMake/FilesToBeCopiedDuringInstall.cmake.in" "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigInstallFilesScript.cmake" @ONLY)
# Copy the file to the install folder
install (SCRIPT "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigInstallScript.cmake")
install (SCRIPT "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigInstallFilesScript.cmake")
###################
# Documentation  ##
###################
if(${PROJECT_NAME}_BUILD_DOCUMENTATION)
    include("${PROJECT_SOURCE_DIR}/doc/ConfigureDocumentation.cmake")
endif()


###############################
# Search for NPTrackingTools ##
###############################
set(LIB_NAME "NPTrackingTools")
set(LIB_PATH ${${PROJECT_NAME}_LIB_BIN})
find_package(${LIB_NAME} REQUIRED PATH ${LIB_PATH})

# Link to libraries
target_link_libraries(${PROJECT_NAME} ${LIB_NAME})
# Include directories
include_directories(${${LIB_NAME}_INCLUDE_DIRS})
if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Adding Library header folder: ${${LIB_NAME}_INCLUDE_DIRS}")
endif()

# Copy Dll after build
if(${CMAKE_GENERATOR} MATCHES "Visual Studio" )
    add_custom_command(TARGET ${PROJECT_NAME}
                        POST_BUILD
                        COMMAND ${CMAKE_COMMAND} -DLIB_BIN=${${LIB_NAME}_BINARY_DIR} -DBIN_DIR=${PROJECT_BINARY_DIR} -P ${PROJECT_SOURCE_DIR}/CMake/CopyDll.cmake
                        )
endif()



###############################
# Search for ITK ##
###############################
set(LIB_NAME "ITK")
find_package(${LIB_NAME} REQUIRED)
include(${ITK_USE_FILE})

# Link to libraries
target_link_libraries(${PROJECT_NAME} ${ITK_LIBRARIES})
# Include directories
include_directories(${${LIB_NAME}_INCLUDE_DIRS})
if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Adding Library header folder: ${${LIB_NAME}_INCLUDE_DIRS}")
endif()

# Copy Dll after build
if(${CMAKE_GENERATOR} MATCHES "Visual Studio" )
    add_custom_command(TARGET ${PROJECT_NAME}
                        POST_BUILD
                        COMMAND ${CMAKE_COMMAND} -DLIB_BIN=${${LIB_NAME}_BINARY_DIR} -DBIN_DIR=${PROJECT_BINARY_DIR} -P ${PROJECT_SOURCE_DIR}/CMake/CopyDll.cmake
                        )
endif()



###############################
# Search for tinyxml2 ##
###############################
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/CMake")
set(LIB_NAME "tinyxml2")
set(LIB_PATH ${${PROJECT_NAME}_LIB_BIN})
find_package(${LIB_NAME} REQUIRED PATH ${LIB_PATH})

# Link to libraries
target_link_libraries(${PROJECT_NAME} ${tinyxml2_LIBRARY})
# Include directories
include_directories(${tinyxml2_INCLUDE_DIR})
if(${PROJECT_NAME}_CMAKE_DEBUG_FLAG)
    message("    Adding Library header folder: ${${LIB_NAME}_INCLUDE_DIRS}")
endif()

# Copy Dll after build
if(${CMAKE_GENERATOR} MATCHES "Visual Studio" )
    add_custom_command(TARGET ${PROJECT_NAME}
                        POST_BUILD
                        COMMAND ${CMAKE_COMMAND} -DLIB_BIN=${${LIB_NAME}_BINARY_DIR} -DBIN_DIR=${PROJECT_BINARY_DIR} -P ${PROJECT_SOURCE_DIR}/CMake/CopyDll.cmake
                        )
endif()