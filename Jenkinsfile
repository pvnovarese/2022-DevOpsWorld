pipeline {
  
  environment {
    //
    // this should be fairly unique, it doesn't need to be perfect
    // since we're not going to push this anywhere
    //
    IMAGE = "${JOB_BASE_NAME}:${BRANCH_NAME}-${BUILD_NUMBER}"
    //
    // shouldn't need the registry variable unless you're not using dockerhub
    // registry = 'docker.io'
    //
    // change this HUB_CREDENTIAL to the ID of whatever jenkins credential has your registry user/pass
    // first let's set the docker hub credential and extract user/pass
    // we'll use the USR part for figuring out where are repository is
    // HUB_CREDENTIAL = "docker-hub"
    // use credentials to set DOCKER_HUB_USR and DOCKER_HUB_PSW
    // DOCKER_HUB = credentials("${HUB_CREDENTIAL}")
    // change repository to your DockerID
    // REPOSITORY = "${DOCKER_HUB_USR}/jenkins-syft-demo"
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
        sh """
          ### if docker isn't available, just bail 
          ### (correcting this is a bigger problem outside the scope of this workshop)
          which docker   
          ### make sure syft is available, and if not, download and install 
          if [ ! -x "/usr/local/bin/syft" ]; then
            curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b ${HOME}/.local/bin
          fi
          ### same for grype
          if [ ! -x "/usr/local/bin/grype" ]; then
            curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b ${HOME}/.local/bin
          fi
          PATH=${HOME}/.local/bin:${PATH}
        """
      } // end steps
    } // end stage "install and verify tools 
    
    stage('Build image and tag with build number') {
      steps {
        sh """
          docker build --network=host -t ${IMAGE} .
        """  
        //
        // if you want to use the docker plugin, something like this:  
        // script {
        //   def dockerImage = docker.build ("${IMAGE}")
        // } // end script
        //
      } // end steps
    } // end stage "build image and tag w build number"
    
    stage('Analyze with syft') {
      steps {
        // run syft
        sh """
          syft --output json --file sbom.json ${IMAGE} 
         """
      } // end steps
    } // end stage "analyze with syft"
    
    stage('Evaluate with Grype') {
      steps {
        sh """
          grype --output table sbom:sbom.json | tee grype.txt
          # we could just use --file option for grype but I'm piping to tee here so we see the result in the logs
        """
        //script {
        //  docker.withRegistry('', HUB_CREDENTIAL) {
        //    dockerImage.push('prod') 
        //    // dockerImage.push takes the argument as a new tag for the image before pushing
        //  }
        //} // end script
      } // end steps
    } // end stage "retag as prod"

    stage('Clean up') {
      // delete the images locally
      steps {
        sh """
          docker rmi ${IMAGE}
        """
      } // end steps
    } // end stage "clean up"

    
  } // end stages
} //end pipeline
