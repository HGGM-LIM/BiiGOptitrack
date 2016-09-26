# Author: Eugenio Marinetto
# Date: 2015-01-16

# Find Libraries for TrackingTools API


# -----------------------------------------------------------------------------
if( NOT WIN32)

    set(EP_OPTION_NAME OFF)
    message("Optitrack only have API dinamic link libraries for Windows Systems. Please complain to: http://forums.naturalpoint.com/" )
    set(TrackingToolsAPI_FOUND OFF)
    mark_as_advanced( FORCE
        TrackingToolsAPI_FOUND)

else()

    # Find Tracking Tools installation
    find_path(TrackingToolsAPI_DIR Motive.exe
          DOC  "Include directory of the Optitrack library."
          HINT "C:/Program Files/OptiTrack/Motive"
          )

    if(TrackingToolsAPI_DIR)
      #message("[OK] Optitrack Tracking Tools found @ ${TrackingToolsAPI_DIR}")
    else()
      message("[FAIL] Optitrack Tracking Tools NOT found, please set TrackingToolsAPI_DIR")
    endif()

    # Find Dll library
    find_path(TrackingToolsAPI_LIB_DIR NPTrackingToolsx64.dll
          DOC  "Dinamic Link Library of Tracking Tools API NPTrackingToolsx64.dll"
          HINT "${TrackingToolsAPI_DIR}/lib"
          )

    # Find Dll library
    find_path(AMTIUSBDevice_LIB_DIR AMTIUSBDevice.dll
          DOC  "Dinamic Link Library of Tracking Tools API AMTIUSBDevice.dll"
          HINT "${TrackingToolsAPI_DIR}"
          )

    if(TrackingToolsAPI_LIB_DIR)
      #message("[OK] Optitrack Tracking Tools Library directory found @ ${TrackingToolsAPI_LIB_DIR}")
    else()
      message("[FAIL] Optitrack Tracking Tools Library directory NOT found, please set TrackingToolsAPI_LIB_DIR")
    endif()

    # Find Headers file
    find_path(TrackingToolsAPI_INC_DIR NPTrackingTools.h
          DOC  "Dinamic Link Library of Tracking Tools API NPTrackingTools.dll"
          HINT "${TrackingToolsAPI_DIR}/inc"
          )
    if(TrackingToolsAPI_INC_DIR)
      #message("[OK] Optitrack Tracking Tools Include directory found @ ${TrackingToolsAPI_INC_DIR}")
    else()
      message("[FAIL] Optitrack Tracking Tools Include directory NOT found, please set TrackingToolsAPI_INC_DIR")
    endif()

    set(TrackingToolsAPI_INC "${TrackingToolsAPI_INC_DIR}/NPTrackingTools.h")
    set(TrackingToolsAPI_INC2 "${TrackingToolsAPI_INC_DIR}/trackablesettings.h")

    # Load the proper library x64 or x32
    if( CMAKE_SIZEOF_VOID_P EQUAL 8 )
      find_file(TrackingToolsAPI_DLL NPTrackingToolsx64.dll ${TrackingToolsAPI_LIB_DIR})
      find_file(TrackingToolsAPI_LIB_FILE NPTrackingToolsx64.lib ${TrackingToolsAPI_LIB_DIR})
      find_file(AMTIUSBDevice_LIB_FILE AMTIUSBDevice.dll ${AMTIUSBDevice_LIB_DIR})
      
      set(TrackingToolsAPI_LIB "NPTrackingToolsx64")

    else( CMAKE_SIZEOF_VOID_P EQUAL 8 )
      find_file(TrackingToolsAPI_DLL NPTrackingTools.dll ${TrackingToolsAPI_LIB_DIR})
      find_file(TrackingToolsAPI_LIB_FILE NPTrackingTools.lib ${TrackingToolsAPI_LIB_DIR})
      set(TrackingToolsAPI_LIB "NPTrackingTools")

    endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )

    if(TrackingToolsAPI_LIB_FILE AND TrackingToolsAPI_DLL)
      #message("[OK] Optitrack Tracking Tools Library found @ ${TrackingToolsAPI_LIB}")
    else()
      message("[FAIL] Optitrack Tracking Tools Library NOT found, please set TrackingToolsAPI_LIB")
      unset(TrackingToolsAPI_LIB CACHE)
    endif()

    # Find Headers file
    find_path(TrackingToolsAPI_EXE Motive.exe
          DOC  "TrackingTools application"
          HINT "${TrackingToolsAPI_DIR}"
          )
    if(TrackingToolsAPI_EXE)
      #message("[OK] Optitrack Tracking Tools found @ ${TrackingToolsAPI_EXE}")
    else()
      message("[FAIL] Optitrack Tracking Tools NOT found, please set TrackingToolsAPI_EXE")
    endif()

    set(TrackingToolsAPI_EXE "${TrackingToolsAPI_DIR}/TrackingTools.exe")

    # Assume that if include and lib were found
    if(TrackingToolsAPI_DIR
     AND TrackingToolsAPI_LIB_DIR
     AND TrackingToolsAPI_INC_DIR
     AND TrackingToolsAPI_LIB
     AND TrackingToolsAPI_INC
     AND TrackingToolsAPI_DLL
     AND TrackingToolsAPI_INC2
     AND TrackingToolsAPI_EXE
     AND AMTIUSBDevice_LIB_DIR)

    set(TrackingToolsAPI_FOUND "YES" FORCE)
    set(TrackingToolsAPI_INCLUDE_DIRS ${TrackingToolsAPI_INC_DIR} CACHE PATH "" FORCE)
    set(TrackingToolsAPI_SOURCE_DIRS "" CACHE PATH "" FORCE)
    set(TrackingToolsAPI_BINARY_DIRS ${TrackingToolsAPI_DIR} ${TrackingToolsAPI_LIB_DIR} CACHE PATH "" FORCE)
    set(TrackingToolsAPI_EXECUTABLES ${TrackingToolsAPI_EXE} CACHE FILEPATH "" FORCE)
    set(TrackingToolsAPI_LIBRARIES ${TrackingToolsAPI_LIB} CACHE STRING "" FORCE)
    set(TrackingToolsAPI_LIB_DIR ${TrackingToolsAPI_LIB_DIR} CACHE PATH "" FORCE)
    set(TrackingToolsAPI_SHARED ON FORCE)
    set(TrackingToolsAPI_EXECUTABLES_DIRS ${TrackingToolsAPI_DIR} CACHE STRING "" FORCE)
    set(TrackingToolsAPI_INSTALL_DIR ${TrackingToolsAPI_DIR} CACHE STRING "" FORCE)

      mark_as_advanced( FORCE
        TrackingToolsAPI_FOUND
        TrackingToolsAPI_INCLUDE_DIRS
        TrackingToolsAPI_SOURCE_DIRS
        TrackingToolsAPI_BINARY_DIRS
        TrackingToolsAPI_EXECUTABLES
        TrackingToolsAPI_LIBRARIES
        TrackingToolsAPI_SHARED
        TrackingToolsAPI_LIB_DIR
        TrackingToolsAPI_EXECUTABLES_DIRS
        TrackingToolsAPI_INSTALL_DIR
      )


    endif()


endif()

