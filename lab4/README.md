## Lab 4: Vulnerability Scanning

Goal: get a vulnerability report and optionally enforce vulnerability checks.

1. Edit the Jenkinsfile and add a stage to evaluate our SBOM with grype:
```
    stage('Evaluate SBOM with grype') {
      steps {
        // run grype, read sbom from json sbom, output in json and table format. 
        // we will pipe text output to "tee" so we can save the report AND see it in the logs
        // we could instead just use "--file" option for grype if we just want to silenty archive results
        sh '''
          PATH=${HOME}/.local/bin:${PATH}
          grype --output json=grype-${IMAGE}-sbom.json --output table sbom:${IMAGE}-sbom.json | tee grype-${IMAGE}-sbom.txt
        ''';
      } // end steps
    } // end stage "Evaluate with grype"
```
2. Add a "lab4" pipeline the same way we've been doing for labs 1 and 2.
3. Run the pipeline, review the output of the grype evaluation in the logs.
4. Grype can break the pipeline if vulnerabilities of a specified severity (or higher) are detected.  Add `--fail-on critical` to the grype check in the Jenkinsfile.
5. Run the pipeline again and observe the failure when critical vulnerabilities are found.
