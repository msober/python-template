# Backend Dockerfile
FROM python:3.11-slim as base

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY backend/requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY backend/app ./app

# Expose port
EXPOSE 8000

# Development stage
FROM base as development
RUN pip install --no-cache-dir \
    pytest>=7.4.0 \
    pytest-cov>=4.1.0 \
    pytest-asyncio>=0.21.0 \
    black>=23.0.0 \
    flake8>=6.0.0 \
    httpx>=0.25.0
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

# Production stage
FROM base as production
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
