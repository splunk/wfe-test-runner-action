FROM ghcr.io/splunk/workflow-engine-base:3.0.0

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "-x", "/entrypoint.sh"]
