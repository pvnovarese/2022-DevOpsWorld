## Lab 1: Create SBOMs

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
          rm -f *sbom*
          # set the PATH just to be sure
          PATH=${HOME}/.local/bin:${PATH}
          # run syft and output both json and text files.
          syft --output json=${IMAGE}-sbom.json --output table=${IMAGE}-sbom.txt ${IMAGE} 
        '''
      } // end steps
    } // end stage "analyze with syft"
```

* We also want to add a stage to archive the sboms so we can find them later:
```
    stage('Archive SBOMs') {
      steps {
        // archive anything with "sbom" in the name
        archiveArtifacts artifacts: '*sbom*'
        // and, just to be sure, let's clean up after ourselves, 
        // remove any sboms we've created from the workspace
        sh 'rm -f *sbom*'
      } // end steps
    } // end stage "Archive SBOMs"
```   

* (optional) Edit the Dockerfile (in the root of the repository) and change the label from "lab0" to "lab1" (this really isn't that big of a deal)
