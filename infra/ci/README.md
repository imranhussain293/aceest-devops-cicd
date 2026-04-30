# Local CI Tooling (Docker Compose)

This folder runs Jenkins + SonarQube locally.

## Start

```bash
cd infra/ci
docker compose up -d
```

## Access
- Jenkins: http://localhost:8081
- SonarQube: http://localhost:9000

## Notes
- SonarQube may take ~1–2 minutes to become ready on first boot.
- Jenkins will ask for an initial admin password; retrieve it from the container logs.
