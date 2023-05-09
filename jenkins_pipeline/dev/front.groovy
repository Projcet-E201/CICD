// docker sock 에러가 나온다면 다음 명령어 입력
// sudo usermod -aG docker jenkins
// sudo systemctl restart jenkins

pipeline {
  agent any

  environment {
        credentialsGithubId = "github"
        repo = "https://github.com/Projcet-E201/Front"
        branch = 'main'
        containerName = "react"
        imageTag = "scofe/react:latest"
  }

  stages {
    stage("clone") {
        steps {
            git branch: "${env.branch}", url: "${env.repo}", credentialsId: "${env.credentialsGithubId}"
        }
    }
    stage("Image Build"){
        steps{
            sh "docker build -f Dockerfile.dev -t ${env.imageTag} ."
        }
    }
    stage("Stop container") {
      steps{
        script {
          sh "docker stop ${env.containerName} || true"
          sh "docker rm ${env.containerName} || true"
          sh "docker image prune"
        }
      }
    } 
    stage("Run container"){
        steps{
            script {
              sh "docker run -d -p 80:80 --name ${env.containerName} --network br_app ${env.imageTag}"
            }
        }
    } 
  }
  
//   post {
//             success {
//                 discordSend description: "알림테스트", 
//                   footer: "${env.buildName} 가 성공했습니다.", 
//                   link: env.BUILD_URL, result: currentBuild.currentResult, 
//                   title: "${env.buildName}  job 성공", 
//                   webhookURL: "${env.discordWebook}"
//             }
//             failure {
//                 discordSend description: "알림테스트", 
//                   footer: "${env.buildName} 빌드가 실패했습니다.", 
//                   link: env.BUILD_URL, result: currentBuild.currentResult, 
//                   title: "${env.buildName} 젠킨스 job 실패", 
//                   webhookURL: "${env.discordWebook}"
//             }
//         }
}