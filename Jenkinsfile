pipeline {
    agent any

    environment {
        IMAGE_NAME = "berzylyss/greenshop-web"
        DOCKER_CREDENTIALS_ID = 'dockerhub'       // Credentials Docker Hub
        GIT_REPO_URL = 'https://github.com/Berzylyss/Greenshop.git'
        GIT_BRANCH = 'main'
        WEB_FOLDER = 'greenshop-web'
        DB_FOLDER = 'greenshop-db'
        DB_ROOT_PASS = 'greenshoproot'
        DB_NAME = 'greenshop'
        DB_USER = 'greenshopuser'
        DB_PASS = 'greenshopdb'
        NETWORK_NAME = 'greenshop-net'
    }

    stages {

        stage('Checkout Web Code') {
            steps {
                script {
                    echo "Clonage du dossier ${WEB_FOLDER} depuis GitHub..."
                    sh """
                    rm -rf web-tmp
                    git clone --branch ${GIT_BRANCH} --single-branch ${GIT_REPO_URL} web-tmp
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('web-tmp/greenshop-web') {
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

        stage('Deploy Containers Locally') {
            steps {
                script {
                    echo "Création du réseau Docker si inexistant..."
                    sh """
                    docker network inspect ${NETWORK_NAME} >/dev/null 2>&1 || docker network create ${NETWORK_NAME}
                    """

                    echo "Déploiement de la base de données..."
                    sh """
                    docker rm -f greenshop-db || true
                    docker run -d --name greenshop-db --network ${NETWORK_NAME} \
                        -e MYSQL_ROOT_PASSWORD=${DB_ROOT_PASS} \
                        -e MYSQL_DATABASE=${DB_NAME} \
                        -e MYSQL_USER=${DB_USER} \
                        -e MYSQL_PASSWORD=${DB_PASS} \
                        mariadb:latest
                    """

                    echo "Déploiement du site web..."
                    sh """
                    docker rm -f greenshop-web || true
                    docker run -d --name greenshop-web --network ${NETWORK_NAME} -p 80:80 \
                        -e DB_HOST=greenshop-db \
                        -e DB_DATABASE=${DB_NAME} \
                        -e DB_USERNAME=${DB_USER} \
                        -e DB_PASSWORD=${DB_PASS} \
                        ${IMAGE_NAME}:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Déploiement terminé avec succès !'
        }
        failure {
            echo 'Le déploiement a échoué.'
        }
    }
}
