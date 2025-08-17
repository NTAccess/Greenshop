
pipeline {
    agent any

    environment {
        GIT_REPO_URL = 'https://github.com/Berzylyss/Greenshop.git'
        GIT_BRANCH = 'main'
        WEB_FOLDER = 'greenshop-web'
        IMAGE_NAME = 'berzylyss/greenshop-web'
        WEB_CONTAINER_NAME = 'greenshop-web'
        DB_CONTAINER_NAME = 'greenshop-db'
        DB_IMAGE = 'mariadb:latest'
        DB_PORT = '3306'
        WEB_PORT = '80'
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
                        echo "Construction de l'image Docker du web..."
                        docker.build("${IMAGE_NAME}:latest")
                    }
                }
            }
        }

        stage('Stop Existing Web Container') {
            steps {
                script {
                    echo "Arrêt du conteneur web existant s'il existe..."
                    sh """
                    if [ \$(docker ps -q -f name=${WEB_CONTAINER_NAME}) ]; then
                        docker stop ${WEB_CONTAINER_NAME}
                        docker rm ${WEB_CONTAINER_NAME}
                    fi
                    """
                }
            }
        }
        
        stage('Start Web Container') {
            steps {
                script {
                    echo "Arrêt et suppression du conteneur web existant..."
                    sh """
                    docker rm -f greenshop-web || true
                    docker run -d --name greenshop-web -p 80:80 berzylyss/greenshop-web:latest
                    """
                }
            }
        }

        stage('Ensure DB Container Running') {
            steps {
                script {
                    echo "Vérification du conteneur DB..."
                    sh """
                    if [ -z \$(docker ps -q -f name=${DB_CONTAINER_NAME}) ]; then
                        docker run -d --name ${DB_CONTAINER_NAME} -p ${DB_PORT}:3306 \\
                            -e MYSQL_ROOT_PASSWORD=greenshoproot \\
                            -e MYSQL_DATABASE=greenshop \\
                            -e MYSQL_USER=greenshopuser \\
                            -e MYSQL_PASSWORD=greenshopdb \\
                            ${DB_IMAGE}
                    fi
                    """
                }
            }
        }

    }

    post {
        success {
            echo "Déploiement terminé avec succès !"
        }
        failure {
            echo "Le déploiement a échoué."
        }
    }
}
