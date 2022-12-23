import numpy as np

def main():
    # load data from monthdata.npz
    data = np.load('monthdata.npz')
    
    totals = data['totals']
    counts = data['counts']
    
    
    # which city had the lowest precipitation
    total_precp_city = np.sum(totals, axis=1)
    lowest = np.argmin(total_precp_city)
    # print row no.
    print('Row with lowest total precipitation:')
    print(lowest)
    
    
    # determine average precp in these location for each month 
    # total precp of each month / total no. of obs for that month
    total_precp_month = np.sum(totals, axis=0)
    total_obs_month = np.sum(counts, axis=0)
    avg_precp_month = total_precp_month / total_obs_month
    
    # print result
    print('Average precipitation in each month:')
    print(avg_precp_month)
  
    
    # determine average precp (daily precp averaged over the month) for each city
    total_obs_city = np.sum(counts, axis=1)
    avg_precp_city = total_precp_city / total_obs_city
    
    # print result
    print('Average precipitation in each city:')
    print(avg_precp_city)
    
    
    # calculate total precp for each quarter in each city
    # 4n, 3
    new_totals = np.reshape(totals, (totals.shape[0]*4, 3))
    quarterlyTotal_precp_city = np.sum(new_totals, axis=1)
    # n, 4
    quarterlyTotal_precp_city = np.reshape(quarterlyTotal_precp_city, (totals.shape[0], 4))

    # print result
    print('Quarterly precipitation totals:')
    print(quarterlyTotal_precp_city)
    
    
    
if __name__ == '__main__':
    main()
