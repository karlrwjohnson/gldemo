#include <stdio.h>

float doThing(int x) {
    return 1.2;
}

void glClear(unsigned int mask) {
    printf("glClear(): mask = %u\n", mask);
}

void noArgs() {
    printf("noArgs() called");
}
