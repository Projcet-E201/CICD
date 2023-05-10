pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIAL = "docker_hub"
        DOCKER_IMAGE = 'scofe/data_generator'
        DOCKER_TAG = 'latest'

        credentialsGithubId = "github"
        repo = "https://github.com/Projcet-E201/DataGenerator.git"
        branch = 'main'

        ANSIBLE_INVENTORY_PATH = "/home/ubuntu/CICD/server_management/ansible/inventory"
        ANSIBLE_PLAYBOOK_PATH = "/home/ubuntu/CICD/server_management/ansible/playbook"
    }

    stages {
        stage("Git clone") {
            steps {
                 git branch: "${env.branch}", url: "${env.repo}", credentialsId: "${env.credentialsGithubId}"
            }
        }

        stage("Gradle build") {
            steps {
                sh "chmod +x gradlew"
                sh "./gradlew clean build"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', "${env.DOCKER_HUB_CREDENTIAL}") {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
            
                sh "sudo ansible-playbook -i ${env.ANSIBLE_INVENTORY_PATH}/hosts.yaml ${env.ANSIBLE_PLAYBOOK_PATH}/data_server/datagenerator.yaml"
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