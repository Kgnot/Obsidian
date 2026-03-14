---
type: course
status: en_progreso
tags:
  - course
date_started: 2024-05-20
---

# LOGS: 
Antes de entrar en el mundo de Springboot debemos entender sobre los logs ya que mas adelante nos será útil. (Aunque ese más adelante sera mucho mucho más adelante por lo que se puede omitir este apartado).

La librería recomendada es: 
```java
import org.slf4j.Logger;  
import org.slf4j.LoggerFactory;
```
Y su inicialización: 

```java
public static final Logger logger = LoggerFactory.getLogger(InicialApplication.class);
```

La manera en que lo podmeos usar:
```java
@SpringBootApplication  
public class InicialApplication {  
  
    public static final Logger logger = LoggerFactory.getLogger(InicialApplication.class);  
  
    public static void main(String[] args) {  
        SpringApplication.run(InicialApplication.class, args);  
  
        logger.info("Aplicación iniciada correctamente");  
  
        new Thread(() -> {  
            logger.info("Estoy en un hilo aparte");  
        },"Estoy aqui ey").start();  
  
        Thread nuevoHilo = new Thread(() -> {  
            logger.info("Otro hilo aparte");  
        },"hilo-logger-2");  
        nuevoHilo.start();  
    }  
}
```
Esto nos genera el siguiente resultado: 
![Pasted image 20260130081127.png](images/Pasted%20image%2020260130081127.png)
Tal como observamos tenemos los logs de la información del hilo.

Podemos modificar en `application.properties` o `application.yml` los logs de la siguiente forma: 
```yml
logging:
  pattern:
    console: "%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n"
```
![Pasted image 20260130081250.png](images/Pasted%20image%2020260130081250.png)

Queda más «rústico», por decirlo de alguna forma. 

Una de las características es que en producción siempre toca loggear sin tanto detalle, es decir: 
```yaml
# dev
logging.level.root=DEBUG

# prod
logging.level.root=INFO

```

Es bueno loggear el inicio y final en procesos largos.

Si se quiere investigar más, el término MDC debe ser importante para su búsqueda.
## Loki + Graphana

Loki es un sistema de logs creado por Grafana Labs con una idea clave: 
> Indexa etiquetas, no el contenido del log

Entonces podemos tener una arquitectura como por ejemplo: 
```plain text
Spring Boot
   ↓
Promtail (agente)
   ↓
Loki (almacena logs)
   ↓
Grafana (consulta y visualiza)
```

la configuración minima para ello (en docker) es: 
```yml title=docker-compose.yml
version: "3.8"  
  
name: "Prueba logger Spring Boot con Loki y Grafana"  
  
services:  
  app:  
    image: eclipse-temurin:21-jre-alpine  
    container_name: spring_app  
    volumes:  
      - ./build/libs/app.jar:/opt/app/app.jar  
      - ./logs:/logs  
    working_dir: /opt/app  
    command: ["java", "-jar", "app.jar"]  
    ports:  
        - "8080:8080"  
    depends_on:  
      - loki  
  loki:  
    image: grafana/loki:2.8.2  
    container_name: loki  
    ports:  
      - "3100:3100"  
    command: -config.file=/etc/loki/local-config.yaml  
  
  promtail:  
      image: grafana/promtail:2.9.0  
      container_name: promtail  
      volumes:  
          - ./logs:/logs  
          - ./promtail/config.yaml:/etc/promtail/config.yaml  
      command: -config.file=/etc/promtail/config.yaml  
      depends_on:  
        - loki  
  
  grafana:  
    image: grafana/grafana:10.2.0  
    container_name: grafana  
    ports:  
      - "3000:3000"  
    environment:  
      - GF_SECURITY_ADMIN_USER=admin  
      - GF_SECURITY_ADMIN_PASSWORD=admin  
    depends_on:  
      - loki
```

Necesitamos una configuración de promtail: 
```yaml title=config.yaml
server:  
  http_listen_port: 9080  
  grpc_listen_port: 0  
  
positions:  
  filename: /tmp/positions.yaml  
  
clients:  
  - url: http://loki:3100/loki/api/v1/push  
  
scrape_configs:  
  - job_name: spring-app  
    static_configs:  
      - targets:  
          - localhost  
        labels:  
          job: spring-app  
          __path__: /logs/*.log
```

Aqui decimos que lee archivos, pone labels y los envía a loki.

Ahora necesitamos que Spring Boot escriba logs a archivo, entonces: 

```yml title=application.yml
spring:  
  application:  
    name: inicial  
  
logging:  
  pattern:  
    console: "%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n"  
    file: "%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n"  
  file:  
    name: logs/spring-app.log  
  level:  
    root: INFO  
    org.springframework: INFO

```

Y montamos ese folder en docker (no olvidemos también añadir el `jar`): 
```yml title=docker-compose.yml
volumes:
  - ./logs:/logs
  - ./build/libs/app.jar:opt/app/app.jar
```
***
¡Dato importante no olvidar la estructura de carpetas de Linux: 
![Pasted image 20260130104152.png](images/Pasted%20image%2020260130104152.png)
Por esa razón se coloca en `/opt`
***
Despues de realizar esas acciones, debemos ir a nuestro Grafana, agregar la conección: 
![Captura de pantalla 2026-01-30 100155.png](images/Captura%20de%20pantalla%202026-01-30%20100155.png)
Luego de eso debemos agregar un dashboard, preferiblemente, por temas prácticos, no ahondaremos en ello, pero es posible pedir un archivo `json` a la IA con el contexto de tu trabajo y que este te genere dicho `json` e importarlo, podría quedar de la siguiente forma: 

![Captura de pantalla 2026-01-30 103159.png](images/Captura%20de%20pantalla%202026-01-30%20103159.png)

## MDC: 

MDC nos da contexto sobre un logger, este contiene pues, un mapa el cual podemos añadir, imaginemos que estamos en un proyecto de cero con gradle, debemos añadir las siguientes dependencias: 
```gradle
implementation 'org.slf4j:slf4j-api:2.0.17'  
implementation 'ch.qos.logback:logback-classic:1.4.11'
```
Luego en una clase usamos el factory: 
```java
private static final Logger logger = LoggerFactory.getLogger(MainPrueba.class);
```

Y a la hora de usar hacemos por ejemplo:
```java
logger.info("Obtuvimos:{}", buffer.get());  
MDC.put("transactionId", "12345");  
buffer.put("H".getBytes());  
buffer.put("o".getBytes());  
logger.info("Obtuvimos:{}", buffer.get(1)); // Letra H en ascii  
MDC.clear();
```

Como vemos esta puesto un `MDC` este nos ayuda para generar ese contexto, entonces, para verlo necesitamos un último archivo en resources: 
```xml
<configuration>  
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">  
        <encoder>            <!-- Patron: Fecha (Hora) [Hilo] Nivel Logger - Mensaje -->  
            <pattern>%d{HH:mm:ss.SSS} [%thread] %X{transactionId} %highlight(%-5level) %cyan(%logger{36}) - %msg%n</pattern>  
        </encoder>    </appender>  
    <root level="INFO">  
        <appender-ref ref="CONSOLE" />  
    </root>
</configuration>
```

Con esto podemos poner la "key" del mapa que construimos con MDC. Al final queda de la siguiente forma: 



# Java Spring Boot

## REST CRUD APIs:

REST, que significa Representational State Transfer, es un estilo arquitectónico utilizado en el desarrollo web para construir aplicaciones web ligeras, mantenibles y escalables. Una API REST, también conocida como servicio web REST, se basa en este estilo arquitectónico y se utiliza para crear aplicaciones web que pueden interactuar y comunicarse con otras aplicaciones web a través de Internet. Estas APIs REST están diseñadas para aprovechar los protocolos existentes, lo que las hace fáciles de usar y desarrollar.

Por otro lado, los servicios REST son un conjunto de principios de arquitectura que permiten la comunicación entre sistemas a través de Internet. Los servicios REST se utilizan para construir interfaces que pueden ser utilizadas por varias aplicaciones para comunicarse entre sí.

En resumen, REST API, REST Web Services y REST Services se refieren a servicios basados en la arquitectura REST que permiten la comunicación entre diferentes aplicaciones a través de la web.

### REST sobre HTTP:

Como primera instancia, lo más común es unas rest sobre operaciones HTTP. HTTP tiene varios métodos sobre las CRUD los cuales tenemos: 

| HTTP MÉTODO | OPERACIÓN CRUD |
| --- | --- |
| POST | Crea una nueva entidad |
| GET | Lee una lista de entidades o una sola entidad |
| PUT | Modifica una entidad existe |
| DELETE | Elimina una entidad existente |

Ahora, veremos las HTTP Request y HTTP Response: 

![Untitled](src/Java%20SpringBoot/Untitled.png)

En el HTTP Request tenemos: 

- Request Line: Es el comando HTTP
- Header variables: metadatos solicitados
- Message body: Contenido del mensaje

Para el HTTP Response Message: 

- Response Line: El protocolo que se esta manejando y estado del código
- Header variables: tipo de los metadatos (si es JSON o XML, la longitud de los datos).
- Message Body: Contenido del mensaje en la configuración dada. (JSON XML , etc.).

#### HTTP Response - Status Code:

![Untitled](src/Java%20SpringBoot/Untitled%201.png)

### Sobre el código Java Spring:

Tal como se ve al inicio del curso se hace algo totalmente simple: 

```java
@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

}
```

```java
@RestController
@RequestMapping("/test")
public class DemoRestController {

    //add code for the
    @GetMapping("/hello")
    public String sayHello(){
        return "hello2 world";
    }
}

```

Y usando Postman podemos observar el rest 

![Untitled](src/Java%20SpringBoot/Untitled%202.png)

NOTA: Algo a tener en cuenta es las conversiones, mapeo, etc. que existen de JSON a Java POJO (Que son las clases normales de java ), existe algo llamado Jackson:  

Jackson es una biblioteca popular en Java para procesar datos JSON. Proporciona funcionalidades para convertir objetos Java a JSON y viceversa, lo que se conoce como "data binding" (enlace de datos). Aquí te explico los conceptos clave relacionados con Jackson, JSON y Java POJO, así como los términos de mapeo, serialización, marshalling, unmarshalling y deserialización.

#### Jackson Data Binding

**Jackson** es una biblioteca para procesar JSON en Java. Proporciona varias funcionalidades, incluyendo:

- **Data Binding**: Conversión automática entre JSON y objetos Java (POJOs).
- **Tree Model**: Manipulación de JSON como un árbol de nodos (similar a DOM para XML).
- **Streaming API**: Lectura y escritura de JSON como una secuencia de tokens.

#### JSON y Java POJO

**JSON (JavaScript Object Notation)** es un formato ligero de intercambio de datos que es fácil de leer y escribir para humanos y fácil de analizar y generar para máquinas.

**Java POJO (Plain Old Java Object)**: Un POJO es un objeto Java simple que no depende de ninguna tecnología o marco específico. Los POJOs suelen utilizarse para representar datos que se pueden convertir a y desde JSON.

#### Mapeo, Serialización, Marshalling, Unmarshalling, Deserialización

1. **Mapeo**:
    - **Definición**: Es el proceso de relacionar los campos de un objeto Java (POJO) con las claves y valores de un JSON.
    - **Ejemplo**:
    
    ```json
    { "name": "John", "age": 30 }
    ```
    
    Mapeado a: 
    
    ```java
    public class Person {
        private String name;
        private int age;
        // getters and setters
    }
    ```
    

Las demás, es decir Marshalling, Unmarshalling, Deserialización las veremos después xd: 

La manera mas sencilla para dar a entender este Jackson es enviando una `List<Object>` como `@GetMapping` y automáticamente se vera como un JSON.

### Variables del Path o de Ruta

Tenemos el ejemplo: 

```java
//Apartado de la clase estudiante
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Student {
    private String fistName;
    private String lastName;
    private int age;
}

// Apartado del Rest Controller
@RestController
@RequestMapping("/api")
public class StudentRestController {

    @GetMapping("/Students")
    public List<Student> getStudents() {
        List<Student> studentList = new ArrayList();

        //adding students
        studentList.add(new Student("Daniel", "Ricaurte", 15));
        studentList.add(new Student("Hakio", "Zairy", 15));
        studentList.add(new Student("Luis", "Benabides", 15));

        return studentList;
    }
}
```

El resultado que tenemos es: 

![Untitled](src/Java%20SpringBoot/Untitled%203.png)

---

Dentro de estas variables de ruta tenemos el GET: 
Aqui podemos obtener cada uno de los estudiantes usando los corchetes: `/api/students/{studentID}` 
Para realizarlo debemos vincular la variable al método usando @PathVariable . Ejemplo: 

```java
@RestController
@RequestMapping("/api")
public class StudentRestController{
		
		@GetMapping("/students/{studentID}")
		public Student getStudent(@PathVariable int studentID){ // Como podemos observar debe ser el mismo nombre de la variable
				List<Student> listStudents = new ArrayList();
				//.. resto de codigo
				
				return listStudents.get(studentID);
		}

}
```

Ahora bien. Entramos a la parte de los errores,  ¿Cómo creamos un exception para cada uno de los errores, o cuál es la mejor manera para poder abastecerlos? El código necesario es:  [Esto es de una forma mas abierta]. 

```java
public class StudentNotFoundException extends RunTimeException {

	public StudentNotFoundException(String message){
		super(message);
	}
}
// --------------------------------- Parte del controlador -----------------------------
@RestController
@RequestMapping("/api")
public class StudentRestController{
	
	...
	@ExceptionHandler
	public ResponseEntity<StudentErrorResponse> handleException(StudentNotFoundException exc){
	
				StudentErrorResponse error =  new StudentErrorResponse();
				
				error.setStatus(HttpStatus.NOT_FOUND.value());
				error.setMessage(exc.getMessage());
				error.setTimeStamp(System.currentTimeMillis());
				
				return new ResponseEntity<>(error,HttpStatus.NOT_FOUND);
	}
}
```

![Untitled](src/Java%20SpringBoot/eef26c87-0c62-4e2a-9d9c-1d95ac5fda54.png)

**El proceso de programación es:**

1. **Crear una clase de respuesta de errores propios**
2. **Crear una clase de excepciones propios**
3. **Modificar el servicio REST para implementar las excepciones si no encuentra el estudiante**
4. **Adicionar el ayudante o Handler usando la anotación @ExceptionHanlder.**

Los dos primeros pasos se basan en el código: 

```java
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class StudentErrorResponse {

    private int status;
    private String message;
    private long timeStamp;

}
//- ----------------------------------- Clase de no encontrado ----------------------- -

public class StudentNotFoundException extends RuntimeException{

    public StudentNotFoundException(String message) {
        super(message);
    }

    public StudentNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }

    public StudentNotFoundException(Throwable cause) {
        super(cause);
    }
}

```

**Modificar el servicio REST para implementar las excepciones si no encuentra el estudiante:**

```java
@RestController
@RequestMapping("/api")
public class StudentRestController {

    private List<Student> studentList;

		// Rsto del código
    @GetMapping("/Students/{studentID}")
    public Student getStudentID(@PathVariable int studentID){

				// Esta es la parte que nosotros estamos haciendo, creando el new StudentNotFoundException que creamos arriba
        if((studentID>= studentList.size()) || (studentID< 0)){
            throw new StudentNotFoundException("Student id not found "+studentID);
        }
        return studentList.get(studentID);
    }

}
```

**Adicionar el ayudante o Handler usando la anotación @ExceptionHanlder.**

La idea es: 

![Untitled](src/Java%20SpringBoot/Untitled%204.png)

---

![Untitled](src/Java%20SpringBoot/Untitled%205.png)

```java
//Todo dentro del @RestController 

 @ExceptionHandler
    public ResponseEntity<StudentErrorResponse> hanlderException(StudentNotFoundException exc){
        StudentErrorResponse error =  new StudentErrorResponse();

        error.setStatus(HttpStatus.NOT_FOUND.value());
        error.setMessage(exc.getMessage());
        error.setTimeStamp(System.currentTimeMillis());

        return new ResponseEntity<>(error,HttpStatus.NOT_FOUND);
    }
```

#### Para hacer las excepciones de cualquier forma, es decir EXCEPCIONES GENERICAS ESPECIFICAS:

```java
@ExceptionHandler
    public ResponseEntity<StudentErrorResponse> handlerException(Exception exc) {
        StudentErrorResponse error = new StudentErrorResponse();

        error.setStatus(HttpStatus.BAD_REQUEST.value());
        error.setMessage(exc.getMessage());
        error.setTimeStamp(System.currentTimeMillis());

        return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
    }
```

La diferencia entre ambas radica en el tipo de excepción que nosotros estamos recibiendo como argumento .

#### Para hacer las excepciones como:  EXCEPCIONES GENERICAS GLOBALES:

Es decir de cualquier @RestController que se haga dentro del aplicativo va a generar esas mismas excepciones, la idea es usar la anotación `@ControllerAdvice` 

```java
package com.example.demo.rest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class StudentRestExceptionHandler {
   //add  an exception handler using @ExceptionHanlder

    @ExceptionHandler
    public ResponseEntity<StudentErrorResponse> hanlderException(StudentNotFoundException exc) {
        StudentErrorResponse error = new StudentErrorResponse();

        error.setStatus(HttpStatus.NOT_FOUND.value());
        error.setMessage(exc.getMessage());
        error.setTimeStamp(System.currentTimeMillis());

        return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
    }

    //add an new exception handler ... to catch any exception
    @ExceptionHandler
    public ResponseEntity<StudentErrorResponse> handlerException(Exception exc) {
        StudentErrorResponse error = new StudentErrorResponse();

        error.setStatus(HttpStatus.BAD_REQUEST.value());
        error.setMessage(exc.getMessage());
        error.setTimeStamp(System.currentTimeMillis());

        return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
    }
}

```

La idea aqui es solo usar esta clase para todo tipo de excepciones que pueden ocurrir, como observamos aqui solo es meramente necesario el código del segundo método debido a que maneja excepciones de la clase `Student` .

### REST API Design

Para crear un REST API Design debemos tener en cuenta 3 cosas:

1. Revisar los requerimientos de la API
2. Identificar el recurso principal y entidades
3. Usar los métodos HTTP para asignar vida a los recursos
Para el paso 3 recordar: 

![Untitled](src/Java%20SpringBoot/Untitled%206.png)

Tambien entender: 

![Untitled](src/Java%20SpringBoot/Untitled%207.png)

Cosas que no se deben hacer: 

![Untitled](src/Java%20SpringBoot/Untitled%208.png)

#### Ejemplo PAYPAL:

![Untitled](src/Java%20SpringBoot/Untitled%209.png)

### Completitud

#### Capa de servicios

La capa de servicios es una implementación del patrón de diseño **«Service Fecade»** la cual sirve para implementar múltiples fuentes de datos (data sources) 

![Untitled](src/Java%20SpringBoot/Untitled%2010.png)

La capa de servicios se trata de una interfaz : 

```java
public interface EmployeeService{
	List<Employee> findAll();
}
```

El paso número dos es implementar esta interfaz: 

```java
@Service
public class EmployeeServiceImpl implements EmployeeService {

	//inyectamos EmpleadoDAO
	@Override
	public List<Employee> finAll(){
			return employeeDAO.findAll();
	}

}
```

@Service habilita el escaneo del componente. Tambien recordar que la capa de servicio es la que debe hacer los tramites transaccionales.

#### Añadir o actualizar un dato en la base de datos

Para añadir o actualizar un elemento nosotros debemos usar el `merge` es decir:

```java
@Override
public Employee save(Employee theEmployee){
		Employe dbEmployee = entityManager.merge(theEmployee);
		return  dbEmployee;
}
```

                                             SI EL ID == 0 ENTONCES SE GUARDA O SE INSERTA, DE LO CONTRARIO SE ACTUALIZA

### Spring Data JPA (Simplifica las cosas)

Nosotros anteriormente debíamos usar: 

![Untitled](src/Java%20SpringBoot/Untitled%2011.png)

Con la implementación de JPA nosotros ahora solo necesitamos una interfaz que obtenga lo siguiente: 

```java
public interface EmployeeRepository extends JpaRepository<Employee,Integer> {
        // jpaRepository<Entity,PrimaryKey>
        // Es todo el codigo que se necesita . . .  XD!
}
```

Quedando las carpetas de la siguiente forma: 

![Untitled](src/Java%20SpringBoot/Untitled%2012.png)

Y `EmployeeServiceImpl` quedaría de la siguiente forma:  (añadir @Service)

![Untitled](src/Java%20SpringBoot/Untitled%2013.png)

De esta manera se implementan El CRUD básico y algunos más que se pueden observar en la implementación. 

### Spring Data REST (Simplifica las cosas de la parte del REST)

El Spring Data REST , al igual que el Spring Data JPA usamos interfaces para establecer el CRUD minimo, y los endpoints necesarios, de forma natural vendrían siendo : 

![Untitled](src/Java%20SpringBoot/Untitled%2014.png)

Todo gracias a instalar una dependencia la cual es: 

```yaml
<dependency>
	<groupID>org.springframework.boot</groupID>
	<artifactId>spring-boot-starter-data-rest</artifactId>
</dependency>
```

En resumen necesitamos tres cosas para poder lograr este REST rapido :

1. Nuestra entidad
2. JpaRepository: El usado en Spring Data JPA donde: `EmployeeRepository extends JpaRepository` 
3. La dependencia de Maven POM para: `spring-boot-starter-data-rest`

Una vez, solo haber implementado la dependencia nos debería ya implementar todo, con el slash de `employees` .
Que como sabemos es la norma que sigue.

Otra anotación que debemos hacer es que nos genera automáticamente una serie de datos llamados HATEOAS. En este caso esta dada por: 

![Untitled](src/Java%20SpringBoot/Untitled%2015.png)

Podemos usar las propiedades del proyecto para poder modificar ciertas cosas: 

```yaml
#
# Spring Data Rest propiedades
#
spring.data.rest.base-path=/magi-api
```

El código de arriba nos produce que cambiemos el `path` o la manera en que localizamos todo eso. Ahora usando postman queda: 

![Untitled](src/Java%20SpringBoot/Untitled%2016.png)

Básicamente el URL queda: [http://localhost:8080/magi-api/employees](http://localhost:8080/magi-api/employees) . 
A la hora de hacer un Put:

#### Put :

Para este nosotros usamos: [http://localhost:8080/magi-api/employees](http://localhost:8080/magi-api/employees)/{id} donde “id” es el lugar donde nosotros debemos colocar y en el cuerpo todo normal menos el id, eso de paso lo ignorara. 

![Untitled](src/Java%20SpringBoot/Untitled%2017.png)

### Configuración del Spring Data & Paginación:

Dentro de java spring boot , cuando usamos el Data REST , la ubicación de los endpoints es conocida por ser el plural de las clases, es decir, para el siguiente código: 

```java
public interface EmployeeRepository extends JpaRepository<Employee,Integer> {

}
```

Tenemos que el endpoint es dado por `../employees`  que es el plural, pero al ser tan variado y no usarse siempre en el mismo idioma, podemos usar la siguiente anotación: 

#### RepositoryRestResource(path=”…”)

En este nosotros podemos poner el path que nosotros queramos a la clase, por ejemplo: 

```java
@RepositoryRestResource(path="members")
public interface EmployeeRepository extends JpaRepository<Employee,Integer>{

}
```

Esto significa que el endpoint es dado por: `../members`  

#### Paginación:

Por defecto Spring Data REST usa paginación de cada 20 elementos. 
Es decir que el tamaño de la pagina es de 20 elementos creando un link de la siguiente forma: `../employees?page=0`  o `../employees?page=1` etc. siendo 0 el base. Tiene las siguientes propiedades: 

![Untitled](src/Java%20SpringBoot/Untitled%2018.png)

#### Sorting (Ordenamiento):

Podemos ordenar los elementos de una pagina automáticamente , en el ejemplo de Employee tenemos las propiedades como:  firstName, lastName y email. por lo que podemos usar: 

- `.../employees?sort=lastName`
- `.../employees?sort=fistName,desc`
- `.../employees?sort=firstName,asc`

## Ciclo dos y uno | Spring Core:

Lo primero que debemos saber es como crear el directorio, debería quedar de esta manera: 

![Untitled](src/Java%20SpringBoot/Untitled%2019.png)

---

Tenemos ahora los Spring Starter: 

Son paquetes de maven para poder descargar todos los necesarios, la tabla anexada: (claramente son mas de 30) 

![Untitled](src/Java%20SpringBoot/Untitled%2020.png)

---

### Spring Boot Actuator Endpoints:

Spring Boot proporciona un conjunto de herramientas y endpoints para monitorear la aplicación en producción. Ofrece métricas sobre salud, propiedades, y configuraciones además de otros aspectos.

Tenemos una tabla acerca de estos endpoints: 

![Untitled](src/Java%20SpringBoot/Untitled%2021.png)

---

### Inyectar propiedades en java Spring Boot:

Para inyectar propiedades necesitamos de la anotación @Value , para asi acceder a las propiedades del proyecto: 

![Untitled](src/Java%20SpringBoot/Untitled%2022.png)

---

### Spring Boot properties:

Existen una muy grande gama de propiedades diseñadas para el control de Spring Boot , la cual configura los comportamientos  de las aplicaciones de Spring, estos se dividen en grandes grupos: 

![Untitled](src/Java%20SpringBoot/Untitled%2023.png)

Las propiedades tenemos: 

- En el apartado de Web:

```yaml
#HTTP server port
server.port = 7070
#Context path of the aplication:
server.servlet.context-path = /my-silly-app 
	#la parte de arriba crea que la manera de ir a una pagina sea: 
	#http://localhost:7070/my-silly-app/(nombre_de_la_direccion)
#Default HTTP session time out
server.servlet.session.timeout = 15m 
	#Aqui nosotros creamos un timeout para la pagina de 15 minutos, donde no carga
	#simplemente aparece el error de timeotu .
```

- Actuator Properties

```yaml
#EndPoints to include by name or wildcard
management.endpoints.web.exposure.include = * 
#Endpoints to exlude by name or wildcard
management.endpoints.web.exposure.exclude = beans,mapping
#Base path for actuator endpoints
management.endpoints.web.base-path = /actuator
	#este ultimo es para poner: http://localhost:8080/actuator/mappings (en la parte de actuator)
```

- Seguridad Propiedades:

```yaml
#default user name
spring.security.user.name = admin
#password for default user
spring.security.user.password = topsecret
```

- Data propiedades:

```yaml
#JBDC URL of the database
spring.datasource.url=jdbc:mysql://localhost:3306/ecommerce
#login username of the database
spring.datasource.username= scott
#Login password of the databse
spring.datasource.password= contraseña
```

---

### Iniciar una app fácilmente…

Bueno, para java springboot se usa la anotación (@Annotation):  @SpringBootApplication . 

Así el código principal queda: 

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

}
```

Y como todo para paginación web, tiene que hacer uso de un controlador , en este caso REST

```java
@RestController
public class ControladorRest(){
	@GetMapping("/") // Este nos genera donde va a estar , es decir, localhost:8080/.../
										// en esos ... iria lo de adentro de las comillas de getMapping
	public String comienzo(){
		return "hola"; //  retornamos en la pagina el texto hola.
	}
		
```

 
Asi que:

### Tipos de Mapeo de un rest controller en java SpringBoot

Hay muchos tipos de mapeo, en especifico: 

![Untitled](src/Java%20SpringBoot/Untitled%2024.png)

Estos métodos de mapeo se usan para: 

- Get : Para solicitar información de un recurso
- Post: Para enviar información a fin de crear o de actualizar un recurso
- Put: Para enviar información a fin de modificar un recurso
- Patch: Actualiza una parte del recurso
- Delete: elimina un recurso específico.

```java
@RestController
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/api/user/{id}")
    public User byId(@PathVariable("id") int id) {
        return userService.find(id);
    }

    @PostMapping("/api/user/")
    public User create(@RequestBody User user) {
        return userService.create(user);
    }

    @PutMapping("/api/user/")
    public User update(@RequestBody User user) {
        return userService.update(user);
    }

    @PatchMapping("/api/user/")
    public User change(@RequestBody User user) {
        return userService.change(user);
    }

    @DeleteMapping("/api/user/{id}")
    public boolean delete(@PathVariable("id") int id) {
        return userService.remove(id);
    }

}
```

### Las “Annotation” en java SpringBoot:

Las anotaciones en java Spring Boot son bastante importantes, nosotros tenemos anotaciones como:

@Component : Lo que hace es marcar la clase como un Spring Bean y la convierte en un posible candidato para la inyección de dependencias 

```java
// Tenemos la clase: 
public interface  Coach{
	String getDailyWorkout();
}

// Ahora: 

@Component
public class CricketCoach implements Coach {

	@Override public String getDailyWorkout(){
		return "practice fast Bowling for 15 minutes";
	}

}
```

      Tenemos que tener en cuenta que un  Spring Bean  es una clase regular de java que es gestionada por java Spring.
Ademas es importante para más adelante saber: 

![Untitled](src/Java%20SpringBoot/Untitled%2025.png)

@Autowired: Esta anotación indica a Java Spring que inyecte la dependencia

```java
@RestController
public class  DemoController {

	private  Coach coach;
	
	// Aqui es donde hacemos una inyeccion de dependencias de tipo Constructor
	@Autowired 
	public  DemoController(Coach coach){
		   this.coach=coach;
	}	
	
	@getMapping("/dailyWorkout")
	public String getDailyWorkout(){
		return this.coach.getDailyWorkout();
	}

}
```

Hablando del autowired: 

Tendremos que hablar de los tipos de inyecciones.  

Tenemos: 

- Inyección por constructor:
    - Se usa cuando tienes una sola dependencia
    - Es el, por general, usado en spring io
- Inyección por setter:
    - Cuando tienes múltiples dependencias

@Qualifers: Los Qualifers son una anotación la cual nos brinda una manera en la cual ponemos que tipo de clase necesitamos , ejemplos: 

```java
//Tenemos la interfaz: 
public interface Coach{
		String getDailyWorkout();
}
// luego clases que la implementan:
@Component
public class CricketCoach implements Coach {
 // .. all code
}
@Component
public class TennisCoach implements Coach {
// .. all code
}
@Component
public class futbolCoach implements Coach{
// .. all code
}
@Component
public class BaseballCoach implements Coach{
// .. all code
}

//------------ Ahora tenemos lo que es el Rest: --------//

@RestController
public class DemoController {

 private Coach coach;
 
 @Autowired
 public DemoController(@Qualifier("baseballCoach") Coach coach){
	 this.coach = coach;
 }
 
 @GetMapping("/dailyWorkout")
 public String getDailyWorkout(){
	 return coach.getDailyWorkout(); 
 }

}

```

Como vemos el Qualifier hace que de todas las interfaces se implemente solo una, en este caso la de ‘baseballcoach’ (dentro del Qualifier no es necesario poner la mayúscula inicial, solo minúscula).

@Primary: Es una solución alternativa a el Qualifier , esta se coloca en las clases “Bean” es decir, en las que se tiene el @Component , esto marca a tal clase como la primaria, y la que se muestra por defecto: 

```java
// Implementando la clase interface: 
// . . . 
@Component
@Primary
public class BaseballCoach implements Coach {
	 // .. Los metodos heredados
}
```

Esto crea que a la hora de ser llamado se use el @RestController de la misma manera que se venia usando, es decir: 

```java
@RestController
public class DemoController {

	private Coach coach;
	
	@Autowired
	public DemoController(Coach coach){
		this.coach = coach;
	}
	
	@GetMapping("/dailyWorkout")
	public String getDailyWorkout(){
		return coach.getDailyWorkout();
	}
}
```

Como nota tenemos:  *El Qualifier tiene mayor relevancia que el Primary , asi pues, se recomienda solo usar una de las dos para no caer en esto.*

@Lazy: Cuando nosotros iniciamos la aplicación de Spring Boot todo se inicializa de manera inmediata, cuando nosotros usamos la anotación @Lazy lo que hace que solo se inicialice en ciertos casos, por ejemplos: 

- Cuando sea necesario para una inicialización o dependencia
- Solicitud explícita.

La idea es usarla en los Beans, generando: 

```java
@Component
@Lazy
public class TrackCoach implements Coach {

	public TrackCoach(){
		System.out.println("En el constructo: "+ getClas().getSimpleName())

}
```

Ahora bien, si necesitamos que esto se implemente a cada clase puede llegar a ser tedioso, y por eso nosotros usamos el archivo de propiedades. 

Para hacer la inicialización global tenemos que: 

```yaml
#Aqui va la inicializacion global
spring.main.lazy-initialization = true
```

@Scope: Estos son explicados mas abajo, usado en los Beans, es decir en los que llevan la anotación `@Component` .

@PostConstruct y @PreDestroy: Anotación que vemos mas abajo en el Ciclo de vida de los Beans

@Configuration y @Bean : Anotación que vemos en Configuración de clases Bean

### Componentes Scanning (PEQUEÑA FORMA DE CARPETAS)

![Untitled](src/Java%20SpringBoot/Untitled%2026.png)

La manera para que pueda escanear cualquier tipo de componente sin importar en donde se tenga situado es: 

```java
// en la clase principal colocamos: 
@SpringBootAplication(
	scanBasePackages= { "com.luv2code.springcoredemo",
											"com.luv2code-util",
											"org.acme.cart",
											"edu.cmu.srs"})
public class SpringcoredemoApplication{
	... 
}
```

Este scanning se ve mejor en este sistema de carpetas: 

![Untitled](src/Java%20SpringBoot/Untitled%2027.png)

La parte principal que lee es el “springcoredemo”, en este caso, es el por defecto, para que funcione la parte del util se debe: 

```java
@SpringBootApplication(
		scanBasePackages = {"com.Henry.springcoredemo",
				            "com.Henry.util"})
public class SpringcoredemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringcoredemoApplication.class, args);
	}

}
```

De esta manera lee todos los archivos, tanto del principal como del util, que es el creado 

### Spring : tipos de inyecciones

Los tipos de inyecciones son dos: 

- Inyección por constructor: Dependencias obligatorias
- Inyección por ‘setter’ : Dependencias opcionales
- inyección por Campo: “no recomendado”

Anteriormente la inyección por campo era popular , pero ya no debido a que hace que el código sea mas complejo de “testear” de manera unitaria. Aun asi se puede lograr ver en proyectos heredados o “legacy projects” que son proyectos que han sido de hace mucho tiempo, o sin documentación, etc. 

Básicamente la inyección por campo hace referencia a: 

```java
@RestController
public class DemoController{

	@AutoWired
	private Coach coach;
	
	// Sin constructores o Setters
	
	@GetMapping("/dir")
	public String getDailyWorkout(){
		return coach.getDailyWorkout;
	}

}
```

### Beans Scopes

Los “Beans Scopes” hacen referencia al ciclo de vida de un  “Bean”, cuánto deberían vivir?, cuantas instancias tiene y como se comparte.

Por defecto son Singleton es decir: 

![Untitled](src/Java%20SpringBoot/Untitled%2028.png)

La manera en la que nosotros creamos un tipo de “Scope” es implementando la anotación Scope:  

```java
@Component
@Scope(ConfigurableBeanFactory.SCOPE_SINGLETON)
public class TennisCoach implements Coach {
 // .. El resto del codigo
}
```

Hay diferentes tipos de Scopes , como ya vimos el Singleton hace referencia al mismo, entonces, tenemos tambien: 

| Scope | Descripción |
| --- | --- |
| singleton | Crea una una única instancia del Bean. Es el Scope por defecto |
| prototype | Crea nuevas instancias por cada solicitud que tenga  |
| request | Para solicitudes web HTTP. Solo para aplicaciones web |
| session | Para solicitudes web HTTP. Solo para aplicaciones web |
| application | Para aplicaciones web de tipo ServletContext. Solo para aplicaciones web |
| websocket | Para una web Socket. Solo para aplicaciones web |

Para usar el prototype: 

```java
@Component
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class CricketCoach implements Coach{
	// .. el resto del codigo
}
```

Aquí sí crea una instancia por cada una de las llamadas, es decir: 

![Untitled](src/Java%20SpringBoot/Untitled%2029.png)

Una manera para verificar si son o no el mismo podemos: 

```java
@RestController
public class DemoController{

	private Coach coach;
	private Coach otroCoach;
	
	public DemoController(
												@Qualifier("cricketCoach") Coach coach,
												@Qualifier("cricketCoach") Coach otroCoach,){
		
				this.coach = coach;
				this.otroCoach = otroCoach;
		}
		
		@GetMapping("/check")
		public String check(){
			return "comparando los dos beans : coach == otroCoach , "+ (coach==otroCoach);
		}

}
```

Aquí ya dependería de que usamos, si usamos singleton aparecerá `false` si es prototype será `True` .

### Ciclo de vida de los Beans

![Untitled](src/Java%20SpringBoot/Untitled%2030.png)

Como las clases Beans tienen un ciclo de vida podemos usar anotaciones como lo son: “@PostConstruct” y “@PreDestroy” de la siguiente manera: 

```java
// A nuestro Bean: añadimos: 
@Component
public class CricketCoach implements Coach {

	public CricketCoach(){
		System.out.println("En el constructor: "+ getClass().getSimpleName());
	}
	
	@PostConstruct
	public void doMyStartupStuff(){
		System.out.println("en doMyStartupStuff(): "+getClass().getSimpleName());
	}
	
	@PreDestroy 
	public void doMyCleanupStuff(){
		System.out.println("en doMyCleanupStuff(): "+getClass().getSimpleName());
	}

}
```

***Anotaciones secundarias: 
El ciclo de vida de los Prototype Beans no son tomados tan en cuenta, entonces estos no cuentan o, bueno, no funciona el @PreDestroy, a demás de que estos son @Lazy por defecto.*** 

### Configuración de clases Bean

Nosotros usamos la anotación Bean para crear el ya visto inyección de dependencia , ¿Por qué no simplemente usamos los @Component? , Podemos usarlos, sin embargo es preciso usar `@Bean` cuando no podamos acceder a la clase, es decir, es una de terceros. 
Por ejemplo: 

```java
// tendremos la configuracion de un pedido S3Client de AWS 
@Configuration
public class DocumentsConfig{

	@Bean
	public S3Client remoteClient(){
	
	// creamos el s3client para conectar a aws s3 : 
		ProfileCredentialsPorvider credentialsProvider = ProfileCredentialsProvider.create();
		Region region =  Region.US_EAST_1;
		S3Client s3Client = S3Client.builder()
												.region(region)
												.credentialsProvider(credentialsProvider)
												.build();
		
		return s3Client;
	}
}
```

En este ejemplo lo que tenemos es de una estructura de terceros, en este caso AWS, pasamos a un `@Bean` en nuestro programa y de esta manera aplicar un singleton a un Bean : 

```java
@Component
public class DocumentsService{

	private S3Client s3Client;
	
	@Autowired
	public DocumentServide(S3Client s3Client){
		this.s3Client = s3Client;
	}

}
```

recordar que el Bean id es el nombre del método por defecto, es decir, para el ejemplo anterior es remoteClient , tambien podemos modificar el id de manera personalizada entre paréntesis del Bean como `Bean('idPersonalizado')`

Un ejemplo mas concreto sería: 

![Untitled](src/Java%20SpringBoot/Untitled%2031.png)

![Untitled](src/Java%20SpringBoot/Untitled%2032.png)

![Untitled](src/Java%20SpringBoot/Untitled%2033.png)

---

## Hibernate/JPA CRUD:

### ¿Qué es Hibernate?

Es básicamente un framework en el cual guarda o persiste objetos de java en una base de datos: 

![Untitled](src/Java%20SpringBoot/Untitled%2034.png)

### Beneficios de Hibernate

Hibernate ofrece una serie de beneficios para los proyectos de desarrollo, entre los cuales se incluyen:

- **Abstracción de la base de datos**: Hibernate proporciona una capa de abstracción sobre la base de datos subyacente, lo que permite a los desarrolladores escribir código que es independiente del sistema de base de datos que se esté utilizando. Esto facilita la portabilidad del código entre diferentes bases de datos.
- **Mapeo objeto-relacional**: Hibernate facilita el mapeo entre las tablas de la base de datos y las clases de Java. Esto simplifica el desarrollo, ya que los desarrolladores pueden trabajar con objetos y clases en lugar de con tablas y SQL.
- **Facilita las operaciones CRUD**: Hibernate proporciona métodos integrados para las operaciones de Crear, Leer, Actualizar y Borrar (CRUD), lo que ahorra a los desarrolladores la necesidad de escribir estas operaciones desde cero.
- **Optimización de rendimiento**: Hibernate también ofrece numerosas características para mejorar el rendimiento de las aplicaciones, como el soporte para el almacenamiento en caché de segundo nivel y la capacidad de optimizar las consultas SQL.
- **Soporte para transacciones**: Hibernate proporciona un marco para manejar las transacciones de la base de datos de forma segura y eficiente.

### ¿Qué es JPA?

Es conocido como Java Persistence API (JPA) , es una API estándar para el mapeo Objeto-Relacional o ORM.
JPA es una lista de Interfaces para implementar. 
La implementaciones que tiene es en Hibernate y otra llamada EclipseLink. Aunque hay muchísimos más. 

### Beneficios de JPA

Los beneficios es que, al ser interfaces listas para implementar, no es necesario algún implementador nato, cualquiera sirve y se puede usar o transcribir a cualquier otro sin ningún problema

### Código de JPA

Este seria el código simple para guardar una variable: 

```java
// Suponemos que ya tenemos creada la clase estudiante con su constructor adecuado entonces
Stundent estudiante =  new Student("Daniel fernando", " Ariza Mora", "juniorr2002m@gmail.com");

// Esta es la parte de JPA, entonces:
	entityManager.persist(estudiante);
	// la parte de entityManager es un especial JPA helper object
	// Y basicamente lo que hace es hacer un inserte por nosotros sin necesidad
		// como se hacia anteriomente con el JDBC que es escribir codigo SQL dentro del programa. 
```

Para nosotros obtener algo de la  base de datos debemos de: 

```java
//Con el ejemplo anterior, siguiendolo tenemos:
int id = 1;
Student otroEstudiante = entityManager.find(Student.class,id);
// El find hace una Query o una consulta a la base de datos
```

Para obtener todos los estudiantes, entonces: 

```java
TypedQuery<Student> theQuery =  entityManager.createQuery("from Student", Stundet.class);
List<Student> students = theQuery.getResultList(); 
```

### Construcción:

Lo primero que debemos construir es el apartado del main, algo que debemos de saber es que podemos crear un @Bean antes que todos en el cual pondremos nuestro propio código, este código nos puede servir para, por ejemplo, conectar a la base de datos o una simple línea de comando: 

```java
@SpringBootApplication
public class CruddemoApplication {

	public static void main(String... args){
		SpringApplication.run(CrudedemoApplication.class,args);
	}
	
	// Aqui iria nuestra parte del bean
	@Bean
	public CommandLineRunner commandLineRunner(String[] args){
		return runner -> {
			System.out.println("Hola mundo");
		}
	
	}
}
```

### Tablas y mas anotaciones de Spring Boot.

Nosotros en JPA usamos las clases de java como forma de comparación a las tablas de la base de datos. Asi usa anotaciones que se necesitan para mapear la clase java a las tablas relacionales.

@Entity: 

La anotación `@Entity` se utiliza para marcar una clase como una entidad JPA. Una entidad representa una tabla en una base de datos y cada instancia de la entidad corresponde a una fila en esa tabla. Aquí hay algunos puntos clave sobre `@Entity`:

- **Declaración de Entidad:** Para que una clase sea reconocida como una entidad JPA, debe ser anotada con `@Entity`.
- **Requisitos:** La clase anotada con `@Entity` debe tener un campo que se pueda identificar de manera única como clave primaria. Este campo se anota típicamente con `@Id`.
- **Persistencia:** Las clases anotadas con `@Entity` son administradas por el contexto de persistencia de JPA, lo que significa que se pueden almacenar, actualizar, eliminar y recuperar desde una base de datos.

```java
@Entity
@Table(name="student")
@Data // apartado de lombok
public class Student{

		@Id
		@GeneratedValue(strategy = GenerationType.IDENTITY)
		@Column(name = "id")
		private int id;
    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "email")
    private String email;

}

/*
* El data ya me da la funcionalidad de:
* getters / setters
* constructor, tanto vacio como general
* toString
* */
```

### JPA CRUD

Para empezar con el CRUD nosotros hacemos lo que es, como vimos anteriormente , un Data Access Object o un DAO el cual cuenta con métodos como: 

- save()
- findById()
- findAll()
- findByLastName()
- update()
- delete()
- deleteAll()

Nuestro DAO  necesita lo que es una JPA Entidad , esta JPA Entidad es el componente principal para

guardar/recuperar entidades. El diagrama de arquitectura seria algo como: 

![Untitled](src/Java%20SpringBoot/Untitled%2035.png)

Donde el Estudiante DAO se conecta a la entidad JPA y esta a una fuente de datos, que es directo a la base de datos. 
Hay dos tipos, Entity Manager y JPARepository. 
Para saber en que momentos usarlos tenemos la siguiente tabla: 

![Untitled](src/Java%20SpringBoot/Untitled%2036.png)

Tambien se puede usar ambos en el mismo proyecto

Los pasos a seguir para crear el DAO son: 

1. Definir la interfaz DAO
2. Definir la implementación DAO
    1. Inyectar la Entity manager
3. Actualizar la aplicación principal

#### Definiendo la interfaz DAO:

```java
public interface StudentDAO{
	void save(Student theStudent)
}      
```

#### Definiendo la implementación DAO

```java
public class StudentDAOImpl implements StudentDAO{

	private EntityManager entityManager;
	
	@Autowired
	public StudentDAOImpl(EntityManager theEntityManager){
		entityManager = theEntityManager;
	}
	
	@Override
	public void save(Student theStudent){
		entityManager.persist(theStudent);
	}
}
```

Ahora nos encontramos con dos anotaciones que usaremos, la primera es: @Transactional y la segunda es @Repository. 

- @Repository: 
La anotación `@Repository` es una especialización de la anotación `@Component` y se utiliza para indicar que una clase es un repositorio de datos, típicamente responsable de la interacción con la base de datos. Los repositorios son parte de la capa de acceso a datos (DAO - Data Access Object) y proporcionan una abstracción sobre las operaciones de persistencia.
- @Transactional:
La anotación `@Transactional` se utiliza para gestionar transacciones de manera declarativa. Una transacción es una unidad de trabajo que se ejecuta de manera indivisible, garantizando que todas las operaciones dentro de la transacción se completen correctamente, o ninguna lo haga (consistencia y atomicidad).

Dando un ejemplo en código lo usamos asi: 

```java
@Repository
public class StudentDAOImpl implements StudentDAO{

	private EntityManager entityManager;
	
	@Autowired
	public StudentDAOImpl(EntityManager theEntityManager){
		entityManager = theEntityManager;
	}
	
	@Override
	@Transactional
	public void save(Student theStudent){
		entityManager.persist(theStudent);
	}

}
```

Usamos @Repository para marcar la clase como un repositorio de datos, y luego marcamos @Transactional para marcar que estamos haciendo una transacción, en este caso, guardar el estudiante.

#### Actualizamos la aplicación principal:

```java
@SpringBootApplication
public class CruddemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(CruddemoApplication.class, args);
	}

	@Bean
		public CommandLineRunner commandLineRunner(StudentDAO studentDAO){
		return runner -> {
							System.out.println("Creando un nuevo estudiante . . .");
							Student tempStudent = new Student("paul","Doe", "paul@luv2code.com");
							
							//guardamos el estudiante
							System.out.println("Guardando Estudiante...");
							studentDAO.save(tempStudent);
							// como ya lo hemos guardado ahora: 
							System.out.println("Save Student. Generate id: "+tempStudent.getId());
							 
							
		};
	}

}
```

Como notación tenemos que el @Transactional solo se usa en métodos que le hacen una modificación a la base de datos directamente.

---

Para nosotros hacer búsquedas personalizadas dentro de las clases, usamos el método: `createQuery()` de la siguiente manera: 

```java
TypedQuery<Student> theQuery = entityManager.createQuery(
																												 "from Student where lastName='Doe'", Student,class);
List<Students> students = theQuery.getResultList();
```

Tambien podemos hacerlo mediante parámetros de la siguiente forma: 

```java
public List<Student> findByLastName(String theLastName){
	TypedQuery<Student> theQuery = entityManager.createQuery(
																							 "from Student WHERE lastName=:theData",Student.class);
	theQuery.setParameters("theData",theLastName);
	
	return theQuery.getResultList();
}
```

Cuando uno hace los Query o las consultas, no se pone el “select” debido a que este se toma por defecto ya, para hacer consultas personalizadas la cláusula select es requerida: 

```java
TyperQuery<Student> theQuery = 
										entityManager.createQuery("select s FROM Student s",Student.class);
```

Algo que hay que aclarar es lo siguiente: 
con JPQL la sintaxis esta basada en el nombre de las entidades y los campos de las mismas es decir, de la clase de Java.  Ahora bien, cuando nosotros haces el `select` y `from` en las consultas estas son directamente a la ENTIDAD mas no a la base de datos.

Otra nota: 
Para eliminar o modificar muchas filas basta con: 

```java
// Elimina y nos dice la cantidad de filas que han sido modificadas
int numRowDeleted = entityManager.createQuery(
																	"DELETE FROM Students WHERE lastName= 'smith'")
																	.executeUpdate();
//Modifica y nos dice la canitdad de filas que han sido modificadas.
int numRowUpdate = entityManager.createQuery(
																	"UPDATE Student SET lastName='Tester'")
																	.executeUpdate();
// Para eliminar todos los estudianteS: 
int numRowDeleted2 =  entityManager
														.createQuery("DELETE from Student")
														.excecuteUpdate();
																	
// COMO A NOTACION EL " UPDATE " DE LA PALABRA QUE USAMOS ES UNA ANOTACION DE QUE ESTAMOS HACIENDO UNA MODIFICACION EN LA BASE DE DATOS.
```

El código total del CRUD debe verse de esta manera: 

#### Estudiante DAO:

```java
public interface StudentDAO {
    void save(Student theStudent);
    Student findById(Integer id);
    List<Student> findAll();
    List<Student> findByLastName(String lastName);
    void update(Student student);
    void delete(Integer id);
    int deleteAll();
}
```

#### Estudiante DAO Imp:

```java
@Repository
public class StudentDAOImp implements StudentDAO {

    //DEFINIMOS UN ENTITY MANAGER QUE SE IMPLEMENTARA DE POR SI EN EL CONSTRUCTOR
    private EntityManager entityManager;

    //INYECCION EN EL CONTRUCTOR
    public StudentDAOImp(EntityManager entityManager) {
        this.entityManager = entityManager;
    }

    //implements save method
    @Override
    @Transactional
    public void save(Student theStudent) {
        entityManager.persist(theStudent); // save the student to database
    }

    @Override
    public Student findById(Integer id) {
        return entityManager.find(Student.class, id); // asi nosotros mandamos que busque de los estudiantes el Id
    }

    @Override
    public List<Student> findAll() {
        //Create Query
        TypedQuery<Student> theQuery = entityManager.createQuery("FROM Student ", Student.class);
        //return Query results

        return theQuery.getResultList();
    }

    @Override
    public List<Student> findByLastName(String lastName) {
        TypedQuery<Student> theQuery = entityManager.createQuery("from Student Where lastName=:data", Student.class);
        theQuery.setParameter("data", lastName);

        return theQuery.getResultList();
    }

    @Override
    @Transactional
    public void update(Student student) {
        entityManager.merge(student);
    }

    @Override
    @Transactional
    public void delete(Integer id) {
        Student student = entityManager.find(Student.class, id);
        entityManager.remove(student);
    }

    @Override
    @Transactional
    public int deleteAll() {
        int numRowsDelete = entityManager
                .createQuery("delete from Student")
                .executeUpdate();
        return numRowsDelete;
    }

}
```

#### Apartado para el Main:

```java
public class CruddemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(CruddemoApplication.class, args);
    }

    @Bean
    public CommandLineRunner commandLineRunner(StudentDAO studentDAO) {
        return runner -> {
        // METODOS:
            //createStudentDao(studentDAO);
            //readStudent(studentDAO,2);
            //queryForStudents(studentDAO);
            //queryForStudentsByLastName(studentDAO);
            //updateStudent(studentDAO);
            //removeStudent(studentDAO);
            //studentDAO.deleteAll();
        };
    }

    private void removeStudent(StudentDAO studentDAO) {
        int studentId = 1;
        studentDAO.delete(studentId);
    }

    private void updateStudent(StudentDAO studentDAO) {
        int student = 1;
        //buscamos el estudiante
        Student student1 = studentDAO.findById(1);
        //le hacemos el cambio
        student1.setFirstName("pepe");

        studentDAO.update(student1);
    }

    private void queryForStudentsByLastName(StudentDAO studentDAO) {
        List<Student> studentList = studentDAO.findByLastName("Callejas");
        for(Student s : studentList){
            System.out.println(s);
        }
    }

    private void queryForStudents(StudentDAO studentDAO) {
        List<Student> studentList = studentDAO.findAll();

        for(Student s : studentList){
            System.out.println("Estudiante: "+s);
        }
    }

    private void readStudent(StudentDAO studentDAO, Integer id) {
        Student myStudent = studentDAO.findById(id);
        System.out.println("El estudiante encontrado es: " + myStudent);
    }

    private void createStudentDao(StudentDAO studentDAO) {
        //create the student object
        System.out.println("Creating new student object...");
        Student tempStudent = new Student("Paul", "Doe", "paul@luv2code.com");
        //save the student object
        System.out.println("Saving the student . . . ");
        studentDAO.save(tempStudent);
        //display id of the saved student
        System.out.println("saved student. generated id: " + tempStudent.getId());
    }

}
```

### Crear una tabla desde java-code

JPA/Hibernate nos provee una opción de crear de manera automática tablas.
Para esto usamos las propiedades de la aplicación `application.properties` , y usamos: `spring.jpa.hibernate.ddl-auto=PROPERTIE_VALUE` :

![Untitled](src/Java%20SpringBoot/Untitled%2037.png)

Como anotación tenemos que el create, create-drop se usa para testing debido a que no guardan ningún tipo de datos. Si se desea mantener los datos usamos Update.

Sin embargo hay que tener cuidado porque las bases de datos se configuran con el esquema de programación. Si se cambia, cambiaria toda la base de datos y si se llega a usar esa misma base de datos para otras aplicaciones puede joder todo.

**Para: `spring.jpa.hibernate.ddl-auto=create`**

**En general, no se recomienda la generación automática para proyectos empresariales y en tiempo real.**

- **Es MUY fácil eliminar datos de PRODUCCIÓN si no se tiene cuidado. ☠️**

**Se recomiendan scripts SQL ✅**

- **Los DBAs corporativos prefieren scripts SQL para la gobernanza y la revisión de código.**
- **Los scripts SQL pueden ser personalizados y ajustados para diseños de bases de datos complejos.**
- **Los scripts SQL pueden ser controlados por versiones.**
- **También pueden trabajar con herramientas de migración de esquemas como Liquibase y Flyway.**

---

## Seguridad:

En esta sección se verá :

- Seguridad de SpringBoot REST APIs
- Definir usuarios y roles.
- URL Protegidas en base al rol.
- Almacenar usuarios, contraseñas y roles en una BD (texto plano → Encriptado).

### Spring Security Model:

Se define un framework de seguridad para Spring Security. Se implementa usando filtros Servlet en el background.
Existen dos métodos:  declarativo y programático. 

Los filtros Servlet son usados para pre-procesar o post-procesar peticiones web, puede enrutar las peticiones web basándose en la lógica de seguridad y spring provee de muchas funcionalidades de seguridad

![image.png](src/Java%20SpringBoot/image.png)

![image.png](src/Java%20SpringBoot/image%201.png)

Dentro del código necesario para realizar la seguridad, debemos añadir la siguiente dependencia en el pom : 

```markdown
<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

La cual al correr el programa pasaran dos cosas, en primer lugar hallaremos un login y en segundo, encontraremos que nos dan la contraseña, bien sabemos que el usuario es: user.

![image.png](src/Java%20SpringBoot/image%202.png)

![image.png](src/Java%20SpringBoot/image%203.png)

Podemos modificar el user y password directamente del archivo properties : 

![image.png](src/Java%20SpringBoot/image%204.png)

Luego de nosotros tener eso vamos a crear un elemento sencillo para una autenticación sencilla: 

```java
@Configuration
public class DemoSecurityConfig {
	
	
	@Bean
	public InMemoryUserDetailsManager userDetailsManager(){
	
			UserDetail john = User.builder()
												.username("john").
												.password("{noop}test123")
												.roles("EMPLOYEE")
												.build();
			UserDetail mary= User.builder()
												.username("mary").
												.password("{noop}test123")
												.roles("EMPLOYEE","MANAGER")
												.build();
			UserDetail susan= User.builder()
												.username("susan").
												.password("{noop}test123")
												.roles("EMPLOYEE","MANAGER","ADMIN")
												.build();
												
												
			return new InmemoryUserDetailsManager(john,mary,susan);
								
	}

}
```

Aqui estamos usando antes de las contraseñas un “ {noop}” que lo que quiere decir es no operation, es decir que no haya ningún tipo de encriptamiento en el, es decir, texto plano. 

Luego podemos ir a postman para ingresar a nuestro endpoint , para esto usamos postman y usamos el apartado de “Basic Auth”: 

![image.png](src/Java%20SpringBoot/image%205.png)

Aqui al rellenar el Usuario y Contraseña con lo que configuramos arriba, podemos acceder a los datos desde postman.

#### Roles:

Los roles, como ya vimos en el código de arriba se pueden añadir a cada uno de los usuarios que estamos creando. Estos roles nos pueden ayudar a gestionar dentro de nuestra aplicaciones, por ejemplo, quien tiene los derechos necesarios para poder borrar a los empleados, o borrar en la base de datos, por ejemplo. 

El código asociado es [Dentro del apartado de configuración como un nuevo bean: ]

```java
@Configuration
...

@Bean
public SecurityFilterChain  filterChain(HttpSecurity http) throws Exception {

		http.autorhizeHttpRequest(configure -> 
						configurer
											.requestMatchers(HttpMethod.GET, "/api/employees").hasRole("EMPLOYEE")
											.requestMatchers(HttpMethod.GET, "/api/employees/**").hasRole("EMPLOYEE")
											.requestMatchers(HttpMethod.POST, "/api/employees").hasRole("MANAGER")
											.requestMatchers(HttpMethod.PUT, "/api/employees/**").hasRole("MANAGER")
											.requestMatchers(HttpMethod.DELETE, "/api/employees/**").hasRole("ADMIN"));
		
		// Usa la configuración básica de autenticación
		http.httpBasic(Customizer.withDefaults());
		
		return http.build();
}

...

```

En el código de arriba observamos varias cosas, una de ellas es el uso de los endpoints y el método que le estamos asignando, en este caso decimos como: Los que tiene rol de empleado pueden acceder al método GET total de los empleados y a el método GET de cada uno de los empleados, es decir podemos ver la información propia de cada uno teniendo ese rol.  Lo mismo sucede con los siguientes, y aqui el único que puede eliminar a los empleados es el que tiene el rol de ADMIN. 

Automáticamente nos protege de los CORS,  asi que debemos deshabilitarlos en la siguiente línea: 
`http.csrf(csrf -> csrf.disable());` 

#### Para ahora hacer ese tipo de autenticación en la base de datos debemos:

```java
@Configuration
public class DemoConfiguration{

	@Bean
	public UserDetailsManager userDetailManager(DataSource dataSource){
		return new JdbcUserDetailsManager(dataSource);
	}

}
```

Este código lo que hace es buscar directamente en la base de datos, o automáticamente dos tablas por defecto: 

- `users`: Contiene columnas como `username`, `password`, y `enabled`.
- `authorities`: Contiene columnas como `username` y `authority` (roles o permisos).
    - **Tabla `users`** (para almacenar usuarios):
        - Debe contener las siguientes columnas:
            - `username` (tipo `VARCHAR`, clave primaria): El nombre de usuario.
            - `password` (tipo `VARCHAR`): La contraseña del usuario (almacenada de forma segura, por ejemplo, con un hash bcrypt).
            - `enabled` (tipo `BOOLEAN`): Indica si el usuario está habilitado (`true`) o no (`false`).
    - **Tabla `authorities`** (para almacenar roles o permisos):
        - Debe contener las siguientes columnas:
            - `username` (tipo `VARCHAR`): El nombre de usuario asociado al rol.
            - `authority` (tipo `VARCHAR`): El rol o permiso asignado al usuario (por ejemplo, `ROLE_ADMIN`, `ROLE_USER`).

### Bcrypt:

---

## Apartado de Mi aplicativo sobre seguridad

Aqui habrá un apartado para explicar que estoy haciendo con mi aplicativo de spring para la seguridad, explicaré cositas, y miraremos documentación y otras páginas:

 

```java
//Para la documentación la manera principal es esta: 

@Configuration
@EnableWebSecurity
public class SecurityConfig {

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		// ...
		return http.build();
	}

	@Bean
	public UserDetailsService userDetailsService() {
		// Return a UserDetailsService that caches users
		// ...
	}

	@Autowired
	public void configure(AuthenticationManagerBuilder builder) {
		builder.eraseCredentials(false);
	}

// Aqui no entra la documentación pero esta: 
	@Bean 
  public PasswordEncoder passwordEncoder () { 
        return new BCryptPasswordEncoder (); 
    } 
}
```

Ya hora veremos que hace cada uno a un poquito más de detalle, por ahora:

- `securityFilterChain`: Este método es anotado como un `bean`, indicando que devuelve un spring Bean y es responsable de definir la cadena de filtros de seguridad, usa como parámetro `HttpSecurity` que a su vez es como un punto de partida que spring usa para definir ciertos tipos de filtros de seguridad.
    - **Protección CSRF:**  Para configurar la protección de de Cross (Cross-Site Request Forgey)[falsificación de solicitud entre sitios]. Deshabilitar CSRF es común en las API REST sin estado donde cada solicitud es independiente
    - **Autorizar solicitudes**: configura la autorización de solicitudes. Es decir si quieres que cierta parte del REST reciba solicitudes POST, GET, etc. y si para eso quieres o no autenticación
    - **Autenticación básica HTTP**: habilita la autenticación básica HTTP con la configuración predeterminada.
    - **Gestión de sesiones**: configura la sesión para que tenga algún estado, no tener es lo que es típico en las API REST donde cada solicitud debe autenticarse de forma independiente y no depender de sesiones.
- `userDetailsService`: 
En **Spring Security**, `UserDetailsService` es una interfaz que proporciona una forma estándar de recuperar información del usuario para el proceso de autenticación y autorización. Su implementación es un componente clave cuando se necesita autenticar usuarios y gestionar sus roles y permisos.
Por lo que el método lo que hace es generar un usuario para manejar, lo que usan en la documentación oficial es:

```java
    @Bean
    	public UserDetailsService userDetailsService() {
    		UserDetails userDetails = User.withDefaultPasswordEncoder()
    			.username("user")
    			.password("password")
    			.roles("USER")
    			.build();
    
    		return new InMemoryUserDetailsManager(userDetails);
    	}
    ```

    
    Aqui determinan un usuario por defecto y lo guardan en memoria para asi poder usarlo de manera normal, esto tambien lo vemos en el curso de spring asi que no es necesario ahondar aqui. 
    
- `configure`:
El método **`configure(AuthenticationManagerBuilder builder)`** en tu clase de configuración de seguridad se utiliza para personalizar el comportamiento del **`AuthenticationManager`**, que es el componente principal de Spring Security responsable de autenticar usuarios.

Aun no se muy bien como funciona asi que si algo lo digo mas abajo xddd.
- `passwordEncoder`: Este método es sencillo, y básicamente codifica lo que haya jasjas con Bcrypt. [explicado en el curso general]

Biennn, ya una vez visto la configuración normal procedemos a hacerlo en nuestro código con una diferencia y es que el `UserDetailsService` vamos a hacerlo personalizado para lo que nuestro recurso necesita: 

```java
@Configuration
@EnableWebSecurity
public class WebSecurityConfiguration {

    @Autowired
    private UserDetailsService userDetails; // necesitaremos de hacer inyección de alguna forma

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable) // reemplazando a 'csrf -> csrf.disable()' que es lo que se coloca de normal
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers(new AntPathRequestMatcher("/users/", "POST")).permitAll()
                        .anyRequest().authenticated()
                )
                .httpBasic(Customizer.withDefaults())
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                );

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

}
```

El código anterior muestra como sería la base requerida.

Luego implementamos el UserDetailsService propio: 

```java
@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UsersRepository repository;

    @Override // realmente es por email, pero es lo que sobre escribímos
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        final Users user = repository.findByEmail(email);
        if(user == null){
            throw new UsernameNotFoundException("Unknown user with email: "+ email);
        }

        return User.withUsername(user.getEmail())
                .password(user.getPassword())
                .accountExpired(true)
                .accountLocked(false)
                .credentialsExpired(false)
                .disabled(false)
                .build();
    }
}
```

Aquí debemos configurar el `repository` de `Jpa` para que admita el buscar por email. 

Luego nosotros debemos usar un `Mapper` para de esta forma controlar la encriptación: 

```java
public class UserMapper { // usamos como un singleton

    private final BCryptPasswordEncoder encoder;

    private UserMapper(){
        encoder = new  BCryptPasswordEncoder();
    }

    public static UserMapper getInstance(){
        return new UserMapper();
    }

    //Aquí podemos usar un UsersRequestDTO para validar si la contraseña esta bien puesta o no, pero lo podemos hacer tambien del frontend
    //dejaré lo que es como serpia la clase más abajo
    public Users toEntity(Users user){
        return Users.builder()
                .email(user.getEmail())
                .nickname(user.getNickname())
                .password(encoder.encode(user.getPassword()))
                .build();
    }
}

```

Este `Mapper` lo usamos para Implementarlo dentro de la implementación del servicio: 

```java
   @Override
    public void save(Users user_rq) {
        Users user = UserMapper.getInstance().toEntity(user_rq);
        repository.save(user);
    }
```

Y ahora solo queda usarlo en la solicitud post: 

```java
@RestController
@RequestMapping("/users")
public class UsersController {

    private final UsersServiceImpl service;

    @Autowired
    public UsersController(UsersServiceImpl service){
        this.service = service;
    }

    @GetMapping("/{id}")
    public Users getUserId(@PathVariable int id){
        return service.findById(id);
    }

    @PostMapping("/")
    public ResponseEntity<?> createUser(@RequestBody Users user) {
        service.save(user);
        return ResponseEntity.ok("User created successfully");
    }
}
```

Y listo, quedaría todo listo, quiza configurar unas cosas y listo. 

Puede que haya un error y es que Users es una clase entity, para que funcione correctamente es necesario mapearlo en otra clase llamada UsersDTO o solo usar los setters u otra cosa es que no de ningun error . Puede que no lea los beans bien y se debe usar: 

```java
@SpringBootApplication(scanBasePackages = {"com.Henry"})
@EnableJpaRepositories(basePackages = "com.Henry.dao")
@EntityScan(basePackages = "com.Henry.entities")
public class FinasitApplication {

	public static void main(String[] args) {
		Dotenv dotenv = Dotenv.configure()
				.filename(".env.db")
				.load();

		dotenv.entries().forEach(e -> {
			System.setProperty(e.getKey(), e.getValue());

		});

		SpringApplication.run(FinasitApplication.class, args);
	}
}

```

Como se puede ver ponemos el escaneo de entidades, y enableJPARepository para que de esta forma lea los beans ya que manualmente no lo hace. Toca verificar bien la tabla para que no hayan errores con el `validate` en los properties.

También puede genere error el lombok debido a una configuración de maven, debe verse algo como: 

```xml
   <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.8.1</version>
                <configuration>
                    <source>21</source>
                    <target>21</target>
                    <annotationProcessorPaths>
                        <path>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                            <version>1.18.36</version>
                        </path>
                    </annotationProcessorPaths>
                </configuration>
            </plugin>
        </plugins>
    </build>
```

Ya que por alguna razón por defecto falla, y pues ya jaja, daticos.

Otro dato importante es sobre los dto.

### DTO

Los DTO básicamente me dice que quiere que le muestre al endpoint?, es facil, mira: 

Un DTO luce así:

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsersDTO {
    private int id;
    private String email;
    private String nickname;
    private String password;
}

```

Aqui le decimos que queremos id, email, nickname, password. Solo eso, si nosotros usamos el Users directamente este cargara todo, absolutamente todo y si no encuentra pues nos dará error, puede que podemos controlar esos errores (no se cómo directamente, puede ser con un jsonIgnored) pero puede no ser lo óptimo, con DTO podemos manejar manualmente que queremos que se maneje. 

El `ServiceUsersImpl` se vería de esta forma: 

```java
@Service
public class UsersServiceImpl implements UsersService{

    private final UsersRepository repository;

    @Autowired
    public UsersServiceImpl(UsersRepository repository){
        this.repository =repository;
    }

    public UsersDTO convertToDTO(Users user) {
        return UsersDTO.builder()
                .email(user.getEmail())
                .nickname(user.getNickname())
                .password(user.getPassword())
                .build();
    }

    @Override
    public List<UsersDTO> findAll() {
        List<Users> users = repository.findAll();

        return users.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

// .... demas codigo
```

Con toda esta configuración damos por sentado un ejemplo de como usar seguridad. 

## Apartado 2, JWT , autenticación y autorización

Hablemos acerca de JWT, básicamente es un Json Web Token que permite la autenticación de un usuario mas no su autorización.

Esta se divide en 3: 

![image.png](src/Java%20SpringBoot/image%206.png)

El header que nos dice en que fue encriptado, el playload que es el contenido. Aquí podemos colocar cualquier cosa que nos asegure la autenticación del usuario o cliente y luego esta el signature que es la firma, la cual nos asegura que no fue modificado en el proceso de enviado. 

![image.png](src/Java%20SpringBoot/image%207.png)

El proceso de Autenticación sigue el curso que vemos arriba. Un tema es que el apartado User debe seguir la implementación de UserDetail que es lo que más arriba nosotros implementamos. Aquí nosotros vemos como hace primero un request a los filtros, estos chequean si el JWT es nulo, de ser asi lo pasan a un controlador, este a un servicio y luego va al repositorio en donde usamos el UserDetails, luego se deveulve el JWT Token.

Vamos a explicar paso a paso que se hace en este proceso de autenticación/registro.

### Proceso completo con código:

Primero sabemos que el cliente hace una petición, por lo que entonces debemos crear los endpoints: 

```java
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;
    
    @PostMapping("login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {

        return ResponseEntity.ok(authService.login(request));
    }

    @PostMapping("register")
    public ResponseEntity<AuthResponse> register(@RequestBody RegisterRequest request) {
        return ResponseEntity.ok(authService.register(request));
    }
}
```

Aquí usamos el metodo Post para ambas solicitudes y debe devolvernos un ResponseEntity.ok en el cual se nos sera devuelto un token, en este caso usamos un AuthService será quien nos ayude con esto. Como podemos observar en ambos usamos un login request y un register request, estas dos clases las definimos al igual que el authService; en los request estan las peticiones que se esperan: 

 

```java
// Login: 
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class LoginRequest {
    String email;
    String password;
}

// Register: 
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RegisterRequest {
    String nickname;
    String email;
    String password;
    String firstName;
    String lastName;
}
// De paso añadimos un AuthResponse que es lo que queremos devolver en este caso era solo un string, sin embargo
// nos puede ayudar para saber si añadir más cosas o no para despues: 
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AuthResponse {
    String token;
}
```

Es simple, solo mandamos lo que necesitamos para crear nuestro usuario, en este caso es usuario y perfil. Cómo sería nuestro AuthService? : La logica general sería: 

```java
@Service
@RequiredArgsConstructor
public class AuthService {

    public AuthResponse login(LoginRequest request) {
    
    //retornamos el token de ingreso
		}
		
		public AuthResponse register(RegisterRequest request){
		
		//retornamos el token de registro
		}
}
```

Para nuestro código quedaría de la siguiente forma: 

```java
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UsersService usersService;
    private final ProfilesService profilesService;
    private final JwtService jwtService;
    private final UserDetailsServiceImpl userDetailsService;
    private final AuthenticationManager authenticationManager;

    //Aquí estámos creando el usuario, entonces:
    public AuthResponse login(LoginRequest request) {

        authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));
        UserDetails userDetails = userDetailsService.loadUserByUsername(request.getEmail());
        String token = jwtService.getToken(userDetails);

        return AuthResponse.builder()
                .token(token)
                .build();
    }

    public AuthResponse register(RegisterRequest request) {
        // NO OLVIDAR AÑADDIR QUE SI NO SE CRA EL PERFIL ELIMINAR EL USUARIO, MANEJAR ESE ERROR :CCC
        Users user = Users.builder()
                .email(request.getEmail())
                .password(request.getPassword())
                .nickname(request.getNickname())
                .build();

        user = usersService.save(user);

        Profiles profile = Profiles.builder()
                .first_name(request.getFirstName())
                .last_name(request.getLastName())
                .id_user(user)
                .build();
        profilesService.save(profile);

        // Parte adicional que no está en el video pero lo hago para colocarlo
        UserDetails userDetails = userDetailsService.loadUserByUsername(user.getEmail());

        return AuthResponse.builder()
                .token(jwtService.getToken(userDetails))
                .build();

    }
}
```

De la cual explicaré: Usamos los servicios de perfil y usario para crearlos en la base de datos luego usamos una clase que CREAMOS que sera nuestro servicio JWT, usamos el `userDetailsServiceImpl` que nosotros creamos, o si quieres en la clase usario extender de ese mismo entonces no será tan necesario [pero hará el codigo mas acoplado], para mas informacion: https://github.com/irojascorsico/spring-boot-jwt-authentication/blob/v1.0/src/main/java/com/irojas/demojwt/User/User.java.

La clase que creamos de JwtService: 

```java
@Service
@RequiredArgsConstructor
public class JwtService {

    @Value("${jwt.secret.key}")
    private String SECRET_KEY;

    public String getToken(UserDetails user) {
        return getToken(new HashMap<>(),user);
    }

    private String getToken(Map<String,Object> extraClaims, UserDetails user) {
        return Jwts
                .builder()
                .setClaims(extraClaims)
                .setSubject(user.getUsername()) // no olvidar que el username es el email xd
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis()+1000*60*24))
                .signWith(getKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    private Key getKey() {
        byte[] keyBytes = Decoders.BASE64.decode(SECRET_KEY);
        return Keys.hmacShaKeyFor(keyBytes); // permite una nueva instancia de nuestra secretKey
    }
}
```

Aqui observamos una Secret_Key que es un numero aleatorio que nosotros mismos podemos obtener del cmd: `openssl rand -base64 64` , este lo guardaremos en un .env o algun archivo de seguridad y lo leemos en el [application.properties](http://application.properties) o application.yml.

En el getToken tendra dos partes, el primero es un string que usamos nosotros y mandamos un UserDetails que es el usuario por defecto que usa SpringBoot, y retornamos de otro que necesita un HashMap y el UserDetails, el HashMap es para “extraClaims” que son como connotaciones extra que podemos añadir del usuario o “afirmaciones” que nos dice acerca del usuario y gracias a Jwts [que es una dependencia de maven, toca meterlas la cuales son: ]

```xml
 <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-api</artifactId>
            <version>0.11.5</version>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-impl</artifactId>
            <version>0.11.5</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-jackson</artifactId>
            <version>0.11.5</version>
            <scope>runtime</scope>
        </dependency>
```

El caso es que usamos el constructor que tiene integrado para, no construir, sino generar un compact, donde ponemos lo que ya vimos que es un JWT, es decir: si necesita claims, un sujeto de quien es, el inicio y final de la validacion de dicho token, y luego lo firmamos, y para ello usamos el metodo `getKey` en la cual usamos la `SECRET_KEY` y sha xd.

|

Volviendo a lo que era el AuthService manejamos el login con un `AuthenticationManager` que su funcionamiento está en usar el UserDetails que hemos definido en otra clase como @Service ,esto verifica si la contraseña es correcta, y esta contraseña se encripta con el `Bcrypt` que nosotros definimos, e igual veremos ahora la configuración para saber de donde salen los Autowired de la clase AuthService, esto es gracias a un `AuthenticactionProvider` que también definiremos luego. Ya despues de la autenticación, si todo está bien obtendremos el token y lo construiremos. ¡Sencillo! 

Ahora tenemos el apartado de `register` que realmente solo crea el usuario y perfil [aqui iria alguna logica para crear, quiza podemos usar algun servicio extra para no delegar tanto código ahi] y luego obtenemos el token con el servicio de Jwt que ya digimos

#### Y la configuración?

Esta es la configuración que manejamos para que se inyecten las dependencias:

```java
@Configuration
@RequiredArgsConstructor
public class ApplicationConfig {

    private final UserDetailsService userDetailsService;

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception
    {
        return config.getAuthenticationManager();
    }

    @Bean
    public AuthenticationProvider authenticationProvider()
    {
        DaoAuthenticationProvider authenticationProvider= new DaoAuthenticationProvider();
        authenticationProvider.setUserDetailsService(userDetailsService);
        authenticationProvider.setPasswordEncoder(passwordEncoder());
        return authenticationProvider;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

}
```

Aqui usamos el UserDetails que ya usabamos con anterioridad, luego en los dos métodos desconocidos es donde creamos los Beans que usamos en el login.

También, antes de entrar a la otra configuración que básicamente viene siendo un ligero cambio frente al que teniamos es la creación de `JwtAuthenticationFilters` la cual nos brinda la posibilidad de crear los filtros de autenticación con Jwt que ya crearemos esa clase mas adelante anotada como : @Component [ TAMBIEN RECORDAR QUE LAS ANOTACIONES COMO : COMPONENT,SERVICE,CONTROLLER y REPOSITORY; SON EXACTAMENTE IGUALES EN TERMINOS DE “QUE HACE” PERO LA USAMOS PARA DIFERENCIAR EL CONTEXTO DE LA APP].

La configuración un poco cambiada sería: 

```java
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class WebSecurityConfiguration {

    private UserDetailsService userDetailsService;
    private final JwtAuthenticationFilters jwtAuthenticationFilters;
    private final AuthenticationProvider authenticationProvider;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable) // reemplazando a 'csrf -> csrf.disable()' que es lo que se coloca de normal
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers("/auth/**").permitAll() // decimos que lo que tiene que ver con auth -> login | sign in : No necesita autenticación.
                        .anyRequest().authenticated()
                )
//                .httpBasic(Customizer.withDefaults())
                .authenticationProvider(authenticationProvider)
                .addFilterBefore(jwtAuthenticationFilters, UsernamePasswordAuthenticationFilter.class)
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                );

        return http.build();
    }
}
```

La verdad no hay mucho que ver, solamente que añadimos el `AuthenticationProvider` y `JwtAuthenticationFilters` que veremos en poco. Pero básicamente esa es el como se hace un login y register en spring, ahora veremos otra cosita.

Para pasar a la siguiente instancia debemos ver: 

![image.png](src/Java%20SpringBoot/2bc3e3a0-64b0-46e8-a3f1-d21f2e539e74.png)

Aquí se explica como es el proceso de validación de un token que está siendo pasado por la httprequest y como nos puede dar erroes o no puesde brindar la pagina que estámos queriendo acceder

### Proceso de Validación JWT

para esto vamos a ahora si a declarar el `JwtAuthenticationFilters` este extiende de `OncePerRequestFilter` que es una clase abstracta que nos ayuda a establecer filtros personalizados que usaremos, la clase se vería algo asi: 

```java
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilters extends OncePerRequestFilter {
    private final JwtService jwtService;
    private final UserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, 
											    HttpServletResponse response, 
											    FilterChain filterChain) throws ServletException, IOException {
        //Vamos a obtener el token:
        final String token = getTokenFromRequest(request);
        final String email;
        if (token == null) {
            filterChain.doFilter(request, response);
            return;
        }
        // si el token no es nulo entonces obtendremos el email: [que en este caso seria nuestro username]
        email = jwtService.getUserNameFromToken(token);
        //si llega a ser que el email no es nulo y no esta en el contexto de seguridad entonces debemos validar:
        if(email!= null && SecurityContextHolder.getContext().getAuthentication()==null){
            UserDetails userDetails = userDetailsService.loadUserByUsername(email);
            
            if(jwtService.isTokenValid(token,userDetails)){
                System.out.println("El token está siendo valido xd");
                UsernamePasswordAuthenticationToken authenticationToken = 
                new UsernamePasswordAuthenticationToken(
                        userDetails,
                        null,
                        userDetails.getAuthorities());
                authenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authenticationToken);
            }
        }

        filterChain.doFilter(request, response);
    }
    
    private String getTokenFromRequest(HttpServletRequest request) {
        //necesitamos del header la autenticación
        final String authHeader = request.getHeader(HttpHeaders.AUTHORIZATION);

        if (StringUtils.hasText(authHeader) && authHeader.startsWith("Bearer ")) {
            return authHeader.substring(7);
        }

        return null;
    }
}
```

Como vemos en la clase nosotros usamos como atributos el JwtService y UserDetailsService a la que a JwtService la añadiremos algunos métodos que no vimos debido a que no era tan necesario sino hasta ahora, primero veremos la lógica de el método sobreescrito de `doFilterInternal` en este nosotros vamos a extraer el token que viene del header si no viene pues nos mandara error, una vez lo tengamos gracias a el método privado `getTokenFromRequest` debémos asegurarnos que el email no sea nulo obteniendolo del `jwtService` mediante el método que construiremos dentro de este servicio: 

```java
public String getUserNameFromToken(String token) {
     return getClaim(token,Claims::getSubject);
}
    
public <T> T getClaim(String token, Function<Claims,T> claimResolver){
     final Claims claims = getAllClaims(token);
     return claimResolver.apply(claims);
}

//privado
private Claims getAllClaims(String token){
        //Accedemos gracias a la libreria Jwts
        return Jwts.parserBuilder()
                .setSigningKey(getKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

//Aqui desglosaremos estos dos métodos: 

/*
Con getClaim creamos una clase generica la cual recibe el token y una función, 
esta funcion es una interfaz del tipo Function<K,T> la cual nos dice que recibe como parametro un claim y
devuelve algo de tipo T, cuando hacemos la función un .apply decimos que se tiene que aplicar la funcion que
le pasaremos por referencia.
Dentro de este metodo nosotros obtenemos los claims del token mediante una función privada la cual usamos Jwts
que hace un parserBuilder que crea una nueva instancia de una clase DefaultJwtParserBuilder que se utiliza
para validar y analizar tokens, entonces, aqui seteamos el key que si no olvidamos era el SECRET_KEY
y construimos para luego parsear los claims del token y obtener el body, es decir, los claims
Luego de obtener los claims se los pasamos al apply y aqui entra otra vez el método usado.

en el getUserNameFromToken(String) retornamos el getClaim(token,Claims::getSubject) donde
Claims::getSubject es una referncia al metodo, es decir, en vez de usar lambda como: 

getClaim(token, (claim) -> claim.getSubject()) solo lo referenciamos con Claims::getSubject
, y asi podemos encontrar el Sujeto que es el nombre del usuario, en nuestro aplicativo, el email.

*/
```

Despues de asegurarnos que no es nulo el correo y que no se encuentra dentro del contexto de seguridad (que este contexto es individual y se ejecuta uno en cada hilo que se requiera) cargamos el usuario con el userDetailsService y aqui decimos, el token es válido? mediante el metodo que añadimos en JwtService: 

```java
 		public boolean isTokenValid(String token, UserDetails userDetails) {
        //primero verificamos si el username corresponde con el que obtenemos del userDetails:
        final String username = getUserNameFromToken(token);
        return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }

    private Date getExpiration(String token){
        return getClaim(token,Claims::getExpiration);
    }
    private boolean isTokenExpired(String token){
        return getExpiration(token).before(new Date());
    }
```

Con lo que explicamos anteriormente no es necesario ahondar mucho en el, ahora bien , luego de saber si el token es valido o no usamos un`UsernamePasswordAuthenticationToken` que básicamente creo un mini token donde coloco los detalles del usuario, las credenciales que en este caso no son necesarias porque ya esta autenticado y luego las “authorities” que son los roles que ocuparia, y para finalizar lo añado al contexto de seguridad de spring es decir `SecurityContextHolder`. Terminamos con un `filterChain.doFilter(request, response);` que lo que hace es pasar al siguiente filtro, es decir mira en las configuraciones de donde fue llamado este filtro es decir: 

```java
//En WebSecurityConfiguration
//...
@Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable) // reemplazando a 'csrf -> csrf.disable()' que es lo que se coloca de normal
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers("/auth/**").permitAll() // decimos que lo que tiene que ver con auth -> login | sign in : No necesita autenticación.
                        .anyRequest().authenticated()
                )
                .authenticationProvider(authenticationProvider)
                .addFilterBefore(jwtAuthenticationFilters, UsernamePasswordAuthenticationFilter.class)
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                );

        return http.build();
    }
    /...
```

Como vemos hay un `addFilterBefore()` que es donde llamamos al JwtAuthenticationFilters, ya que terminsmo ahora sigue con el filtro en cadena de la sesion Manejada que por defecto es una sesion con politica “ sin estado” que no guarda la autenticación y necesita pedir el token en cada llamado.

## Apartado 3, HttpOnly y cookies.

Con lo que observamos anteriormente vemos que al usuario se le es pasado el JWT, pero esto debe ser guardado en 3 lugares deiferentes, en las cookies, en al localstorage o en la sessionStorage.

En las cookies se guarda un maximo de 4mb, el localStorage esta cerca de las 10 y sessionStorage por loas 5.
Con lo anteriormente dicho, debemos guardar el token JWT en el servidor mediante una HttpOnly cookie.

Lo primero que haremos será instalar 

---

---

## Diferencias entre JWT y Session:

### Autenticación basada en Sesiones:

El diagrama de flujo es el siguiente

![image.png](src/Java%20SpringBoot/image%208.png)

Aqui nosotros observamos que lo más importante es el manejo de sesiones en el servidor, ahi es donde se controla basicamente todo, puede ser dentro de una base de datos. 

#### Ventajas:

- Revocar una sesión es sencillo
- Almacenamiento separado necesario para guardar la información de la sesión
- Que una aplicación escale tambien hace que esa sesión quede envuelta en ese “escalado”

Uno de los grandes problemas de esto es: 

![image.png](src/Java%20SpringBoot/image%209.png)

Que a la hora de tener multiples servidores necesitamos centralizar esta sesión generando cierta latencia en cada petición.

### Autenticación basada en JWT:

El Flujo es el siguiente: 

![image.png](src/Java%20SpringBoot/image%2010.png)

Aqui observamos como ahora no depende de almacenar alguna sesión que es de sus principales diferencias, además de que se almacená en una cookie localmente. Y las principales diferencias son:

#### Diferencias:

- No necesita un almacenamiento separado
- La invalidación de un JWT no es para nada sencillo
- El escalado por parte del cliente y servicio es sencillo

Para firmar los JWT  hay varios algoritmos disponibles como HMAC, RSA, ECDSA | se divide en firmas simetricas y asimetricas

Aquí necesitamos manejar algo llamado tokens de refresco que son necesarios para que el usuario acceda a la información sin necesidad de estar iniciando sesión a cada rato,

![image.png](src/Java%20SpringBoot/image%2011.png)

![image.png](src/Java%20SpringBoot/image%2012.png)

![image.png](src/Java%20SpringBoot/image%2013.png)

Esto hace que sea más segura y sin afectar la experiencia del usuario si se llegan a robar un token de acceso

Es importante recalcar que el token de refresco o actualización se envía cada que el token de acceso termina, no en cada petición, mientras que el token de acceso si se envía en cada petición

#### **¿Qué token expira en 15 min y cuál en 1 mes?**

- **`token` (Access Token)** → Expira en **15 minutos** y se usa en cada petición para acceder a los recursos protegidos.
- **`refreshToken` (Refresh Token)** → Expira en **1 mes** y se usa solo cuando el `token` expira, para obtener uno nuevo sin necesidad de hacer login otra vez.

## TIPS:

Cuando estemos trabajando los post, por lo general debemos tener en cuenta si nuestra clase tiene un `@JsonBackReference` o un `@JsonManageReference` , si tiene la primera significa que nuestro querido POST lo evitará, si tiene el otro entonces debemos añadirlo, entendemos?, esta cuestión nos hace pensar y decidirnos por los clásicos `@JsonIgnore` .  Algo que podemos hacer es crear solo un `EntityDTO` para este POST. Esto nos ayuda a que el GET obtengamos todo lo que necesitamos manejando las relaciones cíclicas con los dos primeros comandos

Otro tip va a ser a la hora de crear una clase que debe ser `EmbbebedId` . Por ejemplo:

```java
public class Item {
    @EmbeddedId
    private ItemPk id;
    @ManyToOne
    @JoinColumn(name = "invoice_id", insertable = false, updatable = false)
    @JsonBackReference
    private Invoice invoice;

    @Column(name = "quantity", nullable = false)
    private int quantity;
    @Column(name = "price", nullable = false)
    private double price;
    @ManyToOne
    @JoinColumn(name = "invoice_id", insertable = false, updatable = false)
    @JsonBackReference
    private Product product;
}

public class ItemPk implements Serializable {
    @Column(name = "invoice_id")
    private int invoiceId;
    @Column(name = "item_id")
    private int itemId;

}
```

Aquí tenemos una llave compuesta que esta relacionada con otra. En este tipo de datos cuando hacemos un POST debemos crear un DTO de esta forma, sin incluir el compuesto total:

```java
public class ItemDTO {
    private int itemId;
    private int productId;
    private int quantity;
    private double price;

}
```

A la hora de crear el servicio: 

```java
   @Override
    public Item save(ItemDTO itemDTO, int invoiceId) {
        //Aquí nosotros hacemos la conversión :D
        Item it = ItemMapper.toEntity(itemDTO, invoiceId);
        return repository.save(it);
    }

```

Entonces, como vemos. Para guardar necesitamos el invoiceID, claramente, pero antes veremos el Mapper: 

```java
public class ItemMapper {

    public static ItemDTO toDTO(Item item) {
        return ItemDTO.builder()
                .itemId(item.getId().getItemId())
                .productId(item.getProduct().getProductId())
                .quantity(item.getQuantity())
                .price(item.getPrice())
                .build();
    }

    public static Item toEntity(ItemDTO dto, int invoiceId) {

        ItemPk id = ItemPk.builder()
                .invoiceId(invoiceId)
                .itemId(dto.getItemId())
                .build();

        return Item.builder()
                .id(id)
                .product(Product.builder()
                        .productId(dto.getProductId())
                        .build())
                .quantity(dto.getQuantity())
                .price(dto.getPrice())
                .build();
    }

}
```

Aqui aclaramos como funciona :D.

Ahora imaginemos que queremos crear una factura en esto: 

```java
 @PostMapping("/")
    public Invoice saveInvoice(@RequestBody InvoiceDTO invoice)
    {
        Invoice in = InvoiceMapper.toEntity(invoice);
        // guardamos la factura:
        in = service.save(in);
        if (in == null) throw new RuntimeException("No se pudo guardar la factura");
        //Ahora creamos los items de esa factura
        Invoice finalIn = in;
        in.getItems().forEach(item -> {
            ItemDTO itDTO = ItemMapper.toDTO(item);
            itemService.save(itDTO, finalIn.getInvoiceId());
        });
        return in;
    }
```

el POST se vería de esta forma, aqui podemos observar que creamos cada uno de los items despues de crear la factura, el DTO de la factura es importante aqui para hacerlo mas sencillo

```java
public class InvoiceDTO { // Esta es la request pedida

    private Customer customer;
    // El customer cuenta con: name, identify, direction, phone
    private Vehicle vehicle;
    //Vehiculo: vehicleId, customer, plate, description
    private PaymentType paymentType;
    private String dateOrdered;
    private Double total;
    private List<ItemDTO> items;

}
```

Aqui mostramos el InvoiceDTO simplemente para dar a entender mejor eso y como finalización el JSON debe ser, almenos en este ejemplo:

```json
{
  "customer": {
    "customerId": 2
  },
  "vehicle": {
    "vehicleId": 2
  },
  "paymentType": {
    "paymenttypeid": "Tarjeta de Crédito"
  },
  "dateOrdered": "2025-02-26",
  "total": 250000,
  "items": [
    {
        "itemId": 1,
        "productId": 3,
        "quantity": 15,
        "price": 49.99
    },
    {
        "itemId": 2,
        "productId": 3,
        "quantity": 5,
        "price": 49.99
    }
  ]
}

```

;D.

## Excepciones aqui :D

Para manejar excepciones podemos crear las nuestras, hacerlo es bastante facil, al menos no de manera tan detallada y especifica . Luego de esto a la hora de hacer las queridas excepciones en los controladores, ya que digamos, hicimos una clase excepción como **`BrandException`** entonces le colocan a su servicio la excepción a la hora de buscar el id, entonces: usan el `throws BrandException` , y toca manejarlo en el controlador, se puede hacer de diferentes maneras. 

[ Por cierto es recomendable usar `ResponseEntity<…>`  para las respuestas, si siempre seré un ok, entonces no es necesario]. 

```java
// Forma 1: 
@RestController
@RequestMapping("/brand-car")
@RequiredArgsConstructor
public class BrandCarController {

    private final BrandCarService brandCarService;

    @GetMapping("/{id}")
    public ResponseEntity<?> getBrandCarById(@PathVariable String id) {
        try {
            BrandCar brandCar = brandCarService.findById(id);
            return ResponseEntity.ok(brandCar);
        } catch (BrandCarException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }
}

// forma 2: 
@RestController
@RequestMapping("/brand-car")
@RequiredArgsConstructor
public class BrandCarController {

    private final BrandCarService brandCarService;

    @GetMapping("/{id}")
    public ResponseEntity<BrandCar> getBrandCarById(@PathVariable String id) throws BrandCarException {
        return ResponseEntity.ok(brandCarService.findById(id));
    }

    @ExceptionHandler(BrandCarException.class)
    public ResponseEntity<String> handleBrandCarException(BrandCarException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
    }
}

```

### La tercera forma:

La tercera forma es controlarlos globalmente mediante una clase, de esa forma quedaria: 

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(BrandCarException.class)
    public ResponseEntity<String> handleBrandCarException(BrandCarException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleGeneralException(Exception e) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body("Error interno del servidor: " + e.getMessage());
    }
}

```

Yo lo haré de la tercera forma en un ejercicio que estoy realizando :D. Asi que un dato de excepciones wuju. 

[https://www.notion.so](https://www.notion.so)

## Manejo de ambientes y perfiles: 

Una vez creado el proyecto la manera mas eficiente y sencilla para crear ambientes (Testing, produccion, dev, etc) es crear un `application.properties` o `application.yml` por cada uno de los ambientes.
![Pasted image 20251216144819.png](images/Pasted%20image%2020251216144819.png)
En cada uno de estos archivos de propiedades se coloca todo lo relacionado a lo que nosotros deseemos de configurar. Una base de datos diferente, un puerto diferente, un nombre diferente, una tamaño de pool diferente. 
Y en el `application.yml` vamos a colocar el perfil que deseamos:
```yaml
spring:  
  profiles:  
    active: dev # Aqui activamos dev
```

Algo que debe ser importante es que tanto `gradle` como `maven` también usan perfiles. Este es quien a nosotros nos crea el proyecto, asi que también es un apartado importante y a tener en cuenta.

### **MAVEN:**
En maven para crear un perfil basta con usar la etiqueta para esto, de la siguiente forma: 
```xml
<profiles>  
    <profile>  
	    <id>dev</id>  
	    <activation>       <!--Este es el perfil por defecto que se usa -->  
	       <activeByDefault>true</activeByDefault>  
	    </activation>    
	    <properties> <!--Estas etiquetas integran nuestro maven con nuestro springboot-->  
	       <build.profile.id>dev</build.profile.id> <!--Este es el nombre de nuestro perfil-->  
	       <profile.active>dev</profile.active>  
	    </properties>    
	    <build>       
		    <resources> <!--Los recursos que queremos que construya-->  
	          <resource> <!--Que recurso?-->  
	             <directory>src/main/resources</directory> <!--Le indicamos el directorio de donde estará-->  
	             <filtering>true</filtering> <!--Le activamos el filtro, que es lo que usa maven para facilitarle archivos-->  
	             <!--¿Qué archivos va a incluir?-->             
	             <includes>  
	                <include>application-dev.yml</include>  
	             </includes>          
		        </resource>       
		    </resources>    
		</build>
	</profile>
</profiles>
```
Dentro de nuestro  ``{xml icon} <proyect> ... </proyect> `` es donde va esta categoría.

Luego de ello podemos vincular nuestro archivo de propiedades de la siguiente forma: 
```yaml
spring:  
  profiles:  
    active: @profile.active@
```
Así le decimos que nosotros vamos a activar el perfil envuelto entre esa etiqueta.

Nosotros podemos crear tantos perfiles como queramos, el tema aqui es que puede ocurrirnos un error, para ello en el `build` general de la aplicación usamos: 
```xml 
<build>  
    <!--Aqui en el build general para los perfiles se identifiquen: -->  
    <!--Activar filtrado de perfiles-->    
    <resources>  
       <resource>          
       <directory>src/main/resources</directory>  
          <filtering>true</filtering>  
          <!--Le ponemos exclusiones-->  
          <excludes>  
             <exclude>application-*.yml</exclude>  
          </excludes>       
        </resource>    
    </resources>
          ...
```
Aquí le decimos que me excluya todos los `application-*.yml`, esto debido a que cuando haga los perfiles ya lo estoy incliyendo en: `	                <include>application-dev.yml</include>` .

Para activar esto a la hora de construir se usa de la siguiente forma: 
```cmd
mvn clean install -P<entorno>
```
En nuestro caso tenemos las siguientes 3: 
```bash
mvn clean install -Pstg
mvn clean install -Pdev
mvn clean install -Pprod
```
Por ejemplo, haciendo la primera nos genera los siguientes logs: 
![Pasted image 20251216173739.png](images/Pasted%20image%2020251216173739.png)
Que como vemos toma la configuración de `stg`.

***
### IMPORTANTE
Aqui hay un tema que es importante y es que en Springboot 4.x o 3.x puede fallar ese método anterior, lo mejor es agregar esto: 
```java
spring:  
  config:  
    activate:  
      on-profile: prod
```
En cada uno de los archivos de propiedades. Y luego se puede eliminar todo el tema de los perfiles en maven y delegarle eso a spring directamente.

***
### ¿Cómo usar los perfiles con anotaciones?
Los perfiles con anotaciones se usan de la siguiente forma: 
```java
@Profile({"tut1","hello-world"})
@Configuration
public class Tut1Config {

    @Bean
    public Queue hello() {
        return new Queue("hello");
    }

    @Profile("receiver")
    @Bean
    public Tut1Receiver receiver() {
        return new Tut1Receiver();
    }

    @Profile("sender")
    @Bean
    public Tut1Sender sender() {
        return new Tut1Sender();
    }
}
```
Aquí tenemos un ejemplo con RabbitMQ en el que tenemos perfiles, entonces le decimos que la clase `Tut1Config` solo se va a activar cuando estén los perfiles: `tut1` o `hello-world`, mientras que los perfiles de abajo con `receiver` y `sender` solo se activarán si también tienen ese perfil activo, es decir: 
`(tut1 OR hello-world) AND sender`.
Para activarlo en Spring Boot se hace por línea de comandos: `java -jar app.jar --spring.profiles.active=tut1,receiver`.  También por el `application.yml` haciendo: 
```yml title=application.yml
spring:
  profiles:
    active: tut1,receiver

```


---

# Java Spring Cloud
Aquí vamos a manejar lo que son los microservicios, seguiremos un video para ello. Manejaremos un microservicio de departamentos junto con un microservicio de empleados y otro microservicio de configuracion que es un config server. Todos configurados con un Service Discovery para tener los microservicios localizados y para tenerlos todos en un solo punto usaremos API Getaway que a su vez tendra un balanceador de cargas. 
Es un proyecto que combinaremos con documentación y más: 
## Spring Cloud
**Spring Cloud** es un conjunto de herramientas dentro del ecosistema Spring que te ayuda a construir **sistemas distribuidos y microservicios** de manera más sencilla, robusta y escalable.
La arquitectura por la documentación: 

![Pasted image 20250513214651.png](src/Java%20SpringBoot/Pasted%20image%2020250513214651.png)

Aqui encontramos como esta funcionando la arquitectura principal. Luego de enviar alguna peticion mediante un movil, un navegador o un IoT entrá a un 
#### **ApiGetaway**:
En pocas palabras es el único punto de entrada para los clientes, este se encarga de: 
- Enrutar peticiones a los microservicios
- Hacer la autenticación , logging, rate limit, etc
- Oculta la complejidad de los microservicios internos
#### **Service Registry**:
Este es: 
- Un registro central de servicios
- Cada microservicio se registra aqui (nombre, IP, puerto)
- Otros servicios pueden descrubrirse aqui dinamicamente
#### **Config Server**:
- Proporciona **configuración centralizada** a todos los microservicios.
- La config suele estar en un **repositorio Git**.
- Permite:
    - Modificar configuración sin tener que recompilar.
    - Mantener consistencia entre entornos (dev, qa, prod). 
#### Distributed Tracing
Sirve mucho para debugging y monitorización.

---

Antes de seguir con un proyecto de springcloud vamos a empezar con un curso de [spring cloud](https://www.youtube.com/watch?v=U_rPO2ILMFU&list=PLxy6jHplP3Hi_W8iuYSbAeeMfaTZt49PW&index=2) . 


***
# CACHE en Spring Boot: 

Vamos a repasar lo que es el caché como tal y como se implementa en springboot de diferentes formas.

Antes de hablar del caché en general, debemos entender como se gestiona la memoria en java, stack vs heap. 

En java la memoria se divide conceptualmente así:
```plaintext
Thread
 ├─ Stack (por thread)
 │    ├─ variables locales
 │    ├─ parámetros
 │    └─ frames de métodos
 │
 └─ Heap (compartido)
      └─ objetos
```

STACK:

Cada thread o hilo tiene su propio stack:
Por ejemplo: 
```java
public void foo(){
	int x = 10;
}
```
`x` vive en el stack del thread.
Si 100 threads llaman a `foo()`, existen 100 copias de `x`.
Por lo que es thread-safe naturalmente.

HEAP: 
Los objetos viven el heap compartido. 
```java
Map<String,Object> cache = new HashMap<>();
```
Ese `HashMap` vive en el heap.
Esto significa que todos los threads ven el mismo objeto. 
```text
Thread A  
Thread B  
Thread C  
	↓  
	mismo objeto HashMap en Heap
```
***
Algo más en esto es este tema, las variables locales como en el ejemplo del método `foo` son thread-safe porque pertenecen al stack.
Los atributos del objeto como por ejemplo: 
```java
class A {
	int x; // este atributo
}
```
Estos pertenecen al heap y son compartidos, por lo que no es, a priori thread-safe. Pero si el objeto es singleton, todos los threads apuntarán al mismo atributo.

Con esto en mente vamos a fabricar nuestro caché. No será tan increíble como librerías como `spring-cache` o `caffeine`, o incluso Redis que es bastante bueno en esto. 

Vamos a empezar con un programa super sencillo: 

![[Pasted image 20260305193012.png]]

Aquí nosotros vemos simplemente los repositorios, servicios y controladores habituales. Ahora, en el repositorio de book observamos lo siguiente: 
```java
@Repository
public class RepositoryBookLocal implements RepositoryBook {

    private final Map<Long, BookEntity> books = new ConcurrentHashMap<>();
    private final RepositoryAuthorLocal authorRepository = new RepositoryAuthorLocal();

    public RepositoryBookLocal() {
        initializeData();
    }

    private void initializeData() {
        // Obtener autores del repositorio de autores
        AuthorEntity garciaMarquez = authorRepository.findById(1L).orElse(null);
        AuthorEntity isabelAllende = authorRepository.findById(2L).orElse(null);
        AuthorEntity borges = authorRepository.findById(3L).orElse(null);
        AuthorEntity vargasLlosa = authorRepository.findById(4L).orElse(null);
        AuthorEntity cortazar = authorRepository.findById(5L).orElse(null);

        // Crear libros con sus respectivos autores
        BookEntity book1 = new BookEntity(1L, "Cien años de soledad", garciaMarquez);
        BookEntity book2 = new BookEntity(2L, "El amor en los tiempos del cólera", garciaMarquez);
        BookEntity book3 = new BookEntity(3L, "La casa de los espíritus", isabelAllende);
        BookEntity book4 = new BookEntity(4L, "Paula", isabelAllende);
        BookEntity book5 = new BookEntity(5L, "Ficciones", borges);
        BookEntity book6 = new BookEntity(6L, "El Aleph", borges);
        BookEntity book7 = new BookEntity(7L, "La ciudad y los perros", vargasLlosa);
        BookEntity book8 = new BookEntity(8L, "Conversación en La Catedral", vargasLlosa);
        BookEntity book9 = new BookEntity(9L, "Rayuela", cortazar);
        BookEntity book10 = new BookEntity(10L, "Bestiario", cortazar);

        // Agregar libros al repositorio
        books.put(1L, book1);
        books.put(2L, book2);
        books.put(3L, book3);
        books.put(4L, book4);
        books.put(5L, book5);
        books.put(6L, book6);
        books.put(7L, book7);
        books.put(8L, book8);
        books.put(9L, book9);
        books.put(10L, book10);
    }

    @Override
    public List<BookEntity> findAll() throws InterruptedException {
        Thread.sleep(2000); // Simular retraso de 2 segundos
        return new ArrayList<>(books.values());
    }

    @Override
    public Optional<BookEntity> findById(Long id) {
        return Optional.ofNullable(books.get(id));
    }

    @Override
    public BookEntity save(BookEntity book) {
        if (book.getId() == null) {
            // Generar nuevo ID
            Long newId = books.keySet().stream()
                    .max(Long::compareTo)
                    .orElse(0L) + 1;
            book.setId(newId);
        }
        books.put(book.getId(), book);
        return book;
    }

    @Override
    public void deleteById(Long id) {
        books.remove(id);
    }
}

```

simulamos dos cosas, los datos y simulamos también un retraso de 2 segundos para los libros. Y ahora estamos preparados para añadir el caché. Un primer vistazo podemos pensar en esto: 
```java
@Service  
public class BookServicesImpl implements BookService {  
  
    private final RepositoryBook repositoryBook;  
    private final Map<String, Object> cache;  
  
    public BookServicesImpl(RepositoryBook repositoryBook) {  
        this.repositoryBook = repositoryBook;  
        this.cache = new HashMap<>();  
    }  
  
  
    @Override  
    public List<BookEntity> findAll() {  
        List<BookEntity> cached = (List<BookEntity>) cache.get("findAll");  
        if (cached != null) {  
            return cached;  
        }  
  
        try {  
            cache.put("findAll", repositoryBook.findAll());  
            return new ArrayList<>(repositoryBook.findAll());  
        } catch (InterruptedException e) {  
            Thread.currentThread().interrupt();  
            throw new RuntimeException("Thread was interrupted", e);  
        }  
  
    }  
    
	...
}
```

Porque claro, tenemos en mente que un caché puede ser de cada servicio, metemos el mapa así nomas y llamamos solamente dentro de cada uno de sus métodos, todo suena bien hasta que entendemos el tema de como accede java a la memoria. El mapa se vuelve inseguro o no es thread-safe, porque es un elemento que todos van a acceder y no estamos manejando `lock`, o `syncronized`. 

Por lo anterior una mejor practica seria solamente hacer: 
```java
	...
public BookServicesImpl(RepositoryBook repositoryBook) {  
        this.repositoryBook = repositoryBook;  
        this.cache = new ConcurrentHashMap<>();  
    }
    ...
```
Ya con esto manejamos mejor el tema; sin embargo, siempre puede haber algo mejor, y es generando el servicio. Ya queda para el lector crear el servicio, es la misma idea, solo que ahora inyectamos el servicio. Con este servicio no solo manejamos fácilmente el caché de un repositorio de datos, sino que también el de todos los que queramos, así, centralizándolo.

Otra forma bastante elegante de crearlo es con el patrón decorador, pensemos, ¿cuál sería el componente?, la base decorador?
Bueno, puede parecer un poco de sobre ingeniería, pero es importante tocarlo, ya que a lo mejor podríamos añadir una fábrica de cahés. ¿Que cache necesitamos?, uno con largo almacenamiento?, ¿uno con poco?, etc. Entonces tenemos: 

Primeramente nuestro decorador caché.
```java
public abstract class CacheDecorator {  
  
    protected static final String FIND_ALL_KEY = "books:findAll";  
    protected final BookService bookService;  
  
    protected CacheDecorator(BookService bookService) {  
        this.bookService = bookService;  
    }  
  
    protected String findByIdKey(Long id) {  
        return "books:findById:" + id;  
    }  
  
    protected void invalidateFindAll() {  
        evict(FIND_ALL_KEY);  
    }  
  
    protected void invalidateFindById(Long id) {  
        if (id != null) {  
            evict(findByIdKey(id));  
        }  
    }  
  
    protected abstract <T> T getOrCompute(String key, Supplier<T> supplier);  
  
    protected abstract void evict(String key);  
  
    protected abstract void clear();  
}
```

Luego la implementación que será de BookService, en este caso solo es para nuestro BookService. Con reflexión podríamos hacer algo mucho mejor para cualquier servicio y manejar las anotaciones tipo interfaz pero sería para crear uno propio bastante completo. 
Como deciamos la implementación se ve de esta forma: 
```java
public class CacheBookDecorator extends CacheDecorator implements BookService {  
  
    private final Map<String, Object> cache;  
  
    public CacheBookDecorator(BookService wrapped) {  
        super(wrapped);  
        this.cache = new ConcurrentHashMap<>();  
    }  
  
    @Override  
    public List<BookEntity> findAll() {  
        return getOrCompute(FIND_ALL_KEY, bookService::findAll);  
    }  
  
    @Override  
    public Optional<BookEntity> findById(Long id) {  
        return getOrCompute(findByIdKey(id), () -> bookService.findById(id));  
    }  
  
    @Override  
    public BookEntity save(BookEntity book) {  
        BookEntity saved = bookService.save(book);  
        invalidateFindAll();  
        invalidateFindById(saved != null ? saved.getId() : null);  
        return saved;  
    }  
  
    @Override  
    public void deleteById(Long id) {  
        bookService.deleteById(id);  
        invalidateFindAll();  
        invalidateFindById(id);  
    }  
  
    @Override  
    @SuppressWarnings("unchecked")  
    protected <T> T getOrCompute(String key, Supplier<T> supplier) {  
        return (T) cache.computeIfAbsent(key, ignored -> supplier.get());  
    }  
  
    @Override  
    protected void evict(String key) {  
        cache.remove(key);  
    }  
  
    @Override  
    protected void clear() {  
        cache.clear();  
    }  
}
```

En la clase de la implementación identificamos que lo único que hace es añadir al mapa y ya, si no lo delega al servicio como tal que para ver como está, está así: 
```java
@Service  
public class BookServicesImpl implements BookService {  
  
    private final RepositoryBook repositoryBook;  
  
    public BookServicesImpl(RepositoryBook repositoryBook) {  
        this.repositoryBook = repositoryBook;  
    }  
  
  
    @Override  
    public List<BookEntity> findAll() {  
        try {  
            return new ArrayList<>(repositoryBook.findAll());  
        } catch (InterruptedException e) {  
            Thread.currentThread().interrupt();  
            throw new RuntimeException("Thread was interrupted", e);  
        }  
    }  
  
    @Override  
    public Optional<BookEntity> findById(Long id) {  
        return repositoryBook.findById(id);  
    }  
  
    @Override  
    public BookEntity save(BookEntity book) {  
        return repositoryBook.save(book);  
    }  
  
    @Override  
    public void deleteById(Long id) {  
        repositoryBook.deleteById(id);  
    }  
}
```

Cómo vemos no hay nada extraño, es un servicio normal. Ahora, debemos agregar algo a la configuración: 
```java
@Configuration  
public class ServiceConfig {  
  
    @Bean  
    public BookService bookService(BookService bookServicesImpl) {  
        return new CacheBookDecorator(bookServicesImpl);  
    }  
  
}
```
Esta es la parte más importante, ya que aquí es donde realmente usamos el decorador, aquí es donde decoramos la clase. 

Ahora debemos pensar en el dato, ¿hay datos obsoletos?, ¿existe un crecimiento infinito de memoria con lo que hacemos?, ¿hay inconsistencias en sistemas distribuidos?. Esto son los famosos TTL.

***
Identifiquemos ciertos atributos del caché: 

Está el caché en memoria o el caché distribuido, el caché en memoria es guardada en la memoria de las aplicaciones tal y como hemos venido haciéndolo, este método es bastante rápido, pero solo aplica a una instancia de la aplicación por lo que puede llegar a ser ineficiente.  Luego tenemos el caché distribuido que es información guardada en un sistema externo y se comparte en múltiples instancias de la aplicación. 

Cómo vimos otro concepto importante es el TTL (Time To Live), esta es la duración por la cual la información debe estar en el caché. Una vez expirado, el caché es automáticamente removido o actualizado para tenerlo al día.

También tenemos los "Eviction Strategies", estos deciden que información remover cuando el caché está totalmente lleno
- **LRU (Least Recently Used):** Remueve información que no ha sido usada recientemente
- **LFU(Least Frequently Used):** Remueve información que es menos usada
- **FIFO(First In, First Out):** Remueve la información que fue añadida primero
## Caching en SpringBoot:

Ahora, una vez ya visto todo lo anterior, vamos a mirar como es el caché en spring boot. 
Spring caché es una abstracción de caching.

No implementa el caché directamente. Lo que hace es proveer una API uniforme para distintos motores de caché
La dependencia necesaria: 
```xml
<dependency>
 <groupId>org.springframework.boot</groupId>
 <artifactId>spring-boot-starter-cache</artifactId>
</dependency>
```

La arquitectura conceptual: 
```text
Application
     ↓
Spring Cache Abstraction
     ↓
Cache Provider
     ├─ Caffeine
     ├─ Redis
     ├─ Ehcache
     └─ Simple Map
```

Algunos ejemplos de proveedores son> 
- Redis
- Caffeine
- Ehcache
### Arquitectura interna de Spring Cache

Los componentes principales 
```text
@Cacheable
	↓
AOP Proxy
	↓
CacheInterceptor
	↓
CacheManager
	↓
Cache provider
```
Es decir, Spring usa AOP para interceptar el método (Luego veremos AOP a profundidad)
Así cuando llamamos por ejemplo a: `bookService.findAll()`
Lo que realmente ocurre es: 
```text
Proxy
   ↓
Cache check
   ↓
Method execution
```
Vamos a ver prontamente lo que son las anotaciones, sin embargo hay algo que debemos entender primero y es el procesao de una anotación especifica: 
```java
@Cacheable("books")
public List<Book> findAll() {
    return repository.findAll();
}
```
Esto hace: 
```text
1 request llega
2 proxy intercepta método
3 genera clave
4 revisa cache
5 hit → devuelve
6 miss → ejecuta método
7 guarda resultado
8 devuelve resultado
```

### Sistema de caché
Primero debemos activar el sistema de caché: 
```java
@SpringBootApplication  
@EnableCaching   // Esta es la importante
public class AprenderCacheApplication {  
  
    public static void main(String[] args) {  
        SpringApplication.run(AprenderCacheApplication.class, args);  
    }  
  
}
```
Podemos hacerlo de la forma de arriba o también de la siguiente forma:
```java
@Configuration  
@EnableCaching  
public class AppConfig {  
	...
}
```
Ya que es una configuración directa, podríamos decirlo.
Hacer todo eso registra:
- CacheInterceptor
- CacheManager
- CacheResolver

#### Rol de cada componente que registra: 
- `@EnableCaching`: Es la señal que le damos a Spring para que empiece a aplicar las reglas de caché en la aplicación. Sin esto spring ignora todas las anotaciones de caché en general.
- `CacheInterceptor`: Es el que intercepta las peticiones o llamadas a un método que tiene anotación de caché como `@Cacheable`. Su trabajo es decidir, siguiendo las reglas, si debe buscar en el caché  y devolverlo directamente o si debe ejecutar el método para luego si guardarlo, es el ejecutor de la política caché.
- `CacheManager`: Es el Jefe del caché, quien lo maneja. Es quien conoce todos los caché que existen y sabe como gestionarlos. Cuando el `CacheInterceptor` necesita algún "estante" llamado PRODUCTOS, le pregunta al este `CacheManager` y este le devuelve sin importar si usa `ConcurrentMap` o usa algo más sofisticado como `Ehcache` o un almacén externo como Redis. Actua como un acceso unificado para todas las cache.
- `CacheResolver`: Es el especializado de encontrar el "estante" correcto. Es una pieza más avanzada. Por defecto, el `CacheManager` resuelve las cachés solo por su nombre. El `CacheResolver` te permite escribir lógica personalizada para decidir qué caché o cachés se deben usar para una invocación de método en particular, basandose en el contexto de la llamada
#### El cache provider:
Claro, después de todo eso debe de haber un lugar físico en el cual se guarden los datos. Ahí es donde entra el cache provider.

El `CacheManager` es una interfaz. Necesitas una implementación concreta que sea la que realmente guarde los datos en memoria, en disco, o en un sistema remoto. Y Spring ya incluye uno por defecto para empezar sin una configuración adicional. 

- El proveedor por defecto: `ConcurrentMapCacheManager`.
	- Cuando tienes `@EnableCaching`, pero no has configurado nada más, Spring Boot o Spring Framework, asume automáticamente un proveedor "Simple". Este proveedor es el `ConcurrentMapCacheManager`, que como su nombre indica, utiliza un `ConcurrentHashMap` de Java para almacenar los objetos en caché.
- Otros proveedores: 
	- Spring Boot es inteligente y puedeautoconfigurarr otros `CacheManager` si detecta las librerías necesarias en el classpath. Esto nos permite cambiar el almacenamiento subyacente sin modificar nuestro código. Algunos ejemplos son:
		- [Ejemplo](https://docs.spring.io/spring-boot/docs/1.3.0.M5/reference/html/boot-features-caching.html)
		- [Ejemplo 2 aunque está en chino xd](https://www.ucloud.cn/yun/73389.html)


### En programa: 
Vamos a ver las anotaciones principales, ya vimos la que configura, en general, todo además de habilitar.
***
#### `@Cacheable`

Esta es la más importante, ya que si existe en caché, devuelve, y si no ejecuta el método y guarda, un ejemplo: 
```java
@Cacheable("books")  
public Book findById(Long id) {  
return repository.findById(id);  
}
```
La clave generada: 
```text
cacheName: books
key: id
```

Aqui hay algo importante y es el SpEL en java (Spring Expression Language), cosa que no vamos a tocar en profundidad, pero podemos observar que en los valores de Caché se implementa ese mecanismo.

El parámetro `value` técnicamente define el nombre de la caché (o cachés) donde se almacenará el resultado. El `CacheManager` usa este nombre para resolver la instancia concreta de `Cache` (vía `CacheResolver`). Puede ser un `String[]` si se quiere almacenar en múltiples cachés simultáneamente. 
El parámetro `key` (y SpEL) utiliza el spring expression language para evaluar dinámicamente la clave de caché en tiempo de ejecución. El contexto de evaluación proporciona:
- `#root.args`: Array de todos los argumentos del método
- `#root.methodName`: Nombre del método
- `#root.target`: Objeto target (el bean)
- `#root.caches`: Array de las cachés actuales
- Y básicamente todos los parámetros del método por nombre

***
#### `@CachePut`

Aqui ejecuta el método y actualiza el caché:
```java
@CachePut(value = "books" , key = "#book.id")
public Book update(Book book){
	return repository.save(book);
}
```

Para dar un ejemplo más completo para este apartado vamos a realizar lo siguiente en nuestro programa: 

Primero vamos a generar un buen servicio un poco más completo: 
```java
@Service  
public class BookServicesImpl implements BookService {  
  
    private final BookRepository bookRepository;  
  
    public BookServicesImpl(BookRepository bookRepository) {  
        this.bookRepository = bookRepository;  
    }  
  
  
    @Override  
    @Cacheable("books")  
    public List<BookEntity> findAll() {  
        try {  
            return new ArrayList<>(bookRepository.findAll());  
        } catch (InterruptedException e) {  
            Thread.currentThread().interrupt();  
            throw new RuntimeException("Thread was interrupted", e);  
        }  
    }  
  
    @Override  
    @Cacheable(value = "books", key = "#id")  
    public Optional<BookEntity> findById(Long id) {  
        try {  
            return bookRepository.findById(id);  
        } catch (InterruptedException e) {  
            throw new RuntimeException(e);  
        }  
    }  
  
    @Override  
    @CachePut(value = "books", key = "#book.id")  
    public BookEntity save(BookEntity book) {  
        return bookRepository.save(book);  
    }  
  
    @Override  
    public void deleteById(Long id) {  
        bookRepository.deleteById(id);  
    }  
}
```

Lo importante es que tenemos un `@Cacheable` en `findById` y tenemos el `@CachePut` en donde guardamos para buscar el `id` de forma ya cacheable, la buscamos en el método `findById()`. Entonces, para que eso pase vamos a completar el código: 

En el controlador
```java
@RestController  
@RequestMapping("/books")  
public class BookController {  
  
    private final BookService bookService;  
    private final Mediator mediator;  
  
  
    public BookController(BookService bookService,  
                          @Qualifier("createBookMediator") Mediator mediator) {  
        this.bookService = bookService;  
        this.mediator = mediator;  
    }  
  
  
    @GetMapping  
    public List<BookEntity> getBooks() {  
        return bookService.findAll();  
    }  
  
    @GetMapping("/{id}")  
    public ResponseEntity<BookEntity> getBookById(@PathVariable Long id) {  
        return bookService.findById(id)  
                .map(ResponseEntity::ok)  
                .orElse(ResponseEntity.notFound().build());  
    }  
  
    @PostMapping  
    public ResponseEntity<Void> save(@RequestBody BookRequest request) {  
        mediator.notify(request, "bookCreated");  
        return ResponseEntity.status(HttpStatus.CREATED).build();  
    }  
}
```

Dentro de save hay un mediador, para mostrar cómo funciona: 
```java
public interface Mediator {  
  
    void notify(Object sender, String event);  
}

//---

@Component  
@Qualifier("createBookMediator")  
public class CreateBookMediator implements Mediator {  
  
    private final BookService bookService;  
    private final AuthorService authorService;  
  
    public CreateBookMediator(BookService bookService, AuthorService authorService) {  
        this.bookService = bookService;  
        this.authorService = authorService;  
    }  
  
    @Override  
    public void notify(Object sender, String event) {  
        // primero vamos a que el objeto sea un libro enviado, es decir, bookRequest  
        var bookRequest = (BookRequest) sender;  
        if (event.equals("bookCreated")) {  
            var author = authorService.findById(bookRequest.authorId());  
            if (author.isPresent()) {  
                var bookEntity = BookMapper.requestToEntity(bookRequest);  
                // añadimos el autor por set, ya que no es del dominio, si lo fuera set está prohibido  
                bookEntity.setAuthor(author.get());  
                // guardamos el libro  
                bookService.save(bookEntity);  
            } else {  
                throw new RuntimeException("Author not found");  
            }  
        }  
    }  
}
```
Y como vimos debemos agregar un timer: 
```java
@Repository  
public class BookRepositoryLocal implements BookRepository {

	...
	
	@Override  
	public Optional<BookEntity> findById(Long id) throws InterruptedException {  
	    Thread.sleep(2000);  
	    return Optional.ofNullable(books.get(id));  
	}  
	  
	@Override  
	public BookEntity save(BookEntity book) {  
	    if (book.getId() == null) {  
	        // Generar nuevo ID  
	        Long newId = books.keySet().stream()  
	                .max(Long::compareTo)  
	                .orElse(0L) + 1;  
	        book.setId(newId);  
	    }  
	    books.put(book.getId(), book);  
	    return book;  
	}
	
	...
}
```

Ya luego hacemos las pruebas en insomnia, postman, curl o en el que mejor se adapte: 

Primero miraremos cuanto dura para buscar un ID: 
![[Pasted image 20260306221101.png]]

Luego vamos a crear nuestro libro: 
![[Pasted image 20260306221148.png]]

Y por último ... ¿Cuánto demorará si buscamos el número 11 que acabamos de añadir?:
![[Pasted image 20260306221249.png]]

Aquí es donde observamos cómo funciona el `@CachePut`

***

#### `@CacheEvict`

Básicamente elimina los datos del caché.
Este es un ejemplo bastante sencillo, solo debemos de poner lo siguiente: 

```java
@Service  
public class BookServicesImpl implements BookService {  
  
    ...
  
    @Override  
    @CacheEvict(value = "books", key = "#id")  
    public void deleteById(Long id) {  
        bookRepository.deleteById(id);  
    }  
}
```
Y vamos de paso a cerar el apartado del controlador:

```java
@RestController  
@RequestMapping("/books")  
public class BookController {  
  
    private final BookService bookService;  
    private final Mediator mediator;  
  
  
    public BookController(BookService bookService,  
                          @Qualifier("createBookMediator") Mediator mediator) {  
        this.bookService = bookService;  
        this.mediator = mediator;  
    }  
  
  
    @GetMapping  
    public List<BookEntity> getBooks() {  
        return bookService.findAll();  
    }  
  
    @GetMapping("/{id}")  
    public ResponseEntity<BookEntity> getBookById(@PathVariable Long id) {  
        return bookService.findById(id)  
                .map(ResponseEntity::ok)  
                .orElse(ResponseEntity.notFound().build());  
    }  
  
    @PostMapping  
    public ResponseEntity<?> save(@RequestBody BookRequest request) {  
        EventApplication event = new CreateBookEvent(request);  
        var ret = (BookEntity) mediator.notify(event);  
        return new ResponseEntity<>(  
                BookCreatedResponse.success(ret.getId(), ret.getTitle())  
                , HttpStatus.CREATED);  
    }  
  
	  // PARTE IMPORTANTE
  
    @DeleteMapping("/{id}")  
    public ResponseEntity<Void> delete(@PathVariable Long id) {  
        bookService.deleteById(id);  
        return ResponseEntity.noContent().build();  
    }  
}
```

Vamos a hacer una prueba, si nosotros NO usamos el `CacheEvict` sucede esto: 
Creamos el libro: 
![[Pasted image 20260307122153.png]]
Buscamos y en efecto encontramos el libro: 
![[Pasted image 20260307122208.png]]
Eliminamos el libro: 
![[Pasted image 20260307122225.png]]
SI NOSOTROS NO USAMOS EL `@CacheEvict`, cuando hacemos el get de nuevo: 
![[Pasted image 20260307122257.png]]
Vemos que se encuentra aunque realmente no esté. Si hacemos el mismo proceso con el `@CacheEvict`: 
![[Pasted image 20260307122403.png]]
Con esto concluimos el porque y la necesidad de esta anotación, aunque de ultima forma, podemos eliminar todo un apartado de esta forma: 
```java
@CacheEvict(value = "books", allEntries = true) // Esto limpia TODO el value = books
```

***
#### `@Caching`

Este permite combinar operaciones.
Básicamente, puede coordinar múltiples operaciones en un solo método, vamos a ver como es el su anatomía: 
```java
@Target({ElementType.TYPE, ElementType.METHOD})  
@Retention(RetentionPolicy.RUNTIME)  
@Inherited  
@Documented  
@Reflective  
public @interface Caching {  
    Cacheable[] cacheable() default {};  
  
    CachePut[] put() default {};  
  
    CacheEvict[] evict() default {};  
}
```

Aquí es impórtate mencionar que los arrays se ejecutan en este orden: 
1. `evict` (primero limpia)
2. `cacheable` (Después se verifica/busca)
3. `put` finalmente se guarda

Los escenarios practicos para esto es algo que rara vez vamos a poder utiizar, aunque siempre puede ser buena idea conocer,  por ejemplo imaginemos que al actualziar un libro dee actualizar cache del libro, limpiar cache de busquedas y actualizar la caché del autor. Entonces: 

```java
@Service
public class BookService {
    
    @Caching(
        // Primero: Limpiar cachés derivadas
        evict = {
            @CacheEvict(value = "bookSearch", allEntries = true), // Limpia TODAS las búsquedas
            @CacheEvict(value = "authorBooks", key = "#book.authorId") // Limpia solo del autor específico
        },
        // Luego: Actualizar la caché principal del libro
        put = {
            @CachePut(value = "books", key = "#book.id") // Actualiza el libro
        }
    )
    public BookEntity updateBook(BookEntity book) {
        return bookRepository.save(book);
    }
}
```

Otro escenario puede ser el de busqueda múltiple de caché con diferentes claves: 
```java
public class UserService {
    
    @Caching(
        cacheable = {
            @Cacheable(value = "users", key = "#userId"),           // Busca por ID
            @Cacheable(value = "usersByEmail", key = "#email")      // Busca por email
        },
        put = {
            @CachePut(value = "userProfiles", key = "#result.profileId") // Guarda el perfil asociado
        }
    )
    public User getUserWithProfile(Long userId, String email) {
        // Lógica que obtiene usuario y su perfil
        return userRepository.findByIdAndEmail(userId, email);
    }
}
```

También pueden ser operaciones condicionales: 

```java
public class InventoryService {
    
    @Caching(
        evict = {
            @CacheEvict(value = "productList", condition = "#product.stock == 0"), // Solo si stock es 0
            @CacheEvict(value = "categoryProducts", key = "#product.categoryId", 
                       condition = "#product.price > 1000") // Solo si es caro
        },
        put = {
            @CachePut(value = "products", key = "#product.id", 
                     unless = "#product.status == 'INACTIVE'") // No guardar si está inactivo
        }
    )
    public ProductEntity updateProduct(ProductEntity product) {
        return productRepository.save(product);
    }
}
```

Algo invalido es: 
```java
// ❌ CÓDIGO INVÁLIDO - NO COMPILA
@CachePut(value = "books", key = "#book.id")
@CacheEvict(value = "searchCache", allEntries = true)
public BookEntity save(BookEntity book) {
    return repository.save(book);
}
```

No podemos combinar, para eso necesitamos el `@Caching` específicamente.

***

### Tip y casos de uso: 

Un tip necesario es colocar configuración a nivel de clases, y combinar los caching, por ejemplo: 
```java
@CacheConfig(cacheNames = "books") // Configuración a nivel de clase
@Service
public class AdvancedBookService {
    
    @Caching(
        evict = {
            @CacheEvict(key = "#id"), // Hereda "books" de @CacheConfig
            @CacheEvict(value = "searchCache", allEntries = true)
        }
    )
    public void deleteBook(Long id) {
        repository.deleteById(id);
    }
    
    @Caching(
        put = {
            @CachePut(key = "#result.id"), // Hereda "books"
            @CachePut(value = "bookDetails", key = "#result.isbn")
        }
    )
    public BookEntity saveWithDetails(BookEntity book) {
        return repository.save(book);
    }
}
```

#### Caso de uso: 
Aplicar caching indiscriminadamente es una receta para problemas de memoria, overhead de invalidation y datos obsoletos. Los candidatos ideales son aquellos que cumplen con la mayoría de estos criterios: son operaciones costosas en CPU o base de datos, se ejecutan con alta frecuencia, tienen un conjunto de claves reutilizable (baja cardinalidad), pueden tolerar cierto grado de obsolescencia y su lentitud impacta directamente en la experiencia del usuario (altos percentiles P95/P99) [](https://blog.sentry.io/ai-driven-caching-strategies-instrumentation/?original_referrer=https%3A%2F%2Fblog.sentry.io%2F2023%2F02%2F15%2Fgetting-started-with-jetpack-compose%2F%3Futm_source%3Ddevto%26utm_medium%3Dpaid-community%26utm_campaign%3Dgeneral-fy26q1-mims%26utm_content%3Dstatic-ad-acid-startfree). 
Por el contrario, debes evitar cachear datos con alta cardinalidad (como consultas con muchos filtros únicos o IDs de usuario), información altamente volátil que requiere frescura inmediata, o datos personalizados donde un error en la clave podría filtrar información. Cachear respuestas que ya son rápidas o cuyo costo de serialización es mayor que el beneficio tampoco tiene sentido, y hay que tener cuidado con patrones que pueden causar estampidas o sobrecargar la memoria si los payloads son muy grandes [](https://docs.spryker.com/docs/dg/dev/guidelines/performance-guidelines/custom-code-performance-guidelines)[](https://blog.sentry.io/ai-driven-caching-strategies-instrumentation/?original_referrer=https%3A%2F%2Fblog.sentry.io%2F2023%2F02%2F15%2Fgetting-started-with-jetpack-compose%2F%3Futm_source%3Ddevto%26utm_medium%3Dpaid-community%26utm_campaign%3Dgeneral-fy26q1-mims%26utm_content%3Dstatic-ad-acid-startfree).

Para definir tu caso de uso, necesitas un estudio basado en datos de producción, no en suposiciones. Debes comenzar por identificar los cuellos de botella reales: busca en tus herramientas de monitoreo las transacciones con peor rendimiento (P95/P99 alto), las consultas a base de datos más pesadas y repetitivas, y los endpoints que están en la ruta crítica de las operaciones más frecuentes [](https://blog.sentry.io/ai-driven-caching-strategies-instrumentation/?original_referrer=https%3A%2F%2Fblog.sentry.io%2F2023%2F02%2F15%2Fgetting-started-with-jetpack-compose%2F%3Futm_source%3Ddevto%26utm_medium%3Dpaid-community%26utm_campaign%3Dgeneral-fy26q1-mims%26utm_content%3Dstatic-ad-acid-startfree). 
Analiza los patrones de acceso: ¿los mismos datos se solicitan una y otra vez con los mismos parámetros? Por ejemplo, en un endpoint paginado, es probable que solo la página 1 y los filtros más comunes tengan alta reutilización, mientras que las páginas profundas tienen cardinalidad casi infinita y no deberían cachearse [](https://blog.sentry.io/ai-driven-caching-strategies-instrumentation/?original_referrer=https%3A%2F%2Fblog.sentry.io%2F2023%2F02%2F15%2Fgetting-started-with-jetpack-compose%2F%3Futm_source%3Ddevto%26utm_medium%3Dpaid-community%26utm_campaign%3Dgeneral-fy26q1-mims%26utm_content%3Dstatic-ad-acid-startfree).

Las métricas clave para evaluar el éxito son, principalmente, la tasa de aciertos (hit ratio), que debe alinearse con tus expectativas (no buscar el 100% ciegamente); la reducción en la latencia de respuesta (especialmente en los percentiles altos); y la disminución en la carga de tu base de datos o servicios externos [](https://www.zenml.io/llmops-database/multi-layered-caching-architecture-for-ai-metadata-service-scalability)[](https://www.devx.com/web-development-zone/database-caching-patterns-for-performance-optimization/). 
Una buena implementación se valida cuando, por ejemplo, reduces la latencia de 400ms a menos de 1ms para los hits y observas una caída significativa en las consultas a la base de datos, todo mientras monitoreas que las tasas de error no se disparen y que el consumo de memoria del caché se mantenga dentro de lo planificado

## Caffeine y Redis

### Caffeine

Vamos a hablar de Caffeine primero, este es una biblioteca Java de alto rendimiento para crear y gestionar cachés en memoria. Este no es un simple mapa donde se guardan cosas. Lo que lo hace especial es cómo gestiona el espacio y decide que datos conservar y cuáles eliminar. Como la memoria no es infinita, tiene que ser selectivo. 

Su funcionamiento se basa en dos conceptos claves: 
1. **Política de expulsión** Son las reglas para decidir que datos sacar del caché cuando está lleno
	- Basada en tamaño (no quiero que el caché sobrepase los 100 MB)
	- Basada en tiempo (Elimina los datos después de 10 minutos de guardado, o si no se han usado en al menos 5 minutos)
2. **Política de eliminación** La parte más inteligente es cómo decide qué es "menos útil". Caffeine utiliza un algoritmo llamado *Window TinyLFU (Least Frequently Used)*
	- **Frecuencia:** Sigue un registro de qué elementos se piden más veces. Los que se piden mucho, se quedan. Los que apenas se usan, son los primeros en irse si hace falta espacio.
	- **Ventana de frescura:** Añade una pequeña "ventana" especial para dar una oportunidad a los elementos nuevos. Imagina un artículo de hoy que de repente se vuelve viral. Sin esta ventana, se eliminaría rápidamente por no tener un historial de uso, pero gracias a ella, tiene tiempo de demostrar que es popular y pasar a la zona de "frecuentes".
	- **Filtro de frecuencia:** Usa una estructura de datos muy eficiente para recordar aproximadamente cuántas veces se ha usado un elemento, sin gastar mucha memoria en ello.

**Caffeine es una caché "autogestionada" que aprende de los patrones de acceso de tu aplicación para mantener siempre disponibles los datos que más le pides, optimizando el uso de la memoria y haciendo tu programa mucho más rápido.**

#### Cómo se usa:

Debemos añadir, en primer lugar, el `spring-boot-starter-cache` y `caffeine` como dependencias de java en, ya sea maven o gradle.
```xml
 <dependency>
	<groupId>com.github.ben-manes.caffeine</groupId>
	<artifactId>caffeine</artifactId>
</dependency>
```

No debemos olvidar el `@EnableCaching`.

Un dato importante es configurar el cachée mediante las propiedades o mediante el yml:
```yml
spring.cache.type=caffeine  
# Especificacion de caffeine  
spring.cache.caffeine.spec=maximumSize=100,expireAfterAccess=5m  
#nombres de las caches  
spring.cache.cache-names=cacheLibros,cacheAutores
```
En los nombres se recomienda pero no es obligatorio.

Otra forma de hacerlo de forma más "programable" es mediante beans: 
```java
@Configuration
@EnableCaching
public class CacheConfig {

    @Bean
    public CacheManager cacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager("usuarios", "productos");
        cacheManager.setCaffeine(caffeineCacheBuilder());
        return cacheManager;
    }

    private Caffeine<Object, Object> caffeineCacheBuilder() {
        return Caffeine.newBuilder()
                .initialCapacity(100)           // Tamaño inicial
                .maximumSize(500)                // Máximo 500 entradas
                .expireAfterAccess(10, TimeUnit.MINUTES)  // Expira por falta de acceso
                .expireAfterWrite(1, TimeUnit.HOURS)      // Expira 1 hora después de escribir
                .recordStats()                   // Activar estadísticas
                .weakKeys()                       // Usar referencias débiles para las keys
                .softValues();                     // Usar referencias suaves para los values
    }
}
```

Y pensaremos: ¿Cómo se usa? se usa las mismas anotaciones con el mismo grado que se usó al inicio.
#### Monitoreo
Para activar el monitoreo es mediante el bean:
```java
@Bean
public CacheManager cacheManager(){
	CaffeineCacheManager cacheManager = new CaffeineCacheManager();
	cacheManager.setCaffeine(Caffeine.newBuilder()
		.maximumSize(10_000)
		.recordStats() // Esto activa las estadisticas
	);
	return cacheManager;
}
```
Y la manera para acceder a estas estadisticas a va a ser por medio de un componente: 

```java
@Component
public class CacheMonitor {
    
    private final CacheManager cacheManager;
    
    public CacheMonitor(CacheManager cacheManager) {
        this.cacheManager = cacheManager;
    }
    
    @Scheduled(fixedDelay = 60000) // Cada minuto
    public void reportarEstadisticas() {
        Cache cache = cacheManager.getCache("usuarios");
        if (cache != null) {
            Object nativeCache = cache.getNativeCache();
            if (nativeCache instanceof com.github.benmanes.caffeine.cache.Cache) {
                com.github.benmanes.caffeine.cache.Cache caffeineCache = 
                    (com.github.benmanes.caffeine.cache.Cache) nativeCache;
                
                CacheStats stats = caffeineCache.stats();
                System.out.println("=== Estadísticas de caché 'usuarios' ===");
                System.out.println("Solicitudes totales: " + stats.requestCount());
                System.out.println("Aciertos (hit): " + stats.hitCount());
                System.out.println("Fallos (miss): " + stats.missCount());
                System.out.println("Tasa de aciertos: " + stats.hitRate());
                System.out.println("Tiempo promedio carga (ns): " + stats.averageLoadPenalty());
            }
        }
    }
}
```

Podríamos aqui indexar un archivo de logs o usar `new relic` o algún tipo de forma que pueda generarnos trazabilidad.
### Redis
Con Redis pasa algo muy similar y es la magia de las interfaces, debemos colocar la dependencia: 
```xml
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

Spring usa Lettuce como cliente Redis, antes usaba Jedis, solo que Lettuce es reactivo y no bloqueante.

Ahora habilitamos el caché con `@EnableCaching` y luego se vienen las configuraciones: 
```properties
# Tipo de caché
spring.cache.type=redis

# Conexión a Redis
spring.redis.host=localhost
spring.redis.port=6379
# spring.redis.password=tu-contraseña  # si tienes contraseña
# spring.redis.ssl.enabled=true         # si usas SSL

# Configuración de TTL global para la caché (opcional)
spring.cache.redis.time-to-live=600000  # 10 minutos en milisegundos

# Si quieres permitir valores null en caché (por defecto true)
spring.cache.redis.cache-null-values=false

# Usar prefijos en las keys de Redis (recomendado)
spring.cache.redis.use-key-prefix=true
spring.cache.redis.key-prefix=mi-app:
```

Y para hacerlo por medio de código: 

```java
@Configuration
@EnableCaching
public class RedisCacheConfig {

    @Bean
    public RedisCacheManager cacheManager(RedisConnectionFactory connectionFactory) {
        // Configuración por defecto para todas las cachés
        RedisCacheConfiguration defaultCacheConfig = RedisCacheConfiguration.defaultCacheConfig()
                // Formato de las keys: prefijo::nombre
                .computePrefixWith(cacheName -> "mi-app:" + cacheName + ":")
                // TTL por defecto: 10 minutos
                .entryTtl(Duration.ofMinutes(10))
                // No cachear valores null
                .disableCachingNullValues()
                // Serializar valores como JSON
                .serializeValuesWith(
                        RedisSerializationContext.SerializationPair.fromSerializer(
                                new GenericJackson2JsonRedisSerializer()
                        )
                );

        // Configuraciones específicas para cachés concretas
        Map<String, RedisCacheConfiguration> cacheConfigurations = new HashMap<>();
        
        cacheConfigurations.put("usuarios", RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofHours(1))  // Usuarios: 1 hora
                .disableCachingNullValues());
        
        cacheConfigurations.put("productos", RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofMinutes(30))  // Productos: 30 minutos
                .disableCachingNullValues());

        return RedisCacheManager.builder(connectionFactory)
                .cacheDefaults(defaultCacheConfig)
                .withInitialCacheConfigurations(cacheConfigurations)
                .transactionAware()  // Integración con transacciones Spring
                .build();
    }
}
```

**Detalles importantes de la configuración** [](https://tsecurity.de/de/2671036/IT+Programmierung/Caching+in+Spring+Boot+with+Redis/de/17/IT+Betriebssysteme/Android+Tipps/)[](https://multidev.redis.io/learn/develop/java/redis-and-spring-course/lesson_9):

- **Serialización**: Por defecto Redis guarda bytes. Con `GenericJackson2JsonRedisSerializer` guardas como JSON, legible y compatible [ref](https://tsecurity.de/de/2671036/IT+Programmierung/Caching+in+Spring+Boot+with+Redis/de/17/IT+Betriebssysteme/Android+Tipps/)
- **TTL (Time-To-Live)** : Define cuánto tiempo vive cada entrada antes de expirar automáticamente [ref](https://multidev.redis.io/learn/develop/java/redis-and-spring-course/lesson_9)
- **Prefijos**: Ayudan a organizar las keys en Redis y evitar colisiones [ref](https://multidev.redis.io/learn/develop/java/redis-and-spring-course/lesson_9)

Lo que debemos hacer es levantar redis y tenerlo en la misma maquina, que pueda acceder, ya sea con Docker o manualmente.

El Caching funciona totalmente igual.

# Eventos En Spring Boot

## Fundamentos: 

Vamos a hablar de lo que es el patrón observer y la implementación en spring boot. El patrón observer es el más común a la hora de hablar en relación de eventos, ya que reparte de manera secuencial un evento. Viendo el diseño de las clases del patrón tenemos: 

![[Pasted image 20260312102838.png]]

Aqui observamos la necesidad de un publicador un suscriptor y suscriptores específicos. El hacerlo manual hace que podamos manejar diferentes publicadores y suscriptores, aunque esto haga más tedioso o complicado debido a modularidad. 
Para hacerlo de forma sencilla creamos estas clases: 

```java
public interface EventApplication {  
}
```

Luego heredamos el evento: 
```java
public record SaveBookEvent(String email, String subject, String body) implements EventApplication {  
}
```
Ahora vamos a crear el Subscriptor: 
```java
public interface Subscriber {  
    void update(EventApplication app);  
}
```

Este hará algo con el evento que quiera.
Y el publicador: 
```java
@Component  
public class PublisherEmail {  
  
    private final List<Subscriber> subscribers;  
  
    public PublisherEmail() {  
        this.subscribers = new ArrayList<>();  
    }  
  
    public void subscribe(Subscriber subscriber) {  
        subscribers.add(subscriber);  
    }  
  
    public void unsubscribe(Subscriber subscriber) {  
        subscribers.remove(subscriber);  
    }  
  
    public void notify(EventApplication event) {  
        for (Subscriber subscriber : subscribers) {  
            subscriber.update(event);  
        }  
    }  
}
```

Con esto damos paso a que se puedan suscribir cualquier tipo de servicio a un determinado evento:
```java
@Service  
@Qualifier("sendEmail")  
public class SendEmail implements Subscriber {  
  
  
    public void sendEmail(String email, String subject, String body) {  
        System.out.println("Sending email to: " + email);  
        System.out.println("Subject: " + subject);  
        System.out.println("Body: " + body);  
    }  
  
  
    @Override  
    public void update(EventApplication app) {  
        if (app instanceof SaveBookEvent emailEvent) {  
            sendEmail(emailEvent.email(), emailEvent.subject(), emailEvent.body());  
        }  
    }  
}
```

Aqui implementamos un update que recive el evento querido, y en la configuración:
```java
@Configuration  
public class AppConfig {    
    @Bean  
    public PublisherEmail publisherEmail(  
            @Qualifier("sendEmail") Subscriber subscriber  
    ) {  
        var publisherEmail = new PublisherEmail();  
        publisherEmail.subscribe(subscriber);  
        return publisherEmail;  
    }  

}
```

De esta forma suscribimos a quien sea a nuestro publicador.

Esta es la forma más rudimentaria podríamos mejorarla, como por ejemplo evitando usar `instanceof` y manejar un genérico en el `subscriber` , o agregar un mapa de eventos y sus suscriptores en el `EventPublisher` que pondríamos como publicador genérico en vez del nuestro. Con eso ganamos desacoplamiento, como ejemplo de código: 
```java
@Component
public class EventPublisher {

    private final Map<Class<?>, List<Subscriber<?>>> subscribers = new HashMap<>();

    public <T extends EventApplication> void subscribe(Class<T> type, Subscriber<T> subscriber) {
        subscribers.computeIfAbsent(type, k -> new ArrayList<>()).add(subscriber);
    }

    @SuppressWarnings("unchecked")
    public <T extends EventApplication> void publish(T event) {
        List<Subscriber<?>> subs = subscribers.getOrDefault(event.getClass(), List.of());

        for (Subscriber<?> sub : subs) {
            ((Subscriber<T>) sub).update(event);
        }
    }
}
```

Pero como veníamos viendo existe una alternativa ya de Spring Boot que es `ApplicationEventPublisher`.

### AplicationEventPublisher

Esta es una interfaz de Spring para publicar eventos dentro del contenedor de la aplicación. Forma parte del sistema de Spring Events, que implementa un mecanismo interno de Observer / Pub-Sub.

La idea es desacoplar componentes: Un objeto publica un evento y cualquier otro componente puede escucharlo sin que ambos coexistan entre sí.

Para implementarlo vamos a inyectar esta clase: 
```java
@Service  
public class BookServiceImpl implements BookService {  
  
    private final BookRepository bookRepository;  
    private final ApplicationEventPublisher applicationEventPublisher;  
  
    public BookServiceImpl(BookRepository bookRepository, ApplicationEventPublisher applicationEventPublisher) {  
        this.bookRepository = bookRepository;  
        this.applicationEventPublisher = applicationEventPublisher;  
    }  
  
    @Cacheable("books")  
    public List<BookEntity> findAll() throws InterruptedException {  
        return bookRepository.findAll();  
    }  
  
    public void save(BookEntity book) {  
        bookRepository.save(book);  
        applicationEventPublisher.publishEvent(  
                new SaveBookEvent(  
                        "junior@gmail.com",  
                        "Book Saved",  
                        "A new book with title '" + book.getTitle() + "' was saved to the repository."  
                )  
        );  
    }  
}
```
Aquí como vemos ya no usamos nuestro publicador, con esto también ayudamos a que tenga más sentido este publicador.
Ahora vamos a nuestro servicio de email: 
```java
@Service  
public class SendEmail{  
  
    public void sendEmail(String email, String subject, String body) {  
        System.out.println("Sending email to: " + email);  
        System.out.println("Subject: " + subject);  
        System.out.println("Body: " + body);  
    }  
}
```

Por ahora así quedaría (que igualmente en nuestro propio publicador de eventos podiamos hacer). Y crearemos una clase nueva que será nuestro centralizador de los eventos: 
```java
@Component  
public class BookEvents {  
  
    public final SendEmail sendEmail;  
  
    public BookEvents(SendEmail sendEmail) {  
        this.sendEmail = sendEmail;  
    }  
  
    @EventListener  
    public void userCreatedHandleMail(SaveBookEvent event) {  
        sendEmail.sendEmail(event.email(), event.subject(), event.body());  
    }  
  
}
```

Y cuando corremos nuestro servidor y enviamos el contenido correspondiente: 
![[Pasted image 20260312121200.png]]

En nuestro lloger observamos lo siguiente:
```bash
2026-03-12 12:06:24.663 [main] INFO  o.a.coyote.http11.Http11NioProtocol - Initializing ProtocolHandler ["http-nio-8080"]
2026-03-12 12:06:24.664 [main] INFO  o.a.catalina.core.StandardService - Starting service [Tomcat]
2026-03-12 12:06:24.664 [main] INFO  o.a.catalina.core.StandardEngine - Starting Servlet engine: [Apache Tomcat/11.0.18]
2026-03-12 12:06:24.687 [main] INFO  o.s.b.w.c.s.WebApplicationContextInitializer - Root WebApplicationContext: initialization completed in 632 ms
2026-03-12 12:06:25.193 [main] INFO  o.a.coyote.http11.Http11NioProtocol - Starting ProtocolHandler ["http-nio-8080"]
2026-03-12 12:06:25.200 [main] INFO  o.s.boot.tomcat.TomcatWebServer - Tomcat started on port 8080 (http) with context path '/'
2026-03-12 12:06:25.205 [main] INFO  com.cache.CacheApplication - Started CacheApplication in 1.489 seconds (process running for 1.824)
2026-03-12 12:06:30.564 [http-nio-8080-exec-1] INFO  o.a.c.c.C.[Tomcat].[localhost].[/] - Initializing Spring DispatcherServlet 'dispatcherServlet'
2026-03-12 12:06:30.564 [http-nio-8080-exec-1] INFO  o.s.web.servlet.DispatcherServlet - Initializing Servlet 'dispatcherServlet'
2026-03-12 12:06:30.565 [http-nio-8080-exec-1] INFO  o.s.web.servlet.DispatcherServlet - Completed initialization in 1 ms
Sending email to: junior@gmail.com
Subject: Book Saved
Body: A new book with title 'null' was saved to the repository.
```

Aquí vemos que en efecto el evento se publicó, y podemos seguir añadiendo eventos de esta forma, luego veremos una arquitectura completa orientada a esto. Aún podemos seguir viendo cosas que son interesantes. 

Vamos a añadir un `@Transactional` entonces: 
```java
public Class BookServiceImpl implements BookService {

...

@Transactional  
public void save(BookEntity book) {  
    bookRepository.save(book);  
      
    applicationEventPublisher.publishEvent(  
            new SaveBookEvent(  
                    "junior@gmail.com",  
                    "Book Saved",  
                    "A new book with title '" + book.getTitle() + "' was saved to the repository."  
            )  
    );  
}

}
```
Vamos a probar con dos ideas, la primera es esta, y usaremos en nuestros eventos, enriqueciéndola de la siguiente forma: 
```java
@Component  
public class BookEvents {  
    public static final Logger log = LoggerFactory.getLogger(BookEvents.class.getName());  
    public final SendEmail sendEmail;  
  
    public BookEvents(SendEmail sendEmail) {  
        this.sendEmail = sendEmail;  
    }  
  
    @EventListener  
    public void userCreatedHandleMail(SaveBookEvent event) {  
        sendEmail.sendEmail(event.email(), event.subject(), event.body());  
    }  
  
    @TransactionalEventListener  
    public void afterCommit(SaveBookEvent event) {  
        log.info("After commit of event: {} ", event);  
    }  
  
}
```

Para terminar configuraremos H2 DataBase para que exista la transacción. Luego de ser configurada (que debe ser trivial para el lector) Observaremos esto: 
```bash
2026-03-12 12:35:26.978 [http-nio-8080-exec-1] INFO  o.s.web.servlet.DispatcherServlet - Completed initialization in 1 ms
Sending email to: junior@gmail.com
Subject: Book Saved
Body: A new book with title 'El viento nos robo la vida' was saved to the repository.
2026-03-12 12:35:27.129 [http-nio-8080-exec-1] INFO  com.cache.events.BookEvents - After commit of event: SaveBookEvent[email=junior@gmail.com, subject=Book Saved, body=A new book with title 'El viento nos robo la vida' was saved to the repository.] 

```
Como observamos se ejecuta el `afterCommit` ahora, y ¿si falla?, observemos que sucede: 
```java
@Component  
public class BookEvents {  
    public static final Logger log = LoggerFactory.getLogger(BookEvents.class.getName());  
    public final SendEmail sendEmail;  
  
    public BookEvents(SendEmail sendEmail) {  
        this.sendEmail = sendEmail;  
    }  
  
    @EventListener  
    public void userCreatedHandleMail(SaveBookEvent event) {  
        sendEmail.sendEmail(event.email(), event.subject(), event.body());  
    }  
  
    @TransactionalEventListener  
    public void afterCommit(SaveBookEvent event) {  
        log.info("After commit of event: {} ", event);  
    }  
  
}
```

2. Eventos síncronos vs asíncronos (@Async + @EnableAsync)
3. Orden de ejecución con @Order
## Tipos de eventos
6. Eventos simples (POJOs)
    
7. Eventos que extienden ApplicationEvent (legado)
    
8. Eventos genéricos y type erasure (ResolvableType)
    
9. Múltiples eventos en un mismo listener
    
10. Listeners con retorno (generan nuevos eventos)
## Control avanzado
11. @TransactionalEventListener y sus fases (BEFORE_COMMIT, AFTER_COMMIT, AFTER_ROLLBACK)
    
12. Condition con SpEL en @EventListener(condition = "...")
    
13. Manejo de excepciones en listeners (ErrorHandler)
    
14. Eventos con prioridad y orden
    
15. Propagación de eventos en jerarquías de ApplicationContext
## Arquitectura y Diseño
16. Estrategias de naming y organización de eventos
    
17. Eventos por dominio vs eventos genéricos (DDD)
    
18. Event versionado y compatibilidad hacia atrás
    
19. Payload mínimo vs payload completo
    
20. Eventos como contrato entre módulos/bounded contexts
## Integración y performance
21. Eventos y transacciones (rollback, consistencia)
    
22. Thread pooling para @Async eventos (custom Executor)
    
23. Monitoreo: métricas de latencia y throughput
    
24. Debugging: trace de eventos con logs
    
25. Testing: @SpringBootTest con @MockBean de listeners

## Escalabilidad
26. Eventos en memoria vs eventos con broker externo (RabbitMQ, Kafka)
    
27. Bridge entre ApplicationEvent y mensajes JMS
    
28. Event replay y event sourcing
    
29. Eventos distribuidos vs locales
    
30. Patrones: Saga, CQRS y Event-Driven Architecture con Spring

# Security context en Spring Boot

# Bibliografía: 
- [Spring Cloud Video](https://www.youtube.com/watch?v=EWqAY_-R57A)
- [Spring Cloud Documentación](https://spring.io/cloud)
- [Spring Cloud curso](https://www.youtube.com/watch?v=U_rPO2ILMFU&list=PLxy6jHplP3Hi_W8iuYSbAeeMfaTZt49PW&index=2)
- 