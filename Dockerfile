FROM ghcr.io/splunk/workflow-engine-base:5.0.2

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "-x", "/entrypoint.sh"]
