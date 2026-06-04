# =============================================================================
# Node.js API — Multi-Stage Dockerfile
# =============================================================================
# Build stage
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci --ignore-scripts --production=false

COPY . .
RUN npm run build --if-present && \
    npm prune --production

# =============================================================================
# Runtime stage
FROM node:20-alpine AS runtime
WORKDIR /app

# Security: Create non-root user
RUN addgroup -g 1000 appgroup && \
    adduser -u 1000 -G appgroup -s /bin/sh -D appuser

# Install curl for health checks
RUN apk add --no-cache curl dumb-init

# Copy production dependencies and source
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/src ./src
COPY --from=build /app/package.json ./

# Security
RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8080/healthz || exit 1

ENV NODE_ENV=production
ENV APP_PORT=8080

ENTRYPOINT ["dumb-init", "node", "src/index.js"]
