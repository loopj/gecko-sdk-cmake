# CMake Package for Gecko SDK

This package provides CMake library targets for parts of the Silicon Labs Gecko SDK, allowing you to use the SDK in your CMake projects without needing to use Simplicity Studio.

Additionally, the package includes toolchain files for ARM Cortex-M4 (Gecko Series 1 devices) and ARM Cortex-M33 (Gecko Series 2 devices) devices.

## Usage

```cmake
# Set up the project
cmake_minimum_required(VERSION 3.21)
project(hello-world LANGUAGES C)

# Include FetchContent module
include(FetchContent)

# Declare GeckoSDK as an external dependency
FetchContent_Declare(
  GeckoSDK
  GIT_REPOSITORY https://github.com/loopj/gecko-sdk-cmake.git
  GIT_TAG main
)

# Download and make the GeckoSDK content available
FetchContent_MakeAvailable(GeckoSDK)

# Define your target and link against the Gecko SDK libraries
add_executable(hello_world main.c)
target_link_libraries(hello_world PRIVATE GeckoSDK::emlib GeckoSDK::kit_drivers::retargetswo)
```

See the [example](example) directory for a full example project.

## CMake Variables

The following CMake variables are required to be set:

- `GECKO_SDK_PATH` - The path to the Gecko SDK, this can be set as an environment variable or passed as a CMake variable.
- `GECKO_DEVICE` - The full Gecko SoC part number (e.g. "EFR32BG22C224F512GM32")
- `GECKO_CPU_FAMILY` - The Gecko SoC CPU family (e.g. "EFR32BG22", "EFR32MG1P")

Some library targets require additional configuration files, namely the `GeckoSDK::bsp` component and the `GeckoSDK::kit_drivers` components. To use these you will need to define one of the following variables:

- `GECKO_BOARD` - A pre-configured development board name (e.g. "BRD4161A")
- `GECKO_BOARD_CONFIG` - A path to custom board configuration (bsp) files

> [!TIP]
> Using a `CMakePresets.json` file can be a good way to set these variables for your project.

## Library Targets

The following library targets are currently available to link against:

- `GeckoSDK::emlib` - The [EMLIB API](https://docs.silabs.com/gecko-platform/4.4.5/platform-peripherals-overview/) peripheral library
- `GeckoSDK::rail_lib` - The [RAIL Library](https://docs.silabs.com/rail/latest/rail-api/) radio abstraction interface layer
- `GeckoSDK::emdrv::gpioint` - The [GPIOINT Driver](https://docs.silabs.com/gecko-platform/4.4.5/platform-driver/gpioint)
- `GeckoSDK::bsp` - The [Board Support Package](https://docs.silabs.com/gecko-platform/4.4.5/platform-driver/bsp) for device initialization, etc.
- `GeckoSDK::kit_drivers::retargetio` - The [Retarget IO](https://docs.silabs.com/gecko-platform/4.4.5/platform-driver/retargetio) kit driver.
- `GeckoSDK::kit_drivers::retargetserial` - The [Retarget Serial](https://docs.silabs.com/gecko-platform/4.4.5/platform-driver/retargetserial) kit driver.
- `GeckoSDK::kit_drivers::retargetswo` - The [Retarget SWO](https://docs.silabs.com/gecko-platform/4.4.5/platform-driver/retargetswo) kit driver.
- `GeckoSDK::bootloader::interface` - The [Bootloader Application Interface](https://docs.silabs.com/mcu-bootloader/latest/gecko-bootloader-api/interface).

## Toolchain Files

## Utility Functions

This package also provides some utility functions to make it easier to work with the Gecko SDK.

### Artifact Generation

To use the artifact generation functions, you will need to include the `generate_artifacts.cmake` file in your CMakeLists.txt file.

```cmake
include(${geckosdk_SOURCE_DIR}/cmake/utils/generate_artifacts.cmake)
```

The following functions will then be available:

```cmake
# Generate a bin file from the target
generate_bin(my_target)

# Generate a hex file from the target
generate_hex(my_target)

# Generate an s37 file from the target
generate_s37(my_target)

# Generate a gbl (Gecko Bootloader) file from the target
# This requires SIMPLICITY_COMMANDER_PATH to be set
generate_gbl(my_target)
```

### Flashing with OpenOCD

To use the OpenOCD flashing functions, you will need to include the `openocd.cmake` file in your CMakeLists.txt file.

This assumes you are using an OpenOCD version that has been patched with EFM32 Series 2 support.

```cmake
include(${geckosdk_SOURCE_DIR}/cmake/utils/openocd.cmake)
```

The following functions will then be available:

```cmake
add_openocd_flash_target(my_target)
```

Which will create a target called `my_target_flash_openocd` that will flash the target using OpenOCD.
