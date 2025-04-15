# CMake target for Gecko NVM3 driver
if(NOT TARGET GeckoSDK_emdrv_nvm3)
  # Define the CPU type
  # TODO: Centralize this
  set(GECKO_CPU_TYPE "CM33")

  # Define the target
  add_library(GeckoSDK_emdrv_nvm3 OBJECT EXCLUDE_FROM_ALL)
  add_library(GeckoSDK_emdrv_nvm3_lib STATIC IMPORTED GLOBAL)
  add_library(GeckoSDK::emdrv::nvm3 ALIAS GeckoSDK_emdrv_nvm3)

  # Include paths
  target_include_directories(
    GeckoSDK_emdrv_nvm3
    INTERFACE "${GECKO_SDK_PATH}/platform/emdrv/nvm3/inc"
  )

  # Sources
  target_sources(
    GeckoSDK_emdrv_nvm3
    PRIVATE "${GECKO_SDK_PATH}/platform/emdrv/nvm3/src/nvm3_hal_flash.c"
  )

  # Imported library location
  set_target_properties(
    GeckoSDK_emdrv_nvm3_lib
    PROPERTIES
      IMPORTED_LOCATION "${GECKO_SDK_PATH}/platform/emdrv/nvm3/lib/libnvm3_${GECKO_CPU_TYPE}_gcc.a"
  )

  # Dependencies
  target_link_libraries(GeckoSDK_emdrv_nvm3 INTERFACE GeckoSDK_emlib GeckoSDK_emdrv_nvm3_lib)
endif()
