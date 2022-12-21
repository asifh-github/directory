import os
import pathlib
import sys
import numpy as np
import pandas as pd
from xml.dom.minidom import parse, parseString


def output_gpx(points, output_filename):
    """
    Output a GPX file with latitude and longitude from the points DataFrame.
    """
    from xml.dom.minidom import getDOMImplementation, parse
    xmlns = 'http://www.topografix.com/GPX/1/0'
    
    def append_trkpt(pt, trkseg, doc):
        trkpt = doc.createElement('trkpt')
        trkpt.setAttribute('lat', '%.10f' % (pt['lat']))
        trkpt.setAttribute('lon', '%.10f' % (pt['lon']))
        time = doc.createElement('time')
        time.appendChild(doc.createTextNode(pt['datetime'].strftime("%Y-%m-%dT%H:%M:%SZ")))
        trkpt.appendChild(time)
        trkseg.appendChild(trkpt)

    doc = getDOMImplementation().createDocument(None, 'gpx', None)
    trk = doc.createElement('trk')
    doc.documentElement.appendChild(trk)
    trkseg = doc.createElement('trkseg')
    trk.appendChild(trkseg)

    points.apply(append_trkpt, axis=1, trkseg=trkseg, doc=doc)

    doc.documentElement.setAttribute('xmlns', xmlns)

    with open(output_filename, 'w') as fh:
        fh.write(doc.toprettyxml(indent='  '))


def get_data(input_gpx):
    # TODO: you may use your code from exercise 3 here.
    # create function to extract cols 
    def element_to_data(ele):
        lat = float(ele.getAttribute("lat"))
        lon = float(ele.getAttribute("lon"))
        dtime = ele.getElementsByTagName('time')
        dtime = pd.to_datetime(dtime[0].firstChild.nodeValue, utc=True)

        return lat, lon, dtime

    # read file
    gps_doc = parse(input_gpx)
    # get 'trkpt' element from file 
    gps_elements = gps_doc.getElementsByTagName('trkpt')
    # get data from elment and create df with cols 
    gps_data = pd.DataFrame(list(map(element_to_data, gps_elements)),
                             columns=['lat', 'lon', 'timestamp'])
    return gps_data


def main():
    input_directory = pathlib.Path(sys.argv[1])
    output_directory = pathlib.Path(sys.argv[2])
    
    accl = pd.read_json(input_directory / 'accl.ndjson.gz', lines=True, convert_dates=['timestamp'])[['timestamp', 'x']]
    
    gps = get_data(sys.argv[1] + '/gopro.gpx')
    
    phone = pd.read_csv(input_directory / 'phone.csv.gz')[['time', 'gFx', 'Bx', 'By']]
    first_time = accl['timestamp'].min()
    
    # TODO: create "combined" as described in the exercise
    # unify the times, aggregate using 4 second bins 
    accl['datetime'] = accl['timestamp'].round("4S")
    gps['datetime'] = gps['timestamp'].round("4S")
    
    # group on the rounded-times, and average all of the other values 
    accl = accl.groupby(['datetime']).mean()
    gps = gps.groupby(['datetime']).mean()
    
    # find the offset with the highest cross-correlation 
    m = 0
    max_index = 0
    for offset in np.linspace(-5.0, 5.0, 101):
        p_data = phone
        p_data['dt'] = first_time + pd.to_timedelta(p_data['time'] + offset, unit='sec')
        p_data['dt'] = p_data['dt'].round("4S")
        p_data = p_data.groupby(['dt']).aggregate('mean')
        data = p_data.join(accl).dropna()
        cor_rel = data['gFx'].dot(data['x'])
        if cor_rel >= m:
            m = cor_rel
            max_index = offset

    time_diff =  max_index.round(2) 
    
    # remake phone['time'] as phone['time'] + offset
    phone = pd.read_csv('walk1/phone.csv.gz')[['time', 'gFx', 'Bx', 'By']]
    phone['time'] = phone['time'] + time_diff
    phone['timestamp'] = first_time + pd.to_timedelta(phone['time'], unit='sec')
    phone['datetime'] = phone['timestamp'].round("4S")
    phone = phone.groupby(['datetime']).mean()

    # combine three dfs
    combined = phone.join(accl)
    combined = combined.join(gps)
    combined = combined.reset_index()

    print(f'Best time offset: {time_diff:.1f}')
    os.makedirs(output_directory, exist_ok=True)
    output_gpx(combined[['datetime', 'lat', 'lon']], output_directory / 'walk.gpx')
    combined[['datetime', 'Bx', 'By']].to_csv(output_directory / 'walk.csv', index=False)
    
    


main()
