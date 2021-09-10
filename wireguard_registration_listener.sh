#!/bin/bash

socat UNIX-LISTEN:/tmp/wgreg,fork,reuseaddr,mode=777 system:"/usr/bin/env sudo -kS xargs -I {} server_config.sh peer {}"
