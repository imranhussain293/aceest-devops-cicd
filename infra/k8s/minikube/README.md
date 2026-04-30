# Minikube deploy

This folder contains the Kubernetes manifests to run the Flask app on Minikube.

## Deploy

```bash
# Ensure context is Minikube
kubectl config current-context

# Start Minikube if needed
minikube start

# Build the app image directly into Minikube's image store
minikube image build -t aceest-fitness:local .

# Apply manifests
kubectl apply -f infra/k8s/minikube/

# Wait for rollout
kubectl rollout status deploy/aceest-fitness

# Access the service

# Option A: Minikube helper (may require keeping the terminal open on Windows + Docker driver)
minikube service aceest-fitness --url

# Option B: Port-forward (reliable on Windows)
kubectl port-forward service/aceest-fitness 18080:80
curl http://127.0.0.1:18080/health
```

## Update / Rollback

```bash
# Rebuild image (same tag) and restart pods to pick up changes
minikube image build -t aceest-fitness:local .
kubectl rollout restart deploy/aceest-fitness

# Roll back to previous ReplicaSet
kubectl rollout undo deploy/aceest-fitness
```
