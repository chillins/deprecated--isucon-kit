#!/usr/bin/env bash

set -ue

# Build application binary before sending it to remote
make app/build

# Deploy source to remote
rsync -av ./webapp/ isuconapp:/home/isucon/webapp/
rsync -av ./env.sh isuconapp:/home/isucon/env.sh
rsync -av ./nginx/ isuconapp:/etc/nginx/
rsync -av ./systemd/ isuconapp:/etc/systemd/system/
rsync -av ./sysctl.conf isuconapp:/etc/sysctl.conf
rsync -av ./sysctl.d/ isuconapp:/etc/sysctl.d/
rsync -av --ignore-missing-args ./powerdns/ isuconapp:/etc/powerdns/
rsync -av ./mysql/ isucondb:/etc/mysql/
rsync -av ./Makefile isuconapp:~
rsync -av ./Makefile isucondb:~

# Apply OS / middleware config
ssh isuconapp 'sysctl --system'
# skip if pdns.service is not installed
ssh isuconapp 'systemctl cat pdns.service >/dev/null 2>&1 && systemctl try-restart pdns'

# Restart application server and nginx
ssh isuconapp 'make app/restart'
ssh isuconapp 'make nginx/restart'
ssh isuconapp 'make nginx/rotate-log'

# Restart DB (mysql)
ssh isucondb 'make mysql/restart'
ssh isucondb 'make mysql/rotate-log'
