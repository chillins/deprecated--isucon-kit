#!/usr/bin/env bash

set -ue -o pipefail

# Install analyzer for application
rsync -av ./Makefile isuconapp:~ 
ssh isuconapp 'make nginx/install-alp'

# Install analyzer for DB
rsync -av ./Makefile isucondb:~ 
ssh isucondb 'make mysql/install-pt-query-digest'

# Install pprotein for app
rsync -av ./systemd/pprotein.service ./systemd/pprotein-agent-httplog.service isuconapp:/etc/systemd/system/
ssh isuconapp 'make pprotein/setup-app'

# Install pprotein for db
rsync -av ./systemd/pprotein-agent.service isucondb:/etc/systemd/system/
rsync -av ./mysql/allow-remote.sql isucondb:/etc/mysql/
