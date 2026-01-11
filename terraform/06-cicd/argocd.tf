# Namespace for ArgoCD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
  }

  depends_on = [azurerm_kubernetes_cluster.cicd]
}

# ArgoCD Helm release
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [
    yamlencode({
      # Server configuration
      server = {
        # Expose via LoadBalancer for external access
        service = {
          type = "LoadBalancer"
          annotations = {
            "service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" = "/healthz"
          }
        }

        # Ingress disabled (using LoadBalancer)
        ingress = {
          enabled = false
        }

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
      }

      # Application controller configuration
      controller = {
        resources = {
          limits = {
            cpu    = "1000m"
            memory = "1Gi"
          }
          requests = {
            cpu    = "250m"
            memory = "256Mi"
          }
        }
      }

      # Repo server configuration
      repoServer = {
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
      }

      # Redis configuration
      redis = {
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
      }

      # Global configuration
      global = {
        # Pod security context
        securityContext = {
          runAsNonRoot = true
          runAsUser    = 999
        }
      }

      # Configure default projects
      configs = {
        params = {
          "application.instanceLabelKey" = "argocd.argoproj.io/instance"
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.argocd,
    azurerm_kubernetes_cluster_node_pool.runners
  ]
}

# Data source to get ArgoCD LoadBalancer IP
data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  depends_on = [helm_release.argocd]
}

# Data source to get ArgoCD admin password
data "kubernetes_secret" "argocd_admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  depends_on = [helm_release.argocd]
}
