# 2022-DevOpsWorld

## Prerequisites

For maximum benefit from this workshop, you'll need the following:

* a github account
* a web browser
* Syft installed on your laptop - https://github.com/anchore/syft
* Grype installed on your laptop - https://github.com/anchore/grype

Optional:

* Docker Desktop (or some other container runtime) installed on your laptop - https://www.docker.com/products/docker-desktop/
* A Docker Hub ID - https://hub.docker.com/signup

## Lab 0: Jenkins Setup

We're going to run jenkins in a container to make this fairly self-contained and easily disposable.  This command will run jenkins and bind to the host's docker sock (if you don't know what that means, don't worry about it, it's not important).

```
# docker-compose up -d
```

once the images are pulled and the containers started, give the system about 30 seconds or so to spin up, then check the logs for the initial password:

```
# docker logs jenkins
```

the initial password will look something like this:

```
*************************************************************
*************************************************************
*************************************************************

Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

ed9575aae6924e11bfa8c863fbba1625

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

*************************************************************
*************************************************************
*************************************************************
```

Now head to http://localhost:8080/ (assuming you're deploying on your local machine Docker Desktop).  To get things configured:

- log in with the initial password
- "Install suggested plugins" (if you get an error on "SSH Build Agents" here don't worry about it, we don't need it, just click "continue")
- Create admin user (suggest admin/foobar just so everyone has the same thing)
- "Save and Continue"
- Instance Configuration - Jenkins URL should be "http://localhost:8080/"
- "Save and Finish"
- "Restart" (if the system seems to get stuck, refresh your browser after a minute or so.

Once Jenkins is all set up, we'll need to install jq, syft, and grype in the jenkins container:

```
 $ docker exec --user=0 jenkins /bin/bash -c "apk add jq && \
   curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin && \
   curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin"
```

A few additional items we might use in some of the labs:
- Create a credential so we can push images into Docker Hub:
	- go to "manage jenkins" -> "manage credentials" (http://localhost:8080/credentials/)
	- click “global” and “add credentials”
	- Use your Docker Hub username and password (get an access token from Docker Hub if you are using multifactor authentication), and set the ID of the credential to “docker-hub”.

## Lab X: package blocks

* install sudo in Dockerfile (apk add sudo)
* test for sudo in package list and break pipeline if detected
* hard mode: check for license on particular package type

eg `syft -o json <image> | jq '.artifacts[] | select (.type == "gem") | .name, .type, .licenses'`

## Lab Y: vuln check

* introduce grype
* break pipelines if critical vulns are found
* bonus: check the difference between "grype <image>" and "grype <sbom>"

## Lab Z: zero day response
