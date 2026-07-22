FROM ghcr.io/splunk/workflow-engine-base:5.0.0

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "-x", "/entrypoint.sh"]
