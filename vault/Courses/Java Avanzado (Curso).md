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

# Arquitectura y organización

## **Arquitectura Hexagonal**.

## **Domain Driven Design (DDD)**.

## **Microservicios con Spring Boot** (aunque es otro mundo, suma mucho).

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
![[Pasted image 20260204085822.png]]
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

#### Selector
#### Channel
#### Buffer
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