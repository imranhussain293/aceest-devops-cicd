# Local CI Tooling (Docker Compose)

This folder runs Jenkins + SonarQube locally.

## Start

```bash
cd infra/ci
docker context use desktop-linux
docker compose up -d
```

If you get an error like `No such image: jenkins/jenkins:lts-jdk17`, it usually means the image was pulled into a different Docker context/engine.
Re-run `docker context use desktop-linux` and then run `docker compose up -d` again.

## Access
- Jenkins: http://localhost:8081
- SonarQube: http://localhost:9000

## Notes
- SonarQube may take ~1–2 minutes to become ready on first boot.
- Jenkins will ask for an initial admin password; retrieve it from the container logs.
