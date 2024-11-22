import os
import pandas as pd
from sqlalchemy import create_engine

# Set the directory containing your SQL files
sql_directory = 'sql/queries'  # Replace with the actual directory path containing your .sql files

# Set the directory where you want to save the output CSV files
output_directory = 'sql/csv'  # Replace with the desired directory path for the CSV output

# Ensure the output directory exists
if not os.path.exists(output_directory):
    os.makedirs(output_directory)

# Set up the database connection using SQLAlchemy
# Format: 'mysql+pymysql://username:password@host:port/database'
engine = create_engine('mysql+pymysql://root:root@localhost/bahn')

# Loop through all .sql files in the directory
for sql_file in os.listdir(sql_directory):
    if sql_file.endswith(".sql"):  # Check if the file is a .sql file
        print(f"Executing query from {sql_file}")
        file_path = os.path.join(sql_directory, sql_file)

        # Read SQL query from the file
        with open(file_path, 'r') as file:
            sql_query = file.read()

        try:
            # Execute the SQL query and get the result into a pandas DataFrame using SQLAlchemy engine
            df = pd.read_sql_query(sql_query, engine)

            # Define output CSV file path in the output directory
            output_csv = os.path.join(output_directory, f'{os.path.splitext(sql_file)[0]}.csv')

            # Save DataFrame to CSV
            df.to_csv(output_csv, index=False, sep=';', decimal=',')  # German format with semicolon separator
            print(f"Query from {sql_file} executed successfully and saved to {output_csv}")

        except Exception as e:
            print(f"Error executing {sql_file}: {e}")

# Close the engine connection (not required for pandas, but good practice)
engine.dispose()
