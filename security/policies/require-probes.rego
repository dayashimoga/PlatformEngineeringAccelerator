# =============================================================================
# OPA Policy: Require Health Probes
# =============================================================================
package kubernetes.admission

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.livenessProbe
  msg := sprintf("Liveness probe is required: %s in %s", [container.name, input.metadata.name])
}

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.readinessProbe
  msg := sprintf("Readiness probe is required: %s in %s", [container.name, input.metadata.name])
}
