pipeline {
  agent any

  options {
    timestamps()
  }

  environment {
    PIP_DISABLE_PIP_VERSION_CHECK = '1'
    PYTHONDONTWRITEBYTECODE = '1'
    PYTHONUNBUFFERED = '1'

    SONAR_HOST_URL = 'http://sonarqube:9000'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Unit Tests') {
      steps {
        sh '''
          set -eux
          python3 -m venv .venv
          . .venv/bin/activate
          pip install -r requirements.txt
          pytest -q --junitxml=pytest-junit.xml --cov=src --cov-report=xml:coverage.xml
        '''
      }
      post {
        always {
          junit allowEmptyResults: true, testResults: 'pytest-junit.xml'
          archiveArtifacts allowEmptyArchive: true, artifacts: 'pytest-junit.xml,coverage.xml'
        }
      }
    }

    stage('SonarQube Scan') {
      steps {
        withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
          sh '''
            set -eux
            sonar-scanner \
              -Dsonar.host.url=${SONAR_HOST_URL} \
              -Dsonar.token=${SONAR_TOKEN}
          '''
        }
      }
    }

    stage('Quality Gate') {
      steps {
        withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
          sh '''
            set -eux

            python3 - <<'PY'
import base64
import json
import os
import time
import urllib.request

report_path = '.scannerwork/report-task.txt'
if not os.path.exists(report_path):
    raise SystemExit(f"Missing {report_path}; did sonar-scanner run?")

props = {}
with open(report_path, 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if not line or '=' not in line:
            continue
        k, v = line.split('=', 1)
        props[k.strip()] = v.strip()

ce_task_url = props.get('ceTaskUrl')
if not ce_task_url:
    raise SystemExit('Missing ceTaskUrl in report-task.txt')

token = os.environ.get('SONAR_TOKEN')
if not token:
    raise SystemExit('Missing SONAR_TOKEN env var')

auth = base64.b64encode((token + ':').encode('utf-8')).decode('ascii')
headers = {
    'Authorization': f'Basic {auth}',
    'Accept': 'application/json',
}

timeout_seconds = 300
poll_seconds = 3
deadline = time.time() + timeout_seconds

def http_get(url: str) -> dict:
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=20) as resp:
        body = resp.read().decode('utf-8')
    return json.loads(body)

analysis_id = None
while time.time() < deadline:
    task = http_get(ce_task_url).get('task', {})
    status = task.get('status')
    if status == 'SUCCESS':
        analysis_id = task.get('analysisId')
        break
    if status in ('FAILED', 'CANCELED'):
        raise SystemExit(f"SonarQube background task status: {status}")
    time.sleep(poll_seconds)

if not analysis_id:
    raise SystemExit('Timed out waiting for SonarQube background task to finish')

host_url = os.environ.get('SONAR_HOST_URL', '').rstrip('/')
qg_url = f"{host_url}/api/qualitygates/project_status?analysisId={analysis_id}"
qg = http_get(qg_url).get('projectStatus', {})
gate_status = qg.get('status')

print(f"Quality Gate: {gate_status}")
if gate_status != 'OK':
    conditions = qg.get('conditions') or []
    failing = [c for c in conditions if c.get('status') == 'ERROR']
    if failing:
        print('Failing conditions:')
        for c in failing:
            metric = c.get('metricKey')
            actual = c.get('actualValue')
            err = c.get('errorThreshold')
            print(f"- {metric}: actual={actual} threshold={err}")
    raise SystemExit('Quality Gate failed')

PY
          '''
        }
      }
    }
  }
}
