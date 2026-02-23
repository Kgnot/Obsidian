---
type: concepto
tags: [concepto, MVC (Concepto)]
date_created: 2024-05-20
---

![img_6212df40ef951.png](images/img_6212df40ef951.png)

Este es un dibujo de como se comporta el MVC, aunque se visualiza mejor en UML: 
![mvc-sequence-diagram-example-2.png](images/mvc-sequence-diagram-example-2.png)
Es de las arquitecturas de presentación más conocidas y fáciles de entender.

**Los objetos de la entidad**(Modelo) no son más que la información o los datos que buscan sus objetos de contorno. Estos pueden ser: tablas de bases de datos, archivos de Excel, sesiones o datos guardados en caché o algo por el estilo
- Describa los objetos que existen a lo largo del tiempo y que se relacionan principalmente con el estado persistente.
- Por lo general, los objetos del modelo de dominio
- Cosas que debemos controlar y almacenar
**Los objetos de límite** (Vista) son objetos con los que los actores (p. ej., usuarios) se comunican en su sistema de software. Estos objetos pueden ser cualquier ventana, pantalla, cuadro de diálogo y menú, u otra interfaz de usuario en su sistema. Puede identificarlos fácilmente al analizar los casos de uso.
- describir las conexiones entre el sistema y el entorno que se comunican.
- Utilizado por los actores cuando se comunican con el sistema
- Solo los objetos de entidad pueden iniciar eventos.
- (por lo general, los principales elementos de la interfaz de usuario, por ejemplo, pantallas)
**Los objetos de control** (controladores) son objetos comerciales o sus servicios web comerciales. Aquí es donde captura las reglas comerciales que se utilizan para filtrar los datos que se presentarán al usuario, lo que solicita. Entonces, el controlador en realidad controla la lógica comercial y la transformación de datos.
- describir el comportamiento en un caso de uso particular.
- El «pegamento» entre los objetos de contorno y los objetos de entidad
- Capture reglas y políticas comerciales
- (nota: a menudo implementado como métodos de otros objetos)

### Reglas de conexión en el modelo MVC

Considere que los objetos de límite y los objetos de entidad son sustantivos, mientras que los controladores son verbos.

Aquí están las cuatro reglas básicas de conexión.

- Los actores solo pueden interactuar o comunicarse con objetos de contorno.
- Los objetos de contorno solo pueden comunicarse con controladores y actores.
- Los objetos de entidad solo pueden interactuar con los controladores.
- Los controladores pueden comunicarse con objetos de contorno y objetos de entidad, así como con otros controladores, pero no con actores.

![mvc-sequence-diagram-example-1.png](images/mvc-sequence-diagram-example-1.png)

El código es algo que haremos en un apartado de prueba donde uso Thymeleaf, Jetty y una base de datos. 