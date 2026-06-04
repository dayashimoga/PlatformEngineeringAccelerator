# =============================================================================
# OPA Policy: Require Resource Limits
# =============================================================================
package kubernetes.admission

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.resources.limits.cpu
  msg := sprintf("CPU limits are required: %s in %s", [container.name, input.metadata.name])
}

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.resources.limits.memory
  msg := sprintf("Memory limits are required: %s in %s", [container.name, input.metadata.name])
}

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.resources.requests.cpu
  msg := sprintf("CPU requests are required: %s in %s", [container.name, input.metadata.name])
}

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.resources.requests.memory
  msg := sprintf("Memory requests are required: %s in %s", [container.name, input.metadata.name])
}
