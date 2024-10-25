import requests
import time
import logging
from datetime import datetime

from partd.file import filename
from sympy.physics.units import current

# API base URL
base_url = 'https://apis.deutschebahn.com/db-api-marketplace/apis/timetables/v1/fchg/'

plan_url = 'https://apis.deutschebahn.com/db-api-marketplace/apis/timetables/v1/plan/'

api_urls = {
    'plan': plan_url,
    'fchg': base_url
}

# Station codes and their corresponding names
stations = {
    '8000244': 'Mannheim_Hbf',
    '8000250': 'Wiesbaden_Hbf',
    '8000134': 'Trier_Hbf',
    '8000240': 'Mainz_Hbf',
    '8000105': 'Frankfurt_Main_Hbf',
}

# API headers
headers = {
    'accept': 'application/xml',
    'DB-Api-Key': '***REMOVED***',
    'DB-Client-Id': '***REMOVED***'
}

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Function to make the API request and save the XML response
def fetch_and_save_data(station_code, station_name, api_type, api_url):

    if(api_type == 'plan'):
        # Construct the full API URL
        url = api_url + station_code
    if(api_type == 'fchg'):
        #date in yymmdd
        current_date = datetime.now().strftime("%y%m%d")
        current_hour = datetime.now().strftime("%H")
        # Construct the full API URL
        url = api_url + station_code + '/' + current_date + '/'+ current_hour

    logging.info(f"Fetching data for {station_name} (station code: {station_code})")

    # Make the request
    response = requests.get(url, headers=headers)

    # Check if the request was successful
    if response.status_code == 200:
        # Generate a timestamp for the filename
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        # Save the raw XML content to a file, with the station name and timestamp in the filename
        if(api_type == 'plan'):
            filename=f'out/api_response_{station_name}_{timestamp}_plan'+ current_hour +'.xml'
        if(api_type == 'fchg'):
            filename=f'out/api_response_{station_name}_{timestamp}_fchg.xml'
        with open(filename, 'wb') as file:
            file.write(response.content)
        logging.info(f"XML response saved to '{filename}'")
    else:
        logging.error(f"API request for {station_name} failed with status code {response.status_code}")

# Main loop to fetch data for each station
if __name__ == '__main__':
    while True:
        for station_code, station_name in stations.items():
            for api_type, api_url in api_urls.items():
                fetch_and_save_data(station_code, station_name)
                # Wait for 60 seconds between each request to respect rate limits
                time.sleep(120)