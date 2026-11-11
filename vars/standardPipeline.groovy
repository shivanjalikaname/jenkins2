// Opinionated declarative pipeline shared by services, so every repo gets the
// same timeouts, log retention, test reporting and deploy gate for free.
//
// Usage in a Jenkinsfile:
//   @Library('pipeline-lib') _
//   standardPipeline(buildCmd: 'make build', testCmd: 'make test',
//                    testReports: 'build/test-results/**/*.xml',
//                    deployCmd: './deploy.sh production')
def call(Map cfg = [:]) {
    Map c = [
        agentLabel    : 'linux',
        buildCmd      : './build.sh',
        testCmd       : './test.sh',
        testReports   : '',
        timeoutMinutes: 30,
        deployBranch  : 'main',
        deployCmd     : '',
    ] + cfg

    pipeline {
        agent { label c.agentLabel }
        options {
            timeout(time: c.timeoutMinutes, unit: 'MINUTES')
            timestamps()
            disableConcurrentBuilds(abortPrevious: true)
            buildDiscarder(logRotator(numToKeepStr: '20', artifactNumToKeepStr: '5'))
        }
        stages {
            stage('Build') {
                steps { sh c.buildCmd }
            }
            stage('Test') {
                steps { sh c.testCmd }
                post {
                    always {
                        script {
                            if (c.testReports) {
                                junit allowEmptyResults: true, testResults: c.testReports
                            }
                        }
                    }
                }
            }
            stage('Deploy') {
                when {
                    allOf {
                        expression { c.deployCmd as boolean }
                        branch c.deployBranch
                    }
                }
                steps { sh c.deployCmd }
            }
        }
        post {
            failure { echo "Build failed: ${env.BUILD_URL}" }
            always { cleanWs() }
        }
    }
}
