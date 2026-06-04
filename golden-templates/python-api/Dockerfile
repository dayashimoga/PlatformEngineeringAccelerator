# =============================================================================
# Python API — Multi-Stage Dockerfile
# =============================================================================
FROM python:3.12-slim AS build
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

COPY . .

# =============================================================================
# Runtime stage
FROM python:3.12-slim AS runtime
WORKDIR /app

# Security: Create non-root user
RUN groupadd -g 1000 appgroup && \
    useradd -u 1000 -g appgroup -s /bin/bash appuser

# Install curl for health checks
RUN apt-get update && apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Copy Python packages and source
COPY --from=build /root/.local /home/appuser/.local
COPY --from=build /app/src ./src

ENV PATH=/home/appuser/.local/bin:$PATH

RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8080/healthz || exit 1

ENV APP_PORT=8080

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080", "--workers", "4"]
