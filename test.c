#include "pstring.h"
#include <stdio.h>

int main() {
    Pstring p1 = {5, "aaaaa"};
    printf("Length of p1: %d\n", pstrlen(&p1));
    return 0;
} 