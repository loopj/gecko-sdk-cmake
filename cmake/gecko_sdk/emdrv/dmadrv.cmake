# CMake target for Gecko DMADRV driver
if(NOT TARGET GeckoSDK_emdrv_dmadrv)
  add_library(GeckoSDK_emdrv_dmadrv OBJECT EXCLUDE_FROM_ALL)
  add_library(GeckoSDK::emdrv::dmadrv ALIAS GeckoSDK_emdrv_dmadrv)

  # Include paths
  target_include_directories(
    GeckoSDK_emdrv_dmadrv
    PUBLIC
      "${GECKO_SDK_PATH}/platform/emdrv/common/inc"
      "${GECKO_SDK_PATH}/platform/emdrv/dmadrv/inc"
      "${GECKO_SDK_PATH}/platform/emdrv/dmadrv/config"
  )

  # Sources
  target_sources(
    GeckoSDK_emdrv_dmadrv
    PRIVATE
      "${GECKO_SDK_PATH}/platform/emdrv/dmadrv/src/dmactrl.c"
      "${GECKO_SDK_PATH}/platform/emdrv/dmadrv/src/dmadrv.c"
  )

  # Dependencies
  target_link_libraries(GeckoSDK_emdrv_dmadrv GeckoSDK_emlib)
endif()
