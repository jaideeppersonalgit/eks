
#!/bin/bash
set -euo pipefail

AWS_REGION="${AWS_REGION:-ap-south-1}"
STACK_NAME="eks-lab"

echo "Getting ECR repository..."

ECR_URI=$(aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --region "$AWS_REGION" \
  --query "Stacks[0].Outputs[?OutputKey=='EcrRepositoryUri'].OutputValue" \
  --output text)

ACCOUNT_ID=$(aws sts get-caller-identity \
  --query Account --output text)

echo "Logging into ECR..."

aws ecr get-login-password --region "$AWS_REGION" | \
docker login --username AWS --password-stdin \
"$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

echo "Building Docker image..."

docker build --platform linux/amd64 \
  -t eks-demo:1.0 ./app

echo "Tagging Docker image..."

docker tag eks-demo:1.0 "$ECR_URI:1.0"

echo "Pushing image to ECR..."

docker push "$ECR_URI:1.0"

echo "Deploying application to EKS..."

export IMAGE_URI="$ECR_URI:1.0"

envsubst '${IMAGE_URI}' < kubernetes/deployment.yaml | \
kubectl apply -f -

echo "Waiting for deployment..."

kubectl rollout status deployment/eks-demo

echo "Deployment completed!"

kubectl get pods -o wide
kubectl get services
