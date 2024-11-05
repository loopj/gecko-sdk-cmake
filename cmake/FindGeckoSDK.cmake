# CMake "find module" for the Silicon Labs Gecko SDK
#
# This module will search for the Gecko SDK at the specified path and include
# the necessary components for building applications with the SDK.
#
# Required variables:
# - GECKO_SDK_PATH: Path to the Gecko SDK
# - GECKO_DEVICE: The Gecko SoC part number (e.g. "EFR32BG22C224F512GM32")
# - GECKO_CPU_FAMILY: The Gecko SoC CPU family (e.g. "EFR32BG22", "EFR32MG1P")
#
# Optional variables:
# - GECKO_BOARD: The development board name (e.g. "BRD4161A")
# - GECKO_BOARD_CONFIG: Path to custom board configuration files
#
# Usage:
#   find_package(GeckoSDK REQUIRED)

include(FindPackageHandleStandardArgs)

# Make sure GECKO_SDK_PATH is defined
if(NOT DEFINED GECKO_SDK_PATH)
  if(DEFINED ENV{GECKO_SDK_PATH})
    set(GECKO_SDK_PATH $ENV{GECKO_SDK_PATH})
  else()
    message(FATAL_ERROR "[GeckoSDK] GECKO_SDK_PATH is not set.")
  endif()
endif()

# Check for a Gecko SDK at the specified path
file(STRINGS "${GECKO_SDK_PATH}/.properties" gecko_sdk_version REGEX "version=[0-9]+\\.[0-9]+\\.[0-9]+")
if (NOT gecko_sdk_version MATCHES "version=([0-9]+)\\.([0-9]+)\\.([0-9]+)")
  message(FATAL_ERROR "[GeckoSDK] Could not find Silicon Labs Gecko SDK at ${GECKO_SDK_PATH}")
endif()

# Extract the version from the .properties file, check if it matches the version requirement
set(PACKAGE_VERSION "${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3}")
find_package_check_version("${PACKAGE_VERSION}" version_check HANDLE_VERSION_RANGE RESULT_MESSAGE_VARIABLE reason)
if (NOT version_check)
  message(FATAL_ERROR "[GeckoSDK] ${reason}")
endif()

# Print the SDK version
message(STATUS "[GeckoSDK] Found Silicon Labs Gecko SDK v${PACKAGE_VERSION}")

# Make sure GECKO_DEVICE is defined, required for most of the SDK
if(NOT DEFINED GECKO_DEVICE)
  message(FATAL_ERROR "GECKO_DEVICE must be defined.")
endif()
message(STATUS "[GeckoSDK] Building for part number ${GECKO_DEVICE}")

# Check if GECKO_CPU_FAMILY is defined, generate a couple of related variables
if(NOT DEFINED GECKO_CPU_FAMILY)
  message(FATAL_ERROR "GECKO_CPU_FAMILY must be defined.")
endif()
message(STATUS "[GeckoSDK] Building for CPU family ${GECKO_CPU_FAMILY}")

# Define the short version of the GECKO_CPU_FAMILY (used by rail_lib and bsp)
if(GECKO_CPU_FAMILY MATCHES "^(.*)[BLPSV]$")
  set(GECKO_CPU_FAMILY_SHORT "${CMAKE_MATCH_1}")
else()
  set(GECKO_CPU_FAMILY_SHORT "${GECKO_CPU_FAMILY}")
endif()

# Set the lowercase version of the GECKO_CPU_FAMILY (used by the system/startup files)
string(TOLOWER ${GECKO_CPU_FAMILY} GECKO_CPU_FAMILY_L)

# Set the part number as a compile definition
add_compile_definitions("${GECKO_DEVICE}=1")

# Make the toolchain directory available to consumers
get_filename_component(GeckoSDK_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
set(GeckoSDK_TOOLCHAIN_DIR "${GeckoSDK_CMAKE_DIR}/toolchains")
set(GeckoSDK_TOOLCHAIN_DIR_HINT "${GeckoSDK_TOOLCHAIN_DIR}" CACHE PATH "Path to MyPackage toolchain files")

# Include the SDK components
include(gecko_sdk/bootloader/interface)
include(gecko_sdk/bsp)
include(gecko_sdk/emdrv/gpioint)
include(gecko_sdk/emlib)
include(gecko_sdk/kit_drivers/retargetserial)
include(gecko_sdk/kit_drivers/retargetswo)
include(gecko_sdk/rail_lib)
