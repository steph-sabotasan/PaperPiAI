# Use the official Python 3.11 slim image as the base image
FROM python:3.11-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    python3-dev \
    python3-pip \
    python3-venv \
    libopencv-dev \
    imagemagick \
    git \
    git-lfs \
    tmux \
    vim \
    cmake && \
    rm -rf /var/lib/apt/lists/*

# Clone XNNPACK repository and initialize submodules
RUN git clone --recurse-submodules https://github.com/google/XNNPACK.git /app/XNNPACK

# Clone OnnxStream repository
RUN git clone https://github.com/vitoplantamura/OnnxStream.git && \
    cd OnnxStream && \
    cd src && \
    mkdir build && cd build && \
    cmake -DMAX_SPEED=ON -DOS_LLM=OFF -DOS_CUDA=OFF -DXNNPACK_DIR="/app/XNNPACK" .. && \
    cmake --build . --config Release && \
    cd /app

# Set environment variables for model paths
ENV SD_BIN="/app/OnnxStream/src/build/sd"
ENV SD_MODEL="/app/stable_diffusion_models/stable-diffusion-xl-turbo-1.0-onnxstream"

# Create output directories
RUN mkdir -p /app/output_images /app/display_images

# Add the generate_picture.py and display_image.py scripts
COPY src/generate_picture.py /app/generate_picture.py
COPY src/display_picture.py /app/display_picture.py

# Set the default command to run when the container starts (e.g., generating an image)
CMD ["python3", "/app/generate_picture.py", "/app/output_images"]
