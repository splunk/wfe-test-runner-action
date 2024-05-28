FROM ghcr.io/splunk/workflow-engine-base:4.1.0

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "-x", "/entrypoint.sh"]
