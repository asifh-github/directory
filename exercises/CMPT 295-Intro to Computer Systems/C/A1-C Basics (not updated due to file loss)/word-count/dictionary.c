#include <ctype.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vector_char.h>
#include <vector_string.h>
int main(int argc, char **argv) {
  char *source = NULL;

  if (argc != 2) {
    printf("./grade_tokenize.bin [FILE PATH]");
    exit(1);
  }
  /**
   * @brief Read file into source.
   * source is a character array with file contents
   * It is null terminated
   */
  FILE *fp = fopen(argv[1], "r");
  if (fp == NULL) { /* Error */
    printf("Error reading file");
    exit(1);
  }
  if (fp != NULL) {
    /* Go to the end of the file. */
    if (fseek(fp, 0L, SEEK_END) == 0) {
      /* Get the size of the file. */
      long bufsize = ftell(fp);
      if (bufsize == -1) { /* Error */
        printf("Error reading file");
      }
      /* Allocate our buffer to that size. */
      source = malloc(sizeof(char) * (bufsize + 1));
      /* Go back to the start of the file. */
      if (fseek(fp, 0L, SEEK_SET) != 0) { /* Error */
      }
      /* Read the entire file into memory. */
      size_t newLen = fread(source, sizeof(char), bufsize, fp);
      if (ferror(fp) != 0) {
        printf("Error reading file");
      } else {
        source[newLen++] = '\0'; /* Just to be safe. */
      }
    }
  }
  fclose(fp);

  // TODO: Process source[] and count the number of words
  // Print the number of words in the end.

  // create a pointer to source/string
  char *ptr = source; 
  //create vector_char_t
  vector_char_t *header = vector_char_allocate();
  // create vector string 
  vector_string *list = vector_string_allocate();

  // iterate over chars in source/string  
  while(*ptr != '\0') {
    if(header == null) {
        //create vector_char_t
        vector_char_t *header = vector_char_allocate();
    }
    // check if char is (alphanumeric): 0-9, A-Z, & a-z
    if((*ptr >= 0 && *ptr <= 9) || (*ptr >= 65 && *ptr <= 90) || (*ptr >= 97 && *ptr <= 122)) {
      // accumulate char in vector_char_t header
      vector_char_add(header, *ptr);
    }
    // if char is non-alphanumeric
    else{
      // if header->len != 0 
      if(header->len != 0) {
        // add NULL terminator to vector_char_t header
        vector_char_add(header, '\0');
        // get string from vector_char_t header
        char *token_ptr = vector_char_get_array(header);
        // check if string exists in vector string
        if(!vector_string_find(list, token_ptr)) {
          // string does not exists
          vector_string_insert(list, token_ptr);
        }
        // string exists: skip insert
        // reset vector_char_t header
        // !! MEMEORY LEAK MAY OCCUR HERE !!
        //free(header->data)
        header->data = NULL;
        header->len = header->max = 0;
        //memset(header->data, '\0', (header->len + 1) * sizeof(char));
        //header->len = 0;
        token_ptr = NULL;
      }
    }
    // increment pointer to source/string by 1
    ptr++;
  }

  // print vector string vs
  vector_string_print(list);

  // free  dynamic memory allocated for vector_string vs
  vector_string_deallocate(list);
  // free dynamic memory allocated for vector_char_t header
  vector_char_delete(header);
  // free dynamic memory allocated for source
  free(source);
  ptr = NULL;
  source = NULL;

  return 0;
}