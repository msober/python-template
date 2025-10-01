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
│   ├── init.sh          # Initialize project (rename from template)
│   ├── dev.sh           # Smart development launcher
│   ├── dev-docker.sh    # Development with Docker
│   ├── dev-local.sh     # Development locally
│   ├── prod.sh          # Smart production launcher
│   ├── prod-docker.sh   # Production with Docker
│   ├── prod-local.sh    # Production locally
│   └── test.sh          # Run tests and linting
├── docker-compose.yml           # Production configuration
├── docker-compose.dev.yml       # Development configuration
├── pyproject.toml              # Python tools configuration
├── .flake8                     # Flake8 configuration
└── .env                        # Environment variables
```

## Quick Start

### Step 1: Initialize Project (First Time Only)

Rename the project from template:

```bash
./scripts/init.sh your-project-name
```

This replaces "python-template" with your project name in all configuration files.

### Step 2: Start Development

**Easiest way (Recommended):**

```bash
./scripts/dev.sh
```

The smart launcher will:
- ✅ Auto-detect Docker availability
- ✅ Let you choose between Docker or Local mode
- ✅ Auto-start the development environment

**Alternative: Direct launch**

```bash
# With Docker
./scripts/dev-docker.sh

# Without Docker (local)
./scripts/dev-local.sh
```

### Step 3: Access Your Application

Once started, open your browser:

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs

### Prerequisites

- Python >= 3.9
- Node.js >= 18
- Docker and Docker Compose (optional, only needed for Docker mode)

---

## Usage Scenarios

### Daily Development Workflow

```bash
# Start development environment
./scripts/dev.sh

# In another terminal: run tests
./scripts/test.sh

# Make changes to code (auto-reload is enabled)
# Backend: backend/app/
# Frontend: frontend/src/

# Stop: Press Ctrl+C
```

### Production Deployment

```bash
# Local production mode
./scripts/prod.sh

# Or with Docker
./scripts/prod-docker.sh
```

**Production URLs:**
- Frontend: http://localhost:3000 (local) or http://localhost (docker)
- Backend: http://localhost:8000
- API Docs: http://localhost:8000/docs

## Development Guide

### Running Tests

```bash
./scripts/test.sh
```

This will:
- Check code formatting with Black
- Run linting with Flake8
- Execute pytest with coverage report

**Manual testing:**

```bash
# Activate virtual environment
source .venv/bin/activate

# Run tests with coverage
cd backend
pytest

# Format code
black backend/app backend/tests

# Check code style
flake8 backend/app backend/tests
```

### Code Quality Tools

- **Black**: Code formatter (line length: 88)
- **Flake8**: Linting and style checking
- **Pytest**: Testing framework with coverage

Configuration files:
- `pyproject.toml` - Black and pytest configuration
- `.flake8` - Flake8 configuration

### Adding New Features

**Backend (FastAPI):**

1. Add routes in `backend/app/api/routes.py`
2. Add tests in `backend/tests/`
3. Run tests: `./scripts/test.sh`

**Frontend (React):**

1. Add components in `frontend/src/`
2. Update `frontend/src/App.jsx` if needed
3. Vite will auto-reload changes

### Environment Configuration

Copy `.env.example` to `.env` and modify as needed:

```bash
cp .env.example .env
```

**Available variables:**

| Variable | Description | Default |
|----------|-------------|---------|
| `APP_NAME` | Application name | Python Template API |
| `DEBUG` | Enable debug mode | true |
| `HOST` | Server host | 0.0.0.0 |
| `PORT` | Server port | 8000 |
| `CORS_ORIGINS` | Allowed CORS origins | http://localhost:5173,http://localhost:3000 |

## API Documentation

Once the backend is running, visit:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Docker Reference

### Basic Commands

```bash
# Build and start (development mode with hot-reload)
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# Build and start (production mode, detached)
docker-compose up -d --build

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# View logs for specific service
docker-compose logs -f backend
docker-compose logs -f frontend

# Rebuild images
docker-compose build --no-cache

# Remove volumes
docker-compose down -v
```

### Docker Architecture

**Multi-stage builds:**
- Development stage: Includes dev dependencies, hot-reload enabled
- Production stage: Optimized, minimal image size

**Services:**
- `backend`: FastAPI application (port 8000)
- `frontend`: Vite dev server (dev) or Nginx (prod)

**Health checks:**
- Backend: `/api/health` endpoint
- Frontend: HTTP availability check

---

## Available Scripts

### Launcher Scripts (Recommended)

| Script | Description |
|--------|-------------|
| `./scripts/init.sh <name>` | Initialize project with custom name |
| `./scripts/dev.sh` | Smart development launcher (auto-detects Docker) |
| `./scripts/prod.sh` | Smart production launcher (auto-detects Docker) |
| `./scripts/test.sh` | Run tests and linting |

### Direct Launch Scripts

| Script | Mode | Description |
|--------|------|-------------|
| `./scripts/dev-docker.sh` | Docker | Development with Docker |
| `./scripts/dev-local.sh` | Local | Development without Docker |
| `./scripts/prod-docker.sh` | Docker | Production with Docker |
| `./scripts/prod-local.sh` | Local | Production without Docker |

### Script Features

**Local Mode:**
- ✅ Auto-creates Python virtual environment
- ✅ Auto-installs all dependencies (Python + Node.js)
- ✅ Hot-reload for frontend and backend
- ✅ Process management with graceful shutdown
- ✅ Colored output and progress indicators
- ✅ Health checks before startup complete
- ✅ Background backend, foreground frontend

**Docker Mode:**
- ✅ Isolated containerized environment
- ✅ Multi-stage builds (dev/prod)
- ✅ Health checks with automatic restart
- ✅ Volume mounting for development hot-reload
- ✅ Optimized production images
- ✅ Docker Compose orchestration

---

## Troubleshooting

### Port Already in Use

```bash
# Find process using port 8000
lsof -i :8000

# Kill process
kill -9 <PID>
```

### Clean Everything and Restart

```bash
# Stop all processes
pkill -f uvicorn
pkill -f vite

# Remove virtual environment
rm -rf .venv

# Remove node modules
rm -rf frontend/node_modules

# Remove Docker containers and volumes
docker-compose down -v

# Start fresh
./scripts/dev.sh
```

### Backend Won't Start

Check logs:
```bash
# Local mode
cat backend.log

# Docker mode
docker-compose logs backend
```

Common issues:
- Python version < 3.9
- Missing dependencies (run script again)
- Port 8000 already in use

### Frontend Build Fails

```bash
# Clean and reinstall
cd frontend
rm -rf node_modules package-lock.json
npm install
npm run build
```

---

## License

MIT
