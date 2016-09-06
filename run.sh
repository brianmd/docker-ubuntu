#!/bin/bash
docker run -it -v /home/core/code:/home/clojure/code -v /home/core:/home/clojure/home -v /:/host bach/toolbox
#docker run -it -v /home/core:/home/clojure -v /:/host bach/toolbox

