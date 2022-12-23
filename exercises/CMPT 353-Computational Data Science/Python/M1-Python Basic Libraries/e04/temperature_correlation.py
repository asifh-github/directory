import os
import pathlib
import sys
import math
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from xml.dom.minidom import parse, parseString

# functions 'deg2rad' & 'distance' referenced from https://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula/21623206
def deg2rad(deg) :
  return deg * (math.pi/180)

#  write a function that calculates the distance between one city and every station
def distance(city, stations):
    R = 6371
    data = stations 
    data.loc[:, 'cname'] = city['name']
    data.loc[:, 'cpd'] = city['population']
    data.loc[:, 'clat'] = city['latitude']
    data.loc[:, 'clon'] = city['longitude']
    
    data['dLat'] = deg2rad((data['clat']-data['latitude']))
    data['dLon'] = deg2rad((data['clon']-data['longitude']))

    data['a'] = np.sin(data['dLat']/2) * np.sin(data['dLat']/2) + np.cos(deg2rad(data['latitude'])) * np.cos(deg2rad(data['clat'])) * np.sin(data['dLon']/2) * np.sin(data['dLon']/2)

    data['c'] = 2 * np.arctan2(np.sqrt(data['a']), np.sqrt(1-data['a']))

    data['d'] = R * data['c']
    
    return data

# write a function that returns the best value you can find for 'avg_tmax' (& population density) for that one city
def best_tmax(city, stations):
    data = distance(city, stations)
    index = np.argmin(data['d'])
    
    return data.loc[index][['avg_tmax', 'cpd']]

def main():
    input_file1 = sys.argv[1]
    input_file2 = sys.argv[2]
    output_file = sys.argv[3]
    
    # read files 
    stations = pd.read_json(input_file1, lines=True)
    # avg_tmax col in the weather data is °C×10, divide by 10
    stations['avg_tmax'] = stations['avg_tmax'] / 10

    city_data = pd.read_csv(input_file2)
    # many cities has missing values, drop na_vals
    city_data = city_data.dropna().reset_index()
    # city area is given in m², convert to km²
    #exclude cities with area greater than 10000 km².
    city_data['area'] = city_data['area'] / 1000000
    city_data = city_data[city_data['area'] < 10000]
    
    #!! apply function across all cities
    #city_data.apply(best_tmax, stations=stations)
    # !!couldn't make aplly function to work, so using for loop
    pop = []
    temp = []
    for i in range(len(city_data)):
        t, p = best_tmax(city_data.iloc[i], stations)
        pop.append(p)
        temp.append(t)
    
    # plot scatterplot of average maximum temperature against population density 
    # add title and label the axes
    fig, ax = plt.subplots()
    plt.plot(temp, pop, 'b.')
    plt.title("Correlation between Average Maximum Temperature & Population Density")
    plt.xlabel('Avg Max Temperature (\u00b0C)')
    plt.ylabel('Population Density (people/km\u00b2)')
    
    # save the image as svg file
    fig.savefig(output_file, format='svg')
main()
