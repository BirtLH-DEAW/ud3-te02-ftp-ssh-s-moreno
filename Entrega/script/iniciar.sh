#!/bin/bash
# Inicia Apache en segundo plano
apache2ctl start

# Inicia ProFTPD en modo sin daemon
proftpd --nodaemon &

# Inicia el servidor SSH
service ssh start

# Mantiene el contenedor activo
tail -f /dev/null