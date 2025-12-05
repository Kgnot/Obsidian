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
## Streams tutorial (flujo de datos)