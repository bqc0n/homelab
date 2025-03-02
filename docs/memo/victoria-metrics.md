# VM

### Grafana Operator

VMでも使えるし、せっかくだからインストール

```yaml
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: grafana-operator
spec:
  destination:
    namespace: dash
    server: https://kubernetes.default.svc
  source:
    repoURL: ghcr.io/grafana/helm-charts
    targetRevision: v5.16.0
    chart: grafana-operator
  project: default
  syncPolicy:
    automated:
      prune: false
      selfHeal: false
    syncOptions:
      - ServerSideApply=true
      - CreateNamespace=true
```

### Victoria Metrics

terraformで入れる。
CRDがないとvmksがエラーになるので2回実行する。

```terraform
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
```

#### Datasource

`grafana.enabled: false`にしてExternally managed Grafanaを使う場合、`grafana.forceDeployDatasource`を`true`にしないとデフォルトDatasourceがデプロイされない。
([`datasource.yaml`](https://github.com/VictoriaMetrics/helm-charts/blob/master/charts/victoria-metrics-k8s-stack/templates/grafana/datasource.yaml))