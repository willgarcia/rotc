ARG CLOUD_SDK_VERSION=298.0.0
ARG ISTIO_VERSION=1.6.4
ARG TERRAFORM_VERSION=0.12.6

FROM alpine:3.10.1 AS base

RUN apk add --no-cache \
    bash \
    ca-certificates

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

#######OUTPUT: AZURE_CLI ############
FROM mcr.microsoft.com/azure-cli

ARG CLOUD_SDK_VERSION
ARG ISTIO_VERSION

RUN apk add --no-cache \
    bash \
    ca-certificates \
    docker \
    git 

RUN apk add --update nodejs npm

WORKDIR /pulumi
COPY --from=builder /root/.pulumi/bin bin
COPY --from=istio /istio-${ISTIO_VERSION} /istio-${ISTIO_VERSION}
COPY --from=gcloud /google-cloud-sdk /google-cloud-sdk
ENV PATH /istio-${ISTIO_VERSION}/bin:$PATH
ENV PATH /google-cloud-sdk/bin:$PATH
ENV PATH "/pulumi/bin:${PATH}"
ENV PATH "/nodejs/bin:${PATH}"


RUN gcloud components install \
    kubectl