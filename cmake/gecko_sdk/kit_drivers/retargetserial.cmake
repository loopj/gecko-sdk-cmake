# CMake target for Gecko RetargetIO Kit Driver
if(NOT TARGET GeckoSDK_kit_drivers_retargetserial)
  add_library(GeckoSDK_kit_drivers_retargetserial OBJECT)
  add_library(GeckoSDK::kit_drivers::retargetserial ALIAS GeckoSDK_kit_drivers_retargetserial)

  # Sources
  target_sources(
    GeckoSDK_kit_drivers_retargetserial
    PRIVATE
      "${GECKO_SDK_PATH}/hardware/kit/common/drivers/retargetserial.c"
  )

  # Dependencies
  target_link_libraries(GeckoSDK_kit_drivers_retargetserial GeckoSDK_kit_drivers_retargetio)
endif()