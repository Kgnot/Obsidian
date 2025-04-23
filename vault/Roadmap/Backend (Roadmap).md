# Backend RoadMap.

# Internet

El internet es una red global de computadores conectados entre si que se comunican mediante protocolos. 

La información se mueve a través de bits sobre varios medios incluyendo los cables Ethernet, fibra óptica o señales inalámbricas 

Podemos decir que el internet  es en realidad una filosofía de diseño y una arquitectura expresada por una seri de protocolos. 

## Protocolos:

Un protocolo es un conjunto de reglas conocidas por todos en la que todos están de acuerdo en usar para de esta manera comunicarnos sin problemas. Todos los dispositivos tienen una dirección única que se usa para poder saber a que equipo se esta comunicando y desde que equipo, uno de los protocolos es el Internet Protocol o IP , así la dirección de un ordenador se llama IP address. Las IP tradicionales tienen 32 bits formada por 8 bits cada una

![image.png](Roadmap/src/Backend%20RoadMap/image.png)

### TCP/IP

La definición de TCP/IP es la identificación del grupo de protocolos 
de red que hacen posible la transferencia de datos en redes, entre 
equipos informáticos e internet. Las siglas TCP/IP hacen referencia a 
este grupo de protocolos:

- **TCP** es el Protocolo de Control de Transmisión que
permite establecer una conexión y el intercambio de datos entre dos
anfitriones. Este protocolo proporciona un transporte fiable de datos.
- **IP** o protocolo de internet, utiliza direcciones
series de cuatro octetos con formato de punto decimal (como por ejemplo
75.4.160.25). Este protocolo lleva los datos a otras máquinas de la red.

El modelo TCP/IP permite un intercambio de datos fiable dentro de una
 red, definiendo los pasos a seguir desde que se envían los datos (en 
paquetes) hasta que son recibidos. Para lograrlo utiliza un sistema de 
capas con jerarquías (se construye una capa a continuación de la 
anterior) que se comunican únicamente con su capa superior (a la que 
envía resultados) y su capa inferior (a la que solicita servicios).

Este modelo se basa en diferentes capas: Aplicación, Transporte, Red, Enlace de Datos, Física o también: 

![image.png](Roadmap/src/Backend%20RoadMap/image%201.png)

Una manera de entenderlo y de manera sencilla es:

La capa de aplicación lo que hace es coger los datos y transformarlos en lenguaje de computador, de ser necesario implementa un algoritmo de encriptación y si es web entra en acción el protocolo http que agregara un encabezado [como http ok] y la encapsula

La capa de transporte coge nuestros datos ya necesarios y solo la fragmentara de ser necesario, es decir si el tamaño por ejemplo es mayor a 1500 bits (por decir algo), y el protocolo TCP (que es para web) añade su propio encabezado

> Un ejemplo de encabezado TCP puede ser el siguiente:
> 
> - Puerto de origen: 16 bits
> - Puerto de destino: 16 bits
> - Número de secuencia: 32 bits
> - Número de acuse de recibo: 32 bits
> - Longitud de la cabecera: 4 bits
> - Flags: 8 bits

![IP-Packet-with-TCP-Header.png](IP-Packet-with-TCP-Header.png)

Aquí observamos como es un protocolo TCP, tambien el HTTP abajo .

La capa de Red entra en acción el protocolo IP y se encarga de agregar su propio encabezado : [cuya información se llama información de direccionamiento lógico]

![image.png](Roadmap/src/Backend%20RoadMap/image%202.png)

En la capa de Enlace de datos agrega su propio encabezado con las MAC de los dispositivos que se están comunicando y un Trailer para comprobar que no ha sido dañado nada de los datos mandados.

Y en la capa física se transforman los datos a el tipo de señal a la que estarán expuesta, ya sea por electricidad, luz u ondas. 

---

Del otro lado se hace el mismo procedimiento pero al revés para mostrar los datos mandados.

### Protocolo HTTP

El protocolo HTTP (HyperText Transfer Protocol), es el protocolo más popular para comunicarse en línea. Hay varios tipos de versiones HTTP , empezamos con:

### HTTP/1.0 :

- **Descripción**: Versión inicial de HTTP que introdujo las solicitudes y respuestas básicas.
- **Características**:
    - Cada solicitud abre una conexión nueva.
    - Sólo admite texto plano, imágenes y archivos simples.
    - No soporta conexiones persistentes.

Ejemplo de solicitud:

```vbnet
GET /index.html /1.0
Host: www.ejemplo.com
```

Ejemplo de respuesta: 

```less
HTTP/1.0 200 OK
Conten-Type: text/html

<html>
  <body>
    <h1>Hola, HTTP/1.0!</h1>
  </body>
</html>
```

### HTTP/1.1

- **Descripción**: Introdujo mejoras significativas, como conexiones persistentes y compresión.
- **Características**:
    - Usa el encabezado `Host` para múltiples dominios en un solo servidor.
    - Soporte para conexiones reutilizables (keep-alive).

Ejemplo solicitud: 

```makefile
GET /blog HTTP/1.1
Host: www.ejemplo.com
User-Agent: Mozilla/5.0  /* El user Agent sirve para identificar el navegador en el que se hace la solicitud*/
```

Ejemplo respuesta: 

```makefile
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 45

{
  "mensaje": "Hola, HTTP/1.1!",
  "exito": true
}
```

### HTTPS (HTTP Secure)

- **Descripción**: HTTP sobre una capa de seguridad (TLS o SSL).
- **Características**:
    - Comunicación encriptada entre cliente y servidor.
    - Asegura confidencialidad, autenticación e integridad de los datos.

[`https://www.banco-seguro.com/login`](https://www.banco-seguro.com/login) 

### HTTP/2

- **Descripción**: Diseñado para mejorar el rendimiento de la web moderna.
- **Características**:
    - Multiplexación: múltiples solicitudes/respuestas en la misma conexión.
    - Compresión de encabezados HTTP.
    - Encriptación obligatoria en muchos casos.

**Ejemplo de un flujo HTTP/2**:

- En lugar de texto plano como HTTP/1.1, usa binarios, lo que mejora la velocidad.
- El navegador solicita un archivo CSS, imágenes, y JavaScript al mismo tiempo en una sola conexión.

### HTTP/3

- **Descripción**: Basado en QUIC (un protocolo de transporte basado en UDP).
- **Características**:
    - Reduce la latencia al eliminar la necesidad de reabrir conexiones interrumpidas.
    - Mejor rendimiento en redes móviles.

| Versión | Persistencia | Encriptación | Multiplexación | Compresión de encabezados |
| --- | --- | --- | --- | --- |
| HTTP/1.0 | No | No | No | No |
| HTTP/1.1 | Si | Opcional | No | No |
| HTTP/2 | Si | Si | Si | Si |
| HTTP/3 | Si | Si | Si | Si |

Vamos a ver los diferentes tipos de HTTP: 

En HTTP existen diferentes metodos, GET, HEAD, POST, PUT, DELETE , CONNECT, OPTION, TRACE, PATCH. 

| **Método** | **Función** |
| --- | --- |
| GET | Solicita datos de un recurso específico. Es el método más común y se usa para recuperar información. |
| HEAD | Similar a GET pero solo recupera los encabezados HTTP, sin el cuerpo de la respuesta. Útil para verificar metadatos. |
| POST | Envía datos para ser procesados a un recurso específico. Se usa para crear nuevos recursos o enviar formularios. |
| PUT | Actualiza un recurso existente o crea uno nuevo si no existe en la ubicación especificada. |
| DELETE | Elimina el recurso especificado en el servidor. |
| CONNECT | Establece un túnel hacia el servidor identificado por el recurso. Se usa principalmente para conexiones HTTPS a través de proxy. |
| OPTIONS | Describe las opciones de comunicación disponibles para el recurso objetivo. Útil para CORS. |
| TRACE | Realiza una prueba de bucle de retorno de mensaje a lo largo de la ruta al recurso objetivo. Usado para diagnóstico. |
| PATCH | Aplica modificaciones parciales a un recurso. Similar a PUT pero solo modifica los campos especificados. |

Después de saber que hacen los métodos HTTP, como se ven las peticiones y respuestas? (Request and Response): 

### Ejemplos de Request y Response por Método HTTP

```
# GET Request
GET /api/users/123 HTTP/1.1
Host: api.ejemplo.com

# GET Response
HTTP/1.1 200 OK
Content-Type: application/json
{
    "id": 123,
    "name": "Juan"
}
```

```
# POST Request
POST /api/users HTTP/1.1
Host: api.ejemplo.com
Content-Type: application/json

{
    "name": "Juan",
    "email": "juan@email.com"
}

# POST Response
HTTP/1.1 201 Created
Content-Type: application/json
{
    "id": 124,
    "message": "Usuario creado"
}
```

```
# PUT Request
PUT /api/users/123 HTTP/1.1
Host: api.ejemplo.com
Content-Type: application/json

{
    "name": "Juan Updated",
    "email": "juan.new@email.com"
}

# PUT Response
HTTP/1.1 200 OK
Content-Type: application/json
{
    "message": "Usuario actualizado"
}
```

```
# DELETE Request
DELETE /api/users/123 HTTP/1.1
Host: api.ejemplo.com

# DELETE Response
HTTP/1.1 204 No Content
```

```
# PATCH Request
PATCH /api/users/123 HTTP/1.1
Host: api.ejemplo.com
Content-Type: application/json

{
    "email": "juan.nuevo@email.com"
}

# PATCH Response
HTTP/1.1 200 OK
Content-Type: application/json
{
    "message": "Email actualizado"
}
```

```
# HEAD Request
HEAD /api/users/123 HTTP/1.1
Host: api.ejemplo.com

# HEAD Response
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 45
Last-Modified: Wed, 18 Dec 2024 10:00:00 GMT
```

```
# OPTIONS Request
OPTIONS /api/users HTTP/1.1
Host: api.ejemplo.com

# OPTIONS Response
HTTP/1.1 200 OK
Allow: GET, POST, PUT, DELETE
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
```

# Controlador de Versionado de Sistemas

Git es un sistema de control de versiones distribuido diseñado para manejar proyectos de cualquier tamaño con velocidad y eficiencia.

## Conceptos Básicos de Git

- **Repositorio**: Es el lugar donde se almacena todo el historial del proyecto y sus archivos.
- **Commit**: Es una instantánea del proyecto en un momento específico.
- **Branch (Rama)**: Una línea independiente de desarrollo que permite trabajar en funcionalidades sin afectar la rama principal.
- **Merge**: El proceso de combinar cambios de diferentes ramas.

## Comandos Fundamentales

```bash
# Iniciar un repositorio
git init

# Clonar un repositorio existente
git clone <url-repositorio>

# Verificar estado de archivos
git status

# Agregar archivos al área de preparación
git add <archivo>

# Crear un commit
git commit -m "mensaje del commit"

# Cambiar entre ramas
git checkout <nombre-rama>

# Crear una nueva rama
git branch <nombre-rama>
```

## Flujo de Trabajo Básico

1. Modificar archivos en tu directorio de trabajo
2. Preparar los archivos, agregándolos al área de preparación (staging)
3. Hacer commit de los cambios, lo que toma los archivos tal y como están en el área de preparación

## Estados de Git

| **Estado** | **Descripción** |
| --- | --- |
| Modified | El archivo ha sido modificado pero no preparado para commit |
| Staged | El archivo modificado ha sido marcado para ir en el próximo commit |
| Committed | Los datos están almacenados de manera segura en la base de datos local |

## Beneficios de Usar Git

- Control de versiones distribuido
- Trabajo colaborativo eficiente
- Historial completo de cambios
- Branching y merging poderoso
- Capacidad de trabajar offline

## Comandos Intermedios de Git

```bash
# Ver historial de commits
git log --oneline

# Deshacer cambios en el área de trabajo
git checkout -- <archivo>

# Deshacer el último commit
git reset HEAD~1

# Guardar cambios temporalmente
git stash

# Aplicar cambios guardados
git stash pop

# Ver diferencias entre commits
git diff <commit1> <commit2>

# Actualizar repositorio local
git fetch origin
git pull origin <rama>
```

## Comandos Avanzados de Git

```bash
# Reescribir historial de commits
git rebase -i HEAD~3

# Buscar commits específicos
git bisect start
git bisect bad
git bisect good <commit>

# Etiquetar versiones
git tag -a v1.0 -m "Versión 1.0"

# Limpiar archivos no rastreados
git clean -fd

# Combinar commits
git merge --squash <rama>

# Guardar cambios parciales
git add -p

# Ver blame de un archivo
git blame <archivo>

# Cherry-pick de commits específicos
git cherry-pick <commit-hash>
```

### Casos de Uso Avanzados

- **Rebase Interactivo:** Útil para limpiar y reorganizar commits antes de fusionar
- **Bisect:** Ayuda a encontrar commits que introdujeron bugs
- **Cherry-pick:** Permite seleccionar commits específicos para aplicar en otra rama
- **Hooks:** Automatizar acciones en eventos específicos de Git

# 

### Bibliografía:

Microsoft. (2022, 13 diciembre). Direccionamiento TCP/IP y subredes. Microsoft Learn. [https://learn.microsoft.com/es-es/troubleshoot/windows-client/networking/tcpip-addressing-and-subnetting](https://learn.microsoft.com/es-es/troubleshoot/windows-client/networking/tcpip-addressing-and-subnetting)

OpenWebinars. (2023, 14 junio). ¿Qué es TCP/IP? OpenWebinars. [https://openwebinars.net/blog/que-es-tcpip/](https://openwebinars.net/blog/que-es-tcpip/)

Git. (2024). Pro Git Book (2nd Edition). Git Documentation. [https://git-scm.com/book/en/v2](https://git-scm.com/book/en/v2)