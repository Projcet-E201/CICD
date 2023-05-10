pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIAL = "docker_hub"
        DOCKER_IMAGE = 'scofe/react'
        DOCKER_TAG = 'latest'
        
        buildName = "Front"
        discordWebook = credentials("DISCORD_WEBHOOK")

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
        success {
                discordSend description: "알림테스트", 
                  footer: "${env.buildName} 가 성공했습니다.", 
                  link: env.BUILD_URL, result: currentBuild.currentResult, 
                  title: "${env.buildName}  job 성공", 
                  webhookURL: "${env.discordWebook}"
            }
            failure {
                discordSend description: "알림테스트", 
                  footer: "${env.buildName} 빌드가 실패했습니다.", 
                  link: env.BUILD_URL, result: currentBuild.currentResult, 
                  title: "${env.buildName} 젠킨스 job 실패", 
                  webhookURL: "${env.discordWebook}"
            }
    }
}