# Utilizamos una imagen oficial de Ubuntu
FROM ubuntu:latest

# Damos información sobre la imagen que estamos creando
LABEL \
    version="1.0" \
    description="Ubuntu + Apache2 + proftpd" \
    maintainer="Sergio Moreno Sanchez <smoreno@birt.eus>"

# Actualizamos la lista de paquetes e instalamos paquetes necesarios
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nano apache2 proftpd proftpd-mod-crypto openssl openssh-server openssh-client git --yes && \
    rm -rf /var/lib/apt/lists/* 

# Creamos directorios para los sitios web
RUN mkdir -p /var/www/html/sitioprimero /var/www/html/sitiosegundo

# Copiamos archivos al contenedor
COPY apache/indexPrimero.html apache/indexSegundo.html /
COPY apache/sitioPrimero.conf apache/sitioSegundo.conf /
COPY apache/sitioPrimero.key apache/sitioPrimero.cer /
COPY ftp/proftpd.conf ftp/tls.conf /
COPY ssh/sshd_config ssh/id_rsa /
COPY script/iniciar.sh /

# Movemos los archivos a sus ubicaciones adecuadas
RUN mv /indexPrimero.html /var/www/html/sitioprimero/index.html && \
    mv /indexSegundo.html /var/www/html/sitiosegundo/index.html && \
    mv /sitioPrimero.conf /etc/apache2/sites-available/sitioPrimero.conf && \
    mv /sitioSegundo.conf /etc/apache2/sites-available/sitioSegundo.conf && \
    mv /sitioPrimero.key /etc/ssl/private/sitioPrimero.key && \
    mv /sitioPrimero.cer /etc/ssl/certs/sitioPrimero.cer

# Movemos los archivos de configuración de proftd y sshd y llave privada
RUN mv /proftpd.conf /etc/proftpd/proftpd.conf && \
    mv /tls.conf /etc/proftpd/tls.conf && \
    mv /sshd_config /etc/ssh/sshd_config && \
    mv /id_rsa /root/.ssh/id_rsa

# Permisos adecuados a id_rsa: -rw------- (600) — Solo el usuario tiene el derecho de leer y escribir.
RUN chmod 600 /root/.ssh/id_rsa
RUN eval "$(ssh-agent -s)" && ssh-add /root/.ssh/id_rsa
RUN ssh-keyscan -H github.com >> /etc/ssh/ssh_known_hosts

# Clonar el repositorio en la carpeta de acceso a ftp anónimo
RUN git clone git@github.com:deaw-birt/UD3-ftp_anonimo.git /srv/ftp/github

# Descomentar el módulo mod_tls.c
RUN sed -i 's/^#\s*LoadModule mod_tls.c/LoadModule mod_tls.c/' /etc/proftpd/modules.conf

# Crear certificado autofirmado para proftd
RUN openssl req -x509 -newkey rsa:4096 \
    -keyout /etc/ssl/private/proftpd.key \ 
    -out /etc/ssl/certs/proftpd.crt \ 
    -nodes -days 365 \
    -subj "/C=ES/ST=Gipuzkoa/L=Zarautz/O=DEAW/OU=SMORENO/CN=SergioMoreno"

# Crear el usuario smoreno1 con password smoreno1. no login. home en /var/www/html/sitioprimero
RUN useradd smoreno1 -d /var/www/html/sitioprimero -s /usr/sbin/nologin -p "$(openssl passwd -1 smoreno1)"

# Cambiar usuario y grupo a sitioprimero
RUN chown -R smoreno1:www-data /var/www/html/sitioprimero

# Crear el usuario smoreno2 con password smoreno2. home en /var/www/html/sitiosegundo
RUN useradd smoreno2 -d /var/www/html/sitiosegundo -p "$(openssl passwd -1 smoreno2)"

# Cambiar usuario y grupo a sitiosegundo
RUN chown -R smoreno2:www-data /var/www/html/sitiosegundo

# Prohibir el acceso por FTP
RUN echo "smoreno2" | tee -a /etc/ftpusers

# Habilitamos los sitios y el módulo SSL
RUN a2ensite sitioPrimero.conf && \
    a2ensite sitioSegundo.conf && \
    a2enmod ssl

# Exponemos los puertos
EXPOSE 80
EXPOSE 443
EXPOSE 21 50000-50030
EXPOSE 1022

# Comando por defecto al iniciar el contenedor
CMD ["/iniciar.sh"]
