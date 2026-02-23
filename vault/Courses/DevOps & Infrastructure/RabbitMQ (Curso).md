---
type: course
status: en_progreso
tags: [course, RabbitMQ (Curso)]
date_started: 2024-05-20
---

Página oficial: https://www.rabbitmq.com/
Documentación: https://www.rabbitmq.com/docs
***
RabbitMQ es un agente de mensajería de código abierto que permite la comunicación asíncrona y fiable entre diferentes aplicaciones. Funciona como un intermediario que recibe y enruta mensajes, facilitando el desacoplamiento de procesos y mejorando la escalabilidad y resistencia de los sistemas.
# Instalación
Dentro de la documentación encontramos el cómo podemos instalarlo usando docker, asi que: 
```cmd
# latest RabbitMQ 4.x
docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:4-management
```

si es en windows recomendamos tener esto activo :
![Pasted image 20251204180323.png](../images/Pasted%20image%2020251204180323.png)
Luego de eso si aplicamos el comando de docker.
Ahora explicamos que hace el comando:

| parte                   | significado                         |
| ----------------------- | ----------------------------------- |
| `docker run`            | Ejecutar el contenedor              |
| `-it`                   | Modo interactivo + terminal         |
| `--rm`                  | Se borra al detenerlo               |
| `--name rabbitmq`       | Nombre del contenedor               |
| `-p 5672:5672`          | Puerto AMQP                         |
| `-p 15672:15672`        | Panel web                           |
| `rabbitmq:4-management` | Imagen de rabbitMQ con interfaz web |
***
Una vez descargado tenemos lo que es la interfaz interactiva: 
![Pasted image 20251204181120.png](images/Pasted%20image%2020251204181120.png)
![Pasted image 20251204182305.png](images/Pasted%20image%2020251204182305.png)
Dentro de la documentación también nos comenta como instalarlo en diferentes entornos, no solo docker. 
***
Para poder observar de forma visual el RabbitMQ, podemos ir al `localhost:15672` este nos dirige al apartado visual donde el usuario y contraseña son `guest`.
![Pasted image 20251204204423.png](images/Pasted%20image%2020251204204423.png)

# RabbitMQ Tutorial principiante :
Link: https://www.rabbitmq.com/tutorials
La documentación nos entrega un tutorial de los conceptos básicos de creación de aplicaciones de mensajería usando RabbitMQ. Lo divide en dos tipos de tutoriales.
## Queue tutorial (Cola)
En esta sección se cubrirá el protocolo por defecto que usa RabbitMQ, AMQP 0-9-1.
Este tutorial se hará desde Java, sin embargo, tiene diferentes lenguajes en el tutorial para poder ser creado.

==Nos menciona una notación para algunos diagramas, nos comenta sobre una letra P para los **productores** que es nada más que alguien envió.== Luego tenemos la **cola** o **queue** que es le nombre de la caja de posteo en RabbitMQ y aunque los mensajes fluyen a través de RabbitMQ y sus aplicaciones, solo se puede almacenar dentro de una cola. Una cola solo está limitada por el espacio en el disco del Host, es esencialmente un gran buffer de mensajes.

Muchos productores pueden enviar mensajes que van a una cola, y muchos consumidores pueden recibir información de una cola.

Luego tenemos lo que son los consumidores y es muy similar a lo que significa ser un recibidor, un consumidor es un programa que generalmente espera recibir mensajes.

![Pasted image 20251204200956.png](images/Pasted%20image%2020251204200956.png)
Debemos notar que ninguno de los 3, ni el consumidor, productor ni la cola, residen en el mismo host, y de hecho por lo general nunca se hace..

### Creando nuestro primer HOLA MUNDO

Vamos a usar el cliente de java, para esta parte del tutorial se tiene escrito dos programas de java, un productor que envia los mensajes y un consumir que los recibe y los imprime. 
Usaremos la siguiente dependencia: 
```xml
<dependency>
    <groupId>com.rabbitmq</groupId>
    <artifactId>amqp-client</artifactId>
    <version>5.27.1</version>
</dependency>
```
Y las dependencias de `SLF4J API` y `SLF4J Simple`.
***
En el código se dividió en dos, `cliente1` que es quien envía y el `cliente2` que es quien recibe.

Código del cliente 1: 
```java
package org.patterns;  
  
  
import com.rabbitmq.client.Channel;  
import com.rabbitmq.client.Connection;  
import com.rabbitmq.client.ConnectionFactory;  
  
import java.io.IOException;  
import java.util.concurrent.TimeoutException;  
  
public class Main {  
  
    private static final String QUEUE_NAME = "hello";  
  
    public static void main(String[] args) {  
  
        ConnectionFactory factory = new ConnectionFactory();  
        // el host lo podemos cambiar por una ip diferente o un hostname diferente  
        factory.setHost("localhost");  
        try(Connection connection = factory.newConnection()){  
            // creamos el canal  
            Channel channel = connection.createChannel();  
            // luego declaramos un mensaje a publicar  
            channel.queueDeclare(QUEUE_NAME,false,false,false,null);  
            String message = "Hola desde Cliente1";  
            channel.basicPublish("",QUEUE_NAME,null,message.getBytes());  
            System.out.println("[x] Sent: '"+message+"'");  
            /// Cosas que debemos tener en cuenta y es que declarar una Queue o cola es idempotente, solo se crea si no existe  
            /// y el mensaje se manda por bytes por lo que puedes mandar lo que quieras, es decir debe ser serializable.  
  
        } catch (IOException e) {  
            throw new RuntimeException("IOException: "+e);  
        } catch (TimeoutException e) {  
            throw new RuntimeException("TimeoutException: "+e);  
        }  
  
  
    }  
}
```
Código del cliente 2:
```java
package org.patterns;  
  
import com.rabbitmq.client.Channel;  
import com.rabbitmq.client.Connection;  
import com.rabbitmq.client.ConnectionFactory;  
import com.rabbitmq.client.DeliverCallback;  
  
import java.io.IOException;  
import java.nio.charset.StandardCharsets;  
import java.util.concurrent.TimeoutException;  
  
public class Main {  
  
    private final static String QUEUE_NAME = "hello";  
    /*  
     * ¿Por qué no utilizamos una instrucción try-with-resource para cerrar automáticamente el canal     * y la conexión? Al hacerlo, simplemente haríamos que el programa continuara, cerrara todo  
     * y saliera. Esto sería incómodo porque queremos que el proceso permanezca activo     * mientras el consumidor escucha de forma asíncrona la llegada de mensajes.     * */  
  
    public static void main(String[] args) throws IOException, TimeoutException {  
        ConnectionFactory factory = new ConnectionFactory();  
        factory.setHost("localhost");  
        Connection connection = factory.newConnection();  
        Channel channel = connection.createChannel();  
  
        channel.queueDeclare(QUEUE_NAME, false, false, false, null);  
        System.out.println("[*] Wait for messages. To exit press CTRL+C");  
        DeliverCallback deliverCallback = (consumerTag, delivery) -> {  
            String message = new String(delivery.getBody(), StandardCharsets.UTF_8);  
            System.out.println("[x] Recibido: " + message);  
        };  
        channel.basicConsume(QUEUE_NAME, true, deliverCallback,consumerTag -> {});  
    }  
}
```
***
Al correrlos obtenemos esto: 
![Pasted image 20251204205258.png](images/Pasted%20image%2020251204205258.png)

La primera imagen es antes y la segunda es despues, la imagen de ambos corriendo fue la siguiente: 
![Pasted image 20251204205327.png](images/Pasted%20image%2020251204205327.png)
Algo que es necesario es descargar el `slf4j` o agregarlo en el maven.
Lo más importante es que la cola se cargó con el nombre que se le había colocado (==hello==): 
![Pasted image 20251204205447.png](images/Pasted%20image%2020251204205447.png)

Y en el docker desktop se puede observar: 
![Pasted image 20251204205717.png](images/Pasted%20image%2020251204205717.png)
Que en efecto se envia , se abre y se cierra una conexion mientras una permanece abierta.
### Work Queues
(Usando java client)
En el primer apartado nosotros escribimos un programa que enviaba y recibía mensajes de una queue nombrada. En este vamos a crear un trabajo de cola o un `Work Queue` que será usada para distribuir tareas que requieren mucho tiempo entre varios `workers`.
En palabras de la documentación: 
"La idea principal detrás de las colas de trabajo (también conocida como: colas de tareas) es evitar hacer una tarea intensiva en recursos de inmediato y tener que esperar a que se complete. En su lugar, programamos la tarea que se realizará más adelante. Encapsulamos una tarea como mensaje y la enviamos a una cola. Un proceso de trabajo que se ejecuta en segundo plano hará estallar las tareas y, finalmente, ejecutará el trabajo. Cuando se ejecutan muchos trabajadores, las tareas se compartirán entre ellos." 

Lo que estamos haciendo aqui es que la cola de trabajo es un patrón donde: 
1. Un productor publica tareas (mensajes) en una cola.
2. Uno o varios workers (pueden ser microservicios/scripts/contenedores/servicio de Linux/etc.) consumen las tareas de esa cola y la procesan.
3. Cada tarea la toma UN SOLO WORKERS, no varios
4. Si hay muchos `workers` RabbitMQ balancea la tarea entre ellos
El objetivo principal es **no hacer el trabajo pesado en el momento**, sino **delegarlo** a procesos especializados que lo harán en segundo plano.

Este concepto es especialmente útil en aplicaciones web donde es imposible manejar una tarea compleja durante una breve ventana de solicitud HTTP.

#### Preparación:
Para esta preparación solo se mostrará que este work queues es algo que viene ya incluido. Es decir, imaginemos una tarea grande, y para simularla usaremos el siguiente método: 
```java
private static void doWork(String recibido) throws InterruptedException {  
    for (char a : recibido.toCharArray()) {  
        if (a == '.') Thread.sleep(1000);  
    }  
}
```
Esto nos da la idea de que hay tareas que se demora más o menos. Entonces nuestro servicio que recibe los eventos es: 
```java
DeliverCallback deliverCallback = (consumerTag, delivery) -> {  
    String message = new String(delivery.getBody(), StandardCharsets.UTF_8);  
    // aqui vamos a agregar tareas más pesadas simulando con un sleep:  
    try {  
        doWork(message);  
    } catch (InterruptedException e) {  
        throw new RuntimeException(e);  
    } finally {  
        System.out.println("[x] Done ");  
    }  
    System.out.println("[x] Recibido: " + message);  
};
```
El `doWork` es quien nos dice que una tarea dura más o menos, y en el apartado que envia solo debemos ponerle '.' a los mensajes para que sea una tarea pesada o menos pesada. Generando lo siguiente: 
![Pasted image 20251205113309.png](images/Pasted%20image%2020251205113309.png)
Con eso vemos que sin importar cuanto dure una tarea siempre queda en la cola, y se realiza poco a poco. 

#### Round Robin Dispatching:
Una de las ventajas que nosotros tenemos es que "reparte" las cargas de los mensajes a todos los trabajadores, imaginemos lo siguiente, una serie de tareas no dependientes que se necestian realizar y le pasamos una serie de trabajadores que van a realizarla, cada trabajador obtiene una tarea y la realiza, esto mismo hace RabbitMQ, por ejemplo tengamos lo siguiente, tres trabajadores : 
![Pasted image 20251205131445.png](images/Pasted%20image%2020251205131445.png)
Y en el código de quien envía la petición: 
```java
List<String> lista = List.of(  
        "Trabajo1",  
        "TRabajo2",  
        "Trabajo3",  
        "Trabajo4"  
);  
for(var msg : lista){  
    channel.basicPublish("",QUEUE_NAME,null,msg.getBytes());  
    System.out.println("[x] Sent: '"+msg+"'");  
}
```
Con esto publicamos varios al tiempo, ahora bien, a la hora de publicarlos: 
1. vemos que se envía correctamente: 
	![Pasted image 20251205131604.png](images/Pasted%20image%2020251205131604.png)
2. Observamos que cambio tuvieron los trabajadores:  
	![Pasted image 20251205131640.png](images/Pasted%20image%2020251205131640.png)
Ahora imaginemos 100 tareas mandandose en paralelo: 
```java
List<String> lista = generadorTareas(); //genera 100 tareas 
lista.stream().parallel().forEach(msg -> {  
    try {  
        channel.basicPublish("", QUEUE_NAME, null, msg.getBytes());  
    } catch (IOException e) {  
        throw new RuntimeException(e);  
    }  
    System.out.println("[x] Sent: '" + msg + "'");  
});
```
Obtenemos esto: 
![Pasted image 20251205132253.png](images/Pasted%20image%2020251205132253.png)
Por lo que podemos ver que se les envía toda la cola, y se divide entre los diferentes trabajadores o workers. Que pueden ser instancias de lo que sea. 
#### Reconocimiento de Mensajes (Message acknowledgment):

Imaginemos que tenemos un sistema de mensajería donde: 
1. Un productor envia mensajes a RabbitMQ
2. RabbitMQ los guarda en una cola
3. Un consumidor los recibe y procesa
Nos hacemos la pregunta de: ¿Qué pasaría si el consumidor muere durante el procesamiento? 
Imaginemos el siguiente pipeline: 
![Pasted image 20251205160220.png](images/Pasted%20image%2020251205160220.png)
Claramente no nos favorece que suceda, para que no pase RabbitMQ nos brinda "Reconocimiento de Mensajes" (ack). Un reconocimiento es algo que se le envía a RabbitMQ diciéndose que el mensaje ya fue recibido, procesado y que RabbitMQ es libre de liberarlo.
Si un consumidor muere sin enviar el reconocimiento o "ack", entonces se entenderá como que el mensaje no fue procesado completamente y lo volverá a encolar.
Los reconocimientos de los mensajes están activados de forma predeterminada. En ejemplos anteriores los desactivamos explícitamente a través de la bandera `autoAck=true`. Es hora de poner esta bandera en falso y enviar un reconocimiento adecuado del trabajador, una vez que hayamos terminado con una tarea.

En el ejemplo que propone la documentación tenemos lo siguiente: 
```java
channel.basicQos(1); // Hey , solo dame un mensaje a la vez

DeliverCallback deliverCallback = (consumerTag, delivery) -> {
  String message = new String(delivery.getBody(), "UTF-8");

  System.out.println(" [x] Received '" + message + "'");
  try {
                // Procesamiento LARGO (riesgo de falla)
                doWork(message);
                
                // SOLO SI TODO SALIÓ BIEN: CONFIRMO
                System.out.println(" [x] Procesamiento COMPLETO");
                channel.basicAck(delivery.getEnvelope().getDeliveryTag(), false);
                
            } catch (Exception e) {
                System.err.println(" [x] ERROR procesando: " + e.getMessage());
                
                // SI HUBO ERROR: RECHAZO Y REENCOLO
                // Parámetros: deliveryTag, multiple, requeue
                channel.basicNack(delivery.getEnvelope().getDeliveryTag(), false, true);
            }
};
boolean autoAck = false; // No quiero AUTOmatic ACKknwledgment . Lo manejaré yo
channel.basicConsume(TASK_QUEUE_NAME, autoAck, deliverCallback, consumerTag -> { });
```
Para entender un poco más el asunto miremos esto, `basicAck` necesita dos cosas: 
```java
// Firma del método:
void basicAck(long deliveryTag, boolean multiple) throws IOException;

// 1. deliveryTag: ID único de la entrega
// 2. multiple: si confirma múltiples mensajes
```
Y nosotros le estamos pasando el `delivery.getEnvelope().getDeliveryTag()` esto es un número secuencial que RabbitMQ asigna a cada mensaje entregado. Un flujo de como se podria esperar comportar este proceso es el siguiente: 
![Pasted image 20251205181316.png](images/Pasted%20image%2020251205181316.png)
En código se vería algo de esta forma: 
```java 
DeliverCallback deliverCallback = (consumerTag, delivery) -> {  
	String message = new String(delivery.getBody(), StandardCharsets.UTF_8);  
	long deliveryTag = delivery.getEnvelope().getDeliveryTag();  

	System.out.println("[x] Recibido: " + message);  

	try {  
		doWork(message);  
		// Si no hay errores, confirma  
		channel.basicAck(deliveryTag, false);  
		System.out.println("[x] Procesado OK: " + message);  

	} catch (Exception e) {  
		System.out.println("[x] Error, reencolando: " + message);  
		// Rechazar y reencolar (true al final = reencolar)  
		channel.basicNack(deliveryTag, false, true);  
	}  
};  

boolean autoAck = false; // Nosotros hacemos el ACK manual  
channel.basicConsume(QUEUE_NAME, autoAck, deliverCallback, consumerTag -> {});  
}  
```
Y como respuestas tenemos lo siguiente: 
![Pasted image 20251205183417.png](images/Pasted%20image%2020251205183417.png)
##### Forgotten Acknowledgment - Explicación
Un "Forgotten Acknowledgment" ocurre cuando configuras `autoAck = false` (para control manual) pero olvidas llamar a `basicAck()` después de procesar un mensaje. RabbitMQ entrega el mensaje, pero nunca recibe confirmación de que fue procesado, por lo que el mensaje queda en estado "unacknowledged" (no confirmado).

Tiene consecuencias graves como por ejemplo -> 
1. **Memoria consumida**: RabbitMQ no puede liberar mensajes no confirmados
2. **Reenvíos aleatorios**: Si el consumidor se cae, RabbitMQ reenvía los mensajes
3. **Bloqueo de cola**: Mensajes quedan atrapados, no disponibles para otros consumidores
Podemos monitorear con esto: 
```cmd
rabbitmqctl list_queues name messages_ready messages_unacknowledged
```
la mejor práctica que podemos hacer es generar un límite de mensajes sin ACK simultáneamente:
```java
// Limita cuántos mensajes pueden estar sin ACK simultáneamente
channel.basicQos(10); // Máximo 10 mensajes sin confirmar

// Con prefetch de 1, es más fácil debuggear problemas
channel.basicQos(1); // Solo 1 mensaje sin ACK a la vez
```
#### Durabilidad de un mensaje
Hemos aprendido sobre como sé intercambiar eventos o mensajes entre varios clientes mediante RabbitMQ y como asegurar que este se consuma incluso si el consumidor muere. Pero nuestras tareas en RabbitMQ se pierden si RabbitMQ para. 
Cuando RabbitMQ se cierra o se rompe este olvidará las colas y los mensajes, a menos que le digas que no, dos cosas son requeridas para que estos mensajes no se pierdan: ==Nosotros necesitamos marcar tanto la cola como los mensajes como "durable"==.

Primero, necesitamos asegurar que la cola sobreviva a un reinicio del nodo de RabbitMQ, en este orden de ideas necesitamos declarar que sea durable, de la siguiente forma: 

```java
boolean durable = true;
channel.queueDeclare("hello",durable,false,false,null);
```
Recordemos que `hello` es el nombre de nuestra cola.
Aunque este comando es correcto por sí mismo, este no funcionara en nuestra configuración actual. ¿Por qué?, porque nosotros tenemos ya definidos una cola llamada `hello` el cual NO es durable. RabbitMQ no puede redefinir una cola existente con parámetros diferentes y podría retornar un error a cualquier programa que intente esto. 

Pero claramente aqui hay una solución rápida y diferente, vamos a declarar una cola con un nombre diferente, por ejemplo: 
```java
boolean durable = true;
channel.queueDeclare("task_queue", durable, false, false, null);
```
Este método de `queueDeclare` cambia lo necesario para aplicar a tanto productores como consumidores el código.

En este punto nosotros estamos asegurando que la cola `task_queue` no va a perder datos incluso si se reinicia. Ahora nosotros necesitamos marcar nuestros mensajes como persistentes
- Mediante la configuración de `MessageProperties` (Que implementa `BasicProperties`) en el valor de `PERSISTENT_TEXT_PLAIN`.
```java
	import com.rabbitmq.client.MessageProperties;

channel.basicPublish("", "task_queue",
            MessageProperties.PERSISTENT_TEXT_PLAIN,
            message.getBytes());
```
#### Envío justo: 

También llamado Fair dispatch. 
Es posible que haya notado que el envío todavía no funciona exactamente como queríamos.
Por ejemplo, en una situación con dos trabajadores, cuando todos los mensajes extraños son pesados e incluso los mensajes son ligeros, un trabajador estará constantemente ocupado y el otro apenas hará ningún trabajo. Bueno, RabbitMQ no sabe nada de eso y seguirá enviando mensajes de manera uniforme.

Esto sucede porque RabbitMQ solo envía un mensaje cuando el mensaje entra en la cola. No se fija en la cantidad de mensajes no reconocidos para un consumidor. Simplemente envía ciegamente cada n-ésimo mensaje al n-ésimo consumidor.
![Pasted image 20251205203353.png](images/Pasted%20image%2020251205203353.png)
Para quitar este problema nosotros podemos usar el método`basicQos` con la configuración `prefetchCount` = `1`. Esto le dice a RabbitMQ que no le dé más de un mensaje a un worker al mismo tiempo, por decirlo así, no entregue más mensajes a un trabajador (Worker) a menos que este haya terminado y reconocido previamente, en cambio, le mandara mensajes a quien no esté ocupado. Entonces: 
```java
int preferchCount = 1;
channel.basicQos(prefetchCount);
```
> Como una nota debemos tener en cuenta que si todos los workers están ocupados, nuestra cola podría llenarse. Así que necesitaremos estar truchas y probablemente adicionar más workers o usar alguna otra estrategia.

#### Poniendo todo junto:
Aqui ya vamos a observar el código completo de cómo quedaría todo junto
```java 
///------------ EL WOERKER------------------
package org.patterns;  
  
import com.rabbitmq.client.*;  
import java.io.IOException;  
import java.nio.charset.StandardCharsets;  
import java.util.concurrent.TimeoutException;  
  
public class Main {  
  
    private final static String QUEUE_NAME = "hello";  
  
    public static void main(String[] args) throws IOException, TimeoutException {  
        ConnectionFactory factory = new ConnectionFactory();  
        factory.setHost("localhost");  
        Connection connection = factory.newConnection();  
        Channel channel = connection.createChannel();  
  
        channel.queueDeclare(QUEUE_NAME, false, false, false, null);  
        System.out.println("[*] Esperando mensajes. CTRL+C para salir");  
        channel.basicQos(1); // solo recibiremos de a uno  
        DeliverCallback deliverCallback = (consumerTag, delivery) -> {  
            String message = new String(delivery.getBody(), StandardCharsets.UTF_8);  
            long deliveryTag = delivery.getEnvelope().getDeliveryTag();  
  
            System.out.println("[x] Recibido: " + message);  
  
            try {  
                doWork(message);  
                // Si no hay errores, confirma  
                channel.basicAck(deliveryTag, false);  
                System.out.println("[x] Procesado OK: " + message);  
  
            } catch (Exception e) {  
                System.out.println("[x] Error, reencolando: " + message);  
                // Rechazar y reencolar (true al final = reencolar)  
                channel.basicNack(deliveryTag, false, true);  
            }  
        };  
  
        boolean autoAck = false; // Nosotros hacemos el ACK manual  
        channel.basicConsume(QUEUE_NAME, autoAck, deliverCallback, consumerTag -> {});  
    }  
  
    private static void doWork(String recibido) throws InterruptedException {  
        for (char a : recibido.toCharArray()) {  
            if (a == '.') Thread.sleep(1000);  
        }  
    }  
}
```
```java
///-------------------El que envía ----------------------
package org.patterns;  
  
  
import com.rabbitmq.client.Channel;  
import com.rabbitmq.client.Connection;  
import com.rabbitmq.client.ConnectionFactory;  
  
import java.io.IOException;  
import java.util.ArrayList;  
import java.util.List;  
import java.util.concurrent.TimeoutException;  
  
public class Main {  
  
    private static final String QUEUE_NAME = "hello";  
  
    public static void main(String[] args) {  
  
        ConnectionFactory factory = new ConnectionFactory();  
        // el host lo podemos cambiar por una ip diferente o un hostname diferente  
        factory.setHost("localhost");  
        try (Connection connection = factory.newConnection()) {  
            // creamos el canal  
            Channel channel = connection.createChannel();  
            // luego declaramos un mensaje a publicar  
            channel.queueDeclare(QUEUE_NAME, false, false, false, null);  
            List<String> lista = generadorTareas();  
            lista.stream().parallel().forEach(msg -> {  
                try {  
                    channel.basicPublish("", QUEUE_NAME, null, msg.getBytes());  
                } catch (IOException e) {  
                    throw new RuntimeException(e);  
                }  
                System.out.println("[x] Sent: '" + msg + "'");  
            });  
            /// Cosas que debemos tener en cuenta y es que declarar una Queue o cola es idempotente, solo se crea si no existe  
            /// y el mensaje se manda por bytes por lo que puedes mandar lo que quieras, es decir debe ser serializable.        } catch (IOException e) {  
            throw new RuntimeException("IOException: " + e);  
        } catch (TimeoutException e) {  
            throw new RuntimeException("TimeoutException: " + e);  
        }  
    }  
  
    public static List<String> generadorTareas() {  
        List<String> t = new ArrayList<>();  
        while (t.size() < 3) {  
            t.add(".....Trabajo + " + (t.size() + 1));  
        }  
        return t;  
    }  
}
```


### Publish/Subscribe
Dentro de la documentación los requisitos para esto es tener RabbitMQ instalado y correr en localhost en el puerto estándar 5672.

En el tutorial anterior vimos lo que son las colas, los trabajos de cola, los trabajadores, etc. El supuesto detrás de estos trabajos de cola es que cada tarea es entregada a exactamente un trabajador. En esta parte nosotros realizaremos algo relativamente diferente, nosotros entregaremos un mensaje a múltiples consumidores, este patrón es conocido como "publicador/suscriptor" u observer.
Para ilustrar esto se creará un sistema simple de loggeo, el cual tendrá dos programas, el primero sencillamente trasmitirá y el otro recibirá, podemos crear varios "recibidores" para este caso, asi podríamos escribir logs en el disco mientras otros los leen.
#### Exchanges
En la parte anterior del tutorial enviamos y recibimos mensajes de una cola. Ahora es tiempo de introducir él modelo de completitud de mensajería en Rabbit.

La idea central en el modelo de mensajería en RabbitMQ es que el productor nunca envía ningún mensaje directamente a una cola. En realidad, muy a menudo el productor ni siquiera sabe si un mensaje será entregado a alguna cola.

En cambio, el productor solo puede enviar mensajes a un intercambio. Un intercambio es algo muy simple. Por un lado recibe mensajes de los productores y el otro lado los empuja a hacer colas. El intercambio debe saber exactamente qué hacer con un mensaje que recibe. ¿Debería adjuntarse a una cola en particular? ¿Debería adjuntarse a muchas colas? O debería descartarse. Las reglas para eso se definen por el tipo de intercambio.
![Pasted image 20251206114028.png](images/Pasted%20image%2020251206114028.png)
Hay varios tipos de intercambios disponibles: `direct`, `topic`, `headers` y `fanout`.
Vamos a hacer énfasis en el último, en `fanout`. Vamos a crear un intercambio de este tipo y llamarlo `logs`.
Aquí una tabla sobre la lista de intercambios
```cmd
sudo rabbitmqctl list_exchanges
```
o dentro del contendor podemos hacer: 
![Pasted image 20251206114526.png](images/Pasted%20image%2020251206114526.png)

| Nombre               | Tipo    | Descripción                                                                                                                |
| -------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------- |
| `amq.direct`         | direct  | Exchange direct predefindo. Enruta mensajes donde el routing key coincide exactamente con el nombre dle binding de la cola |
| `amq.fanout`         | fanout  | Exchange fanout predefinido. Envia mensajes a TODAS las colas vinculadas, ignorando el routing key                         |
| `amq.headers`        | headers | Exchange headers predefinido. Enruta basado en headers del mensaje en lugar del routing key                                |
| `amq.match`          | headers | Otro exchange headers predefinido (similar a `amq.headers)                                                                 |
| `amq.rabbitmq.trace` | topic   | Exchange interno para tracing/debuging de RabbitMQ. No usar en producción normal                                           |
| `amq.topic`          | topic   | Exchange topic predefinido. Enruta usando patrones wildcard (* y #) en el routing key.                                     |
Luego veremos todos y cada uno de estos tipos de intercambios o exchange.
Por ahora seguimos con la documentación:

Entonces tenemos:
```java
channel.exchangeDeclare("logs","fanout"); // puede ser tambien "amq.fanout"
```
El intercambio de fanout es bastante simple. Como puedes observar por el nombre (fanout ->fan out) esto solamente es un tipo de broadcast de los mensajes recibido a todas las personas que las conocen y eso es exactamente lo que necesitamos.

En la parte anterior pudimos enviar mensajes a todas las colas porque el exchange por defecto es `""`.
Si recordamos nosotros enviábamos de la siguiente forma: 
![Pasted image 20251211101654.png](images/Pasted%20image%2020251211101654.png)
Por lo que en `channel.basicPublish("",...)` poníamos el literal por defecto. Ahora podemos colocar nuestro exchange.
```java
channel.basicPublish( "logs", "", null, message.getBytes());
```
Por ahora no entramos en cosas de código como tal, aún necesitamos ver que son las colas temporales.
#### Colas temporales

Las colas temporales son necesarias cuando necesitamos una cola que se elimine automáticamente, no sea durable y sea exclusiva, esto lo necesitamos porque como bien sabemos los `exchange` solo es el distribuidor de los correos, los recibe y sabe como distribuirlos, pero no los almacena. La cola `queue` es el buzón de nuestro consumidor, como una analogía tenemos: 
`Productor → Exchange (oficina de correos) → Colas (buzones individuales) → Consumidores`
Sin colas el exchange recibirá mensajes, pero no sabrá donde dejarlos para que los consumidores lo recojan. Para generar una cola de estas características hacemos: 
```java
String queueName = channel.queueDeclare().getQueue();
```
Después ahondaremos más en todo el apartado de colas y cada término específicamente, para colas tenemos https://www.rabbitmq.com/docs/queues .
Por el momento `queueName` contiene un nombre de cola cualquiera. (Este puede ser algo cómo `amq.gen-JzTY20BRgKO-HjmUJj0wLg`)
#### Bindings
![Pasted image 20251212082135.png](images/Pasted%20image%2020251212082135.png)
Ya hemos creado un exchange de tipo fanout y una cola `queue`. Ahora necesitamos llamar a ese exchange para enviar mensajes a nuestras colas, esa relación entre el exchange y las colas se llama `binding`.
```java
channel.queueBinding(queueName,"logs","");
```
A partir de ahora nuestro exchange de `logs` va a añadir mensajes en nuestra cola.
Como dato adicional podemos ver que bindings nosotros tenemos en nuestra aplicación usando:
```bash
rabbitmqctl list_bindings # Este es el comando
Listing bindings for vhost /... #Esta es la respuesta
```

#### Poniendolo todo junto
Ahora toca poner cada una de estas cosas juntas, lo cual generaría un diagrama:
![Pasted image 20251212083648.png](images/Pasted%20image%2020251212083648.png)
El programa del productor debe lucir algo como lo siguiente: 
```java
public class EmitLog {

  private static final String EXCHANGE_NAME = "logs";

  public static void main(String[] argv) throws Exception {
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("localhost");
    try (Connection connection = factory.newConnection();
         Channel channel = connection.createChannel()) {
        channel.exchangeDeclare(EXCHANGE_NAME, "fanout");

        String message = argv.length < 1 ? "info: Hello World!" :
                            String.join(" ", argv);

        channel.basicPublish(EXCHANGE_NAME, "", null, message.getBytes("UTF-8"));
        System.out.println(" [x] Sent '" + message + "'");
    }
  }
}
```
Y el programa del consumidor: 
```java
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.DeliverCallback;

public class ReceiveLogs {
  private static final String EXCHANGE_NAME = "logs";

  public static void main(String[] argv) throws Exception {
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("localhost");
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();

    channel.exchangeDeclare(EXCHANGE_NAME, "fanout");
    String queueName = channel.queueDeclare().getQueue();
    channel.queueBind(queueName, EXCHANGE_NAME, "");

    System.out.println(" [*] Waiting for messages. To exit press CTRL+C");

    DeliverCallback deliverCallback = (consumerTag, delivery) -> {
        String message = new String(delivery.getBody(), "UTF-8");
        System.out.println(" [x] Received '" + message + "'");
    };
    channel.basicConsume(queueName, true, deliverCallback, consumerTag -> { });
  }
}
```
***
En nuestro ejemplo añadimos esta lógica y obtenemos los siguientes resultados. Enviamos: 
![Pasted image 20251212091600.png](images/Pasted%20image%2020251212091600.png)
y lo que recibimos de cuatro (4) consumidores diferentes: 
![Pasted image 20251212091625.png](images/Pasted%20image%2020251212091625.png)
Aqui observamos como cada uno procesa exactamente lo mismo

### Routing
En este tutorial vamos a agregar una función a él - vamos a hacer posible suscribirse solo a un subconjunto de los mensajes. Por ejemplo, podremos dirigir solo mensajes de error críticos al archivo de registro (para ahorrar espacio en disco), mientras que todavía podremos imprimir todos los mensajes de registro en la consola. Esto nos da una idea de lo que es el Routing, apoyándonos de la IA: 
>**Routing es el sistema que permite enviar mensajes específicos a consumidores específicos usando etiquetas (routing keys)**, donde el exchange compara el routing key del mensaje con las reglas de vinculación (binding keys) de cada cola para decidir exactamente quién recibe qué, permitiendo filtrado selectivo en lugar de broadcast generalizado.
#### Bindings:
En los ejemplos anteriores nosotros ya hemos creado bindings (que literalmente significa vinculante) podemos recordar en el código: 
```java
channle.queueBind(queueName,EXCHANGE_NAME,"");
```
Un binding es una relación entre un exchange y una cola. Esto puede simplificarse como: La cola está interesada en mensajes del exchange.

Los bindings pueden tomar un parámetro extra llamado `routingKey`. Para evitar la confusión con el parametro`basic_publish` podemos llamarlo como una `binding Key`, y la manera en que creamos un binding con una llave:
```java
channel.queueBind(queueName,EXCHANGE_NAME,"black");
```
El significado de esta llave depende del exchange que nosotros hayamos colocado, es decir, si es de tipo `fanout` entonces simplemente ignora este valor.
#### Direct exchange:
Siguiendo un ejemplo de un sistema de logging que tocamos en los tutoriales anteriores, manda todos los mensajes a todos los consumidores. Nosotros necesitamos filtrar los mensajes de logging dependiendo de su gravedad, por ejemplo , necesitamos escribir en el disco todos los problemas de logging críticos, pero no necesitamos ni los de alerta ni los informativos. Nosotros usamos `fanout` que a final de cuentas no nos brinda tanta flexibilidad, solo manda los mensajes a todos y ya.

En cambio, vamos a usar el exchange `direct`, el algoritmo de ruteo detrás de `direct` es simple - un mensaje va a la cola cuyo `binding key` coincide exactamente con la `routing key`. La ilustración siguiente mejora la explicación.
![Pasted image 20251212114731.png](images/Pasted%20image%2020251212114731.png)
Aqui podemos ver el exchange de tipo `direct` que tiene dos colas atada a esta. La primera cola tiene la llave `orange` y la segunda tiene dos llaves, `black` y `green`.

En tal configuración, un mensaje publicado en el intercambio con una clave de enrutamiento naranja se enrutará a la cola `amq.x`. Los mensajes con una clave de enrutamiento de negro o verde irán a la `amq.x2`. Todos los demás mensajes serán descartados.
#### Múltiples bindings:
Es completamente válido crear múltiples colas con el mismo `binding Key`. En el siguiente ejemplo nuestro exchange `direct` va a actuar como un `fanout` aunque sea de tip`direct` esto debido a que se manda a todas las colas.
![Pasted image 20251213085919.png](images/Pasted%20image%2020251213085919.png)
#### Emitir los logs:
Para conseguir lo que deseamos que es mandar y recibir un tipo de log, primero vamos a cambiar de `fanout` a `direct`. Entonces: 
```java
channel.exchangeDeclare(EXCHANGE_NAME,"direct");
// tambien tenemos esta forma
channel.exchangeDeclare(
    EXCHANGE,                    // 1. Nombre del exchange
    BuiltinExchangeType.DIRECT,  // 2. Tipo de exchange
    true                         // 3. durable - Significa que si es durable resiste a reinicios del servidor
);
```
Y luego estamos listos para enviar el mensaje de esta forma: 
```java
channel.basicPublish(EXCHANGE_NAME, severity, null, message.getBytes());
```
#### Suscripción:
Para la suscripción necesitamos el binding, en este caso los bindings son los tipos de `logs` que necesitamos, es decir, error, info, warning. Digamos que lo queremos dinamico con el `jar` entonces: 
```java
String queueName = channel.queueDeclare().getQueue();

for(String severity : argv){
  channel.queueBind(queueName, EXCHANGE_NAME, severity);
}
```
De esta forma podemos elegir que tipo de log queremos.
#### Poner todo junto: 
Al ponerlo todo junto quedaría de la siguiente forma: 
##### Publicador:
```java
public class Main {  
  
    private static String EXCHANGE_NAME = "logs";  
  
    public static void main(String[] args) {  
  
        ConnectionFactory factory = new ConnectionFactory();  
        // el host lo podemos cambiar por una ip diferente o un hostname diferente  
        factory.setHost("localhost");  
        try (Connection connection = factory.newConnection()) {  
            // creamos el canal  
            Channel channel = connection.createChannel();  
            // luego declaramos un mensaje a publicar  
            channel.exchangeDeclare(EXCHANGE_NAME, "direct");  
            String severity = "info";   // esto lo cambiamos cada que lo corremos
            String msg = "Estas pero guapo hoy"; // esto es un ejemplo  
  
            channel.basicPublish(EXCHANGE_NAME, severity, null, msg.getBytes()); // enviamos el mensaje  
            System.out.println("[x] Mensaje enviado : " + msg + " y de gravedad: " + severity);  
  
        } catch (IOException e) {  
            throw new RuntimeException("IOException: " + e);  
        } catch (TimeoutException e) {  
            throw new RuntimeException("TimeoutException: " + e);  
        }  
    }  
  
}
```
##### Consumidor: 
```java 
public class Main {  
    private final static String EXCHANGE_NAME = "logs";  
  
    public static void main(String[] args) throws IOException, TimeoutException {  
        ConnectionFactory factory = new ConnectionFactory();  
        factory.setHost("localhost");  
        Connection connection = factory.newConnection();  
        Channel channel = connection.createChannel();  
        // Definimos que sea direct  
        channel.exchangeDeclare(EXCHANGE_NAME, "direct");  
        String queueName = channel.queueDeclare().getQueue();  // obtenemos la cola  
        if (args.length < 1) {  
            System.err.println("Usage: ReceiveLogsDirect [info] [warning] [error]");  
            System.exit(1);  
        }  
  
        for (String severity : args) {  
            channel.queueBind(queueName, EXCHANGE_NAME, severity);  
        }  
        System.out.println(" [*] Waiting for messages. To exit press CTRL+C");  
  
  
        DeliverCallback deliverCallback = (consumerTag, delivery) -> {  
            String message = new String(delivery.getBody(), StandardCharsets.UTF_8);  
            System.out.println(" [x] Received '" +  
                    delivery.getEnvelope().getRoutingKey() + "':'" + message + "'");  
  
        };  
  
        channel.basicConsume(  
        queueName,     // ¿Qué buzón escuchar? (nombre de cola)  
        true,          // ¿Auto-acknowledge? (true = "ya lo recibí, bórralo")  
        deliverCallback, // ¿Qué hacer con cada mensaje?  
        consumerTag -> {} // Callback si cancelan tu consumo (raro usar)  
); 
  
    }  
  
}
```
Y nuestro resultado es el siguiente: 
![Pasted image 20251213110206.png](images/Pasted%20image%2020251213110206.png)
Aquí observamos tanto la inicialización como los `logs` que nosotros enviamos

### Topicos:
En el tutorial anterior hemos mejorado nuestro sistema de registro. En lugar de usar un intercambio de fanout solo capaz de transmisión ficticia, usamos uno directo y ganamos la posibilidad de recibir selectivamente los registros.

Aunque el uso del intercambio directo mejoró nuestro sistema, todavía tiene limitaciones: no puede hacer el enrutamiento en función de múltiples criterios.

En nuestro sistema de registro, es posible que deseemos suscribirnos no solo a los registros basados en la gravedad, sino también en la fuente que emitió el registro. Es posible que conozca este concepto de la herramienta syslog unix, que enruta los registros en función de la gravedad (información/advertencia/crit...) y la instalación (auth/cron/kern...).

Eso nos daría mucha flexibilidad: es posible que queramos escuchar solo errores críticos provenientes de 'cron', pero también todos los registros de 'kern'.

Para implementar eso en nuestro sistema de logs (registro), necesitamos aprender sobre un topic exchange (intercambio de temas) más complejo

#### Topic Exchange (Intercambio de temas)
Un **topic exchange** es una forma de enviar mensajes usando **temas**, parecido a poner etiquetas para decidir quién recibe qué información. Cada mensaje se envía con un **nombre compuesto por palabras separadas por puntos**, por ejemplo `deportes.futbol.colombia`. Las personas o sistemas que quieren recibir mensajes dicen qué temas les interesan, y pueden usar reglas simples: el símbolo `*` significa “cualquier palabra en esta posición” y el símbolo `#` significa “cualquier cantidad de palabras, o incluso ninguna”. Así, alguien que se suscribe a `deportes.#` recibe todo lo relacionado con deportes, mientras que `*.futbol.colombia` recibiría solo mensajes de fútbol en Colombia. 

Existe una regla importante: ese nombre del tema no puede ocupar más de **255 bytes**, que es una medida de **tamaño en memoria**, no de cuántas letras ves en pantalla. Si usas letras simples sin acentos, cada letra ocupa 1 byte y podrías tener hasta unas 255 letras; pero si usas letras con tilde, ñ, símbolos o emojis, cada uno ocupa más espacio (varios bytes), por lo que el límite se alcanza antes. El error aparece cuando el nombre del tema es **demasiado largo**, normalmente por intentar escribir frases completas en lugar de usar categorías cortas, por eso se recomienda usar nombres breves y ordenados, como etiquetas, no como oraciones completas.

- * (estrella) puede sustituir exactamente una palabra.
- `#` (hash) puede sustituir a cero o más palabras.

![Pasted image 20251213122415.png](images/Pasted%20image%2020251213122415.png)
En este ejemplo nosotros estamos enviando mensajes que describen animales. El mensaje sera enviado con una `routing key` que consiste en 3 palabras (dos puntos). La primera palabra describe la velocidad, la segunda palabra un color y la tercera la especie, generando un formato: `<velocidad>.<color>.<especie>`.

Nosotros creamos tres `bindings`: Para Q1 está unida con él `binding key` `*.orange.*` y la Q2 con `*.*.rabbit` y `lazy.#`.

Estos `bindings` pueden ser resumidos como: 
- Q1 esta interesando en todos los animales naranjas
- Q2 quiere escuchar todo acerca de los conejos y todo sobre los animales perezosos.

Un mensaje con un `routing key` establecido como `quick.orange.rabbit` va a ser recibida en ambas colas. Mensajes como `lazy.orange.elephant` también iría en ambas. Por el otro lado `quick.orange.fox` irá solo en la primera cola y `lazy.brown.fox` solo en la segunda.

¿Que pasaría si rompemos este formato de mensajes con una o cuatro palabras, como `orange` o `quick.orange.new.rabbit` ? Bueno, estos mensajes no harán match con ninguno `binding` y simplemente se perderá.

Por el otro lado `lazy.orange.new.rabbit`, a pesar de tener 4 palabras, este hare match con el ultimo binding y sera entregado a la segunda cola.

#### Poniéndolo todo junto:
Ahora vamos a usar este `topic` exchange en nuestro sistema de logging, entonces, vamos a trabajar suponiendo que las routing keys de os logs tienen dos palabras `<facility>.<severidad>`
***
Lo único que se cambia en el código es: 
```java
channel.exchangeDeclare(EXCHANGE_NAME, "topic");
```
En resto queda exactamente igual. Un ejemplo demostrativo: 
![Pasted image 20251213190224.png](images/Pasted%20image%2020251213190224.png)
Aqui vemos diferentes tipos de mensajes que son redirigidos dependiendo de lo que decidimos que escuchara, como se puede observar se coloca al inicio del la inicializacion del `jar` por `cmd`.

### RPC (Remote Procedurel Call)
En este segundo tutorial aprendimos acerca de como usar los trabajos de cola para distribuir el tiempo de consumo de tareas entre multiples workers.

¿Pero qué pasa si nosotros necesitamos correr una función en un computador remoto y esperar un resultado?
Bueno aqui el patrón usado es comun mente llamada RPC o Remote Procedure Call.

En este tutorial vamos a usar RabbitMQ para construir un sistema RPC: Un cliente y un servidor RPC escalable. Vamos a crear un servicio RPC que retorne números fibonacci.

#### Interfaz del cliente: 
Para ilustrar como un servicio RPC podria ser usado vamos acrear una clase simple para el cliente. Esto va a exponser un metodo llamado `call` que enviará una peticion RPC y bloqueará hasta recibir una respuesta: 
```java 
FibonacciRpcClient fibonacciRpc = new FibonacciRpcClient();
String result = fibonacciRpc.call("4");
System.out.println( "fib(4) is " + result);
```
> **Una nota sobre RPC:**
> Aunque RPC es un patrón bastante común en la computación, a menudo es criticado. Los problemas surgen cuando un programador no es consciente de sí una llamada de función es local o si es un RPC lento. Confusiones como esa resultan en un sistema impredecible y agrega complejidad innecesaria a la depuración. En lugar de simplificar el software, el RPC mal utilizado puede resultar en un código de espagueti incontenible.
> Teniendo esto en mente consideré las siguientes advertencias: 
> 	- Mantente seguro de que función se llama local y que se hace remota
> 	- Documentar tu sistema. Crea las dependencias entre componentes claros
> 	- Maneje casos de error. ¿Como podría el cliente reaccionar cuando el servidor RPC esta caído por un largo tiempo?
> En caso de duda, evite RPC. Si puede, debe usar una tubería asíncrona: en lugar de bloqueo similar a RPC, los resultados se envían de forma asíncrona a una siguiente etapa de cálculo.

#### Callback queue:
El patrón de solicitud-respuesta en RabbitMQ implica una interacción directa entre el servidor y el cliente.

Un cliente envía una petición y el servidor responde con un mensaje de respuesta.

Para recibir una respuesta, necesitamos enviar un nombre de cola callback con la solicitud. Tal cola a menudo se llama con el nombre del servidor, pero también puede tener un nombre bien conocido (con el nombre de cliente)

El servidor usará ese nombre para responder usando el exchange predeterminado.

```java
callbackQueueName = channel.queueDeclare().getQueue();

BasicProperties props = new BasicProperties
							.Builder()
							.replyTo(callbackQueueName)
							.build();
channel.basicPublisj("","rpc_queue",props,message.getBytes());

// todo el codigo para leer un mensaje de respuesta
```
Nosotros necesitamos este import: 
```java
import com.rabbitmq.client.AMQP.BasicProperties;
```
> **Message properties:**
> En el protocolo AMQP 0-9-1 se predefine un conjunto de 14 propiedades que van con el mensaje. Muchas de las propiedades raramente se usan, con excepción de las siguientes:
> 
> - `deliveryMode`: Marca un mensaje como persistente (con valor de 2) o transitorio (cualquier valor). Tú podrías recordar esta propiedad del segundo tutorial: [tutorial link](https://www.rabbitmq.com/tutorials/tutorial-two-java).
> - `contentType`: Usado para describir el tipo de codificación. Por ejemplo generalmente es usado el método de codificación JSON, este es una buena práctica `application/json`.
> - `replyTo`: Comúnmente usado para nombrar una callback queue.
> - `correlationId`: Útil para correlacionar las respuestas de RPC con las solicitudes.

#### Correlation ID:
Crear una cola callback para cada petición RCP es bastante ineficiente, lo mejor es crear una sola por cada cliente.

Eso plantea un nuevo problema, después de haber recibido una respuesta en esa cola, no está claro a qué solicitud pertenece la respuesta. Es entonces cuando se utiliza la propiedad `correlationId`. Vamos a establecerlo a un valor único para cada solicitud. Más tarde, cuando recibamos un mensaje en la cola de callback, veremos esta propiedad, y con base en eso podremos hacer coincidir una respuesta con una solicitud. Si vemos un valor de desconocido de `correlationId`, podemos descartar el mensaje de forma segura, no pertenece a nuestras solicitudes.

Puede preguntar, ¿por qué deberíamos ignorar los mensajes desconocidos en la cola callback, en lugar de fallar con un error? Se debe a la posibilidad de una condición de carrera en el lado del servidor. Aunque es poco probable, es posible que el servidor RPC muera justo después de enviarnos la respuesta, pero antes de enviar un mensaje de acuse de recibo para la solicitud. Si eso sucede, el servidor RPC reiniciado procesará la solicitud de nuevo. Es por eso que en el cliente debemos manejar las respuestas duplicadas con gracia, y el RPC debería ser ideal.

#### Summary (resumen)
Nuestro RCP va a trabajar de la siguiente forma:![Pasted image 20251214121556.png](images/Pasted%20image%2020251214121556.png)

- Cuando el cliente inicia, este crea una exclusiva callback queue.
- Para una solicitud RPC, el cliente envía un mensaje con dos propiedades `reply_to` que nos dice a la cola a la que va dirigida y `correlation_id` que es quien da un unico valor a una petición
- La solicitud se envía a la cola `rcp_queue`
- El RCP worker (llamado: server) esta esperando por peticiones de esa cola. Cuando una petición aparece este hace su trabajo y envía un mensaje con el resultado hacia el cliente usando la cola con el campo de `replyTo`.
- El cliente espera los datos de la cola de respuesta. Cuando aparece un mensaje, comprueba la propiedad `correlationId`. Si coincide con el valor de la solicitud, devuelve la respuesta a la aplicación.

#### Poniendolo todo junto: 
En la documentación nos mandan a github en un lugar donde hay este tipo de código, asi que aqui lo ponemos: 

**Servidor:**
```java title=Main.java
package org.patterns;  
  
import com.rabbitmq.client.*;  
  
import java.nio.charset.StandardCharsets;  
  
public class Main {  
  
    private static final String RPC_QUEUE_NAME = "rpc_queue";  
  
    // Este será el servidor que vamos a crear  
    public static void main(String[] args) throws Exception {  
        ConnectionFactory connectionFactory = new ConnectionFactory();  
        connectionFactory.setHost("localhost");  
        /* creamos la conexión, debemos de recordar que esto toca cerrarlo, es decir:  
         *connection.close();         */        Connection connection = connectionFactory.newConnection();  
        Channel channel = connection.createChannel();  
        channel.queueDeclare(  
                RPC_QUEUE_NAME,   // 1. Nombre de la cola  
                false,            // 2. durable: si sobrevive a reinicios del broker  
                false,            // 3. exclusive: si es solo para esta conexión  
                false,            // 4. autoDelete: si se elimina cuando no hay consumidores  
                null              // 5. arguments: parámetros adicionales (Map)  
        );  
        // aquí aseguramos que no haya ningún mensaje y empiece con una cola vacía - purge  
        channel.queuePurge(RPC_QUEUE_NAME);  
        channel.basicQos(1); // le decimos que se procese un mensaje a la vez  
        System.out.println("[x] Esperando peticiones RPC");  
  
        DeliverCallback deliverCallback = (consumerTag, delivery) -> {  
            AMQP.BasicProperties replyProperties = new AMQP.BasicProperties  
                    .Builder()  
                    .correlationId(delivery.getProperties().getCorrelationId())  
                    .build();  
            String response = "";  
  
            try{  
                String message = new String(delivery.getBody(), StandardCharsets.UTF_8);  
                int n = Integer.parseInt(message); // esto debido a que sabemos que es un entero lo que recibiremos  
                System.out.println("[.] fib ("+message+")");  
                response+= fib(n);  
            }catch (RuntimeException e){  
                System.out.println(" [.] " + e);  
            }finally {  
                channel.basicPublish("", delivery.getProperties().getReplyTo(), replyProperties, response.getBytes("UTF-8"));  
                channel.basicAck(delivery.getEnvelope().getDeliveryTag(), false);  
            }  
        };  
        channel.basicConsume(RPC_QUEUE_NAME, // nombre de la cola  
                false, // autoAck  
                deliverCallback, // callback para entregas  
                (consumerTag -> {}) // callback para cancelado y a veces hay otro callback para apagado  
        );  
  
    }  
  
  
    private static int fib(int n) {  
        if (n == 0) return 0;  
        if (n == 1) return 1;  
        return fib(n - 1) + fib(n - 2);  
    }  
  
}
```
**Cliente:**
 ```java unwrap:false title:RPCClient.java {35,49,67,96} 
// Este será el cliente:  
public class RPCClient implements AutoCloseable {  
  
    private Connection connection;  
    private Channel channel;  
    private String requestQueueName = "rpc_queue"; // igual que en el servidor  
  
    public RPCClient() throws IOException, TimeoutException {  
        ConnectionFactory factory = new ConnectionFactory();  
        factory.setHost("localhost");  
  
        connection = factory.newConnection();  
        channel = connection.createChannel();  
    }  
  
    public static void main(String[] args) throws IOException, TimeoutException {  
        try (RPCClient fibonacciRpc = new RPCClient()){  
            for(int i = 0; i<32 ;i++){  
                String i_str = Integer.toString(i);  
                System.out.println(" [x] Requesting fib(" + i_str + ")");  
                String response = fibonacciRpc.call(i_str);  
                System.out.println(" [.] Got '" + response + "'");  
            }  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
    }  
  
    public String call(String message) throws IOException, InterruptedException, ExecutionException, TimeoutException {  
  
        // 1. GENERAMOS UN ID ÚNICO PARA ESTA SOLICITUD  
        // ============================================        
        // El correlationId es como el "número de ticket" en una carnicería        
        // Cada solicitud tiene su propio ID para saber qué respuesta corresponde a qué pedido        
        final String corrId = UUID.randomUUID().toString();  
  
  
        // 2. CREAMOS UNA COLA TEMPORAL "DE UN SOLO USO" PARA LA RESPUESTA  
        // ================================================================        
        // Esto es como decir: "Déjame el pollo listo en el mostrador 5"        
        // RabbitMQ genera un nombre automático tipo "amq.gen-JzTY20BRgKO..."        
        String replyQueueName = channel.queueDeclare().getQueue();  
  
  
        // 3. PREPARAMOS EL "SOBRE" DEL MENSAJE CON INSTRUCIONES  
        // ======================================================        
        // Le ponemos dos etiquetas importantes:        
        // - correlationId: "Ticket #12345" (para identificar)        
        // - replyTo: "Déjalo en el mostrador 5" (dirección de entrega)        
        AMQP.BasicProperties props = new AMQP.BasicProperties  
                .Builder()  
                .correlationId(corrId)     // ← El ticket único  
                .replyTo(replyQueueName)   // ← Dónde queremos la respuesta  
                .build();  
  
  
        // 4. ENVIAMOS LA SOLICITUD AL SERVIDOR RPC  
        // =========================================        
        // Publicamos el mensaje en la cola principal del servidor        
        // Pero ahora con las propiedades extras que acabamos de crear        
        channel.basicPublish("", requestQueueName, props, message.getBytes(StandardCharsets.UTF_8));  
  
  
        // 5. PREPARAMOS EL "BUZÓN" PARA LA RESPUESTA (ASÍNCRONO)  
        // =======================================================        
        // CompletableFuture es como una PROMESA o un "IOU" (I Owe You)        
        // Es una caja que ahora está vacía, pero en el futuro tendrá un valor        
        final CompletableFuture<String> response = new CompletableFuture<>();  
        // Estado actual: "vacío" / "pendiente"  
  
  
        // 6. PONEMOS UN "VIGILANTE" EN NUESTRA COLA TEMPORAL        
        // ===================================================        
        // Le decimos a RabbitMQ: "Cuando llegue algo a mi cola temporal, avísame"        
        // El vigilante (consumer) revisa cada mensaje que llega       
         String ctag = channel.basicConsume(replyQueueName, true, (consumerTag, delivery) -> {  
            // 7. FILTRAMOS: ¿ESTA RESPUESTA ES PARA MÍ?  
            // =========================================            
            // Revisamos el correlationId del mensaje recibido            
            // Solo aceptamos si es NUESTRO ticket            
            if (delivery.getProperties().getCorrelationId().equals(corrId)) {  
                // 8. ¡ES NUESTRA RESPUESTA! COMPLETAMOS LA PROMESA  
                // ================================================                
                // Metemos el valor en la caja CompletableFuture                
                // Esto "cumple la promesa" y desbloquea a quien esté esperando                
                response.complete(new String(delivery.getBody(), StandardCharsets.UTF_8));  
            }  
            // Si no es nuestro correlationId, simplemente ignoramos el mensaje  
        }, consumerTag -> {}); // Callback vacío si nos cancelan el consumo  
  
  
        // 9. ESPERAMOS BLOQUEANTEMENTE HASTA TENER LA RESPUESTA  
              
        // ======================================================        
        // response.get() SE QUEDA PEGADO aquí hasta que:        
        // - Alguien llame a response.complete() (línea 68) → Continúa        
        // - O pase un timeout (no configurado aquí) → Excepción        
        String result = response.get(30, TimeUnit.SECONDS);  
        // Cuando llega aquí, ya tenemos el valor de la promesa cumplida  
  
  
        // 10. LIMPIEZA: QUITAMOS EL VIGILANTE DE LA COLA        
        // ===============================================        
        // Ya recibimos lo que necesitábamos, cancelamos el consumo        
        channel.basicCancel(ctag);  
  
        // 11. DEVOLVEMOS EL RESULTADO AL LLAMANTE  
        return result;  
    }  
  
  
    @Override  
    public void close() throws Exception {  
        connection.close();  
    }  
}
```

### Reliable publishing with the publisher confirms:

Los **publisher confirms** son una extensión de RabbitMQ (AMQP 0.9.1) que permite al productor saber si un mensaje fue recibido correctamente por el broker.
- El broker envía `acks` (confirmados) o `nacks` (rechazados).
- Son asíncronos por naturaleza, aunque el cliente puede esperar de forma síncrona.
- Se habilitan por canal, no por mensaje.
> Útiles cuando perder mensajes no es aceptable (como pagos, eventos críticos logs importantes)

#### Habilitar publishers confirms:
```java 
Channel channel =  connection.createChannel();
channel.confirmSelect();
```
Esto se debe hacer una sola vez por canal.
#### Estrategias de uso: 
##### Estrategia 1: Confirmación por mensaje
Publica un mensaje y espera la confirmación antes de enviar el siguiente: 
```java
while(thereAreMessagesToPublish()){
	channel.basicPublish(exchange, queue, properties, body);
	channel.waitForConfirmsOrDie(5_000);
}
```

###### Ventajas
- Muy fácil de implementar
- Manejo claro de errores
###### Desventajas
- Muy lenta
- Bloquea el envío
- ~ cientos de mensajes por segundo
###### Caso de uso
- Sistemas simples
- Bajo volumen
- Máxima confiabilidad sin complejidad
##### Estrategia 2: Confirmación por lotes (Batch)
Publica varios mensajes y espera la confirmación del lote completo.
```java
int batchSize = 100;
int outstanding = 0;

while (thereAreMessagesToPublish()) {
    channel.basicPublish(exchange, queue, properties, body);
    outstanding++;

    if (outstanding == batchSize) {
        channel.waitForConfirmsOrDie(5_000);
        outstanding = 0;
    }
}

if (outstanding > 0) {
    channel.waitForConfirmsOrDie(5_000);
}

```
###### Ventajas
- Mucho mejor rendimiento (20–30x)
- Implementación sencilla
###### Desventajas
- No sabes qué mensaje falló
- Manejo de errores impreciso
- Sigue siendo bloqueante
###### Caso de uso
- Procesos batch
- Logs
- Envío masivo donde no importa el mensaje exacto fallido

##### Estrategia 3: Confirmaciones Asíncronas (Recomendada)
El broker confirma mensajes en segundo plano usando **callbacks**.
**Números de secuencia:**
Cada mensaje tiene números de secuencia: 
```java
long seqNo = channel.getNextPublishSeqNo();
channel.basicPublish(exchange, queue, properties, body);
```
**Seguimiento de mensajes:**
```java
ConcurrentNavigableMap<Long, String> outstandingConfirms =
    new ConcurrentSkipListMap<>();

outstandingConfirms.put(seqNo, body);
```
**Confirm Listener:**
```java
ConfirmCallback clean = (seqNo, multiple) -> {
    if (multiple) {
        outstandingConfirms.headMap(seqNo, true).clear();
    } else {
        outstandingConfirms.remove(seqNo);
    }
};

channel.addConfirmListener(
    clean,
    (seqNo, multiple) -> {
        String body = outstandingConfirms.get(seqNo);
        System.err.printf(
            "NACK message: %s (seq=%d)%n", body, seqNo
        );
        clean.handle(seqNo, multiple);
    }
);
```
Es importante: 
**NO** republiques desde el callback  
Usa una cola intermedia (`ConcurrentLinkedQueue`) y un hilo publicador
###### Ventajas
- Máximo rendimiento
- Control fino de errores
- Ideal para producción
###### Desventajas
- Implementación más compleja
- Requiere manejo concurrente
###### Caso de uso
- Microservicios
- Sistemas financieros
- Event-driven architectures
- Alta concurrencia

#### Rendimiento:
```fold title=localhost.yml
50k mensajes individuales:   ~5,549 ms
50k en batch:               ~2,331 ms
50k async:                  ~4,054 ms
```
***


```fold title=nodeRemoto.yml
50k mensajes individuales:   ~231,541 ms
50k en batch:               ~7,232 ms
50k async:                  ~6,332 ms
```

Según la IA se puede decir: 
![Pasted image 20251215085123.png](images/Pasted%20image%2020251215085123.png)
Y para un mejor entendimiento: 
![Pasted image 20251215090402.png](images/Pasted%20image%2020251215090402.png)
#### Poniéndolo todo junto: 
Vamos por dos partes, la del consumidor: 
##### Consumidor:
```java title=ConsumerApp.java
public class ConsumerApp {  
	  // este está hecho con IA xd, pero es facil de entender
    private static final String QUEUE = "orders.queue";  
    private static final String EXCHANGE = "orders.exchange";  
    private static final String ROUTING_KEY = "orders.created";  
  
    public static void main(String[] args) throws Exception {  
  
        ConnectionFactory factory = new ConnectionFactory();  
        factory.setHost("localhost");  
  
        Connection connection = factory.newConnection();  
        Channel channel = connection.createChannel();  
  
        // Declaraciones  
        channel.exchangeDeclare(EXCHANGE, BuiltinExchangeType.DIRECT, true);  
        channel.queueDeclare(  
                QUEUE,  
                true,   // durable  
                false,  
                false,  
                null  
        );  
        channel.queueBind(QUEUE, EXCHANGE, ROUTING_KEY);  
  
        // Procesar un mensaje a la vez (backpressure)  
        channel.basicQos(1);  
  
        System.out.println("Esperando mensajes...");  
  
        DeliverCallback deliverCallback = (consumerTag, delivery) -> {  
            String message = new String(  
                    delivery.getBody(),  
                    StandardCharsets.UTF_8  
            );  
  
            try {  
                System.out.println("⚙️ Procesando: " + message);  
  
                // Simular lógica de negocio  
                Thread.sleep(500);  
  
                // 3️⃣ ACK manual                channel.basicAck(delivery.getEnvelope().getDeliveryTag(), false);  
                System.out.println("✅ ACK enviado: " + message);  
  
            } catch (Exception e) {  
                System.err.println("💥 Error procesando: " + message);  
  
                // Rechazar y reencolar  
                channel.basicNack(  
                        delivery.getEnvelope().getDeliveryTag(),  
                        false,  
                        true  
                );  
            }  
        };  
  
        channel.basicConsume(  
                QUEUE,  
                false, // autoAck = false  
                deliverCallback,  
                consumerTag -> {}  
        );  
    }  
}
```
##### Publicador:
```java title=Publicador.java
public class Publicador {  
  
    private static final String EXCHANGE = "orders.exchange";  
    private static final String ROUTING_KEY = "orders.created";  
  
    public static void main(String[] args) throws IOException, TimeoutException, InterruptedException {  
        ConnectionFactory connectionFactory = new ConnectionFactory();  
        Connection connection = connectionFactory.newConnection();  
        Channel channel = connection.createChannel();  
  
        // declaraciones idempotentes:  
        channel.exchangeDeclare(EXCHANGE, BuiltinExchangeType.DIRECT, true);  
        // activamos el publisher confirms:  
        channel.confirmSelect();  
        // Un mapa para correlacionar mensajes  
        ConcurrentNavigableMap<Long, String> outstandingConfirms = new ConcurrentSkipListMap<>();  
        // Ahora hacemos el callback para ack  
        ConfirmCallback ackCallback = (seqNo, multiple) -> {  
            if (multiple) {  
                outstandingConfirms.headMap(seqNo, true).clear();  
            } else {  
                outstandingConfirms.remove(seqNo);  
            }  
        };  
        // Y el callback para nack  
        ConfirmCallback nackCallback = (seqNo, multiple) -> {  
            String msg = outstandingConfirms.get(seqNo);  
            System.err.println("NACK recibido para mensaje: " + msg);  
            // aquí podrías re-encolar el mensaje para retry  
            ackCallback.handle(seqNo, multiple);  
        };  
        // hacemos nuestro listener  
        channel.addConfirmListener(ackCallback, nackCallback);  
  
        // publicamos los mensajes:  
        for (int i = 1; i <= 10; i++) {  
            String message = "Order #" + i;  
  
            long seqNo = channel.getNextPublishSeqNo();  
            outstandingConfirms.put(seqNo, message);  
  
            AMQP.BasicProperties props = new AMQP.BasicProperties  
                    .Builder()  
                    .deliveryMode(2) // persistente  
                    .build();  
  
            channel.basicPublish(  
                    EXCHANGE,  
                    ROUTING_KEY,  
                    props,  
                    message.getBytes(StandardCharsets.UTF_8)  
            );  
  
            System.out.println("Enviado: " + message);  
  
        }  
  
        Thread.sleep(2000);  
  
        channel.close();  
        connection.close();  
  
    }  
  
}
```

## Streams tutorial (flujo de datos)
### Offset Tracking:
#### Setup: 
Esta parte del tutorial consiste en escribir dos programas en Java; un productor que envía una ola de mensajes con un mensaje marcador al final, y un consumidor que recibe mensajes y se detiene cuando recibe el mensaje marcador. Muestra cómo un consumidor puede navegar a través de un flujo e incluso puede reiniciar donde lo dejó en una ejecución anterior.

#### Sending:
El programa que envia empieza instanciando `Enviroment` y creando el stream:
```java
// el Enviroment es similar a crear el factory y una conexión
try(Environment environment = Environment.builder().build()){
	String stream = "stream-offset-tracking-java";
	environment.streamCreator()
		.stream(stream)
		.maxLengthBytes(ByteCapacity.GB(1))
		.create();
}
```
Cuando se crea el stream se borran los mensajes más viejos.
Luego de esto creamos el `Producer` y publicamos 100 mensajes. El valor del cuerpo del último mensaje se establece como `marker`, este es un marcador para el consumidor para decirle que ya deje de consumir.
> **Nota**
> ¿Para qué el `CountDownLatch`?
>   - Streams usa **publisher confirms**
>   - Cada mensaje:
		-Se confirma cuando el broker lo **persistió**
	-El latch asegura:
    - _“No cierres el programa hasta que TODOS estén confirmados”_

```java title=ejemplo.java
Producer producer = environment.producerBuilder()
                               .stream(stream)
                               .build();

int messageCount = 100;
CountDownLatch confirmedLatch = new CountDownLatch(messageCount);
System.out.printf("Publishing %d messages%n", messageCount);
IntStream.range(0, messageCount).forEach(i -> {
    String body = i == messageCount - 1 ? "marker" : "hello";
    producer.send(producer.messageBuilder()
                          .addData(body.getBytes(UTF_8))
                          .build(),
                  ctx -> {
                      if (ctx.isConfirmed()) {
                        confirmedLatch.countDown();
                      }
                  }
    );
});

boolean completed = confirmedLatch.await(60, TimeUnit.SECONDS);
System.out.printf("Messages confirmed: %b.%n", completed);
```
Ahora debemos crear el programa que recibe:
#### Receiving: 
El programa que recibe debe crear una instancia de `Environment` y asegurar que el stream también es creado. Esta parte del código es la misma que el programa de enviado, así que se omite y se deja para el lector.
En el programa que recibe empieza un `consumer` en el inicio de del stream (`OffsetSpecification.first()`) . Esto usa variables para generar un output a cada elemento del stream desde el inicio hasta el final.

El `consumer` para cuando recibe el mensaje: "Asigna el desplazamiento a una variable, cierra al consumidor y disminuye el recuento de cierre." . Al igual que para el sender, el `CountDownLatch` le dice al programa que siga adelante cuando el consumidor haya terminado con su trabajo.
```java
// Indica desde qué punto del stream comenzará el consumo.
// first() = offset 0 (primer mensaje existente en el stream)
OffsetSpecification offsetSpecification = OffsetSpecification.first();

// Guarda el offset del PRIMER mensaje recibido.
// Se inicializa en -1 porque:
// 1) Los offsets reales del stream SIEMPRE son >= 0
// 2) -1 actúa como valor "sentinela" que indica:
//    "todavía no he recibido ningún mensaje"
AtomicLong firstOffset = new AtomicLong(-1);

// Guarda el offset del ÚLTIMO mensaje recibido (el "marker").
// Se inicializa en 0 porque:
// 1) El valor inicial NO se usa hasta que llegue el marker
// 2) lastOffset.set(...) sobrescribe este valor
// 3) 0 es un valor neutro y válido para inicializar
AtomicLong lastOffset = new AtomicLong(0);

// CountDownLatch inicializado en 1 porque:
// 1) Solo hay UN evento que nos interesa esperar:
//    → que el consumidor termine (marker recibido)
// 2) Cuando ese evento ocurre, llamamos countDown()
// 3) El latch pasa de 1 → 0 y libera el hilo principal
// Si fuera 2, necesitaríamos DOS eventos para continuar
CountDownLatch consumedLatch = new CountDownLatch(1);

// Construcción del consumidor del stream
environment.consumerBuilder()
    // Nombre del stream al que se conecta
    .stream(stream)

    // Offset inicial desde el que se empezará a leer
    .offset(offsetSpecification)

    // Handler que se ejecuta por cada mensaje recibido
    .messageHandler((ctx, msg) -> {

        // Guarda el offset del primer mensaje recibido
        // compareAndSet(-1, ctx.offset()):
        // - Solo escribe si el valor actual es -1
        // - Garantiza que SOLO el primer mensaje lo setea
        // - Los siguientes mensajes no sobrescriben el valor
        if (firstOffset.compareAndSet(-1, ctx.offset())) {
            System.out.println("First message received.");
        }

        // Convierte el cuerpo del mensaje de bytes a String
        String body = new String(
            msg.getBodyAsBinary(),
            StandardCharsets.UTF_8
        );

        // Si el mensaje es el marcador final
        if ("marker".equals(body)) {

            // Guarda el offset del mensaje marker
            // Este es el último mensaje procesado
            lastOffset.set(ctx.offset());

            // Cierra explícitamente el consumidor
            // → deja de recibir mensajes del stream
            ctx.consumer().close();

            // Decrementa el latch:
            // 1 → 0, desbloquea el hilo principal
            consumedLatch.countDown();
        }
    })

    // Crea e inicia el consumidor
    .build();

System.out.println("Started consuming...");

// Bloquea el hilo principal hasta que:
// 1) consumedLatch llegue a 0
// 2) o pasen 60 minutos (timeout de seguridad)
consumedLatch.await(60, TimeUnit.MINUTES);

// Se ejecuta SOLO cuando el consumidor terminó correctamente
System.out.printf(
    "Done consuming, first offset %d, last offset %d.%n",
    firstOffset.get(),
    lastOffset.get()
);

```

Ahi queda completamente comentado
#### Exploring the Stream:
Para iniciar todo primero necesitamos continuar con este comando de docker: 
```bash
docker run -d --rm --name rabbitmq \
  -p 5672:5672 \
  -p 15672:15672 \
  -p 5552:5552 \
  -e RABBITMQ_SERVER_ADDITIONAL_ERL_ARGS='-rabbitmq_stream advertised_host localhost' \
  rabbitmq:4-management
```
Luego de montar el puerto `5552` que es el que se usa para streams normalmente, tenemos que activar el plug-in: 
```bash
docker exec rabbitmq rabbitmq-plugins enable \
  rabbitmq_stream \
  rabbitmq_stream_management
```
Eso sería todo, y en el cmd/bash veriamos: 
![Pasted image 20251216102550.png](images/Pasted%20image%2020251216102550.png)
y en la UI: 
![Pasted image 20251216102624.png](images/Pasted%20image%2020251216102624.png)
***
Ahora poniendo todo junto podemos ver el cómo funciona: 

![Pasted image 20251216103229.png](images/Pasted%20image%2020251216103229.png)
Y del lado del productor: 
![Pasted image 20251216103245.png](images/Pasted%20image%2020251216103245.png)
Si se vuelve a correr el consumidor: 
![Pasted image 20251216103304.png](images/Pasted%20image%2020251216103304.png)
Vemos que ahora ya solo va al marker, porque ya consumio lo anterior :D . El código completo: 
**Recibidor**
```java title=ReceivingApp.java
package org.patterns;  
  
  
import com.rabbitmq.stream.Environment;  
import com.rabbitmq.stream.OffsetSpecification;  
  
import java.nio.charset.StandardCharsets;  
import java.util.concurrent.CountDownLatch;  
import java.util.concurrent.TimeUnit;  
import java.util.concurrent.atomic.AtomicLong;  
  
public class ReceivingApp {  
  
    private static final String STREAM = "orders.stream";  
    private static final String CONSUMER_NAME = "orders-consumer";  
  
    public static void main(String[] args) {  
        try (Environment environment = Environment.builder().build()) {  
            OffsetSpecification offsetSpecification = OffsetSpecification.first();  
            // Para la concurrencia:  
            AtomicLong firstOffset = new AtomicLong(-1);  
            AtomicLong lastOffset = new AtomicLong(0);  
            // solo necesitamos un evento:  
            CountDownLatch consumeLatch = new CountDownLatch(1);  
            // vamos al environment:  
            environment.consumerBuilder()  
                    .stream(STREAM)  
                    .offset(offsetSpecification)  
                    .name(CONSUMER_NAME)  
                    .messageHandler((ctx, msg) -> {  
                        if (firstOffset.compareAndSet(-1, ctx.offset())) {  
                            System.out.println("First message received.");  
                        }  
                        String body = new String(  
                                msg.getBodyAsBinary(),  
                                StandardCharsets.UTF_8  
                        );  
                        System.out.println(  
                                "Offset " + ctx.offset() + " → " + body  
                        );  
                        // Si el mensaje es el marcador final  
                        if ("marker".equals(body)) {  
  
                            // Guarda el offset del mensaje marker  
                            // Este es el último mensaje procesado                            
                            lastOffset.set(ctx.offset());  
  
                            // Cierra explícitamente el consumidor  
                            // → deja de recibir mensajes del stream                            
                            ctx.consumer().close();  
  
                            // Decrementa el latch:  
                            // 1 → 0, desbloquea el hilo principal                           
                             consumeLatch.countDown();  
                        }  
                    })  
                    .build();  
  
            System.out.println("Started consuming...");  
  
            consumeLatch.await(60, TimeUnit.MINUTES);  
  
            // Se ejecuta SOLO cuando el consumidor terminó correctamente  
            System.out.printf(  
                    "Done consuming, first offset %d, last offset %d.%n",  
                    firstOffset.get(),  
                    lastOffset.get()  
            );  
        } catch (Exception e) {  
  
        }  
    }  
  
  
}
```
**Productor**
```java title=Productor.java
package org.patterns;  
  
  
import com.rabbitmq.stream.ByteCapacity;  
import com.rabbitmq.stream.Environment;  
import com.rabbitmq.stream.Producer;  
  
import java.nio.charset.StandardCharsets;  
import java.util.concurrent.CountDownLatch;  
import java.util.concurrent.TimeUnit;  
import java.util.stream.IntStream;  
  
public class Productor {  
  
    private static final String STREAM = "orders.stream";  
  
    public static void main(String[] args) {  
  
        try (Environment environment = Environment.builder()  
                .build()) {  
            environment.streamCreator()  
                    .stream(STREAM)  
                    .maxLengthBytes(ByteCapacity.GB(1))  
                    .create();  
  
            Producer producer = environment.producerBuilder()  
                    .stream(STREAM)  
                    .build();  
            int messageCount = 100;  
            CountDownLatch confirmedLatch = new CountDownLatch(messageCount);  
            System.out.printf("Publishing %d messages%n", messageCount);  
            // en el intStream es lo que hará a cada uno de los mensajes  
            IntStream.range(0,messageCount).forEach(i -> {  
                String body = i == messageCount-1? "marker":"Order #"+i;  
                producer.send(producer.messageBuilder()  
                        .addData(body.getBytes(StandardCharsets.UTF_8))  
                        .build(),  
                        ctx->{  
                    if(ctx.isConfirmed()){  
                        confirmedLatch.countDown();  
                    }  
                        }  
                );  
            });  
  
            boolean completed = confirmedLatch.await(60, TimeUnit.SECONDS);  
            System.out.printf("Messages confirmed: %b.%n", completed);  
  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
    }  
}
```

# Resumen y visión general: 
RabbitMQ es un **broker de mensajería multiparadigma**. No se limita a colas: soporta **procesamiento de mensajes, enrutamiento, streaming de eventos e integración entre brokers y protocolos**.

RabbitMQ se organiza alrededor de **modos de uso**, cada uno con responsabilidades bien definidas.
## 1. Colas (Queues) — Procesamiento de mensajes

Las colas son el mecanismo clásico de RabbitMQ (AMQP 0.9.1). Se usan para **procesar mensajes de forma confiable**, normalmente con un solo consumidor por mensaje.

### Qué permite una cola

- Entregar un mensaje a **un solo consumidor**
- Confirmación manual (ACK / NACK)
- Reintentos
- Backpressure (`basicQos`)
- Dead Letter Queues (DLQ)
- Persistencia en disco
- Orden garantizado por cola
### Variantes de colas

- **Durable queues**  
    Persisten reinicios del broker.
- **Lazy queues**  
    Mantienen mensajes en disco, reducen uso de RAM.
- **Priority queues**  
    Permiten asignar prioridades a mensajes.
- **Quorum queues**  
    Replicadas (Raft), tolerantes a fallos, recomendadas en producción moderna.
- **Exclusive / Auto-delete queues**  
    Viven solo mientras el consumidor está conectado.
### Ejemplo típico
Procesamiento de órdenes:
```fold title=procesamientoOrdenes.txt
`OrderCreated → Queue → Worker → ACK`
```
### Cuándo usar colas

- Trabajo distribuido
- Procesos background
- Microservicios
- Reintentos y tolerancia a fallos
- Garantía “exactly-once” a nivel aplicación
## 2. Exchanges — Enrutamiento de mensajes

Los exchanges **no almacenan mensajes**, solo los **dirigen a colas** según reglas.

Un producer nunca envía directamente a una cola; siempre publica a un exchange.

### Tipos principales de exchange
- **Direct**  
    Enrutamiento por clave exacta.
- **Topic**  
    Enrutamiento por patrones (`order.*`, `user.#`).
- **Fanout**  
    Broadcast: envía a todas las colas ligadas.
- **Headers**  
    Enrutamiento por headers (poco usado).
### Qué permite un exchange
- Desacoplar producers de consumers
- Enviar un mismo mensaje a múltiples colas
- Cambiar routing sin tocar código productor
### Ejemplo típico: 
```fold title=Ejemplo
Producer → Exchange(topic)
                    ├─ Queue billing
                    ├─ Queue shipping
                    └─ Queue audit

```

### Cuando usar Exchanges

## 3. Streams — Event Streaming

RabbitMQ Streams es un **log de eventos persistente**, similar conceptualmente a Kafka.

Los mensajes **no se eliminan** cuando se consumen.

### Qué permite un stream

- Leer mensajes por offset
- Releer mensajes (replay)
- Múltiples consumidores leyendo lo mismo
- Alta tasa de throughput
- Persistencia fuerte
- Seguimiento de offsets (server-side)

### Características clave

- Mensajes ordenados
- Los consumidores mantienen su posición
- El historial permanece hasta que se borra por política

### Ejemplo
```fold title=Ejemplo
OrderCreated (event)
→ Stream
→ Analytics
→ Audit
→ FraudDetection
```
### Cuándo usar Streams

- Event sourcing
- Auditoría
- Analytics
- CDC (Change Data Capture)
- Integraciones event-driven
- Necesidad de replay
## 4. Federation — Conectar brokers

Federation permite **enlazar brokers RabbitMQ entre sí**, sin mover toda la topología.

### Qué permite

- Consumir colas/exchanges remotos
- Replicar mensajes entre data centers
- Escenarios multi-región

### Características

- Pull-based (no empuja)
- Más simple que clustering
- Ideal para WAN

### Ejemplo
```fold title=Ejemplo
Broker A (EU) ← Federation ← Broker B (US)
```
## 5. Shovel — Movimiento de mensajes

Shovel copia mensajes **activamente** entre brokers o protocolos.
### Qué permite
- Migrar mensajes
- Integrar brokers heterogéneos
- Transferir mensajes históricos
### Diferencia con Federation
- Federation = consumo remoto
- Shovel = copia física de mensajes
### Ejemplo

`Queue A → Shovel → Queue B`
## 7. Prometheus — Observabilidad

RabbitMQ expone métricas compatibles con Prometheus.
### Qué permite

- Métricas de colas
- Latencia
- Throughput
- Consumers activos
- Backpressure

### Uso típico

`RabbitMQ → Prometheus → Grafana`

***
# Usos en proyectos
Teniendo en cuenta los 7 apartados mencionados aquí (que existen claramente más usos pero solo mencionamos 7 en donde abordamos 3 en relativod etalle en el tutorial de principiante) vamos a generar los casos de uso de cada una de estas. Algo más especifico.
## 1. Colas: 

Se enfoca en tipo de sistemas como un sistema transaccional clásico (e-commerse, ERP, CRM, etc) .

**Flujo**
`API Compra  → Cola orders.queue  → OrderProcessor`

**Qué se procesa**
- Crear orden en base de datos
- Reservar stock
- Calcular totales

**Por qué cola**
- Garantía de entrega    
- ACK/NACK
- Reintentos
- DLQ si falla

Otro proyecto en el que se puede usar es un sistema de facturación.

**Contexto**
- Miles de facturas diarias.
- Procesamiento Pesado
- No importa el orden, sí la confiabilidad

**Flujo**
```
Facturación
 → billing.queue
 → Workers de facturas
```
## 2. Exchanges

**Tipo de sistema**
Sistema basado en eventos de negocio (microservicios).

**Proyecto 1**:  Plataforma de compras (event-driven)

**Evento real**
`OrderCreated
`
**Exchange**
`orders.exchange (topic)`

**Flujos**
```
OrderCreated
 ├→ billing.queue        (facturación)
 ├→ shipping.queue       (envíos)
 ├→ notifications.queue  (emails / push)
 └→ analytics.queue      (métricas)
```

**Por qué exchange**

- Un evento activa múltiples flujos
- El productor no conoce consumidores
- Cada servicio evoluciona solo

## 3. Streams: 
**Tipo de sistema:**  
Plataforma de eventos, analytics, auditoría o event sourcing.

**Proyecto 1**: Auditoría de acciones de usuarios

**Eventos**
```
UserLoggedIn
UserPasswordChanged
UserRoleUpdated
```

**Flujo**
```
Aplicación
 → users.stream
```
**Consumen**

- Seguridad (en tiempo real)
- Auditoría (batch)
- Analytics (replay)

**Por qué stream**

- No se borra el mensaje
- Se puede volver atrás
- Múltiples lectores independientes


`aunque esto también se podría hacer desde bases de datos`

**Proyecto 2**: Tracking de órdenes

**Eventos**
```
OrderCreated
OrderPaid
OrderShipped
OrderDelivered
```
Se puede reconstruir el estado completo de una orden.

## 4. Federation

**Tipo de sistema:**  
Plataforma distribuida entre regiones o empresas.

**Proyecto 1** SaaS multi-región

**Contexto**
- Clientes en Europa y América
- Brokers separados

**Flujo**
`RabbitMQ US  ← Federation → RabbitMQ EU`

**Uso**
- Replicar eventos críticos
- Evitar latencia global

## 5. Shovel

**Tipo de sistema:**  
Integración puntual o migraciones.

**Proyecto 1** Migración de infraestructura

**Contexto**
- Cambio de datacenter
- Cambio de versión de RabbitMQ

***
Los demas pueden llegar a ser exagerados

# RabbitMQ para SpringBoot:

En este apartado vamos a ver el cómo iniciar en Springboot, lo primero es las configuraciones. Vamos a colocar la dependencia de MQTT de springboot que nos habilita de una vez RabbitMQ
```xml
<dependency>  
    <groupId>org.springframework.boot</groupId>  
    <artifactId>spring-boot-starter-amqp</artifactId>  
</dependency>
```
Y la que nos configura en el `application.properties` o en el `application.yml`: 
```yml
spring:
	rabbitmq:  
	  host: localhost  
	  port: 5672  
	  username: guest  
	  password: guest
```
En este archivo de configuración tambien podemos denominar nuestra cola, puede ser algo como![Pasted image 20251216202147.png](images/Pasted%20image%2020251216202147.png).

Como se usa, el uso es sencillo. Vamos a seguir el tutorial de RabbitMQ para este caso, vamos a crearlo de la siguiente forma:
```java title=Receiver.java
@Component  
@RabbitListener(queues = "hello")  
public class Receiver {  
  
    @RabbitHandler  
    public void receiver(String in) {  
        System.out.printf("[x] Recibido : %s", in);  
    }  
}
```
Esto es totalmente sencillo, obtenemos de una cola llamada "`hello`" un mensaje tipo `String`.
Para enviar un mensaje vamos a cambiar dos cosas, primero colocaremos en la clase `Receiver
`
```java title=Sender.java
@Component  
@Profile("sender")  
public class Sender {  
  
    private final RabbitTemplate template;  
    private final Queue queue;  
  
    public Sender(RabbitTemplate template, Queue queue) {  
        this.template = template;  
        this.queue = queue;  
    }  
  
    @Scheduled(fixedDelay = 1000, initialDelay = 500)  
    public void send() {  
        String message = "holaaa xd";  
        this.template.convertAndSend(queue.getName(), message);  
        System.out.println("[x] Enviado: " + message);  
    }  
  
}
```

Y vamos a hacer la prueba corriendo dos veces el `jar` pero con diferente perfil:

![Pasted image 20251218150336.png](images/Pasted%20image%2020251218150336.png)
Aqui en el apartado de `sender` coloqué un controlador sencillo: 
```java title=ControllerDummy.java
  
@RestController  
@RequestMapping("events")  
@Profile("sender")  
public class ControllerDummy {  
  
    private final Sender sender;  
  
    public ControllerDummy(Sender sender) {  
        this.sender = sender;  
    }  
  
    @GetMapping("/send")  
    public ResponseEntity<?> enviarMensaje() {  
        sender.send();  
        return ResponseEntity  
                .ok("Enviado");  
    }  
  
}
```
Si ingresamos a ese `endpoint` tenemos: 
![Pasted image 20251218150348.png](images/Pasted%20image%2020251218150348.png) y ![Pasted image 20251218150402.png](images/Pasted%20image%2020251218150402.png)
Aquí observamos que envia y recibe en dos diferentes que tiene perfiles diferentes para simular dos aplicaciones diferentes.
## Work Queues:
Vamos a hablar sobre las work queues en Spring Boot. Tenemos la siguiente imagen que nos representa lo que deseamos: 
![Pasted image 20251219092430.png](images/Pasted%20image%2020251219092430.png)

Para empezar vamos a crear el programa mediante los perfiles: 
```java title=configTutorial.java
@Configuration  
@Profile({"tut2", "work-queues"})  
public class ConfigTutorial {  
  
    @Bean  
    public Queue hello() {  
        return new Queue("hello");  
    }  
  
    @Profile("receiver")  
    private static class ReceiverConfig {  
        @Bean  
        public Receiver receiver1() {  
            return new Receiver(1);  
        }  
  
        @Bean  
        public Receiver receiver2() {  
            return new Receiver(2);  
        }  
    }  
      
    @Profile("sender")  
    public Sender sender() {  
        return new Sender();  
    }  
}
```

```java title=Receiver.java
@RabbitListener(queue = "hello")
public class Receiver {  
  
    private final int instance;  
  
    public Receiver(int instance) {  
        this.instance = instance;  
    }  
  
    @RabbitHandler  
    public void receive(String in) throws InterruptedException {  
        StopWatch watch = new StopWatch();  
        watch.start();  
        System.out.println("instance " + this.instance + " [x] Received : " + in);  
        doWork(in);  
        watch.stop();  
        System.out.println("instance " + this.instance +  
                " [x] Done in " + watch.getTotalTimeSeconds() + "s");  
    }  
  
    private void doWork(String in) throws InterruptedException {  
        for (char ch : in.toCharArray()) {  
            if (ch == '.') {  
                Thread.sleep(500);  
            }  
        }  
    }  
}
```

```java title=Sender.java
public class Sender {  
  
    @Autowired  
    private RabbitTemplate template;  
    @Autowired  
    private Queue queue;  
  
    AtomicInteger dots = new AtomicInteger(0);  
    AtomicInteger count = new AtomicInteger(0);  
  
    @Scheduled(fixedDelay = 1000, initialDelay = 500)  
    public void send() {  
        StringBuilder builder = new StringBuilder("Hello");  
        if (dots.incrementAndGet() == 4) {  
            dots.set(1);  
        }  
        for (int i = 0; i < dots.get(); i++) {  
            builder.append('.');  
        }  
        builder.append(count.incrementAndGet());  
        String message = builder.toString();  
        template.convertAndSend(queue.getName(), message);  
        System.out.println("[x] Sent : " + message);  
    }    
}
```

Y por último es necesario activar un par de cosas en el main: 
```java title=SpringEnvironmentsApplication.java
@SpringBootApplication  
@EnableScheduling  
@EnableRabbit  
public class SpringEnvironmentsApplication {  
  
    public static void main(String[] args) {  
        SpringApplication.run(SpringEnvironmentsApplication.class, args);  
    }  
  
}
```
***
Aqui nosotros vemos las tres clases, y el uso de los perfiles para ahora iniciar mediante maven cada perfil. Cómo tenemos el `@Shedule` apenas inicie va a empezar a enviar mensajes tipo: `Hello`.

![Pasted image 20251219101155.png](images/Pasted%20image%2020251219101155.png)
Aqui observamos ambos apartados junto con sus perfiles. 
***
En la documentación nos menciona cosas importantes, como por ejemplo el reconocimiento de menajes o el `Message acknowledge` el cual por defecto re encola si llega a haber algún tipo de problema con el procesamiento de mensajes, en el protocolo AMQP es: 
```java
channel.basicAck(deliveryTag, false);
```
Lo cual en Spring es totalmente por defecto.

Luego nos comenta sobre la persistencia de los mensajes en donde nos dice que la persistencia de mensajes en Spring está por defecto. Aunque una mejor manera para determinar que sea por defecto es generando la propiedad que nos indica: 
```java
@Bean
public Queue hello() {
    return QueueBuilder
            .durable("hello")
            .build();
}
```
### Round-Robin vs Fair dispatch:
Hay dos formas de mandar lo que son este apartado de las colas de trabajo, digamos que existen varios workers, entonces. Cuando se usa el Round-Robin significa que se reparte de misma forma a todos los workers sin importar si esta o no ocupado. Sin embargo, el Fair dispatch evalúa si un `worker` tiene más cantidad de trabajo, mas no más cantidad de tareas. Es decir, si está desocupado que trabaje.

Spring tiene por defecto `Fair dispatch` usando Spring AMQP. Este lo usa con `prefetchCount = 250` es decir: “No le des más de 250 mensajes sin ACK a un consumer”.
Según la IA: 
![Pasted image 20251219124031.png](images/Pasted%20image%2020251219124031.png)

## Publish/Subscribe:
Aquí volvemos a ver lo que son los exchanges, esta vez vamos directamente con el código, tenemos una clase de configuración de la siguiente forma: 
```java title=ConfigTutorial.java
@Configuration  
@Profile({"tut2", "publish-subscribe"})  
public class ConfigTutorial {  
  
    @Bean
    public FanoutExchange fanout() {  
        return new FanoutExchange("tut.fanout");  
    }  
  
    @Profile("receiver")  
    public static class ReceiverConfig {  
        @Bean  
        public Queue autoDeleteQueue1() {  
            return new AnonymousQueue();  
        }  
        @Bean  
        public Binding binding1(  
                FanoutExchange exchange,  
                @Qualifier("autoDeleteQueue1") Queue q) {  
            return BindingBuilder.bind(q).to(exchange);  
        }  
    }  
  
    @Profile("sender")  
    @Bean  
    public Sender sender() {  
        return new Sender();  
    }    
}
```

Luego para el sender tenemos: 
```java title=Sender.java
public class Sender {  
  
    @Autowired  
    private RabbitTemplate template;  
  
    @Autowired  
    private FanoutExchange fanout;  
  
    AtomicInteger dots = new AtomicInteger(0);  
    AtomicInteger count = new AtomicInteger(0);  
  
    @Scheduled(fixedDelay = 1000, initialDelay = 500)  
    public void send() {  
        StringBuilder builder = new StringBuilder("Hello");  
        if (dots.incrementAndGet() == 3) {  
            dots.set(1);  
        }  
        for (int i = 0; i < dots.get(); i++) {  
            builder.append('.');  
        }  
        builder.append(count.incrementAndGet());  
        String message = builder.toString();  
        // usamos este  
        template.convertAndSend(fanout.getName(), "", message);  
        System.out.println("Se esta enviando a : " + fanout.getName());  
        System.out.println("[x] Sent : " + message);  
    }  
}
```
Aqui debemos notar que en el `template` usa el método `convertAndSend` que contiene 3 apartados.
1. Nombre del fanout
2. Routing Key
3. El mensaje a serializar.

En el apartado del recibidor: 
```java tilte=Receiver.java
@Profile("receiver")  
@Component  
@RabbitListener(queues = "#{@autoDeleteQueue1.name}")  
public class Receiver {  
  
  
    public Receiver() {  
    }  
  
    @RabbitHandler  
    public void receive(@Payload String in) throws InterruptedException {  
        System.out.println("Recibí en spring: " + in);  
        receive(in, 1);  
    }  
  
    public void receive(String in, int receiver) throws InterruptedException {  
        StopWatch watch = new StopWatch();  
        watch.start();  
        System.out.println("instance " + receiver + " [x] Received '" + in + "'");  
        doWork(in);  
        watch.stop();  
        System.out.println("instance " + receiver + " [x] Done in "  
                + watch.getTotalTimeSeconds() + "s");  
    }  
  
    private void doWork(String in) throws InterruptedException {  
        for (char ch : in.toCharArray()) {  
            if (ch == '.') {  
                Thread.sleep(500);  
            }  
        }  
    }  
}
```

## Routing: 

Nosotros en él los códigos anteriores habíamos creado unos `bindings` de la siguiente forma: 
```java
@Bean
public Binding binding1(FanoutExchange fanout,
    Queue autoDeleteQueue1) {
    return BindingBuilder.bind(autoDeleteQueue1).to(fanout);
}
```
Ahora podemos agregar un parámetro extra a su creación, el cual consisten en darle una `key`, en este caso: 
```java
@Bean
public Binding binding1a(DirectExchange direct,
    Queue autoDeleteQueue1) {
    return BindingBuilder.bind(autoDeleteQueue1)
        .to(direct)
        .with("orange");
}
```
Para eso recordemos el estilo en que se trasmiten los mensajes en los exchanges de tipo `direct`: 
![Pasted image 20251220155524.png](images/Pasted%20image%2020251220155524.png)
También debemos de saber que es completamente legal crear múltiples bindings con el mismo binding key:
![Pasted image 20251220155646.png](images/Pasted%20image%2020251220155646.png)
### Publicando mensajes: 

Para este apartado de publicación de mensajes ya no necesitamos usar la configuración de `fanout`, necesitamos la configuración de `direct`.
```java
@Bean
public DirectExchange direct() {
    return new DirectExchange("tut.direct");
}
```

### Suscripción de mensajes:

Para suscribirse a mensajes usamos el binding con el tipo de binding que nosotros deseamos, el código realizado es: 
```java
@Bean
public DirectExchange direct() {
    return new DirectExchange("tut.direct");
}
...
@Bean
public Binding binding1a(DirectExchange direct,
    Queue autoDeleteQueue1) {
    return BindingBuilder.bind(autoDeleteQueue1)
        .to(direct)
        .with("orange");
}
```

***
Vamos a poner todo el código: 

En la configuración es donde entra el apartado diferencial: 
```java title=ConfigTutorial.java
@Configuration  
@Profile({"tut2", "publish-subscribe"})  
public class ConfigTutorial {  
  
    @Bean  
    public DirectExchange direct() {  
        return new DirectExchange("tut.fanout");  
    }  
  
    @Profile("receiver")  
    public static class ReceiverConfig {  
        @Bean  
        public Queue autoDeleteQueue1() {  
            return new AnonymousQueue();  
        }  
  
        @Bean  
        public Binding binding1(  
                DirectExchange direct,  
                @Qualifier("autoDeleteQueue1") Queue autoDeleteQueue1) {  
            return BindingBuilder.bind(autoDeleteQueue1)  
                    .to(direct)  
                    .with("orange");  
        }  
    }  
  
    @Profile("sender")  
    @Bean  
    public Sender sender() {  
        return new Sender();  
    }  
}
```
En esta configuración lo que hacemos diferente es declarar el `DirectExchange` con el nombre de `tut.fanout`. Luego creamos el `binding` en el cual solo se conecta ante la key route llamada `orange`.
En la clase `receiver` no hacemos absolutamente nada, se queda igual, como ejemplo: 
```java
@Profile("receiver")  
@Component  
@RabbitListener(queues = "#{@autoDeleteQueue1.name}")  
public class Receiver {  
  
  
    public Receiver() {  
    }  
  
    @RabbitHandler  
    public void receive(@Payload String in) throws InterruptedException {  
        System.out.println("Recibí en spring: " + in);  
        receive(in, 1);  
    }  
  
    public void receive(String in, int receiver) throws InterruptedException {  
        StopWatch watch = new StopWatch();  
        watch.start();  
        System.out.println("instance " + receiver + " [x] Received '" + in + "'");  
        doWork(in);  
        watch.stop();  
        System.out.println("instance " + receiver + " [x] Done in "  
                + watch.getTotalTimeSeconds() + "s");  
    }  
  
    private void doWork(String in) throws InterruptedException {  
        for (char ch : in.toCharArray()) {  
            if (ch == '.') {  
                Thread.sleep(500);  
            }  
        }  
    }  
}
```

El que cambia en este momento es el sender, ya que enviamos a cada uno de los diferentes bindings:
```java title=Sender.java
public class Sender {  
  
    @Autowired  
    private RabbitTemplate template;  
  
    @Autowired  
    private DirectExchange direct;  
  
    AtomicInteger index = new AtomicInteger(0);  
  
    AtomicInteger count = new AtomicInteger(0);  
  
    private final String[] keys = {"orange", "black", "green"};  
  
    @Scheduled(fixedDelay = 1000, initialDelay = 500)  
    public void send() {  
        StringBuilder builder = new StringBuilder("Hello to ");  
        if (this.index.incrementAndGet() == 3) {  
            this.index.set(0);  
        }  
        String key = keys[this.index.get()];  
        builder.append(key).append(' ');  
        builder.append(this.count.get());  
        String message = builder.toString();  
        template.convertAndSend(direct.getName(), key, message);  
        System.out.println(" [x] Sent '" + message + "'");  
    }  
}
```
Entonces cada segundo cambiamos de binding.
A la hora de reproducirlos vemos lo siguiente: 
![Pasted image 20251220170042.png](images/Pasted%20image%2020251220170042.png)
También se agregó un programa con otro binding, el programa: 
```java title=OtroPrograma
public class Main {  
  
    private static String EXCHANGE = "tut.fanout";  
  
    public static void main(String[] args) throws IOException, TimeoutException {  
  
        ConnectionFactory connectionFactory = new ConnectionFactory();  
        connectionFactory.setHost("localhost");  
        Connection connection = connectionFactory.newConnection();  
        Channel channel = connection.createChannel();  
  
        channel.exchangeDeclare(EXCHANGE, "direct", true);  
        String queueName = channel.queueDeclare().getQueue();  
  
        channel.queueBind(queueName, EXCHANGE, "");  
  
        if (args.length < 1) {  
            System.err.println("Usage: ReceiveLogsDirect [info] [warning] [error]");  
            System.exit(1);  
        }  
  
        for (String binding : args) {  
            channel.queueBind(queueName, EXCHANGE, binding);  
        }  
  
        System.out.println("[***] Esperando mensajes: ");  
  
        DeliverCallback deliverCallback = (consumerTag, delivery) -> {  
  
            String message = new String(delivery.getBody(), StandardCharsets.UTF_8);  
            System.out.println("[x] Recibimos el mensaje: " + message);  
  
        };  
  
        channel.basicConsume(  
                queueName,  
                true,               // autoAck  
                deliverCallback,  
                consumerTag -> {  
                }  
        );  
  
  
    }  
}
```

Y los resultados: 
![Pasted image 20251220170157.png](images/Pasted%20image%2020251220170157.png)
***
Como conclusión, ya tenemos el cómo replicarlo en Spring Boot.
## Topics: 
Recordemos lo que son los topics, los topics son una forma de subdividir temas en un exchange, en este caso hay dos formas que son necesarias de entender: 
- `*` (star) puede sustituir exactamente una palabra
- `#` (hash) puede sustituir cero o muchas palabras.

El ejemplo que dimos en tutoriales anteriores es el mismo usado aqui:
![Pasted image 20251220192009.png](images/Pasted%20image%2020251220192009.png)
En este caso, al igual que en el tutorial de los inicios, se divide en 3 topicos: 
`<velocidad>.<color>.<especie>`
Un ejemplo rápido generado por la IA frente a esto de los asteriscos y hash, es por ejemplo:
![Pasted image 20251221152809.png](images/Pasted%20image%2020251221152809.png)
Y en el apartado de hash: 
![Pasted image 20251221152821.png](images/Pasted%20image%2020251221152821.png)
***
¿Cómo quedaría con el código?: 
El código queda muy, muy similar, lo único que cambia es la configuración así: 
```java
@Configuration  
@Profile({"tut2", "publish-subscribe"})  
public class ConfigTutorial {  
  
    @Bean  
    public TopicExchange direct() {  
        return new TopicExchange("tut.fanout");  
    }  
  
    @Profile("receiver")  
    public static class ReceiverConfig {  
        @Bean  
        public Queue autoDeleteQueue1() {  
            return new AnonymousQueue();  
        }  
  
        @Bean  
        public Binding binding1(  
                TopicExchange topic,  
                @Qualifier("autoDeleteQueue1") Queue autoDeleteQueue1) {  
            return BindingBuilder.bind(autoDeleteQueue1)  
                    .to(topic)  
                    .with("*.orange.*");  
        }  
    }  
  
    @Profile("sender")  
    @Bean  
    public Sender sender() {  
        return new Sender();  
    }  
}
```
Y luego en el sender enviamos los topics: 
```java
public class Sender {  
  
    @Autowired  
    private RabbitTemplate template;  
  
    @Autowired  
    private TopicExchange topic;  
  
    AtomicInteger index = new AtomicInteger(0);  
  
    AtomicInteger count = new AtomicInteger(0);  
  
    private final String[] keys = {"quick.orange.rabbit", "lazy.orange.elephant", "quick.orange.fox",  
            "lazy.brown.fox", "lazy.pink.rabbit", "quick.brown.fox"};  
  
    @Scheduled(fixedDelay = 1000, initialDelay = 500)  
    public void send() {  
        StringBuilder builder = new StringBuilder("Hello to ");  
        if (this.index.incrementAndGet() == 5) {  
            this.index.set(0);  
        }  
        String key = keys[this.index.get()];  
        builder.append(key).append(' ');  
        builder.append(this.count.get());  
        String message = builder.toString();  
        template.convertAndSend(topic.getName(), key, message);  
        System.out.println(" [x] Sent '" + message + "'");  
    }  
}
```
Ahora, creamos los programas y como vemos lo que enviamos, esto es lo que recibimos: 
![Pasted image 20251221172951.png](images/Pasted%20image%2020251221172951.png)![Pasted image 20251221173009.png](images/Pasted%20image%2020251221173009.png)

Ahí vemos cuál es la que envía, cuáles reciben.

### RCP: 
El apartado de RCP es un DirectExchange con `callback`. Y la manera de hacerlo es sencillamente: 
```java
@Configuration  
@Profile({"tut2", "publish-subscribe"})  
public class ConfigTutorial {  
  
  
    @Profile("receiver")  
    public static class ReceiverConfig {  
        @Bean  
        public Queue queue() {  
            return new Queue("tut.rcp");  
        }  
  
        @Bean  
        public DirectExchange rpcExchange() {  
            return new DirectExchange("rpc.exchange");  
        }  
        @Bean  
        public Binding binding1(  
                @Qualifier("rpcExchange") DirectExchange ex,  
                @Qualifier("queue") Queue queue) {  
            return BindingBuilder.bind(queue)  
                    .to(ex)  
                    .with("rcp");  
        }  
    }  
  
    @Profile("sender")  
    @Bean  
    public Sender sender() {  
        return new Sender();  
    }  
}
```

El sender : 
```java
public class Sender {  
  
    @Autowired  
    private RabbitTemplate template;  
  
    @Scheduled(fixedDelay = 1000, initialDelay = 500)  
    public void send() {  
        String request = "Hello RCP";  
        System.out.println("[x] Send request: " + request);  
  
        Object response = template.convertSendAndReceive(  
                "rpc.exchange",  
                "rcp",  
                request  
        );  
  
        System.out.println(" [✓] Response: " + response);  
    }  
}
```
Y el reciever:
```java
@Profile("receiver")  
@Component  
@RabbitListener(queues = "#{@queue.name}")  
public class Receiver {  
  
    @RabbitHandler  
    public String handle(String message){  
        System.out.println(" [x] RPC received: " + message);  
        return "Processed → " + message;  
    }  
}
```

Con esto ya tenemos el siguiente resultado: 
![Pasted image 20251221211934.png](images/Pasted%20image%2020251221211934.png)
Cómo se observa hay un apartado que envia y uno que recibe. Y ... ya.