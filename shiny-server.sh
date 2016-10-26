#!/bin/bash	

chmod +x /etc/service/shiny-server/run

mkdir -p /var/log/shiny-server
chown shiny /var/log/shiny-server

exec shiny-server >> /var/log/shiny-server.log 2>&1
