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

## Documentation
- See `docs/assignment.md` for the required deliverables checklist.
