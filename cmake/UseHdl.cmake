# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
UseHdl
-------

Use Module for HDL

This file provides functions for TclHdl.  It is assumed that
:module:`FindHdl` has already been loaded.  See :module:`FindHdl` for
information on how to load Hdl into your CMake project.

Creating And Installing HDL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: cmake

add_hdl(<target_name>
    [VENDOR <vendor>]
    [TOOL <tool>]
    [SETTINGS <name> [FILES <file>]]
    [REVISION <rev>]
    [OUTPUT_DIR <dir>]
    [OUTPUT_NAME <name>]
    [SOURCES] <source1> [<source2>...]
    [VHDL] <source1> [<source2>...]
    [VHDL_2008] <source1> [<source2>...]
    [VERILOG] <source1> [<source2>...]
    [COEFF] <source1> [<source2>...]
    [TCL] <source1> [<source2>...]
    [TCLHDL] <source1> [<source2>...]
    [PRE] <source1> [<source2>...]
    [POST] <source1> [<source2>...]
    [COREGEN] <source1> [<source2>...]
    [XCI] <source1> [<source2>...]
    [XCO] <source1> [<source2>...]
    [XCO_UPGRADE] <source1> [<source2>...]
    [QSYS] <source1> [<source2>...]
    [IPX] <source1> [<source2>...]
    [COREGEN] <source1> [<source2>...]
    [XCI] <source1> [<source2>...]
    [XCO] <source1> [<source2>...]
    [XCO_UPGRADE] <source1> [<source2>...]
    [QSYS] <source1> [<source2>...]
    [IPX] <source1> [<source2>...]
    [FLOW] <flow>
    [SOURCE_DIR] <dir>
    [IP_DIR] <dir>
    [CONSTRAINT_DIR] <dir>
    [SETTING_DIR] <dir>
    [SCRIPT_DIR] <dir>
    )


Examples
""""""""

To add compile flags to the target you can set these flags with the following
variable:

.. code-block:: cmake

Finding Tools
^^^^^^^^^^^^^

.. code-block:: cmake

find_hdl(<VAR>
    <name> | NAMES <name1> [<name2>...]
    [PATHS <path1> [<path2>... ENV <var>]]
    [VERSIONS <version1> [<version2>]]
    [DOC "cache documentation string"]
    )


#]=======================================================================]

#------------------------------------------------------------------------------
#-- Helper function: Add tclhdl file
#------------------------------------------------------------------------------
function(_tclhdl_add_file)
    cmake_parse_arguments(_tclhdl_add_file "" "FUNCTION;TYPE;OUTPUT" "FILES" ${ARGN})
    set(_type "${_tclhdl_add_file_TYPE}")
    set(_output "${_tclhdl_add_file_OUTPUT}")
    foreach(_file IN LISTS _tclhdl_add_file_FILES)
        set(_name "::tclhdl::${_tclhdl_add_file_FUNCTION} ")
        if (_type)
            string (CONCAT _name ${_name} "\"${_type}\" ")
        endif()
        string (CONCAT _name ${_name} "\"${_file}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${_output} ${_name})
        #message (STATUS "${_name}")
    endforeach()
endfunction()

#------------------------------------------------------------------------------
#-- TCLHDL Project Setup
#------------------------------------------------------------------------------
function(add_hdl _TARGET_NAME)

    cmake_parse_arguments(_add_hdl
        ""
        "VENDOR;TOOL;REVISION;OUTPUT_DIR;OUTPUT_NAME"
        "VHDL;VHDL_2008;VERILOG;COEFF;TCL;TCLHDL;SOURCES;PRE;POST;SETTINGS;TCL_SETTINGS;FLOW;SOURCEDIR;IPDIR;CONSTRAINTDIR;SETTINGDIR;SCRIPTDIR;COREGEN;XCI;XCO;XCO_UPGRADE;QSYS;IPX;UCF;XDC;SDF;LPF"
        ${ARGN}
        )

    if(NOT DEFINED _add_hdl_OUTPUT_DIR AND DEFINED CMAKE_HDL_TARGET_OUTPUT_DIR)
        set(_add_hdl_OUTPUT_DIR "${CMAKE_HDL_TARGET_OUTPUT_DIR}")
    endif()
    if(NOT DEFINED _add_hdl_OUTPUT_NAME AND DEFINED CMAKE_HDL_TARGET_OUTPUT_NAME)
        set(_add_hdl_OUTPUT_NAME "${CMAKE_HDL_TARGET_OUTPUT_NAME}")
        set(CMAKE_HDL_TARGET_OUTPUT_NAME)
    endif()
    if (NOT DEFINED _add_hdl_OUTPUT_DIR)
        set(_add_hdl_OUTPUT_DIR ${CMAKE_BINARY_DIR})
    else()
        get_filename_component(_add_hdl_OUTPUT_DIR ${_add_hdl_OUTPUT_DIR} ABSOLUTE)
    endif()
    if (_add_hdl_SETTINGS)
        list (GET _add_hdl_SETTINGS 0 _add_hdl_SETTINGS_NAME)
        cmake_parse_arguments (_add_hdl_SETTINGS "" "" "FILES" ${_add_hdl_SETTINGS})
    endif()

    string(TOUPPER ${_add_hdl_VENDOR} _vendor)
    string(TOUPPER ${_add_hdl_TOOL} _tool)
    string(CONCAT  _vendor_tool ${_vendor} "_" ${_tool})

    set (_HDL_REVISION 	        ${_add_hdl_REVISION})
    set (_HDL_VHDL_FILES 	    ${_add_hdl_VHDL})
    set (_HDL_VHDL2008_FILES 	${_add_hdl_VHDL_2008})
    set (_HDL_VERILOG_FILES	    ${_add_hdl_VERILOG})
    set (_HDL_COEFF_FILES	    ${_add_hdl_COEFF})
    set (_HDL_TCL_FILES 	    ${_add_hdl_TCL})
    set (_HDL_TCLHDL_FILES 	    ${_add_hdl_TCLHDL})
    set (_HDL_PRE_FILES 	    ${_add_hdl_PRE})
    set (_HDL_POST_FILES 	    ${_add_hdl_POST})
    set (_HDL_SOURCEDIR 	    ${_add_hdl_SOURCEDIR})
    set (_HDL_IPDIR 	        ${_add_hdl_IPDIR})
    set (_HDL_CONSTRAINTDIR 	${_add_hdl_CONSTRAINTDIR})
    set (_HDL_SETTINGDIR 	    ${_add_hdl_SETTINGDIR})
    set (_HDL_SCRIPTDIR 	    ${_add_hdl_SCRIPTDIR})
    set (_HDL_FLOW_FILES 	    ${_add_hdl_FLOW})
    set (_HDL_SETTINGS_NAME 	${_add_hdl_SETTINGS_NAME})
    set (_HDL_SETTINGS_FILES 	${_add_hdl_SETTINGS_FILES})
    set (_HDL_TCL_SETTINGS 	    ${_add_hdl_TCL_SETTINGS})
    set (_HDL_COREGEN_FILES 	${_add_hdl_COREGEN})
    set (_HDL_XCI_FILES 	    ${_add_hdl_XCI})
    set (_HDL_XCO_FILES 	    ${_add_hdl_XCO})
    set (_HDL_XCO_UPGRADE_FILES ${_add_hdl_XCO_UPGRADE})
    set (_HDL_IPX_FILES 	    ${_add_hdl_IPX})
    set (_HDL_UCF_FILES 	    ${_add_hdl_UCF})
    set (_HDL_XDC_FILES 	    ${_add_hdl_XDC})
    set (_HDL_LPF_FILES 	    ${_add_hdl_LPF})
    set (_HDL_SOURCE_FILES 	    ${_add_hdl_SOURCES} ${_add_hdl_UNPARSED_ARGUMENTS})

    set (_HDL_PROJECT_DIR "${CMAKE_BINARY_DIR}/${_TARGET_NAME}")
    set (_HDL_PROJECT_TYPE 	${_vendor_tool})

    set (CMAKE_HDL_TCLHDL_FILE_PROJECT      "${_HDL_PROJECT_DIR}/project")
    set (CMAKE_HDL_TCLHDL_FILE_SOURCE       "${_HDL_PROJECT_DIR}/sources")
    set (CMAKE_HDL_TCLHDL_FILE_IP           "${_HDL_PROJECT_DIR}/ip")
    set (CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS  "${_HDL_PROJECT_DIR}/constraints")
    set (CMAKE_HDL_TCLHDL_FILE_SIMULATION   "${_HDL_PROJECT_DIR}/simulation")
    set (CMAKE_HDL_TCLHDL_FILE_PRE          "${_HDL_PROJECT_DIR}/pre")
    set (CMAKE_HDL_TCLHDL_FILE_POST         "${_HDL_PROJECT_DIR}/post")
    set (CMAKE_HDL_TCLHDL_FILE_BUILD        "${_HDL_PROJECT_DIR}/build")
    set (CMAKE_HDL_TCLHDL_FILE_SETTINGS     "${_HDL_PROJECT_DIR}/settings")

    #-- Create Project Directory
    file (MAKE_DIRECTORY "${_HDL_PROJECT_DIR}")

    #-- Create TclHdl file structure
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_PROJECT})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_IP})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_SIMULATION})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_PRE})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_POST})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_BUILD})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_SETTINGS})

    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_PROJECT} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_SOURCE} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_IP} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_SIMULATION} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_PRE} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_POST} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_BUILD} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_SETTINGS} "")

    #-- Set project file environment
    set (_name "::tclhdl::set_project_name \"${_TARGET_NAME}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_project_type \"${_HDL_PROJECT_TYPE}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_source_dir \"${_HDL_SOURCEDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_ip_dir \"${_HDL_IPDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_constraint_dir \"${_HDL_CONSTRAINTDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_settings_dir \"${_HDL_SETTINGDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_scripts_dir \"${_HDL_SCRIPTDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})

    #-- Add project tclhdl project
    set (_name "::tclhdl::add_project \"${_TARGET_NAME}\" \"${_HDL_SETTINGS_NAME}\" \"${_HDL_REVISION}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})

    #-- Add project fetch procedures
    set (_name "::tclhdl::fetch_pre\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::fetch_ips\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::fetch_sources\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::fetch_constraints\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::fetch_simulations\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::fetch_post\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})

    #-- Add sources
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "VHDL"                FILES ${_HDL_VHDL_FILES}        OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "VHDL 2008"           FILES ${_HDL_VHDL2008_FILES}    OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "VERILOG"             FILES ${_HDL_VERILOG_FILES}     OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "COEFF"               FILES ${_HDL_COEFF_FILES}       OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "TCL"                 FILES ${_HDL_TCL_FILES}         OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "TCLHDL"              FILES ${_HDL_TCLHDL_FILES}      OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_pre"        TYPE ""                    FILES ${_HDL_PRE_FILES}         OUTPUT ${CMAKE_HDL_TCLHDL_FILE_PRE})
    _tclhdl_add_file (FUNCTION "add_post"       TYPE ""                    FILES ${_HDL_POST_FILES}        OUTPUT ${CMAKE_HDL_TCLHDL_FILE_POST})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "COREGEN"             FILES ${_HDL_COREGEN_FILES}     OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "XCI"                 FILES ${_HDL_XCI_FILES}         OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "XCO"                 FILES ${_HDL_XCO_FILES}         OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "XCO_UPGRADE"         FILES ${_HDL_XCO_UPGRADE_FILES} OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "QSYS"                FILES ${_HDL_QSYS_FILES}        OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "IPX"                 FILES ${_HDL_IPX_FILES}         OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_constraint" TYPE "UCF"                 FILES ${_HDL_UCF_FILES}         OUTPUT ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS})
    _tclhdl_add_file (FUNCTION "add_constraint" TYPE "XDC"                 FILES ${_HDL_XDC_FILES}         OUTPUT ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS})
    _tclhdl_add_file (FUNCTION "add_constraint" TYPE "LPF"                 FILES ${_HDL_LPF_FILES}         OUTPUT ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS})
    _tclhdl_add_file (FUNCTION "add_settings"   TYPE ${_HDL_SETTINGS_NAME} FILES ${_HDL_SETTINGS_FILES}    OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SETTINGS})
    _tclhdl_add_file (FUNCTION "fetch_settings" TYPE ""                    FILES ${_HDL_TCL_SETTINGS}      OUTPUT ${CMAKE_HDL_TCLHDL_FILE_PROJECT})

    #-- Add build flow
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_FLOW_FILES)
        set(_name "::tclhdl::build_")
        string (CONCAT _name ${_name} "${_HDL_SOURCE_FILE}")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_BUILD} ${_name})
    endforeach()

    #-- Set different tools invoke depending upon OS
    set (CMAKE_HDL_SYSTEM_SOURCE "")
    if (UNIX)
        set (CMAKE_HDL_SYSTEM_SOURCE "source")
    endif ()

    #-- Set the different vendor specific calls
    if ( ${_vendor} STREQUAL "XILINX" )
        #set (XILINX_SOURCE_SETTINGS ${CMAKE_HDL_TOOL_SETTINGS})
        file (TO_NATIVE_PATH ${CMAKE_HDL_TOOL_SETTINGS} XILINX_SOURCE_SETTINGS)
        if ( ${_tool} STREQUAL "VIVADO" )
            set (_VENDOR_TOOL "vivado" "-mode" "tcl" "-notrace" "-source")
            set (_VENDOR_ARGS "-tclargs")
        elseif ( ${_tool} STREQUAL "ISE" )
            set (_VENDOR_TOOL "xtclsh")
            set (_VENDOR_ARGS "")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${XILINX_SOURCE_SETTINGS}")
    elseif ( ${_vendor} MATCHES "Altera|Intel" )
        if ( ${_tool} EQUAL "Quartus" )
            set (_VENDOR_TOOL "quartus_sh")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${INTEL_SOURCE_SETTINGS}")
    elseif ( ${_vendor} STREQUAL "LATTICE" )
        #set (XILINX_SOURCE_SETTINGS ${CMAKE_HDL_TOOL_SETTINGS})
        file (TO_NATIVE_PATH ${CMAKE_HDL_TOOL_SETTINGS} LATTICE_SOURCE_SETTINGS)
        if ( ${_tool} STREQUAL "DIAMOND" )
            set (_VENDOR_TOOL "pnmainc")
            if (UNIX)
                set (_VENDOR_TOOL "diamondc")
            endif ()
            set (_VENDOR_ARGS "")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${LATTICE_SOURCE_SETTINGS}")
    endif ()

    #set (TCLHDL_TOOL ${CMAKE_HDL_TCLHDL})
    file (TO_NATIVE_PATH ${CMAKE_HDL_TCLHDL} TCLHDL_TOOL)
    #if ( ${HAS_TCLHDL} )
    set (_TCLHDL_TOOL       "${TCLHDL_TOOL}")
    set (_TCLHDL_IP         "-generateip")
    set (_TCLHDL_DEBUG      "-debug")
    set (_TCLHDL_PROJECT    "-project")
    set (_TCLHDL_GENERATE   "-generate")
    set (_TCLHDL_BUILD      "-build")
    set (_TCLHDL_REPORT     "-report")
    set (_TCLHDL_BITSTREAM  "-bitstream")
    set (_TCLHDL_PROGRAM    "-program")
    set (_TCLHDL_SHELL      "-shell")
    set (_TCLHDL_CLEAN      "-clean")
    #endif ()

    add_custom_target (${_TARGET_NAME}-shell
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_SHELL} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-ip
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_IP} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-generate
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_GENERATE} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-report
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_BUILD} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-bitstream
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_BITSTREAM} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-program
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_PROGRAM} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-clean
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_CLEAN} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_BUILD} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )
endfunction()

#------------------------------------------------------------------------------
#-- TCLHDL Simulation Project Setup
#------------------------------------------------------------------------------
function(add_hdl_simulation _TARGET_NAME)

    cmake_parse_arguments(_add_hdl_simulation
        ""
        "VENDOR;TOOL;REVISION;OUTPUT_DIR;OUTPUT_NAME"
        "VHDL;VHDL_2008;VERILOG;TCL;TCLHDL;SOURCES;PRE;POST;SOURCEDIR;SCRIPTDIR"
        ${ARGN}
        )

    if(NOT DEFINED _add_hdl_simulation_OUTPUT_DIR AND DEFINED CMAKE_HDL_TARGET_OUTPUT_DIR)
        set(_add_hdl_simulation_OUTPUT_DIR "${CMAKE_HDL_TARGET_OUTPUT_DIR}")
    endif()
    if(NOT DEFINED _add_hdl_simulation_OUTPUT_NAME AND DEFINED CMAKE_HDL_TARGET_OUTPUT_NAME)
        set(_add_hdl_simulation_OUTPUT_NAME "${CMAKE_HDL_TARGET_OUTPUT_NAME}")
        set(CMAKE_HDL_TARGET_OUTPUT_NAME)
    endif()
    if (NOT DEFINED _add_hdl_simulation_OUTPUT_DIR)
        set(_add_hdl_simulation_OUTPUT_DIR ${CMAKE_BINARY_DIR})
    else()
        get_filename_component(_add_hdl_simulation_OUTPUT_DIR ${_add_hdl_simulation_OUTPUT_DIR} ABSOLUTE)
    endif()

    string(TOUPPER ${_add_hdl_simulation_VENDOR} _vendor)
    string(TOUPPER ${_add_hdl_simulation_TOOL} _tool)
    string(CONCAT  _vendor_tool ${_vendor} "_" ${_tool})

    set (_HDL_REVISION 	        ${_add_hdl_simulation_REVISION})
    set (_HDL_VHDL_FILES 	    ${_add_hdl_simulation_VHDL})
    set (_HDL_VHDL2008_FILES 	${_add_hdl_simulation_VHDL_2008})
    set (_HDL_VERILOG_FILES	    ${_add_hdl_simulation_VERILOG})
    set (_HDL_TCL_FILES 	    ${_add_hdl_simulation_TCL})
    set (_HDL_TCLHDL_FILES 	    ${_add_hdl_simulation_TCLHDL})
    set (_HDL_PRE_FILES 	    ${_add_hdl_simulation_PRE})
    set (_HDL_POST_FILES 	    ${_add_hdl_simulation_POST})
    set (_HDL_SOURCEDIR 	    ${_add_hdl_simulation_SOURCEDIR})
    set (_HDL_SCRIPTDIR 	    ${_add_hdl_simulation_SCRIPTDIR})
    set (_HDL_TCL_SETTINGS 	    ${_add_hdl_simulation_TCL_SETTINGS})
    set (_HDL_SOURCE_FILES 	    ${_add_hdl_simulation_SOURCES} ${_add_hdl_simulation_UNPARSED_ARGUMENTS})

    set (_HDL_PROJECT_DIR "${CMAKE_BINARY_DIR}/${_TARGET_NAME}")
    set (_HDL_PROJECT_TYPE 	${_vendor_tool})

    set (CMAKE_HDL_TCLHDL_FILE_PROJECT      "${_HDL_PROJECT_DIR}/project")
    set (CMAKE_HDL_TCLHDL_FILE_SIMULATION   "${_HDL_PROJECT_DIR}/simulation")
    set (CMAKE_HDL_TCLHDL_FILE_PRE          "${_HDL_PROJECT_DIR}/pre")
    set (CMAKE_HDL_TCLHDL_FILE_POST         "${_HDL_PROJECT_DIR}/post")

    #-- Add sources
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "VHDL"                FILES ${_HDL_VHDL_FILES}        OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "VHDL 2008"           FILES ${_HDL_VHDL2008_FILES}    OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "VERILOG"             FILES ${_HDL_VERILOG_FILES}     OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "COEFF"               FILES ${_HDL_COEFF_FILES}       OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "TCL"                 FILES ${_HDL_TCL_FILES}         OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "TCLHDL"              FILES ${_HDL_TCLHDL_FILES}      OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_pre"        TYPE ""                    FILES ${_HDL_PRE_FILES}         OUTPUT ${CMAKE_HDL_TCLHDL_FILE_PRE})
    _tclhdl_add_file (FUNCTION "add_post"       TYPE ""                    FILES ${_HDL_POST_FILES}        OUTPUT ${CMAKE_HDL_TCLHDL_FILE_POST})
    _tclhdl_add_file (FUNCTION "fetch_settings" TYPE ""                    FILES ${_HDL_TCL_SETTINGS}      OUTPUT ${CMAKE_HDL_TCLHDL_FILE_PROJECT})

    #-- Set different tools invoke depending upon OS
    set (CMAKE_HDL_SYSTEM_SOURCE "")
    if (UNIX)
        set (CMAKE_HDL_SYSTEM_SOURCE "source")
    endif ()

    #-- Set the different vendor specific calls
    if ( ${_vendor} STREQUAL "XILINX" )
        #set (XILINX_SOURCE_SETTINGS ${CMAKE_HDL_TOOL_SETTINGS})
        file (TO_NATIVE_PATH ${CMAKE_HDL_TOOL_SETTINGS} XILINX_SOURCE_SETTINGS)
        if ( ${_tool} STREQUAL "VIVADO" )
            set (_VENDOR_TOOL "vivado" "-mode" "tcl" "-notrace" "-source")
            set (_VENDOR_ARGS "-tclargs")
        elseif ( ${_tool} STREQUAL "ISE" )
            set (_VENDOR_TOOL "xtclsh")
            set (_VENDOR_ARGS "")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${XILINX_SOURCE_SETTINGS}")
    elseif ( ${_vendor} MATCHES "Altera|Intel" )
        if ( ${_tool} EQUAL "Quartus" )
            set (_VENDOR_TOOL "quartus_sh")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${INTEL_SOURCE_SETTINGS}")
    elseif ( ${_vendor} STREQUAL "LATTICE" )
        #set (XILINX_SOURCE_SETTINGS ${CMAKE_HDL_TOOL_SETTINGS})
        file (TO_NATIVE_PATH ${CMAKE_HDL_TOOL_SETTINGS} LATTICE_SOURCE_SETTINGS)
        if ( ${_tool} STREQUAL "DIAMOND" )
            set (_VENDOR_TOOL "pnmainc")
            if (UNIX)
                set (_VENDOR_TOOL "diamondc")
            endif ()
            set (_VENDOR_ARGS "")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${LATTICE_SOURCE_SETTINGS}")
    endif ()

    #set (TCLHDL_TOOL ${CMAKE_HDL_TCLHDL})
    file (TO_NATIVE_PATH ${CMAKE_HDL_TCLHDL} TCLHDL_TOOL)
    #if ( ${HAS_TCLHDL} )
    set (_TCLHDL_TOOL       "${TCLHDL_TOOL}")
    set (_TCLHDL_DEBUG      "-debug")
    set (_TCLHDL_PROJECT    "-project")
    set (_TCLHDL_CLEAN      "-simulation")
    #endif ()

    add_custom_target (${_TARGET_NAME}-simulation
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_SIMULATION} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

endfunction()

