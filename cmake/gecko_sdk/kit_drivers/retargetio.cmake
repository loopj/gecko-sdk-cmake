# CMake target for Gecko RetargetIO Kit Driver
if(NOT TARGET GeckoSDK_kit_drivers_retargetio)
  add_library(GeckoSDK_kit_drivers_retargetio OBJECT)
  add_library(GeckoSDK::kit_drivers::retargetio ALIAS GeckoSDK_kit_drivers_retargetio)

  # Sources
  target_sources(
    GeckoSDK_kit_drivers_retargetio
    PRIVATE
      "${GECKO_SDK_PATH}/hardware/kit/common/drivers/retargetio.c"
  )

  # Dependencies
  target_link_libraries(GeckoSDK_kit_drivers_retargetio GeckoSDK_bsp)
endif()