## LAB 0

The goal of this lab is just to level set, make sure Jenkins is configured properly, make sure the tools we need are installed (or can be installed), and that we can build a simple image.

The Dockerfile and Jenkinsfile for this lab are in this directory, but should be by default in the root of the repository.  If you get further along in the exercises and need to start over, you can copy the files from here back to the root of the repo.

* Fork this repository into your own GitHub account
* From the main Jenkins Dashboard, select "New Item" (top of left-hand column)
* Enter "lab0" for item name (I highly recommend using all lowercase names)
* Select "Pipeline" and hit "OK"
* On the configuration page, scroll down to the "Pipeline" section
* Change "Definition" to "Pipeline script from SCM"
* Set "SCM" to "Git"
* For "Repository URL" input this repo's URL (e.g. https://github.com/{YOUR_GIT_USERNAME}/2022-devopsworld )
* Click "Save" at the bottom 
* Click "Build Now"

If the build completes successfully, you're in a go mode.

Notes:

* If you take a look at the Jenkinsfile, you will see that we can either use an existing syft/grype installed in the build node (or, more likely in the case of this lab, the container Jenkins is running inside of), or if those tools don't exist, we can install them locally as the `jenkins` user (in `$HOME/.local/bin`)
