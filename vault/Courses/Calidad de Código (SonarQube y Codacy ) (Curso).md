# Inicio
Primero veremos lo que es Codacy que según yo es el más fácil de usar y de aplicar. Primero vamos a la página: 
![[Pasted image 20250425183750.png]]
Primero miremos algo de los precios que siempre es importante entender que es lo que , si pagamos, obtenemos: 
![[Pasted image 20250425184308.png]]
Nosotros claramente usaremos el "Developer", aqui veremos una tabla que nos puede ayudar a indentificar: 

| Plan           | ¿Qué hace?                                                                                                                                                                                            | Diferencias clave                                                                                                                                                                                                          | ¿Cuándo usarlo?                                                                                                                                                               |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Developers** | Escanea y asegura código generado por IA directamente en el IDE (VSCode, Cursor, Windsurf). Detecta vulnerabilidades, secretos, dependencias inseguras, código duplicado, y problemas de performance. | Gratis<br>- Solo para 1 desarrollador<br>- Seguridad básica integrada en IDE<br>- No permite colaboración de equipos ni reportes avanzados.                                                                                | Cuando eres un desarrollador individual que quiere asegurar su código generado por IA sin pagar. Ideal para proyectos personales o freelance.                                 |
| **Team**       | Todo lo del Developer, pero para equipos (hasta 30 devs). Añade colaboración, estándares de codificación compartidos, PR scanning, y gestión de riesgos escalada.                                     | - $21 por dev/mes (anual)<br>- Soporte de equipos<br>- Revisión automática de Pull Requests<br>- Seguridad cruzada entre proyectos.                                                                                        | Cuando tienes un equipo pequeño o mediano que necesita asegurar su código de forma colaborativa y estandarizada, desde el desarrollo hasta los PRs.                           |
| **Business**   | Todo lo de Team, más monitoreo de seguridad en tiempo real, SBOM explorer, exploración de licencias, soporte para auditorías de seguridad, APIs customizadas y despliegue prioritario.                | - Precio personalizado<br>- Proyectos ilimitados<br>- Detección de vulnerabilidades diaria en todo el código<br>- Penetration Testing disponible (por separado)<br>- Dedicated Customer Success Manager y soporte premium. | Cuando eres una empresa grande o con requisitos de cumplimiento (compliance) fuerte en seguridad, auditorías constantes o que necesita integración profunda con sus sistemas. |
| **Audit**      | Genera un informe único de auditoría de 360° para calidad y seguridad de código. No es un servicio continuo.                                                                                          | - Precio personalizado<br>- Una sola vez<br>- Exporta informes de cumplimiento<br>- Incluye SAST, DAST, SCA, revisión de secretos, auditoría de licencias y más.<br>- No requiere suscripción continua.                    | Cuando necesitas solo un informe de cumplimiento para una auditoría interna, certificación o cliente, pero no quieres pagar por monitoreo o integración continua.             |

---
En la tabla observamos las principales diferencias.
Dentro de la documentación nos dan una serie de pasos a seguir para poder iniciar, entonces tendremos que hacer: 
1. Iniciar sesión o registrarse
2. Escoger una organización
	-  ![[Pasted image 20250425193046.png]]
3. Añadir los repositorios
	- ![[repositories-add.png]]

Una vez hecho esto nos encontramos en la pagina principal, usaré mi Codacy para seguir explicando. 

![[Pasted image 20250425185714.png]]

![[Pasted image 20250425191958.png]]
Aqui nosotros tenemos la pagina principal que veremos
![[Pasted image 20250425192021.png]]
Y en repositorio vemos que repositorios hemos elegido: 
![[Pasted image 20250425192053.png]]
Podemos crear integraciones a diferente lado
![[Pasted image 20250425192139.png]]
Al meternos dentro de cada uno de los repositorios tenemos una vista diferente. ![[Pasted image 20250425192249.png]]
Aqui vemos un apartado de home que es un Dashboard de básicamente lo necesario que nos dan. 
La documentación nos recomienda una sección en la que configuremos nuestro repositorios: 
## Configurar repositorios
En muchas situaciones, tu quisieras ignorar o excluir archivos del analisis de Codecy. Para excluirlos vamos a las opciones de nuestro repositorio: 
![[Pasted image 20250425200532.png]]
Este es un repositorio en el cual podemos ignorar muchas cosas, lo recomendable, siento yo, es posible ignorar `resources` o `test` dependiendo de como se comporte el sistema después de eso.
Nos recomienda usar un archivo de configuración para definir una lista personalizada de exclusión de direcciones. 
### Crear una lista personalizada de exlcusión
Para crear esta lista basta con crear en nuestra raíz del proyecto un archivo con nombre : `.codacy.yml` o `.codacy.yaml`.
Este archivo debe empezar siempre con `---` . Un ejemplo de este es: 
```yaml
---
engines: 
	rubocop:
	    exclude_paths:
	      - "config/test.yml"
	    base_sub_dir: "test/baseDir"
	duplication:
	    exclude_paths:
	      - "config/test.yml"
	    config:
	      languages:
	        - "ruby"
languages:
  css:
    extensions:
      - ".scss"
  python:
    enabled: false
exclude_paths:
  - ".bundle/**"
  - "spec/**/*"
  - "benchmarks/**/*"
  - "**.min.js"
  - "**/tests/**"
include_paths:
  - "**/tests/integration/**"
```
Este archivo que vemos esta orientado a Ruby por lo que al menos, yo no conozco mucho el prototipo de archivos de Ruby, transformando esto a código Java tenemos: 
```yml
---
engines:
  checkstyle:
    exclude_paths:
      - "src/test/"
      - "build/"
      - "**/generated/**"
    base_sub_dir: "src/"

  duplication:
    exclude_paths:
      - "src/test/"
    config:
      languages:
        - "java"

languages:
  java:
    extensions:
      - ".java"

exclude_paths:
  - "build/**"
  - "out/**"
  - "**/test/**"
  - "**/generated/**"
include_paths:
  - "src/main/**"
  - "src/app/**"
```
Aquí entendemos un poco más ahora bien definiremos cada uno haciendo una tabla de su significado.

| Clave                               | Qué hace                                                                                                    |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `engines`                           | Define los motores de analisis (como `checkstyle` para java y `duplication` para encontrar código repetido) |
| `exclude_paths` dentro de `engines` | Aqui especifica carpetas que estos motores deben ignorar                                                    |
| `base_sub_dir`                      | Le decimos al motor desde donde debe empezar a analizar, es útil si no esta configurado ya                  |
| `languages`                         | Aquí declaro que lenguaje uso y que extensiones voy o quiero analizar.                                      |
| `exclude_path` global               | Son los archivos o directorios que ningún motor debe tocar                                                  |
| `include_path`                      | Rutas que si deberían analizarse , asi estén dentro de las exclusiones.                                     |
Por defecto ya se nos viene ignorado unos archivos, como podemos observar: ![[Pasted image 20250425204028.png]]



# Bibliografía: 
- [Documentación oficial](https://docs.codacy.com/getting-started/codacy-quickstart/)
- 