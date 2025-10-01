#!/bin/bash

# Local production startup script (without Docker)
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project paths
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKEND_DIR="$PROJECT_ROOT/backend"
FRONTEND_DIR="$PROJECT_ROOT/frontend"
VENV_DIR="$PROJECT_ROOT/.venv"
PID_FILE="$PROJECT_ROOT/.prod-pids"

echo -e "${BLUE}Starting local production environment...${NC}"
echo ""

# Cleanup function
cleanup() {
    echo ""
    echo -e "${YELLOW}Stopping services...${NC}"

    if [ -f "$PID_FILE" ]; then
        while IFS= read -r pid; do
            if ps -p "$pid" > /dev/null 2>&1; then
                echo "Stopping process $pid..."
                kill "$pid" 2>/dev/null || true
            fi
        done < "$PID_FILE"
        rm -f "$PID_FILE"
    fi

    echo -e "${GREEN}Services stopped.${NC}"
    exit 0
}

trap cleanup INT TERM

# Check Python version
echo -e "${BLUE}Checking Python version...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python 3 is not installed${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
REQUIRED_VERSION="3.9"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo -e "${RED}Error: Python >= 3.9 is required (found $PYTHON_VERSION)${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Python $PYTHON_VERSION${NC}"

# Check Node.js
echo -e "${BLUE}Checking Node.js...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}Error: Node.js is not installed${NC}"
    exit 1
fi

NODE_VERSION=$(node --version)
echo -e "${GREEN}✓ Node.js $NODE_VERSION${NC}"

# Check if .env file exists
if [ ! -f "$PROJECT_ROOT/.env" ]; then
    echo -e "${RED}Error: .env file not found. Please create one from .env.example${NC}"
    exit 1
fi

# Setup Python virtual environment
echo ""
echo -e "${BLUE}Setting up Python virtual environment...${NC}"
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

# Activate virtual environment
source "$VENV_DIR/bin/activate"
echo -e "${GREEN}✓ Virtual environment activated${NC}"

# Install Python dependencies
echo -e "${BLUE}Installing Python dependencies...${NC}"
pip install -q --upgrade pip
pip install -q -r "$PROJECT_ROOT/requirements.txt"
echo -e "${GREEN}✓ Python dependencies installed${NC}"

# Build frontend
echo ""
echo -e "${BLUE}Building frontend...${NC}"
cd "$FRONTEND_DIR"

# Install Node.js dependencies
if [ ! -d "node_modules" ]; then
    npm install
fi

# Build frontend
npm run build
echo -e "${GREEN}✓ Frontend built successfully${NC}"

# Start backend server with multiple workers
echo ""
echo -e "${BLUE}Starting FastAPI backend (production mode)...${NC}"
cd "$BACKEND_DIR"
source "$VENV_DIR/bin/activate"

# Create log directory
mkdir -p "$PROJECT_ROOT/logs"

# Start backend with 4 workers
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4 > "$PROJECT_ROOT/logs/backend.log" 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > "$PID_FILE"

# Wait for backend to start
echo "Waiting for backend to start..."
for i in {1..30}; do
    if curl -s http://localhost:8000/api/health > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Backend started (PID: $BACKEND_PID)${NC}"
        break
    fi
    if [ $i -eq 30 ]; then
        echo -e "${RED}Error: Backend failed to start${NC}"
        echo "Check logs/backend.log for details"
        cleanup
    fi
    sleep 1
done

# Start frontend static file server
echo ""
echo -e "${BLUE}Starting frontend server...${NC}"
cd "$FRONTEND_DIR/dist"

# Use Python's built-in HTTP server
python3 -m http.server 3000 > "$PROJECT_ROOT/logs/frontend.log" 2>&1 &
FRONTEND_PID=$!
echo $FRONTEND_PID >> "$PID_FILE"

# Wait for frontend to start
sleep 2
if ps -p $FRONTEND_PID > /dev/null; then
    echo -e "${GREEN}✓ Frontend started (PID: $FRONTEND_PID)${NC}"
else
    echo -e "${RED}Error: Frontend failed to start${NC}"
    cleanup
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Production environment is running!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${BLUE}Frontend:${NC}  http://localhost:3000"
echo -e "  ${BLUE}Backend:${NC}   http://localhost:8000"
echo -e "  ${BLUE}API Docs:${NC}  http://localhost:8000/docs"
echo ""
echo -e "${YELLOW}Logs directory:${NC} logs/"
echo -e "${YELLOW}  Backend:${NC}  tail -f logs/backend.log"
echo -e "${YELLOW}  Frontend:${NC} tail -f logs/frontend.log"
echo ""
echo -e "${YELLOW}To stop services:${NC} Press Ctrl+C or run: kill \$(cat .prod-pids)"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Keep script running and tail logs
tail -f "$PROJECT_ROOT/logs/backend.log" "$PROJECT_ROOT/logs/frontend.log"
