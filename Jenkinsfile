pipeline {
    agent any

    environment {
        IMAGE_NAME = "berzylyss/greenshopweb"
        DOCKER_CREDENTIALS_ID = 'dockerhub'  
        GIT_REPO_URL = 'https://github.com/Berzylyss/Greenshop.git'
        GIT_BRANCH = 'main'
        GIT_FOLDER = 'greenshop-web'  
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
    }
}
