# 🐳 Docker Multi-Stage Build Assignment

This repository contains a hands-on Docker assignment where you will create multi-stage Docker builds and configure container communication between a Java backend and React frontend.

## 📋 Assignment Overview

**Objective**: Write Dockerfiles and docker-compose.yml to containerize both Java backend and React frontend applications, ensuring they can communicate with each other.

### Your Tasks
You need to create the following files:
- ✏️ `backend/Dockerfile` - Multi-stage Dockerfile for Java Spring Boot application
- ✏️ `frontend/Dockerfile` - Multi-stage Dockerfile for React application
- ✏️ `docker-compose.yml` - Orchestration file to run both services together

### Learning Outcomes
- Understand multi-stage Docker builds
- Optimize Docker images for production
- Configure container networking
- Implement frontend-backend communication in containerized environments

---

## 🛠️ Technology Stack

### Backend
- **Language**: Java 17
- **Framework**: Spring Boot 3.2.0
- **Build Tool**: Maven 3.9
- **Base Images**:
  - Builder: `maven:3.9-eclipse-temurin-17-alpine`
  - Runtime: `eclipse-temurin:17-jre-alpine`
- **Port**: 8080

### Frontend
- **Framework**: React 18.2
- **Build Tool**: Vite 5.0
- **Runtime**: Node.js 20
- **Web Server**: Nginx 1.25
- **Base Images**:
  - Builder: `node:20-alpine`
  - Runtime: `nginx:1.25-alpine`
- **Port**: 3000 (mapped to container port 80)

### Infrastructure
- **Docker**: 20.10+
- **Docker Compose**: 2.0+
- **Network**: Custom bridge network

---

## 🏗️ Architecture

```
┌─────────────────────┐         ┌─────────────────────┐
│                     │         │                     │
│   Frontend (React)  │ ──────► │  Backend (Spring)   │
│   Port: 3000        │   HTTP  │  Port: 8080        │
│   (Nginx)           │         │  (Java 17)         │
│                     │         │                     │
└─────────────────────┘         └─────────────────────┘
         │                               │
         └───────────────┬───────────────┘
                         │
                 Docker Network
                (app-network)
```

---

## 📂 Project Structure

```
Devops-Assignments/
├── backend/                    # Java Spring Boot Application
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/example/backend/
│   │   │   │   ├── BackendApplication.java
│   │   │   │   ├── controller/ApiController.java
│   │   │   │   └── model/
│   │   │   │       ├── Message.java
│   │   │   │       └── User.java
│   │   │   └── resources/
│   │   │       └── application.yml
│   ├── Dockerfile              # ⚠️ YOU NEED TO CREATE THIS
│   └── pom.xml                 # Maven dependencies
│
├── frontend/                   # React Application
│   ├── src/
│   │   ├── App.jsx             # Main React component
│   │   ├── App.css
│   │   ├── main.jsx
│   │   └── index.css
│   ├── index.html
│   ├── Dockerfile              # ⚠️ YOU NEED TO CREATE THIS
│   ├── nginx.conf              # Nginx configuration (provided)
│   ├── package.json            # NPM dependencies (provided)
│   └── vite.config.js          # Vite configuration (provided)
│
├── docker-compose.yml          # ⚠️ YOU NEED TO CREATE THIS
├── scripts/
│   ├── test-connection.sh      # Test script (provided)
│   ├── build-all.sh            # Helper scripts (provided)
│   └── cleanup.sh
├── .gitignore
└── README.md                   # This file
```

---

## 🚀 Quick Start

### Prerequisites
- Docker (version 20.10 or higher)
- Docker Compose (version 2.0 or higher)
- Basic understanding of Docker, Java, and React

### Assignment Steps

1. **Clone or navigate to the repository**:
   ```bash
   cd Devops-Assignments
   ```

2. **Create the required Docker files** (See detailed requirements below):
   - Create `backend/Dockerfile`
   - Create `frontend/Dockerfile`
   - Create `docker-compose.yml` in the root directory

3. **Build and start all containers**:
   ```bash
   docker-compose up --build
   ```

4. **Test your implementation**:
   ```bash
   # Run the automated test script
   chmod +x scripts/test-connection.sh
   ./scripts/test-connection.sh
   ```

5. **Access the applications** (if successful):
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8080/api/users
   - Backend Health: http://localhost:8080/actuator/health

6. **Stop the containers**:
   ```bash
   docker-compose down
   ```

---

## 📝 Assignment Requirements

### Backend Dockerfile Requirements

Create a `backend/Dockerfile` with the following specifications:

**Stage 1: Builder Stage**
- Use Maven image with Java 17: `maven:3.9-eclipse-temurin-17-alpine`
- Set working directory to `/app`
- Copy `pom.xml` and download dependencies
- Copy source code from `src/` directory
- Build the application using Maven (create JAR file)
- JAR file should be named `backend-app.jar` in the `target/` directory

**Stage 2: Runtime Stage**
- Use JRE-only image: `eclipse-temurin:17-jre-alpine`
- Create a non-root user named `spring`
- Copy the JAR file from builder stage
- Expose port `8080`
- Add health check using `wget` to check `/actuator/health`
- Run the application as non-root user

**Expected Final Image Size**: ~200MB

---

### Frontend Dockerfile Requirements

Create a `frontend/Dockerfile` with the following specifications:

**Stage 1: Builder Stage**
- Use Node.js image: `node:20-alpine`
- Set working directory to `/app`
- Copy `package*.json` files
- Install dependencies using `npm ci` (ensure package-lock.json exists)
- Copy all source code
- Build the application using `npm run build` (creates `dist/` directory)

**Stage 2: Production Stage**
- Use Nginx image: `nginx:1.25-alpine`
- Copy custom `nginx.conf` to `/etc/nginx/conf.d/default.conf`
- Copy built static files from builder stage (`dist/`) to `/usr/share/nginx/html`
- Expose port `80`
- Add health check using `wget` to check `/health` endpoint
- Start nginx in foreground mode

**Expected Final Image Size**: ~25MB

---

### Docker Compose Requirements

Create a `docker-compose.yml` in the root directory with the following specifications:

**Services**:

1. **backend**:
   - Build from `./backend` directory
   - Container name: `docker-assignment-backend`
   - Port mapping: `8080:8080`
   - Network: `app-network`
   - Environment variable: `SPRING_PROFILES_ACTIVE=default`
   - Health check: Check `/actuator/health` endpoint every 30s
   - Restart policy: `unless-stopped`

2. **frontend**:
   - Build from `./frontend` directory
   - Build arg: `VITE_BACKEND_URL=http://localhost:8080`
   - Container name: `docker-assignment-frontend`
   - Port mapping: `3000:80`
   - Network: `app-network`
   - Depends on: `backend` (wait for backend to be healthy)
   - Health check: Check `/health` endpoint every 30s
   - Restart policy: `unless-stopped`

**Networks**:
- Create custom bridge network named `docker-assignment-network`

---

## 🔍 Understanding Multi-Stage Builds

### Backend Dockerfile (Java)

The backend uses a **two-stage build**:

#### Stage 1: Build Stage
```dockerfile
FROM maven:3.9-eclipse-temurin-17-alpine AS builder
```
- Uses Maven image to compile the Java application
- Downloads dependencies and builds the JAR file
- Results in a large image (~800MB) but includes all build tools

#### Stage 2: Runtime Stage
```dockerfile
FROM eclipse-temurin:17-jre-alpine
```
- Uses minimal JRE-only image (no build tools)
- Copies only the compiled JAR from Stage 1
- Results in a smaller image (~200MB)
- Includes security best practices (non-root user)

**Benefits**:
- ✅ Smaller final image size (75% reduction)
- ✅ Faster deployment and scaling
- ✅ Better security (no build tools in production)
- ✅ Cleaner image with only runtime dependencies

### Frontend Dockerfile (React)

The frontend uses a **two-stage build**:

#### Stage 1: Build Stage
```dockerfile
FROM node:20-alpine AS builder
```
- Uses Node.js image to install dependencies
- Runs Vite build to create optimized static files
- Includes development tools and all node_modules

#### Stage 2: Production Stage
```dockerfile
FROM nginx:1.25-alpine
```
- Uses lightweight Nginx image
- Copies only the built static files from Stage 1
- No Node.js or build tools in final image
- Configured with optimized nginx.conf

**Benefits**:
- ✅ Drastically smaller image (~25MB vs ~400MB)
- ✅ Nginx serves static files efficiently
- ✅ Built-in caching and compression
- ✅ Production-ready web server

---

## 🌐 Container Communication

### How the Containers Communicate

1. **Docker Network**: Both containers are connected to a custom bridge network `app-network`

2. **Service Discovery**: 
   - Containers can reach each other using service names
   - Backend is accessible at `http://backend:8080` from frontend container

3. **Port Mapping**:
   - Host `localhost:8080` → Backend container `8080`
   - Host `localhost:3000` → Frontend container `80`

4. **Frontend Configuration**:
   - Frontend makes API calls to `http://localhost:8080` (from browser)
   - In production, you'd use environment variables or reverse proxy

5. **Health Checks**:
   - Both containers have health checks configured
   - Frontend waits for backend to be healthy before starting

---

## 🛠️ Manual Build and Run (Without Docker Compose)

### Building Images Separately

```bash
# Build backend image
cd backend
docker build -t docker-assignment-backend:latest .

# Build frontend image
cd ../frontend
docker build -t docker-assignment-frontend:latest .
```

### Running Containers Manually

```bash
# Create network
docker network create app-network

# Run backend
docker run -d \
  --name backend \
  --network app-network \
  -p 8080:8080 \
  docker-assignment-backend:latest

# Run frontend (after backend is healthy)
docker run -d \
  --name frontend \
  --network app-network \
  -p 3000:80 \
  docker-assignment-frontend:latest
```

---

## 📊 API Endpoints

### Backend Endpoints

| Method | Endpoint          | Description              |
|--------|-------------------|--------------------------|
| GET    | `/api/health`     | Health check             |
| GET    | `/api/info`       | Backend information      |
| GET    | `/api/users`      | List all users           |
| GET    | `/api/users/{id}` | Get specific user        |
| POST   | `/api/users`      | Create new user          |

### Example API Calls

```bash
# Get all users
curl http://localhost:8080/api/users

# Get backend info
curl http://localhost:8080/api/info

# Create a new user
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Alice","email":"alice@example.com"}'
```

---

## 🔧 Development Mode

### Running Backend Locally (without Docker)

```bash
cd backend
./mvnw spring-boot:run
```

### Running Frontend Locally (without Docker)

```bash
cd frontend
npm install
npm run dev
```

---

## 📈 Image Size Comparison

### Without Multi-Stage Builds:
- Backend: ~800MB (includes Maven, source code, build tools)
- Frontend: ~400MB (includes Node.js, node_modules, source code)
- **Total**: ~1.2GB

### With Multi-Stage Builds:
- Backend: ~200MB (only JRE + JAR)
- Frontend: ~25MB (only Nginx + static files)
- **Total**: ~225MB

**Space Saved**: ~81% reduction! 🎉

---

## 🎯 Assignment Tasks

### Level 1: Core Requirements (MANDATORY)
1. ✏️ Create `backend/Dockerfile` with multi-stage build
2. ✏️ Create `frontend/Dockerfile` with multi-stage build
3. ✏️ Create `docker-compose.yml` to orchestrate both services
4. ✅ Run `docker-compose up --build` successfully
5. ✅ Verify both containers are running and healthy
6. ✅ Pass all tests in `./scripts/test-connection.sh`
7. ✅ Access frontend at http://localhost:3000 and see data from backend

### Level 2: Documentation & Understanding (RECOMMENDED)
1. 📝 Document what each stage in your Dockerfiles does
2. 📝 Compare image sizes: check with `docker images`
3. 📝 Explain how the containers communicate with each other
4. 📝 Document the purpose of health checks
5. 📝 Create a troubleshooting guide for common issues you encountered

### Level 3: Advanced Enhancements (OPTIONAL)
1. 🚀 Add `.dockerignore` files to optimize build context
2. 🚀 Implement docker-compose profiles (dev/prod)
3. 🚀 Add volume mounts for development hot-reload
4. 🚀 Optimize build times using build cache
5. 🚀 Add monitoring/logging with Docker logging drivers
6. 🚀 Implement security scanning of images

---

## 💡 Hints & Tips

### Backend Dockerfile Hints
- Remember to use `AS builder` to name your first stage
- Maven command to package: `mvn clean package -DskipTests`
- The JAR file will be in `/app/target/backend-app.jar`
- Use `COPY --from=builder` to copy from the previous stage
- Health check command format: `wget --quiet --tries=1 --spider URL`
- Switch to non-root user with `USER spring` before CMD

### Frontend Dockerfile Hints
- `npm ci` requires `package-lock.json` - you may need to run `npm install` locally first
- Vite builds to `dist/` directory by default
- Nginx conf must be copied before the static files
- Health check endpoint `/health` is configured in nginx.conf
- Nginx daemon off: `CMD ["nginx", "-g", "daemon off;"]`

### Docker Compose Hints
- Version: Use `version: '3.8'`
- Health check format:
  ```yaml
  healthcheck:
    test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "URL"]
    interval: 30s
    timeout: 10s
    retries: 3
    start_period: 40s
  ```
- Dependency with condition:
  ```yaml
  depends_on:
    backend:
      condition: service_healthy
  ```
- Network driver: Use `bridge` driver

### Common Commands
```bash
# Check if port is in use
sudo lsof -i :8080
sudo lsof -i :3000

# View container logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Rebuild without cache
docker-compose build --no-cache

# Check image sizes
docker images | grep docker-assignment
```

---

## 🐛 Troubleshooting

### Backend container fails to start
```bash
# Check logs
docker logs docker-assignment-backend

# Common issues:
# - Port 8080 already in use
# - Java version mismatch
```

### Frontend can't connect to backend
```bash
# Verify backend is running
curl http://localhost:8080/api/health

# Check if containers are on same network
docker network inspect docker-assignment-network

# Check browser console for CORS errors
```

### Build fails with dependency errors
```bash
# Clean Docker cache
docker builder prune -a

# Rebuild without cache
docker-compose build --no-cache
```

---

## 📚 Learning Resources

- [Docker Multi-Stage Builds Documentation](https://docs.docker.com/build/building/multi-stage/)
- [Docker Compose Networking](https://docs.docker.com/compose/networking/)
- [Spring Boot with Docker](https://spring.io/guides/topicals/spring-boot-docker/)
- [React Production Build](https://react.dev/learn/start-a-new-react-project)

---

## 🤝 Contributing

This is an educational project. Feel free to:
- Add more features to the backend/frontend
- Improve the Docker configurations
- Add more documentation
- Create additional examples

---

## 📝 License

This project is created for educational purposes.

---

## 👨‍💻 Author

DevOps Training Assignment - Multi-Stage Docker Builds

---

## 🎓 Key Takeaways

1. **Multi-stage builds** significantly reduce image size
2. **Build stages** separate build-time and run-time dependencies
3. **Docker networks** enable container-to-container communication
4. **Health checks** ensure service availability
5. **Docker Compose** simplifies multi-container orchestration

---

## 📋 Quick Reference Card

### Files You Need to Create
| File | Location | Purpose |
|------|----------|---------|
| `Dockerfile` | `backend/` | Multi-stage build for Java app |
| `Dockerfile` | `frontend/` | Multi-stage build for React app |
| `docker-compose.yml` | Root directory | Orchestrate both services |

### Key Specifications
| Component | Value |
|-----------|-------|
| Backend Port | `8080` |
| Frontend Port | `3000` (host) → `80` (container) |
| Backend Container Name | `docker-assignment-backend` |
| Frontend Container Name | `docker-assignment-frontend` |
| Network Name | `docker-assignment-network` |
| Backend JAR Name | `backend-app.jar` |
| Frontend Build Output | `dist/` directory |
| Backend Health Endpoint | `/actuator/health` |
| Frontend Health Endpoint | `/health` |

### Docker Images to Use
| Stage | Backend | Frontend |
|-------|---------|----------|
| **Builder** | `maven:3.9-eclipse-temurin-17-alpine` | `node:20-alpine` |
| **Runtime** | `eclipse-temurin:17-jre-alpine` | `nginx:1.25-alpine` |

### Essential Commands
```bash
# Build and run
docker-compose up --build

# Run in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Stop containers
docker-compose down

# Test your solution
./scripts/test-connection.sh

# Check image sizes
docker images | grep docker-assignment
```

---

Happy Learning! 🚀🐳
