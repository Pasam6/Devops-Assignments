#!/bin/bash

# Script to clean up Docker resources
# Usage: ./scripts/cleanup.sh

set -e

echo "🧹 Cleaning up Docker resources..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Stop running containers
echo -e "${YELLOW}Stopping running containers...${NC}"
docker-compose down 2>/dev/null || echo "No containers to stop"
echo ""

# Remove images
echo -e "${YELLOW}Removing images...${NC}"
docker rmi docker-assignment-backend:latest 2>/dev/null || echo "Backend image not found"
docker rmi docker-assignment-frontend:latest 2>/dev/null || echo "Frontend image not found"
echo ""

# Remove network
echo -e "${YELLOW}Removing network...${NC}"
docker network rm docker-assignment-network 2>/dev/null || echo "Network not found"
echo ""

# Optional: Clean up all unused resources
read -p "Do you want to clean up all unused Docker resources? (y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo -e "${YELLOW}Running docker system prune...${NC}"
    docker system prune -f
    echo ""
fi

echo -e "${GREEN}✓ Cleanup complete!${NC}"

