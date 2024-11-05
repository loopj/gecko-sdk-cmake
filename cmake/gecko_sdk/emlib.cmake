# CMake target for Gecko EMLIB
if(NOT TARGET gecko_sdk_emlib)
  add_library(gecko_sdk_emlib OBJECT EXCLUDE_FROM_ALL)

  # Common include paths
  target_include_directories(
    gecko_sdk_emlib
    PUBLIC
      "${GECKO_SDK_PATH}/platform/common/inc"
      "${GECKO_SDK_PATH}/platform/common/config"
      "${GECKO_SDK_PATH}/platform/common/toolchain/inc"
      "${GECKO_SDK_PATH}/platform/common/toolchain/config"
      "${GECKO_SDK_PATH}/platform/common/toolchain/config/standard"
  )

  # Common sources
  target_sources(
    gecko_sdk_emlib
    PRIVATE
      "${GECKO_SDK_PATH}/platform/common/src/sl_assert.c"
      "${GECKO_SDK_PATH}/platform/common/src/sl_string.c"
      "${GECKO_SDK_PATH}/platform/common/src/sl_syscalls.c"
      "${GECKO_SDK_PATH}/platform/common/toolchain/src/sl_memory.c"
  )

  # CMSIS include paths
  target_include_directories(gecko_sdk_emlib PUBLIC "${GECKO_SDK_PATH}/platform/CMSIS/Core/Include")

  # Device include paths
  target_include_directories(
    gecko_sdk_emlib
    PUBLIC "${GECKO_SDK_PATH}/platform/Device/SiliconLabs/${GECKO_CPU_FAMILY}/Include"
  )

  # Device sources
  target_sources(
    gecko_sdk_emlib
    PRIVATE
      "${GECKO_SDK_PATH}/platform/Device/SiliconLabs/${GECKO_CPU_FAMILY}/Source/startup_${GECKO_CPU_FAMILY_L}.c"
      "${GECKO_SDK_PATH}/platform/Device/SiliconLabs/${GECKO_CPU_FAMILY}/Source/system_${GECKO_CPU_FAMILY_L}.c"
  )

  # EMLIB include paths
  target_include_directories(gecko_sdk_emlib PUBLIC "${GECKO_SDK_PATH}/platform/emlib/inc")

  # EMLIB sources (using a wildcard to avoid listing all files)
  file(GLOB EMLIB_SOURCES "${GECKO_SDK_PATH}/platform/emlib/src/*.c")
  target_sources(gecko_sdk_emlib PRIVATE ${EMLIB_SOURCES})
endif()