pipeline {
    agent any

    environment {
        credentialsGithubId = "ssafy"
        credentialsGitlabId = "gitlab_jenkins"
    
        prefix = 'Back'
        childName = 'Back'
        
        childRepo = "https://github.com/ProjectTeam-Test/${env.childName}.git"
        parentRepo = "https://lab.ssafy.com/s08-bigdata-recom-sub2/S08P22E105.git"
        
        childBranch = 'main'
        parentBranch = 'develop'
    }

    stages {
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
        stage('Pull parent repository') {
            
            steps {
                script { 
                    git branch: "${env.parentBranch}", url: "${env.parentRepo}", credentialsId: "gitlab_jenkins"
                }
            }
        }
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
        stage('Push parent repository') {
            steps {
                script {
                    sh "git subtree pull --prefix=${env.prefix} ${env.childName} ${env.childBranch}"
                    sh "git config --global credential.helper store"
                    withCredentials([usernamePassword(credentialsId: "${credentialsGitlabId}", passwordVariable: 'password', usernameVariable: 'username')]) {
                        sh "git push -u https://$username:$password@lab.ssafy.com/s08-bigdata-recom-sub2/S08P22E105.git ${env.parentBranch}"
                    }
                }
            }
        }
    }
}
