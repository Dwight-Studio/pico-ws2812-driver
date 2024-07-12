# Pi Pico WS2812 Driver

## About

Simple Pi Pico driver for the C/C++ SDK to communicate with WS2812 LEDs.
This driver is based on
the [`pico-examples/pio/ws2812`](https://github.com/raspberrypi/pico-examples/blob/master/pio/ws2812/) by Raspberry Pi.

## Quick start

The driver can be imported using a cmake script (similar to the [`pico-sdk`](https://github.com/raspberrypi/pico-sdk/)).

Here is a simple quick start guide:

1. Setup the `pico-sdk` for your project
2. Clone this repository
3. Download `pico_ws2812_driver_import.cmake` and put it along with `pico_sdk_import.cmake` (in the root folder of your
   project)
4. Copy and fill this `CMakeLists.txt` template

```cmake
cmake_minimum_required(VERSION 3.28)

set(PICO_SDK_PATH "YOUR/SDK/PATH")
#set(PICO_WS2812_DRIVER_PATH "YOUR/DRIVER/PATH")

# Pull in SDK
include(pico_sdk_import.cmake)
include(pico_ws2812_driver_import.cmake)

project(test C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Initialize the SDK
pico_sdk_init()
pico_ws2812_driver_init()

add_executable(test main.c)
target_link_libraries(test pico_stdlib ws2812)
pico_add_extra_outputs(test)
```

If you cloned the driver in the same directory as the [`pico-sdk`](https://github.com/raspberrypi/pico-sdk/), you don't
need to set `PICO_WS2812_DRIVER_PATH`. Otherwise, uncomment the `set` directive and complete the path.

5. Import `"ws2812.h"` and use the driver in your code (see the [test example](#test-example))

## Test example

After setting up your cmake project, you can test the driver. Here is simple example. Note that the used GPIO Pin is 23,
which is the default pin on YD-RP2040 boards.

This is `main.c`:

```c
#include <pico/time.h>
#include <math.h>
#include <ws2812.h>

float compute_brightness() {
    return powf(sinf((float) to_ms_since_boot(get_absolute_time()) / 2500.0f), 2.0f);
}

bool led_callback(repeating_timer_t *timer) {
    float brightness = compute_brightness();

    ws2812_set_rgb_float(timer->user_data, brightness, brightness * 0.5f, 0);
    return true;
}

int main(void) {
    repeating_timer_t timer;

    ws2812_inst_t *inst = ws2812_init(pio0, 0, WS2812_DEFAULT_PIN, WS2812_DEFAULT_BAUD_RATE, false);

    add_repeating_timer_ms(25, led_callback, inst, &timer);

    while (1) {
        tight_loop_contents();
    }
}
```