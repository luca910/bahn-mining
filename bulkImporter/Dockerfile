FROM python:3.9-slim

WORKDIR /app

# Copy application files
COPY . /app


# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Ensure bash is installed for parallel execution
RUN apt-get update && apt-get install -y bash && rm -rf /var/lib/apt/lists/*

# Set up the script to run with parameters
COPY run_importer.sh /app/run_importer.sh
RUN chmod +x /app/run_importer.sh

CMD ["/app/run_importer.sh"]
