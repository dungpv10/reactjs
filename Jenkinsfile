@Library('tty-utility') import com.tty.Utilities
def utils = new Utilities(this)

pipeline {
  agent {
    node {
      label 'tty-dev-server'
    }
  }
  stages {
    stage('Check Variables') {
      steps {
        script {
          gitCommit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
          gitShortCommit = gitCommit.take(6)
          echo sh(returnStdout: true, script: 'env')
          utils.sendMessage "START", gitShortCommit
        }
        
      }
    }
    stage('SonarQube Quality Analysis') {
      steps {
        script {
          scannerHome = tool 'SonarQube Scanner'
        }
        withSonarQubeEnv('SonarQube') {
          sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=MERCHANT-WEB -Dsonar.sources=."
        }
        script {
          timeout(time: 1, unit: 'HOURS') {
            qualitygate = waitForQualityGate()
            if (qualitygate.status != "OK") {
              utils.sendMessage "FAILED", gitShortCommit
              error "Pipeline aborted due to quality gate coverage failure: ${qualitygate.status}"
            }
          }
        }
        
      }
    }
    stage('Build') {
      steps {
        echo 'Step Build'
      }
    }
    stage('Test') {
      steps {
        echo 'Step Test'
      }
    }
    stage('Deploy') {
      steps {
        sh 'rsync -avzhe --progress --delete ./* ~/merchant_web'
        sh 'sudo docker restart merchant-web'
        script {
          utils.sendMessage "SUCCESS", gitShortCommit
        }
      }
    }
  }
  post { 
    failure { 
      script {
        utils.sendMessage "FAILED", gitShortCommit
      }
    }
  }
}