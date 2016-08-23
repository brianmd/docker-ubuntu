# FROM ubuntu:16.04

# WARNING: the summit passwd is lame.
USERNAME=summit
PW=summitpw
USERID=64534
GIT_KEY=git_key

export DEBIAN_FRONTEND=noninteractive
# Create an environment variable for the correct distribution
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
# Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
# Import the Google Cloud public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

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
  google-cloud-sdk \
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
  ufw \
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

export GIT_SSH_COMMAND="ssh -i ~/.ssh/$GIT_KEY"
export DEBIAN_FRONTEND=noninteractive
(mkdir -p ~/.config && cd ~/.config && git clone https://github.com/brianmd/docker-ubuntu.git && cd docker-ubuntu && ./install.sh)
git clone https://github.com/brianmd/dotfiles.git /root/.config/dotfiles
(cd /root/.config/dotfiles && ./prep-user-tools.sh)

ufw allow ssh && \
    ufw allow mosh && \
    ufw enable

gcloud components install kubectl
gcloud components install app-engine-java

apt-get clean && \
    rm -rf /var/lib/apt/lists/*/tmp/* /var/tmp/*


addgroup -gid $USERID $USERNAME
# adduser --disabled-password --gecos '' -u $USERID --gid $USERID $USERNAME ;\
useradd -m -u $USERID --gid $USERID $USERNAME -s /bin/zsh && \
    usermod -aG docker $USERNAME && \
    adduser $USERNAME sudo && \
    echo "$USERNAME:${PW}" | chpasswd && \
    echo "$USERNAME ALL=(ALL) ALL" | tee -a /etc/sudoers

sudo -u $USERNAME mkdir -p /home/$USERNAME/.ssh
if [[ -f authorized_keys ]]; then
  sudo -u $USERNAME cp authorized_keys /home/$USERNAME/.ssh/
fi
if [[ -f ~/.ssh/$GIT_KEY ]]; then
  cp ~/.ssh/$GIT_KEY /home/$USERNAME/.ssh/
fi
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod -R 700 /home/$USERNAME/.ssh

# cd /home/$USERNAME

# sudo -u $USERNAME mkdir -p /home/$USERNAME/.config
# sudo -u $USERNAME git clone https://github.com/brianmd/dotfiles.git /home/$USERNAME/.config/dotfiles
# sudo -u $USERNAME git clone https://github.com/syl20bnr/spacemacs /home/$USERNAME/.emacs.d

# # sudo -iu $USERNAME sh -c 'cd /home/$USERNAME/.config/dotfiles && make relink'

# # RUN cd /home/$USERNAME/.config/dotfiles && git pull && echo 1

sudo -u $USERNAME -i -- sh -lc '(mkdir -p ~/.config && cd ~/.config && git clone https://github.com/brianmd/dotfiles.git && cd dotfiles && ./prep-user-tools.sh)'

# These are saved to the end because they require user input, and this may be unattended.
vim +PlugInstall
sudo -u $USERNAME vim +PlugInstall

echo "You may need to run 'vim +PlugInstall both as root and as $USERNAME'"
echo "You may also need to run 'gcloud init'"
