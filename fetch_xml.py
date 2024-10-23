import requests
import time
from datetime import datetime

# API base URL
base_url = 'https://apis.deutschebahn.com/db-api-marketplace/apis/timetables/v1/fchg/'

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

# Function to make the API request and save the XML response
def fetch_and_save_data(station_code, station_name):
    # Construct the full API URL
    url = base_url + station_code
    print(f"Fetching data for {station_name} (station code: {station_code})")

    # Make the request
    response = requests.get(url, headers=headers)

    # Check if the request was successful
    if response.status_code == 200:
        # Generate a timestamp for the filename
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        # Save the raw XML content to a file, with the station name and timestamp in the filename
        filename = f'api_response_{station_name}_{timestamp}.xml'
        with open(filename, 'wb') as file:
            file.write(response.content)
        print(f"XML response saved to '{filename}'")
    else:
        print(f"API request for {station_name} failed with status code {response.status_code}")

# Main loop to fetch data for each station
if __name__ == '__main__':
    while True:
        for station_code, station_name in stations.items():
            fetch_and_save_data(station_code, station_name)
            # Wait for 60 seconds between each request to respect rate limits
            time.sleep(60)
