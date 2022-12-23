  if(ts != NULL) {
    // check if ts->heads != NULL, table_string[index] (buckets)
    if(ts->heads != NULL) {
      // assign header ptr to ts->heads
      vs_entry_t **header = ts->heads;
      // loop through ts->heads, headed/each head
      for(int i=0; i<ts->buckets; i++) {
        // check if ts->heads[i]->head != NULL, table_string[index][entry] (list)
        if(ts->heads[i] != NULL){
          // assign pointer curr to header[i] (list) and pointer temp to NULL;
          vs_entry_t *curr_entry = header[i];
          vs_entry_t *temp = NULL;
          // iterate over header[i] (list) until curr_entry == NULL
          while(curr_entry != NULL) {
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
      }
    } 
    // free ts and set NULL, table_string
    free(ts);
    ts = NULL;
  }