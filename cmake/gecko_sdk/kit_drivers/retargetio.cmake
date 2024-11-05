# CMake target for Gecko RetargetIO Kit Driver
if(NOT TARGET gecko_sdk_kit_drivers_retargetio)
  add_library(gecko_sdk_kit_drivers_retargetio OBJECT EXCLUDE_FROM_ALL)
  add_library(GeckoSDK::kit_drivers::retargetio ALIAS gecko_sdk_kit_drivers_retargetio)

  # Sources
  target_sources(
    gecko_sdk_kit_drivers_retargetio
    PRIVATE
      "${GECKO_SDK_PATH}/hardware/kit/common/drivers/retargetio.c"
  )

  # Dependencies
  target_link_libraries(gecko_sdk_kit_drivers_retargetio gecko_sdk_bsp)
endif()