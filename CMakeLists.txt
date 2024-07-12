cmake_minimum_required(VERSION 3.28)

# Pull in SDK
include(pico_sdk_import.cmake)

project(pico_ws2812_driver C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

set(SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/src)
set(SRC_FILES ${SRC_DIR}/ws2812.c ${SRC_DIR}/ws2812.h)

# Initialize the SDK
pico_sdk_init()

add_library(ws2812 ${SRC_FILES})

target_include_directories(ws2812 PUBLIC ${SRC_DIR})

target_link_libraries(ws2812 pico_stdlib hardware_pio)

# Generate the header file
pico_generate_pio_header(ws2812 ${SRC_DIR}/ws2812.pio)