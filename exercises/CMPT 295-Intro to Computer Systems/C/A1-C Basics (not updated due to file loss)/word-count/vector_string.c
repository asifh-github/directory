#include "vector_string.h"
#include "str_cmp.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int my_str_len(const char* str) {
  int count = 0;
  if(str != NULL) {
    while(*str != '\0') {
      count++;
      str++;
    }
  }
  return count;
}

/**
/////////////////////////////////////////

*/
/**
 * @brief Memory allocate a vector string so that we can start inserting entries
 * into it.
 *
 */
vector_string *vector_string_allocate() {
  // allocate dynamic memory to store vector string vs
  vector_string *vs = (vector_string*)malloc(sizeof(vector_string));
  // check if vs was successfully allocated
  if(vs == NULL) {
    return NULL;
  }
  // set head and tail to NULL
  vs->head = NULL;
  vs->tail = NULL;

  // return vector string vs
  return vs;
}

/**
 * @brief Search the vector string pointed to by vs and return true if the
 * vs_entry.value == key, else return false.
 * TODO:
 * @param vs - Pointer to vector_string datastructure
 * @param key - Pointer to string to search for
 * @return * Find*
 */
bool vector_string_find(vector_string *vs, char *key) { 
  // check if vector string vs != NULL 
  if(vs == NULL) {
    // return false
    return false;
  }

  // assign pointer curr to vs->head
  vs_entry_t *curr = vs->head;
  // iterate over linked list until vs->head == NULL
  while(curr != NULL) {
    // check if strings match
    if(!my_str_cmp(curr->value, key)){
      // returns 0: return ture
      return true;
    }
    // assign pointer curr to next entry/element
    curr = curr->next;
  }

  // if string not found in vector string vs
  return false; 
  }

/**
 * @brief TODO: Insert the string pointed to by key into the vector string.
 *  char* is externally allocated. You do not have to allocate internally
 *
 * @param vs - Pointer to vector_string datastructure
 * @param key - Pointer to string to search for
 * @return * Find*
 */
void vector_string_insert(vector_string *vs, char *key) {
  // Insert the string into the tail of the list.
  // check if vector string vs != NULL and key != NULL
  if(vs == NULL) {
    printf("NULL Argument in Function\n");
    return;
  }

  // create entry to put in vector string vs
  vs_entry_t *entry = (vs_entry_t*)malloc(sizeof(vs_entry_t));
  // check if memory allocataion was successful
  if(entry == NULL) {
    // malloc: not successfull
    printf("Memory Allocation Failed\n");
    return;
  }

  // malloc: successful
  // create dynamic memory for value 
  entry->value = (char*)malloc(my_str_len(key + 1)*sizeof(char))
  // assign entry->value = key and enrty->next = NULL
  memcpy(entry->value, key, my_str_len(key));
  entry->value[my_str_len(key)] = '\0';
  entry->next = NULL;
  // check if vector string is empty, vs-> head/tail == NULL
  if (vs->head == NULL) {
    // assign vs->head, tail = entry
    vs->head = entry;
    vs->tail = entry;
  } 
  // if vector string vs non-empty
  else{
    // assign vs->tail->next = entry
    vs->tail->next = entry;
    // assign tail to last entry/element 
    vs->tail = entry;
  }
}

/**
 * @brief Remove all entries and cleanup vector string
 * TODO: Remove all entries. Remember head and tail are pointers.
 * Remember to remove vs as well; not just entries. or you will have memory
 * leaks.
 * @param vs: Pointer to vector_string struct
 */
void vector_string_deallocate(vector_string *vs) {
  // check if vector string vs != NULL 
  if(vs == NULL) {
    printf("NULL Argument in Function\n");
    return;
  }

  // assign pointer curr to vs->head and pointer temp to NULL;
  vs_entry_t *curr = vs->head;
  vs_entry_t *temp = NULL;
  // iterate over vector string vs until vs->head == NULL
  while(curr != NULL) {
    // assign temp ptr to curr ptr
    temp = curr;
    // assign curr ptr to curr->next
    curr = curr->next;
    // free entry->value
    free(temp->value);
    temp->value = NULL;
    // free entry/temp
    free(temp);
    temp = NULL;
  }
  // free vector string vs
  free(vs);
  vs = NULL;
}

/**
 * @brief Print all value in each entry of the vector string, in the following
 * format. In this case hello and world are the unique words in the file.
 * 1. hello
 * 2. world
 * @param vs
 */
void vector_string_print(vector_string *vs) {
  // check if vector string vs != NULL 
  if(vs == NULL) {
    printf("NULL Argument in Function\n");
    return;
  }

  // assign count = 0
  unsigned int count = 0;
  // assign pointer entry to vs->head
  vs_entry_t *entry = vs->head;
  // printf("~ %s\n", entry->value);
  // iterate over vector string vs until vs->head == NULL
  while(entry != NULL) {
    // increment count by 1
    count++;
    // print string in entry from vector string vs
    printf("%d. %s\n", count, entry->value);
    // assign entry ptr to next entry/elemnt
    entry = entry->next;
  }
}