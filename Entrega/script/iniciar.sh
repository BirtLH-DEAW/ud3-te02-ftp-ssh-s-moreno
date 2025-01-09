#!/bin/bash
# Inicia Apache en segundo plano
apache2ctl -D FOREGROUND &

# Inicia ProFTPD en modo sin daemon
proftpd --nodaemon

# Inicia el servidor SSH
/usr/sbin/sshd -D
