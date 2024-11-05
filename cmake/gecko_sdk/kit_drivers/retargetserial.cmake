# CMake target for Gecko RetargetIO Kit Driver
if(NOT TARGET gecko_sdk_kit_drivers_retargetserial)
  add_library(gecko_sdk_kit_drivers_retargetserial OBJECT EXCLUDE_FROM_ALL)
  add_library(GeckoSDK::kit_drivers::retargetserial ALIAS gecko_sdk_kit_drivers_retargetserial)

  # Sources
  target_sources(
    gecko_sdk_kit_drivers_retargetserial
    PRIVATE
      "${GECKO_SDK_PATH}/hardware/kit/common/drivers/retargetio.c"
      "${GECKO_SDK_PATH}/hardware/kit/common/drivers/retargetserial.c"
  )

  # Dependencies
  target_link_libraries(gecko_sdk_kit_drivers_retargetserial gecko_sdk_bsp)
endif()