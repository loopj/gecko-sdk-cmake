# CMake target for Gecko RetargetIO SWO Kit Driver
if(NOT TARGET GeckoSDK_kit_drivers_retargetswo)
  add_library(GeckoSDK_kit_drivers_retargetswo OBJECT EXCLUDE_FROM_ALL)
  add_library(GeckoSDK::kit_drivers::retargetswo ALIAS GeckoSDK_kit_drivers_retargetswo)

  # Sources
  target_sources(
    GeckoSDK_kit_drivers_retargetswo
    PRIVATE
      "${GECKO_SDK_PATH}/hardware/kit/common/drivers/retargetio.c"
      "${GECKO_SDK_PATH}/hardware/kit/common/drivers/retargetswo.c"
  )

  # Dependencies
  target_link_libraries(GeckoSDK_kit_drivers_retargetserial GeckoSDK::bsp)
endif()