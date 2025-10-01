#!/bin/bash

# Project initialization script - rename project from template
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default template name
TEMPLATE_NAME="python-template"

# Check if project name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Project name is required${NC}"
    echo "Usage: $0 <project-name>"
    echo "Example: $0 my-awesome-project"
    exit 1
fi

NEW_PROJECT_NAME="$1"

# Validate project name (alphanumeric and hyphens only)
if ! [[ "$NEW_PROJECT_NAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
    echo -e "${RED}Error: Project name must contain only letters, numbers, and hyphens${NC}"
    exit 1
fi

echo -e "${GREEN}Initializing project: $NEW_PROJECT_NAME${NC}"
echo ""

# Function to replace text in file
replace_in_file() {
    local file=$1
    local search=$2
    local replace=$3

    if [ -f "$file" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s/$search/$replace/g" "$file"
        else
            # Linux
            sed -i "s/$search/$replace/g" "$file"
        fi
        echo -e "${GREEN}✓${NC} Updated: $file"
    else
        echo -e "${YELLOW}⚠${NC} Skipped (not found): $file"
    fi
}

# Files to update
echo "Updating configuration files..."

# Python configuration
replace_in_file "pyproject.toml" "name = \"$TEMPLATE_NAME\"" "name = \"$NEW_PROJECT_NAME\""
replace_in_file "setup.py" "name=\"$TEMPLATE_NAME\"" "name=\"$NEW_PROJECT_NAME\""

# Frontend configuration
replace_in_file "frontend/package.json" "\"name\": \"${TEMPLATE_NAME}-frontend\"" "\"name\": \"${NEW_PROJECT_NAME}-frontend\""

# Docker compose files
replace_in_file "docker-compose.yml" "${TEMPLATE_NAME}-backend" "${NEW_PROJECT_NAME}-backend"
replace_in_file "docker-compose.yml" "${TEMPLATE_NAME}-frontend" "${NEW_PROJECT_NAME}-frontend"
replace_in_file "docker-compose.dev.yml" "${TEMPLATE_NAME}-backend-dev" "${NEW_PROJECT_NAME}-backend-dev"
replace_in_file "docker-compose.dev.yml" "${TEMPLATE_NAME}-frontend-dev" "${NEW_PROJECT_NAME}-frontend-dev"

# README
replace_in_file "README.md" "# Python Template" "# ${NEW_PROJECT_NAME}"
replace_in_file "README.md" "${TEMPLATE_NAME}/" "${NEW_PROJECT_NAME}/"

echo ""
echo -e "${GREEN}Project initialization complete!${NC}"
echo ""
echo "Project name changed from '${TEMPLATE_NAME}' to '${NEW_PROJECT_NAME}'"
echo ""
echo "Next steps:"
echo "1. Review and update .env file with your configuration"
echo "2. Update README.md with your project description"
echo "3. Start development: ./scripts/dev.sh"
echo ""
echo -e "${YELLOW}Note: You may want to remove this script after initialization${NC}"
