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
  }
}
