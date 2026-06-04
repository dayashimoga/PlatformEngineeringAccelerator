# Lab 01: Docker Hardening (UID & Capabilities)

## Lab Information
- **Difficulty**: Intermediate
- **Duration**: 30 minutes
- **Estimated Mastery Score**: +10 points

---

## 1. Goal
Modify a basic Dockerfile to drop root access, run under non-privileged user constraints, and minimize container image size using multi-stage builds.

---

## 2. Lab Tasks

### Task 1: Inspect the insecure Dockerfile
Open `golden-templates/node-api/Dockerfile` or similar base images.
Notice how we declare:
```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "src/index.js"]
```
*Vulnerability*: This container runs as root inside the namespace, allowing host execution privilege escalations.

### Task 2: Harden the image
Refactor the Dockerfile to include non-root profiles:
```dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:20-alpine AS runtime
WORKDIR /app
# Create non-root group and user
RUN addgroup -g 1000 appgroup && \
    adduser -u 1000 -G appgroup -s /bin/sh -D appuser
COPY --from=build /app/node_modules ./node_modules
COPY src/ ./src
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 8080
CMD ["node", "src/index.js"]
```

---

## 3. Validation Steps
1. Build the container tag:
   ```bash
   docker build -t local/hardened-node:v1 .
   ```
2. Verify which user ID runs the container process:
   ```bash
   docker run --rm local/hardened-node:v1 id
   ```
   *Expected Output*: `uid=1000(appuser) gid=1000(appgroup)`
