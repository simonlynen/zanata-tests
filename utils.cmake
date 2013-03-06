IF(NOT _UTILS_CMAKE_)
    SET(_UTILS_CMAKE_ "DEFINED")

    # REAL_PATH(absolutePathToBeReturn path)
    FUNCTION(REAL_PATH var path)
	IF (${path} MATCHES "^/")
	    SET(${var} "${path}" PARENT_SCOPE)
	ELSEIF(${path} MATCHES "(^~[^/]*/)(.*)")
	    IF(CMAKE_MATCH_1 STREQUAL "~/")
		SET(${var} "${HOME}/${CMAKE_MATCH_2}" PARENT_SCOPE)
	    ELSE(CMAKE_MATCH_1 STREQUAL "~/")
		FILE(TO_NATIVE_PATH "${path}" _var)
		SET(${var} "${_var}" PARENT_SCOPE)
	    ENDIF(CMAKE_MATCH_1 STREQUAL "~/")
	ELSE(${path} MATCHES "^/")
	    SET(${var} "${CMAKE_SOURCE_DIR}/${path}" PARENT_SCOPE)
	ENDIF(${path} MATCHES "^/")
    ENDFUNCTION(REAL_PATH var path)

    MACRO(REQUIRE_CMD var cmd)
	FIND_PROGRAM(${var} "${cmd}" ${ARGN})
        IF("${${var}}" MATCHES "NOTFOUND$")
	   MESSAGE(FATAL "${cmd} is not installed")
	ENDIF("${${var}}" MATCHES "NOTFOUND$")
    ENDMACRO(REQUIRE_CMD var cmd)

    MACRO(SELENIUM_GENERATE var cmd target value)
	SET(${var} "<tr>\n  <td>${cmd}</td>\n  <td>${target}</td>\n  <td>${value}</td>\n</tr>")
    ENDMACRO(SELENIUM_GENERATE var cmd target value)

    MACRO(SELENIUM_APPEND var cmd target value)
	IF("${${var}}" STREQUAL "")
	    SELENIUM_GENERATE(${var} "${cmd}" "${target}" "${value}")
	ELSE("${${var}}" STREQUAL "")
	    SELENIUM_GENERATE(_cmd "${cmd}" "${target}" "${value}")
	    SET(${var} "${${var}}\n${_cmd}")
	ENDIF("${${var}}" STREQUAL "")
    ENDMACRO(SELENIUM_APPEND var cmd target value)

    # Always build when making the target, also specify the output files
    # ADD_CUSTOM_TARGET_COMMAND(target OUTPUT [file1 [file2 ..]]] COMMAND ...)
    MACRO(ADD_CUSTOM_TARGET_COMMAND target OUTPUT)
	SET(_outputFileList "")
	SET(_optionList "")
	SET(_outputFileMode 1)
	FOREACH(_t ${ARGN})
	    IF(_outputFileMode)
		IF(_t STREQUAL "COMMAND")
		    SET(_outputFileMode 0)
		    LIST(APPEND _optionList "${_t}")
		ELSE(_t STREQUAL "COMMAND")
		    LIST(APPEND _outputFileList "${_t}")
		ENDIF(_t STREQUAL "COMMAND")
	    ELSE(_outputFileMode)
		LIST(APPEND _optionList "${_t}")
	    ENDIF(_outputFileMode)
	ENDFOREACH(_t ${ARGN})
	ADD_CUSTOM_TARGET(${target} ${_optionList})
	ADD_CUSTOM_COMMAND(OUTPUT ${_outputFileList}  ${_optionList})
    ENDMACRO(ADD_CUSTOM_TARGET_COMMAND)

ENDIF(NOT _UTILS_CMAKE_)

