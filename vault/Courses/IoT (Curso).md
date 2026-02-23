---
type: course
status: en_progreso
tags: [course, IoT (Curso)]
date_started: 2024-05-20
---

El curso de IoT va a estar con diferentes apartados y fases.
***
# Fase 1: Fundamentos IoT

El IoT como lo dice el nombre es el internet de las cosas, es la interconexión de dispositivos cotidianos interconectada desde internet, como el control de cámaras desde un celular o computadora, o también variedad de electrodomésticos que trasmiten datos hacía internet, hace que los dispositivos se comuniquen entre sí y también con nosotros.
## Conceptos Core: 
### Arquitectura:
La arquitectura que se toma para un sistema IoT se divide en cuatro o cinco capas:

![kskkwto3gkhej4ghw-layers-of-iot-architecture.avif](images/kskkwto3gkhej4ghw-layers-of-iot-architecture.avif)
#### Capa de percepción:

La capa de percepción interactúa con el terreno físico para recopilar datos sin procesar. Dispositivos conectados al IoT, como sensores y cámaras, recopilan pasivamente información e imágenes que se comunicarán a través de la capa de transporte (por ejemplo la capa de red) mientras que los actuadores instruyen a los dispositivos para que realicen tareas basándose en datos de sensores o comandos adicionales dentro de los sistemas IoT. (Los actuadores son dispositivos de hardware que convierten la energía en movimiento).

Esta también es llamada como la capa de dispositivo, ya que incluye dispositivos, sensores y actuadores que recopilan información del entorno.
#### Capa de transporte | red | comunicaciones

Esta capa es la responsable del flujo de los datos y la transferencia de estos entre los sensores en la capa de percepción (dispositivos) y la capa procesamiento a través de varias redes. También es la encargada de transportar los datos desde los dispositivos a internet, esto depende un poco de la idea deseada, a menudo mediante una puerta de enlace (gateway) que puede realizar procesamiento adicional y a menudo agrega comunicaciones con numerosos dispositivos y periféricos. 

#### Capa de procesamiento (ingesta a la nube y almacenamiento)

Esta capa de procesamiento de datos, también denominada como middleware, almacena, analiza y preprocesa los datos procedentes dela capa de transporte. Esto incluye actividades como la agregación de datos, la traducción de protocolos y la aplicación de la seguridad para preparar los datos para la capa de aplicación.  Esta capa se ubica en la puerta de enlace (gateway) o en la nube.

Los proveedores de plataformas en la nube como AWS, Azure y otros ofrecen servicios específicos para el IoT que permiten la ingestión y el enrutamiento del flujo de datos a la nube. Esto proporciona una potencia adicional de procesamiento/enrutamiento que facilita la gestión y el almacenamiento de estos datos, así como la ampliación de la infraestructura a medida que crece el número de dispositivos implementados.

#### Capa de aplicación:

La capa de aplicación contiene aplicaciones de software que utilizan los datos preprocesados recopilados en la capa de percepción para completar tareas o extraer información mediante análisis avanzados. Bases de datos, almacenes de datos y lagos de datos se incluyen en la capa de aplicación. No siempre la base de datos se incluye de forma para "guardar datos", ya que la capa de procesamiento también se encarga de eso; sin embargo, puede estar aqui como forma de la aplicación que se desea.

#### Capa de negocio:

La capa de negocio es probablemente la capa más común de la arquitectura IoT, ya que abarca interfaces de usuario, paneles de control y herramientas de visualización de datos que la mayoría de los profesionales de negocios utilizan a diario. A veces se combina esta capa con la de aplicación, etc. Entre más capas más detallado y entre menos capas existe menos detalle, pero todas describen el mismo proceso

#### Las 4 capas juntas: 

En esta arquitectura la manera en que todas se combinan está descrita de la siguiente forma: 
- **Capa del dispositivo:** Un sensor de temperatura toma lecturas de temperatura dentro de un refrigerador.
- **Capa de comunicaciones:** las lecturas se envían a un enrutador o un dispositivo de enlace a través de un protocolo LoRa propietario y se envían a la nube a través de una red celular.
- **Capa de almacenamiento y procesamiento de datos:** la nube almacena y procesa los datos entrantes para generar alertas en tiempo real y, cuando sea posible, reducir la cantidad total de datos almacenados.
- **Capa de aplicación:** la nube genera informes y análisis para los usuarios finales de las aplicaciones y el mantenimiento de registros, a través de interfaces web y entrega por correo electrónico.

Y par aún sistema de 4 capas puede ser visto de esta forma: 
![kskkvyrt1mnkzgasi-stages-iot-architecture.png.avif](images/kskkvyrt1mnkzgasi-stages-iot-architecture.png.avif)




### Utiles:

Alguno de los conceptos utiles en este mundo del IoT esta: 
- Device: Hace referencia a los dispositivos
- Gateway: Es quien maneja la puerta de enlace con internet
- Broker: Es un servidor central que actúa como intermediario (Middleware) para la comunicación entre dispositivos, utilizando el modelo de publicación/subscripción. 
- Digital Twin: Un gemelo digital es un modelo virtual de un objeto físico. Abarca el ciclo de vida del objeto y utiliza los datos en tiempo real enviados por los sensores del objeto para simular el comportamiento y supervisar las operaciones. Los gemelos digitales pueden replicar varios elementos del mundo real, desde piezas individuales de un equipo en una fábrica hasta instalaciones completas, como turbinas eólicas e incluso ciudades enteras. La tecnología de gemelos digitales permite supervisar el rendimiento de un activo, identificar posibles fallos y tomar decisiones mejor fundamentadas en cuanto al mantenimiento y el ciclo de vida

### Patrones de diseño IoT:
#### Digital Twins:
Un _digital twin_ (gemelo digital) es una representación virtual de un dispositivo, sistema o entorno físico que reproduce su comportamiento en tiempo real o casi real. Este gemelo permite simular, monitorear y analizar cómo funciona algo sin necesidad de tenerlo físicamente, lo que facilita pruebas, diagnósticos y optimización. En el contexto de IoT, los digital twins son modelos digitales conectados mediante protocolos como MQTT, HTTP o CoAP, capaces de reflejar estados, sensores, actuadores y flujo de datos igual que un dispositivo real. Estos modelos son fundamentales para desarrollar soluciones IoT sin hardware, optimizar redes complejas y visualizar el funcionamiento de sistemas antes de implementarlos en el mundo físico.

Estos se pueden simular con Python y luego encapsular en un contenedores de docker para crear una red grande de IoT, esto es importante de tener en cuenta.

Otra de las formas para crear ese tipo de simulaciones nos la presta ya grandes empresas como lo es AWS o Google mediante Google Cloud, para tener más información frente a lo de AWS tenemos el siguiente video que sirve mucho de apoyo; sin embargo, hay que pagar: [video](https://www.youtube.com/watch?v=agct8xAFwrs).

#### Message Broker Patterns:
Antes de entrar a los patrones de mensajerías por broker vamos a ver protocolos, estos conceptos se van a abrir mucho más dentro de los links a los conceptos dados.
##### MQTT:
El protocolo MQTT es un protocolo de mensajería basado en estándares, o u conjunto de reglas, que se utiliza para la comunicación de un equipo a otro. Los sensores inteligentes, los dispositivos portátiles y otros dispositivos de Internet de las cosas (IoT) generalmente tienen que trasmitir o recibir datos a través de una red con recursos restringidos y un ancho de banda limitado. Estos dispositivos IoT utiliza MQTT para la transmisión de datos, ya que resulta fácil de implementar y puede comunicar datos IoT de manera eficiente. MQTT admite la mensajería entre dispositivos a la nube y la nube a dispositivos. Para más información [[MQTT (Concepto)]]
##### CoAP
##### AMQP:
##### HTTP/2
##### gRCP
#### Event Sourcing telemetría:
#### CQRS para datos de dispositivos:


# Bibliografía
- [Mongo DB IoT](https://www-mongodb-com.translate.goog/resources/basics/cloud-explained/iot-architecture?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc&_x_tr_hist=true)
- [Zipit IoT](https://www-zipitwireless-com.translate.goog/blog/4-layers-of-iot-architecture-explained?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc)
- [Digital twin aws](https://aws.amazon.com/es/what-is/digital-twin/)
- [AWS - mqtt](https://aws.amazon.com/es/what-is/mqtt/)
- 