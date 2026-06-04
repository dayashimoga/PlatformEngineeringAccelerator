# =============================================================================
# OPA Policy: Deny Privileged Containers
# =============================================================================
package kubernetes.admission

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  container.securityContext.privileged == true
  msg := sprintf("Privileged containers are not allowed: %s in %s", [container.name, input.metadata.name])
}

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  container.securityContext.allowPrivilegeEscalation == true
  msg := sprintf("Privilege escalation is not allowed: %s in %s", [container.name, input.metadata.name])
}

deny[msg] {
  input.kind == "Deployment"
  not input.spec.template.spec.securityContext.runAsNonRoot
  msg := sprintf("Containers must run as non-root: %s", [input.metadata.name])
}
