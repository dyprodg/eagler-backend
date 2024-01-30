pipeline {
    agent {
        label 'ec2-basic'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('switch directory') {
            steps {
                dir('function') { 
                    echo 'switched dir'
                }
            }
        }

        stage('Python Test Run') {
            steps {
                dir('function') {
                    echo 'Run Python Function Test'
                }
            }
        }

        stage('Push to ECR') {
            steps {
                dir('function') {
                    sh './registry.sh'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succesfull!'
        }
        failure {
            echo 'Pipeline failed'
        }
        always {
            echo 'Pipeline finished'
        }
    }
}