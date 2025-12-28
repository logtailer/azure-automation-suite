terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# ArgoCD Namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      "pod-security.kubernetes.io/enforce" = "baseline"
      "pod-security.kubernetes.io/audit"   = "baseline"
      "pod-security.kubernetes.io/warn"    = "baseline"
    }
  }
}

# ArgoCD Installation via Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.6"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [
    yamlencode({
      global = {
        domain = var.argocd_domain
      }
      
      server = {
        service = {
          type = "LoadBalancer"
          annotations = {
            "service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" = "/healthz"
          }
        }
        
        config = {
          "application.instanceLabelKey" = "argocd.argoproj.io/instance"
          "server.rbac.policy.default"   = "role:readonly"
          "server.rbac.policy.csv" = <<-EOT
            p, role:admin, applications, *, */*, allow
            p, role:admin, certificates, *, *, allow
            p, role:admin, clusters, *, *, allow
            p, role:admin, repositories, *, *, allow
            g, argocd-admin, role:admin
          EOT
        }
      }
      
      repoServer = {
        replicas = 2
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
      
      applicationSet = {
        enabled = true
      }
      
      notifications = {
        enabled = true
        argocdUrl = "https://${var.argocd_domain}"
      }
    })
  ]

  depends_on = [kubernetes_namespace.argocd]
}

# ArgoCD Projects for different environments
resource "kubernetes_manifest" "app_project_production" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "AppProject"
    metadata = {
      name      = "production"
      namespace = kubernetes_namespace.argocd.metadata[0].name
    }
    spec = {
      description = "Production applications"
      sourceRepos = ["*"]
      destinations = [
        {
          namespace = "production"
          server    = "https://kubernetes.default.svc"
        }
      ]
      clusterResourceWhitelist = [
        {
          group = ""
          kind  = "Namespace"
        }
      ]
      namespaceResourceWhitelist = [
        {
          group = ""
          kind  = "*"
        },
        {
          group = "apps"
          kind  = "*"
        },
        {
          group = "networking.k8s.io"
          kind  = "*"
        }
      ]
    }
  }
  
  depends_on = [helm_release.argocd]
}
