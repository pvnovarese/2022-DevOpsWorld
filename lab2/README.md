## Lab 2: Check SBOM for forbidden packages

Goal: implement a check for a forbidden package

Method 1: simple grep of the package list

This is very straightforward.  We just take all the package names, put them all on one line, and then use an invert grep to throw an error if we find the package we want to block.  Add this stage right after the "Analyze with syft" stage and before "Archive SBOMs" - 

```
    stage('Package Check') {
      steps {
        // all we need to do is put all the package names on one line and then grep -v
        // the awk extracts just the package names
        // tr converts newlines to spaces (puts e
        // note: as written this is just a partial match
        sh '''          
          awk '{print $1}' ${IMAGE}-sbom.txt | tr "\n" " " | grep -qv curl
        '''
      } // end steps
    } // end stage "Package check"
```

Method 2: jq filter of the json sbom

```
    stage('Package Check') {
      steps {
        // same idea, put all the package names on one line and then grep -v
        // note: as written this is just a partial match
        sh '''                    
          jq -r '.artifacts[].name' ${IMAGE}-sbom.json | tr "\n" " " | grep -qv curl
        '''
      } // end steps
    } // end stage "Package check"
```

Either of these methods should error out at this stage.  You can verify that this is actually working by changing "curl" to "sudo" or some other package we haven't installed.
