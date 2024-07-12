/**
 * Copyright (c) 2020 Raspberry Pi (Trading) Ltd.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 *
 * Modified by Deleranax
 */

#include "ws2812.h"
#include "ws2812.pio.h"

ws2812_inst_t *ws2812_init(PIO pio, uint sm, uint pin, float baud_rate, bool rgbw) {
    ws2812_inst_t *inst = malloc(sizeof(ws2812_inst_t));
    uint offset = pio_add_program(pio, (const pio_program_t *) &ws2812_program);

    ws2812_program_init(pio, sm, offset, pin, baud_rate, rgbw);

    inst->pio = pio;
    inst->sm = sm;
    inst->pin = pin;

    return inst;
}

void ws2812_deinit(ws2812_inst_t *inst) {
    pio_sm_set_enabled(inst->pio, inst->sm, false);

    free(inst);
}

void ws2812_set_rgb(ws2812_inst_t *inst, uint8_t r, uint8_t g, uint8_t b) {
    uint32_t grb = ((uint32_t) (r) << 8) |((uint32_t) (g) << 16) |(uint32_t) (b);

    pio_sm_put_blocking(inst->pio, inst->sm, grb << 8u);
}

void ws2812_set_rgb_float(ws2812_inst_t *inst, float r, float g, float b) {
    r = fmaxf(fminf(r, 1), 0);
    g = fmaxf(fminf(g, 1), 0);
    b = fmaxf(fminf(b, 1), 0);

    ws2812_set_rgb(inst, (uint8_t) floorf(r * 255), (uint8_t) floorf(g * 255), (uint8_t) floorf(b * 255));
}
