#!/bin/bash

# Smart development launcher - automatically detects Docker availability
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}Python Template - Development Launcher${NC}"
echo ""

# Check if Docker is available and running
DOCKER_AVAILABLE=false
if command -v docker &> /dev/null; then
    if docker info > /dev/null 2>&1; then
        DOCKER_AVAILABLE=true
        echo -e "${GREEN}✓ Docker is available and running${NC}"
    else
        echo -e "${YELLOW}⚠ Docker is installed but not running${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Docker is not installed${NC}"
fi

echo ""

# If Docker is available, ask user preference
if [ "$DOCKER_AVAILABLE" = true ]; then
    echo "Choose startup mode:"
    echo "  1) Docker (Recommended - isolated environment)"
    echo "  2) Local (Direct on your machine)"
    echo "  3) Auto-select Docker"
    echo ""
    read -p "Enter choice [1-3] (default: 1): " choice
    choice=${choice:-1}

    case $choice in
        1)
            echo -e "${GREEN}Starting with Docker...${NC}"
            exec "$SCRIPT_DIR/dev-docker.sh"
            ;;
        2)
            echo -e "${GREEN}Starting locally...${NC}"
            exec "$SCRIPT_DIR/dev-local.sh"
            ;;
        3)
            echo -e "${GREEN}Auto-selecting Docker...${NC}"
            exec "$SCRIPT_DIR/dev-docker.sh"
            ;;
        *)
            echo -e "${RED}Invalid choice. Exiting.${NC}"
            exit 1
            ;;
    esac
else
    # Docker not available, use local mode
    echo -e "${BLUE}Docker is not available. Starting in local mode...${NC}"
    echo ""
    exec "$SCRIPT_DIR/dev-local.sh"
fi
