# Use the official Python 3.11 slim image as the base image
FROM python:3.11-slim

# Set environment variables
ENV INSTALL_DIR=/app

# Install basic dependencies required for the install script
RUN apt-get update && \
    apt-get install -y \
    sudo \
    bash && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR ${INSTALL_DIR}

# Copy the install.sh script into the container
COPY scripts/install.sh ${INSTALL_DIR}/install.sh

# Ensure the script is executable
RUN chmod +x ${INSTALL_DIR}/install.sh

# Run the install.sh script
RUN ${INSTALL_DIR}/install.sh

# Copy the display_picture and generate_picture scripts
COPY src/display_picture.py ${INSTALL_DIR}/display_picture.py
COPY src/generate_picture.py ${INSTALL_DIR}/generate_picture.py

CMD ["python", "/app/generate_picture.py", "tmp"]

