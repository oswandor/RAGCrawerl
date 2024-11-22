# Use the official Python image from the Docker Hub
FROM python:3.11.0-slim

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Instalar las dependencias del sistema necesarias para compilar psycopg2
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*


# Install the dependencies
RUN pip install --upgrade pip

RUN pip install -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose the port Streamlit will run on
EXPOSE 8501

# Run the Streamlit app
CMD ["streamlit", "run", "main.py", "--server.port=8501", "--server.address=0.0.0.0"]