import pandas as pd

def main():
    # read csv files 
    totals = pd.read_csv('totals.csv').set_index(keys=['name'])
    counts = pd.read_csv('counts.csv').set_index(keys=['name'])


    # which city had the lowest precipitation
    total_precp_city = totals.sum(axis=1)
    lowest = total_precp_city.idxmin()

    # print row name
    print('City with lowest total precipitation:')
    print(lowest)


    # determine average precp in these location for each month 
    total_precp_month = totals.sum(axis=0)
    total_obs_month = counts.sum(axis=0)
    avg_precp_month = total_precp_month / total_obs_month

    # print result 
    print('Average precipitation in each month:')
    print(avg_precp_month)


    # determine average precp (daily precp averaged over the month) for each city
    total_obs_city = counts.sum(axis=1)
    avg_precp_city = total_precp_city / total_obs_city

    # print result 
    print('Average precipitation in each city:')
    print(avg_precp_city)


    
if __name__ == '__main__':
    main()
