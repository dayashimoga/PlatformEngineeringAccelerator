const express = require('express');
const { MeterProvider } = require('@opentelemetry/sdk-metrics');
const { NodeSDK } = require('@opentelemetry/sdk-node');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-grpc');
const { OTLPMetricExporter } = require('@opentelemetry/exporter-metrics-otlp-grpc');
const { getNodeAutoInstrumentations } = require('@opentelemetry/auto-instrumentations-node');
const { PrometheusExporter } = require('@opentelemetry/exporter-prometheus');
const { Resource } = require('@opentelemetry/resources');
const { SEMRESATTRS_SERVICE_NAME, SEMRESATTRS_SERVICE_VERSION } = require('@opentelemetry/semantic-conventions');
const promClient = require('prom-client');

// --- Configuration ---
const SERVICE_NAME = process.env.APP_NAME || 'node-api';
const SERVICE_VERSION = process.env.APP_VERSION || '1.0.0';
const PORT = parseInt(process.env.APP_PORT || '8080', 10);
const OTEL_ENDPOINT = process.env.OTEL_EXPORTER_OTLP_ENDPOINT || 'http://localhost:4317';

// --- OpenTelemetry Setup ---
const sdk = new NodeSDK({
  resource: new Resource({
    [SEMRESATTRS_SERVICE_NAME]: SERVICE_NAME,
    [SEMRESATTRS_SERVICE_VERSION]: SERVICE_VERSION,
    'deployment.environment': process.env.NODE_ENV || 'development',
  }),
  traceExporter: new OTLPTraceExporter({
    url: OTEL_ENDPOINT,
  }),
  metricReader: new PrometheusExporter({ port: 9464 }),
  instrumentations: [
    getNodeAutoInstrumentations({
      '@opentelemetry/instrumentation-http': {
        ignoreIncomingPaths: ['/healthz', '/ready', '/metrics'],
      },
      '@opentelemetry/instrumentation-fs': { enabled: false },
    }),
  ],
});

sdk.start();
process.on('SIGTERM', () => sdk.shutdown().then(() => process.exit(0)));

// --- Prometheus Metrics ---
const collectDefaultMetrics = promClient.collectDefaultMetrics;
collectDefaultMetrics({ prefix: 'node_api_' });

const httpRequestsTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status'],
});

const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'route', 'status'],
  buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10],
});

// --- Express App ---
const app = express();
app.use(express.json());

// Metrics middleware
app.use((req, res, next) => {
  const start = process.hrtime.bigint();
  res.on('finish', () => {
    const duration = Number(process.hrtime.bigint() - start) / 1e9;
    const route = req.route?.path || req.path;
    httpRequestsTotal.inc({ method: req.method, route, status: res.statusCode });
    httpRequestDuration.observe({ method: req.method, route, status: res.statusCode }, duration);
  });
  next();
});

// --- Health Endpoints ---
app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.get('/ready', (req, res) => {
  res.status(200).json({ status: 'ready', timestamp: new Date().toISOString() });
});

// --- Metrics Endpoint ---
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', promClient.register.contentType);
  res.end(await promClient.register.metrics());
});

// --- API Routes ---
app.get('/', (req, res) => {
  res.json({
    service: SERVICE_NAME,
    version: SERVICE_VERSION,
    status: 'running',
    timestamp: new Date().toISOString(),
  });
});

// --- Start Server ---
app.listen(PORT, '0.0.0.0', () => {
  console.log(`${SERVICE_NAME} v${SERVICE_VERSION} listening on port ${PORT}`);
});

module.exports = app;
