#include "dogfault.h"
#include "print.h"
#include <assert.h>
#include <ctype.h>
#include <getopt.h>
#include <math.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct Line {
  unsigned long long block;
  short valid;
  unsigned long long tag;
  int lru_clock;
} Line;

typedef struct Set {
  Line *lines;
  int lru_clock;
} Set;

typedef struct Cache {

  // Parameters
  int setBits;     // s
  int linesPerSet; // E
  int blockBits;   // k

  // Core data structure
  Set *sets;

  // Cache statistics
  int eviction_count;
  int hit_count;
  int miss_count;

  // Used for verbose prints
  short displayTrace;
} Cache;

/**
 * @brief Return the tag of the address
 *
 * @param address
 * @param cache
 * @return unsigned long long
 */
unsigned long long cache_tag(const unsigned long long address,
                             const Cache *cache) {
  // TODO:
  // m -> | t | s | k |
  // t -> m >> k >> s
  unsigned long long tag;
  tag = address >> cache->blockBits >> cache->setBits; 
  return tag;
}

/**
 * @brief return the set index of the address
 *
 * @param address
 * @param cache
 * @return unsigned long long
 */
unsigned long long cache_set(const unsigned long long address,
                             const Cache *cache) {
  // TODO:
  // m -> | t | s | k |
  // s -> (m >> k) & ((1U << s) - 1)
  unsigned long long set;
  set = (address >> cache->blockBits) & ((1U << cache->setBits) - 1);
  return set;
}

/**
 * @brief Check if the block of the address is in the cache.
 *  If yes, return true. Else return false
 * @param address
 * @param cache
 * @return true
 * @return false
 */
bool probe_cache(const unsigned long long address, const Cache *cache) {
  /*
   TODO: 1. calculate tag and set values
         2. Iterate over all lines in set
         3. If line is valid and tag matches return true
         4. Set lru clock
  */
  // tag value
  unsigned long long tagBlock = cache_tag(address, cache);
  // set value
  unsigned long long setBlock = cache_set(address, cache);
  // loop over cache_sets for match
  for(unsigned int i=0; i<cache->linesPerSet; i++){
    // check if: cache_line == valid && cache_tag == tagBlock
    if(cache->sets[setBlock].lines[i].valid == true && 
       cache->sets[setBlock].lines[i].tag == tagBlock) {
      // set max_lru = -1
      int max_lru = -1;
      // loop over cache_sets for max_lru
      for(unsigned int j=0; j<cache->linesPerSet; j++) {
        // check if: lru_clock > max_lru
        if(cache->sets[setBlock].lines[j].lru_clock > max_lru) {
          // set max_lru = lru_clock
          max_lru = cache->sets[setBlock].lines[j].lru_clock;
        }
      }
      // max_lru = max_lru + 1
      cache->sets[setBlock].lines[i].lru_clock = max_lru + 1;
      // return true
      return true;
    }
  }
  // return false
  return false;
}

/**
 * @brief Insert block in cache
 *
 * @param address
 * @param cache
 */
void allocate_cache(const unsigned long long address, const Cache *cache) {
  /*
 TODO: 1. calculate tag and set values
       2. Iterate over all lines in set and find empty set.
       3. Insert block. If you do not find an empty block panic as this method
 will always be called in conjunction with avail_cache which verifies there is
 space.
       4. Set lru clock
*/
  // tag value
  unsigned long long tagBlock = cache_tag(address, cache);
  // set value
  unsigned long long setBlock = cache_set(address, cache);
  // set max_lru = -1
  int max_lru = -1;
  // loop over cache_sets to update lru_clock value
  for(unsigned i=0; i<cache->linesPerSet; i++) {
    //check if:  lru_clock > max_lru
    if(cache->sets[setBlock].lines[i].lru_clock > max_lru) {
      max_lru = cache->sets[setBlock].lines[i].lru_clock;
    }
  }
  // loop over cache_sets for empty line
  for(unsigned int i=0; i<cache->linesPerSet; i++) {
    // check if: valid ==  0
    if(cache->sets[setBlock].lines[i].valid == 0) {
      // set cache_sets_lru_clock = max_lru + 1
      cache->sets[setBlock].lines[i].lru_clock = max_lru + 1;
      // set cache_sets_tag = tagBlock
      cache->sets[setBlock].lines[i].tag = tagBlock;
      // set cache_sets_valid = 1
      cache->sets[setBlock].lines[i].valid = 1;
      // return from function
      return;
    }
  }
}

/**
 * @brief Check if empty way available. if yes, return true, else return false.
 *
 * @param address
 * @param cache
 * @return true
 * @return false
 */
bool avail_cache(const unsigned long long address, const Cache *cache) {
  /*
TODO: 1. calculate tag and set values
     2. Iterate over all lines in set and find empty set.
     3. Insert block. If you do find an empty block return true;
     4. If you did not find empty block return false.
*/
  // get tag value
  unsigned long long tagBlock = cache_tag(address, cache);
  // get set value
  unsigned long long setBlock = cache_set(address, cache);
  // loop over cache_sets for empty line
  for(unsigned int i=0; i<cache->linesPerSet; i++) {
    // check if: valid ==  0
    if(cache->sets[setBlock].lines[i].valid == 0) {
      return true;
    }
  }
  return false;
}

/**
 * @brief Find the victim line to be removed from the set
 *      if you run out of space. Return the index/way of the block
 * @param address
 * @param cache
 * @return unsigned long long
 */
unsigned long long victim_cache(const unsigned long long address,
                                Cache *cache) {
  /*
TODO: 1. calculate tag and set values
     2. Iterate over all lines in set and sort them based on lru clock.
     3. Return the way/index of the block with the smallest lru clock
*/
  // get tag value
  unsigned long long tagBlock = cache_tag(address, cache);
  // get set value
  unsigned long long setBlock = cache_set(address, cache);
  // set index = 0
  unsigned int index = 0;
  // set min_lru = cache_sets_lines[0]_lru
  int min_lru = cache->sets[setBlock].lines[index].lru_clock;
  // loop over cache_sets to get lru_clock
  for(unsigned int i=1; i<cache->linesPerSet; i++) {
    // check if: cache_tag == tag && cache_lru_clock < min_lru
    if(cache->sets[setBlock].lines[i].tag == tagBlock && 
       cache->sets[setBlock].lines[i].lru_clock < min_lru) {
      // set min_lru = cache_sets_lines[i]_lru_clock
      min_lru = cache->sets[setBlock].lines[i].lru_clock;
      // set index = i
      index = i;
    }
  }
  // return index
  return index;
}

/**
 * @brief Remove/Invalidate the cache block in corresponding set and way.
 *
 * @param address
 * @param index
 * @param cache
 */
void evict_cache(const unsigned long long address, int index, Cache *cache) {
  // TODO:
  // get set value
  unsigned long long setBlock = cache_set(address, cache);
  // set cache_valid = 0
  cache->sets[setBlock].lines[index].valid = 0;
}

/**
 * @brief Invoked for each memnory access in the memory trace.
 *
 * @param address
 * @param cache
 */
void operateCache(const unsigned long long address, Cache *cache) {
  /** TODO:
   * Use the method above to run the cache.
   * To ensure that your results match against the reference simulator.
   * We provide you the statements to print in each condition. Use them.
   * You should display them only when displayTrace is activated
   */
  // check if: (block) address exists in cache
  if(probe_cache(address, cache) == true) {
    if (cache->displayTrace) {
      // If access hit in the cache
      printf(" hit ");
    }
    // increment hit_count
    cache->hit_count++;
    // return
    return;
  }
  // if: (block) address do not exists in cache
  else {
    // check if: no empty block in cache
    if(avail_cache(address, cache) == false) {
      if (cache->displayTrace) {
        // If access misses in the cache and we needed to evict an entry to insert the block.
        printf(" miss eviction ");
      }
      // get victim line/block in cache
      int index = victim_cache(address, cache);
      // remove victim line/block from cache
      evict_cache(address, index, cache);
      // insert new line/block in cache
      allocate_cache(address, cache);
      // incerment eviction_count
      cache->eviction_count++;
    }
    // if: there is empty block in cache
    else {
      if (cache->displayTrace) {
        // If access misses in the cache we did not
        printf(" miss ");
      }
      // insert block in cache
      allocate_cache(address, cache);
    }
    // increment miss_count
    cache->miss_count++;
  }
  // return
  return;
}

// DO NOT MODIFY LINES HERE. OTHERWISE YOUR PROGRAM WILL FAIL
// get the input from the file and call operateCache function to see if the
// address is in the cache.
void operateFlags(char *traceFile, Cache *cache) {
  FILE *input = fopen(traceFile, "r");
  int size;
  char operation;
  unsigned long long address;
  while (fscanf(input, " %c %llx,%d", &operation, &address, &size) == 3) {
    if (cache->displayTrace)
      printf("%c %llx,%d", operation, address, size);

    switch (operation) {
    case 'M':
      operateCache(address, cache);
      // Incrementing hit_count here to account for secondary access in M.
      cache->hit_count++;
      if (cache->displayTrace)
        printf("hit ");
      break;
    case 'L':
      operateCache(address, cache);
      break;
    case 'S':
      operateCache(address, cache);
      break;
    }
    if (cache->displayTrace)
      printf("\n");
  }
  fclose(input);
}

/**
 * @brief Initialize the cache. Allocate the data structures on heap and return
 * ptr.
 *
 * @param cache
 */
void cacheSetUp(Cache *cache) {
  // TODO:
  // get set value
  int s = cache->setBits;
  // get lines/blocks per set
  int E = cache->linesPerSet;
  // set number of sets in cache
  int S = 1U << s;
  // allocate dynamic memory for cache_sets
  cache->sets = (Set*)malloc(S * sizeof(Set));
  // loop over cache_sets and allocate space for cache_sets_lines
  for(unsigned int i=0; i<S; i++) {
    cache->sets[i].lines = (Line*)malloc(E * sizeof(Line));
    // loop over cache_sets_lines and set values = 0
    for(unsigned int j=0; j<E; j++) {
      // lru_clock
      cache->sets[i].lines[j].lru_clock = 0;
      // valid
      cache->sets[i].lines[j].valid = 0;
      // tag
      cache->sets[i].lines[j].tag = 0;
    }
  }
  // set counts = 0
  // hit_count
  cache->hit_count = 0; 
  // miss_count
  cache->miss_count = 0;
  // eviction_count
  cache->eviction_count = 0;
}

/** Free up cache memory */
void deallocate(Cache *cache) {
  // TODO:
  // get set value
  int s = cache->setBits;
  // set number of sets in cache
  int S = 1U << s;
  // loop over cache_sets and deallocate space (created) for cache_sets_lines
  for(unsigned int i=0; i<S; i++) {
    free(cache->sets[i].lines);
  }
  // deallocated space (created) for cache_sets
  free(cache->sets);
}

int main(int argc, char *argv[]) {
  Cache cache;

  opterr = 0;
  cache.displayTrace = 0;
  int option = 0;
  char *traceFile;
  // accepting command-line options
  // "assistance from"
  // https://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html#Example-of-Getopt
  while ((option = getopt(argc, argv, "s:E:b:t:LFv")) != -1) {
    switch (option) {
    // select the number of set bits (i.e., use S = 2s sets)
    case 's':
      cache.setBits = atoi(optarg);
      break;
    // select the number of lines per set (associativity)
    case 'E':
      cache.linesPerSet = atoi(optarg);
      break;
    // select the number of block bits (i.e., use B = 2b bytes / block)
    case 'b':
      cache.blockBits = atoi(optarg);
      break;
    case 't':
      traceFile = optarg;
      break;
    case 'v':
      cache.displayTrace = 1;
      break;
    }
  }
  // initializes the cache
  cacheSetUp(&cache);
  // check the flag and call appropriate function
  operateFlags(traceFile, &cache);
  // prints the summary
  printSummary(cache.hit_count, cache.miss_count, cache.eviction_count);
  // deallocates the memory
  deallocate(&cache);
  return 0;
}