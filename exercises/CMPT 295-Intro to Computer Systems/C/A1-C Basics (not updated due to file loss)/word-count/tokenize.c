#include <ctype.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vector_char.h>

int main(int argc, char **argv) {
  char *source = NULL;

  /**
   * @brief Read file into source.
   * source is a character array with file contents
   * It is null terminated
   */
  if (argc != 2) {
    printf("./grade_tokenize.bin [FILE PATH] \n");
    exit(1);
  }

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

  // TODO: Tokenize processing
  // TODO:source contains the string to be processed.
  /** Start processing file and separate into words */
  /** Pseudocode */
  // 1. Iterate over characters
  // 2. if current-character starts word start accumulating into vector_char
  // 3. if current character terminates word. print and restart word start
  // check. Free all data.
  // Hint: Use vector_char

  // create a pointer to source/string
  char *ptr = source; 
  //create vector_char_t
  vector_char_t *header = vector_char_allocate();

  // iterate over chars in source/string  
  while(*ptr != '\0') {
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
        // print srting
        printf("%s\n", token_ptr);
        // reset vector_char_t header
        //header->data[0] = '\0';
        //header->len = 0;
        _free(header->data);
        header->len = header->max = 0;
      }
    }
    // increment pointer to source/string by 1
    ptr++;
  }

  // free dynamic memory allocated for vector_char_t header
  vector_char_delete(header);
  // free dynamic memory allocated for source
  free(source);
  ptr = NULL;

  return 0;
}