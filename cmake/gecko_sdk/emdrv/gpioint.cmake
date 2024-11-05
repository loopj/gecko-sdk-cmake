# CMake target for Gecko GPIOINT driver
if(NOT TARGET gecko_sdk_emdrv_gpioint)
  add_library(gecko_sdk_emdrv_gpioint OBJECT EXCLUDE_FROM_ALL)
  add_library(GeckoSDK::emdrv::gpioint ALIAS gecko_sdk_emdrv_gpioint)

  # Include paths
  target_include_directories(
    gecko_sdk_emdrv_gpioint
    PUBLIC "${GECKO_SDK_PATH}/platform/emdrv/gpiointerrupt/inc"
  )

  # Sources
  target_sources(
    gecko_sdk_emdrv_gpioint
    PRIVATE "${GECKO_SDK_PATH}/platform/emdrv/gpiointerrupt/src/gpiointerrupt.c"
  )

  # Dependencies
  target_link_libraries(gecko_sdk_emdrv_gpioint gecko_sdk_emlib)
endif()