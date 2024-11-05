# CMake target for Gecko Board Support Package (BSP)
if(NOT TARGET gecko_sdk_bsp)
  # Include the board-specific configuration files, if available
  if(DEFINED GECKO_BOARD)
    # Use pre-defined board configs from the SDK
    set(GECKO_BOARD_CONFIG_PATH "${GECKO_SDK_PATH}/hardware/kit/${GECKO_CPU_FAMILY_SHORT}_${GECKO_BOARD}/config")
    message(STATUS "[GeckoSDK] Using pre-defined BSP configuration for ${GECKO_CPU_FAMILY_SHORT}_${GECKO_BOARD}")
  elseif(DEFINED GECKO_BOARD_CONFIG)
    # Use custom board configs
    set(GECKO_BOARD_CONFIG_PATH "${GECKO_BOARD_CONFIG}")
    message(STATUS "[GeckoSDK] Using custom BSP configuration files at ${GECKO_BOARD_CONFIG}")
  else()
    message(WARNING "[GeckoSDK] No BSP configuration files included!")
  endif()

  # Define the target
  add_library(gecko_sdk_bsp OBJECT EXCLUDE_FROM_ALL)
  add_library(GeckoSDK::bsp ALIAS gecko_sdk_bsp)

  # Include paths
  target_include_directories(
    gecko_sdk_bsp
    PUBLIC
      "${GECKO_SDK_PATH}/platform/halconfig/inc/hal-config"
      "${GECKO_SDK_PATH}/hardware/kit/common/bsp"
      "${GECKO_SDK_PATH}/hardware/kit/common/config"
      "${GECKO_SDK_PATH}/hardware/kit/common/drivers"
      "${GECKO_SDK_PATH}/hardware/kit/common/halconfig"
  )
  
  # Include the BSP configuration files
  if(DEFINED GECKO_BOARD_CONFIG_PATH)
    target_include_directories(gecko_sdk_bsp PUBLIC "${GECKO_BOARD_CONFIG_PATH}")
  endif()

  # Sources
  target_sources(gecko_sdk_bsp PRIVATE
    "${GECKO_SDK_PATH}/hardware/kit/common/bsp/bsp_init.c"
    "${GECKO_SDK_PATH}/hardware/kit/common/bsp/bsp_trace.c"
  )

  # Dependencies
  target_link_libraries(gecko_sdk_bsp gecko_sdk_emlib)
endif()