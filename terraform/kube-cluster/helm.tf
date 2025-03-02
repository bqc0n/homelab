resource "helm_release" "victoria-metrics-operator" {
  chart = "oci://ghcr.io/victoriametrics/helm-charts/victoria-metrics-operator"
  name  = "vmo"
  namespace = "dash"
  values = [file("vmo_values.yaml")]
}

resource "helm_release" "victoria-metrics-k8s-stack" {
  chart = "oci://ghcr.io/victoriametrics/helm-charts/victoria-metrics-k8s-stack "
  name  = "vmks"
  namespace = "dash"
  values = [file("vm_k8s_stack_values.yaml")]
}