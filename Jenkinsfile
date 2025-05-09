pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "berzylyss/greenshop"
        DOCKER_TAG = "latest"
        DOCKER_CREDENTIALS_ID = "dockerhub-creds"
        SSH_KEY_ID = "vm-ssh-key"
    }

    triggers {
        pollSCM('* * * * *') // ou use GitHub Webhooks
    }

    stages {
        stage('Check changed folders') {
            when {
                changeset "**/greenshop-web/**"
            }
            steps {
                echo "greenshop-web changed, continuing pipeline..."
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }

        stage('Deploy to VMs') {
            steps {
                sshagent(credentials: ["${SSH_KEY_ID}"]) {
                    script {
                        def servers = ["user@vm1", "user@vm2", "user@vm3"]
                        for (server in servers) {
                            sh """
                            ssh -o StrictHostKeyChecking=no ${server} '
                                docker pull ${DOCKER_IMAGE}:${DOCKER_TAG} &&
                                docker stop greenshopweb|| true &&
                                docker rm greenshopweb || true &&
                                docker run -d --name greenshopweb -p 80:80 ${DOCKER_IMAGE}:${DOCKER_TAG}
                            '
                            """
                        }
                    }
                }
            }
        }
    }
}
