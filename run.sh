#!/bin/bash
docker run -it -v $HOME/code:/home/clojure/code -v $HOME:/home/clojure/home -v /:/host bach/toolbox
#docker run -it -v /home/core:/home/clojure -v /:/host bach/toolbox

