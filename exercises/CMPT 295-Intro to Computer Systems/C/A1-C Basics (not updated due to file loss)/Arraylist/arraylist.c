
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "arraylist.h"

////////////////////////////////////////////////////////////////////////////////
//Functions that you need to implement:

/*
 * Append the value x to the end of the arraylist. If necessary, double the
 * capacity of the arraylist.
 */
void arraylist_add(arraylist *a, void *x)
{
    // TODO
    // check if arraylist != NULL and size of array of pointers (buffer) != 0,
    // and pointer x != NULL
    if (a != NULL && a->buffer_size != 0 && x != NULL) {
        // if length < size of array of pointers (buffer)
        if(a->length < a->buffer_size) {
            // add pointer x at the end/length of array
            a->buffer[a->length] = x;
            // increment length by 1
            a->length++;
        }
        // if length >= size of array of pointers (buffer)
        else {
            // reallocte (double sized) dynamic memory to store pointers 
            void **temp_ptrArr = (void**)realloc(a->buffer, 2*a->buffer_size*sizeof(void*));
            // check if temp_ptrArr != NULL
            if (temp_ptrArr != NULL) {
                // update address of buffer
                a->buffer = temp_ptrArr;                
            }           
            // update buffer size
            a->buffer_size = 2 * a->buffer_size;
            // add pointer x at the end/length of array
            a->buffer[a->length] = x;
            // increment length by 1
            a->length++;
        }
    }
    else {
        printf("NULL Argument(s) passed in Function\n");
    }
}

/*
 * Store x at the specified index of the arraylist. Previously stored values
 * should be moved back rather than overwritten. It is undefined behavior to
 * insert an element with an index beyond the end of an arraylist.
 */
void arraylist_insert(arraylist *a, unsigned int index, void *x)
{
    // TODO
    // Hint: Consider how you could implement this function in terms of
    // arraylist_add()
    // check if arraylist != NULL and size of array of pointers (buffer) != 0,
    // and pointer x != NULL
    if (a != NULL && a->buffer_size != 0 && x != NULL) {
        // if length + 1  <  size of array of pointers (buffer)
        if((a->length + 1) < a->buffer_size) {
            // move elements (pionters) of array from [index] to array[length -1] 
            // to array[index + 1] and array[length + (-1 + 1)] 
            memmove(&a->buffer[index + 1], &a->buffer[index], (a->length - index) * sizeof(void*));
            // add pointer x at the index of array
            a->buffer[index] = x;
            // increment length by 1
            a->length++;
        }
        // if length + 1  >=   size of array of pointers (buffer)
        else {
            // reallocte (double sized) dynamic memory to store pointers 
            void **temp_ptrArr = (void**)realloc(a->buffer, 2*a->buffer_size*sizeof(void*));
            // check if temp_ptrArr != NULL
            if (temp_ptrArr != NULL) {
                // update address of buffer
                a->buffer = temp_ptrArr;                
            }      
            // update buffer size
            a->buffer_size = 2 * a->buffer_size;
            // move elements (pionters) of array from [index] to array[length -1] 
            // to array[index + 1] and array[length] 
            memmove(&a->buffer[index + 1], &a->buffer[index], (a->length - index) * sizeof(void*));
            // add pointer x at the index of array
            a->buffer[index] = x;
            // increment length by 1
            a->length++;
        }
    }
    else {
        printf("NULL Argument(s) passed in Function\n");
    }
}

/*
 * Free any memory used by that arraylist.
 */
void arraylist_free(arraylist *a)
{
    // Hint: How many times is malloc called when creating a new arraylist?
    // TODO
    // check if arraylist != NULL
    if(a != NULL) {
        // check if array of pointers (buffer) != NULL
        if(a->buffer_size != 0) {
            // free array of pointers (buffer) 
            // !!doing this prompts error message when run locally on macos!!
            free(a->buffer);
            a->buffer = NULL;
        }
        //free arraylist
        free(a);
        a = NULL;
    }
}

////////////////////////////////////////////////////////////////////////////////

arraylist *arraylist_new()
{
    arraylist *a = (arraylist *)malloc(sizeof(arraylist));
    a->buffer = (void **)malloc(4 * sizeof(void *));
    a->buffer_size = 4;
    a->length = 0;

    return a;
}

void arraylist_remove(arraylist *a, unsigned int index)
{
    for (unsigned int i = index; i < a->length - 1; i++)
        a->buffer[i] = a->buffer[i + 1];

    --a->length;
}

void *arraylist_get(arraylist *a, unsigned int index)
{
    return a->buffer[index];
}

void arraylist_print(arraylist *a)
{
    printf("[");
    if (a->length > 0)
    {
        for (unsigned int i = 0; i < a->length - 1; i++)
            printf("%d, ", *(int *)arraylist_get(a, i));
        printf("%d", *(int *)arraylist_get(a, a->length - 1));
    }

    printf("]\n");
}

void arraylist_output(arraylist *a, char *output, int *pos)
{
    int index = 0;
    sprintf(output + *pos, "[");
    ++*pos;
    if (a->length > 0)
    {
        for (unsigned int i = 0; i < a->length - 1; i++)
        {
            index = sprintf(output + *pos, "%d, ", *(int *)arraylist_get(a, i));
            (*pos) = (*pos) + index;
        }
        index = sprintf(output + *pos, "%d", *(int *)arraylist_get(a, a->length - 1));
        (*pos) = (*pos) + index;
    }
    sprintf(output + *pos, "]\n");
    (*pos) = (*pos) + 2;
}
