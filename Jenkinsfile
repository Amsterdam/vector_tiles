#!groovy

def tryStep(String message, Closure block, Closure tearDown = null) {
    try {
        block()
    }
    catch (Throwable t) {
        slackSend message: "${env.JOB_NAME}: ${message} failure ${env.BUILD_URL}", channel: '#ci-channel', color: 'danger'

        throw t
    }
    finally {
        if (tearDown) {
            tearDown()
        }
    }
}


node {
    stage("Checkout") {
        checkout scm
    }

    stage('Test') {
        tryStep "test", {
            sh "docker-compose -p vector_tiles -f docker-compose.yml build"
        }, {
            sh "docker-compose -p vector_tiles -f docker-compose.yml down"
        }
    }

    stage("Build acceptance image tippecanoe") {
        tryStep "build", {
            docker.withRegistry('https://repo.data.amsterdam.nl','docker-registry') {
                def image = docker.build("datapunt/vector_tiles_tippecanoe:${env.BUILD_NUMBER}", "--build-arg http_proxy=${JENKINS_HTTP_PROXY_STRING} --build-arg https_proxy=${JENKINS_HTTP_PROXY_STRING} containers/tippecanoe")
                image.push()
                image.push("acceptance")
            }
        }
    }

    stage("Build acceptance image importer") {
        tryStep "build", {
            docker.withRegistry('https://repo.data.amsterdam.nl','docker-registry') {
                def image = docker.build("datapunt/vector_tiles_importer:${env.BUILD_NUMBER}",  "--build-arg http_proxy=${JENKINS_HTTP_PROXY_STRING} --build-arg https_proxy=${JENKINS_HTTP_PROXY_STRING} .")
                image.push()
                image.push("acceptance")
            }
        }
    }
}

stage('Waiting for approval') {
    slackSend channel: '#ci-channel', color: 'warning', message: 'Vector Tiles is waiting for Production Release - please confirm'
    input "Deploy to Production?"
}

node {
    stage('Push production image tippecanoe') {
        tryStep "image tagging", {
            docker.withRegistry('https://repo.data.amsterdam.nl','docker-registry') {
                def image = docker.image("datapunt/vector_tiles_tippecanoe:${env.BUILD_NUMBER}")
                image.pull()
                image.push("production")
                image.push("latest")
            }
        }
    }
    stage('Push production image importer') {
        tryStep "image tagging", {
            docker.withRegistry('https://repo.data.amsterdam.nl','docker-registry') {
                def image = docker.image("build.datapunt.amsterdam.nl:5000/datapunt/vector_tiles_importer:${env.BUILD_NUMBER}")
                image.pull()
                image.push("production")
                image.push("latest")
            }
        }
    }
}
