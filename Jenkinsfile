pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub'       // Credentials Docker Hub
        GIT_REPO_URL = 'https://github.com/Berzylyss/Greenshop.git'
        GIT_BRANCH = 'main'
        GIT_WEB_FOLDER = 'greenshop-web'
        GIT_DB_FOLDER = 'greenshop-db'

        // Variables depuis .env
        MYSQL_ROOT_PASSWORD = "greenshoproot"
        MYSQL_DATABASE = "greenshop"
        MYSQL_USER = "greenshopuser"
        MYSQL_PASSWORD = "greenshopdb"
        WEB_IMAGE = "berzylyss/greenshop-web"
        WEB_IMAGE_TAG = "latest"
        DB_IMAGE = "mariadb:latest"
    }

    stages {

        stage('Checkout Web Code') {
            steps {
                sh """
                rm -rf web-tmp
                git clone --branch ${GIT_BRANCH} --depth 1 ${GIT_REPO_URL} web-tmp
                """
            }
        }

        stage('Checkout DB Scripts') {
            steps {
                sh """
                rm -rf db-tmp
                git clone --branch ${GIT_BRANCH} --depth 1 ${GIT_REPO_URL} db-tmp
                """
            }
        }

        stage('Check for Changes') {
            steps {
                script {
                    def changed = sh(
                        script: "cd web-tmp && git rev-parse HEAD",
                        returnStdout: true
                    ).trim()

                    if (fileExists("last_commit.txt")) {
                        def lastCommit = readFile("last_commit.txt").trim()
                        if (lastCommit == changed) {
                            echo "Pas de changement dans le code. Skip build."
                            currentBuild.result = 'SUCCESS'
                            return
                        }
                    }

                    writeFile file: "last_commit.txt", text: changed
                    env.CODE_CHANGED = "true"
                }
            }
        }

        stage('Build and Push Docker Image') {
            when {
                expression { env.CODE_CHANGED == "true" }
            }
            steps {
                dir('web-tmp/greenshop-web') {
                    script {
                        echo "Construction de l'image Docker..."
                        def image = docker.build("${WEB_IMAGE}:${WEB_IMAGE_TAG}")

                        echo "Push de l'image Docker vers Docker Hub..."
                        withDockerRegistry(credentialsId: "${DOCKER_CREDENTIALS_ID}", url: '') {
                            image.push()
                        }
                    }
                }
            }
        }

        stage('Run Docker Containers Locally') {
            steps {
                script {
                    echo "Lancement des conteneurs Docker en local..."

                    // MariaDB
                    sh """
                    docker rm -f greenshop-db || true
                    docker run -d --name greenshop-db \\
                        -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \\
                        -e MYSQL_DATABASE=${MYSQL_DATABASE} \\
                        -e MYSQL_USER=${MYSQL_USER} \\
                        -e MYSQL_PASSWORD=${MYSQL_PASSWORD} \\
                        -p 3306:3306 ${DB_IMAGE}
                    """

                    // Web
                    sh """
                    docker rm -f greenshop-web || true
                    docker pull ${WEB_IMAGE}:${WEB_IMAGE_TAG}
                    docker run -d --name greenshop-web -p 8080:80 ${WEB_IMAGE}:${WEB_IMAGE_TAG}
                    """
                }
            }
        }

        stage('Initialize Database') {
            steps {
                script {
                    echo "Initialisation de la base MariaDB..."
                    sh """
                    cat db-tmp/greenshop-db/init.sql | docker exec -i greenshop-db mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}
                    """
                }
            }
        }
    }
}
