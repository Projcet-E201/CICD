pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-northeast-2'
    }

    stages {
        stage('Check EC2 Instances Status and Start/Stop') {
            steps {
                script {
                    withCredentials([
                        aws(credentialsId: 'aws-access-key-id', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
                    ]) {
                        def instanceIds = [
                            "i-04bb9f333c2026817", // data server 1
                            "i-01d92f8da28ad3d9f", // data server 2
                            "i-01f9b29b49c4bc4dd", // data server 3
                            "i-05cebb1ead2a1ae05", // data server 4
                            "i-0a835268e2e1075ea", // data server 5
                            "i-0b1e083fd067c25e2", // data server 6
                            "i-047c53c4cc9eed8e7", // kafka server 1
                            "i-0b4b302c910908306", // kafka server 2
                            "i-0f8fd0db9a16653a9" // kafka server 3
                        ]

                        for (instanceId in instanceIds) {
                            def instanceState = sh(returnStdout: true, script: "aws ec2 describe-instances --instance-ids ${instanceId} --query 'Reservations[0].Instances[0].State.Name' --output text").trim()
                            if (instanceState == "stopped") {
                                sh "aws ec2 start-instances --instance-ids ${instanceId}"
                            } else if (instanceState == "running") {
                                sh "aws ec2 stop-instances --instance-ids ${instanceId}"
                            }
                        }
                    }
                }
            }
        }
    }
}