#!/bin/bash

# Production startup script
set -e

echo "Starting production environment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found. Please create one from .env.example"
    exit 1
fi

# Build and start services
echo "Building and starting production services..."
docker-compose up --build -d

echo "Production environment started successfully!"
echo "Frontend: http://localhost"
echo "Backend API: http://localhost:8000"
echo "API Docs: http://localhost:8000/docs"

# Show logs
echo ""
echo "Showing logs (Ctrl+C to exit)..."
docker-compose logs -f
