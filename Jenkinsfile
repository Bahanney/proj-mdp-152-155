pipeline {
  agent any

  environment {
    RUNTIME_HOST = "ec2-user@18.118.140.194"
    WAR_NAME     = "WebAppCal-1.3.5.war"
    PROJECT_DIR  = "proj-mdp-152-155"
    SSH_KEY_PATH = "/home/jenkins/bee.pem"
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'project-1', url: 'https://github.com/Bahanney/proj-mdp-152-155.git'
      }
    }

    stage('Build WAR') {
      steps {
        dir("${PROJECT_DIR}/calculator") {
          sh "mvn clean package"
        }
      }
    }

    stage('Copy WAR to Runtime Server') {
      steps {
        sh """
          scp -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no ${PROJECT_DIR}/calculator/target/${WAR_NAME} ${RUNTIME_HOST}:/home/ec2-user/
        """
      }
    }

    stage('Deploy WAR on Tomcat') {
      steps {
        sh """
          ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no ${RUNTIME_HOST} '
            sudo mv /home/ec2-user/${WAR_NAME} /opt/apache-tomcat-9.0.91/webapps/${WAR_NAME} &&
            /opt/apache-tomcat-9.0.91/bin/shutdown.sh || true &&
            sleep 3 &&
            /opt/apache-tomcat-9.0.91/bin/startup.sh
          '
        """
      }
    }
  }
}
