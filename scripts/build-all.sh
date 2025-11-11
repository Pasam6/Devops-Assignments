#!/bin/bash

# Script to build all Docker images
# Usage: ./scripts/build-all.sh

set -e

echo "🐳 Building Docker Assignment Images..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Build backend
echo -e "${BLUE}Building backend image...${NC}"
cd backend
docker build -t docker-assignment-backend:latest .
echo -e "${GREEN}✓ Backend image built successfully${NC}"
echo ""

# Build frontend
echo -e "${BLUE}Building frontend image...${NC}"
cd ../frontend
docker build -t docker-assignment-frontend:latest .
echo -e "${GREEN}✓ Frontend image built successfully${NC}"
echo ""

# Display image sizes
echo -e "${BLUE}Image sizes:${NC}"
docker images | grep "docker-assignment"
echo ""

echo -e "${GREEN}✓ All images built successfully!${NC}"
echo ""
echo "To run the application:"
echo "  docker-compose up"
echo ""
echo "To run in detached mode:"
echo "  docker-compose up -d"

