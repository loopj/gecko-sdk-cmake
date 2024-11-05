# CMake target for Gecko Bootloader interface
if(NOT TARGET gecko_sdk_bootloader_interface)
  add_library(gecko_sdk_bootloader_interface OBJECT EXCLUDE_FROM_ALL)

  # Include paths
  target_include_directories(
    gecko_sdk_bootloader_interface
    PUBLIC
      "${GECKO_SDK_PATH}/platform/bootloader"
      "${GECKO_SDK_PATH}/platform/bootloader/api"
      "${GECKO_SDK_PATH}/platform/bootloader/config"
      "${GECKO_SDK_PATH}/platform/bootloader/config/s2/btl_interface"
  )

  # Sources
  target_sources(
    gecko_sdk_bootloader_interface
    PRIVATE
      "${GECKO_SDK_PATH}/platform/bootloader/api/btl_interface.c"
      "${GECKO_SDK_PATH}/platform/bootloader/api/btl_interface_storage.c"
  )

  # Dependencies
  target_link_libraries(gecko_sdk_bootloader_interface gecko_sdk_emlib)
endif()