# Assignment 2 – Requirements Checklist

This page tracks the deliverables stated in the assignment brief.

## Tooling expected
- Git + GitHub: done
- Jenkins (CI): done
- Pytest (unit tests): done
- SonarQube (static analysis / quality gate): done
- Docker or Podman (containerization): done
- Container registry: AWS ECR planned
- Kubernetes deployment
  - Local: Minikube done
  - Cloud: AWS EKS planned

## Required artifacts in the submission
- Flask application files + versioned releases: done
- `Jenkinsfile`: done
- `Dockerfile`: done
- Kubernetes YAML manifests: Minikube done, AWS EKS draft added
- Pytest test cases: done
- SonarQube report/results: capture screenshot from local SonarQube
- GitHub repo link: done
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
