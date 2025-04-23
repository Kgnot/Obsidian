# Arquitectura de Software

Una de las cosas mas importantes es poder escoger uno o dos lenguajes. Los mios por ahora solo voy en JAVA. 

# Herramientas

Las primeras herramientas son Github, Jenkis, Jira, ELK, SonarQube. Abajo espero crear una pagina donde pondré eso o solo aprenderlo.  Haciendo por categorías de herramientas tenemos: 

## Controles de versiones:

- Github, Gitlab, Bitbucker,Git
    
    Diseñado para gestionar ramas, código y colaboradores.
    [[Git (Curso)]]    

## Integración y despliegue continuo (CI/CD):

- Jenkins
    - Orquestador de pipelines, muy flexible y algo viejo
- GithubActions:
    - CI/CD integrada con github
- GitLab CI/CD
    - Alternativa moderna a Jenkins
- CircleCI/ TravisCI
    - Creada para proyectos pequeños

El CI/CD nos permite compilar, testear, y desplegar automáticamente.

Aqui el apartado va a ser para github Actions y quiza Jenkins: 
[[Github Actions , Jenkins (CI CD) (Curso)]] 

## Calidad de código y análisis estático:

- SonarQube:
    - Analiza bugs, duplicación de código, cobertura de pruebas
- **PMD / Checkstyle**
    - Para Java, analizan formato, estilo y errores comunes.
- Codacy / CodeClimate
    - Alternativas más automáticas, a veces con visuales más simples.

## Observabilidad y monitoreo

- ELK Stack (Elasticksearch, Logstash, Kibana)
    - Centralización y visualización de logs
- Grafana + Prometheus
    - Metricas, alertas y performance
- Jaeger/Zipkin
    - Para trazabilidad distribuida (microservicios)

## Colaboración y documnetación

- Confluence
    - Un notion para equipos donde se documenta, arquitectura, desiciones, etc
- Jira
    - Gestión de tareas, bugs,épicas y sprints
- Slak, discord, microsoft teams
    - Comunicación en tiempo real

# Principios de Diseño:

Aqui aplicarémos todo lo necesario y relacionado a: 

## OOP:

## Clean Code:

## TDD

## DDD

## Teoriema CAP

## Patrón MVC

## ACID

## Patrones de GoF:
[[Patrones de diseño (Concepto)]]


# Principios Arquitectonicos.

## Microservisios:

## Publicacion-Suscripciones

## Layered

## Event-Driver

## Client-Server

## Hexagonal

# Plataformas

Es necesario entender los conceptos de: 

## Contenedores

## Orquestación

## Computación en la Nube.

## Serverless

## CDN

## API Gateways.

## CI/CD

# Analisis de Datos:

## Bases de datos:

### SQL:

### NoSQL:

### NewSQL:

## Streaming de datos con Kafka

## Hadoop

## Migración de datos

## OLAP:

# Redes y Seguridad:

## DNS

## TCP

## TLS

## HTTPS

## Cifrado

## JWT

[[Java SpringBoot (Curso)]] - Aqui hay un apartado sobre ello

## OAuth

## Gestión de credenciales