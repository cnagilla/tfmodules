FROM hashicorp/terraform:1.2.4
ARG WORK_DIR="/modules"
ARG AZ_VERSION="2.38.0"
ARG HELM_VERSION="3.12.1"
ARG KUBECTL_VERSION="1.26.0"

# Working direcory
WORKDIR ${WORK_DIR}

# Packages
RUN apk add --no-cache \
        git \
        curl \
        curl-dev \
        iproute2 \
        ca-certificates \
        gnupg \
        unzip \
        py3-pip \
        bash-completion \
        git-bash-completion \
        gcc \
        musl-dev \
        python3-dev \
        libffi-dev \
        openssl-dev \
        cargo \
        make

# Pre-commit
RUN pip3 install pre-commit \
    && git config --global --add safe.directory ${WORK_DIR}

# Azure cli
RUN pip install azure-cli==${AZ_VERSION} \
    && az config set extension.use_dynamic_install=yes_without_prompt

# K8s tools
RUN wget "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
    && tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && mv -v linux-amd64/helm /usr/bin/helm \
    && helm completion bash > /usr/share/bash-completion/completions/helm \
    && curl -L "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o /usr/bin/kubectl \
    && chmod +x /usr/bin/kubectl \
    && kubectl completion bash > /usr/share/bash-completion/completions/kubectl \
    && rm -vrf helm-v${HELM_VERSION}-linux-amd64.tar.gz linux-amd64/

ENTRYPOINT ["/bin/bash"]