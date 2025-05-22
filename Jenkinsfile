pipeline {
  agent any

  environment {
    IMAGE_NAME = "bahanney/webapp-calculator" // Replace with your Docker Hub username
    IMAGE_TAG = "${env.BUILD_NUMBER}"
    DOCKER_CREDENTIALS_ID = "docker-hub-credentials"
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'project-1', url: 'https://github.com/Bahanney/proj-mdp-152-155.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
            sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
          }
        }
      }
    }

    stage('Run Docker Container') {
      steps {
        script {
          sh "docker rm -f webapp || true"
          sh "docker run -d --name webapp -p 8080:8080 ${IMAGE_NAME}:${IMAGE_TAG}"
        }
      }
    }
  }

  post {
    always {
      script {
        sh "docker stop webapp || true"
        sh "docker rm webapp || true"
      }
    }
  }
}
