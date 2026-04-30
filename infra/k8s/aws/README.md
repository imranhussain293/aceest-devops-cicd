# AWS EKS deploy

These manifests are for the production-like cloud deployment required by the assignment.

## Prerequisites

- AWS CLI installed and configured
- Docker Desktop running
- `kubectl` installed
- An EKS cluster with `kubectl` context configured
- An ECR repository named `aceest-fitness`

## Build and push image to ECR

```powershell
.\scripts\aws\build-and-push-ecr.ps1 `
  -AwsRegion ap-south-1 `
  -RepositoryName aceest-fitness `
  -ImageTag v0.1.0
```

The script prints the full ECR image URI. Replace the placeholder image in
`deployment.yaml` with that URI before applying the manifests.

## Deploy to EKS

```powershell
kubectl config current-context
kubectl apply -f infra/k8s/aws/
kubectl rollout status deployment/aceest-fitness
kubectl get service aceest-fitness
```

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
