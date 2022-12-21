import sys
import numpy as np
import pandas as pd 
import matplotlib.pyplot as plt
from pykalman import KalmanFilter
from statsmodels.nonparametric.smoothers_lowess import lowess

def main():

    # get filenames 
    filename = sys.argv[1]
    
    # read csv file 
    cpu_data = pd.read_csv(filename, parse_dates=['timestamp'])
    
    # convert timestamp values to quantitive value 
    def to_timestamp(t):
        return t.timestamp()

    # make a copy of data 
    # add timestamp col to cpu_data for lowess 
    cpu_data['time_val'] = cpu_data['timestamp'].apply(to_timestamp)
    
    # apply lowess smoothing to data/graph 
    lowess_cpu_data = lowess(cpu_data['temperature'], cpu_data['time_val'], frac=0.035)
    
    # prepare data for kalman
    kalman_data = cpu_data[['temperature', 'cpu_percent', 'sys_load_1', 'fan_rpm']]
    initial_state = kalman_data.iloc[0]
    # bservation_covariance expresses how much you believe the sensors
    #f the sensor is very accurate, small values should be used
    observation_covariance = np.diag([2, 1, 2, 2]) ** 2 # TODO: shouldn't be zero
    # transition_covariance expresses how accurate your prediction is

    transition_covariance = np.diag([0.05, 0.1, 0.2, 0.2]) ** 2 # TODO: shouldn't be zero
    transition = [[0.96, 0.5, 0.2 ,0.001], [0.1, 0.4, 2.3, 0], [0, 0, 0.96, 0], [0, 0, 0, 1]] # TODO: shouldn't (all) be zero

    # apply kalman smoothing 
    kf = KalmanFilter(
        initial_state_mean=initial_state,
        initial_state_covariance=observation_covariance,
        observation_covariance=observation_covariance,
        transition_covariance=transition_covariance,
        transition_matrices=transition
    )
    kalman_smoothed, covar = kf.smooth(kalman_data)
    
    # plot cpu_temp using both loess and kalman smoothing
    plt.plot(cpu_data['timestamp'], cpu_data['temperature'], 'b.', alpha=0.5)
    plt.plot(cpu_data['timestamp'], kalman_smoothed[:, 0], 'g-', label="Kalman Smoothing")
    plt.plot(cpu_data['timestamp'], lowess_cpu_data[:, 1], 'r-', label="Loess Smoothing")
    # add title, label the axes, & legend
    plt.title("CPU Temperature vs. Time ")
    plt.xlabel("Time")
    plt.ylabel("Temp.")
    plt.legend()
    plt.xticks(rotation=25)
    
    # save plots as png 
    plt.savefig('cpu.svg') 
    
    
    
if __name__ == '__main__':
    main()
