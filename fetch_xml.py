import requests
import time

# Deutsche Bahn API credentials
api_url = 'https://apis.deutschebahn.com/db-api-marketplace/apis/timetables/v1/fchg/8000250'
headers = {
    'accept': 'application/xml',
    'DB-Api-Key': 'f824d3743fcd68a8be25fadfe6482c72',
    'DB-Client-Id': 'cd8329b6d08c51ad68f63e830783bfbb'
}

# Function to fetch XML data from the Deutsche Bahn API
def fetch_xml():
    try:
        response = requests.get(api_url, headers=headers)
        response.raise_for_status()  # Check if request was successful
        return response.text  # Return the XML content as text
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")
        return None

# Function to save the XML data to a file
def save_xml(xml_data, filename):
    with open(filename, 'w') as file:
        file.write(xml_data)

# Main function to scrape the API and save the XML data periodically
def main(initial_interval=60, max_retries=5):
    retries = 0
    interval = initial_interval

    while True:
        print(f"Fetching data from the Deutsche Bahn API...")
        xml_data = fetch_xml()

        if xml_data:
            # Save the XML file with a timestamped filename
            filename = f"/app/output/timetable_{int(time.time())}.xml"
            save_xml(xml_data, filename)
            print(f"XML data saved to {filename}")

            # Reset retry count and interval after a successful fetch
            retries = 0
            interval = initial_interval
        else:
            retries += 1
            print(f"Failed attempt {retries} out of {max_retries}")

            if retries >= max_retries:
                print(f"Max retries reached ({max_retries}). Stopping the script.")
                break

            # Exponential backoff: increase the wait time after each failure
            interval = min(initial_interval * 2 ** retries, 3600)  # Max backoff: 1 hour

        # Wait for the specified interval
        print(f"Waiting {interval} seconds before the next attempt...")
        time.sleep(interval)

if __name__ == "__main__":
    main(initial_interval=60, max_retries=5)
