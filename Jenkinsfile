properties([parameters([
  [$class: 'DateParameterDefinition',
   name: 'today',
   dateFormat: 'yyyyMMdd',
   defaultValue: 'LocalDate.now()']
])])

pipeline { 
    environment { 
        registry = "amattera89/rpi-jenkins" 
        registryCredential = 'dockerhub' 
        dockerImage = '' 
        today = "${params.today}"
    }
    agent any 
    
    stages { 

        stage('Cloning our Git') { 
            steps { 
                      git branch: 'master', credentialsId: 'github', url:'https://github.com/amattera89/rpi-jenkins.git' 
            }
        } 

        stage('Building our image') { 
            steps { 
                script { 
                    dockerImage = docker.build registry + ":$today" 
                }
            } 
        }

        stage('Deploy our image') { 

            steps { 

                script { 

                    docker.withRegistry( '', registryCredential ) { 

                        dockerImage.push() 

                    }
                } 
            }
        } 
        stage('Cleaning up') { 
            steps { 
                sh "docker rmi $registry:$today" 
            }
        } 
    }
}
