---
type: course
status: en_progreso
tags: [course, InfluxDB]
date_started: 2024-05-20
---

Vamos a empezar con la documentación de ello, aunque primero un video introductorio
# Introducción
InfluxDB es una base de datos orientada a series temporales, diseñada para almacenar, consultar y analizar datos que cambian a lo largo del tiempo con alta frecuencia. Es común en casos donde cada dato tiene una marca temporal asociada. 
## ¿Para qué se usa?
Principalmente en:
- Monitoreo de infraestructura (CPU, memoria, disco, red)
- IoT y sensores
- Métricas de aplicaciones
- Observabilidad (metrics, events)
- Datos financieros en tiempo real
## Arquitectura y versiones
- **InfluxDB OSS**: versión open source, desplegable on-premise.
- **InfluxDB Cloud**: servicio gestionado en la nube.
- **InfluxDB 2.x**: unifica API, autenticación, dashboards y Flux.
- **InfluxDB 3.x**: arquitectura rediseñada (motor columnar, mejor rendimiento analítico, SQL).

# Get Started
InfluxDB 3 Core server contiene bases de datos lógicas; las bases de datos contienen lógica, y las tablas están relacionada con columnas.

InfluxDB 3 usa una estructura más cercana a una base de datos analítica: 
- Servidor:
	- Database -> equivale a:
		- Un bucket en InfluxDB 2
		- un db + retention policy en InfluxDB1
	- Table -> Equivalente a una `measurement`
	- Columnas -> columnas tipadas (no "points" como antes)
Básicamente: 
Database -> Tables -> Columns

Tenemos tipos de columnas, cada columna puede representar: 
- Time: Una columna de tiempo (nanosegundos)
- Tags indexados:
	- `String dictionary`
- Fields (No indexados):
	- `int64`
	- `float64`
	- `uint64`
	- `bool`
	- `string`
Esto reemplaza el modelo clásico de `measurement + tags + fields`, pero conceptualmente sigue siendo lo mismo.

En influxDB 3, cada tabla tiene una clave primaria formada por: 
> (Tags ordenados) + time

Esto significa: 
- Cada fila está identificada de forma única por
	- El conjunto de tags
	- El timestamp
- Los datos se ordenen físicamente en disco usando esa clave
- El orden afecta directamente al rendimiento de consultas

Y el orden de los tags. Cuando se crea una tabla (explícitamente o al escribir datos por primera vez):
- El orden de los tags queda fijado
- Ese orden:
	- Define la clave primaria
	- no puede cambiarse después
- InfluxDB es _schema-on-write_, pero el esquema de tags es **inmutable**.
***
Si no sabes muy bien por qué comparan con pasados pensemos en lo siguiente:

La idea central de InfluxDB está pensada para modelar eventos que ocurren en el tiempo, es decir: 
- Qué pasó
- cuándo pasó
- a quién/ a qué le pasó
- qué valores se midieron
La pregunta base es: ¿Cómo identifico una serie de datos a lo largo del tiempo?

La unidad fundamental es la serie temporal. Una serie temporal es una secuencia de valores, ordenados por tiempo, que describen _la misma cosa_.
Ejemplo: 
- Temperatura del sensor 123
- Uso de CPU del host A
- Latencia del endpoint/login

El rol del tiempo en InfluxDB tiene las siguientes características: 
- Todas las filas tienen tiempo
- El tiempo NO es un atributo más
- El tiempo ordena y defino los datos
Aquí se puede ver como `(time, identidad_de_la_serie) -> Valores`. El tiempo siempre forma parte de la identidad del dato

## TAGS: 
Aquí está el equivalente conceptual a las claves en SQL. 
Un tag podría decirse que es la identidad de la serie. Pues lo tags:
- Identifican qué cosa estás midiendo
- Son comparables a: 
	- claves naturales
	- columnas usadas para `group by`
	- columnas indexadas
## Fields: 
Los fields son valores que cambian, no identifican y no crean series nuevas, tal como ==la temperatura, humedad, latencia y cpu_usage==

Haciendo las comparaciones, los tags son a las columnas que identifican la fila y los fields son a las columnas de los datos.

***
## InfluxDB 3
Ahora si lo que hace influxDB 3 es formalizar todo de manera un poco mas "SQL-like"
¿Entonces qué hace?:
- Usa tablas reales
- Usa columnas tipadas
- Usa parquet (columnar)
- Define una clave primaria clara

|InfluxDB 3|Equivalente mental|
|---|---|
|Database|Base de datos|
|Table|Tabla|
|Tag|Columna indexada que identifica|
|Field|Columna de datos|
|Time|Parte obligatoria de la PK|
|Primary key|(tags..., time)|
# Instalar InfluxDB 3 Core

La instalación se puede obtener de aqui: 
https://docs.influxdata.com/influxdb3/core/install/
Y en docker con ` sudo docker pull influxdb:3-core `. Y en Docker Hub tenemos el siguiente comando para iniciar: 
```cmd
docker run --rm influxdb:3-core influxdb3 serve --help
```
Sin embargo el comando minimo es: 
```bash
docker run -d \
  --name influxdb3 \
  -p 8181:8181 \
  -v influxdb3-data:/var/lib/influxdb3 \
  -e INFLUXDB3_AUTH_TOKEN=zmQaymleE2IQFIdutkEHWJ94GMYTdUs3pYiwsyOvuJATCS6sUrOzF9p2PbaRvuiq \
  quay.io/influxdb/influxdb3-core:latest \
  serve --node-id node1
```
En la documentación nos comenta que podemos hacer lo siguiente: 
![Pasted image 20260103110452.png](images/Pasted%20image%2020260103110452.png)
Después de eso nos dice que realizamos el siguiente comando: 
```bash
export INFLUXDB3_AUTH_TOKEN=YOUR_AUTH_TOKEN
```
y en `YOUR_AUTH_TOKEN` poner el que obtuvimos en el paso anterior, es decir: 
![Pasted image 20260103111555.png](images/Pasted%20image%2020260103111555.png)
Luego algo que debemos de tomar en cuenta es que ahora, para cada petición que se realice debe ser de la siguiente forma: 
```bash
curl "http://localhost:8181/api/v3/configure/database" \
  --header "Authorization: Bearer YOUR_AUTH_TOKEN"
```

# Escribir datos: 

InfluxDB 3 Core está diseñado para **alta tasa de escritura** y utiliza una sintaxis de escritura **eficiente y legible por humanos** llamada _line protocol_.  
InfluxDB es una base de datos **schema-on-write**, lo que significa que puedes empezar a escribir datos y InfluxDB crea automáticamente la base de datos lógica, las tablas y sus esquemas, **sin necesidad de ninguna intervención previa**.

Una vez que InfluxDB crea el esquema, **válida las escrituras futuras contra ese esquema** antes de aceptar nuevos datos.  
Tanto **nuevos tags como nuevos fields** pueden añadirse más adelante a medida que el esquema evoluciona.
## Line Protocol: 
[referencia](https://docs.influxdata.com/influxdb3/core/reference/line-protocol/)
InfluxDB 3 Core usa line protocol para escribir puntos de datos. Este es un texto basado en un formato que provee las tablas, tag set, field set y timestamp de un punto de información.
```js
// Syntax
<table>[,<tag_key>=<tag_value>[,<tag_key>=<tag_value>]] <field_key>=<field_value>[,<field_key>=<field_value>] [<timestamp>]

// Example
myTable,tag1=value1,tag2=value2 fieldKey="fieldValue" 1556813561098000000
```
Líneas separadas por un carácter de nueva línea `\n` representa un simple punto en InfluxDB. Line protocol es sensible a espacio de línea.
![Pasted image 20260103112504.png](images/Pasted%20image%2020260103112504.png)
### Table: 

(=={red}Requerido==)El nombre de la tabla. InfluxDB acepta una tabla por punto.

### Tag set
(==Opcional==) Todos los pares clave-valor de tags del punto.
Las relaciones clave-valor se indican con el operador `=`.
Múltiples pares clave-valor se separan por comas.

Las claves de tag y los valores de tag distinguen mayúsculas y minúsculas. 
Las claves de tag estan suetas a restricciones de nombres.
Los valores de tag no pueden estar vacíos; si no hay valor, se debe omitir el tag del conjunto.

Tipo de dato de la clave: **String**.
Tipo de dato del valor: **String**.

### Field set:
(=={red}Requerido==) Todos los pares clave valor de un punto. Los puntos deben tener al menos un campo. 

Tipo de dato de la clave: **String**.
Tipo de dato del valor: **Float | Integer | UInteger | String | Boolean**

### Timestamp
(==opcional==) La marca de tiempo Unix del punto de datos. Influx DB acepta un solo timestamp por punto.
Si no se proporciona un timestamp, InfluxDB utiliza la hora del sistema (UTX) de la máquina anfitriona.

Para hacerse una pequeña idea Unix time es una forma estándar de representar el tiempo como un número
- Es el número de segundos (o milisegundos / nanosegundos) transcurridos desde el 1 de enero de 1970 00:00:00 UTC
- No depende de zonas horarias
- Es fácil de comparar, ordenar y almacenar.
Que es UTC ? es el tiempo universal de referencia
- No tiene ona horaria
- No cambia por horario de verano
- Es el estándar usado por sistemas distribuidos. 
- Es una hora absoluta

## Construcción del Line protocol
Con un entendimiento básico del line portocol, se puede ahora construir un Line protocol y escribir información en InfluxDB3. Consideremos un caso de uso donde tú coleccionas la información de sensores en tu casa. Cada sensor colecciona temperatura, humedad y monóxido de carbón. Al coleccionar esta información se usa el siguiente esquema: 
- Table: `home`
	- Tags
		- `room`: Living Room
	- Fields
		- `temp` Temperatura en Celsius (float)
		- `hum`: Porcentaje de humedad (float)
		- `co`: Monóxido de carbón en partes por millón (entero)
	- timestamp: Unix timestamp en presición de segundos

La siguiente protocol line represente la información recolectada entre **2026-01-02T08:00:00Z (UTC)** hasta **2026-01-02T20:00:00Z (UTC)**:
```
home,room=Living\ Room temp=21.1,hum=35.9,co=0i 1767340800
home,room=Kitchen temp=21.0,hum=35.9,co=0i 1767340800
home,room=Living\ Room temp=21.4,hum=35.9,co=0i 1767344400
home,room=Kitchen temp=23.0,hum=36.2,co=0i 1767344400
home,room=Living\ Room temp=21.8,hum=36.0,co=0i 1767348000
home,room=Kitchen temp=22.7,hum=36.1,co=0i 1767348000
home,room=Living\ Room temp=22.2,hum=36.0,co=0i 1767351600
home,room=Kitchen temp=22.4,hum=36.0,co=0i 1767351600
home,room=Living\ Room temp=22.2,hum=35.9,co=0i 1767355200
home,room=Kitchen temp=22.5,hum=36.0,co=0i 1767355200
home,room=Living\ Room temp=22.4,hum=36.0,co=0i 1767358800
home,room=Kitchen temp=22.8,hum=36.5,co=1i 1767358800
home,room=Living\ Room temp=22.3,hum=36.1,co=0i 1767362400
home,room=Kitchen temp=22.8,hum=36.3,co=1i 1767362400
home,room=Living\ Room temp=22.3,hum=36.1,co=1i 1767366000
home,room=Kitchen temp=22.7,hum=36.2,co=3i 1767366000
home,room=Living\ Room temp=22.4,hum=36.0,co=4i 1767369600
home,room=Kitchen temp=22.4,hum=36.0,co=7i 1767369600
home,room=Living\ Room temp=22.6,hum=35.9,co=5i 1767373200
home,room=Kitchen temp=22.7,hum=36.0,co=9i 1767373200
home,room=Living\ Room temp=22.8,hum=36.2,co=9i 1767376800
home,room=Kitchen temp=23.3,hum=36.9,co=18i 1767376800
home,room=Living\ Room temp=22.5,hum=36.3,co=14i 1767380400
home,room=Kitchen temp=23.1,hum=36.6,co=22i 1767380400
home,room=Living\ Room temp=22.2,hum=36.4,co=17i 1767384000
home,room=Kitchen temp=22.7,hum=36.5,co=26i 1767384000
```

> **Anotación:**  Como los espaciós no son permitidos, entonces usamos el `\`.


## Write Data usando el CLI: 

Para empezar rapidamente a escribir en influxdb3 usamos el comando`influxdb3 write` incluyendo li siguiente: 
- `--database` opción que identifica la base de datos objetivo
- `--token` opción que especifica el uso del token a menos que ya este en variables de entorno
Entonces un ejemplo: 
```bash
influxdb3 write \
  --database DATABASE_NAME \
  --token apiv3_Y18r_5lhrwjF6gl6o8gQ9WC0hEnCRrxvd4l6qKnWGE0KVuylG4Qlv5SAleurJ2yQp8xAEHcVxTfqURshK5gdBw \
  --precision s \
'home,room=Living\ Room temp=21.1,hum=35.9,co=0i 1641024000
home,room=Kitchen temp=21.0,hum=35.9,co=0i 1641024000
home,room=Living\ Room temp=21.4,hum=35.9,co=0i 1641027600
home,room=Kitchen temp=23.0,hum=36.2,co=0i 1641027600
home,room=Living\ Room temp=21.8,hum=36.0,co=0i 1641031200
home,room=Kitchen temp=22.7,hum=36.1,co=0i 1641031200
home,room=Living\ Room temp=22.2,hum=36.0,co=0i 1641034800
home,room=Kitchen temp=22.4,hum=36.0,co=0i 1641034800
home,room=Living\ Room temp=22.2,hum=35.9,co=0i 1641038400
home,room=Kitchen temp=22.5,hum=36.0,co=0i 1641038400
home,room=Living\ Room temp=22.4,hum=36.0,co=0i 1641042000
home,room=Kitchen temp=22.8,hum=36.5,co=1i 1641042000
home,room=Living\ Room temp=22.3,hum=36.1,co=0i 1641045600
home,room=Kitchen temp=22.8,hum=36.3,co=1i 1641045600
home,room=Living\ Room temp=22.3,hum=36.1,co=1i 1641049200
home,room=Kitchen temp=22.7,hum=36.2,co=3i 1641049200
home,room=Living\ Room temp=22.4,hum=36.0,co=4i 1641052800
home,room=Kitchen temp=22.4,hum=36.0,co=7i 1641052800
home,room=Living\ Room temp=22.6,hum=35.9,co=5i 1641056400
home,room=Kitchen temp=22.7,hum=36.0,co=9i 1641056400
home,room=Living\ Room temp=22.8,hum=36.2,co=9i 1641060000
home,room=Kitchen temp=23.3,hum=36.9,co=18i 1641060000
home,room=Living\ Room temp=22.5,hum=36.3,co=14i 1641063600
home,room=Kitchen temp=23.1,hum=36.6,co=22i 1641063600
home,room=Living\ Room temp=22.2,hum=36.4,co=17i 1641067200
home,room=Kitchen temp=22.7,hum=36.5,co=26i 1641067200'
```
Para inspeccionar lo que hemos hecho: 
```bash
influxdb3 show databases --token apiv3_Y18r_5lhrwjF6gl6o8gQ9WC0hEnCRrxvd4l6qKnWGE0KVuylG4Qlv5SAleurJ2yQp8xAEHcVxTfqURshK5gdBw
```
Eso nos muestra: 
![Pasted image 20260103124456.png](images/Pasted%20image%2020260103124456.png)
Ahora entramos a `DATABASE_NAME` porque sin culpa así lo llamamos jeje. 
Ejecutamos: 
```bash
influxdb3 query \
--database DATABASE_NAME \
--token apiv3_Y18r_5lhrwjF6gl6o8gQ9WC0hEnCRrxvd4l6qKnWGE0KVuylG4Qlv5SAleurJ2yQp8xAEHcVxTfqURshK5gdBw \
"SHOW TABLES"
```
Eso nos genera:
![Pasted image 20260103124750.png](images/Pasted%20image%2020260103124750.png)
Con ello miramos y tenemos la `table_schema` con el nombre de `home` que era el que se creo, como bien recordamos:
```bash
home,room=Kitchen temp=21.0,hum=35.9,co=0i 1641024000
```
Ahora ejecutamos:
```bash
influxdb3 query \
--database DATABASE_NAME
--token apiv3_Y18r_5lhrwjF6gl6o8gQ9WC0hEnCRrxvd4l6qKnWGE0KVuylG4Qlv5SAleurJ2yQp8xAEHcVxTfqURshK5gdBw
"SELECT * FROM home ORDER BY time"
```
Eso nos genera: 
![Pasted image 20260103124950.png](images/Pasted%20image%2020260103124950.png)
Entonces, podemos observar por orden de tiempo una serie de datos temporal.
***
Todo esto ha sido realizado desde el CLI, pero hay otras maneras de escribir datos, en la documentacións nos menciona 3 formas diferentes: 
- [InfluxDB HTTP API](https://docs.influxdata.com/influxdb3/core/write-data/http-api/): Recommended for batching and higher-volume write workloads.
- [InfluxDB client libraries](https://docs.influxdata.com/influxdb3/core/write-data/client-libraries/): Client libraries that integrate with your code to construct data as time series points and write the data as line protocol to your InfluxDB 3 Core database.
- [Telegraf](https://docs.influxdata.com/telegraf/v1/): A data collection agent with over 300 plugins for collecting, processing, and writing data.

| Herramienta               | Descripción                                                                                                       |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| InfluxDB HTTP API         | Recomendado para escrituras en lote (batching) y cargas de escritura altas                                        |
| InfluxDB client libraries | Librerías que se integran en tu código para construir series temporales y escribir datos en formato line protocol |
| Telegraf                  | Agente de recolección de datos con más de 300 plugins para recolectar, procesar y escribir datos en InfluxDB      |
# Consultar datos:
InfluxDB3 Core soporta tanto SQL nativo como InfluxQL para buscar información o datos. InfluxQL es un SQL-like query language diseñado para InfluxDBv1 y customizado para consultas de tiempo de series.

InfluxDB3 Core limita las búsquedas a 72 horas para asegurar mejor rendimiento, para más información acerca de esta limitación se puede ingresar a: [update on InfluxDB 3 Core’s 72-hour limitation](https://www.influxdata.com/blog/influxdb3-open-source-public-alpha-jan-27/).

> Flux, lenguaje introducido en InfluxDB v2 no esta soportado en InfluxDB3

## Query data con influxdb3 CLI 
Dentro de la documentación : [Documento de Query](https://docs.influxdata.com/influxdb3/core/get-started/query/?dl=oss3&code_lang=bash&code_lines=4&has_placeholders=true&code_type=code&section=Example%253A%2520Query%2520passing%2520URL-encoded%2520parameters&first_line=curl%2520-G%2520%2522http%253A%252F%252Flocalhost%253A8181%252Fapi%252Fv3%252Fquery_sql%2522%2520%255C)
Nos especifica bastante bien sobre los tipos de query, pero algo que es importante es el cómo debería verse una query, y tecnicamente sería: 
```bash
influxdb3 query \
  --database DATABASE_NAME \
  "SELECT * FROM home ORDER BY time"
```
Asi obtenemos los datos, claramente tenemos que agregar el `token` en caso de seguridad, pero también nos muestra en formato `curl` de la siguiente forma: 
```bash
curl -G "http://localhost:8181/api/v3/query_sql" \
  --header 'Authorization: Bearer AUTH_TOKEN' \
  --data-urlencode "db=DATABASE_NAME" \
  --data-urlencode "q=select * from cpu limit 5"
```

A lo que yo lo hice con Insomnia para probarlo y hacerlo más visual que un bash, por lo que queda:
![Pasted image 20260103130440.png](images/Pasted%20image%2020260103130440.png)

## SQL vs InfluxQL

InfluxDB 3 Core admite dos lenguajes de consulta: **SQL** e **InfluxQL**.  
Aunque estos dos lenguajes son similares, existen diferencias importantes que debes tener en cuenta.

---

## SQL

La implementación de SQL en InfluxDB 3 proporciona un motor de consultas SQL completo, impulsado por **Apache DataFusion**.  
InfluxDB amplía DataFusion con funcionalidades adicionales específicas para series temporales y admite consultas SQL complejas, incluidas consultas que utilizan **joins**, **unions**, **funciones de ventana** y más.

**Recursos:**
- [SQL query guides](https://docs.influxdata.com/influxdb3/core/query-data/sql/)
- [SQL reference](https://docs.influxdata.com/influxdb3/core/reference/sql/)
- [Apache DataFusion SQL reference](https://datafusion.apache.org/user-guide/sql/index.html)

---

## InfluxQL

InfluxQL es un lenguaje de consulta similar a SQL, creado para **InfluxDB v1** y compatible con **InfluxDB 3 Core**.  
Su sintaxis y funcionalidad son similares a SQL, pero está diseñado específicamente para consultar datos de series temporales.  
InfluxQL **no ofrece** el conjunto completo de funcionalidades de consulta que sí ofrece SQL.

Si estás migrando desde versiones anteriores de InfluxDB, puedes seguir utilizando InfluxQL y las APIs relacionadas con InfluxQL que ya usabas.

**Recursos:**
- [InfluxQL query guides](https://docs.influxdata.com/influxdb3/core/query-data/influxql/)
- [InfluxQL reference](https://docs.influxdata.com/influxdb3/core/reference/influxql/)
- [InfluxQL feature support](https://docs.influxdata.com/influxdb3/core/reference/influxql/feature-support/)

---

## Optimización de consultas

InfluxDB 3 Core ofrece las siguientes opciones de optimización para mejorar tipos específicos de consultas:

- [Last values cache](https://docs.influxdata.com/influxdb3/core/get-started/query/?dl=oss3&code_lang=bash&code_lines=4&has_placeholders=true&code_type=code&section=Example%253A%2520Query%2520passing%2520URL-encoded%2520parameters&first_line=curl%2520-G%2520%2522http%253A%252F%252Flocalhost%253A8181%252Fapi%252Fv3%252Fquery_sql%2522%2520%255C#last-values-cache)
- [Distinct values cache](https://docs.influxdata.com/influxdb3/core/get-started/query/?dl=oss3&code_lang=bash&code_lines=4&has_placeholders=true&code_type=code&section=Example%253A%2520Query%2520passing%2520URL-encoded%2520parameters&first_line=curl%2520-G%2520%2522http%253A%252F%252Flocalhost%253A8181%252Fapi%252Fv3%252Fquery_sql%2522%2520%255C#distinct-values-cache)

---

## Caché de últimos valores

La **caché de últimos valores (Last Values Cache, LVC)** de InfluxDB 3 Core almacena en memoria los últimos **N valores** de una serie o jerarquía de columnas.  
Esto permite a la base de datos responder este tipo de consultas en **menos de 10 milisegundos**.

Para más información sobre cómo configurar y usar la LVC, consulta:
- [Manage a last values cache](https://docs.influxdata.com/influxdb3/core/admin/last-value-cache/)
- [Query the last values cache](https://docs.influxdata.com/influxdb3/core/admin/last-value-cache/query/)

---

## Caché de valores distintos

La **caché de valores distintos (Distinct Values Cache, DVC)** de InfluxDB 3 Core almacena en memoria los valores únicos de columnas específicas dentro de una serie o jerarquía de columnas.  
Esto es útil para búsquedas rápidas de metadatos, que pueden responder en **menos de 30 milisegundos**.

Para más información sobre cómo configurar y usar la DVC, consulta:
- [Manage a distinct values cache](https://docs.influxdata.com/influxdb3/core/admin/distinct-value-cache/)
- [Query the distinct values cache](https://docs.influxdata.com/influxdb3/core/admin/distinct-value-cache/query/)





# Bibliografía: 
- [documentación](https://docs.influxdata.com/influxdb3/core/)
- [Video inicial]()