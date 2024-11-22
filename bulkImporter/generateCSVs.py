#sql view to csv
# This script will generate a csv file from a sql view

import csv
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

# Get the view name from the command line arguments
view = sys.argv[1]

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

    # Write the data to a csv file
    with open(f'{view}.csv', 'w') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(columnNames)
        writer.writerows(data)

    print(f"Generated {view}.csv")
