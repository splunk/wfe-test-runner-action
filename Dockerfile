# Container image that runs your code
FROM ghcr.io/splunk/workflow-engine-base:2.0.3

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["bash","-x","/entrypoint.sh"]
