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

# Service account for runner pods
resource "kubernetes_service_account" "arc_runner" {
  metadata {
    name      = "arc-runner-sa"
    namespace = kubernetes_namespace.arc_system.metadata[0].name
  }

  depends_on = [kubernetes_namespace.arc_system]
}

# Runner scale set for repository-level runners
resource "helm_release" "arc_runner_set" {
  name       = var.runner_scale_set_name
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set"
  version    = "0.9.0"
  namespace  = kubernetes_namespace.arc_system.metadata[0].name

  values = [
    yamlencode({
      # GitHub configuration (repository-level for personal GitHub)
      githubConfigUrl = "https://github.com/${var.github_repository_owner}/${var.github_repository_name}"
      githubConfigSecret = {
        github_token = var.github_token
      }

      # Scaling configuration
      minRunners = var.runner_min_replicas # 0
      maxRunners = var.runner_max_replicas # 5

      # Runner configuration
      runnerScaleSetName = var.runner_scale_set_name

      # Container mode with Docker-in-Docker
      containerMode = {
        type = "dind" # Docker-in-Docker
      }

      # Template for runner pods
      template = {
        spec = {
          # Schedule on runner nodes only
          nodeSelector = {
            workload = "github-runners"
          }

          tolerations = [{
            key      = "workload"
            operator = "Equal"
            value    = "github-runners"
            effect   = "NoSchedule"
          }]

          # Runner container
          containers = [{
            name  = "runner"
            image = "ghcr.io/actions/actions-runner:latest"

            resources = {
              limits = {
                cpu    = "2000m"
                memory = "4Gi"
              }
              requests = {
                cpu    = "1000m"
                memory = "2Gi"
              }
            }

            # Environment variables
            env = [{
              name  = "RUNNER_LABELS"
              value = "self-hosted,aks,azure"
            }]
          }]

          # Service account
          serviceAccountName = "arc-runner-sa"
        }
      }

      # Listener configuration for webhook-based scaling
      listenerTemplate = {
        spec = {
          containers = [{
            name = "listener"
            resources = {
              limits = {
                cpu    = "200m"
                memory = "256Mi"
              }
              requests = {
                cpu    = "100m"
                memory = "128Mi"
              }
            }
          }]
        }
      }

      # Controller service account
      controllerServiceAccount = {
        name      = "arc-controller-sa"
        namespace = var.arc_namespace
      }
    })
  ]

  depends_on = [
    helm_release.arc_controller,
    kubernetes_secret.github_pat,
    kubernetes_service_account.arc_runner
  ]
}
