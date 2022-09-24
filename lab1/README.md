## Lab 1

The goal of this lab is to build on the previous lab and add a quick SBOM creation and archive to it.

The Dockerfile/Jenkinsfile in this directory are just for reference, and for recovery purposes if you make any mistakes during the lab.


* Edit the Jenkinsfile.  After the "build image" stage, we'll want to add a new stage:

```
    stage('Analyze with syft') {
      steps {
        // run syft, output in both json and text formats
        //
        // note: setting PATH here like this will work regardless of whether syft/grype 
        // were installed before we ran this pipeline or during the pipeline execution
        sh '''
          # first, let's make sure there's no old sboms laying around (just so our build artifacts are clean)
          rm *sbom*
          PATH=${HOME}/.local/bin:${PATH}
          syft --output json=${SBOM_NAME}.json --output table=${SBOM_NAME}.txt ${IMAGE} 
         '''
      } // end steps
    } // end stage "analyze with syft"
```

* (optional) Edit the Dockerfile (in the root of the repository) and change the label from "lab0" to "lab1"
