# Python Template

A full-stack Python scaffold with FastAPI backend and React frontend.

## Features

- **Backend**: FastAPI + Uvicorn
- **Frontend**: Vite + React
- **Python Version**: >= 3.9
- **Development Tools**: pytest, black, flake8
- **Docker**: Multi-stage builds with development and production configurations
- **Scripts**: Easy-to-use shell scripts for common tasks

## Project Structure

```
python-template/
├── backend/               # FastAPI backend
│   ├── app/
│   │   ├── main.py       # Application entry point
│   │   ├── config.py     # Configuration management
│   │   └── api/          # API routes
│   ├── tests/            # Backend tests
│   ├── Dockerfile
│   └── requirements.txt
├── frontend/             # React frontend
│   ├── src/
│   │   ├── App.jsx
│   │   ├── main.jsx
│   │   └── index.css
│   ├── Dockerfile
│   ├── package.json
│   └── vite.config.js
├── scripts/              # Utility scripts
│   ├── dev.sh           # Start development environment
│   ├── prod.sh          # Start production environment
│   └── test.sh          # Run tests
├── docker-compose.yml           # Production configuration
├── docker-compose.dev.yml       # Development configuration
├── pyproject.toml              # Python tools configuration
├── .flake8                     # Flake8 configuration
└── .env                        # Environment variables
```

## Quick Start

### Prerequisites

- Python >= 3.9
- Node.js >= 18
- Docker and Docker Compose (optional, for containerized deployment)

### Option 1: Docker (Recommended)

#### Development Mode
```bash
./scripts/dev.sh
```

This will start:
- Backend: http://localhost:8000
- Frontend: http://localhost:5173
- API Docs: http://localhost:8000/docs

#### Production Mode
```bash
./scripts/prod.sh
```

This will start:
- Frontend: http://localhost
- Backend: http://localhost:8000
- API Docs: http://localhost:8000/docs

### Option 2: Local Development

#### Backend Setup
```bash
# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -e ".[dev]"

# Run backend
cd backend
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

#### Frontend Setup
```bash
# Install dependencies
cd frontend
npm install

# Run frontend
npm run dev
```

## Development

### Running Tests
```bash
./scripts/test.sh
```

Or manually:
```bash
# Activate virtual environment
source .venv/bin/activate

# Run tests with coverage
cd backend
pytest

# Format code with black
black backend/app backend/tests

# Check code style with flake8
flake8 backend/app backend/tests
```

### Code Quality Tools

- **Black**: Code formatter (line length: 88)
- **Flake8**: Linting and style checking
- **Pytest**: Testing framework with coverage

### Environment Variables

Copy `.env.example` to `.env` and modify as needed:

```bash
cp .env.example .env
```

Available variables:
- `APP_NAME`: Application name
- `DEBUG`: Enable debug mode (true/false)
- `HOST`: Server host (default: 0.0.0.0)
- `PORT`: Server port (default: 8000)
- `CORS_ORIGINS`: Allowed CORS origins (comma-separated)

## API Documentation

Once the backend is running, visit:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Docker Commands

```bash
# Build images
docker-compose build

# Start services (detached)
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Development mode with hot-reload
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
```

## Project Scripts

- `scripts/dev.sh`: Start development environment with Docker
- `scripts/prod.sh`: Start production environment with Docker
- `scripts/test.sh`: Run all tests and linting checks

## License

MIT
