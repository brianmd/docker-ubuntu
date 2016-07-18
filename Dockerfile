FROM ubuntu:16.04

# Docker documentation recommends against upgrading. If needed, request image maintainers to update
# RUN apt-get update && \
#     apt-get upgrade -y

RUN apt-get update && apt-get install -y \
  autossh \
  build-essential \
  curl \
  direnv \
  emacs24 \
  exuberant-ctags \
  gdebi \
  git \
  golang \
  htop \
  keychain \
  mosh \
  openssh-server \
  python-software-properties \
  silversearcher-ag \
  software-properties-common \
  tmux \
  tree \
  vim \
  wget \
  zsh

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
    usermod -aG docker summit

RUN sudo -u summit mkdir -p /home/summit/.config && git clone https://github.com/brianmd/dotfiles.git /home/summit/.config/dotfiles && \
    sudo -u summit git clone https://github.com/syl20bnr/spacemacs /home/summit/.emacs.d

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*/tmp/* /var/tmp/*


# NOTE: commands from here on run as user summit

WORKDIR /home/summit
USER summit
ENTRYPOINT ["/bin/zsh"]

RUN cd /home/summit/.config/dotfiles && \
    make relink

