#!/bin/bash

# Script to test the connection between frontend and backend
# Usage: ./scripts/test-connection.sh

set -e

echo "🔍 Testing Docker Assignment Application..."
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if containers are running
echo -e "${BLUE}Checking if containers are running...${NC}"
if ! docker ps | grep -q "docker-assignment-backend"; then
    echo -e "${RED}✗ Backend container is not running${NC}"
    exit 1
fi
if ! docker ps | grep -q "docker-assignment-frontend"; then
    echo -e "${RED}✗ Frontend container is not running${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Both containers are running${NC}"
echo ""

# Test backend health
echo -e "${BLUE}Testing backend health...${NC}"
HEALTH_STATUS=$(curl -s http://localhost:8080/actuator/health | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
if [ "$HEALTH_STATUS" = "UP" ]; then
    echo -e "${GREEN}✓ Backend is healthy${NC}"
else
    echo -e "${RED}✗ Backend health check failed${NC}"
    exit 1
fi
echo ""

# Test backend API
echo -e "${BLUE}Testing backend API endpoints...${NC}"
if curl -s http://localhost:8080/api/users | grep -q "John Doe"; then
    echo -e "${GREEN}✓ /api/users endpoint working${NC}"
else
    echo -e "${RED}✗ /api/users endpoint failed${NC}"
    exit 1
fi

if curl -s http://localhost:8080/api/info | grep -q "Docker Assignment Backend"; then
    echo -e "${GREEN}✓ /api/info endpoint working${NC}"
else
    echo -e "${RED}✗ /api/info endpoint failed${NC}"
    exit 1
fi
echo ""

# Test frontend
echo -e "${BLUE}Testing frontend...${NC}"
if curl -s http://localhost:3000 | grep -q "root"; then
    echo -e "${GREEN}✓ Frontend is accessible${NC}"
else
    echo -e "${RED}✗ Frontend is not accessible${NC}"
    exit 1
fi

if curl -s http://localhost:3000/health | grep -q "healthy"; then
    echo -e "${GREEN}✓ Frontend health check working${NC}"
else
    echo -e "${RED}✗ Frontend health check failed${NC}"
    exit 1
fi
echo ""

# Display container information
echo -e "${BLUE}Container Information:${NC}"
docker ps --filter "name=docker-assignment" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Display network information
echo -e "${BLUE}Network Information:${NC}"
docker network inspect docker-assignment-network --format '{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}'
echo ""

echo -e "${GREEN}✓ All tests passed!${NC}"
echo ""
echo "Access the application:"
echo "  Frontend: http://localhost:3000"
echo "  Backend:  http://localhost:8080/api/users"

