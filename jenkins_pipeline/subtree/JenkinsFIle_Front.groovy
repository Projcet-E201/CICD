pipeline {
    agent any

    environment {

        // 증명ID (깃허브, 깃랩)
        credentialsGithubId = "github"
        credentialsGitlabId = "gitlab"
    
        // subtree repo이름, 폴더이름
        prefix = 'Front'
        childName = 'Front'
        
        // childRepo 주소, parentRepo 주소 
        childRepo = "https://github.com/Projcet-E201/Front.git"
        parentRepo = "https://lab.ssafy.com/s08-final/S08P31E201.git"
        
        // childRepo 브랜치, parentRepo 브랜치
        childBranch = 'main'
        parentBranch = 'develop'
    }

    stages {
        // 깃랩 가져옴
        stage('Pull parent repository') {
            
            steps {
                script { 
                    git branch: "${env.parentBranch}", url: "${env.parentRepo}", credentialsId: "${env.credentialsGitlabId}"
                }
            }
        }

        // remote 추가
        stage('Git remote add') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${env.credentialsGithubId}", passwordVariable: 'password', usernameVariable: 'username')]) {
                        try {
                            sh 'git remote -v'
                            sh "git remote add ${env.prefix} https://$username:$password@github.com/Projcet-E201/${env.childName}.git"
                        } catch(err) {
                            echo err.getMessage()
                            echo 'already exist'
                        }
                    }
                }
            }
        }

        // child의 변경사항을 pull받고, 이후 push해서 업데이트한다.
        stage('Push parent repository') {
            steps {
                script {
                    sh "git subtree pull --prefix=${env.prefix} ${env.childName} ${env.childBranch}"
                    sh "git config --global credential.helper store"
                    withCredentials([usernamePassword(credentialsId: "${credentialsGitlabId}", passwordVariable: 'password', usernameVariable: 'username')]) {
                        sh "git push -u https://$username:$password@lab.ssafy.com/s08-final/S08P31E201.git ${env.parentBranch}"
                    }
                }
            }
        }
    }
}