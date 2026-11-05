#include "gpio.hpp"

int main() {
    for (unsigned int line = 0; line <= 27; ++line) {
        Gpio gpio(line, Gpio::kOutputLow);
    }
}
