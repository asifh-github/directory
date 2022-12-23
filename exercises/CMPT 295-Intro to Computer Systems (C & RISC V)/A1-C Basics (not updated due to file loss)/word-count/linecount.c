#include <ctype.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <table_string.h>
#include <vector_char.h>
int main(int argc, char **argv) {
  char *source = NULL;

  if (argc != 2) {
    printf("./wordcount.bin [FILE PATH]");
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

  /** Start processing file and separate into words */
  // TODO: Write linecount

  // create a pointer to source/string
  char *ptr = source; 
  //create vector_char_t
  vector_char_t *header = vector_char_allocate();
  // create table string of size 8 buckets
  table_string *ts = table_string_allocate(4);

  // set line count = 1
  unsigned int line_count = 1;

  while(*ptr != '\0') {
    // check for new line/lien number
    if(*ptr == '\n') {
      // if new line, increment line count
      line_count++;
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
        // add string to table string
        table_string_insert_or_add(ts, token_ptr, line_count);
        // reset vector_char_t header
        // !! MEMEORY LEAK MAY OCCUR HERE !!
        header->data = NULL;
        header->len = header->max = 0;
        //memset(header->data, '\0', (header->len + 1) * sizeof(char));
        //header->len = 0;
      }
    }
    // increment pointer to source/string by 1
    ptr++;
  }

  // print table string ts
  table_string_print(ts);

  // free  dynamic memory allocated for vector_string vs
  table_string_deallocate(ts);
  // free dynamic memory allocated for vector_char_t header
  vector_char_delete(header);
  // free dynamic memory allocated for source
  free(source);
  ptr = NULL;
  source = NULL;

  return 0;
}