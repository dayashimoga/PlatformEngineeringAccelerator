# Simulation 02: Traffic Spike & Autoscaling

## Incident Scenario
A sudden spike in consumer API request traffic hits the application gateway, exhausting node CPU capacity and raising endpoint request latency.

## Symptoms & Metrics
- **Grafana Panels**: Request Rate (reqps) spikes. P95 latency exceeds 2 seconds.
- **AlertManager Notification**: `HighLatency` alert triggered.

## Step-by-Step Investigation
1. Check running pod counts and HPA limits:
   ```bash
   kubectl get hpa -n <namespace>
   ```
2. Verify if the cluster is experiencing CPU throttling:
   - Check the CPU Usage metrics compared to resource limits.
3. Validate if the cloud provider is adding additional node instances to handle scheduling bottlenecks.

## Recovery Procedures
- **Increase HPA Limits**: If the current replica count matches the maxReplicas limit, increase the HPA parameters inside `values-prod.yaml`:
  ```yaml
  autoscaling:
    maxReplicas: 20
  ```
- **Apply Patches**: Commit changes to Git and trigger Argo CD sync.
