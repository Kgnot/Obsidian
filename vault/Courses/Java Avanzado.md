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

---

# Temas algorítmicos (si querés combinar con estructuras de datos)

## **Tries en Java**.

## **Grafos y algoritmos (Dijkstra, DFS/BFS)**.

## **Árboles AVL y B-Trees**.

---

# Integración con tecnologías externas

## **Conexión con bases de datos (JDBC, HikariCP)**.

## **Mensajería (Kafka, RabbitMQ)**.

## **Uso de Redis desde Java**.

## **Integración con sistemas NoSQL (MongoDB, Cassandra)**.

---

# Temas "Bonus" (si te animás a más)

## **Programación reactiva (Project Reactor o RxJava)**.

## **Micronaut y Quarkus (alternativas ligeras a Spring)**.

## **GraalVM y Native Images**.

## **WebAssembly desde Java**.