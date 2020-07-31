ARG CLOUD_SDK_VERSION=298.0.0
ARG ISTIO_VERSION=1.6.4

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

FROM alpine:3.11

ENV GLIBC_VER=2.31-r0

# install glibc compatibility for alpine so pulumi and aws can work together
RUN apk --no-cache add \
        binutils \
        curl \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && apk --no-cache del \
        binutils \
        curl \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/*

ARG CLOUD_SDK_VERSION
ARG ISTIO_VERSION

RUN apk add --no-cache \
    bash \
    ca-certificates \
    docker \
    python2 \
    git 

RUN apk -v --update add py-pip && \
    pip install --upgrade awscli && \
    pip install envsubst && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

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