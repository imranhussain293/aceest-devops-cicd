# ACEest DevOps CI/CD (Assignment 2)

This repository contains the ACEest Fitness & Gym application and the end-to-end CI/CD pipeline artifacts required for Assignment 2.

## What’s inside
- Application source code (Flask)
- Automated tests (Pytest)
- Jenkins pipeline (`Jenkinsfile`)
- Static analysis via SonarQube
- Containerization (Docker)
- Kubernetes manifests for local Minikube and a cloud environment (AWS)

## Quick start (local)

Create a virtual environment, install dependencies, run tests:

```bash
python -m venv .venv
# Windows PowerShell
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
pytest -q
```

Run the app locally:

```bash
python -c "from aceest_fitness import create_app; create_app().run(host='0.0.0.0', port=5000)"
```

Build and run the Docker image:

```bash
docker build -t aceest-fitness:local .
docker run --rm -p 8080:8080 aceest-fitness:local
```

Then open `http://localhost:8080/health`.

## Documentation
- See `docs/assignment.md` for the required deliverables checklist.
- Local Jenkins + SonarQube setup: `infra/ci/README.md`
- Minikube deploy: `infra/k8s/minikube/README.md`

## SonarQube (local)

When running via Docker Compose (see `infra/ci/README.md`):
- URL: http://localhost:9000
- Default login: `admin` / `admin` (you will be prompted to change it)
