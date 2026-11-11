#include "gpio.hpp"
#include <unistd.h>
#include <cstdio>
#include <ctime>

double now_us() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec * 1e6 + ts.tv_nsec / 1e3;
}

int main() {
    Gpio left_buzzer(27, Gpio::kOutputLow);
    Gpio right_buzzer(22, Gpio::kOutputLow);
    if (!left_buzzer.ok() || !right_buzzer.ok()) return 1;

    double freq_l = 0, freq_r = 0;
    bool state_l = false, state_r = false;
    double last_toggle_l = now_us(), last_toggle_r = now_us();
    double last_read = 0;

    while (true) {
        double t = now_us();

        if (t - last_read > 15000) {
            FILE* f = fopen("/tmp/hand_state", "r");
            if (f) {
                fscanf(f, "%lf %lf", &freq_l, &freq_r);
                fclose(f);
            }
            last_read = t;
        }

        if (freq_l <= 0) {
            if (state_l) { left_buzzer.Set(0); state_l = false; }
        } else if (t - last_toggle_l >= 500000.0 / freq_l) {
            state_l = !state_l;
            left_buzzer.Set(state_l);
            last_toggle_l = t;
        }

        if (freq_r <= 0) {
            if (state_r) { right_buzzer.Set(0); state_r = false; }
        } else if (t - last_toggle_r >= 500000.0 / freq_r) {
            state_r = !state_r;
            right_buzzer.Set(state_r);
            last_toggle_r = t;
        }

        usleep(100);
    }
}
