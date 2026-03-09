@Library('ecommerce-shared-lib') _

pipeline {
  agent any

  environment {
    SERVICE_NAME = 'ecommerce-database'
    IMAGE_NAME = '01abhyas/ecommerce-database'
    SONAR_PROJECT = 'ecommerce-database'
  }

  stages {

    stage('Prepare Version') {
      steps {
        script {
          sh '''
            set -eu
            mkdir -p artifacts
            GIT_SHA=$(git rev-parse --short HEAD)
            BRANCH_SAFE=$(echo "${BRANCH_NAME:-unknown}" | tr '/' '-')
            DOCKER_TAG="1.0.0-build.${BUILD_NUMBER}.${GIT_SHA}"
            printf "DOCKER_TAG=%s\nBRANCH_SAFE=%s\n" "$DOCKER_TAG" "$BRANCH_SAFE" > artifacts/version.env
            echo "DockerTag: $DOCKER_TAG"
          '''
          def ver         = readProperties(file: 'artifacts/version.env')
          env.DOCKER_TAG  = ver.DOCKER_TAG
          env.BRANCH_SAFE = ver.BRANCH_SAFE
        }
      }
    }

    stage('Validate SQL') {
      steps {
        sh '''
          set -eu
          echo "--- Validating SQL files ---"
          for f in schema/*.sql seeds/*.sql migrations/*.sql; do
            [ -f "$f" ] || continue
            [ -s "$f" ] || { echo "ERROR: $f is empty"; exit 1; }
            echo "  OK: $f"
          done
          echo "--- All SQL files valid ---"
        '''
      }
    }

    stage('SonarQube Analysis') {
      steps {
        sonarAnalysis(projectKey: env.SONAR_PROJECT, waitGate: false)
      }
    }

    stage('Container Build & Push') {
      when { not { changeRequest() } }
      steps {
        buildAndPushImage(
          imageName: env.IMAGE_NAME,
          dockerTag: env.DOCKER_TAG,
          context: '.',
        )
      }
    }

    stage('Approval - Prod') {
      when { branch 'main' }
      steps {
        timeout(time: 30, unit: 'MINUTES') {
          input(
            message: "Push database image ${env.DOCKER_TAG} to PRODUCTION?",
            ok: 'Confirm',
            submitter: 'admin',
          )
        }
      }
    }

    stage('Archive Artifacts') {
      steps {
        archiveArtifacts artifacts: 'artifacts/**', fingerprint: true, allowEmptyArchive: true
      }
    }

  }

  post {
    always { cleanWs() }
  }
}
