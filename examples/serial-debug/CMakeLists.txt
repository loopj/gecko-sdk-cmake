# Minimum version of CMake required
cmake_minimum_required(VERSION 3.21)

# Project name and type
project(serial-debug LANGUAGES C)

# Include FetchContent module
include(FetchContent)

# Declare GeckoSDK as an external dependency from the local filesystem
FetchContent_Declare(
  GeckoSDK
  SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/../.."
)

# Declare GeckoSDK as a dependency from GitHub
# FetchContent_Declare(
#   GeckoSDK
#   GIT_REPOSITORY https://github.com/loopj/gecko-sdk-cmake.git
#   GIT_TAG        main
# )

# Download and make the GeckoSDK content available
FetchContent_MakeAvailable(GeckoSDK)

# Add the executable
add_executable(serial_debug main.c)

# Link the library to the target
target_link_libraries(serial_debug PRIVATE GeckoSDK::emlib GeckoSDK::bsp GeckoSDK::kit_drivers::retargetserial)

# Set the linker script
target_link_options(serial_debug PRIVATE "-T${CMAKE_CURRENT_LIST_DIR}/linkerfile.ld")

# Generate .hex artifact after building the target
gecko_sdk_generate_hex(serial_debug)