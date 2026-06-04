# Simulation 04: Certificate Expiration (TLS Failures)

## Incident Scenario
The SSL/TLS certificate mapped to the cluster ingress controller expires, blocking browser client connections.

## Symptoms & Metrics
- **Browser Error**: `NET::ERR_CERT_DATE_INVALID` or `SSL handshake failed`.
- **AlertManager Notification**: `CertificateExpiration` warning.

## Step-by-Step Investigation
1. Inspect the certificate validity details using openssl:
   ```bash
   echo | openssl s_client -showcerts -connect app.example.com:443 2>/dev/null | openssl x509 -noout -dates
   ```
2. Verify Cert-Manager certificate resources and status:
   ```bash
   kubectl get certificates -n <namespace>
   kubectl get secrets -n <namespace>
   ```

## Recovery Procedures
- **Force Renewal**: Trigger Cert-Manager renewal manually:
  ```bash
  kubectl cert-manager renew <certificate-name> -n <namespace>
  ```
- **Verify Issuance**: Monitor the issuance challenge events:
  ```bash
  kubectl describe challenge -n <namespace>
  ```
