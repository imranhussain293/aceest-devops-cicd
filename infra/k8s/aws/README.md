# AWS EKS deploy

These manifests are for the production-like cloud deployment required by the assignment.

## Prerequisites

- Docker Desktop running
- `kubectl` installed
- `eksctl` installed
- An EKS cluster with `kubectl` context configured
- An ECR repository named `aceest-fitness`
- AWS credentials configured under `C:\Users\<you>\.aws`

If AWS CLI is not installed locally, the helper script uses the official
`amazon/aws-cli` Docker image and mounts your local `.aws` folder.

Configure credentials without sharing secrets in the repository or chat:

```powershell
mkdir $env:USERPROFILE\.aws
notepad $env:USERPROFILE\.aws\credentials
notepad $env:USERPROFILE\.aws\config
```

Example `credentials` file:

```ini
[default]
aws_access_key_id = YOUR_ACCESS_KEY_ID
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY
```

Example `config` file:

```ini
[default]
region = ap-south-1
output = json
```

Verify identity:

```powershell
docker run --rm -v "$env:USERPROFILE\.aws:/root/.aws" amazon/aws-cli sts get-caller-identity
```

## Create EKS cluster

```powershell
eksctl create cluster -f infra/aws/eksctl-cluster.yaml
aws eks update-kubeconfig --region ap-south-1 --name aceest-eks
kubectl get nodes
```

## Build and push image to ECR

```powershell
.\scripts\aws\build-and-push-ecr.ps1 `
  -AwsRegion ap-south-1 `
  -RepositoryName aceest-fitness `
  -ImageTag v0.1.0
```

The script prints the full ECR image URI. Replace `IMAGE_URI_PLACEHOLDER` in
`deployment.yaml` with that URI before applying the manifests.

Example:

```powershell
.\scripts\aws\update-eks-image.ps1 `
  -ImageUri '123456789012.dkr.ecr.ap-south-1.amazonaws.com/aceest-fitness:v0.1.0'
```

The deployment uses a rolling update strategy and `imagePullPolicy: Always`, so
subsequent pushes with a new tag can be promoted by re-running the update plus
`kubectl rollout status deployment/aceest-fitness`.

## Deploy to EKS

```powershell
kubectl config current-context
.\scripts\aws\deploy-eks.ps1
```

If your cluster uses a load balancer, wait for the external endpoint and then
hit `/health` on the service URL.

## Rollout and rollback

```powershell
# Restart pods after publishing a new image tag
kubectl rollout restart deployment/aceest-fitness

# View rollout history
kubectl rollout history deployment/aceest-fitness

# Roll back to the previous ReplicaSet
kubectl rollout undo deployment/aceest-fitness
```

Use screenshots of the rollout status, service endpoint, and `/health` response
as submission evidence.
