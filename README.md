# Intention

Explore installation strategies. 

This is NOT to be used as an actual
docker container, as it is bloated.

Rather, because docker commits each layer,
changing particular installation points can
be done much more rapidly than on creating
a new VM. Once the exploration phase has
been satifactorily completed, it is a simple
matter to convert the commands to a script
usable as user data or run by hand.

# Installation

Note: must have a private git ssh key to this github repository.
If not, should use https://github.com/brianmd/docker-ubuntu.git

If going to run in docker, use something like this:
docker run -it --rm -v /home/logindir/.ssh/git_key:/root/.ssh/git_key ubuntu /bin/bash

# export GIT_SSH_COMMAND="ssh -i ~/.ssh/git_key"
apt-get update && apt-get install -y git && mkdir -p ~/.config && cd ~/.config && git clone https://github.com/brianmd/docker-ubuntu.git && cd docker-ubuntu && ./install.sh
