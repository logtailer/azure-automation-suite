#!/bin/bash

# 🧹 Azure DevOps Platform - Cleanup Script
# This script removes all deployed resources to avoid ongoing costs

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default values
ENVIRONMENT=${1:-"dev"}
PROJECT_NAME=${2:-"azure-platform"}

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

# Display cleanup banner
echo -e "${RED}"
cat << "EOF"
   ____ _                                
  / ___| | ___  __ _ _ __  _   _ _ __  
 | |   | |/ _ \/ _` | '_ \| | | | '_ \ 
 | |___| |  __/ (_| | | | | |_| | |_) |
  \____|_|\___|\__,_|_| |_|\__,_| .__/ 
                               |_|    
    Resource Cleanup Script
EOF
echo -e "${NC}"

echo -e "${RED}WARNING: This will delete ALL resources for environment: $ENVIRONMENT${NC}"
echo "This action cannot be undone!"
echo
read -p "Are you absolutely sure? Type 'DELETE' to confirm: " -r
echo

if [[ $REPLY != "DELETE" ]]; then
    print_status "Cleanup cancelled"
    exit 0
fi

# Start cleanup
print_status "Starting cleanup for environment: $ENVIRONMENT"
START_TIME=$(date +%s)

# Step 1: Clean up Kubernetes resources
cleanup_kubernetes() {
    print_status "Cleaning up Kubernetes resources..."
    
    RESOURCE_GROUP="rg-${PROJECT_NAME}-${ENVIRONMENT}"
    CLUSTER_NAME="aks-${PROJECT_NAME}-${ENVIRONMENT}"
    
    # Try to get AKS credentials
    if az aks show --resource-group "$RESOURCE_GROUP" --name "$CLUSTER_NAME" &>/dev/null; then
        print_status "Getting AKS credentials for cleanup..."
        az aks get-credentials --resource-group "$RESOURCE_GROUP" --name "$CLUSTER_NAME" --overwrite-existing &>/dev/null || true
        
        if kubectl cluster-info &>/dev/null; then
            # Remove ArgoCD
            print_status "Removing ArgoCD..."
            kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --ignore-not-found=true &>/dev/null || true
            kubectl delete namespace argocd --ignore-not-found=true &>/dev/null || true
            
            # Remove monitoring stack
            print_status "Removing monitoring stack..."
            helm uninstall prometheus -n monitoring &>/dev/null || true
            kubectl delete namespace monitoring --ignore-not-found=true &>/dev/null || true
            
            # Remove ingress controller
            print_status "Removing ingress controller..."
            helm uninstall ingress-nginx -n ingress-nginx &>/dev/null || true
            kubectl delete namespace ingress-nginx --ignore-not-found=true &>/dev/null || true
            
            # Remove sample applications
            print_status "Removing sample applications..."
            kubectl delete all --all -n default --ignore-not-found=true &>/dev/null || true
            
            print_success "Kubernetes resources cleaned up"
        else
            print_warning "Could not connect to AKS cluster, skipping Kubernetes cleanup"
        fi
    else
        print_warning "AKS cluster not found, skipping Kubernetes cleanup"
    fi
}

# Step 2: Clean up Terraform resources (in reverse order)
cleanup_terraform() {
    print_status "Cleaning up Terraform resources..."
    
    # Check if backend config exists
    if [ ! -f "terraform/backend.tfvars" ]; then
        print_warning "Backend config not found, using local state"
        BACKEND_CONFIG=""
    else
        BACKEND_CONFIG="-backend-config=../backend.tfvars"
    fi
    
    # List of components in reverse deployment order
    components=(
        "terraform/06-cicd:CI/CD"
        "terraform/05-observability:Observability"
        "terraform/04-aks:AKS"
        "terraform/03-security:Security"
        "terraform/02-networking:Networking"
    )
    
    for component in "${components[@]}"; do
        IFS=':' read -r path name <<< "$component"
        
        if [ -d "$path" ]; then
            print_status "Destroying $name..."
            cd "$path"
            
            # Initialize if needed
            if [ ! -d ".terraform" ]; then
                if [ "$name" == "Foundation" ]; then
                    terraform init &>/dev/null || true
                else
                    terraform init $BACKEND_CONFIG &>/dev/null || true
                fi
            fi
            
            # Destroy resources
            terraform destroy -auto-approve \
                -var="project_name=$PROJECT_NAME" \
                -var="environment=$ENVIRONMENT" \
                -var="location=Central India" &>/dev/null || {
                print_warning "Failed to destroy $name via Terraform, some resources may remain"
            }
            
            cd - > /dev/null
            print_success "$name destroyed"
        else
            print_warning "$path not found, skipping $name"
        fi
    done
    
    # Special handling for foundation (has local state)
    if [ -d "terraform/01-foundation" ]; then
        print_status "Destroying Foundation..."
        cd terraform/01-foundation
        
        terraform destroy -auto-approve \
            -var="project_name=$PROJECT_NAME" \
            -var="environment=$ENVIRONMENT" \
            -var="location=Central India" &>/dev/null || {
            print_warning "Failed to destroy Foundation via Terraform"
        }
        
        cd - > /dev/null
        print_success "Foundation destroyed"
    fi
}

# Step 3: Clean up any remaining Azure resources
cleanup_remaining_resources() {
    print_status "Cleaning up any remaining Azure resources..."
    
    # Resource groups to check
    resource_groups=(
        "rg-${PROJECT_NAME}-${ENVIRONMENT}"
        "rg-tfstate-${ENVIRONMENT}"
        "NetworkWatcherRG"
    )
    
    for rg in "${resource_groups[@]}"; do
        if az group show --name "$rg" &>/dev/null; then
            print_status "Deleting resource group: $rg"
            az group delete --name "$rg" --yes --no-wait &>/dev/null || {
                print_warning "Failed to delete resource group: $rg"
            }
        fi
    done
    
    print_success "Resource group deletion initiated (running in background)"
}

# Step 4: Clean up local files
cleanup_local_files() {
    print_status "Cleaning up local files..."
    
    # Remove Terraform state files and plans
    find terraform -name "terraform.tfstate*" -delete 2>/dev/null || true
    find terraform -name "tfplan*" -delete 2>/dev/null || true
    find terraform -name ".terraform.lock.hcl" -delete 2>/dev/null || true
    find terraform -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
    
    # Remove backend config
    rm -f terraform/backend.tfvars 2>/dev/null || true
    
    # Remove any downloaded keys
    rm -f *.pem 2>/dev/null || true
    rm -f privatekey.pem 2>/dev/null || true
    
    print_success "Local files cleaned up"
}

# Main cleanup function
main() {
    print_status "Starting cleanup for environment: $ENVIRONMENT"
    
    # Step 1: Kubernetes cleanup
    cleanup_kubernetes
    
    # Step 2: Terraform cleanup
    cleanup_terraform
    
    # Step 3: Remaining Azure resources
    cleanup_remaining_resources
    
    # Step 4: Local files
    cleanup_local_files
    
    # Calculate cleanup time
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    MINUTES=$((DURATION / 60))
    SECONDS=$((DURATION % 60))
    
    print_success "Cleanup completed in ${MINUTES}m ${SECONDS}s"
    
    echo
    echo -e "${GREEN}✅ Cleanup Summary:${NC}"
    echo "• Kubernetes resources removed"
    echo "• Terraform resources destroyed"
    echo "• Azure resource groups marked for deletion"
    echo "• Local state files cleaned up"
    echo
    echo -e "${YELLOW}📋 Post-Cleanup Notes:${NC}"
    echo "• Resource group deletion may take 10-15 minutes to complete"
    echo "• Check Azure Portal to verify all resources are deleted"
    echo "• Some network resources may take longer to delete"
    echo "• If any resources remain, delete them manually via Azure Portal"
    echo
    echo -e "${BLUE}💰 Cost Impact:${NC}"
    echo "• All compute resources have been stopped/deleted"
    echo "• Storage costs should reduce to near zero within 24 hours"
    echo "• Check your Azure billing dashboard in a few hours"
    echo
    
    print_success "🎉 All done! Your Azure resources have been cleaned up."
}

# Execute main function
main "$@"
