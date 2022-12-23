#include "dedup.h"
#include "table_string.h"
#include "vector_char.h"
#include <ctype.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int dedup(table_string *ts1, char* file1, table_string *ts2, char* file2) {
  // Find common strings between ts1 and ts2
  // Store in array and print them
  // You can make use of dedup_entry_t (if you want; you can also ignore if you wish)
    // Print them.
    // printf("\n%s", word);
    // printf("\n%s ", file1);
    // Print all lines in file1 with word , separated
    // printf("%d,", entry[i].lines1[j]);
    // printf("\n%s", file2);
    // printf("%d,", entry[i].lines2[j]);

  // check if ts1 != NULL
  if(ts1 != NULL && ts2 != NULL) {
    // check if ts1->heads != NULL
    if(ts1->heads != NULL && ts2->heads != NULL) {
      // assign header1 ptr to ts1->heads
      vs_entry_t **header_1 = ts1->heads;
      // assign header2 ptr to ts2->heads
      vs_entry_t **header_2 = ts2->heads;
      // loop through ts1->heads, headed1/each head
      for(int i=0; i<ts1->buckets; i++){
        // assign pointer curr1 to header1[i] (list)
        vs_entry_t *curr_entry_1 = header_1[i];
        // iterate over header1[i] (list) until curr_entry1 == NULL
        while(curr_entry_1 != NULL) {
          for(int j=0; j<ts2->buckets; j++){
            // assign pointer curr2 to header2[i] (list)
            vs_entry_t *curr_entry_2 = header_2[i];
            // iterate over header2[i] (list) until curr_entry2 == NULL
            while(curr_entry_2 != NULL) {
              if(!my_str_cmp(curr_entry_1->value, curr_entry_2->)){
                // returns 0: return ture
                // print output
                printf("\n%s", curr_entry_2->value);
                printf("\n%s", file1);
                for(int k=0; k<curr_entry_1->size_of_lines; k++) {
                  // print line numbers
                  printf("%d ", curr_entry_1->lines[k]);
                }
                printf("\n%s", file2);
                for(int k=0; k<curr_entry_2->size_of_lines; k++) {
                  // print line numbers
                  printf("%d ", curr_entry_2->lines[k]);
                }
              }
              curr_entry_2 = curr_entry_2->next;
            }
          }
          curr_entry_1 = curr_entry_1->next;
        }
      }
    }
  }
}









