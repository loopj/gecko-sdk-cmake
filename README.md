# CMake Package for Gecko SDK

This package provides CMake library targets for parts of the Silicon Labs Gecko SDK, allowing you to use the SDK in your CMake projects without needing to use Simplicity Studio.

Additionally, the package includes toolchain files for ARM Cortex-M4 (Gecko Series 1 devices) and ARM Cortex-M33 (Gecko Series 2 devices) devices, and functions to generate binary, hex, s37, and gbl files from your target.

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Example](#example)
- [Installation](#installation)
  - [Using CPM](#using-cpm)
  - [Using FetchContent](#using-fetchcontent)
- [Configuration](#configuration)
- [Available Library Targets](#available-library-targets)
- [Toolchain Files](#toolchain-files)
- [Artifact Generation](#artifact-generation)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Example

Set the `GECKO_SDK_PATH` environment variable to the path of the Gecko SDK on your system:

```bash
export GECKO_SDK_PATH=/path/to/your/gecko_sdk
```

Define a `CMakeLists.txt` file in your project directory:

```cmake
# Set up the project
cmake_minimum_required(VERSION 3.21)
project(flash_led)

# Install the Gecko SDK package using CPM
include(cmake/CPM.cmake)
CPMAddPackage(
  NAME GeckoSDK
  GITHUB_REPOSITORY loopj/gecko-sdk-cmake
  VERSION v1.0.0
)

# Define our executable target
add_executable(flash_led main.c)

# Link against EMLIB from the Gecko SDK
target_link_libraries(flash_led PRIVATE GeckoSDK::emlib)

# Set the linker script
target_link_options(serial_debug PRIVATE "-T${CMAKE_CURRENT_LIST_DIR}/linkerfile.ld")

# Generate a flashable hex file for the target
gecko_sdk_generate_hex(flash_led)
```

Configure the build:

```bash
cmake -B build \
  -DGECKO_DEVICE=EFR32BG22C224F512GM32 \
  -DGECKO_CPU_FAMILY=EFR32BG22 \
  -DCMAKE_TOOLCHAIN_FILE=arm-cortex-m33.cmake
```

Build the project:

```bash
cmake --build build
```

See the [examples](examples) directory for example projects.

## Installation

### Using CPM

You can include this package in your project using the [CMake Package Manager](https://github.com/cpm-cmake/CPM.cmake):

```cmake
include(cmake/CPM.cmake)

CPMAddPackage(
  NAME GeckoSDK
  GITHUB_REPOSITORY loopj/gecko-sdk-cmake
  VERSION v1.0.0
)
```

### Using FetchContent

Alternatively, you can use CMake's plain `FetchContent` module:

```cmake
include(FetchContent)

FetchContent_Declare(
  GeckoSDK
  GIT_REPOSITORY https://github.com/loopj/gecko-sdk-cmake.git
  GIT_TAG v1.0.0
)

FetchContent_MakeAvailable(GeckoSDK)
```

## Configuration

The following CMake variables are required:

- `GECKO_SDK_PATH` - The path to the Gecko SDK, this can be set as an environment variable or passed as a CMake variable.
- `GECKO_DEVICE` - The full Gecko SoC part number (e.g. "EFR32BG22C224F512GM32")
- `GECKO_CPU_FAMILY` - The Gecko SoC CPU family (e.g. "EFR32BG22", "EFR32MG1P")

If using the `GeckoSDK::bsp`, `GeckoSDK::kit_drivers::retargetserial`, or `GeckoSDK::kit_drivers::retargetswo` library targets:

- `GECKO_BOARD` - A pre-configured development board name (e.g. "BRD4161A") or
- `GECKO_BOARD_CONFIG` - A path to custom board configuration (bsp) files

If you want to generate a `.gbl` firmware image using the `gecko_sdk_generate_gbl` function:

- `SIMPLICITY_COMMANDER_PATH` - The path to the folder containing Simplicity Commander executable

> [!TIP]
> Using a `CMakePresets.json` file is a clean way to set these variables for your project.

## Available Library Targets

The following library targets are currently available to link against:

- `GeckoSDK::emlib` - The [EMLIB API](https://docs.silabs.com/gecko-platform/4.4.5/platform-peripherals-overview/) peripheral library
- `GeckoSDK::rail_lib` - The [RAIL Library](https://docs.silabs.com/rail/latest/rail-api/) radio abstraction interface layer
- `GeckoSDK::emdrv::gpioint` - The [GPIOINT Driver](https://docs.silabs.com/gecko-platform/4.4.5/platform-driver/gpioint)
- `GeckoSDK::bsp` - The [Board Support Package](https://docs.silabs.com/gecko-platform/4.4.5/platform-driver/bsp) for device initialization, etc.
- `GeckoSDK::kit_drivers::retargetserial` - The [Retarget Serial](https://docs.silabs.com/gecko-platform/4.4.5/platform-driver/retargetserial) kit driver.
- `GeckoSDK::kit_drivers::retargetswo` - The [Retarget SWO](https://docs.silabs.com/gecko-platform/4.4.5/platform-driver/retargetswo) kit driver.
- `GeckoSDK::bootloader::interface` - The [Bootloader Application Interface](https://docs.silabs.com/mcu-bootloader/latest/gecko-bootloader-api/interface).

Pull requests are welcome to add more library targets!

## Toolchain Files

Toolchain files are provided for ARM Cortex-M4 and ARM Cortex-M33 devices.

To use these, copy the appropriate toolchain file from `cmake/toolchains` to your project directory and set the `CMAKE_TOOLCHAIN_FILE` variable to point to it.

```bash
cmake -DCMAKE_TOOLCHAIN_FILE=arm-cortex-m33.cmake ...
```

If you are using a `CMakePresets.json` file, you can set the toolchain file in the `configurePreset` section:

```json
{
  "configurePreset": {
    "toolchainFile": "arm-cortex-m33.cmake"
  }
}
```

## Artifact Generation

This package also provides functions to generate binary, hex, s37, and gbl files from your target.

The following artifact generation functions are made available:

```cmake
# Generate a bin file from the target
gecko_sdk_generate_bin(my_target)

# Generate a hex file from the target
gecko_sdk_generate_hex(my_target)

# Generate an s37 file from the target
gecko_sdk_generate_s37(my_target)

# Generate a gbl (Gecko Bootloader) file from the target
# This requires SIMPLICITY_COMMANDER_PATH to be set
gecko_sdk_generate_gbl(my_target)
```

## License

This project is made available under the [MIT License](LICENSE), except where otherwise specified.
