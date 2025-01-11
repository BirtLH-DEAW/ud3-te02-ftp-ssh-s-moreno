# DEAW 03 TAREA EVALUATIVA 02

## Vídeo autoevaluación

+ [Vídeo en YouTube](https://youtu.be/RaA4STfJaXM)


## Usuarios del sistema:

+ smoreno1 (password: smoreno1)
+ smoreno2 (password: smoreno2)

## Lanzar contenedor 

```bash
cd  Entrega
build -t deaw03te02 .
docker run -dit --name deaw03te02 -p 21:21 -p 80:80 -p 443:443 -p 1022:1022 -p 50000-50030:50000-50030 deaw03te02
# Entrar a la terminal del contenedor:
docker exec -it deaw03te02 /bin/bash                                                    
```
