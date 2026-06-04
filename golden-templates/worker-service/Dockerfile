# =============================================================================
# .NET Worker Service — Multi-Stage Dockerfile
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
FROM mcr.microsoft.com/dotnet/runtime:8.0-alpine AS runtime
WORKDIR /app

# Security: Create non-root user
RUN addgroup -g 1000 appgroup && \
    adduser -u 1000 -G appgroup -s /bin/sh -D appuser

# Copy published app
COPY --from=build /app/publish .

# Security: Set ownership and switch to non-root user
RUN chown -R appuser:appgroup /app
USER appuser

# Environment variables
ENV DOTNET_EnableDiagnostics=0

ENTRYPOINT ["dotnet", "Worker.dll"]
