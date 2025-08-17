pipeline {
    agent any

    environment {
        IMAGE_NAME = "berzylyss/greenshop-web"
        DOCKER_CREDENTIALS_ID = 'dockerhub'
        GIT_REPO_URL = 'https://github.com/Berzylyss/Greenshop.git'
        GIT_BRANCH = 'main'
        WEB_FOLDER = 'greenshop-web'
    }

    stages {

        stage('Checkout Web Code') {
            steps {
                script {
                    sh """
                    rm -rf web-tmp
                    git clone --depth 1 --branch ${GIT_BRANCH} ${GIT_REPO_URL} web-tmp
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('web-tmp/greenshop-web') {
                    script {
                        echo "Construction de l'image Docker web..."
                        docker.build("${IMAGE_NAME}:latest")
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry(credentialsId: "${DOCKER_CREDENTIALS_ID}", url: '') {
                    script {
                        echo "Push de l'image vers Docker Hub..."
                        docker.image("${IMAGE_NAME}:latest").push()
                    }
                }
            }
        }

        stage('Update Running Web Container') {
            steps {
                script {
                    echo "Mise à jour du conteneur web existant..."
                    sh """
                    docker rm -f greenshop-web || true
                    docker run -d \
                      --name greenshop-web \
                      --network greenshop_greenshop-net \
                      -p 80:80 \
                      ${IMAGE_NAME}:latest
                    """
                }
            }
        }
    }
}
