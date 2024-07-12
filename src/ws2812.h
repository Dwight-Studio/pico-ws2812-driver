#ifndef PICO_WS2812_DRIVER_H
#define PICO_WS2812_DRIVER_H

#include <malloc.h>
#include <math.h>
#include "pico/stdlib.h"
#include "pico/malloc.h"
#include "hardware/pio.h"

#define WS2812_DEFAULT_PIN 23
#define WS2812_DEFAULT_BAUD_RATE 800000

struct ws2812_inst {
    PIO pio;
    uint sm;
    uint pin;
} typedef ws2812_inst_t;

/*!
 * Initiate the WS2812 PIO state machine.
 *
 * @param pio PIO instance
 * @param sm state machine instance
 * @param pin pin number
 * @param baud_rate baud rate
 * @param rgbw true if the WS2812 supports white
 * @return WS2812 instance
 */
ws2812_inst_t *ws2812_init(PIO pio, uint sm, uint pin, float baud_rate, bool rgbw);

/*!
 * Sends a color pixel to the WS2812.
 *
 * @param inst WS2812 instance
 * @param r red component
 * @param g green component
 * @param b blue component
 */
void ws2812_set_rgb(ws2812_inst_t *inst, uint8_t r, uint8_t g, uint8_t b);

/*!
 * Sends a color pixel to the WS2812 using float values.
 *
 * @param inst WS2812 instance
 * @param r red floating point component (between 0 and 1)
 * @param g green floating point component (between 0 and 1)
 * @param b blue floating point component (between 0 and 1)
 */
void ws2812_set_rgb_float(ws2812_inst_t *inst, float r, float g, float b);

#endif //PICO_WS2812_DRIVER_H
