

# Parte 2: Creando una arquitectura

En la primera parte de este libro se enfocó en sentar las bases por la cual un arquitecto debe pensar en ciertos atributos de calidad para formar o construir un sistema. Esta segunda parte se basa en la pregunta: ¿Cómo un arquitecto crea una arquitectura?

En el capítulo 4 estaremos explorando diferentes tipos de calidad que son apropiados para la arquitectura, existen 6 importantes: 
- Disponibilidad
- Modificabilidad
- Rendimiento
- Seguridad
- Testeabilidad
- Usabilidad

En el capítulo 5, vamos a listar las herramientas (Tácticas y patrones) del kit de arquitectura que vamos a usar para alcanzar los atributos de calidad.

En el capítulo 6, introduciremos nuestro segundo caso de estudio, un sistema diseñado para respaldar las funciones de control de tráfico área de la Administración federal de aviación. Este sistema fue diseñado para alcanzar altos requerimientos de disponibilidad (menos de 5 minutos fuera de servicio por año) e ilustra las tácticas enumeradas en el capítulo 5.

En el capítulo 7, analizamos cómo aplicar estas herramientas en el diseño de una arquitectura y en la creación de un sistema esquelético, y como las arquitecturas se ven reflejadas en una estructura organizacional.

En el capítulo 8, vamos a presentar nuestro tercer caso de estudio de los simuladores de vuelo, estos sistemas fueron diseñados para alcanzar un rendimiento en tipo real y ser fácilmente modificable. Mostraremos como estos logros son alcanzados.

En el capítulo 9, vemos que una vez la arquitectura se diseña esta debe ser documentada. Se trata de documentar primero las perspectivas pertinentes y, a continuación, el material que va más allá de cualquier perspectiva concreta. Detalla cómo documentar una arquitectura.

A menudo, la arquitectura de un sistema no está disponible porque nunca se documentó,
se ha perdido o porque el sistema tal y como está construido difiere del sistema diseñado. En el capítulo 10 se aborda
la recuperación de la arquitectura de un sistema existente.
## Capítulo 4: Entendiendo los atributos de calidad: 

Las consideraciones del negocio determinan los atributos de calidad que debemos incorporar en la arquitectura del sistema. Estos atributos van más allá de la funcionalidad, la cual describe las capacidades, servicios y comportamiento básico del sistema. Aunque la funcionalidad y otras cualidades están estrechamente relacionadas, la funcionalidad por sí sola no es suficiente, ya que los sistemas también deben cumplir con atributos como rendimiento, seguridad, mantenibilidad y escalabilidad, que definen cómo debe operar el sistema en diferentes condiciones.

### Funcionalidad y Arquitectura
La funcionalidad y los atributos de calidad son ortogonales, es decir, pueden definirse de manera independiente: la funcionalidad describe qué hace el sistema, mientras que los atributos de calidad determinan cómo lo hace (rendimiento, seguridad, disponibilidad, etc.). Aunque no cualquier nivel de calidad es alcanzable para cualquier tipo de funcionalidad debido a limitaciones inherentes, las decisiones arquitectónicas influyen directamente en el nivel de calidad que se puede lograr. La funcionalidad requiere que los distintos componentes del sistema colaboren correctamente para cumplir su propósito, pero no depende de una estructura específica, ya que podría implementarse incluso como un sistema monolítico. Sin embargo, la arquitectura introduce una estructura que permite no solo cumplir la funcionalidad, sino también satisfacer otros atributos de calidad, los cuales terminan condicionando cómo se organiza y construye el sistema.
### Arquitectura y atributos de calidad
El cumplimiento de los atributos de calidad deben ser considerados a lo largo del diseño, implementación y despliegue. Ninguno de estos debe depender de una única etapa o momento, por ejemplo:
- **Usabilidad:** Tiene componentes arquitectónicos y no arquitectónicos, no arquitectónicos como el diseño de la interfaz de usuario y arquitectónicos como el permitir deshacer acciones, cancelar operaciones o reutilizar datos (ya que requiere de coordinación entre múltiples componentes del sistema)
- **Modificabilidad**: Esta depende tanto de la arquitectura como de la implementación. A nivel arquitectónico, está determinada por como se divide la funcionalidad entre componentes, buscando que los cambios afecten la menor cantidad posible de elementos. A nivel no arquitectónico, depende de la calidad del código dentro de cada módulo. Incluso, una buena arquitectura con código mal escrito puede dificultar las modificaciones. 
- **Rendimiento**: Este también combina factores arquitectónicos como no arquitectónicos. Desde la arquitectura hay aspectos como la cantidad de comunicaciones entre componentes, distribución de responsabilidades y el manejo de recursos compartidos. Desde la implementación, impactan decisiones como la elección y codificación de algoritmos. Ambos niveles determinan conjuntamente el desempeño final del sistema.

Así que los mensajes de la sección son dos: 
1. La arquitectura es crítica para la realización de muchos atributos de calidad que interesan al sistema, y estos atributos pueden ser diseñados y evaluados a nivel de arquitectura
2. La arquitectura por sí misma, es insuficiente para alcanzar los atributos de calidad. Este nos provee la base para llegar a ellos, pero no servirá de nada si no se presta atención a los detalles.

En sistemas complejos, los atributos de calidad no pueden lograrse de forma aislada, ya que mejorar uno puede afectar positiva o negativamente a otros. Existen tensiones naturales entre ellos, como entre seguridad y confiabilidad, o entre portabilidad y rendimiento, donde optimizar una cualidad introduce compromisos en otra. Por ello, el diseño arquitectónico implica gestionar estos trade-offs para alcanzar un balance adecuado. A partir de esto, los atributos de calidad se pueden agrupar en tres clases: 
1. **Del sistema**, como disponibilidad, modificabilidad, rendimiento, seguridad, testabilidad y usabilidad.
2. **Del negocio**, como el tiempo de salida al mercado, influenciadas por la arquitectura.
3. **De la arquitectura**, como la integridad conceptual, que impactan indirectamente otras cualidades del sistema.

### Atributos de calidad del sistema:

Los atributos de calidad del sistema han sido ampliamente estudiados, aun así presentan tres problemas principales: sus definiciones suelen no ser operacionales (no son medibles directamente), existe solapamiento entre atributos (un mismo evento puede pertenecer a varios), y cada comunidad utiliza su propia terminología para describir fenómenos similares. Para abordar esto, se propone el uso de escenarios de atributos de calidad que permiten describirlos de forma clara, medible y estructurada. 

#### Escenarios de atributos de calidad

Un escenario de atributos de calidad es un requisito específico de un atributo de calidad. Consta de seis partes: 
- **Fuente del estímulo**: Se trata de la entidad que genera un estímulo (humano, sistema o algún otro actuador)
- **Estímulo**: El estímulo es la condición que debe tenerse en cuenta cuando llega a un sistema
- **Entorno**: El estímulo se produce en ciertas condiciones, el sistema puede encontrarse en una situación de sobrecarga o estar en funcionamiento cuando se produce, o bien alguna otra condición.
- **Artefacto**: Se estimula algún artefacto. Puede ser todo el sistema o partes de él.
- **Respuesta**: La respuesta es la actividad que se lleva a cabo tras la llegada del estímulo.
- **Medida de respuesta:** Cuando se produce la respuesta, debe ser medible de alguna manera para que se pueda comprobar el requisito.

Se distinguen dos tipos de escenarios de atributos de calidad: Los escenarios generales, que son independientes del sistema y aplican de forma abstracta cualquier sistema, y los escenarios concretos, que son específicos de un sistema particular. Aunque los atributos se describen inicialmente mediante escenarios generales, para convertirlos en requisitos reales es necesario adaptarlos y transformarlos en escenarios correctos según el contexto del sistema. 

![[Pasted image 20260318194043.png]]

#### Escenarios de Disponibilidad

El escenario general para el atributo de calidad de la disponibilidad, por ejemplo, el mostrado en la siguiente figura. Aqui se muestran sus seis partes, indicando el rango de valores que pueden adoptar. A partir de esto podemos derivar escenarios concretos y específicos en cada sistema
No todos los sistemas cuentan con estas seis partes, las partes que son necesarias son el resultado de la aplicación del escenario y de los tipos de pruebas que se llevarán a cabo para determinar si se ha cumplido el escenario.

![[Pasted image 20260318193718.png]]
Figura 4.1

En la figura 1 podemos observar un "estandar" de algo que puede ocurrir dentro del escenario de disponibilidad, básicamente: 
- **Source (Fuente)**: quién genera el evento  
    → interno o externo
- **Stimulus (Estímulo)**: qué ocurre  
    → fallos, omisiones, caídas, problemas de timing
- **Artifact (Artefacto)**: qué parte del sistema se ve afectada  
    → proceso, almacenamiento, CPU, red
- **Environment (Entorno)**: en qué condiciones ocurre  
    → operación normal o degradada
- **Response (Respuesta)**: qué hace el sistema  
    → registrar, notificar, continuar, degradarse, detenerse
- **Response Measure (Medida)**: cómo se evalúa  
    → tiempo de reparación, disponibilidad, downtime

Pero para tener una situación real tenemos lo siguiente: 
![[Pasted image 20260318204622.png]]
Figura 4.2

Aquí en la figura 4.2  lo importante: **instanciar el escenario general**.
- **Source**: externo al sistema
- **Stimulus**: mensaje no anticipado
- **Artifact**: un proceso
- **Environment**: operación normal    
- **Response**: informar al operador y continuar
- **Response Measure**: sin downtime


#### Escenario de Modificabilidad:

En un escenario concreto de modificabilidad