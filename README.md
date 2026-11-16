
# AWS EKS End-to-End Deployment

## Project Overview

This project demonstrates end-to-end deployment
of a containerized application on AWS EKS.

## Technologies

- AWS CloudFormation
- Amazon EKS
- Amazon EC2
- Amazon VPC
- IAM
- Amazon ECR
- Docker
- Kubernetes
- GitHub

## Architecture

CloudFormation provisions:

- VPC and networking
- Internet Gateway
- Public Subnets
- IAM Roles
- EKS Cluster
- Managed Node Group
- ECR Repository

## Deployment Steps

### 1. Deploy Infrastructure

./scripts/deploy-infra.sh

### 2. Configure Kubernetes Access

aws eks update-kubeconfig \
  --region ap-south-1 \
  --name eks-lab

Configure the EKS access entry as described
in the deployment instructions.

### 3. Deploy Application

./scripts/deploy-app.sh

### 4. Verify Deployment

kubectl get nodes
kubectl get pods
kubectl get deployments
kubectl get services

### 5. Access Application

kubectl port-forward service/eks-demo-service 8080:80

Open http://localhost:8080

### 6. Cleanup

./scripts/cleanup.sh

## Application

Custom Nginx application running inside
a Kubernetes pod on AWS EKS.
