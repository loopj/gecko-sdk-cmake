# Minimum version of CMake required
cmake_minimum_required(VERSION 3.21)

# Project name and type
project(hello-world LANGUAGES C)

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
add_executable(hello_world main.c)

# Link the library to the target
target_link_libraries(hello_world PRIVATE GeckoSDK::emlib)

# Set the linker script
target_link_options(hello_world PRIVATE "-T${CMAKE_CURRENT_LIST_DIR}/linkerfile.ld")

# Generate .hex artifact after building the target
gecko_sdk_generate_hex(hello_world)