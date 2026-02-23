Este será un curso que seguiré de código facilito, de ser necesario me apoyaré en la documentación original de docker.
El curso consta de 7 módulos: 

# Tabla de contenido  
1. [Módulo 1](#módulo-1)  
2. [Módulo 2](#módulo-2)  
3. [Módulo 3](#módulo-3)  
4. [Módulo 4](#módulo-4)  
5. [Módulo 5](#módulo-5)  
6. [Módulo 6](#módulo-6)  
7. [Bibliografía](#bibliografía)  

---  

# Módulo 1  
Aquí nos muestran la introducción de lo que vamos a ver, desde docker inicial, docker-compose, aplicaciones multicontenedores, como hacer deploy de nuestras aplicaciones a producción, y los orquestadores, es decir Kubernetes o K8s.

## ¿Qué es docker? 
Docker es una tecnología de contenedores esencial, cambia el hecho de como las empresas ejecutan y distribuyen sus aplicaciones, una de sus características es la portabilidad, esto se refiere a que se puede configurar un contenedor de Docker instalando todas las dependencias, archivos y binarios para que se ejecute satisfactoriamente, este archivo lo podemos compartir en cualquier lugar que se puede ejecutar Docker. Docker me asegura que se ejecutara de la misma forma que se ejecutará en local en cualquier otro lugar. 

Vamos a ver primero que son las máquinas virtuales y su diferencia con los contenedores, tenemos la siguiente figura: 
![Pasted image 20250520202843.png](src/Docker/Pasted%20image%2020250520202843.png)
Ambos comparten ciertas cosas, la máquina lo que hace es simular un hardware, es decir, simular memoria, disco duro, cpu. Esto gracias a algo llamado **Hipervisor** , que es un intermediario entre nuestro hardware y nuestras máquinas virtuales, encargado de la simulación del hardware que necesita nuestra máquina virtual, a la hora de elegir una máquina virtual debemos instalar un sistema operativo. 

De parte de los contenedores igualmente tenemos una infraestructura y encima de ella un sistema operativo. Como punto debemos entender que Docker solo funciona internamente con Linux , luego de eso tenemos el **Container Engine** viene siendo el Hipervisor pero en este caso no simula una CPU, sino que se usa el mismo recurso de la máquina huésped, aunque nosotros podemos limitar los recursos si queremos. 
## Conceptos: 
### Dockerfile
Es un archivo de texto plano que contiene todas las instrucciones necesarias para construir una imagen, este archivo no tiene ninguna extensión y se compone de diferentes directivas que nos permite correr y ejecutar comandos que nos ayuda a configurar un contenedor.
### Imagen
Pieza fundamental y viene de la mano con el Dockerfile, una imagen podemos verlo como la versión compilada del Dockerfile. Haciendo una analogía, el Dockerfile y la imagen puede ser vista como una clase (POO).
### Contenedor
El contenedor viene a actuar como un objeto que se instancia a través de una imagen, nosotros a través de una imagen podemos crear múltiples contenedores, ya que es el objeto final con el que nosotros vamos a interactuar.
### Dockerhub
Es un "repositorio" en el cual vamos a almacenar imágenes, aquí encontramos un sin fin de tecnologías que se están usando en Docker, por ejemplo, Python, PHP, Django, node, java, etc. 
### Docker daemon/cli 
Este es un servicio que se ejecuta en segundo plano y es el encargado de gestionar todo lo relacionado con Docker, desde las imágenes, compilar imágenes a través del Dockerfile, etc.


Docker se ejecuta a través de una arquitectura de cliente-servidor, donde el servidor es el Docker daemon y el cliente el cual será el que se va a conectar al Docker host, por default es una terminal en la que podemos ejecutar comandos.
![Pasted image 20250520205548.png](src/Docker/Pasted%20image%2020250520205548.png)

## Instalación
Como Docker solo corre en un sistema operativo Linux, tenemos varias opciones, para los que no son Linux se debe instalar una máquina virtual que trae ya empaquetada Docker en su documentación, nosotros lo haremos en Linux con `apt` [Documentación_](https://docs.docker.com/engine/install/ubuntu/).
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
Después verificamos usando: 
![Pasted image 20250520212705.png](src/Docker/Pasted%20image%2020250520212705.png) 
Con esto comprobamos que ya está corriendo Docker

---
Luego de instalarlo ahora vamos a Docker hub:  https://hub.docker.com/  y para este caso buscaremos una imagen de un servidor web, es decir, apache, y encontramos que este es el comando `docker pull httpd`, con esto descargamos esa imagen, que quedaría: 
![Pasted image 20250520213828.png](src/Docker/Pasted%20image%2020250520213828.png)
Aquí observamos que tenemos la imagen lista para crear contenedores y al realizar el comando `docker ls` podemos ver todos las imágenes/repositorios que nosotros tenemos, por ejemplo: 
![Pasted image 20250520214316.png](src/Docker/Pasted%20image%2020250520214316.png) 
En nuestro caso.

Ahora vamos a ejecutar la imagen y crear el contenedor, que usaremos el comando run:

```bash
sudo docker run -p 8080:80 httpd
# p es para el puerto, en la documentación nos dice que se ejecuta en el puerto 80 , entonces. El apartado 
#-p <puerto_maquina_local>:<puerto_documentación>
```
Al ejecutarlo tenemos: 
![Pasted image 20250520214906.png](src/Docker/Pasted%20image%2020250520214906.png)

# Módulo 2  
Bien. Ya ejecutamos nuestro primer contenedor, ahora ejecutaremos más.  Ahora lo haremos con Nginx que es un software libre para servidor web, reverse proxy, caching, balanceador de carga, media streaming y más. 
Podemos hacer el pull mediante la recomendación del dockerhub: `docker pull nginx`, también podemos hacer un `docker run -p 8080:80 nginx` inmediatamente, esto hace dos cosas:
Si la imagen no está en nuestro local, hará un docker pull y posteriormente el docker run. 
![Pasted image 20250526091215.png](src/Docker/Pasted%20image%2020250526091215.png) 
Como vemos en la imagen dice que no encuentra la imagen a lo que procede a descargar o hacer pull a esa imagen. 
![Pasted image 20250526091321.png](src/Docker/Pasted%20image%2020250526091321.png)
Obteniendo de esa forma, si vamos al `localhost:8080` este mensaje de "Welcome to nginx ..." .
Si seguimos mirando, usando `docker container` nos muestra una lista de muchos de los comandos que podemos hacer, ahora, dentro de cada uno de ellos podemos ver más comandos que podemos realizar, como por ejemplo tenemos el comando de `docker container` donde si lo ejecutamos vemos un apartado de más comandos de combinación dentro de este. Y aquí encontramos el `docker container ls` que lista todos los contenedores que se estén ejecutando en el momento, si usamos el flag de `--help` vemos que dentro de ese `docker container ls` hay más comandos, en este caso podemos visualizar algo así: 
![Pasted image 20250526092108.png](src/Docker/Pasted%20image%2020250526092108.png)
Por ejemplo, para ver todos los contenedores usamos la abreviatura que se nos indica que es: 
`docker container ls -a`
Podemos seguir mirando y encontrar que tenemos el `--name` que nos ayuda a colocarle un nombre al contenedor. 
![Pasted image 20250526110543.png](src/Docker/Pasted%20image%2020250526110543.png)
y si miramos en otra terminal: 
![Pasted image 20250526110643.png](src/Docker/Pasted%20image%2020250526110643.png)
vemos que el nombre que le hemos dado es "test", como observamos es un identificador único, al intentar ejecutar el comando con el mismo nombre, se ve un error.
Dentro de docker hay muchísimos comandos que deberían ser usados y vistos desde la terminal, por lo que no se notaran todos aquí, sin embargo la siguiente imagen muestra otro importante que es la eliminación de un contenedor: 
![Pasted image 20250526111459.png](src/Docker/Pasted%20image%2020250526111459.png)

---
Ya con esto nosotros podemos decir que entendemos como usar los contenedores o al menos estamos asociados a ellos, entonces, ya sabiendo eso vamos a realizar el comando: 
`docker run --help` aquí nosotros vemos el siguiente comando: 
![Pasted image 20250526115514.png](src/Docker/Pasted%20image%2020250526115514.png)
En ese comando vemos que nos sirve para inicializar contenedores en segundo plano y al tiempo nos imprime el ID del contenedor. 
![Pasted image 20250526120302.png](images/Pasted%20image%2020250526120302.png)
Y podemos ver que nuestro contenedor se está ejecutando :D.
En docker están los comandos normales y los comandos "alias", una tabla que refleja eso es: 

| Comando largo            | Alias equivalente     |
| ------------------------ | --------------------- |
| docker container run     | docker run            |
| docker container ls      | docker ps             |
| docker container stop    | docker stop           |
| docker container start   | docker start          |
| docker container rm      | docker rm             |
| docker container exec    | docker exec           |
| docker container inspect | docker inspect        |
| docker image ls          | docker images         |
| docker image rm          | docker rmi            |
| docker image pull        | docker pull           |
| docker image push        | docker push           |
| docker image build       | docker build          |
## Docker interactivo. 
Dentro del modo interactivo que nos muestra docker es cuando podemos entrar a uno de esos contenedores para "interactuar" directamente con estos, entonces estamos en nuestro `docker ps`, y usamos el comando: `docker execute <container_id>` y el comando que queramos ejecutar. 
![Pasted image 20250526124717.png](images/Pasted%20image%2020250526124717.png)
de esta manera podemos entrar dentro del contenedor y ver qué hay.
De esta forma podemos ejecutar comandos, pero no es tan intuitivo, el modo interactivo como tal es poder conectar nuestra terminal con la del contenedor, lo que nos permite ingresar comandos como si estuviéramos trabajando en una máquina virtual o dentro de nuestro host, es útil para varias tareas como observar logs, instalar software, etc. 
![Pasted image 20250526125118.png](images/Pasted%20image%2020250526125118.png)
Nos está situando en la terminal del controlador. Para salir de esa terminal usamos la palabra `exit` 
## Puertos y logs: 
Los puertos son importantes, ya que de esta manera podemos "evidenciar" lo que está cargando de manera visual, como hemos visto a lo largo del curso, tenemos que usar el flag `-p 8080:80` donde significa que estamos mapeando en nuestro puerto 8080 el puerto 80 del contenedor, de esta manera lo podemos observar, sin embargo, también podemos hacer el `docker run nginx` sin necesidad de mapearlo, este funcionará; sin embargo, no tendremos una manera visual de verla, ya que no se está mapeando en ningún lugar. También existe la forma en que genera un puerto aleatorio con `-P` , que es usando la misma 'p' pero de forma mayúscula. Para ver el puerto que usa basta con usar el `docker container ls` o su alias equivalente y podemos observar donde se está mapeando.
También nosotros loggeamos cada que necesitamos observar cosas y el porqué de esas cosas.  Por ejemplo con MySQL. 
Cuando intentamos iniciar MySQL tenemos el siguiente error: 
![Pasted image 20250526193746.png](images/Pasted%20image%2020250526193746.png)
Todo normal, pero cuando lo iniciamos en segundo plano, la única manera de ver los logs es con `docker logs <id_container>` : 
![Pasted image 20250526193929.png](images/Pasted%20image%2020250526193929.png) 
Aquí observamos que el comando de segundo plano nos da el ID, pero claramente no se inició, a continuación queremos saber que paso?, entonces hacemos los logs. 
Uno de los comandos más importantes para esto de logs es el `-f` de esta forma podemos ver los logs en tiempo real: 
![Pasted image 20250526194859.png](images/Pasted%20image%2020250526194859.png)
Aquí vemos los logs, pero al final vemos: 
![Pasted image 20250526194914.png](images/Pasted%20image%2020250526194914.png)
Que se ve que acabe de ingresar a la página y se ve el log de ello.
## El comando inspect (inspeccionar): 
El comando inspect nos ayuda a inspeccionar un contenedor o ver la configuración por defecto que tiene un contenedor. 
Nos da toda  la información en un JSON, ahi podemos ir indagando :D
## Variables de entorno: 
Cómo podemos pasar variables de entorno que son importantes para ejecutar ciertos contenedores como el de MySQL. 
![Pasted image 20250526223218.png](images/Pasted%20image%2020250526223218.png)
Aquí como vemos se está ejecutando el contenedor de MySQL , le agregamos dos variables de entorno que se concatenan. 

### Contenedores sin servicios

Cuando ejecutamos imágenes base como `ubuntu` en Docker, estamos trabajando con **contenedores sin servicios**. Esto significa que no incluyen un sistema de inicialización (como `systemd` o `init`) ni tienen procesos corriendo en segundo plano por defecto.

Estas imágenes están pensadas para ser **simples, minimalistas y enfocadas en ejecutar una tarea específica**, como correr un script o lanzar una terminal. Por eso, si ejecutamos `docker run ubuntu` El contenedor arranca, ejecuta el comando por defecto (que generalmente es `bash`), pero como **no tiene terminal asignada ni servicios corriendo**, el proceso termina de inmediato y el contenedor se apaga. Es por eso que **no aparece en** `docker container ls`, ya que este solo muestra los contenedores activos.

Para que un contenedor basado en `ubuntu` se mantenga en ejecución, es necesario:
- Usar `-it` para abrir una sesión interactiva con TTY.
- O ejecutar un comando que no termine, como `tail -f /dev/null`.
Estos contenedores son muy útiles para tareas puntuales, pruebas, scripts, o como base para construir imágenes más complejas, pero **no están diseñados para actuar como servidores por sí solos**. 
En ese caso debemos hacer lo siguiente, usar `-dit` o `-it` para poder colocarlo como "servicio": 
![Pasted image 20250526224252.png](images/Pasted%20image%2020250526224252.png)
Aquí nosotros podemos ingresar al contenedor y realizar lo que queremos.

## ¿Qué son los volúmenes en docker?
Los volúmenes en Docker son una forma de almacenar datos de manera persistente fuera del ciclo de vida de un contenedor. Normalmente, cuando un contenedor se elimina, todos sus datos internos también se pierden. Pero con volúmenes, esos datos se guardan en una ubicación específica gestionada por Docker y puede sobrevivir reinicios o eliminaciones de contenedores.  Estos se guardan o se persisten en el sistema de archivos del host.
![Pasted image 20250527152338.png](images/Pasted%20image%2020250527152338.png)
## Volúmenes en Docker
Docker permite crear volúmenes de varias formas, pero la más común es usando el flag `-v` o `--mount` al ejecutar un contenedor:
```bash
docker run -v mi_volumen:/ruta/en/contenedor imagen
```
Esto lo que hace es: 
- Crea (si no existe) un volumen llamado `mi_volumen`.
- Lo monta dentro del contenedor en la ruta especificada
También puedes ver y administrar volúmenes con: 
- `docker volume ls` → lista todos los volúmenes.
- `docker volume inspect <nombre>` → muestra información detallada.
- `docker volume rm <nombre>` → elimina un volumen.

Como un ejemplo de todo lo anterior tenemos: 
![Pasted image 20250527154350.png](images/Pasted%20image%2020250527154350.png)

## Redes: 
Docker usa un sistema de redes virtuales para permitir que los contenedores se comuniquen entre sí y con el mundo exterior. Al crear o ejecutar contenedores, puedes decidir cómo se conectan, con quién pueden hablar y por qué medio. 
### Tipos de redes en docker: 
1. **Bridge**: *- por defecto*: 
   Crea una red privada donde los contenedores pueden comunicarse entre ellos usando sus nombres. Es útil para aplicaciones que corren en varios contenedores
2. **host**: *- usa la red del host directamente*:
   El contenedor comparte la red del sistema anfitrión. No hay aislamiento de red. Solo funciona en Linux
3. **none:** *- sin red*
   El contenedor no tiene acceso a ninguna red. Se usa para aislamiento total.
4. **Redes personalizadas**: *- Definidas por el usuario*:
   Permiten más control, como asignar subredes, nombres DNS entre contenedores y mayor seguridad-

¿Cómo podemos crear una red personalizada?: 
```bash
docker network create mi_red
docker run -d --name contenedor1 --network mi_red imagen1
docker run -d --name contenedor1 --network mi_red imagen2
```
En este ejemplo, tanto `contenedor1` como `contenedor2` pueden comunicarse por su nombre, como si fueran máquinas de la misma LAN.

Las redes en docker son bastante importantes para servicios múltiples, un ejemplo de ello es el `docker-compose`, que permite que todo esté conectado y controlado sin exponer cada contenedor al exterior, es decir, sin mapearlo directamente, si no entre ellos. 

# Módulo 3  
En este módulo se explicará que son las imágenes, nuestra primera imagen, copiar archivos, las variables de entorno de imágenes, ejecutar servicios, Entrypoint vs. CMD a dockerizar script de python, docker hub y dockerizar script de node. 

# Módulo 4  
*(Contenido aquí...)*  

# Módulo 5  
*(Contenido aquí...)*  

# Módulo 6  
*(Contenido aquí...)*  


# Comandos: 
Este apartado será para colocar todos los comandos que a lo largo del curso se vayan poniendo con su respectiva definición: 
- `docker ps `: Ver las imágenes y contenedores de Docker
- `docker ls`: Obtener todas las imágenes/repositorios que tiene Docker
- `sudo docker run -p 8080:80 <nombre_imagen>`: Para crear una imagen y mapear el puerto en el que la documentación nos dice al puerto en el que queremos, se entienden mejor en el Módulo 1, Instalación.
- `docker` : Usar solo el comando de docker nos lleva a todos los comandos o al menos los más comunes, generales y de administración que podemos encontrar, por ejemplo `docker container` que es otro comando para ver una lista de comandos dentro de esa

---
# Bibliografía
- [Documentación Docker](https://docs.docker.com/)
- [Curso código facilito](https://codigofacilito.com/videos/introduccion-5bf332ad-3a9e-46b2-9928-a869eb1bb4cb)
- [Video de programación en español](https://www.youtube.com/watch?v=DIDel70dFlI)
- 