## Lab 2: Compare SBOMs

The goal here is to show a very simple diff between a base image and the final image that comes out of the build stage.



syft packages $(grep "^FROM" Dockerfile | awk '{print $2}')
