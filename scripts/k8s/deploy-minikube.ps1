param(
    [Parameter(Mandatory = $false)]
    [string]$ManifestPath = "infra/k8s/minikube"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $ManifestPath)) {
    throw "Manifest path not found: $ManifestPath"
}

kubectl apply -f $ManifestPath
kubectl rollout status deployment/aceest-fitness
kubectl get pods -l app=aceest-fitness
kubectl get service aceest-fitness
