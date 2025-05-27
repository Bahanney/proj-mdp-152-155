pipeline {
    agent any

    environment {
        RUNTIME_HOST = "ec2-user@18.118.140.194"
        WAR_NAME = "WebAppCal-1.3.5.war"
        PROJECT_DIR = "proj-mdp-152-155"
        SSH_KEY_CREDENTIALS = "/home/jenkins/bee.pem" // Replace with your Jenkins SSH credentials ID
        IMAGE_NAME = "bahanney/webapp-calculator"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID = "docker-hub-credentials"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'project-1',
                    credentialsId: 'github-creds', // Ensure this matches your Jenkins credentials ID
                    url: 'https://github.com/Bahanney/proj-mdp-152-155.git'
            }
        }

        stage('Build WAR') {
            steps {
                dir("${PROJECT_DIR}") {
                    sh 'ls -la' // Debug: Verify pom.xml and other files
                    withMaven(maven: 'Maven') { // Replace 'Maven' with your Jenkins Maven tool name
                        sh 'mvn clean package -e -X' // Debug flags for detailed Maven output
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir("${PROJECT_DIR}") {
                    sh 'ls -la' // Debug: Verify Dockerfile presence
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS_ID}") {
                        sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Copy WAR to Runtime Tomcat Server') {
            steps {
                sshagent(credentials: ["${SSH_KEY_CREDENTIALS}"]) {
                    sh """
                        scp -o StrictHostKeyChecking=no ${PROJECT_DIR}/target/${WAR_NAME} ${RUNTIME_HOST}:/home/ec2-user/
                    """
                }
            }
        }

        stage('Deploy WAR on Tomcat Server') {
            steps {
                sshagent(credentials: ["${SSH_KEY_CREDENTIALS}"]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${RUNTIME_HOST} '
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

    post {
        failure {
            echo "Pipeline failed. Check console output for details."
        }
        success {
            echo "Pipeline completed successfully. WAR deployed to Tomcat and Docker image pushed to Docker Hub."
        }
    }
}
