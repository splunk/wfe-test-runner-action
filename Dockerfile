# Container image that runs your code
FROM ubuntu:18.04
ENV KUBECTL_VERSION=v1.21.0
ENV TERRAFORM_VERSION=0.14.11
ENV VAULT_VERSION=1.7.1
ENV ARGOCD_VERSION=v2.0.1
ENV ARGO_VERSION=v3.0.2
ENV KUSTOMIZE_VER=4.1.3
ENV YQ_VERSION=4.9.6
RUN apt-get update && apt-get install -y nano vim make software-properties-common openssh-client jq curl unzip gettext-base dnsutils iputils-ping netcat crudini && apt-get clean
RUN add-apt-repository ppa:git-core/ppa -y
RUN apt-get update && apt-get install -y git
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install
RUN curl -sLO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && mv terraform /usr/local/bin && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN curl -sLO "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" && unzip vault_${VAULT_VERSION}_linux_amd64.zip && mv vault /usr/local/bin && rm vault_${VAULT_VERSION}_linux_amd64.zip
RUN curl -sLO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && mv kubectl /usr/local/bin && chmod 700 /usr/local/bin/kubectl
RUN curl -sLO "https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64" && mv argocd-linux-amd64 /usr/local/bin/argocd && chmod 700 /usr/local/bin/argocd
RUN curl -sLO "https://github.com/argoproj/argo-workflows/releases/download/${ARGO_VERSION}/argo-linux-amd64.gz" && gunzip argo-linux-amd64.gz && mv argo-linux-amd64 /usr/local/bin/argo && chmod 700 /usr/local/bin/argo
RUN curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/aws-iam-authenticator && chmod +x ./aws-iam-authenticator && cp ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator
RUN curl -sLO https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 && chmod +x yq_linux_amd64 && mv -f yq_linux_amd64 /usr/local/bin/yq
RUN curl -o kustomize.tar.gz -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VER}/kustomize_v${KUSTOMIZE_VER}_linux_amd64.tar.gz && gunzip kustomize.tar.gz && tar -xf kustomize.tar && chmod +x ./kustomize && cp ./kustomize /usr/local/bin/kustomize


# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["bash","-x","/entrypoint.sh"]