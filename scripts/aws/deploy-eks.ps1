param(
    [Parameter(Mandatory = $false)]
    [string]$ManifestPath = "infra/k8s/aws"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $ManifestPath)) {
    throw "Manifest path not found: $ManifestPath"
}

kubectl apply -f $ManifestPath
kubectl rollout status deployment/aceest-fitness
kubectl get service aceest-fitness
