#!/bin/bash

# Development startup script
set -e

echo "Starting development environment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Warning: .env file not found. Creating from .env.example..."
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "Created .env file. Please update it with your configuration."
    else
        echo "Error: .env.example not found."
        exit 1
    fi
fi

# Start services with docker-compose
echo "Starting services with Docker Compose..."
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build

echo "Development environment stopped."
