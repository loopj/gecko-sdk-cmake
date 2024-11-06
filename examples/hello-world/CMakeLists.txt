# Minimum version of CMake required
cmake_minimum_required(VERSION 3.21)

# Project name and type
project(hello-world LANGUAGES C)

# Include FetchContent module
include(FetchContent)

# Declare GeckoSDK as an external dependency
FetchContent_Declare(
  GeckoSDK
  SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/../.."
)

# Download and make the GeckoSDK content available
FetchContent_MakeAvailable(GeckoSDK)

# Add the executable
add_executable(hello_world main.c)

# Link the library to the target
target_link_libraries(hello_world PRIVATE GeckoSDK::emlib)

# Set the linker script
target_link_options(hello_world PRIVATE "-T${CMAKE_CURRENT_LIST_DIR}/efr32xg22.ld")