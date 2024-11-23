#sql view to csv
# This script will generate a csv file from a sql view

import csv
import logging
import os
import sys
import pymysql

# Connect to the mariadb database
connection = pymysql.connect(
    host=os.environ.get('DB_HOST', 'localhost'),
    user='root',
    password='root',
    database='bahn'
)

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Get the view name from the command line arguments
view = sys.argv[1]

logging.info(f"Generating csv for {view}")

# Get the column names from the view
with connection.cursor() as cursor:
    cursor.execute(f"SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{view}'")
    columns = cursor.fetchall()

    columnNames = []
    for column in columns:
        columnNames.append(column[0])

    # Get the data from the view
    cursor.execute(f"SELECT * FROM {view}")
    data = cursor.fetchall()

with open(f'/db-results/{view}.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile, delimiter=';')
    writer.writerow(columnNames)
    writer.writerows(data)

    logging.info(f"Generated {view}.csv")

connection.close()