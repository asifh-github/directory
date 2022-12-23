// own implementation 
// to run: gcc -I ./include/ unit_test_vector_string.c vector_string.c -o unit_test_vector_string.bin
#include "vector_string.h"
#include "str_cmp.h"
#include <stdio.h>
#include <string.h>

int main() {
    printf("~unit_test_vector_string.c~\n\n");
    // create strings
    printf("\n~ Creating three strings...\n\n");
    char *str1 = "all";
    char *str2 = "ball";
    char *str3 = "call";

    // allocate vector string
    printf("\n~ Allocating vector string...\n"); 
    vector_string *vs = vector_string_allocate();

    // insert strings 
    printf("\n~ Inserting two strings in vector string...\n");
    vector_string_insert(vs, str1);
    vector_string_insert(vs, str2);

    // find strings
    printf("\n~ Searching for %s in vector string...\n", str1);
    if(vector_string_find(vs, str1)) {
        printf("-> Success: found/exists!\n");
    }
    printf("\n~ Searching for %s in vector string...\n", str3);
    if(!vector_string_find(vs, str3)) {
        printf("-> Success: not found/ do not exists!\n");
    }

    // insert & find str3
    printf("\n~ Inserting last string in vector string...\n");
    vector_string_insert(vs, str3);
    printf("\n~ Agian searching for %s in vector string...\n", str3);
    if(vector_string_find(vs, str3)) {
        printf("-> Success: found/exists!\n");
    }

    // print vector string
    printf("\n~ Printing vector string...\n");
    vector_string_print(vs);

    // deallocate vector string
    printf("\n~ Deallocating vector string...\n\n");
    vector_string_deallocate(vs);

    return 0;
}