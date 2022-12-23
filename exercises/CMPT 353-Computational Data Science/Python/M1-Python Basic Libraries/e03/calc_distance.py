import sys
import math
import numpy as np
import pandas as pd 
import matplotlib.pyplot as plt
from pykalman import KalmanFilter
from xml.dom.minidom import parse, parseString

# create function to extract cols 
def element_to_data(ele):
    lat = float(ele.getAttribute("lat"))
    lon = float(ele.getAttribute("lon"))
    dtime = ele.getElementsByTagName('time')
    dtime = pd.to_datetime(dtime[0].firstChild.nodeValue, utc=True)
    
    return lat, lon, dtime

def deg2rad(deg) :
  return deg * (math.pi/180)

# write a function to calculate distance 
def distance(points):
    R = 6371
    points['lat1'] = points['lat'].shift(-1)
    points['lon1'] = points['lon'].shift(-1)
    points = points.dropna().copy()

    points['dLat'] = deg2rad((points['lat1']-points['lat']))
    points['dLon'] = deg2rad((points['lon1']-points['lon']))

    points['a'] = np.sin(points['dLat']/2) * np.sin(points['dLat']/2) + np.cos(deg2rad(points['lat'])) * np.cos(deg2rad(points['lat1'])) * np.sin(points['dLon']/2) * np.sin(points['dLon']/2)

    points['c'] = 2 * np.arctan2(np.sqrt(points['a']), np.sqrt(1-points['a']))

    points['d'] = R * points['c'] * 1000

    return(points['d'].sum())



def main():

    # get filenames 
    filename1 = sys.argv[1]
    filename2 = sys.argv[2]
    
    # read file
    gps_doc = parse(filename1)
    # get 'trkpt' element from file 
    gps_elements = gps_doc.getElementsByTagName('trkpt')
    # get data from elment and create df with cols 
    gps_data = pd.DataFrame(list(map(element_to_data, gps_elements)),
                             columns=['lat', 'lon', 'datetime'])
    # set datetime as index
    gps_data = gps_data.set_index('datetime')
    
    # read data from csv file and add to gps df 
    csv_data = pd.read_csv(filename2, parse_dates=['datetime']).set_index('datetime')
    gps_data['Bx'] = csv_data['Bx']
    gps_data['By'] = csv_data['By']
    
    # calculate unfiltered distance
    points = gps_data[['lat', 'lon']]

    dist = distance(points).round(6)
    
    # prepare data for kalman
    kalman_data = gps_data[['lat', 'lon', 'Bx', 'By']]
    initial_state = kalman_data.iloc[0]
    # observation_covariance expresses how much you believe the sensors
    # if the sensor is very accurate, small values should be used
    observation_covariance = np.diag([0.2, 0.2, 1, 1]) ** 2 # TODO: shouldn't be zero
    # transition_covariance expresses how accurate your prediction is
    transition_covariance = np.diag([0.5, 0.5, 1, 1]) ** 2 # TODO: shouldn't be zero
    transition = [[1, 0, 0.0000006, 0.00000029], [0, 1, -0.00000043, 0.00000012], [0, 0, 1, 0], [0, 0, 0, 1]] # TODO: shouldn't (all) be zero

    # apply kalman smoothing 
    kf = KalmanFilter(
        initial_state_mean=initial_state,
        initial_state_covariance=observation_covariance,
        observation_covariance=observation_covariance,
        transition_covariance=transition_covariance,
        transition_matrices=transition
    )
    kalman_smoothed, covar = kf.smooth(kalman_data)
    
    # calculate unfiltered distance
    points1 = pd.DataFrame(kalman_smoothed[:, 0:2], columns=['lat', 'lon'])

    dist1 = distance(points1).round(6)

    f = open('calc_distance.txt', 'w')
    f.write(f'Unfiltered distance: {dist:.2f}\n')
    f.write(f'Filtered distance: {dist1:.2f}\n')

    
    
if __name__ == '__main__':
    main()
