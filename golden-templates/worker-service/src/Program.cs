using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using OpenTelemetry.Logs;
using OpenTelemetry.Metrics;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;

var builder = Host.CreateApplicationBuilder(args);

// --- Configuration ---
var serviceName = builder.Configuration["APP_NAME"] ?? "worker-service";
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
        .AddHttpClientInstrumentation()
        .AddOtlpExporter())
    .WithMetrics(metrics => metrics
        .AddHttpClientInstrumentation()
        .AddRuntimeInstrumentation()
        .AddProcessInstrumentation()
        .AddOtlpExporter());

builder.Logging.AddOpenTelemetry(logging => logging
    .AddOtlpExporter());

// --- Register Background Worker ---
builder.Services.AddHostedService<Worker>();

var host = builder.Build();
host.Run();
