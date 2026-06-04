# =============================================================================
# OPA Policy: Require Security Context
# =============================================================================
package kubernetes.admission

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.securityContext
  msg := sprintf("Container '%v' in Deployment '%v' is missing a securityContext configuration.", [container.name, input.metadata.name])
}

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  securityContext := container.securityContext
  securityContext.allowPrivilegeEscalation != false
  msg := sprintf("Container '%v' in Deployment '%v' must set allowPrivilegeEscalation to false.", [container.name, input.metadata.name])
}

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  securityContext := container.securityContext
  securityContext.readOnlyRootFilesystem != true
  msg := sprintf("Container '%v' in Deployment '%v' must run with a readOnlyRootFilesystem set to true.", [container.name, input.metadata.name])
}
