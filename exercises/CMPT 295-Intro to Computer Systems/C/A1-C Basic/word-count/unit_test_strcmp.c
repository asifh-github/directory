// WRITE YOUR OWN
// Build  gcc -I ./include/ unit_test_strcmp.c str_cmp.c -o unit_test_str_cmp.bin
#include "str_cmp.h"
#include <stdio.h>

int main() {
    printf("~unit_test_str_cmp.c~\n\n\n");
    // create strings
    const char *s1 = "apPle";
    const char *s2 = "apple";
    const char *s3 = "apple ";
    const char *s4 = " K.O. ";
    const char *s5 = " K.O. ";

    // compare "apPle" & "apple"
    printf("Comparing %s and %s:\n", s1, s2);
    if(my_str_cmp(s1, s2)){
        printf("Success: Strings does not match!\n\n");
    }

    // compare "apple" & "apple "
    printf("Comparing %s and %s (has space char):\n", s2, s3);
    if(my_str_cmp(s2, s3)){
        printf("Success: Strings does not match!\n\n");
    }

    // compare " K.O. " & " K.O. "
    printf("Comparing %s and %s:\n", s4, s5);
    if(!my_str_cmp(s4, s5)){
        printf("Success: Strings match!\n\n");
    }

    // compare "apple" & " K.O. "
    printf("Comparing %s and %s:\n", s2, s4);
    if(my_str_cmp(s2, s4)){
        printf("Success: Strings does not match!\n\n");
    }

    return 0;
}
