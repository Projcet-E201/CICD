pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIAL = "docker_hub"
        DOCKER_IMAGE = 'scofe/data_generator'
        DOCKER_TAG = 'latest'
        
        buildName = "DataGenerator"
        discordWebook = credentials("DISCORD_WEBHOOK")

        credentialsGithubId = "github"
        repo = "https://github.com/Projcet-E201/DataGenerator.git"
        branch = 'main'

        ANSIBLE_INVENTORY_PATH = "/home/ubuntu/CICD/server_management/ansible/inventory"
        ANSIBLE_PLAYBOOK_PATH = "/home/ubuntu/CICD/server_management/ansible/playbook"
    }

    stages {

        stage('Deploy with Ansible') {
            steps {
            
                sh "sudo ansible-playbook -i ${env.ANSIBLE_INVENTORY_PATH}/hosts.yaml ${env.ANSIBLE_PLAYBOOK_PATH}/data_server/data_generator_playbook.yaml"
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