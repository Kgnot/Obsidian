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
### Reconocimiento de Mensajes (Message acknowledgment):

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
#### Forgotten Acknowledgment - Explicación
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
### Durabilidad de un mensaje
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
### Envio justo: 

También llamado Fair dispatch. 
Es posible que haya notado que el envío todavía no funciona exactamente como queríamos.
Por ejemplo, en una situación con dos trabajadores, cuando todos los mensajes extraños son pesados e incluso los mensajes son ligeros, un trabajador estará constantemente ocupado y el otro apenas hará ningún trabajo. Bueno, RabbitMQ no sabe nada de eso y seguirá enviando mensajes de manera uniforme.

Esto sucede porque RabbitMQ solo envía un mensaje cuando el mensaje entra en la cola. No se fija en la cantidad de mensajes no reconocidos para un consumidor. Simplemente envía ciegamente cada n-ésimo mensaje al n-ésimo consumidor.
![[Pasted image 20251205203353.png]]

## Streams tutorial (flujo de datos)