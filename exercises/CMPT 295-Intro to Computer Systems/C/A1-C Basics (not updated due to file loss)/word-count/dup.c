#include <ctype.h>
#include <dedup.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <table_string.h>
#include <vector_char.h>

/* Read file into a characater buffer */
char *readfile(char *filename) {
  char *source;
  FILE *fp = fopen(filename, "r");
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
  return source;
}

int main(int argc, char **argv) {
  char *source = NULL;

  if (argc != 3) {
    printf("./dedup.bin [FILE PATH1] [FILE PATH2]");
    exit(1);
  }
  char *source1 = readfile(argv[1]);
  char *source2 = readfile(argv[2]);
  /**
   * @brief Read file into source.
   * source is a character array with file contents
   * It is null terminated
   */

  // argv[1] name of file1
  // argv[2] name of file2
  /** Start processing file and separate into words */
  /** Create Table String 1 with file in argv[1] */
  /** Create Table string 2 with file in argv[2] */
  /** Find common words between ts1 and ts2 */
  /** Deallocate **/

  // create 2 table string of size 8 buckets
  table_string *ts_1 = table_string_allocate(8);
  table_string * ts_2 = table_string_allocate(8);

  // iter through source1 and populate ts_1
  // create a pointer to source/string
  char *ptr = source1; 
  //create vector_char_t
  vector_char_t *header = vector_char_allocate();
  // set line count = 1
  unsigned int line_count = 1;
  while(*ptr != '\0') {
    // check if char is (alphanumeric): 0-9, A-Z, & a-z
    if(((*ptr >= 0 && *ptr <= 9) || (*ptr >= 65 && *ptr <= 90) || (*ptr >= 97 && *ptr <= 122)) && (*ptr != '\n')) {
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
        table_string_insert_or_add(ts_1, token_ptr, line_count);
        // reset vector_char_t header
        free(header->data);
        header->data = NULL;
        header->len = header->max = 0;
      }
    }
    // check for new line/lien number
    if(*ptr == '\n') {
      // if new line, increment line count
      line_count++;
    }
    // increment pointer to source/string by 1
    ptr++;
  }


  // iter through source2 and polupate ts_2
  // create a pointer to source/string
  ptr = source2;
  // reset vector_char_t header
  if(header->data != NULL) {
    free(header->data);
  }
  header->data = NULL;
  header->len = header->max = 0;
  // reset line count = 1
  line_count = 1;
  while(*ptr != '\0') {
    // check if char is (alphanumeric): 0-9, A-Z, & a-z
    if(((*ptr >= 0 && *ptr <= 9) || (*ptr >= 65 && *ptr <= 90) || (*ptr >= 97 && *ptr <= 122)) && (*ptr != '\n')) {
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
        table_string_insert_or_add(ts_2, token_ptr, line_count);
        // reset vector_char_t header
        free(header->data);
        header->data = NULL;
        header->len = header->max = 0;

      }
    }
    // check for new line/lien number
    if(*ptr == '\n') {
      // if new line, increment line count
      line_count++;
    }
    // increment pointer to source/string by 1
    ptr++;
  }

  // test: print 2 table strings 
  table_string_print(ts_1);
  table_string_print(ts_2);

  // free  dynamic memory allocated for  2 table strings
  table_string_deallocate(ts_1);
  table_string_deallocate(ts_1);

  // free dynamic memory allocated for vector_char_t header
  vector_char_delete(header);
  // free dynamic memory allocated for sources
  free(source1);
  source1 = NULL;
  free(ptr);
  source2 = NULL;

  return 0;
}