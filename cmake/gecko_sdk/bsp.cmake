# CMake target for Gecko Board Support Package (BSP)
if(NOT TARGET GeckoSDK_bsp)
  # Define the target
  add_library(GeckoSDK_bsp OBJECT EXCLUDE_FROM_ALL)
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