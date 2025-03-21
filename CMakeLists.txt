#
# CMake package for the Silicon Labs Gecko SDK
#
# This module will search for the Gecko SDK at the specified path and include
# the necessary components for building applications with the SDK.
#

# Minimum version of CMake required
cmake_minimum_required(VERSION 3.21)

# Project name and type
project(GeckoSDK LANGUAGES C)

# Required settings:
set(GECKO_SDK_PATH "" CACHE PATH "Path to the Silicon Labs Gecko SDK")
set(GECKO_DEVICE "" CACHE STRING "Gecko SoC part number, e.g. EFR32BG22C224F512GM32")
set(GECKO_CPU_FAMILY "" CACHE STRING "Gecko SoC CPU family, e.g. EFR32BG22")

# Optional settings:
set(GECKO_BOARD "" CACHE STRING "The development board name, e.g. BRD4161A")
set(GECKO_BOARD_CONFIG "" CACHE PATH "Path to custom board configuration files")
set(SIMPLICITY_COMMANDER_PATH "" CACHE PATH "Path to Simplicity Commander")

# Make sure GECKO_SDK_PATH is defined
if(NOT GECKO_SDK_PATH)
  if(DEFINED ENV{GECKO_SDK_PATH})
    set(GECKO_SDK_PATH $ENV{GECKO_SDK_PATH} CACHE PATH "Path to the Silicon Labs Gecko SDK" FORCE)
  else()
    message(FATAL_ERROR "[GeckoSDK] GECKO_SDK_PATH is not set.")
  endif()
endif()

# Set the Simplicity Commander path if it is not defined, but available in the environment
if(NOT SIMPLICITY_COMMANDER_PATH)
  if(DEFINED ENV{SIMPLICITY_COMMANDER_PATH})
    set(SIMPLICITY_COMMANDER_PATH $ENV{SIMPLICITY_COMMANDER_PATH} CACHE PATH "Path to Simplicity Commander" FORCE)
  endif()
endif()

# Make sure the path is valid
if(NOT EXISTS "${GECKO_SDK_PATH}")
  message(FATAL_ERROR "[GeckoSDK] The specified path '${GECKO_SDK_PATH}' does not exist.")
endif()

# Check for a Gecko SDK at the specified path
message(STATUS "[GeckoSDK] Looking for Silicon Labs Gecko SDK at ${GECKO_SDK_PATH}")
file(STRINGS "${GECKO_SDK_PATH}/.properties" gecko_sdk_version REGEX "version=[0-9]+\\.[0-9]+\\.[0-9]+")
if (NOT gecko_sdk_version MATCHES "version=([0-9]+)\\.([0-9]+)\\.([0-9]+)")
  message(FATAL_ERROR "[GeckoSDK] Could not find Silicon Labs Gecko SDK at path '${GECKO_SDK_PATH}'")
endif()

# Extract the version from the .properties file
set(PACKAGE_VERSION "${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3}")

# Print the SDK version
message(STATUS "[GeckoSDK] Found Silicon Labs Gecko SDK v${PACKAGE_VERSION}")

# Make sure GECKO_DEVICE is defined, required for most of the SDK
if(NOT GECKO_DEVICE)
  message(FATAL_ERROR "GECKO_DEVICE is required but not set.")
endif()
message(STATUS "[GeckoSDK] Building for part number ${GECKO_DEVICE}")

# Check if GECKO_CPU_FAMILY is defined, generate a couple of related variables
if(NOT GECKO_CPU_FAMILY)
  message(FATAL_ERROR "GECKO_CPU_FAMILY is required but not set.")
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

# Include the board-specific configuration files, if available
if(GECKO_BOARD)
  # Use pre-defined board configs from the SDK
  set(GECKO_BOARD_CONFIG_PATH "${GECKO_SDK_PATH}/hardware/kit/${GECKO_CPU_FAMILY_SHORT}_${GECKO_BOARD}/config")
  message(STATUS "[GeckoSDK] Using pre-defined BSP configuration for ${GECKO_CPU_FAMILY_SHORT}_${GECKO_BOARD}")
elseif(GECKO_BOARD_CONFIG)
  # Use custom board configs
  set(GECKO_BOARD_CONFIG_PATH "${GECKO_BOARD_CONFIG}")
  message(STATUS "[GeckoSDK] Using custom BSP configuration files at ${GECKO_BOARD_CONFIG}")
else()
  message(NOTICE "[GeckoSDK] Neither GECKO_BOARD or GECKO_BOARD_CONFIG are set, BSP and RetargetIO driver targets will not be created")
endif()

# Include the SDK components
include(cmake/gecko_sdk/bootloader/interface.cmake)
include(cmake/gecko_sdk/emdrv/gpioint.cmake)
include(cmake/gecko_sdk/emdrv/dmadrv.cmake)
include(cmake/gecko_sdk/emlib.cmake)
include(cmake/gecko_sdk/rail_lib.cmake)

# Include the BSP and kit drivers, if a board is defined
if(GECKO_BOARD_CONFIG_PATH)
  include(cmake/gecko_sdk/bsp.cmake)
  include(cmake/gecko_sdk/kit_drivers/retargetserial.cmake)
  include(cmake/gecko_sdk/kit_drivers/retargetswo.cmake)
endif()

# Include the artifact generation functions
include(cmake/utils/generate_artifacts.cmake)

# Set the Gecko SDK found flag
set(GeckoSDK_FOUND TRUE PARENT_SCOPE)
