# Lab 05: OpenTelemetry Collector (Metric Scraping)

## Lab Information
- **Difficulty**: Expert
- **Duration**: 60 minutes
- **Estimated Mastery Score**: +20 points

---

## 1. Goal
Deploy the OpenTelemetry Collector and configure it to scrape metrics from running microservices and forward them to Prometheus storage.

---

## 2. Lab Tasks

### Task 1: Inspect Collector Pipeline
Open [otel-collector-config.yaml](file:///h:/devopsprod4jun26/observability/otel/otel-collector-config.yaml).
Verify the pipelines configuration:
- **Receivers**: Receives OTLP protocols on gRPC/HTTP ports.
- **Processors**: Handles memory limiting, batching, and metadata attributes extraction.
- **Exporters**: Exports metrics to the local Prometheus scraping server.

### Task 2: Verify Instrumentation
Deploy our pre-instrumented Node or .NET Golden template.
Ensure that the metrics route is scraping:
```bash
curl http://localhost:8080/metrics
```
Metrics (e.g. http_requests_total, process_cpu_seconds_total) should be visible.

---

## 3. Validation Steps
Run verify scripts to check collector status:
```bash
make verify
```
*Expected Output*: `[PASS] Telemetry Collector - OpenTelemetry Ingestion active`
