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

## Default credentials

SonarQube (first login):
- Username: `admin`
- Password: `admin`

Jenkins initial admin password:

```bash
docker exec aceest-jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

## Next steps

1) Log into SonarQube and change the `admin` password.
2) Create a SonarQube token: User icon -> **My Account** -> **Security** -> **Generate Tokens**.
3) In Jenkins: add a **Secret text** credential with ID `sonarqube-token` containing that token.

## Notes
- SonarQube may take ~1–2 minutes to become ready on first boot.
- Jenkins will ask for an initial admin password; retrieve it with the `docker exec` command above.

## Docker builds in Jenkins

The local Jenkins container is configured to build Docker images by mounting the Docker daemon socket (`/var/run/docker.sock`).
This is convenient for local CI, but do not use this pattern for untrusted code.
