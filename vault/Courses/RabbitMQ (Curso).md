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
![[Pasted image 20251204180323.png]]
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
![[Pasted image 20251204181120.png]]
![[Pasted image 20251204182305.png]]
Dentro de la documentación también nos comenta como instalarlo en diferentes entornos, no solo docker. 
***
Para poder observar de forma visual el RabbitMQ, podemos ir al `localhost:15672` este nos dirige al apartado visual donde el usuario y contraseña son `guest`.
![[Pasted image 20251204204423.png]]

# RabbitMQ Tutorial:
Link: https://www.rabbitmq.com/tutorials
La documentación nos entrega un tutorial de los conceptos básicos de creación de aplicaciones de mensajería usando RabbitMQ. Lo divide en dos tipos de tutoriales.
## Queue tutorial (Cola)
En esta sección se cubrirá el protocolo por defecto que usa RabbitMQ, AMQP 0-9-1.
Este tutorial se hará desde Java, sin embargo, tiene diferentes lenguajes en el tutorial para poder ser creado.

==Nos menciona una notación para algunos diagramas, nos comenta sobre una letra P para los **productores** que es nada más que alguien envió.== Luego tenemos la **cola** o **queue** que es le nombre de la caja de posteo en RabbitMQ y aunque los mensajes fluyen a través de RabbitMQ y sus aplicaciones, solo se puede almacenar dentro de una cola. Una cola solo está limitada por el espacio en el disco del Host, es esencialmente un gran buffer de mensajes.

Muchos productores pueden enviar mensajes que van a una cola, y muchos consumidores pueden recibir información de una cola.

Luego tenemos lo que son los consumidores y es muy similar a lo que significa ser un recibidor, un consumidor es un programa que generalmente espera recibir mensajes.

![[Pasted image 20251204200956.png]]
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
![[Pasted image 20251204205258.png]]

La primera imagen es antes y la segunda es despues, la imagen de ambos corriendo fue la siguiente: 
![[Pasted image 20251204205327.png]]
Algo que es necesario es descargar el `slf4j` o agregarlo en el maven.
Lo más importante es que la cola se cargó con el nombre que se le había colocado (==hello==): 
![[Pasted image 20251204205447.png]]

Y en el docker desktop se puede observar: 
![[Pasted image 20251204205717.png]]
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
![[Pasted image 20251205113309.png]]
Con eso vemos que sin importar cuanto dure una tarea siempre queda en la cola, y se realiza poco a poco. 

#### Round Robin Dispatching:
Una de las ventajas que nosotros tenemos es que "reparte" las cargas de los mensajes a todos los trabajadores, imaginemos lo siguiente, una serie de tareas no dependientes que se necestian realizar y le pasamos una serie de trabajadores que van a realizarla, cada trabajador obtiene una tarea y la realiza, esto mismo hace RabbitMQ, por ejemplo tengamos lo siguiente, tres trabajadores : 
![[Pasted image 20251205131445.png]]
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
	![[Pasted image 20251205131604.png]]
2. Observamos que cambio tuvieron los trabajadores:  
	![[Pasted image 20251205131640.png]]
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
![[Pasted image 20251205132253.png]]
Por lo que podemos ver que se les envía toda la cola, y se divide entre los diferentes trabajadores o workers. Que pueden ser instancias de lo que sea. 
#### Reconocimiento de Mensajes (Message acknowledgment):

Imaginemos que tenemos un sistema de mensajería donde: 
1. Un productor envia mensajes a RabbitMQ
2. RabbitMQ los guarda en una cola
3. Un consumidor los recibe y procesa
Nos hacemos la pregunta de: ¿Qué pasaría si el consumidor muere durante el procesamiento? 
Imaginemos el siguiente pipeline: 
![[Pasted image 20251205160220.png]]
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
![[Pasted image 20251205181316.png]]
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
![[Pasted image 20251205183417.png]]
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
![[Pasted image 20251205203353.png]]
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
![[Pasted image 20251206114028.png]]
Hay varios tipos de intercambios disponibles: `direct`, `topic`, `headers` y `fanout`.
Vamos a hacer énfasis en el último, en `fanout`. Vamos a crear un intercambio de este tipo y llamarlo `logs`.
Aquí una tabla sobre la lista de intercambios
```cmd
sudo rabbitmqctl list_exchanges
```
o dentro del contendor podemos hacer: 
![[Pasted image 20251206114526.png]]

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
![[Pasted image 20251211101654.png]]
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
![[Pasted image 20251212082135.png]]
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
![[Pasted image 20251212083648.png]]
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
![[Pasted image 20251212091600.png]]
y lo que recibimos de cuatro (4) consumidores diferentes: 
![[Pasted image 20251212091625.png]]
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
![[Pasted image 20251212114731.png]]
Aqui podemos ver el exchange de tipo `direct` que tiene dos colas atada a esta. La primera cola tiene la llave `orange` y la segunda tiene dos llaves, `black` y `green`.

En tal configuración, un mensaje publicado en el intercambio con una clave de enrutamiento naranja se enrutará a la cola `amq.x`. Los mensajes con una clave de enrutamiento de negro o verde irán a la `amq.x2`. Todos los demás mensajes serán descartados.
#### Múltiples bindings:
Es completamente válido crear múltiples colas con el mismo `binding Key`. En el siguiente ejemplo nuestro exchange `direct` va a actuar como un `fanout` aunque sea de tip`direct` esto debido a que se manda a todas las colas.
![[Pasted image 20251213085919.png]]
#### Emitir los logs:
Para conseguir lo que deseamos que es mandar y recibir un tipo de log, primero vamos a cambiar de `fanout` a `direct`. Entonces: 
```java
channel.exchangeDeclare(EXCHANGE_NAME,"direct");
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
![[Pasted image 20251213110206.png]]
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

![[Pasted image 20251213122415.png]]
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
![[Pasted image 20251213190224.png]]
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

## Streams tutorial (flujo de datos)