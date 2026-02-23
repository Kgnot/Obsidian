---
type: course
status: en_progreso
tags:
  - course
date_started: 2024-05-20
---

# MyBatis:

MyBatis es un _framework_ de persistencia muy popular que permite un gran control sobre el SQL. A diferencia de ORM (Mapeo Objeto-Relacional) como Hibernate, que abstraen completamente la base de datos, MyBatis te da la libertad de escribir tus propias consultas SQL, lo que es una ventaja clave para la **optimización del rendimiento** y la **eficacia**.
## Manejo de sentencias SQL

MyBatis separa el código SQL de la lógica de negocio, lo que permite una **mejor mantenibilidad** y **rendimiento**. A diferencia de los ORMs que generan SQL automáticamente, MyBatis ejecuta el SQL que tú escribes, el cual es generalmente más eficiente para consultas complejas o de alto volumen. Esto evita problemas como las N+1 queries o el uso de _joins_ innecesarios que pueden afectar el rendimiento.

- **Evita las consultas anidadas (Nested Selects):** Aunque MyBatis permite `nested selects` (consultas anidadas en los _result maps_), estas pueden generar problemas de rendimiento ya que Mybatis ejecuta una consulta por cada fila de la consulta principal. Es más eficiente usar _joins_ en una única consulta para obtener todos los datos y luego mapear los resultados con `nested result mappings`.
    
- **SQL dinámico:** MyBatis ofrece un potente motor de SQL dinámico que te permite construir consultas condicionales de forma elegante usando etiquetas XML como `<if>`, `<choose>`, `<when>`, `<otherwise>`, `<where>`, `<foreach>`, entre otras. Esto evita la necesidad de concatenar cadenas para construir consultas en Java, lo cual es menos seguro y propenso a errores.
## Caché

MyBatis tiene dos niveles de caché para mejorar el rendimiento, especialmente en escenarios de solo lectura.

- **Caché de primer nivel (L1):** Es la caché por defecto y está ligada a la `SqlSession`. Al abrir una `SqlSession`, Mybatis la crea y almacena los resultados de las consultas. Si se realiza la misma consulta dentro de la misma sesión, MyBatis devuelve el resultado desde el caché en lugar de ir a la base de datos. Esta caché se borra cuando la `SqlSession` se cierra, se vacía o se realiza una operación de modificación (insert, update, delete).
- **Caché de segundo nivel (L2):** Es una caché a nivel global, compartida entre todas las `SqlSession` del mismo _namespace_ del _mapper_. Para activarla, necesitas configurarla explícitamente en el archivo XML del _mapper_ con la etiqueta `<cache>`. Esta caché es muy útil para datos que cambian poco y son accedidos con frecuencia. Puedes configurarla con políticas de expiración, de remoción (LRU, FIFO, etc.) y otras características.
## Técnicas avanzadas y configuraciones especiales

- **`fetchSize`:** Este es un parámetro clave para la optimización. Por defecto, MyBatis carga todos los resultados en memoria. Si las consultas devuelven un gran número de registros, esto puede consumir mucha memoria y tiempo. El parámetro **`fetchSize`** en la configuración te permite decirle al _driver_ JDBC cuántas filas debe traer en cada ronda de comunicación con la base de datos, lo cual es ideal para procesar grandes cantidades de datos.
- **`resultMap`:** Aunque el mapeo automático (`autoMapping`) puede ser conveniente, el uso de `<resultMap>` con mapeos explícitos (`<id>`, `<result>`) es más rápido y seguro. Además, te permite controlar mejor el mapeo de los datos, manejar resultados anidados (`<association>`, `<collection>`) y mapear nombres de columnas diferentes a los de las propiedades de la clase Java.
- **Batching (Procesamiento por lotes):** Para operaciones masivas como inserciones o actualizaciones, el _batching_ es indispensable. En lugar de enviar cada sentencia a la base de datos de forma individual, puedes agrupar varias y enviarlas en un solo paquete. Esto reduce el número de viajes de ida y vuelta a la base de datos, mejorando drásticamente el rendimiento.
## Menos comunes

- **Interceptores (Plugins):** MyBatis permite la creación de _plugins_ (interceptores) que pueden interceptar llamadas a los métodos principales como `Executor`, `StatementHandler`, `ParameterHandler` y `ResultSetHandler`. Esta es una herramienta extremadamente poderosa para implementar funcionalidades transversales como el registro de consultas, la auditoría, la encriptación de campos, o la prevención de actualizaciones completas de tablas.
    
- **`autoMappingBehavior`:** Este ajuste en la configuración de MyBatis controla cómo se realiza el mapeo automático de las columnas. Los valores posibles son `NONE`, `PARTIAL` y `FULL`. Ajustarlo a `PARTIAL` o `NONE` cuando tienes `result maps` explícitos puede prevenir comportamientos inesperados y a veces mejorar el rendimiento, ya que MyBatis no intentará mapear columnas de forma automática, sino que se basará únicamente en lo que has definido.
    
- **`returnInstanceForEmptyRow`:** Normalmente, si todas las columnas de una fila son nulas, MyBatis devuelve `null`. Sin embargo, puedes configurar este ajuste a `true` para que devuelva una instancia vacía de la clase. Esto puede ser útil para ciertos escenarios, aunque debe usarse con precaución, ya que puede tener un impacto en la memoria si se usa en consultas con muchos registros nulos.

## Ejemplos de programación : 

Primero que nada para empezar podemos encontrar la documentación aqui: 
https://mybatis.org/mybatis-3/es/getting-started.html
Debemos agregar la dependencia ya sea de maven o gradle.

Y seguimos los pasos que ahí nos dicen, podemos crear una clase: 
```java
package org.server.config;  
  
import org.apache.ibatis.io.Resources;  
import org.apache.ibatis.session.SqlSessionFactory;  
import org.apache.ibatis.session.SqlSessionFactoryBuilder;  
  
import java.io.IOException;  
import java.io.InputStream;  
import java.util.Properties;  
  
public class MyBatisUtil {  
  
    private final static SqlSessionFactory sessionFactory;  
  
    static {  
        try {  
            String resource = "db/mybatis-config.xml";  
            InputStream inputStream = Resources.getResourceAsStream(resource);  
            Properties props = new Properties();  
            try (InputStream propStream = Resources.getResourceAsStream("db/database.properties")) {  
                props.load(propStream);  
            }            sessionFactory = new SqlSessionFactoryBuilder().build(inputStream, props);  
        } catch (IOException e) {  
            throw new RuntimeException("Error en Mybatis: " + e.getMessage());  
        }    }  
    public static SqlSessionFactory getSessionFactory() {  
        return sessionFactory;  
    }  
  
}
```
En esta clase pasamos dos configuraciones, la de `mybatis-config.xml` y las propiedades, luego ahí instanciamos lo que es el `sessionFactory`. Pero ¿Cómo se ven el XML?: 
```xml
<?xml version="1.0" encoding="UTF-8" ?>  
<!DOCTYPE configuration  
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"  
        "https://mybatis.org/dtd/mybatis-3-config.dtd">  
<configuration>  
    <environments default="development">  
        <environment id="development">  
            <transactionManager type="JDBC"/>  
            <dataSource type="POOLED">  
                <property name="driver" value="${driver}"/>  
                <property name="url" value="${url}"/>  
                <property name="username" value="${username}"/>  
                <property name="password" value="${password}"/>  
            </dataSource>  
        </environment>  
    </environments>  
    <mappers>  
        <mapper resource="mapper/UsersMapper.xml"/>  
    </mappers>  
</configuration>
```
Aqui observamos lo que son el medio ambiente el manejador de transacciones, el tipo de `dataSource` y sus respectivas propiedades.
Luego vemos lo que son los `mappers` y que apunta a uno llamado `UsersMapper.xml` este se ve:
```xml
<!DOCTYPE mapper  
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"  
        "https://mybatis.org/dtd/mybatis-3-mapper.dtd">  
  
<mapper namespace="org.server.spec.UsersMapper">  
    <select id="findAll" resultType="org.server.entity.Users">  
        select  
        user_id,  
        username,  
        password_hash  
        from users  
    </select>  
</mapper>
```
En este apartado vemos como se mapea y se llama por medio del `namespace` a la clase que hace referencia, en este caso `UsersMapper`, y el `restulType` decimos cuál es el resultado que estamos esperando ante cuál método que mandamos por `id`, ahora veremos esas clases: 
```java
public interface UsersMapper {  
  
    List<Users> findAll();  
  
    @Select("SELECT  * from users where user_id = #{id}")  
    Users getUserById(int id);  
}

public record Users(  
        int user_id,  
        String username,  
        String password_hash  
) {  
  
  
}
```
`UsersMapper` es una interfaz sencilla, luego sé instancia; y `Users` es una clase POJO que solo sirve para mapearlo, es el modelo.

¿Cómo buscamos?, usamos un service, por ejemplo: 
```java
public class UserService {  
  
    public List<Users> findAll() {  
        try (SqlSession session = MyBatisUtil.getSessionFactory().openSession()) {  
            UsersMapper mapper = session.getMapper(UsersMapper.class);  
            return mapper.findAll();  
        }  
    }  
  
    public Users findById(int id) {  
        try (SqlSession session = MyBatisUtil.getSessionFactory().openSession()) {  
            UsersMapper mapper = session.getMapper(UsersMapper.class);  
            return mapper.getUserById(id);  
        }  
    }  
}
```
Aqui vemos que generamos la `session` que es la sesión de nuestra base de datos, hace la búsqueda y luego se desconecta. Aqui es donde instanciamos el mapper y retornamos lo que el mapper nos da, e instanciamos eso gracias al método `getMapper`. Y su uso es sencillo como por ejemplo: 
```java
public class Main {  
  
    public static void main(String[] args) throws IOException {  
        UserService userService = new UserService();  
        List<Users> users = userService.findAll();  
  
        users.forEach(System.out::println);  
  
        Users usId = userService.findById(2);  
        System.out.println("User_ ID: " + usId);  
    }  
}
```
Algo que no dije, es que se puede usar: `@Select("SELECT  * from users where user_id = #{id}")` para omitir la configuración XML. Algo importante es siempre usar `namespaces` en los `mappers` de XML, así no habrán errores de ambigüedad.