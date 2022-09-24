pipeline {
  
  // Lab 0
  // this just verifies the basics, are the expected tools available,
  // if not, make sure we can reach them and install them, then 
  // finally verify if we can build an image correctly
  
  environment {
    //
    // this should be fairly unique, it doesn't need to be perfect
    // since we're not going to push this anywhere
    //
    IMAGE = "${JOB_BASE_NAME}:${GIT_BRANCH.split("/")[1]}-${BUILD_NUMBER}"

    //
  } // end environment
  
  agent any
  stages {
    
    stage('Checkout SCM') {
      steps {
        checkout scm
      } // end steps
    } // end stage "checkout scm"

    stage('Install and Verify Tools') {
      steps {
        sh '''
          
          ### if docker isn't available, just bail 
          ### (correcting this is a bigger problem outside the scope of this workshop)
          
          which docker   
          
          ### make sure syft is available, and if not, download and install 
          
          if [ ! $(which syft) ]; then
            curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b ${HOME}/.local/bin
          fi
          
          ### same for grype
          
          if [ ! $(which grype) ]; then
            curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b ${HOME}/.local/bin
          fi
          
          
          ### setting PATH here isn't really necessary since we're just going to exit this sh step anyway but it's
          ### a good reminder that it needs to be done when we actually need syft and grype
          
          PATH=${HOME}/.local/bin:${PATH}
          
          ### also, we can go ahead and sanity check that the tools were installed correctly:
          
          which syft
          which grype
          
        '''
      } // end steps
    } // end stage "install and verify tools"
    
    stage('Build image and tag with build number') {
      steps {
        sh '''
        
          ### standard docker build here
          ### --network=host is really only necessary if you're using the docker-compose.yaml file with docker desktop
          
          docker build --network=host -t ${IMAGE} .
          
        '''  
      } // end steps
    } // end stage "build image and tag w build number"

  } // end stages

} //end pipeline
