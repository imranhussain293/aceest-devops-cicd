# Assignment 2 – Requirements Checklist

This page tracks the deliverables stated in the assignment brief.

## Tooling expected
- Git + GitHub
- Jenkins (CI)
- Pytest (unit tests)
- SonarQube (static analysis / quality gate)
- Docker or Podman (containerization)
- Container registry (Docker Hub or a local registry)
- Kubernetes deployment
  - Local: Minikube
  - Cloud: AWS / Azure / GCP (AWS planned)

## Required artifacts in the submission
- Flask application files + versioned releases
- `Jenkinsfile`
- `Dockerfile`
- Kubernetes YAML manifests
- Pytest test cases
- SonarQube report/results
- GitHub repo link
- Short report (2–3 pages):
  - CI/CD architecture overview
  - Challenges faced + mitigations
  - Key automation outcomes

## Deployment strategies to demonstrate
- Rollback capability
- Rolling update
- Blue/Green
- Canary
- Shadow (traffic mirroring / replay)
- A/B testing

Notes:
- Local environment should run on Minikube.
- “Prod-like” setup should run on a cloud environment.
