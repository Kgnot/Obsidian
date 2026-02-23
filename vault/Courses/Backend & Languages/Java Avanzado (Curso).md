---
type: course
status: en_progreso
tags: [course, Java Avanzado (Curso)]
date_started: 2024-05-20
---

# Java Avanzado

# Colecciones y estructuras de datos internas

## **Implementación de `HashMap`, `TreeMap`, `LinkedHashMap`** (cómo funcionan internamente).

## **Colisiones en HashMap y cómo las resuelve (buckets y árboles rojos-negros desde Java 8)**.

### HashMap

La clase HashMap implementa la interfaz Map como una tabla hash, que ofrece operaciones de búsqueda, inserción, y eliminación en tiempo constante O(1) en el caos promedio.

**La estructura interna:** 

- Un array de nodos (buckets)
- Cada nodo contiene un par clave-valor y una referencia al siguiente nodo.

**Funcionamiento:** 

1. Cuando se inserta un par clave-valor , Java: 
    1. Calcula el hashcode de la calve.
    2. Aplica una función de dispersión para determinar en qué bucket almacenar el valor
    3. Si ya hay elementos en ese bucket entonces se va a una lista enlazada
2. A partir de Java 8, cuando una lista enlazada supera cierto umbral (típicamente 8 elementos), se convierte automáticamente en un árbol binario balanceado (red-black tree) para mejorar el rendimiento de búsqueda de O(n) a O(log n)

La parte más importante del código es usar la función hash, una función hash puede lucir así:

```java
   private int getIndex(K key) {
        int hashCode = key.hashCode();
        // Aplicamos una máscara para asegurar un índice válido (similar a hashCode % buckets.length)
        return (hashCode & 0x7FFFFFFF) % buckets.length;
    }
```

![image.png](src/Java%20Avanzado/image.png)

### TreeMap:

Treemap implementa la interfaz de NavigableMap y utiliza un árbol Rojo-Negro para almacenar los pares clave valor

**Estructura interna principal:** 

- Un árbol rojo negro balanceado
- Cada nodo tiene la clave valor y referencias a los nodos hijos

**Funcionamiento:** 

1. Las claves se mantienen ordenadas según su orden natural (implementando Comparable) o mediante un Comparator.
2. Todas las operaciones (inserción, eliminación, búsqueda) tienen una complejidad de O(log n).
3. El árbol rojo-negro garantiza que el árbol permanezca balanceado, asegurando que las operaciones sean eficientes.
4. A diferencia de HashMap, no hay riesgo de colisiones, pero las operaciones son más lentas.

![image.png](src/Java%20Avanzado/image%201.png)

### LinkedHashMap

LinkedHashMap extiende HashMap y mantiene el orden de inserción (o el orden de acceso si se configura).

**Estructura interna principal:**

- Hereda la estructura de HashMap (tabla hash)
- Añade una lista doblemente enlazada para mantener el orden

**Funcionamiento:**

1. Combina la tabla hash de HashMap para acceso rápido O(1).
2. Adicionalmente, mantiene una lista doblemente enlazada que conecta todos los elementos.
3. Cuando se inserta un elemento, además de añadirlo a la tabla hash, se añade al final de la lista enlazada.
4. Si se configura con `accessOrder=true` en el constructor, los elementos accedidos se mueven al final de la lista, permitiendo implementar cachés LRU (Least Recently Used).

![image.png](src/Java%20Avanzado/image%202.png)

Como resumen podemos decír: 

- HashMap: mejor rendimiento general pero sin orden garantizado
- TreeMap: elementos ordenados por clave pero operaciones más lentas
- LinkedHashMap: rendimiento similar a HashMap pero mantiene orden de inserción o acceso

## **Concurrent Collections** (`ConcurrentHashMap`, `CopyOnWriteArrayList`).

## **WeakHashMap** y diferencias con HashMap.

---

### Streams y Lambdas (profundización)

## **Parallel Streams** (cuándo conviene y cuándo no).

## **Collectors personalizados**.

## **GroupingBy y PartitioningBy avanzados**.

## **FlatMap y casos complejos (anidación de estructuras)**.

---

# Manejo avanzado de memoria

## **Heap, Stack y Metaspace**.

## **Garbage Collectors (G1, ZGC, Epsilon)**.

## **Tuning de JVM y flags avanzadas**.

## **Análisis de Memory Leaks** con herramientas como **VisualVM** o **YourKit**.

---

# Programación Funcional Avanzada

## **Currying** (aunque no es nativo, podés implementarlo).

## **Composición de funciones**.

## **Monads y Optional combinados**.

---

# Serialización y JSON

## **Serialización y deserialización profunda (transient, serialVersionUID)**.

## **Uso de Jackson y Gson (con configuraciones avanzadas)**.

---

# Concurrencia avanzada

## **CompletableFuture y combinaciones (thenCombine, allOf, etc)**.

## **ForkJoinPool (estructura y cuándo aplicarlo)**.

## **ReentrantReadWriteLock**.

## **Phasers y CountDownLatch avanzados**.

---

# Anotaciones avanzadas

## **Creación de anotaciones personalizadas con Reflection**.

## **Procesadores de anotaciones (Annotation Processors)**.

---

# Expresiones Regulares en Java

## **Regex avanzadas**.

## **Uso de `Pattern` y `Matcher`**.

## **Optimización de Regex**.

---

# Pruebas avanzadas

## **Mockito y PowerMock (mocking de métodos estáticos o privados)**.

## **Test parametrizados con JUnit 5**.

## **Property-Based Testing** (con frameworks adicionales).

---

# Seguridad

## **Hashing de contraseñas (PBKDF2, BCrypt)**.

## **Uso de Keystores y Certificados**.

## **Encriptación con AES y RSA**.

## **Protección contra inyección y deserialización insegura**.

---

# Reflexión y Metaprogramación

## **Acceso dinámico a métodos, campos y constructores**.

## **Creación de proxies dinámicos**.

## **Manipulación de bytecode (ASM)**.

---

# Módulos y Java 9+

## **Sistema de módulos (JPMS)**.

## **Cómo dividir proyectos grandes en módulos**.

## **Uso de servicios en módulos**.

---

# Web y Frameworks (si te interesa)

## **Servlets y filtros avanzados**.

## **Manejo de sesiones y caché HTTP**.

## **Uso de WebSockets**.

## **JAX-RS y Jersey para REST**.

## Programación de redes con I/O No bloqueante 
### TCP
Antes de entrar a todo el tema de lo que es la programación de redes con I/O no bloqueante, debemos entender que es TCP y por qué no, TCP/IP. 

TCP es un protocolo de transporte que garantiza la entrega fiable y ordenada de paquetes de datos entre aplicaciones. Solo es el protocolo de transporte. En sus acciones está: 
- Divide los datos en paquetes
- numera los segmentos
- gestiona el flujo de datos para evitar sobrecarga
- retransmite paquetes perdidos
Todo eso asegura que los datos lleguen completos y en orden

TCP/IP es toda la "suit" que hace posible la comunicación en internet y redes locales. Lo que hace es usar TCP para fiabilidad e IP para direccion y enrutamiento de los paquetes a traves de la red. 
![Pasted image 20260204085822.png](images/Pasted%20image%2020260204085822.png)
En la imagen se observa de forma intuitiva que un mensaje se desfragmente y se envía y se vuelve a construir en otro ordenador según la IP.
### Sockets (bloqueantes vs no bloqueantes)

En el ámbito de sockets: El sistema operativo incluye el recurso de comunicación entre procesos de Berkeley Software Distribution conocido como sockets.

Los sockets son canales de comunicación que permiten que procesos no relacionados intercambien datos localmente y entre redes. Un único socket es un punto final de un canal de comunicación bidireccional. Para mayor información y detallada: https://www.ibm.com/docs/es/aix/7.2.0?topic=concepts-sockets

Aquí entramos con los websockets, los websockets son un protocolo de comunicación bidireccional en tiempo real entre un cliente y un servidor a través de una única conexión de larga duración. A diferencia de las solicitudes HTTP tradicionales, que son unidireccionales, funcionan a través de un único socket TCP. Una vez se establece la conexión se pueden enviar y recibir datos en tiempo real entre cliente y servidor.


Para crear sockets en Java debemos tener en cuenta varios conceptos: 

- Puerto
- Host
- Socket del servidor
- Socket del cliente
- DataOutputStream
- BufferReader
- InputStreamReader

Para ello lo más importante son los últimos 3, haciendo un breve repaso: 
#### `InputStreamReader`

> convierte bytes -> caracteres

Java lee bytes, pero nosotros normalmente queremos texto.
`InputStreamReader` es el puente entre un `InputStream` (bytes) y el mundo de los caracteres (`char`,`srting`
por ejemplo, `System.in` son los bytes, por eso hacemos: 

```java
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

public class ConsoleInputExample {
    public static void main(String[] args) {
        // Create an InputStreamReader wrapped in a BufferedReader
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("Please enter your name:");

        try {
            // Read a line of text from the console
            String name = reader.readLine();
            System.out.println("Hello, " + name + "!");
        } catch (IOException e) {
            System.err.println("An I/O error occurred: " + e.getMessage());
        } finally {
            try {
                // It is important to close the reader
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
```

#### `BufferedReader`

>Lee el texto de forma eficiente (lineas completas)

Encima del `InputStreamReader` se pone un `BufferedReader` para: 
- Mejor rendimiento
- Poder usar `readLine()`

Este `BufferedReader` solo lee texto.

#### `DataOutputStream`
> Escribe datos primitivos en binario

Sirve para enviar datos primitivos de forma estructurada
```java
DataOutputStram dos = new DataOutputStream(System.out);
dos.wirteUTF("ola xd");
dos.flush();
```

Un ejemplo completo sobre un socket tanto cliente como servidor sería: 
```java
import java.io.*;  
import java.net.ServerSocket;  
import java.net.Socket;  
import java.util.logging.Logger;  
  
public class SocketsMain {  
  
    private final int PUERTO = 1234;  
    private final String HOST = "localhost";  
    protected String mensajeServidor;  
    protected ServerSocket ss; // socket del servidor  
    protected Socket cs; // socket del cliente  
    protected DataOutputStream salidaServidor, salidaCliente; // flujo de salida  
  
    public SocketsMain(String tipo) throws IOException {  
        if (tipo.equals("servidor")) { // controlamos el servidor si es servidor  
            ss = new ServerSocket(PUERTO);  
            cs = new Socket();  
        } else {  
            cs = new Socket(HOST, PUERTO); // si no controlamos solo cliente  
        }  
    }  
  
//    public static void main(String[] args) throws IOException {  
//        Servidor serv = new Servidor(); //Se crea el servidor  
//  
//        System.out.println("Iniciando servidor\n");  
//        serv.startServer(); //Se inicia el servidor  
//    }  
  
    public static void main(String[] args) throws IOException  
    {  
  
        Cliente cli = new Cliente(); //Se crea el cliente  
  
        System.out.println("Iniciando cliente\n");  
        cli.startClient(); //Se inicia el cliente  
    }  
  
  
    private static class Servidor extends SocketsMain {  
  
        private static Logger logger = Logger.getLogger(Servidor.class.getName());  
  
        public Servidor() throws IOException {  
            super("servidor");  
        }  
  
        public void startServer() {  
            try {  
                logger.info("Servidor esperando conexiones...");  
                cs = ss.accept(); // aceptamos conexiones de los clientes | en espera  
                logger.info("Cliente conectado: " + cs.getInetAddress().getHostAddress());  
                // flujo de salida hacia el cliente  
                salidaServidor = new DataOutputStream(cs.getOutputStream());  
                mensajeServidor = "Hola desde el servidor!";  
                // enviamos el mensaje al cliente  
                salidaServidor.writeUTF(mensajeServidor);  
                logger.info("Mensaje enviado al cliente: " + mensajeServidor);  
  
                //Se obtiene el flujo entrante desde el cliente  
                BufferedReader entrada = new BufferedReader(new InputStreamReader(cs.getInputStream()));  
  
                while((mensajeServidor = entrada.readLine()) != null) //Mientras haya mensajes desde el cliente  
                {  
                    //Se muestra por pantalla el mensaje recibido  
                    System.out.println(mensajeServidor);  
                }  
  
                salidaServidor.close();  
                cs.close();  
                ss.close();  
            } catch (IOException e) {  
                e.printStackTrace();  
            }  
        }  
    }  
  
  
    private static class Cliente extends SocketsMain {  
  
        private static Logger logger = Logger.getLogger(Cliente.class.getName());  
  
        public Cliente() throws IOException {  
            super("cliente");  
        }  
  
        public void startClient() {  
            try  {  
                //Flujo de datos hacia el servidor  
                salidaServidor = new DataOutputStream(cs.getOutputStream());  
  
                //Se enviarán dos mensajes  
                for (int i = 0; i < 2; i++)  
                {  
                    //Se escribe en el servidor usando su flujo de datos  
                    salidaServidor.writeUTF("Este es el mensaje número " + (i+1) + "\n");  
                }  
  
                cs.close();//Fin de la conexión  
  
            } catch (IOException e) {  
                e.printStackTrace();  
            }  
        }  
    }  
}
```

Pero entonces que es un socket I/O no bloqueante? 

Cuando aqui en java nosotros hacemos : 
```java
public void startServer() {  
            try {  
                logger.info("Servidor esperando conexiones...");  
                cs = ss.accept(); // aceptamos conexiones de los clientes | en espera  
                logger.info("Cliente conectado: " + cs.getInetAddress().getHostAddress());
                ...
```

Ese `accept()` es un "bloqueante" lo cual, puede manejar muchos clientes pero todos seran un hilo diferente y al final termina explotando, a diferencia de "no bloqueante" el cual no detiene o bloquea la ejecución, mas bien si no hay datos disponibles para leer la llamada regresa a esperar y corre a otro usuario.
### Java NIO

Java NIO o (New I/O) es el modelo moderno de entrada/salida en Java, pensando para alto rendimiento, concurrencia eficiente y I/O no bloqueante. Es clave cuando se trabaja con servidores, sockets, streams de red o sistemas que manejen muchas conexiones a la vez. 

#### Buffer
En java NIO, un Buffer es una estructura de memoria controlada por la JVM que actúa como zona intermedia entre:
- una fuente/destino de datos (archivo, socket, red, etc.)
- y tu código Java
Formalmente encontramos: 
>Un `Buffer` es un contenedor tipado de datos, con estado interno, diseñado para operaciones I/O de alto rendimiento

No solo es un array, es un objeto con estado.
***
##### Aqui nos preguntamos entonces para qué existen los buffers?
**La problemática sin buffer:**
El hardware **no trabaja al ritmo de tu código java**
- El SO lee bloques grandes
- La red entrega datos en paquetes
- El CPU es mucho más rápido que el I/O
Si intentaras leer byte por byte directamente:
- Muchísimas llamadas al sistema
- Context switching costoso (=={pink}proceso en el que la CPU de un ordenador detiene una tarea, guarda su estado ([registros, contador de programa](https://www.google.com/search?client=firefox-b-d&q=registros%2C+contador+de+programa&ved=2ahUKEwj1uZ_dl8GSAxVGQzABHaeMCSEQgK4QegQIARAD)) y carga el estado de una nueva tarea para permitir la [multitarea](https://www.google.com/search?client=firefox-b-d&q=multitarea&ved=2ahUKEwj1uZ_dl8GSAxVGQzABHaeMCSEQgK4QegQIARAE)==.)
- Rendimiento pésimo

La solución es usar una zona intermedia donde 
- El sistema escribe grandes bloques
- Tu aplicación procesa a su ritmo

```text
Vamos a tocar un tema y es ejemplificar mucho mejor lo que se hizo arriba
Hagamos una analogía, imaginemos: 

Hardware -> Camion cisterna que puede descargar 1000 litros de golpe
Código java -> persona que necesita un vaso de agua a la vez

Sin buffer:
- Pides el camion: "Dame un vaso de agua"
- El camionero se baja y nos llena el vaso
- El minuto dices: "Necesito otro vaso de agua "
- Vuelve el camion repleto y repite el proceso
- !Esto es absudro y costoso, y lento!
  
Cuando usamos buffer:
- El camion descarga los 1000 litros en un tanque (buffer)
- Tu tomas vasos del tanque cuando necesites
- Cuando el tanque se vacía, llamas al camión otra vez
- Esto es más eficiente y rápido.
  
  
En un mundo sin buffers: 

Tu código:  "Dame el byte 1"
Disco:      [Lee 4096 bytes, te da el 1]
Tu código:  "Dame el byte 2"  
Disco:      [Lee 4096 bytes OTRA VEZ, te da el 2]
Tu código:  "Dame el byte 3"
Disco:      [Lee 4096 bytes OTRA VEZ...]

En uno con buffers: 

Tu código:  "Dame 8192 bytes"
Disco:      [Lee 2 bloques de 4096, llena el buffer]
Tu código:  Procesa bytes 1..8192 de su memoria RAM
            (500,000 veces más rápido)
```

##### **¿Qué tipos de buffers hay?:**

`Buffer` es una clase abstracta, cuyas implementaciones concretas tenemos: 
- `ByteBuffer`
- `CharBuffer`
- `IntBuffer`
- `LongBuffer`
- etc.
En I/O red y archivos:

>ByteBuffer el 99% de los casos

##### Anatomía de un buffer: 

1. Capacity
	-  Tamaño total del buffer
	- Fijo al crearlo
```java
public class MainPrueba {  
  
    private static final Logger logger = Logger.getLogger(MainPrueba.class.getName());  
  
    public static void main(String[] args) {  
        ByteBuffer buffer = ByteBuffer.allocate(10);  
//        buffer.capacity();  
        logger.info("Capacidad del ByteBuffer: " + buffer.capacity());  
    }  
}
```

2. Position:
	- Índice actual
	- Indica dónde se va a leer o escribir
		inicialmente empieza en 0 y se mueve automaticamente con cada `put()` o `get()` . Un programa que podemos probar es: 
```java 
public class MainPrueba {  
    private static final Logger logger = LoggerFactory.getLogger(MainPrueba.class);  
  
    public static void main(String[] args) {  
        ByteBuffer buffer = ByteBuffer.allocate(10);  
//        buffer.capacity();  
        logger.info("Capacidad del ByteBuffer: {}", buffer.capacity());  
        logger.info("Obtuvimos:{}", buffer.get());  
        MDC.put("transactionId", "12345");  
        buffer.put("H".getBytes());  
        buffer.put("o".getBytes());  
        logger.info("Obtuvimos:{}", (char) buffer.get()); // Letra H en ascii  
        MDC.clear();  
  
  
        while(buffer.hasRemaining()) {  
            logger.info("Posición actual: {}", buffer.position());  
            logger.info("Límite actual: {}", buffer.limit());  
            logger.info("Capacidad actual: {}", buffer.capacity());  
            buffer.put((byte) 'A');  
        }  
    }  
}
```
Con eso podemos observar que tanto `put` como `get` mandan el puntero a la derecha, podemos jugar con la línea 12, el `buffer.get()` si lo quitamos una casilla atrás y así
3. Limit
	En el código anterior observamos ese limite, nos marca:
- El límite lógico
- Hasta dónde se puede leer o escribir
3. Mark (opcional)
- Marca una posición para volver después
- Poco usada, pero existe

##### Estados del Buffer

Un buffer no sabe solo si está leyendo o escribiendo, el estado lo definimos nosotros

**Estado 1: Escritura:**
Se usa cuando se recibe datos:
```java
buffer.put(byte);
```
**Estado 2: Lectura**
Usado cuando se procesa datos desde el buffer: 
```java
buffer.flip() // Esto básicamente lo que hace es cuando terminas de escribir y ahora vas a leer, entonces reinicia todo

//La lógica sería: 
ByteBuffer buffer = ByteBuffer.allocate(1024);

// 1. escribir datos en el buffer
channel.read(buffer);

// 2. cambiar a modo lectura
buffer.flip();

// 3. procesar datos
while (buffer.hasRemaining()) {
    byte b = buffer.get();
}

// 4. limpiar para reutilizar
buffer.clear();

```

Hay Buffers directos y no directos
##### Buffers directos vs Buffers no directos

Heap buffer:
```java
ByteBuffer.allocate(1024);
```
- Vive en el heap
- Más barato de crear
- Copia extra ente JVM  SO

Direct Buffer:
```java
ByteBuffer.allocateDirect(1024);
```
- Vive fuera del heap
- Menos copias
- Más rapido en I/O
- Más caro de crear
El uso típico de cada uno:
- Heap: Lógica interna
- Direct: Red, archivos grandes, servidores

#### Selector
Para selector vamos a enteder varios puntos iniciales.

¿Qué problema resuelve selector?
Imaginemos un servidor TCP clásico (java.io):
- 1 conexion = 1 hilo
- 1000 conexiones = 1000 hilos
Esto tiene problemas como: 
- Consumo brutal de memoria
- Context switching constante
- El 90% del tiempo los hilos estan esperando I/O

Este modelo no escala.

##### La idea fundamental e selector
Un selector permite que un solo hilo supervise muchos canales y sea notificado solo cuando alguno puede: 
- aceptar una conexión
- leer datos
- escribir datos
Su definición formal:
> Un `Selector` es un multiplexor de eventos de I/O que monitorea múltiples `SelectableChannel` y notifica cuando alguno está listo para una operación específica.

Pero y ¿Qué no hace?
- No lee datos
- No escribe datos
- No procesa lógica
- No gestiona buffers
El selector solo notifica.

##### Requisitos para usar un selector
No cualquier cosa se puede registrar

Codiciones obligatorias: 

1. El channel debe ser `SelectableChannel`
2. El channel debe estar en **modo no bloqueante**
3. Debe registrarse con un interés específico.
Por ejemplo: 
```java
SocketChannel channel = socketChannel.open();
channel.configureBlocking(false);
```

¿Cómo se registra?:
```java
Selector selector = Selector.open();
channel.register(selector, SelectionKey.OP_READ);
```

Hasta aqui debemos preguntarnos ¿qué es el `SelectionKey`? Pues es un puente entre el evento que ocurre y el canal que lo maneja. Es como un contrato.

Cada uno de los registros genera un `SelectionKey`

La Key representa: 
- El channel
- El selector
- Las operaciones de interes
- el estado del canal
Las operaciones posibles: 
- OP_ACCEPT
- OP_CONNECT
- OP_READ
- OP_WRITE

Por ejemplo: 
```java
key.isReadable();
key.isWritable();
key.isAcceptable();
key.isConnectable();
```

Y el ciclo central del selector, el corazón de NIO:
```java
while(true){
	selector.select();
	
	Set<SelectionKey> keys = selector.selectedKeys();
	Iterator<SelectionKey> it = keys.iterator();
	
	while(it.hasNext()){
		SelectionKey key = it.next();
		it.remove();
		
		if (key.isReadable()) {
            // leer
        }
        if (key.isWritable()) {
            // escribir
        }
	
	}
}
```
 Qué hace `select()`
- Bloquea el hilo
- Espera hasta que **al menos un canal esté listo**
- Devuelve cuántos canales cambiaron de estado    

No consume CPU mientras espera.
> OP_WRITE: el más peligroso
>Detalle importante:
>- Un socket suele estar siempre listo para escribir
>- Registrar OP_WRITE sin control causa loops infinitos
>Patrón correcto:
>- Registrar OP_WRITE solo cuando tienes datos pendientes
>- Eliminarlo cuando terminas de escribir
>`key.interestOps(SelectionKey.OP_READ);`

Un solo hilo con Selector puede manejar:
- miles de conexiones TCP
- sin bloquear
- con consumo estable

Esto es la base de:
- Netty
- WebFlux
- Undertow
- Kafka
- Redis (conceptualmente)
#### Channel
En el apartado anterior mencionamos a los `channel` pero no hemos definido que son, bueno. Hasta ahora tenemos
- Buffer = memoria
- Selector = notificación
##### Definición formal
Un `Channel` es una abstracción bidireccional de una fuente o destino de datos capaz de trasferir datos hacia o desde uno o más buffers

Es decir: 
- Representa una conexión con algo externo
- Puede ser un archivo, socket, UDP, etc.
- Siempre intercambia datos mediante buffers
Un channel solo mueve los datos.
¿Pero entonces qué diferencia un `Channel` de un `Stream`?

Un Stream (Java.io)
- Unidireccionales
- Bloqueantes
- Ocultan buffers
- Orientado a flujos
Un Channel (Java.nio):
- Bidireccionales
- Pueden ser no bloqueantes
- Buffers explícitos
- Orientado a bloques

##### Tipos principales de channels: 

**File I/O**
- `FileChannel`
**TCP**
- `SocketChannel`
- `ServerSocketChannel`
**UDP**
- `DatagramChannel`
**Async (NIO.2)**
- `AsyncrhonousSocketChannel`

Para servidores: 
> `ServerSocketChannel` + `SocketChannel` son el núcleo

Vamos a colocar un ejemplo general de Java NIO: 
```java

```
#### Event loop

### Protocolo sobre TCP
#### Framing
#### Delimiatadores
#### Problemas reales

### HTTP desde cero (sobre NIO)

#### Request
#### Response
#### Headers
#### Content-lenght

### Websocket
#### Upgrade _HTTP_
#### Frames
#### Texto vs binario
### HttpAsync
#### Porque no usar threads
### Reactor pattern
### Netty / Webflux

### Servers de alto rendimiento
#### Nginx
#### Netty
#### Tomcat NIO

### Arquitectura basada en NIO


---

# Temas algorítmicos (si querés combinar con estructuras de datos)

## **Tries en Java**.

## **Grafos y algoritmos (Dijkstra, DFS/BFS)**.

## **Árboles AVL y B-Trees**.

---

# Temas "Bonus"

## **Programación reactiva (Project Reactor o RxJava)**.

## **Micronaut y Quarkus (alternativas ligeras a Spring)**.

## **GraalVM y Native Images**.

## **WebAssembly desde Java**.