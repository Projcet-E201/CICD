pipeline {
  agent any

    environment {
            
            credentialsGithubId = "ssafy"
            repo = "https://github.com/ProjectTeam-Test/Auth.git"
            buildName = "dev_auth"
            build = "auth"
            branch = 'main'
            discordWebook = credentials("DISCORD_WEBHOOK")
        }

    stages {
        stage("Git clone") {
            steps {
                git branch: "${env.branch}", url: "${env.repo}", credentialsId: "${env.credentialsGithubId}"
            }
        }
        
        stage('Nginx deploy') {
            steps {
                script {
                    def nginx = sh(
                            script: "docker ps --filter name=dev-${env.build}-nginx -q",
                            returnStdout: true
                    ).trim()
                    
                    if (nginx) {
                        echo "already nginx is running"
                    }else{
                        
                        
                        sh "docker-compose -f docker-compose.nginx.yml down"
                        sh "docker-compose -f docker-compose.blue.yml down"
                        sh "docker-compose -f docker-compose.green.yml down"
                        
                        sh "docker-compose -f docker-compose.blue.yml up -d"
                        sh "docker-compose -f docker-compose.green.yml up -d"
                        sh "docker-compose -f docker-compose.nginx.yml build --no-cache"
                        sh "docker-compose -f docker-compose.nginx.yml up -d"
                    }
                }
            }
        }
        
        stage('Add application.yml') {
            steps {
                sh "pwd"
                sh "cp /home/ubuntu/docker-volume/jenkins/jenkins_home/application-secret.yaml ./src/main/resources"
            }
        }

        stage("Gradle build") {
            steps {
                sh "chmod +x gradlew"
                sh "./gradlew clean build"
            }
        }
        
        stage('Back deploy') {
            steps {
                script {
                    def blue_container_id = sh(
                            script: "docker ps --filter name=dev-auth-blue -q",
                            returnStdout: true
                    ).trim()
                    
                    if (blue_container_id) {
                        echo "example_blue container is running"

                        sh "docker-compose -f docker-compose.green.yml down"
                        sh "docker-compose -f docker-compose.green.yml build --no-cache"
                        sh "docker-compose -f docker-compose.green.yml up -d"
                        
                        sh "sleep 10"

                        sh "docker exec dev-auth-nginx sed -i 's|http://3.35.222.131:8094|http://3.35.222.131:8095|g' /etc/nginx/nginx.conf"
                        sh "docker-compose -f docker-compose.blue.yml down"

                    } else {
                        echo "example_blue container is not running"

                        sh "docker-compose -f docker-compose.blue.yml down"
                        sh "docker-compose -f docker-compose.blue.yml build --no-cache"
                        sh "docker-compose -f docker-compose.blue.yml up -d"
                        
                        sh "sleep 10"

                        sh "docker exec dev-auth-nginx sed -i 's|http://3.35.222.131:8095|http://3.35.222.131:8094|g' /etc/nginx/nginx.conf"
                        sh "docker-compose -f docker-compose.green.yml down"
                    }
                    
                    sh "docker restart dev-auth-nginx"
                }
            }
        }
    }
    
    post {
            always{
                sh "docker image prune"
            }
        
            success {
                discordSend description: "알림테스트", 
                  footer: "${env.buildName} 빌드가 성공했습니다.", 
                  link: env.BUILD_URL, result: currentBuild.currentResult, 
                  title: "${env.buildName} 젠킨스 job", 
                  webhookURL: "${env.discordWebook}"
            }
            failure {
                discordSend description: "알림테스트", 
                  footer: "${env.buildName} 빌드가 실패했습니다.", 
                  link: env.BUILD_URL, result: currentBuild.currentResult, 
                  title: "${env.buildName} 젠킨스 job", 
                  webhookURL: "${env.discordWebook}"
            }
        }
}
