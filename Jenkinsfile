pipeline {
  
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
          PATH=${HOME}/.local/bin:${PATH}
        '''
      } // end steps
    } // end stage "install and verify tools 
    
    stage('Build image and tag with build number') {
      steps {
        sh '''
          docker build --network=host -t ${IMAGE} .
        '''  
      } // end steps
    } // end stage "build image and tag w build number"
    
    stage('Analyze with syft') {
      steps {
        // run syft, output in json format, save to file "sbom.json"
        sh '''
          syft --output json --file sbom.json ${IMAGE} 
         '''
      } // end steps
    } // end stage "analyze with syft"
    
    stage('Evaluate with grype') {
      steps {
        // run grype, read sbom from file "sbom.json", output in table format. 
        // we will pipe output to "tee" so we can save the report AND see it in the logs
        // we could instead just use "--file" option for grype if we just want to silenty archive results
        sh '''
          grype --output table sbom:sbom.json | tee grype.txt
        ''';
      } // end steps
    } // end stage "retag as prod"

  } // end stages

  post {
    always {
      // archive the sbom
      archiveArtifacts artifacts: 'sbom.json, grype.txt'
      // delete the images locally
      sh 'docker image rm ${IMAGE} || failure=1'
    } // end always
  } //end post

} //end pipeline
