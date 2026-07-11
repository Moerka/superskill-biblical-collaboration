#!/bin/bash

# Superskill Kubernetes Deployment Script
# This script automates the deployment of Superskill to a Kubernetes cluster

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
NAMESPACE="superskill"
IMAGE_REGISTRY="moerka"
IMAGE_NAME="superskill-biblical-collaboration"
IMAGE_TAG="1.0.0"
KUBE_CONFIG="${KUBECONFIG:-~/.kube/config}"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v kubectl &> /dev/null; then
        log_error "kubectl is not installed. Please install kubectl."
        exit 1
    fi
    
    if ! command -v docker &> /dev/null; then
        log_warning "Docker is not installed. Skipping image build."
    fi
    
    log_success "Prerequisites check passed"
}

check_cluster_connection() {
    log_info "Checking Kubernetes cluster connection..."
    
    if ! kubectl cluster-info &> /dev/null; then
        log_error "Cannot connect to Kubernetes cluster. Check your KUBECONFIG."
        exit 1
    fi
    
    CLUSTER_NAME=$(kubectl config current-context)
    log_success "Connected to cluster: $CLUSTER_NAME"
}

build_image() {
    log_info "Building Docker image..."
    
    if ! command -v docker &> /dev/null; then
        log_warning "Docker not found. Skipping image build."
        return
    fi
    
    docker build -t ${IMAGE_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} .
    log_success "Docker image built: ${IMAGE_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
}

push_image() {
    log_info "Pushing Docker image to registry..."
    
    if ! command -v docker &> /dev/null; then
        log_warning "Docker not found. Skipping image push."
        return
    fi
    
    docker push ${IMAGE_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
    log_success "Docker image pushed"
}

create_namespace() {
    log_info "Creating namespace: $NAMESPACE"
    
    if kubectl get namespace $NAMESPACE &> /dev/null; then
        log_warning "Namespace $NAMESPACE already exists"
    else
        kubectl create namespace $NAMESPACE
        log_success "Namespace created"
    fi
}

deploy_manifests() {
    log_info "Deploying Kubernetes manifests..."
    
    if [ ! -f "k8s/deployment.yaml" ]; then
        log_error "k8s/deployment.yaml not found"
        exit 1
    fi
    
    kubectl apply -f k8s/deployment.yaml
    log_success "Deployment manifest applied"
    
    if [ -f "k8s/security.yaml" ]; then
        kubectl apply -f k8s/security.yaml
        log_success "Security manifest applied"
    fi
    
    if [ -f "k8s/jobs.yaml" ]; then
        kubectl apply -f k8s/jobs.yaml
        log_success "Jobs manifest applied"
    fi
}

configure_secrets() {
    log_info "Configuring secrets..."
    
    if kubectl get secret superskill-secrets -n $NAMESPACE &> /dev/null; then
        log_warning "Secret 'superskill-secrets' already exists"
        log_info "To update secrets, delete and recreate:"
        log_info "  kubectl delete secret superskill-secrets -n $NAMESPACE"
        log_info "  kubectl create secret generic superskill-secrets -n $NAMESPACE \\"
        log_info "    --from-literal=GITHUB_TOKEN=your-token \\"
        log_info "    --from-literal=GITHUB_APP_ID=your-app-id \\"
        log_info "    --from-literal=DATABASE_URL=your-db-url"
    else
        log_warning "Please create secrets manually:"
        log_info "kubectl create secret generic superskill-secrets -n $NAMESPACE \\"
        log_info "  --from-literal=GITHUB_TOKEN=your-token \\"
        log_info "  --from-literal=GITHUB_APP_ID=your-app-id \\"
        log_info "  --from-literal=DATABASE_URL=your-db-url \\"
        log_info "  --from-literal=REDIS_URL=your-redis-url"
    fi
}

wait_for_deployment() {
    log_info "Waiting for deployment to be ready (this may take a few minutes)..."
    
    kubectl wait --for=condition=available --timeout=300s \
        deployment/superskill-deployment -n $NAMESPACE
    
    log_success "Deployment is ready!"
}

show_deployment_info() {
    log_info "Deployment Information:"
    echo ""
    echo "Namespace: $NAMESPACE"
    echo ""
    echo "Pods:"
    kubectl get pods -n $NAMESPACE
    echo ""
    echo "Services:"
    kubectl get services -n $NAMESPACE
    echo ""
    echo "Accessing the service:"
    log_info "Port-forward to local machine:"
    echo "  kubectl port-forward -n $NAMESPACE svc/superskill-service 8000:8000"
    echo ""
    echo "View logs:"
    echo "  kubectl logs -n $NAMESPACE -l app=superskill -f"
    echo ""
}

cleanup() {
    log_warning "To clean up the deployment, run:"
    echo "  kubectl delete namespace $NAMESPACE"
}

# Main execution
main() {
    log_info "Starting Superskill Kubernetes Deployment"
    echo ""
    
    check_prerequisites
    check_cluster_connection
    
    read -p "Build and push Docker image? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        build_image
        push_image
    fi
    
    create_namespace
    deploy_manifests
    configure_secrets
    wait_for_deployment
    show_deployment_info
    
    log_success "Deployment completed successfully!"
    echo ""
    cleanup
}

# Run main function
main "$@"
