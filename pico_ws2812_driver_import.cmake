# This file can be dropped into a project to help locate the Pico WS2812 Driver libraries
# It will also set up the required include and module search paths.
# Based on the Pimoroni Pico library by Pimoroni

if (DEFINED ENV{PICO_WS2812_DRIVER_FETCH_FROM_GIT} AND (NOT PICO_WS2812_DRIVER_FETCH_FROM_GIT))
    set(PICO_WS2812_DRIVER_FETCH_FROM_GIT $ENV{PICO_WS2812_DRIVER_FETCH_FROM_GIT})
    message("Using PICO_WS2812_DRIVER_FETCH_FROM_GIT from environment ('${PICO_WS2812_DRIVER_FETCH_FROM_GIT}')")
endif ()

if (DEFINED ENV{PICO_WS2812_DRIVER_FETCH_FROM_GIT_PATH} AND (NOT PICO_WS2812_DRIVER_FETCH_FROM_GIT_PATH))
    set(PICO_WS2812_DRIVER_FETCH_FROM_GIT_PATH $ENV{PICO_WS2812_DRIVER_FETCH_FROM_GIT_PATH})
    message("Using PICO_WS2812_DRIVER_FETCH_FROM_GIT_PATH from environment ('${PICO_WS2812_DRIVER_FETCH_FROM_GIT_PATH}')")
endif ()

if (NOT PICO_WS2812_DRIVER_PATH)
    if (PICO_WS2812_DRIVER_FETCH_FROM_GIT)
        include(FetchContent)
        set(FETCHCONTENT_BASE_DIR_SAVE ${FETCHCONTENT_BASE_DIR})
        if (PICO_WS2812_DRIVER_FETCH_FROM_GIT_PATH)
            get_filename_component(FETCHCONTENT_BASE_DIR "${PICO_WS2812_DRIVER_FETCH_FROM_GIT_PATH}" REALPATH BASE_DIR "${CMAKE_SOURCE_DIR}")
        endif ()
        FetchContent_Declare(
                PICO_WS2812
                GIT_REPOSITORY https://github.com/Dwight-Studio/pico-ws2812-driver
                GIT_TAG main
        )
        if (NOT PICO_WS2812)
            message("Downloading PICO_WS2812 SDK")
            FetchContent_Populate(PICO_WS2812)
            set(PICO_WS2812_DRIVER_PATH ${PICO_WS2812_DRIVER_SOURCE_DIR})
        endif ()
        set(FETCHCONTENT_BASE_DIR ${FETCHCONTENT_BASE_DIR_SAVE})
    elseif(PICO_SDK_PATH AND EXISTS "${PICO_SDK_PATH}/../pico-ws2812-driver")
        set(PICO_WS2812_DRIVER_PATH ${PICO_SDK_PATH}/../pico-ws2812-driver)
        message("Defaulting PICO_WS2812_DRIVER_PATH as sibling of PICO_SDK_PATH: ${PICO_WS2812_DRIVER_PATH}")
    elseif(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/../../pico-ws2812-driver/")
        set(PICO_WS2812_DRIVER_PATH ${CMAKE_CURRENT_BINARY_DIR}/../../pico-ws2812-driver/)
    else()
        message(FATAL_ERROR "Pico WS2812 Driver location was not specified. Please set PICO_WS2812_DRIVER_PATH.")
    endif()
endif()

get_filename_component(PICO_WS2812_DRIVER_PATH "${PICO_WS2812_DRIVER_PATH}" REALPATH BASE_DIR "${CMAKE_BINARY_DIR}")
if (NOT EXISTS ${PICO_WS2812_DRIVER_PATH})
    message(FATAL_ERROR "Directory '${PICO_WS2812_DRIVER_PATH}' not found")
endif ()

if (NOT EXISTS ${PICO_WS2812_DRIVER_PATH}/pico_ws2812_driver_import.cmake)
    message(FATAL_ERROR "Directory '${PICO_WS2812_DRIVER_PATH}' does not appear to contain the Pico WS2812 Driver libraries")
endif ()

message("PICO_WS2812_DRIVER_PATH is ${PICO_WS2812_DRIVER_PATH}")

set(PICO_WS2812_DRIVER_PATH ${PICO_WS2812_DRIVER_PATH} CACHE PATH "Path to the Pico WS2812 Driver libraries" FORCE)

list(APPEND CMAKE_MODULE_PATH ${PICO_WS2812_DRIVER_PATH})

macro(pico_ws2812_driver_init)
    add_subdirectory(${PICO_WS2812_DRIVER_PATH} ws2812-driver)
endmacro()