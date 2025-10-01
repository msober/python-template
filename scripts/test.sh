#!/bin/bash

# Test script
set -e

echo "Running tests..."

# Check if virtual environment exists
if [ ! -d ".venv" ]; then
    echo "Virtual environment not found. Creating one..."
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -e ".[dev]"
else
    source .venv/bin/activate
fi

# Run linting
echo ""
echo "Running Black formatter check..."
black --check backend/app backend/tests || {
    echo "Black formatting issues found. Run 'black backend/app backend/tests' to fix."
}

echo ""
echo "Running Flake8..."
flake8 backend/app backend/tests

# Run tests
echo ""
echo "Running pytest..."
cd backend
pytest

echo ""
echo "All tests passed!"
