# Namespace for Actions Runner Controller
resource "kubernetes_namespace" "arc_system" {
  metadata {
    name = var.arc_namespace
  }

  depends_on = [azurerm_kubernetes_cluster.cicd]
}

# GitHub PAT secret for ARC
resource "kubernetes_secret" "github_pat" {
  metadata {
    name      = "github-pat"
    namespace = kubernetes_namespace.arc_system.metadata[0].name
  }

  data = {
    github_token = var.github_token
  }

  type = "Opaque"
}

# Actions Runner Controller Helm chart
resource "helm_release" "arc_controller" {
  name       = "arc"
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set-controller"
  version    = "0.9.0"
  namespace  = kubernetes_namespace.arc_system.metadata[0].name

  values = [
    yamlencode({
      # Controller configuration
      replicaCount = 1

      # Resource limits
      resources = {
        limits = {
          cpu    = "500m"
          memory = "512Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }
      }

      # Pod security context
      securityContext = {
        runAsNonRoot = true
        runAsUser    = 1000
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.arc_system,
    azurerm_kubernetes_cluster_node_pool.runners
  ]
}
