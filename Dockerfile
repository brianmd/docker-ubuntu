FROM ubuntu:16.04

# WARNING: passwd is lame.

ENV USERNAME clojure
ENV PW summitpw
ENV USERID 64534
ENV GIT_KEY git_key

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  autossh \
  autotools-dev \
  build-essential \
  curl \
  direnv \
  emacs24 \
  exim4 \
  exuberant-ctags \
  gdebi \
  git \
  golang \
  heirloom-mailx \
  htop \
  httpie \
  jq \
  keychain \
  module-init-tools \
  monit \
  mosh \
  munin \
  ntpdate \
  openssh-server \
  python-software-properties \
  silversearcher-ag \
  software-properties-common \
  sysstat \
  tmux \
  tree \
  vim \
  ufw \
  unzip \
  wget \
  zsh

# Import the Google Cloud public key
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

RUN echo "install gcloud."
# Create an environment variable for the correct distribution
# ENV CLOUD_SDK_REPO "cloud-sdk-$(lsb_release -c -s)"
# RUN echo "CLOUD_SDK_REPO => $CLOUD_SDK_REPO"
# Add the Cloud SDK distribution URI as a package source
RUN apt-get install --reinstall base-files lsb-release lsb-base
RUN echo "cloud-sdk-`lsb_release -c -s` main"
RUN echo "cloud-sdk-$(lsb_release -c -s) main"
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-`lsb_release -c -s` main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
RUN ls -l /etc/apt/sources.list.d
RUN cat /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get update
RUN apt-get install -y google-cloud-sdk
RUN ls -l /etc/apt/sources.list.d

RUN apt-get update
RUN apt-get install -y google-cloud-sdk

# Install docker
RUN apt-get install -y apt-transport-https ca-certificates && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    add-apt-repository "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -s -c) main" && \
    apt-get update && \
    apt-cache policy docker-engine && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y linux-image-extra-$(uname -r) && \
    apt-get install -y docker-engine && \
    service docker start && \
    systemctl enable docker
 

RUN useradd -m summit -s /bin/zsh && \
    usermod -aG docker summit && \
    adduser summit sudo && \
    echo "summit:summitpw" | chpasswd && \
    echo "summit ALL=(ALL) ALL" | tee -a /etc/sudoers

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*/tmp/* /var/tmp/*

RUN ufw allow ssh
    ufw allow 60000:60100/udp  # mosh
    ufw allow http
    ufw allow https
    ufw allow 32400/tcp  # plex
    ufw allow 1900/udp
    ufw allow 32469/udp
    ufw allow 5353/udp
    ufw enable

# NOTE: commands from here on run as user summit

WORKDIR /home/summit
USER summit
ENTRYPOINT ["/bin/zsh"]

RUN mkdir -p /home/summit/.config && git clone https://github.com/brianmd/dotfiles.git /home/summit/.config/dotfiles && \
    git clone https://github.com/syl20bnr/spacemacs /home/summit/.emacs.d

RUN cd /home/summit/.config/dotfiles && \
    make relink && \
    mkdir -p /home/summit/.ssh

COPY authorized_keys /home/summit/.ssh/

RUN cd /home/summit/.config/dotfiles && git pull && echo 1

CMD ["zsh"]

