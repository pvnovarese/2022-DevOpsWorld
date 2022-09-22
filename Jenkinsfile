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
          # setting PATH here isn't really necessary since we're just going to exit this sh step anyway but it's
          # a good reminder that it needs to be done when we actually need syft and grype
          #
          # also, we can go ahead and sanity check that the tools were installed correctly:
          which syft
          which grype
        '''
      } // end steps
    } // end stage "install and verify tools"
    
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
        // note: setting PATH here like this will work regardless of whether syft/grype 
        // were installed before we ran this pipeline or during the pipeline execution
        sh '''
          PATH=${HOME}/.local/bin:${PATH}
          syft --output json --file sbom.json ${IMAGE} 
         '''
      } // end steps
    } // end stage "analyze with syft"
    
    stage('Evaluate with grype from image') {
      steps {
        // run grype against image directly, output in table format. 
        // (we'll compare timing with running grype against the sbom)
        // we will pipe output to "tee" so we can save the report AND see it in the logs
        // we could instead just use "--file" option for grype if we just want to silenty archive results
        sh '''
          PATH=${HOME}/.local/bin:${PATH}
          grype --output table sbom:sbom.json | tee grype-image.txt
        ''';
      } // end steps
    } // end stage "grype/image"

    
    stage('Evaluate with grype from sbom') {
      steps {
        // run grype, read sbom from file "sbom.json", output in table format. 
        // we will pipe output to "tee" so we can save the report AND see it in the logs
        // we could instead just use "--file" option for grype if we just want to silenty archive results
        sh '''
          PATH=${HOME}/.local/bin:${PATH}
          grype --output table sbom:sbom.json | tee grype-sbom.txt
        ''';
      } // end steps
    } // end stage "grype/sbom"

  } // end stages

  post {
    always {
      // archive the sbom and vuln report
      archiveArtifacts artifacts: 'sbom.json, grype*.txt'
      // delete the images locally (optional, if you do this you'll lose a lot of cache speed gains when building)
      // sh 'docker image rm ${IMAGE} || failure=1'
    } // end always
  } //end post

} //end pipeline
