# CMake target for Gecko RetargetIO Kit Driver
if(NOT TARGET GeckoSDK_kit_drivers_retargetswo)
  add_library(GeckoSDK_kit_drivers_retargetswo OBJECT)
  add_library(GeckoSDK::kit_drivers::retargetswo ALIAS GeckoSDK_kit_drivers_retargetswo)

  # Sources
  target_sources(
    GeckoSDK_kit_drivers_retargetswo
    PRIVATE
      "${GECKO_SDK_PATH}/hardware/kit/common/drivers/retargetswo.c"
  )

  # Dependencies
  target_link_libraries(GeckoSDK_kit_drivers_retargetswo GeckoSDK_kit_drivers_retargetio)
endif()