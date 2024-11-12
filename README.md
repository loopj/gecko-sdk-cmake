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

Pull requests are welcome to add more library targets!

## Toolchain Files

Toolchain files are provided for ARM Cortex-M4 and ARM Cortex-M33 devices. Copy the appropriate toolchain file from `cmake/toolchains` to your project directory and set the `CMAKE_TOOLCHAIN_FILE` variable to point to it.

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

The following artifact generation functions are made available:

```cmake
# Generate a bin file from the target
GeckoSDK_generate_bin(my_target)

# Generate a hex file from the target
GeckoSDK_generate_hex(my_target)

# Generate an s37 file from the target
GeckoSDK_generate_s37(my_target)

# Generate a gbl (Gecko Bootloader) file from the target
# This requires SIMPLICITY_COMMANDER_PATH to be set
GeckoSDK_generate_gbl(my_target)
```
