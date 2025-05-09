pipeline {
    agent any

    environment {
        IMAGE_NAME = "berzylyss/greenshopweb"
        DOCKER_CREDENTIALS_ID = 'dockerhub'  // Utilisation de votre secret Docker Hub
        GIT_REPO_URL = 'https://github.com/Berzylyss/Greenshop.git'
        GIT_BRANCH = 'main'
        GIT_FOLDER = 'greenshop-web'
        SERVERS = ['192.168.10.11', '192.168.10.12', '192.168.10.13']
    }

    stages {
        // 1. Checkout du code GitHub avec sparse-checkout pour récupérer uniquement le dossier greenshop-web
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

        // 2. Construction de l'image Docker à partir du Dockerfile dans greenshop-web
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

        // 3. Push de l'image Docker vers Docker Hub
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

        // 4. Déploiement sur les serveurs
        stage('Deploy to Servers') {
            steps {
                script {
                    echo "Déploiement de la nouvelle image sur les serveurs..."

                    // Déploiement sur chaque serveur
                    SERVERS.each { server ->
                        sshagent(['web-ssh']) {  // Assurez-vous que web-ssh est bien configuré avec vos credentials SSH
                            sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@${server} '
                                echo "Suppression du conteneur existant et de l'ancienne image..."

                                # Arrêt et suppression de l'ancien conteneur
                                docker rm -f greenshopweb || true

                                # Suppression de l'ancienne image (facultatif)
                                docker rmi -f ${IMAGE_NAME}:latest || true

                                # Tirer la nouvelle image depuis Docker Hub
                                docker pull ${IMAGE_NAME}:latest

                                # Exécution du nouveau conteneur avec la nouvelle image, exposé sur le port 80
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
