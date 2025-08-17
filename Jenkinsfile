pipeline {
    agent any

    environment {
        IMAGE_NAME = "berzylyss/greenshopweb"
        DOCKER_CREDENTIALS_ID = 'dockerhub'       // Credentials Docker Hub
        GIT_REPO_URL = 'https://github.com/Berzylyss/Greenshop.git'
        GIT_BRANCH = 'main'
        GIT_WEB_FOLDER = 'greenshop-web'
        GIT_DB_FOLDER = 'greenshop-db'
        SERVERS = ['192.168.10.11', '192.168.10.12', '192.168.10.13', '192.168.20.14']
    }

    stages {

        // Checkout code web
        stage('Checkout Web Code') {
            steps {
                script {
                    echo "Clonage du dossier ${GIT_WEB_FOLDER} depuis GitHub..."
                    sh """
                    rm -rf web-tmp
                    git init web-tmp
                    cd web-tmp
                    git remote add origin ${GIT_REPO_URL}
                    git config core.sparseCheckout true
                    echo "${GIT_WEB_FOLDER}/" > .git/info/sparse-checkout
                    git pull origin ${GIT_BRANCH}
                    """
                }
            }
        }

        // Checkout DB scripts
        stage('Checkout DB Scripts') {
            steps {
                script {
                    echo "Clonage du dossier ${GIT_DB_FOLDER} depuis GitHub..."
                    sh """
                    rm -rf db-tmp
                    git init db-tmp
                    cd db-tmp
                    git remote add origin ${GIT_REPO_URL}
                    git config core.sparseCheckout true
                    echo "${GIT_DB_FOLDER}/init.sql" > .git/info/sparse-checkout
                    git pull origin ${GIT_BRANCH}
                    """
                }
            }
        }

        // Build Docker image
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

        // Push Docker image to Docker Hub
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

        // Deploy Docker containers on servers
        stage('Deploy to Servers') {
            steps {
                script {
                    echo "Déploiement de la nouvelle image sur les serveurs..."
                    SERVERS.each { server ->
                        sshagent(['web-ssh']) {
                            sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@${server} '
                                docker rm -f greenshopweb || true
                                docker rmi -f ${IMAGE_NAME}:latest || true
                                docker pull ${IMAGE_NAME}:latest
                                docker run -d --name greenshopweb -p 80:80 ${IMAGE_NAME}:latest
                            '
                            """
                        }
                    }
                }
            }
        }

        // Update Database
        stage('Update Database') {
            steps {
                withCredentials([string(credentialsId: 'db-root-pass', variable: 'DB_PASS')]) {
                    sshagent(['db-ssh']) {
                        sh """
                        scp -o StrictHostKeyChecking=no db-tmp/greenshop-db/init.sql ubuntu@192.168.20.14:/tmp/init.sql
                        ssh -o StrictHostKeyChecking=no ubuntu@192.168.20.14 '
                            mysql -u root -p${DB_PASS} -e "DROP DATABASE IF EXISTS greenshop; CREATE DATABASE greenshop;"
                            mysql -u root -p${DB_PASS} greenshop < /tmp/init.sql
                        '
                        """
                    }
                }
            }
        }
    }
}
