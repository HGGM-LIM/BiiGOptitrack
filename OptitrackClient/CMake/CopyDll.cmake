# Copy Dll if need
# Copy libraries

message("Copying Dll...")
message("       From: " ${LIB_BIN})
message("       To:   " ${BIN_DIR})

if(EXISTS ${LIB_BIN}/Release)
    file(COPY
        ${LIB_BIN}/Release/
        DESTINATION ${BIN_DIR}/Release
        FILES_MATCHING REGEX .*dll
    )
    file(COPY
        ${LIB_BIN}/Release/
        DESTINATION ${BIN_DIR}/install/bin
        FILES_MATCHING REGEX .*dll
    )
endif()

if(EXISTS ${LIB_BIN}/Debug)
    file(COPY
        ${LIB_BIN}/Debug/
        DESTINATION ${BIN_DIR}/Debug
        FILES_MATCHING REGEX .*dll
    )
endif()

if(EXISTS ${LIB_BIN}/RelWithDebInfo)
    file(COPY
        ${LIB_BIN}/RelWithDebInfo/
        DESTINATION ${BIN_DIR}/RelWithDebInfo
        FILES_MATCHING REGEX .*dll
    )
endif()

if(EXISTS ${LIB_BIN}/MinSizeRel)
    file(COPY
        ${LIB_BIN}/MinSizeRel/
        DESTINATION ${BIN_DIR}/MinSizeRel
        FILES_MATCHING REGEX .*dll
    )
endif()