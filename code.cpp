#include "gpio.hpp"
#include <unistd.h>
#include <cstdlib>

void Pwm(Gpio& led, int duty, int period_us, int cycles) {
    int on_us = period_us * duty / 100;
    int off_us = period_us - on_us;
    for (int i = 0; i < cycles; ++i) {
        led.Set(1);
        usleep(on_us);
        led.Set(0);
        usleep(off_us);
    }
}

int main() {
    Gpio led(17, Gpio::kOutputLow);
    if (!led.ok()) return 1;

    const int period_us = 20000;
    while (true) {
        int peak = rand() % 41;
        for (int duty = 0; duty <= peak; ++duty) Pwm(led, duty, period_us, 2);
        for (int duty = peak; duty >= 0; --duty) Pwm(led, duty, period_us, 2);
    }
}
