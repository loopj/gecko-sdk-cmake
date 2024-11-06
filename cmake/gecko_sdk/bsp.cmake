# CMake target for Gecko Board Support Package (BSP)
if(NOT TARGET GeckoSDK_bsp)
  # Include the board-specific configuration files, if available
  if(GECKO_BOARD)
    # Use pre-defined board configs from the SDK
    set(GECKO_BOARD_CONFIG_PATH "${GECKO_SDK_PATH}/hardware/kit/${GECKO_CPU_FAMILY_SHORT}_${GECKO_BOARD}/config")
    message(STATUS "[GeckoSDK] Using pre-defined BSP configuration for ${GECKO_CPU_FAMILY_SHORT}_${GECKO_BOARD}")
  elseif(GECKO_BOARD_CONFIG)
    # Use custom board configs
    set(GECKO_BOARD_CONFIG_PATH "${GECKO_BOARD_CONFIG}")
    message(STATUS "[GeckoSDK] Using custom BSP configuration files at ${GECKO_BOARD_CONFIG}")
  else()
    message(WARNING "[GeckoSDK] No BSP configuration files included, not generating GeckoSDK::bsp target")
    return()
  endif()

  # Define the target
  add_library(GeckoSDK_bsp OBJECT)
  add_library(GeckoSDK::bsp ALIAS GeckoSDK_bsp)

  # Include paths
  target_include_directories(
    GeckoSDK_bsp
    PUBLIC
      "${GECKO_SDK_PATH}/platform/halconfig/inc/hal-config"
      "${GECKO_SDK_PATH}/hardware/kit/common/bsp"
      "${GECKO_SDK_PATH}/hardware/kit/common/config"
      "${GECKO_SDK_PATH}/hardware/kit/common/drivers"
      "${GECKO_SDK_PATH}/hardware/kit/common/halconfig"
  )
  
  # Include the BSP configuration files
  if(GECKO_BOARD_CONFIG_PATH)
    target_include_directories(GeckoSDK_bsp PUBLIC "${GECKO_BOARD_CONFIG_PATH}")
  endif()

  # Sources
  target_sources(GeckoSDK_bsp PRIVATE
    "${GECKO_SDK_PATH}/hardware/kit/common/bsp/bsp_init.c"
    "${GECKO_SDK_PATH}/hardware/kit/common/bsp/bsp_trace.c"
  )

  # Dependencies
  target_link_libraries(GeckoSDK_bsp GeckoSDK_emlib)
endif()