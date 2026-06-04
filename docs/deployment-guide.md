# Platform Deployment & Setup Guide

This guide details the step-by-step instructions to deploy and configure the Platform Engineering Accelerator infrastructure and tooling.

## Prerequisites

Ensure you have the following CLIs installed locally:
- `azure-cli`, `aws-cli`, or `google-cloud-sdk`
- `terraform` (v1.5+)
- `kubectl`
- `helm` (v3+)
- `conftest` (optional, for local OPA validation)

---

## Step 1: Provision Infrastructure with Terraform

1. Authenticate with your cloud provider (e.g., Azure):
   ```bash
   az login
   ```

2. Initialize Terraform backend and workspaces:
   ```bash
   cd platform/terraform
   terraform init
   ```

3. Select or create your target environment workspace (e.g., dev):
   ```bash
   terraform workspace new dev || terraform workspace select dev
   ```

4. Preview and apply changes:
   ```bash
   terraform plan -var-file="environments/dev/terraform.tfvars"
   terraform apply -var-file="environments/dev/terraform.tfvars" -auto-approve
   ```

5. Retrieve cluster credentials:
   ```bash
   az aks get-credentials --resource-group platform-accelerator-dev-rg --name platform-accelerator-dev-aks
   ```

---

## Step 2: Bootstrap Platform Services

Once Kubeconfig points to your newly created cluster, run the bootstrap shell script:

```bash
chmod +x scripts/*.sh
./scripts/bootstrap.sh
```

This script will:
1. Create system namespaces (`argocd`, `monitoring`, `observability`, `security`).
2. Install Argo CD, configure roles, and deploy the application bootstrap sync generator.
3. Install Kube-Prometheus-Stack, import Grafana dashboards, and configure monitoring alerts.
4. Deploy the OpenTelemetry Operator, Otel Collector, and instrument runtimes.

---

## Step 3: Access Platform Dashboards

### Argo CD Portal
Retrieve the automatically generated admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo
```
Port-forward to your local machine:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
Visit: `https://localhost:8080`

### Grafana Dashboard
Retrieve the admin password:
```bash
kubectl get secret --namespace monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode; echo
```
Port-forward to your local machine:
```bash
kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80
```
Visit: `http://localhost:3000` (Search dashboards for **Application Dashboard** or **Infrastructure Dashboard**).
