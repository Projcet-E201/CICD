pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = '<your-docker-registry-url>'
        DOCKER_CREDENTIALS_ID = '<your-docker-credentials-id>'
        APP_NAME = '<your-app-name>'
        APP_VERSION = '<your-app-version>'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Retrieve source code from your repository
                    checkout scm

                    // Build Docker image
                    dockerImage = docker.build("${APP_NAME}:${APP_VERSION}")

                    // Log in to the Docker registry
                    docker.withRegistry("${DOCKER_REGISTRY}", "${DOCKER_CREDENTIALS_ID}") {
                        // Push the Docker image to the registry
                        dockerImage.push("${APP_VERSION}")
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace
            cleanWs()
        }
    }
}