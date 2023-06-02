pipeline {
    agent {
  label 'agent'
  }
  stages {
      stage ('Zero') {
          steps {
             cleanWs()        
          }
      }
      stage('First') {
          steps {
              sh 'git clone https://github.com/UstasNest/vector-role.git'
          }
          
      }
      stage('Second') {
          steps {
              sh 'cd vector-role && molecule test -s centos_7'
              
          }
      
      }
  }
    
}

