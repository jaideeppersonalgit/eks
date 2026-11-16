
#!/bin/bash
set -euo pipefail

AWS_REGION="${AWS_REGION:-ap-south-1}"
STACK_NAME="eks-lab"

MY_IP=$(curl -s https://checkip.amazonaws.com)

echo "Deploying EKS infrastructure..."

aws cloudformation deploy \
  --template-file cloudformation/eks-infrastructure.yaml \
  --stack-name "$STACK_NAME" \
  --region "$AWS_REGION" \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    ClusterName=eks-lab \
    AdminCidr="${MY_IP}/32" \
    NodeInstanceType=t3.small

echo "Infrastructure deployment completed!"

aws eks update-kubeconfig \
  --region "$AWS_REGION" \
  --name eks-lab

echo "Cluster endpoint:"
aws eks describe-cluster \
  --name eks-lab \
  --region "$AWS_REGION" \
  --query "cluster.endpoint" \
  --output text

echo "Check node readiness with kubectl get nodes"
