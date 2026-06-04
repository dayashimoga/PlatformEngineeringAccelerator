# =============================================================================
# OPA Policy: Require Standard Labels
# =============================================================================
package kubernetes.admission

required_labels := {
  "app.kubernetes.io/name",
  "app.kubernetes.io/version",
}

deny[msg] {
  input.kind == "Deployment"
  label := required_labels[_]
  not input.metadata.labels[label]
  msg := sprintf("Required label '%s' is missing on %s", [label, input.metadata.name])
}

deny[msg] {
  input.kind == "Deployment"
  label := required_labels[_]
  not input.spec.template.metadata.labels[label]
  msg := sprintf("Required label '%s' is missing on pod template of %s", [label, input.metadata.name])
}
