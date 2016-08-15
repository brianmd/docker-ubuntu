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

mkdir -p ~/.config && cd ~/.config && git clone git@github.com:brianmd/docker-ubuntu.git && cd docker-ubuntu && ./install.sh
