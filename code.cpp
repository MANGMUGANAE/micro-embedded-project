#include "gpio.hpp"
#include <unistd.h>

int main() {
    Gpio led(17, Gpio::kOutputLow);
    if (!led.ok()) return 1;

    const int period_us = 20000;
    while (true) {
        for (int duty = 0; duty <= 100; ++duty) {
            int on_us = period_us * duty / 100;
            int off_us = period_us - on_us;
            for (int cycle = 0; cycle < 50; ++cycle) {
                led.Set(1);
                usleep(on_us);
                led.Set(0);
                usleep(off_us);
            }
        }
    }
}
