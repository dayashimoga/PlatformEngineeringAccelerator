# =============================================================================
# OPA Policy: Deny :latest Tag
# =============================================================================
package kubernetes.admission

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  endswith(container.image, ":latest")
  msg := sprintf("Using :latest tag is not allowed: %s in %s (image: %s)", [container.name, input.metadata.name, container.image])
}

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not contains(container.image, ":")
  msg := sprintf("Image must have an explicit tag: %s in %s (image: %s)", [container.name, input.metadata.name, container.image])
}
