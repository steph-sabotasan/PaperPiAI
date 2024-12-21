# Use an official Python 3.11 image as a base image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Install system dependencies including build tools
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
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install --no-cache-dir opencv_contrib_python inky[rpi]==1.5.0 pillow

# Clone necessary repositories
RUN git clone https://github.com/google/XNNPACK.git && \
    cd XNNPACK && \
    git checkout 1c8ee1b68f3a3e0847ec3c53c186c5909fa3fbd3 && \
    mkdir build && cd build && \
    cmake -DXNNPACK_BUILD_TESTS=OFF -DXNNPACK_BUILD_BENCHMARKS=OFF .. && \
    cmake --build . --config Release && \
    cd /app

RUN git clone https://github.com/vitoplantamura/OnnxStream.git && \
    cd OnnxStream && \
    cd src && \
    mkdir build && cd build && \
    cmake -DMAX_S
