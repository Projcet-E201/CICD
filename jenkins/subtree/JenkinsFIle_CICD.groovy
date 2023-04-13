pipeline {
    agent any

    environment {
        // 증명ID (깃허브, 깃랩)
        credentialsGithubId = "ssafy"
        credentialsGitlabId = "gitlab_jenkins"
    
        // subtree repo이름, 폴더이름
        prefix = 'CICD'
        childName = 'CICD'
        
        // childRepo 주소, parentRepo 주소 
        childRepo = "https://github.com/ProjectTeam-Test/${env.childName}.git"
        parentRepo = "https://lab.ssafy.com/s08-bigdata-recom-sub1/S08P21E105.git"
        
        // childRepo 브랜치, parentRepo 브랜치
        childBranch = 'main'
        parentBranch = 'develop'
    }

    stages {

        // 정확한 이유는 모르겠는데, 이게있어야 웹훅이 동작함
        stage('Checkout SCM') {
            steps {
                checkout(
                    [$class: 'GitSCM',
                     branches: [[name: "${env.childBranch}"]],
                     userRemoteConfigs: [[url: "${env.childRepo}",
                                         credentialsId: "${env.credentialsGithubId}"]]
                    ]
                )
                
            }
        }

        // 깃랩 가져옴
        stage('Pull parent repository') {
            
            steps {
                script { 
                    git branch: "${env.parentBranch}", url: "${env.parentRepo}", credentialsId: "gitlab_jenkins"
                }
            }
        }

        // 예외사항 대비하려고 만듬(없어도됨)
        stage('Git remote add') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${env.credentialsGithubId}", passwordVariable: 'password', usernameVariable: 'username')]) {
                        try {
                            sh 'git remote -v'
                            sh "git remote add ${env.prefix} https://$username:$password@github.com/ProjectTeam-Test/${env.childName}.git"
                        } catch(err) {
                            echo err.getMessage()
                            echo 'already exist'
                        }
                    }
                }
            }
        }

        // 예외사항 대비하려고 만듬(없어도됨)
        stage('Git set-url') {
            steps {
                script {
                   withCredentials([usernamePassword(credentialsId: "${env.credentialsGithubId}", passwordVariable: 'password', usernameVariable: 'username')]) {
                        try {
                            sh 'git remote -v'
                            sh "git remote set-url ${env.prefix} https://$username:$password@github.com/ProjectTeam-Test/${env.childName}.git ${childName}"
                        } catch(err) {
                            echo err.getMessage()
                            echo 'already exist'
                        }
                    }
                }
            }
            
        }

        // 예외사항 대비하려고 만듬(없어도됨)
        stage('Git subtree add') {
            steps {
                script {
                    try {
                        sh 'git remote -v'
                        sh "git subtree add --prefix=${env.prefix} ${env.childName} ${env.childBranch}"
                    } 
                    catch(err) {
                        echo err.getMessage()
                        echo 'already exist'
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
                        sh "git push -u https://$username:$password@lab.ssafy.com/s08-bigdata-recom-sub1/S08P21E105.git ${env.parentBranch}"
                    }
                }
            }
        }
    }
}
