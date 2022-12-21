import time
import numpy as np
import pandas as pd
from implementations import all_implementations

def main():
    # create arr of random ints
    random_array = np.random.randint(255, size=10000)
    # create empty arr for results
    time_results = []

    # loop through arr of sorting functions
    # save the run-times
    for i in range(100):         # take multiple run-times of each sort-func
        temp_res = []
        for sort in all_implementations:
            # start time
            st = time.time()
            # sort arr
            res = sort(random_array)
            # end time
            en = time.time()
            # append time for each sort-funcs
            temp_res.append(en-st)
        # append times of each loop to result
        time_results.append(temp_res)

    # convert arr to df
    data = pd.DataFrame(time_results, columns=['qs1', 'qs2', 'qs3', 'qs4', 'qs5', 'merge1', 'partition_sort'])
    # save to file 
    data.to_csv('data.csv', index=False)
    
    
if __name__ == '__main__':
    main()