#include "str_cmp.h"

/**
 * @brief Compare two strings
 *
 * @param s1
 * @param s2
 * @return int
 */
int my_str_cmp(const char *s1, const char *s2) {
  // TODO: Compare two character arrays. return 0 if they match, 1 otherwise
  // You can assume that s1 and s2 are null terminated strings.
  // WARNING: strings could potentially be of different lengths
  // e.g., "apple" does not match "apple " (which includes the extra space).
  // Value to be returned will be 1.
  // You cannot use any of the string helper functions including strlen and
  // strncmp, strcmp.

  // create pointers to the start of char arrays, s1 and s2
  char *str1 = (char*)s1;
  char *str2 = (char*)s2;

  // loop over the char arrays until any one array reaches NULL 
  while(*str1 != '\0' && *str2 != '\0') {
    // check if char in position of s1 an s2 does not match
    if(*str1 != *str2) {
      // does not match: returns 1 
      return 1;
    }
    // increment char pointers by 1
    str1++;
    str2++;
  }

  // check if both char arrays reached NULL
  if(*str1 == '\0' && *str2 == '\0') {
    // reached NULL: return 0
    return 0;
  }
  else {
    // only one array reached NULL (does not match): return 1
    return 1;
  }
}
