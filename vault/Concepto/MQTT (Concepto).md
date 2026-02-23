---
type: concepto
tags: [concepto, MQTT (Concepto)]
date_created: 2024-05-20
---

Primero entrando a la definición de AWS tenemos: 

MQTT es un protocolo de mensajería basado en estándares, o un conjunto de reglas, que se utiliza para la comunicación de un equipo a otro. Los sensores inteligentes, los dispositivos portátiles y otros dispositivos de Internet de las cosas (IoT) generalmente tienen que transmitir y recibir datos a través de una red con recursos restringidos y un ancho de banda limitado. Estos dispositivos IoT utilizan MQTT para la transmisión de datos, ya que resulta fácil de implementar y puede comunicar datos IoT de manera eficiente. MQTT admite la mensajería entre dispositivos a la nube y la nube al dispositivo.

# ¿Qué es lo importante del protocolo?
El protocolo se ha convertido en un estándar para la transmisión de datos de IoT, ya que ofrece beneficios tales como: 
- Ligero y eficiente
- Escalable
- Fiable
- Seguro (Cifrado y autenticación modernos como OAuth)
- Admitido (Gran soporte)

# ¿Cuál es el principio?
El protocolo MQTT funciona según el modelo de publicación o suscripción, esto hace que se desacople el remitente del mensaje (publicador) del receptor del mensaje (suscriptor). Para ello un tercer componente denominado agente de mensajes, controla la comunicación entre publicadores y suscriptores. La forma en que se desacopla es de la siguiente manera: 
#### ****_Desacoplamiento espacial_****

El publicador y el suscriptor no conocen la ubicación de la red del otro y no intercambian información como direcciones IP o números de puerto.

#### ****_Desacoplamiento de tiempo_****

El publicador y el suscriptor no se ejecutan ni tienen conectividad de red al mismo tiempo.

#### ****_Desacoplamiento de sincronización_****

Tanto los publicadores como los suscriptores pueden enviar o recibir mensajes sin interrumpirse entre sí. Por ejemplo, el suscriptor no tiene que esperar a que el publicador envíe un mensaje.


# ¿Cuáles son los componentes MQTT?

MQTT implementa el modelo, como ya sabemos, de publicación y suscripción mediante la definición de clientes y agentes:
## Cliente MQTT: 
Un cliente MQTT es cualquier dispositivo, desde un servidor hasta un microcontrolador, que ejecuta una biblioteca MQTT. Si el cliente envía mensajes, actúa como editor (publicador) y si recibe mensajes, actúa como receptor (suscriptor). Básicamente, cualquier dispositivo que se comunique mediante MQTT a través de una red puede denominarse dispositivo cliente MQTT
## Agente MQTT:
El agente MQTT es el sistema _back-end_ que coordina los mensajes entre los diferentes clientes. La responsabilidad que tiene son de filtrar mensajes, identificar cuáles son los clientes suscritos a cada mensaje y enviarle los mensajes, también tiene tareas como la autorización y autenticación de clientes MQTT, pasar el mensaje a otros sistemas para un posterior análisis y el control de mensajes perdidos y sesiones de clientes. 
## Conexiones
Los clientes y los agentes comienzan a comunicarse mediante una conexión MQTT. Los clientes inician la conexión al enviar un mensaje "CONECTAR" al agente MQTT. El agente confirma que se ha conectado o se ha establecido esa conexión al responder con un mensaje "CONNACK". Tanto el cliente MQTT como el agente requieren una pila TCP o IP para comunicarse. Los clientes nunca se conectan entre sí, solo con un agente.

# Agentes / Broker MQTT:
Un agente MQTT, también conocido como broker, es un servidor central que coordina la comunicación entre los clientes en un sistema de mensajería basado en el modelo publicación/suscripción.

Cómo diferentes tipos de agentes o brokers tenemos: 

## Mosquitto
Uno de los brokers de código abierto más usados, ideal para proyectos IoT y makers debido a la ligereza y facilidad de uso
***
Para mayor información entrar [aquí, curso]([[Mosquitto (Curso)]])

## EMQX

## RabbitMQ

RabbitMQ es principalmente un sistema de mensajería empresarial para aplicaciones distribuidas. Por ejemplo:
### Casos de uso: 
#### 1. Comunicación entre microservicios
Desacopla servicios: un servicio publica mensajes, otro los consume
#### 2. Colas de trabajo:
Distribuir tareas pesadas entre múltiples workers (es simplemente un programa o microservicio que se dedica a consumir mensajes de una cola y procesarlos). Por ejemplo, procesamiento de imágenes, envío de emails masivos y así.
#### 3. Publicar/Suscribir (Pub/Sub)
Un productor publica, múltiples consumidores reciben
#### 4. Balanceo de carga
Distribuye mensajes equitativamente entre consumidores
#### 5. Tolerancia a fallos
Los mensajes persisten hasta que son procesados

### Otros casos
Imaginemos el caso en el que queramos manejar microservicios con IOT, para ciertas cosas, quizá cámaras, sensores, actuadores que necesiten procesamiento de imagen, datos, alertas, etc. Puede pensarse como una combinación entre Mosquitto y RabbitMQ o Kafka haciendo de Mosquitto un router para los demás, solo de ser necesario, aunque ese caso es algo extraño, ya que un cliente en Mosquitto podría llegar a ser un microservicio
***
Para más de RabbitMQ entrar [aqui]([[RabbitMQ (Curso)]]) . Es el curso de RabbitMQ
## NanoMQ