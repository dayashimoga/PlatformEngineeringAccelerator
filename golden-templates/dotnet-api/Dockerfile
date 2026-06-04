# =============================================================================
# .NET API — Multi-Stage Dockerfile
# =============================================================================
# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src

# Copy project file and restore dependencies (layer caching)
COPY src/*.csproj ./
RUN dotnet restore

# Copy source and build
COPY src/ ./
RUN dotnet publish -c Release -o /app/publish --no-restore \
    /p:UseAppHost=false

# =============================================================================
# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS runtime
WORKDIR /app

# Security: Create non-root user
RUN addgroup -g 1000 appgroup && \
    adduser -u 1000 -G appgroup -s /bin/sh -D appuser

# Install curl for health checks
RUN apk add --no-cache curl

# Copy published app
COPY --from=build /app/publish .

# Security: Set ownership and switch to non-root user
RUN chown -R appuser:appgroup /app
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8080/healthz || exit 1

# Environment variables
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production
ENV DOTNET_EnableDiagnostics=0

ENTRYPOINT ["dotnet", "dotnet-api.dll"]
