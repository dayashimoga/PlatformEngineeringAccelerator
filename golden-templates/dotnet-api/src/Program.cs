using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using OpenTelemetry.Logs;
using OpenTelemetry.Metrics;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;

var builder = WebApplication.CreateBuilder(args);

// --- Service Configuration ---
var serviceName = builder.Configuration["APP_NAME"] ?? "dotnet-api";
var serviceVersion = builder.Configuration["APP_VERSION"] ?? "1.0.0";

// --- OpenTelemetry ---
builder.Services.AddOpenTelemetry()
    .ConfigureResource(resource => resource
        .AddService(serviceName: serviceName, serviceVersion: serviceVersion)
        .AddAttributes(new Dictionary<string, object>
        {
            ["deployment.environment"] = builder.Environment.EnvironmentName,
            ["host.name"] = Environment.MachineName
        }))
    .WithTracing(tracing => tracing
        .AddAspNetCoreInstrumentation(options =>
        {
            options.Filter = context =>
                !context.Request.Path.StartsWithSegments("/healthz") &&
                !context.Request.Path.StartsWithSegments("/ready") &&
                !context.Request.Path.StartsWithSegments("/metrics");
        })
        .AddHttpClientInstrumentation()
        .AddOtlpExporter())
    .WithMetrics(metrics => metrics
        .AddAspNetCoreInstrumentation()
        .AddHttpClientInstrumentation()
        .AddRuntimeInstrumentation()
        .AddProcessInstrumentation()
        .AddPrometheusExporter()
        .AddOtlpExporter());

builder.Logging.AddOpenTelemetry(logging => logging
    .AddOtlpExporter());

// --- Health Checks ---
builder.Services.AddHealthChecks()
    .AddCheck("self", () => HealthCheckResult.Healthy("Service is running"), tags: new[] { "ready", "live" });

// --- API Controllers ---
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// --- Middleware Pipeline ---
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// --- Health Endpoints ---
app.MapHealthChecks("/healthz", new HealthCheckOptions
{
    Predicate = check => check.Tags.Contains("live")
});

app.MapHealthChecks("/ready", new HealthCheckOptions
{
    Predicate = check => check.Tags.Contains("ready")
});

// --- Prometheus Metrics ---
app.UseOpenTelemetryPrometheusScrapingEndpoint("/metrics");

// --- API Routes ---
app.MapControllers();

app.MapGet("/", () => Results.Ok(new
{
    service = serviceName,
    version = serviceVersion,
    status = "running",
    timestamp = DateTime.UtcNow
}));

app.Run();
