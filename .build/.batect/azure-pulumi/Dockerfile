ARG CLOUD_SDK_VERSION=298.0.0
ARG ISTIO_VERSION=1.6.4
ARG TERRAFORM_VERSION=0.12.6

FROM alpine:3.10.1 AS base

RUN apk add --no-cache \
    bash \
    ca-certificates

######## TERRAFORM ##########
# FROM base AS terraform
# ARG TERRAFORM_VERSION
# ENV TERRAFORM_VERSION=${TERRAFORM_VERSION}
# RUN wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
#     mkdir -p /terraform-${TERRAFORM_VERSION} && \
#     unzip /tmp/terraform.zip -d /terraform-${TERRAFORM_VERSION} && \
#     rm /tmp/terraform.zip

######## GCLOUD #######
FROM base AS gcloud
ARG CLOUD_SDK_VERSION
RUN apk add --no-cache \
    curl

ENV CLOUD_SDK_VERSION=${CLOUD_SDK_VERSION}

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz

###### ISTIO #########
FROM base AS istio
RUN apk add --no-cache \
    curl
ARG ISTIO_VERSION

ENV ISTIO_VERSION=${ISTIO_VERSION}
RUN curl -sL https://git.io/getLatestIstio | sh - 


######################

FROM alpine:3.12.0 AS builder
ARG PULUMI_VERSION=latest
RUN apk update && \
      apk upgrade && \
      apk add \
      curl \
      make \
      libc6-compat \
      gcc \
      git
# Install the Pulumi SDK, including the CLI and language runtimes.
RUN if [ "$PULUMI_VERSION" = "latest" ]; then \
    curl -fsSL https://get.pulumi.com/ | sh; \
  else \
    curl -fsSL https://get.pulumi.com/ | sh -s -- --version $PULUMI_VERSION ; \
  fi

# The runtime container
# This is our base container, so let's copy all the runtimes to .pulumi/bin

FROM node:latest AS node_base

RUN echo "NODE Version:" && node --version
RUN echo "NPM Version:" && npm --version



#######OUTPUT: AZURE_CLI ############
FROM mcr.microsoft.com/azure-cli

ARG CLOUD_SDK_VERSION
ARG ISTIO_VERSION
ARG TERRAFORM_VERSION

RUN apk add --no-cache \
    bash \
    ca-certificates \
    docker \
    git 

RUN apk add --update nodejs npm

WORKDIR /pulumi
COPY --from=builder /root/.pulumi/bin bin

COPY --from=node_base . /nodejs/bin

# ENV NODE_VERSION=12.6.0
# RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
# ENV NVM_DIR=/root/.nvm
# RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
# RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
# RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}


# COPY --from=terraform /terraform-${TERRAFORM_VERSION} /terraform-${TERRAFORM_VERSION}
COPY --from=istio /istio-${ISTIO_VERSION} /istio-${ISTIO_VERSION}
COPY --from=gcloud /google-cloud-sdk /google-cloud-sdk
# ENV PATH /terraform-${TERRAFORM_VERSION}:$PATH
ENV PATH /istio-${ISTIO_VERSION}/bin:$PATH
ENV PATH /google-cloud-sdk/bin:$PATH
# ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
ENV PATH "/pulumi/bin:${PATH}"
ENV PATH "/nodejs/bin:${PATH}"


RUN gcloud components install \
    kubectl