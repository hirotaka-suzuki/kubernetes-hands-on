# syntax = docker/dockerfile:1.0-experimental
FROM debian:buster-20190708-slim

RUN apt update && \
  apt install -y \
        pkg-config \
        bash \
        bash-completion \
        wget \ 
        curl \
        openssl \
        ca-certificates \
        vim \
        python \
        git \
        tar \
        unzip \
        jq \
        iproute2 \
        net-tools \
        sudo \
        tmux \
        watch

ENV KUBERNETES_VERSION 1.14.3
ENV TERRAFORM_VERSION 0.12.5
ENV CLOUD_SDK_VERSION 248.0.0
ENV STERN_VERSION 1.11.0
ENV HELM_VERSION 2.11.1

ENV PATH /google-cloud-sdk/bin:$PATH

ARG username
ENV USER ${username}
ENV HOME /home/${username}
ENV SHELL /bin/bash

RUN --mount=type=secret,id=userpasswd \
  useradd -m ${USER} && \
  chsh -s /bin/bash ${USER} && \
  cat /run/secrets/userpasswd |chpasswd && \
  adduser ${USER} sudo

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
        && tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
        && rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
        && gcloud config set core/disable_usage_reporting true \
        && gcloud config set component_manager/disable_update_check true \
        && gcloud --version \
        && gcloud components install alpha beta \
        && gcloud components update



RUN set -ex && \
  curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl && \
  chmod +x /usr/local/bin/kubectl && \
  git clone https://github.com/ahmetb/kubectx.git kubectx && \
  mv kubectx/kubectx /usr/local/bin && \
  mv kubectx/kubens /usr/local/bin && \
  COMPDIR=$(pkg-config --variable=completionsdir bash-completion) && \
	ln -sf kubectx/completion/kubens.bash $COMPDIR/kubens && \
	ln -sf kubectx/completion/kubectx.bash $COMPDIR/kubectx && \
  curl -L -o /usr/local/bin/stern https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64 && \
  chmod +x /usr/local/bin/stern && \
  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
  grep "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" terraform_${TERRAFORM_VERSION}_SHA256SUMS > terraform_${TERRAFORM_VERSION}_linux_amd64.zip_SHA256SUM && \
  sha256sum -c terraform_${TERRAFORM_VERSION}_linux_amd64.zip_SHA256SUM && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
  rm -rf terraform_*

RUN chown -R ${USER}:${USER} /home/${USER}


WORKDIR /home/$username
COPY docker/docker-entrypoint.sh .
ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD ["/bin/bash"]
