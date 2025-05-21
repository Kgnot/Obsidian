Este será un curso que seguire de código facilito, de ser necesario me apoyaré en la documentación original de docker.
El curso consta de 7 modulos: 

# Tabla de contenido  
1. [Módulo 1](#módulo-1)  
2. [Módulo 2](#módulo-2)  
3. [Módulo 3](#módulo-3)  
4. [Módulo 4](#módulo-4)  
5. [Módulo 5](#módulo-5)  
6. [Módulo 6](#módulo-6)  
7. [Módulo 7](#módulo-7)  
8. [Bibliografía](#bibliografía)  

---  

# Módulo 1  
Aquí nos uestran la introducción de lo que vamos a ver, desde docker inicial, docker-compose, aplicaciones multicontenedores, como hacer deploy de nuestras aplicaciones a producción, y los orquestadores, es decir Kubernetes o K8s.

## ¿Qué es docker? 
Docker es una tecnología de contendores esencial, cambia el hecho de como las empresas ejecutan y distribuyen sus aplicaciones, una de sus características es la portabilidad, esto se refiere a que se puede configurar un contendor de Docker instalando todas las dependencias, archivos y binarios para que se ejecute satisfactoriamente, este archivo lo podemos compartir en cualquier lugar que se puede ejecutar Docker. Docker me asegura que se ejecutara de la misma forma que se ejecutará en local en cualquier otro lugar. 

Vamos a ver primero que son las máquinas virtuales y su diferencia con los contenedores, tenemos la siguiente figura: 
![[Pasted image 20250520202843.png]]
Ambos comparten ciertas cosas, la máquina lo que hace es simular un hardware, es decir, simular memoria, disco duro, cpu. Esto gracias a algo llamado **Hipervisor** , que es un intermediario entre nuestro hardware y nuestras máquinas virtuales, encargado de la simulación del hardware que necesita nuestra máquina virtual, a la hora de elegir una máquina virtual debemos instalar un sistema operativo. 

De parte de los contenedores igualmente tenemos una infraestructura y encima de ella un sistema operativo. Como punto debemos entender que Docker solo funciona internamente con Linux , luego de eso tenemos el **Container Engine** viene siendo el Hipervisor pero en este caso no simula una CPU, sino que se usa el mismo recurso de la máquina huesped, aunque nosotros podemos limitar los recursos si queremos. 
## Conceptos: 
### Dockerfile
Es un archivo de texto plano que contiene todas las instrucciones necesarias para construir una imagen, este archivo no tiene ninguna extensión y se compone de diferentes directivas que nos permite correr y ejecutar comandos que nos ayuda a configurar un contenedor
### Imagen
Pieza fundamental y viene de la mano con el Dockerfile, una imagen podemos verlo como la versión compilada del Dockerfile. Haciendo una analogía, el Dockerfile y la imagen puede ser vista como una clase (POO)
### Contenedor
El contendor viene a actuar como un objeto que sé instancia a través de una imagen, nosotros a través de una imagen podemos crear múltiples contenedores, ya que es el objeto final con el que nosotros vamos a interactuar.
### Dockerhub
Es un "repositorio" en el cual vamos a almacenar imágenes, aqui encontramos un sin fin de tecnologías que se están usando en Docker, por ejemplo, Python, PHP, Django, node, java, etc. 
### Docker daemon/cli 
Este es un servicio que se ejecuta en segundo plano y es el encargado de gestionar todo lo relacionado con Docker, desde las imágenes, compilar imágenes a través del Dockerfile, etc.


Docker se ejecuta a través de una arquitectura de cliente-servidor, donde el servidor es el Docker daemon y el cliente el cual será el que se va a conectar al Docker host, por default es una terminar en la que podemos ejecutar comandos
![[Pasted image 20250520205548.png]]

## Instalación
Como Docker solo corre en un sistema operativo Linux, tenemos varias opciones, para os que no son Linux se debe instalar una máquina virtual que trae ya empaquetada Docker en su documentación, nosotros lo haremos en Linux con `apt` [Documentación_](https://docs.docker.com/engine/install/ubuntu/).
En la documentación nos dan los siguientes comandos iniciales: 
``
```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
Luego: 
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
¡Después verificamos usando:![[Pasted image 20250520212705.png]] 
Con esto comprobamos que ya está corriendo Docker

---
¡Luego de instalarlo ahora vamos a Docker hub:  https://hub.docker.com/  y para este caso buscaremos una imagen de un servidor web, es decir, apache, y encontramos que este es el comando `docker pull httpd`, con esto descargamos esa imagen, que quedaría:![[Pasted image 20250520213828.png]]
Aquí observamos que tenemos la imagen lista para crear contenedores y al realizar el comando `docker ls` podemos ver todos las imagenes/reopsitorios que nosotros tenemos, por ejemplo:![[Pasted image 20250520214316.png]] En nuestro caso.

Ahora vamos a ejectuar la imagen y crear el contenedor, que usaremos el comando run:

```bash
sudo docker run -p 8080:80 httpd
# p es para el puerto, en la documentación nos dice que se ejcuta en el puerto 80 , entonces. El apartado 
#-p <puerto_maquina_local>:<puerto_documentación>
```
Al ejecutarlo tenemos:![[Pasted image 20250520214906.png]]

# Módulo 2  



# Módulo 3  
*(Contenido aquí...)*  

# Módulo 4  
*(Contenido aquí...)*  

# Módulo 5  
*(Contenido aquí...)*  

# Módulo 6  
*(Contenido aquí...)*  

# Módulo 7  
*(Contenido aquí...)*


# Comandos: 
Este apartado será para colocar todos los comandos que a lo largo del curso se vayan poniendo con su respectiva definición: 
- `docker ps `: Ver las imágenes y contenedores de Docker
- `docker ls`: Obetener todas las imagenes/repositorios que tiene Docker
- `sudo docker run -p 8080:80 <nombre_imagen>`: Para crear una imagen y mapear el puerto en el que la documentacion nos dice al puerto en el que queremos, se entienden mejor en el Módulo 1, Instalación.

---
# Bibliografía
- [Documentación Docker](https://docs.docker.com/)
- [Curso código facilito](https://codigofacilito.com/videos/introduccion-5bf332ad-3a9e-46b2-9928-a869eb1bb4cb)