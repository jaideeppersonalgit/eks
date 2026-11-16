
#!/bin/bash
set -euo pipefail

AWS_REGION="${AWS_REGION:-ap-southeast-2}"
STACK_NAME="eks-lab"

echo "Deleting Kubernetes application..."

kubectl delete deployment eks-demo --ignore-not-found
kubectl delete service eks-demo-service --ignore-not-found

echo "Deleting ECR images..."

IMAGE_IDS=$(aws ecr list-images \
  --repository-name eks-demo \
  --region "$AWS_REGION" \
  --query 'imageIds[*]' \
  --output json)

if [ "$IMAGE_IDS" != "[]" ]; then
  aws ecr batch-delete-image \
    --repository-name eks-demo \
    --region "$AWS_REGION" \
    --image-ids "$IMAGE_IDS"
fi

echo "Deleting CloudFormation stack..."

aws cloudformation delete-stack \
  --stack-name "$STACK_NAME" \
  --region "$AWS_REGION"

aws cloudformation wait stack-delete-complete \
  --stack-name "$STACK_NAME" \
  --region "$AWS_REGION"

echo "EKS infrastructure deleted successfully!"
