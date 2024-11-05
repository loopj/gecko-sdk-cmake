# CMake target for the Gecko RAIL library
if(NOT TARGET gecko_sdk_rail_lib)
  # Determine the RAIL library name and chip
  if(GECKO_CPU_FAMILY_SHORT STREQUAL "EFR32FG1")
    set(RAIL_LIB_NAME "efr32xg1")
    set(RAIL_LIB_CHIP "efr32xg1x")
  elseif(GECKO_CPU_FAMILY_SHORT STREQUAL "EFR32FG14")
    set(RAIL_LIB_NAME "efr32xg14")
    set(RAIL_LIB_CHIP "efr32xg1x")
  elseif(GECKO_CPU_FAMILY_SHORT STREQUAL "EFR32MG22")
    set(RAIL_LIB_NAME "efr32xg22")
    set(RAIL_LIB_CHIP "efr32xg2x")
  elseif(GECKO_CPU_FAMILY_SHORT STREQUAL "EFR32BG22")
    set(RAIL_LIB_NAME "efr32xg22")
    set(RAIL_LIB_CHIP "efr32xg2x")
  else()
    message(WARNING "[GeckoSDK] CPU family ${GECKO_CPU_FAMILY} not yet suppored in rail_lib.cmake")
    return()
  endif()

  # Define the target
  add_library(gecko_sdk_rail_lib STATIC IMPORTED)
  add_library(GeckoSDK::rail_lib ALIAS gecko_sdk_rail_lib)

  # Include paths
  target_include_directories(
    gecko_sdk_rail_lib
    INTERFACE
      "${GECKO_SDK_PATH}/platform/radio/rail_lib/common"
      "${GECKO_SDK_PATH}/platform/radio/rail_lib/protocol/ble"
      "${GECKO_SDK_PATH}/platform/radio/rail_lib/protocol/ieee802154"
      "${GECKO_SDK_PATH}/platform/radio/rail_lib/protocol/sidewalk"
      "${GECKO_SDK_PATH}/platform/radio/rail_lib/protocol/wmbus"
      "${GECKO_SDK_PATH}/platform/radio/rail_lib/protocol/zwave"
      "${GECKO_SDK_PATH}/platform/radio/rail_lib/chip/efr32/${RAIL_LIB_CHIP}"
  )

  # Imported library location
  set_target_properties(
    gecko_sdk_rail_lib
    PROPERTIES
      IMPORTED_LOCATION
        "${GECKO_SDK_PATH}/platform/radio/rail_lib/autogen/librail_release/librail_${RAIL_LIB_NAME}_gcc_release.a"
  )

  # Dependencies
  target_link_libraries(gecko_sdk_rail_lib INTERFACE gecko_sdk_emlib)

  # Function to generate the RAIL library configuration
  function(set_rail_config_paths radioconf_file output_path)
    # Make sure Python 3.10 is available to generate RAIL configuration files
    find_package(Python3 3.10...3.11 QUIET REQUIRED COMPONENTS Interpreter)
    if (Python3_FOUND)
      message(STATUS "[GeckoSDK] Found Python 3.10.x: ${Python3_EXECUTABLE} (version ${Python3_VERSION})")
    else()
      message(FATAL_ERROR "[GeckoSDK] Python 3.10.x is required to generate RAIL configuration files")
    endif()

    # Check for all Python packages in a single command
    execute_process(
      COMMAND ${Python3_EXECUTABLE} -c "import jinja2,yaml,numpy,scipy"
      RESULT_VARIABLE PKG_FOUND
      OUTPUT_QUIET ERROR_QUIET
    )

    # Check if all required Python packages are installed
    if(NOT PKG_FOUND EQUAL 0)
      message(FATAL_ERROR "[GeckoSDK] Python packages jinja2, pyyaml, numpy, and scipy are required to generate RAIL configuration files")
    endif()
  
    # Make paths absolute
    get_filename_component(radioconf_file ${radioconf_file} ABSOLUTE ${CMAKE_CURRENT_SOURCE_DIR})
    get_filename_component(output_path ${output_path} ABSOLUTE ${CMAKE_CURRENT_SOURCE_DIR})

    # Add a custom command to generate the RAIL configuration
    add_custom_command(
      OUTPUT
        ${output_path}/rail_config.c
        ${output_path}/rail_config.h
        ${output_path}/radioconf_generation_log.json
        ${output_path}
      COMMAND
        ${Python3_EXECUTABLE}
        ${GECKO_SDK_PATH}/platform/radio/efr32_multiphy_configurator/Efr32RadioConfiguratorUcAdapter.py
        ${radioconf_file} -o ${output_path} > /dev/null
      DEPENDS ${radioconf_file}
      COMMENT "Generating RAIL radio configuration"
    )
  endfunction()
endif()