# CMake target for Gecko GPIOINT driver
if(NOT TARGET GeckoSDK_emdrv_gpioint)
  add_library(GeckoSDK_emdrv_gpioint OBJECT)
  add_library(GeckoSDK::emdrv::gpioint ALIAS GeckoSDK_emdrv_gpioint)

  # Include paths
  target_include_directories(
    GeckoSDK_emdrv_gpioint
    PUBLIC "${GECKO_SDK_PATH}/platform/emdrv/gpiointerrupt/inc"
  )

  # Sources
  target_sources(
    GeckoSDK_emdrv_gpioint
    PRIVATE "${GECKO_SDK_PATH}/platform/emdrv/gpiointerrupt/src/gpiointerrupt.c"
  )

  # Dependencies
  target_link_libraries(GeckoSDK_emdrv_gpioint GeckoSDK_emlib)
endif()