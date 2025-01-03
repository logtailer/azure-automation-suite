#!/bin/bash

# 🚀 Azure DevOps Platform - One-Click Deployment Script
# This script deploys the entire platform infrastructure

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
ENVIRONMENT=${1:-"dev"}
PROJECT_NAME=${2:-"azure-platform"}
LOCATION=${3:-"Central India"}

# Display banner
echo -e "${BLUE}"
cat << "EOF"
  _                        ____             ___            
 / \    _____   _ _ __ ___ |  _ \  _____   _/ _ \ _ __  ___  
/ _ \  |_  / | | | '__/ _ \| | | |/ _ \ \ / / | | | '_ \/ __| 
/ ___ \  / /| |_| | | |  __/ |_| |  __/\ V /| |_| | |_) \__ \ 
/_/   \_\/___|\__,_|_|  \___|____/ \___| \_/  \___/| .__/|___/ 
                                                    |_|        
    Platform Deployment Script
EOF
echo -e "${NC}"

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if Azure CLI is installed and logged in
    if ! command -v az &> /dev/null; then
        print_error "Azure CLI is not installed. Please install it first."
        exit 1
    fi
    
    # Check if logged into Azure
    if ! az account show &> /dev/null; then
        print_error "Please login to Azure CLI first: az login"
        exit 1
    fi
    
    # Check if Terraform is installed
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed. Please install it first."
        exit 1
    fi
    
    # Check if kubectl is installed
    if ! command -v kubectl &> /dev/null; then
        print_warning "kubectl is not installed. You'll need it to manage the AKS cluster."
    fi
    
    print_success "Prerequisites check passed"
}

# Function to display current Azure context
show_azure_context() {
    print_status "Current Azure context:"
    SUBSCRIPTION=$(az account show --query 'name' -o tsv)
    TENANT=$(az account show --query 'tenantId' -o tsv)
    USER=$(az account show --query 'user.name' -o tsv)
    
    echo "  Subscription: $SUBSCRIPTION"
    echo "  Tenant: $TENANT"
    echo "  User: $USER"
    echo
}

# Function to deploy a terraform component
deploy_terraform_component() {
    local component_path=$1
    local component_name=$2
    
    print_status "Deploying $component_name..."
    
    cd "$component_path"
    
    # Initialize Terraform
    if [ "$component_name" == "Foundation" ]; then
        terraform init
    else
        terraform init -backend-config="../backend.tfvars"
    fi
    
    # Plan and apply
    terraform plan \
        -var="project_name=$PROJECT_NAME" \
        -var="environment=$ENVIRONMENT" \
        -var="location=$LOCATION" \
        -out=tfplan
    
    terraform apply tfplan
    
    print_success "$component_name deployed successfully"
    cd - > /dev/null
}

# Function to install Kubernetes components
install_k8s_components() {
    print_status "Installing Kubernetes components..."
    
    # Get AKS credentials
    RESOURCE_GROUP="rg-${PROJECT_NAME}-${ENVIRONMENT}"
    CLUSTER_NAME="aks-${PROJECT_NAME}-${ENVIRONMENT}"
    
    print_status "Getting AKS credentials..."
    az aks get-credentials --resource-group "$RESOURCE_GROUP" --name "$CLUSTER_NAME" --overwrite-existing
    
    # Wait for nodes to be ready
    print_status "Waiting for nodes to be ready..."
    kubectl wait --for=condition=Ready nodes --all --timeout=600s
    
    # Install Helm if not present
    if ! command -v helm &> /dev/null; then
        print_status "Installing Helm..."
        curl https://get.helm.sh/helm-v3.13.0-linux-amd64.tar.gz | tar xz
        sudo mv linux-amd64/helm /usr/local/bin/
    fi
    
    # Add Helm repositories
    print_status "Adding Helm repositories..."
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    
    # Create namespaces
    print_status "Creating namespaces..."
    kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
    kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
    kubectl create namespace ingress-nginx --dry-run=client -o yaml | kubectl apply -f -
    
    # Install NGINX Ingress Controller
    print_status "Installing NGINX Ingress Controller..."
    helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
        --namespace ingress-nginx \
        --set controller.service.type=LoadBalancer \
        --wait
    
    # Install Prometheus and Grafana
    print_status "Installing Prometheus and Grafana..."
    helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
        --namespace monitoring \
        --set grafana.adminPassword=admin123 \
        --set prometheus.prometheusSpec.retention=30d \
        --wait
    
    # Install ArgoCD
    print_status "Installing ArgoCD..."
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    
    # Wait for ArgoCD to be ready
    kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd
    
    print_success "Kubernetes components installed successfully"
}

# Function to deploy sample applications
deploy_sample_apps() {
    print_status "Deploying sample applications..."
    
    # Create sample FastAPI application
    kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fastapi-app
  labels:
    app: fastapi-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: fastapi-app
  template:
    metadata:
      labels:
        app: fastapi-app
    spec:
      containers:
      - name: fastapi
        image: tiangolo/uvicorn-gunicorn-fastapi:python3.9
        ports:
        - containerPort: 80
        env:
        - name: MODULE_NAME
          value: "main"
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
---
apiVersion: v1
kind: Service
metadata:
  name: fastapi-service
spec:
  selector:
    app: fastapi-app
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: fastapi-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  - http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: fastapi-service
            port:
              number: 80
EOF
    
    print_success "Sample applications deployed"
}

# Function to display access information
show_access_info() {
    print_success "Deployment completed successfully!"
    echo
    echo -e "${BLUE}=== Access Information ===${NC}"
    
    # Get ingress IP
    INGRESS_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    if [ -z "$INGRESS_IP" ]; then
        INGRESS_IP="<pending>"
        print_warning "Ingress IP is still pending. Check again in a few minutes."
    fi
    
    echo "🌐 Application URL: http://$INGRESS_IP/api"
    echo
    
    echo "📊 Monitoring Access:"
    echo "   Grafana: kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80"
    echo "   Username: admin"
    echo "   Password: admin123"
    echo
    
    echo "🚀 ArgoCD Access:"
    echo "   ArgoCD: kubectl port-forward svc/argocd-server -n argocd 8080:443"
    echo "   Username: admin"
    ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d 2>/dev/null || echo "admin")
    echo "   Password: $ARGOCD_PASSWORD"
    echo
    
    echo "☸️  Kubernetes Access:"
    echo "   kubectl get nodes"
    echo "   kubectl get pods --all-namespaces"
    echo
    
    echo -e "${BLUE}=== Next Steps ===${NC}"
    echo "1. Access Grafana dashboards for monitoring"
    echo "2. Configure ArgoCD applications for GitOps"
    echo "3. Deploy your own applications"
    echo "4. Set up custom domains and SSL certificates"
    echo
    
    echo -e "${YELLOW}💰 Cost Information:${NC}"
    echo "   Estimated monthly cost: \$150-300 (depending on usage)"
    echo "   To reduce costs:"
    echo "   - Scale down nodes: kubectl scale deployment --replicas=1"
    echo "   - Use spot instances for non-critical workloads"
    echo "   - Enable cluster autoscaler"
    echo
}

# Function to handle cleanup on failure
cleanup_on_failure() {
    print_error "Deployment failed. Starting cleanup..."
    
    if [ -d "terraform/04-aks" ] && [ -f "terraform/04-aks/terraform.tfstate" ]; then
        print_status "Cleaning up AKS resources..."
        cd terraform/04-aks
        terraform destroy -auto-approve \
            -var="project_name=$PROJECT_NAME" \
            -var="environment=$ENVIRONMENT" \
            -var="location=$LOCATION" 2>/dev/null || true
        cd - > /dev/null
    fi
    
    print_error "Please run './scripts/cleanup.sh $ENVIRONMENT' to clean up remaining resources"
    exit 1
}

# Main deployment function
main() {
    # Trap errors and cleanup
    trap cleanup_on_failure ERR
    
    echo -e "${BLUE}Starting deployment with the following parameters:${NC}"
    echo "  Environment: $ENVIRONMENT"
    echo "  Project Name: $PROJECT_NAME"
    echo "  Location: $LOCATION"
    echo
    
    # Ask for confirmation
    read -p "Do you want to proceed? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Deployment cancelled"
        exit 0
    fi
    
    # Start timer
    START_TIME=$(date +%s)
    
    check_prerequisites
    show_azure_context
    
    # Phase 1: Foundation
    deploy_terraform_component "terraform/01-foundation" "Foundation"
    
    # Create backend config for other components
    print_status "Creating backend configuration..."
    cd terraform/01-foundation
    BACKEND_RG=$(terraform output -raw backend_resource_group_name)
    BACKEND_SA=$(terraform output -raw backend_storage_account_name)
    cd - > /dev/null
    
    cat > terraform/backend.tfvars << EOF
resource_group_name  = "$BACKEND_RG"
storage_account_name = "$BACKEND_SA"
container_name       = "tfstate"
EOF
    
    # Phase 2: Infrastructure
    deploy_terraform_component "terraform/02-networking" "Networking"
    deploy_terraform_component "terraform/03-security" "Security"
    deploy_terraform_component "terraform/04-aks" "AKS Cluster"
    deploy_terraform_component "terraform/05-observability" "Observability"
    
    # Phase 3: Kubernetes Components
    install_k8s_components
    
    # Phase 4: Sample Applications
    deploy_sample_apps
    
    # Calculate deployment time
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    MINUTES=$((DURATION / 60))
    SECONDS=$((DURATION % 60))
    
    print_success "Total deployment time: ${MINUTES}m ${SECONDS}s"
    
    # Show access information
    show_access_info
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
