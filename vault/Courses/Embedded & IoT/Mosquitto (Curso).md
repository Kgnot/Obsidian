---
type: course
status: en_progreso
tags: [course, Mosquitto (Curso)]
date_started: 2024-05-20
---

Una vez hemos visto el curso de RabbitMQ, que si no se ha visto se recomienda. 

Para mosquitto no he encontrado muchos cursos, estaré cogiendo la documentación junto con algunas nociones que he ido encontrando en diferentes lados.

Entrando con la documentación hay diferentes apartados que se van a tocar.

# MQTT Principal.
Al inicio nos habla sobre lo que es MQTT, ya vamos entendiendo, ya que se ha hablado de ello antes. Pero principalmente MQTT es un protocolo demensajeríaa de tipo publicador/suscriptor ligero. Esto es bastante útill para usar con sensores de baja potencia, además de ser aplicable a muchos escenarios. 

Aqui se intentará cubrir un poco de algunas de las configuraciones de MQTT version 3.1.1/.1. Para una información más completa se recomienda ir a [MQTT](http://mqtt.org)

## Publicador suscriptor 
El protocolo MQTT se basa en el principio de publicar mensajes y suscribirse a temas, o "pub/sub". Múltiples clientes se conectan a un *broker* y se suscriben a los temas que les interesan. Los clientes también se conectan al *broker* y publican mensajes en temas. Muchos clientes pueden suscribirse a los mismos temas y utilizar la información como deseen. 

El *broker* y MQTT actúan como una interfaz simple y común para que todo se conecte. Esto significa que si tienes clientes que envían mensajes suscritos a una base de datos, a Twitter, Cosm o incluso a un simple archivo de texto, entonces se vuelve muy sencillo añadir nuevos sensores u otras entradas de datos a una base de datos, Twitter, etc.

## Temas/Suscripciones 

Los mensajes en MQTT se publican en temas (topics). No es necesario configurar un tema; publicarlo es suficiente. Los temas se tratan como una jerarquía, utilizando una barra inclinada (/) como separador. Esto permite organizar de manera sensata temas comunes, de forma similar a un sistema de archivos. 

Por ejemplo, múltiples ordenadores pueden publicar la información de la temperatura de su disco duro en el siguiente tema, reemplazando el nombre del ordenador y del disco duro según corresponda: 
`sensors/COMPUTER_NAME/temperature/HARDDRIVE_NAME` 

Los clientes pueden recibir mensajes creando suscripciones. Una suscripción puede ser a un tema explícito, en cuyo caso solo se recibirán mensajes para ese tema, o puede incluir comodines. 
Hay dos comodines disponibles: `+` o `#`. - `+` se puede usar como comodín para un solo nivel de jerarquía. 

Podría usarse con el tema anterior para obtener información sobre todos los ordenadores y discos duros de la siguiente manera: 
`sensors/+/temperature/+` 

Como otro ejemplo, para un tema de "a/b/c/d", las siguientes suscripciones de ejemplo coincidirán:
```text
a/b/c/d 
+/b/c/d 
a/+/c/d 
a/+/+/d 
+/+/+/+ 
```
Las siguientes suscripciones no coincidirán:
```text
a/b/c 
b/+/c/d 
+/+/+ 
```

- `#` se puede usar como comodín para **todos los niveles restantes de la jerarquía**. Esto significa que debe ser el **último carácter** en una suscripción.
    
**Ejemplos de suscripciones que coincidirán con el tema "a/b/c/d":**

- `a/b/c/d` (Coincidencia exacta)
- `#` (Coincide con cualquier tema)
- `a/#` (Coincide con "a" y cualquier cosa que le siga)
- `a/b/#` (Coincide con "a/b" y cualquier cosa que le siga)
- `a/b/c/#` (Coincide con "a/b/c" y cualquier cosa que le siga)
- `+/b/c/#` (Coincide con un nivel cualquiera, seguido de "b/c" y cualquier cosa que le siga)

### Consideraciones sobre Niveles de Tema de Longitud Cero

Los niveles de tema de longitud cero son válidos en MQTT, lo que puede llevar a un comportamiento que no es inmediatamente obvio.

- **Nivel de longitud cero intermedio:**
    
    - Un tema como `"a//topic"` (donde hay un nivel vacío entre "a" y "topic") coincidirá correctamente con una suscripción como `"a/+/topic"`. El `+` actúa como comodín para ese nivel vacío.
- **Nivel de longitud cero al principio o al final:**
    
    - Un tema como `"/a/topic"` (que comienza con un nivel vacío) coincidirá con suscripciones como `"+/a/topic"`, `"#"` o `"/#"`.
    - Un tema como `"a/topic/"` (que termina con un nivel vacío) coincidirá con suscripciones como `"a/topic/+"` o `"a/topic/#"`.


## Calidad de Servicio (QoS) 

MQTT define tres niveles de Calidad de Servicio (QoS), que determinan el esfuerzo que el _broker_ o el cliente realizarán para asegurar la entrega de un mensaje.

Los mensajes pueden enviarse en cualquier nivel de QoS, y los clientes pueden suscribirse a temas en cualquier nivel de QoS. Es importante destacar que **el cliente elige el QoS máximo que recibirá**.

**Ejemplos de interacción de QoS:**

- Si un mensaje se publica con QoS 2 y un cliente está suscrito con QoS 0, el mensaje se entregará a ese cliente con QoS 0.
- Si un segundo cliente está suscrito al mismo tema con QoS 2, recibirá el mismo mensaje pero con QoS 2.
- Si un cliente está suscrito con QoS 2 y un mensaje se publica con QoS 0, el cliente lo recibirá con QoS 0.

En general, los niveles más altos de QoS son más fiables, pero implican mayor latencia y tienen mayores requisitos de ancho de banda.

**Los tres niveles de QoS son:**

- **0: At most once (Como máximo una vez)**: El _broker_/cliente entregará el mensaje una vez, sin confirmación de recepción.
- **1: At least once (Al menos una vez)**: El _broker_/cliente entregará el mensaje al menos una vez, requiriendo una confirmación de recepción.
- **2: Exactly once (Exactamente una vez)**: El _broker_/cliente entregará el mensaje exactamente una vez, utilizando un proceso de _handshake_ de cuatro pasos para asegurar la entrega única.

## Mensajes Retenidos 

Todos los mensajes pueden configurarse para ser retenidos. Esto significa que el *broker* mantendrá el mensaje incluso después de enviarlo a todos los suscriptores actuales. Si se realiza una nueva suscripción que coincide con el tema del mensaje retenido, entonces el mensaje se enviará al cliente. Esto es útil como mecanismo de "último valor conocido bueno". Si un tema se actualiza con poca frecuencia, sin un mensaje retenido, un cliente recién suscrito podría tener que esperar mucho tiempo para recibir una actualización. Con un mensaje retenido, el cliente recibirá una actualización instantánea. 
## Sesión Limpia / Conexiones Duraderas 

Al conectarse, un cliente establece el indicador de "sesión limpia" (clean session), que a veces también se conoce como "inicio limpio" (clean start). Si la sesión limpia se establece en `false`, la conexión se trata como duradera. Esto significa que cuando el cliente se desconecta, cualquier suscripción que tenga permanecerá y cualquier mensaje QoS 1 o 2 posterior se almacenará hasta que se conecte de nuevo en el futuro. Si la sesión limpia es `true`, todas las suscripciones se eliminarán para el cliente cuando se desconecte.
## Wills (Testamentos) 

Cuando un cliente se conecta a un *broker*, puede informarle que tiene un "testamento" (will). Este es un mensaje que desea que el *broker* envíe cuando el cliente se desconecta inesperadamente. El mensaje de testamento tiene un tema, QoS y estado de retención, al igual que cualquier otro mensaje.


# Mosquito pagina: 

En este apartado de la documentación nos dan una sinopsis de lo que es esto, primero que es un Broker MQTT. Y luego unos comandos que se pueden hacer con `mosquitto`. 
Sin embargo, aqui entraré a correr Mosquitto en docker. Entonces, en primera instancia, debemos crear una estructura de directorios básica: 
```bash
mkdir -p mosquitto/config mosquitto/data mosquitto/log
```
Luego de eso vamos a crear el archivo de `mosquitto.conf`, este es importante, ya que le dice a mosquitto algunas configuraciones. Dentro de la documentación encontramos varias que vamos a tocar más adelante.
Creamos (también nos podemos meter dentro de la carpeta y solo hacer el comando con `mosquitto.conf`): 
```bash
nano moquitto/conf/mosquitto.conf
```
El contenido minimo que recomendamos aqui es: 
```bash
listener 1883
allow_anonymous true

persistence true
persistence_location /mosquitto/data/

log_dest file /mosquitto/log/mosquitto.log
```
¿Esto qué significa?: 
- `listener 1883`: Mosquitto escucha en todas las interfaces.
- `allow_anonymous true`: permite conexiones sin usuario/clave.
- `persistence true`: guarda mensajes retenidos.
- `log_dest file`: guarda logs en archivo.
Y para iniciar en docker usamos ahora: 
```bash
docker run -d \
  --name mosquitto \
  -p 1883:1883 \
  -v $(pwd)/mosquitto/config:/mosquitto/config \
  -v $(pwd)/mosquitto/data:/mosquitto/data \
  -v $(pwd)/mosquitto/log:/mosquitto/log \
  eclipse-mosquitto
```
O para copiar y pegar: 
```bash
docker run -d --name mosquitto -p 1883:1883 -v $(pwd)/mosquitto/config:/mosquitto/config -v $(pwd)/mosquitto/data:/mosquito/data -v $(pwd)/mosquitto/log:/mosquitto/log eclipse-mosquitto
```
Esto le dice que volúmenes estamos montando, el nombre del contenedor y que corra y se ejecute en segundo plano.

>**NOTA:** 
>Recordar usar el comando de docker en la raíz de donde se coloca la carpeta `mosquitto`.

Ahora ya con esto, vamos a instalar un programa llamado `MQTT Explorer`. [Click para descargar](https://mqtt-explorer.com/).

Ahora tenemos lo que es Mosquitto corriendo y veremos algo así: 
![Pasted image 20251224183854.png](images/Pasted%20image%2020251224183854.png)

Podemos ahora simular IoT, ya sea en Python, o si tenemos una ESP32 también. 
Por ejemplo, si conecto mi ESP32 con un código que ya voy a poner, pasa lo siguiente:
![Pasted image 20251224183953.png](images/Pasted%20image%2020251224183953.png)

Cómo vemos se creó un topic: `esp32/test`. Y se publicó: "hola desde ESP32". Ya vamos a ir con ese código. 
 (Antes de aqui voy a pasarme unas semanas aprendiendo c++ de mejro forma)
