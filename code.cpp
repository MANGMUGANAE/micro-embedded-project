#include "gpio.hpp"
#include <unistd.h>

int main() {
    Gpio led(17, Gpio::kOutputLow);

    while (true) {
        led.Set(1);
        usleep(500000);
        led.Set(0);
        usleep(500000);
    }
}
