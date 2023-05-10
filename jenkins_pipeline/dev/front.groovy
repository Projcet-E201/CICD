pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIAL = "docker_hub"
        DOCKER_IMAGE = 'scofe/react'
        DOCKER_TAG = 'latest'

        credentialsGithubId = "github"
        repo = "https://github.com/Projcet-E201/Front"
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

        stage('Build Docker Image') {
            steps {
                script {
                    dir('frontend') {
                        docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                    }
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
                sh "sudo ansible-playbook -i ${env.ANSIBLE_INVENTORY_PATH}/hosts2.yaml ${env.ANSIBLE_PLAYBOOK_PATH}/main_server/react_playbook.yaml"
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