#!/bin/bash

# Directory where files or parameters are mounted
MOUNTED_DIR="/data"

# Check if the directory exists
if [ ! -d "$MOUNTED_DIR" ]; then
  echo "Error: Mounted directory $MOUNTED_DIR not found."
  exit 1
fi

# Run the Python script in parallel for each file/parameter
for param in "$MOUNTED_DIR"/*; do
  echo "Processing $param..."
  python importer.py "$param" &
done

#repeat very 5 seconds
while true; do
  echo "Running importer"
  python importer.py "$MOUNTED_DIR" &
  python generateCSVs.py ar_superquery &
  python generateCSVs.py dp_superquery &
  echo "Sleeping for 200 seconds..."
  sleep 200
done &


# Wait for all background processes to complete
wait

echo "All tasks completed."