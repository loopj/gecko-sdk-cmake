# CMake target for Gecko Bootloader interface
if(NOT TARGET GeckoSDK_bootloader_interface)
  add_library(GeckoSDK_bootloader_interface OBJECT EXCLUDE_FROM_ALL)
  add_library(GeckoSDK::bootloader::interface ALIAS GeckoSDK_bootloader_interface)

  # Include paths
  target_include_directories(
    GeckoSDK_bootloader_interface
    PUBLIC
      "${GECKO_SDK_PATH}/platform/bootloader"
      "${GECKO_SDK_PATH}/platform/bootloader/api"
      "${GECKO_SDK_PATH}/platform/bootloader/config"
      "${GECKO_SDK_PATH}/platform/bootloader/config/s2/btl_interface"
  )

  # Sources
  target_sources(
    GeckoSDK_bootloader_interface
    PRIVATE
      "${GECKO_SDK_PATH}/platform/bootloader/api/btl_interface.c"
      "${GECKO_SDK_PATH}/platform/bootloader/api/btl_interface_storage.c"
  )

  # Dependencies
  target_link_libraries(GeckoSDK_bootloader_interface GeckoSDK_emlib)
endif()