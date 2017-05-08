#!/usr/bin/env bash

PEBBLES_PATH='/usr/px'

function installPX {
    if [ -d "/usr/px" ]; then
      cd /usr/px
      ./gwb stopServer
      cd /root
      rm -rf /usr/px
    fi

    cd /root
    mkdir /usr/px
    unzip -d /usr/px ExampleCenter.zip

    cd /usr/px
    chmod +x gwb
    nohup ./gwb runServer > runServer.log 2>&1 &
    cd /root
}

function startPX {
    if [ -d "/usr/px" ]; then
      cd /usr/px
      ./gwb stopServer
      rm -rf runServer.log
      nohup ./gwb runServer > runServer.log 2>&1 &
      cd /root
    fi
}

function stopPX {
    if [ -d "/usr/px" ]; then
      cd /usr/px && ./gwb stopServer
      cd /root
    fi
}

installPX