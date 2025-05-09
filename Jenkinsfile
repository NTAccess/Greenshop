pipeline {
    agent any

    environment {
        IMAGE_NAME = "berzylyss/greenshopweb"
        DOCKER_CREDENTIALS_ID = 'dockerhub'
        GIT_REPO_URL = 'https://github.com/Berzylyss/Greenshop.git'
        GIT_BRANCH = 'main'
        GIT_FOLDER = 'greenshop-web'
        SERVERS = ['192.168.10.11', '192.168.10.12', '192.168.10.13']
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Clonage du repository GitHub avec sparse-checkout pour le dossier ${GIT_FOLDER}..."
                    sh """
                    git init
                    git remote add origin ${GIT_REPO_URL}
                    git config core.sparseCheckout true
                    echo "${GIT_FOLDER}/" > .git/info/sparse-checkout
                    git pull origin ${GIT_BRANCH}
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('greenshop-web') {  
                    script {
                        echo "Construction de l'image Docker..."
                        docker.build("${IMAGE_NAME}:latest")
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry(credentialsId: "${DOCKER_CREDENTIALS_ID}", url: '') {
                    script {
                        echo "Push de l'image Docker vers Docker Hub..."
                        docker.image("${IMAGE_NAME}:latest").push()
                    }
                }
            }
        }

        stage('Deploy to Servers') {
            steps {
                script {
                    echo "Déploiement de la nouvelle image sur les serveurs..."

                    SERVERS.each { server ->
                        sshagent(['web-ssh']) {
                            sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@${server} '
                                echo "Suppression du conteneur existant et de l'ancienne image..."

                                # Arrêt et suppression de l'ancien conteneur
                                docker rm -f greenshopweb || true

                                # Suppression de l'ancienne image (facultatif)
                                docker rmi -f ${IMAGE_NAME}:latest || true

                                # Tirer la nouvelle image depuis Docker Hub
                                docker pull ${IMAGE_NAME}:latest

                                # Exécution du nouveau conteneur avec la nouvelle image
                                docker run -d --name greenshopweb -p 80:80 ${IMAGE_NAME}:latest
                            '
                            """
                        }
                    }
                }
            }
        }
    }
}
