# Network Security Policies for AKS

# Network Policy to restrict traffic between namespaces
resource "kubernetes_network_policy" "deny_all_ingress" {
  metadata {
    name      = "deny-all-ingress"
    namespace = "default"
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress"]
  }

  depends_on = [azurerm_kubernetes_cluster.cluster]
}

# Allow ingress from same namespace
resource "kubernetes_network_policy" "allow_same_namespace" {
  metadata {
    name      = "allow-same-namespace"
    namespace = "default"
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress"]

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "default"
          }
        }
      }
    }
  }

  depends_on = [azurerm_kubernetes_cluster.cluster]
}

# Allow traffic from system namespaces
resource "kubernetes_network_policy" "allow_system_ingress" {
  metadata {
    name      = "allow-system-ingress" 
    namespace = "default"
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress"]

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "kube-system"
          }
        }
      }
    }

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "gatekeeper-system"
          }
        }
      }
    }
  }

  depends_on = [azurerm_kubernetes_cluster.cluster]
}
