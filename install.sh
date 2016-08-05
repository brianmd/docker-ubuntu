# FROM ubuntu:16.04

# WARNING: the summit passwd is lame.

apt-get update && apt-get upgrade -y && apt-get install -y \
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
  unzip \
  wget \
  zsh

apt-get install -y apt-transport-https ca-certificates && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    add-apt-repository "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -s -c) main" && \
    apt-get update && \
    apt-cache policy docker-engine && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y linux-image-extra-$(uname -r) && \
    apt-get install -y docker-engine && \
    service docker start && \
    systemctl enable docker && \
    curl -L https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine

useradd -m summit -s /bin/zsh && \
    usermod -aG docker summit && \
    adduser summit sudo && \
    echo "summit:summitpw" | chpasswd && \
    echo "summit ALL=(ALL) ALL" | tee -a /etc/sudoers

apt-get clean && \
    rm -rf /var/lib/apt/lists/*/tmp/* /var/tmp/*

sudo -u summit mkdir -p /home/summit/.ssh
sudo -u summit cp authorized_keys /home/summit/.ssh/
chown -R summit:summit /home/summit/.ssh
chmod -R 700 /home/summit/.ssh

cd /home/summit

sudo -u summit mkdir -p /home/summit/.config
sudo -u summit git clone https://github.com/brianmd/dotfiles.git /home/summit/.config/dotfiles
sudo -u summit git clone https://github.com/syl20bnr/spacemacs /home/summit/.emacs.d

sudo -iu summit sh -c 'cd /home/summit/.config/dotfiles && make relink'

# RUN cd /home/summit/.config/dotfiles && git pull && echo 1

