"""
Python API — FastAPI with OpenTelemetry instrumentation
"""
import os
import time
from contextlib import asynccontextmanager
from datetime import datetime, timezone

from fastapi import FastAPI, Request, Response
from opentelemetry import trace, metrics
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OTLPMetricExporter
from opentelemetry.exporter.prometheus import PrometheusMetricReader
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

# --- Configuration ---
SERVICE_NAME = os.getenv("APP_NAME", "python-api")
SERVICE_VERSION = os.getenv("APP_VERSION", "1.0.0")
OTEL_ENDPOINT = os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "http://localhost:4317")

# --- OpenTelemetry Setup ---
resource = Resource.create({
    "service.name": SERVICE_NAME,
    "service.version": SERVICE_VERSION,
    "deployment.environment": os.getenv("ENVIRONMENT", "development"),
})

# Tracing
tracer_provider = TracerProvider(resource=resource)
span_exporter = OTLPSpanExporter(endpoint=OTEL_ENDPOINT, insecure=True)
tracer_provider.add_span_processor(BatchSpanProcessor(span_exporter))
trace.set_tracer_provider(tracer_provider)

# Metrics
prometheus_reader = PrometheusMetricReader()
meter_provider = MeterProvider(resource=resource, metric_readers=[prometheus_reader])
metrics.set_meter_provider(meter_provider)

# --- Prometheus Metrics ---
REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["method", "route", "status"],
)

REQUEST_DURATION = Histogram(
    "http_request_duration_seconds",
    "HTTP request duration",
    ["method", "route", "status"],
    buckets=(0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10),
)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan manager."""
    yield
    tracer_provider.shutdown()
    meter_provider.shutdown()


# --- FastAPI App ---
app = FastAPI(
    title=SERVICE_NAME,
    version=SERVICE_VERSION,
    lifespan=lifespan,
)

# Auto-instrument FastAPI
FastAPIInstrumentor.instrument_app(
    app,
    excluded_urls="healthz,ready,metrics",
)


@app.middleware("http")
async def metrics_middleware(request: Request, call_next):
    """Collect request metrics."""
    start_time = time.time()
    response: Response = await call_next(request)
    duration = time.time() - start_time

    route = request.url.path
    if route not in ("/healthz", "/ready", "/metrics"):
        REQUEST_COUNT.labels(
            method=request.method,
            route=route,
            status=response.status_code,
        ).inc()
        REQUEST_DURATION.labels(
            method=request.method,
            route=route,
            status=response.status_code,
        ).observe(duration)

    return response


# --- Health Endpoints ---
@app.get("/healthz")
async def health():
    return {"status": "healthy", "timestamp": datetime.now(timezone.utc).isoformat()}


@app.get("/ready")
async def ready():
    return {"status": "ready", "timestamp": datetime.now(timezone.utc).isoformat()}


# --- Metrics Endpoint ---
@app.get("/metrics")
async def prometheus_metrics():
    return Response(content=generate_latest(), media_type=CONTENT_TYPE_LATEST)


# --- API Routes ---
@app.get("/")
async def root():
    return {
        "service": SERVICE_NAME,
        "version": SERVICE_VERSION,
        "status": "running",
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }
