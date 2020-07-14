FROM alpine:3.10.1

RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    docker \
    python2 \
    git

ENV TERRAFORM_VERSION=0.12.6
RUN wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin && \
    rm /tmp/terraform.zip

RUN apk -v --update add py-pip && \
    pip install --upgrade awscli && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

# Based on https://github.com/GoogleCloudPlatform/cloud-sdk-docker/blob/master/alpine/Dockerfile.
ENV CLOUD_SDK_VERSION=298.0.0

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz

ENV PATH /google-cloud-sdk/bin:$PATH

RUN gcloud components install \
    kubectl

ENV ISTIO_VERSION=1.7.0-alpha.0
RUN curl -sL https://git.io/getLatestIstio | sh -
ENV PATH /istio-${ISTIO_VERSION}/bin:$PATH

ENV HELM_VERSION=3.2.4
RUN curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64
