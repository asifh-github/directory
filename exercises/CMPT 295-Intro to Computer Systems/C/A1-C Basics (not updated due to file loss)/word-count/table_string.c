#include "table_string.h"
#include "str_cmp.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUCKETS
// DO NOT ADD ANY NEW FUNCTIONS BEFORE djb2
// Hash a character array to integer value between 0 and buckets-1.
// See here for more details: https://theartincode.stanis.me/008-djb2/
unsigned int djb2_word_to_bucket(char *word, int buckets) {
  if (!word) {
    printf("Invoked with null string");
    exit(EXIT_FAILURE);
  }
  unsigned long hash = 5381;
  uint32_t i;

  for (i = 0; i < strlen(word); i++)
    hash = ((hash << 5) + hash) + word[i];

  return hash & (buckets - 1);
}
// ADD YOUR HELPER FUNCTIONS AFTER djb2
/**
 * @brief Instantiate a table string
 *
 * @param buckets
 * @return table_string*
 */
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

table_string *table_string_allocate(unsigned int buckets) {
  // Instantiate a bucket number of heads

  // allocate memory for table string ts
  table_string *ts = (table_string*)malloc(sizeof(table_string));
  // check if malloc was successful
  if(ts == NULL) {
    // unsuccessful: return NULL
    return NULL;
  }
  // if successful:
  // allocate memory for ts->head, array of vs_entry_t ptr
  ts->heads = (vs_entry_t**)malloc(buckets * sizeof(vs_entry_t*));
  // check if malloc was successful
  if(ts->heads == NULL) {
    // unsuccessful: free ts and return NULL
    free(ts);
    ts = NULL;
    return NULL;
  }
  // if successful
  // fill the array w/ null vaules
  for(int i=0; i<buckets; i++){
    ts->heads[i] = NULL;
  }
  // assing no. of buckets to ts->buckets 
  ts->buckets = buckets;

  // return table string ts
  return ts;
}



/**
 * @brief Insert the string pointed to by word into the table string.
 *   If word is already found increment count.
 *   If word is not found insert at the end of the corresponding bucket
 * @param ts - Pointer to table_string datastructure
 * @param word - Pointer to string to search for
 * @return * Find*
 */
void table_string_insert_or_add(table_string *ts, char *word, int line) {
  // Find the bucket for word. djb2 will return a value between 0-buckets-1.
  // Rule: buckets can only be power of 2.

  // check if ts != NULL and word != NULL
  if(ts == NULL || word == NULL) {
    printf("NULL Augument in Function\n");
    return;
  }

  // get corresponding bucket/hash
  int bucket = djb2_word_to_bucket(word, ts->buckets);

  // TODO:
  // Case head == NULL: bucket hasn't been initialized yet
  // Case word already in list, add to line array.
  // Case word not found, insert word and return.

  // check if ts->heads == NULL/buffer not assigned
  if(ts->heads == NULL) {
    // NULL: assign ts->buckets = 4 and reallocate memory for ts->heads
    // ! malloc can be used here !
    ts->buckets = 4;
    ts->heads = (vs_entry_t**)malloc(4 * sizeof(vs_entry_t*));
  }
  // check if malloac was successful
  if(ts->heads == NULL) {
    printf("Memory Allocation Falied\n");
    return;
  }

  // check if ts->heads[bucket] == NULL (list) has word
  if(ts->heads[bucket] == NULL) {
    // NULL: create entry and insert
    vs_entry_t *entry = (vs_entry_t*)malloc(sizeof(vs_entry_t));
    // check if malloc was successful
    if(entry == NULL) {
      // unsuccessful
      printf("Memory Allocation Failed\n");
      return;
    }  

    // successful:
    // set entry->value = word;
    // ! assumption: entry->value is externally allocated !
    entry->value = (char*)malloc((my_str_len(word) + 1) * sizeof(char));
    // check if malloc was successful
    if(entry->value == NULL) {
      // unsuccessful
      printf("Memory Allocation Failed\n");
      return;
    }
    entry->value = word;
    // set entry->next = NULL
    entry->next = NULL;
    // allocate memory for int *lines for line numbers, size = 1 int
    entry->lines = (int*)malloc(1 * sizeof(int));
    // check if malloc was successful
    if(entry->lines == NULL) {
      // unsuccessful
      printf("Memory Allocation Failed\n");
      return;
    }
    // set entry->lines = line
    entry->lines[0] = line;
    //  set entry->size_of_lines to 1
    entry->size_of_lines = 1;
    // assign entry to header and entry = NULL
    ts->heads[bucket] = entry;
  }
  // not NULL/has entry : 
  else {
    // assign curr ptr to header
    vs_entry_t *curr = ts->heads[bucket];
    // set found = false
    bool found = false;
    // loop and check if word exists in ts->heads[bucket], (list) == word 
    while(curr != NULL) {
      if(!my_str_cmp(curr->value, word)) {
        // word exists
        found = true;
        break;
      }
      curr = curr->next;
    }

    // if word exists in list, found == true
    if(found){
      // reallocate memory for int *lines for line numbers, size = size + 1
      curr->lines = (int*)realloc(curr->lines, (curr->size_of_lines + 1) * sizeof(int));
      // check if malloc was successful
      if(curr->lines == NULL) {
        // unsuccessful
        printf("Memory Allocation Failed\n");
        return;
      }
      // set curr_entry->lines = line
      curr->lines[curr->size_of_lines] = line;
      //  set curr_entry->size_of_lines to size_of_lines + 1 
      curr->size_of_lines++;
    }
    // if word does not exists in list, found == false
    else{
      // create entry and insert
      vs_entry_t *entry = (vs_entry_t*)malloc(sizeof(vs_entry_t));
      // check if malloc was successful
      if(entry == NULL) {
        // unsuccessful
        printf("Memory Allocation Failed\n");
        return;
      } 

      // successful:
      // set entry->value = word;
      // ! assumption: entry->value is externally allocated !
      entry->value = word;
      // set entry->next = NULL
      entry->next = NULL;
      // allocate memory for int *lines for line numbers, size = 1 int
      entry->lines = (int*)malloc(1 * sizeof(int));
      // check if malloc was successful
      if(entry->lines == NULL) {
        // unsuccessful
        printf("Memory Allocation Failed\n");
        return;
      }
      // set entry->lines = line
      entry->lines[0] = line;
      //  set entry->size_of_lines to 1
      entry->size_of_lines = 1;
      // assign entry to tail of header and entry = NULL
      vs_entry_t* temp = ts->heads[bucket];
      while(temp != NULL){
        if(temp->next == NULL) {
          temp->next = entry;
          break;
        }
        temp = temp->next;
      }
    }
  }
}

void table_string_deallocate(table_string *ts) {
  // TODO:
  // Free the linked list of each bucket
  // Free the array of head pointers
  // Free the structure itself

  // check if ts != NULL, table_string
  if(ts != NULL) {
    // check if ts->heads != NULL, table_string[index] (buckets)
    if(ts->heads != NULL) {
      // loop through ts->heads, headed/each head
      for(int i=0; i<ts->buckets; i++) {
          // assign pointer curr to header[i] (list) and pointer temp to NULL;
          vs_entry_t *curr_entry = ts->heads[i];
          vs_entry_t *temp = NULL;
          // iterate over header[i] (list) until curr_entry == NULL
          while(curr_entry->value != NULL) {
            // assign temp ptr to curr ptr
            temp = curr_entry;
            // assign curr ptr to curr->next
            curr_entry = curr_entry->next;
             // check if entry->value != NULL, char* array
            if(temp->value != NULL) {
              // free temp->value and set NULL
              free(temp->value);
              temp->value = NULL;
            }
            // check if entry->line != NULL, int array of entry
            if(temp->lines != NULL) {
              // free temp->line and set NULL
              free(temp->lines);
              temp->lines = NULL;
            }
            // free entry/temp
            free(temp);
            temp = NULL;
          }
      }
      // free ts->heads and set NULL, header
      free(ts->heads);
      ts->heads = NULL;
    }
    // free ts and set NULL, table_string
    free(ts);
    ts = NULL;
  } 
}

void table_string_print(table_string *ts) {
  /** TODO:
   for each bucket
    for each entry in bucket
      print entry->word: line line line
  */

// check if ts != NULL
  if(ts != NULL) {
    // check if ts->heads != NULL
    if(ts->heads != NULL) {
      // assign header ptr to ts->heads
      vs_entry_t **header = ts->heads;
      // loop through ts->heads, headed/each head
      for(int i=0; i<ts->buckets; i++){
        // assign pointer curr to header[i] (list)
        vs_entry_t *curr_entry = header[i];
        // iterate over header[i] (list) until curr_entry == NULL
          while(curr_entry- != NULL) {
            // print string/word
            printf("%s: ", curr_entry->value);
            // loop through line to print line numbers
            for(int j=0; j<curr_entry->size_of_lines; j++) {
              // print line numbers
              printf("%d ", curr_entry->lines[j]);
            }
            // print new line
            printf("\n");
            // assign curr entry ptr to next entry/elemnt
            curr_entry = curr_entry->next;
          }
      }
    }
  }
}