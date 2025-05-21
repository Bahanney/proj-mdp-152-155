pipeline {
  agent any

  environment {
    IMAGE_NAME = "webapp-calculator"
    IMAGE_TAG = "latest"
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

    stage('Run Docker Container') {
      steps {
        script {
          sh "docker rm -f webapp || true"
          sh "docker run -d --name webapp -p 8080:8080 ${IMAGE_NAME}:${IMAGE_TAG}"
        }
      }
    }
  }
}
