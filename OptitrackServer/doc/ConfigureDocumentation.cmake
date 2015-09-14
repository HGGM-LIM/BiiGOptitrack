# Add a target to generate API documentation with Doxygen

# This line search for Doxygen for documentation creation
find_package(Doxygen)

if(${PROJECT_NAME}_BUILD_DOCUMENTATION)
    if(NOT DOXYGEN_FOUND)
        message(FATAL_ERROR "Doxygen is needed to build the documentation.")
    endif()

    set(doxyfile_in ${CMAKE_CURRENT_SOURCE_DIR}/doc/Doxyfile.in)
    set(doxyfile ${CMAKE_CURRENT_BINARY_DIR}/doc/Doxyfile)

    # Create the doxyfile in the binary dir
    configure_file(${doxyfile_in} ${doxyfile} @ONLY)

    # This create a new command for the target project
    # and will create the doxygen documentation
    add_custom_command(
        TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${DOXYGEN_EXECUTABLE} ${doxyfile}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generating API documentation with Doxygen"
        VERBATIM)

    # This will copy files from documentation to install/doc
    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html DESTINATION ${${PROJECT_NAME}_INSTALL_DIR}/doc/${PROJECT_NAME})

endif()
