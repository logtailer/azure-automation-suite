# 🚀 Deployment Guide

This guide provides step-by-step instructions to deploy the Azure DevOps platform from scratch.

## 📋 **Prerequisites**

### **Required Tools**
```bash
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install Terraform
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install Helm
curl https://get.helm.sh/helm-v3.13.0-linux-amd64.tar.gz | tar xz
sudo mv linux-amd64/helm /usr/local/bin/
```

### **Azure Setup**
```bash
# Login to Azure
az login

# Set your subscription (replace with your subscription ID)
az account set --subscription "your-subscription-id"

# Verify login
az account show
```

### **Environment Variables**
Create a `.env` file with your specific values:
```bash
# Copy the template
cp .env.example .env

# Edit with your values
export PROJECT_NAME="your-platform"
export ENVIRONMENT="dev"
export LOCATION="Central India"
export SUBSCRIPTION_ID="your-subscription-id"
```

---

## 🎯 **Deployment Options**

### **Option 1: One-Click Deployment (Recommended for Demo)**
```bash
# Clone the repository
git clone https://github.com/yourusername/azure-devops-platform
cd azure-devops-platform

# Make scripts executable
chmod +x scripts/*.sh

# Deploy everything
./scripts/deploy.sh dev
```

### **Option 2: Step-by-Step Deployment (Recommended for Learning)**
Follow the manual steps below for full understanding.

---

## 📚 **Step-by-Step Deployment**

### **Phase 1: Foundation Setup**

#### **Step 1: Deploy Backend Infrastructure**
```bash
cd terraform/01-foundation

# Initialize Terraform
terraform init

# Review the plan
terraform plan -var-file="dev.tfvars"

# Apply infrastructure
terraform apply -var-file="dev.tfvars"

# Note the outputs - you'll need these for other components
terraform output
```

**Expected Outputs:**
```
backend_resource_group_name = "rg-tfstate-dev"
backend_storage_account_name = "sttfstatedev12345678"
backend_container_name = "tfstate"
```

#### **Step 2: Configure Remote State**
Update backend configuration for all other components:
```bash
# Create backend config file
cat > backend.tfvars << EOF
resource_group_name  = "rg-tfstate-dev"
storage_account_name = "sttfstatedev12345678"  # Use actual output
container_name       = "tfstate"
EOF
```

### **Phase 2: Core Infrastructure**

#### **Step 3: Deploy Networking**
```bash
cd ../02-networking

# Initialize with remote backend
terraform init -backend-config="../backend.tfvars"

# Plan deployment
terraform plan \
  -var="project_name=azure-platform" \
  -var="environment=dev" \
  -var="location=Central India"

# Apply infrastructure
terraform apply \
  -var="project_name=azure-platform" \
  -var="environment=dev" \
  -var="location=Central India"

# Verify outputs
terraform output
```

**Expected Resources Created:**
- Virtual Network (10.0.0.0/16)
- 5 Subnets with proper CIDR blocks
- NAT Gateway with public IP
- Network Security Groups
- Route tables

#### **Step 4: Deploy Security Infrastructure**  
```bash
cd ../03-security

# Initialize with remote backend
terraform init -backend-config="../backend.tfvars"

# Plan deployment
terraform plan \
  -var="project_name=azure-platform" \
  -var="environment=dev"

# Apply infrastructure
terraform apply \
  -var="project_name=azure-platform" \
  -var="environment=dev"

# Get Key Vault name for later use
terraform output key_vault_name
```

**Expected Resources Created:**
- Azure Key Vault with network restrictions
- Log Analytics Workspace
- Azure Security Center configuration
- Azure Policy assignments

### **Phase 3: Container Platform**

#### **Step 5: Deploy AKS Cluster**
```bash
cd ../04-aks

# Initialize with remote backend
terraform init -backend-config="../backend.tfvars"

# Plan deployment (this will take 15-20 minutes)
terraform plan \
  -var="project_name=azure-platform" \
  -var="environment=dev" \
  -var="node_count=2"

# Apply infrastructure
terraform apply \
  -var="project_name=azure-platform" \
  -var="environment=dev" \
  -var="node_count=2"

# Get AKS credentials
az aks get-credentials \
  --resource-group "rg-azure-platform-dev" \
  --name "aks-azure-platform-dev" \
  --overwrite-existing

# Verify cluster access
kubectl get nodes
kubectl get namespaces
```

**Expected Output:**
```
NAME                                STATUS   ROLES   AGE   VERSION
aks-default-12345678-vmss000000    Ready    agent   5m    v1.28.3
aks-default-12345678-vmss000001    Ready    agent   5m    v1.28.3
```

### **Phase 4: Observability Stack**

#### **Step 6: Deploy Monitoring Infrastructure**
```bash
cd ../05-observability

# Initialize with remote backend  
terraform init -backend-config="../backend.tfvars"

# Deploy Azure Monitor resources
terraform apply \
  -var="project_name=azure-platform" \
  -var="environment=dev"
```

#### **Step 7: Install Prometheus & Grafana**
```bash
# Add Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Create monitoring namespace
kubectl create namespace monitoring

# Install Prometheus
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values kubernetes/monitoring/prometheus-values.yaml \
  --wait

# Install Grafana (if not included in stack)
helm install grafana grafana/grafana \
  --namespace monitoring \
  --values kubernetes/monitoring/grafana-values.yaml \
  --wait

# Get Grafana admin password
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode

# Port forward to access Grafana
kubectl port-forward --namespace monitoring svc/grafana 3000:80
```

### **Phase 5: CI/CD Pipeline**

#### **Step 8: Install ArgoCD**
```bash
# Create argocd namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for rollout
kubectl rollout status deployment/argocd-server -n argocd

# Get ArgoCD admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port forward to access ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

#### **Step 9: Configure ArgoCD Applications**
```bash
# Apply ArgoCD application configurations
kubectl apply -f kubernetes/argocd/applications/
```

### **Phase 6: Sample Applications**

#### **Step 10: Deploy Sample Applications**
```bash
# Deploy FastAPI application
kubectl apply -f kubernetes/apps/fastapi/

# Deploy React frontend
kubectl apply -f kubernetes/apps/react-frontend/

# Check deployments
kubectl get pods -n default
kubectl get services -n default
```

---

## 🔧 **Configuration & Customization**

### **Environment-Specific Variables**
Create environment-specific `.tfvars` files:

**dev.tfvars:**
```hcl
project_name = "azure-platform"
environment  = "dev"
location     = "Central India"
node_count   = 2
min_node_count = 1
max_node_count = 5
vm_size      = "Standard_D2s_v3"
```

**prod.tfvars:**
```hcl
project_name = "azure-platform"
environment  = "prod"
location     = "Central India"
node_count   = 3
min_node_count = 3
max_node_count = 20
vm_size      = "Standard_D4s_v3"
```

### **Scaling Configuration**
Modify auto-scaling parameters in `04-aks/variables.tf`:
```hcl
variable "enable_auto_scaling" {
  default = true
}

variable "min_count" {
  default = 2
}

variable "max_count" {
  default = 10
}
```

---

## ✅ **Verification Steps**

### **Infrastructure Verification**
```bash
# Check all resource groups
az group list --output table

# Verify AKS cluster
az aks show --resource-group rg-azure-platform-dev --name aks-azure-platform-dev

# Check Key Vault
az keyvault list --output table

# Verify networking
az network vnet list --output table
```

### **Kubernetes Verification**
```bash
# Check cluster info
kubectl cluster-info

# Verify nodes are ready
kubectl get nodes -o wide

# Check system pods
kubectl get pods --all-namespaces

# Verify ingress controller
kubectl get pods -n ingress-nginx

# Check monitoring stack
kubectl get pods -n monitoring
```

### **Application Verification**
```bash
# Check application pods
kubectl get pods -n default

# Verify services
kubectl get services -n default

# Check ingress routes
kubectl get ingress -n default

# Test application endpoints
curl http://your-app-endpoint/health
```

---

## 🚨 **Troubleshooting**

### **Common Issues**

#### **Terraform State Lock**
```bash
# If state is locked, force unlock (use with caution)
terraform force-unlock LOCK_ID

# Or delete the lock blob directly
az storage blob delete --account-name STORAGE_ACCOUNT --container-name tfstate --name default.tflock
```

#### **AKS Authentication Issues**
```bash
# Re-authenticate with AKS
az aks get-credentials --resource-group rg-azure-platform-dev --name aks-azure-platform-dev --overwrite-existing

# Check authentication
kubectl auth can-i get pods
```

#### **Pod Startup Issues**
```bash
# Check pod logs
kubectl logs <pod-name> -n <namespace>

# Describe pod for events
kubectl describe pod <pod-name> -n <namespace>

# Check resource usage
kubectl top pods -n <namespace>
```

#### **Network Connectivity Issues**
```bash
# Check NSG rules
az network nsg rule list --resource-group rg-azure-platform-dev --nsg-name nsg-aks-dev

# Test connectivity from pod
kubectl run test-pod --image=busybox --rm -it -- /bin/sh
# Inside pod: wget -qO- http://example.com
```

---

## 📊 **Post-Deployment Tasks**

### **Security Hardening**
```bash
# Enable Azure Security Center
az security pricing create --name VirtualMachines --tier Standard

# Configure Key Vault access policies
az keyvault set-policy --name <key-vault-name> \
  --object-id <service-principal-id> \
  --secret-permissions get list

# Enable diagnostic settings
az monitor diagnostic-settings create \
  --name "DiagnosticSettings" \
  --resource <resource-id> \
  --logs '[{"category": "AuditEvent", "enabled": true}]'
```

### **Monitoring Setup**
```bash
# Import Grafana dashboards
kubectl apply -f kubernetes/monitoring/dashboards/

# Configure alerting rules
kubectl apply -f kubernetes/monitoring/alerts/

# Set up notification channels
# (Configure in Grafana UI or via API)
```

### **Backup Configuration**
```bash
# Enable AKS backup (if supported in your region)
az aks backup enable --resource-group rg-azure-platform-dev --name aks-azure-platform-dev

# Configure persistent volume snapshots
kubectl apply -f kubernetes/backup/volume-snapshot-classes.yaml
```

---

## 💰 **Cost Optimization**

### **Immediate Actions**
```bash
# Enable cluster autoscaler
az aks update \
  --resource-group rg-azure-platform-dev \
  --name aks-azure-platform-dev \
  --enable-cluster-autoscaler \
  --min-count 1 \
  --max-count 5

# Configure auto-shutdown for dev environment
az vm auto-shutdown -g rg-azure-platform-dev -n vm-name --time 1800
```

### **Monitoring Costs**
```bash
# Set up cost alerts
az consumption budget create \
  --resource-group rg-azure-platform-dev \
  --budget-name "MonthlyBudget" \
  --amount 200 \
  --time-grain Monthly
```

---

## 🔄 **Cleanup**

### **Complete Cleanup**
```bash
# Run cleanup script
./scripts/cleanup.sh dev

# Or manual cleanup (in reverse order)
cd terraform/06-cicd && terraform destroy
cd ../05-observability && terraform destroy  
cd ../04-aks && terraform destroy
cd ../03-security && terraform destroy
cd ../02-networking && terraform destroy
cd ../01-foundation && terraform destroy
```

### **Selective Cleanup**
```bash
# Remove just applications
kubectl delete namespace default

# Remove monitoring
helm uninstall prometheus -n monitoring
helm uninstall grafana -n monitoring
kubectl delete namespace monitoring

# Remove ArgoCD
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl delete namespace argocd
```

---

## 📚 **Next Steps**

1. **Custom Applications**: Deploy your own applications
2. **Domain Setup**: Configure custom domains and SSL certificates  
3. **Multi-Environment**: Set up staging and production environments
4. **Advanced Monitoring**: Add custom metrics and alerting
5. **Security Scanning**: Integrate container and infrastructure scanning
6. **Backup & DR**: Implement backup and disaster recovery procedures

---

## 🆘 **Getting Help**

- **Documentation**: Check the `/docs` folder for detailed guides
- **Logs**: Use `kubectl logs` and Azure portal for troubleshooting
- **Community**: AKS and Terraform communities on GitHub
- **Support**: Azure support portal for cloud-specific issues

---

*This deployment typically takes 45-60 minutes end-to-end. The longest step is AKS cluster creation (15-20 minutes).*
