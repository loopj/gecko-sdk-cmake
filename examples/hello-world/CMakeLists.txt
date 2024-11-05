# Minimum version of CMake required
cmake_minimum_required(VERSION 3.21)

# Project name and type
project(hello-world LANGUAGES C)

# Add the path to the 'FindGeckoSDK.cmake' if it's not in a common module path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../cmake")

# Find the external library
find_package(GeckoSDK REQUIRED)

# Add the executable
add_executable(hello_world main.c)

# Link the library to the target
target_link_libraries(hello_world PRIVATE GeckoSDK::emlib)