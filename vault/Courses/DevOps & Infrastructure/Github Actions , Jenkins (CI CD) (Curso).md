---
type: course
status: en_progreso
tags: [course, Github Actions , Jenkins (CI CD) (Curso)]
date_started: 2024-05-20
---

# Github Actions , Jenkins (CI/CD)

# CI/CD

### CI – **Continuos Integration (Integración Continua)**

**¿Qué es?**

Es el proceso de integrar continuamente el código que cada desarrollador escribe en un repositorio central varias veces al día.

**Objetivo:**

Detectar errores rápido y facilitar la integración del trabajo de todos.

**Incluye típicamente:**

- Commit frecuente de código al repositorio.
- Ejecución automática de tests (unitarios, de integración, etc.).
- Validación del build (compilación, empaquetado, etc.).

### CD – **Continuos Delivery vs Continuos Deployment**

**Continuos Delivery (Entrega Continua)**

**¿Qué es?**

Después de pasar por CI, el software es **empaquetado, probado y dejado listo para desplegar**, pero el despliegue a producción **no es automático**: alguien debe aprobarlo.

**Características:**

- Pipeline automatizado hasta staging o pre-producción.
- Revisión manual antes del despliegue final.
- Ideal para entornos donde necesitas control humano antes de producción.

---

**Continuos Deployment (Despliegue Continuo)**

**¿Qué es?**

Va un paso más allá: cada cambio que pasa los tests y validaciones del pipeline se **despliega automáticamente a producción** sin intervención humana.

**Características:**

- Despliegue 100% automático.
- Feedback inmediato desde usuarios reales.
- Requiere mucha confianza en tus tests y monitoreo.

# Que son las github actions:

Es un sistema de continuos integration and Continuos delivery (CI/CD), es decir integrar nuestra aplicación constantemente. Un sistema de automatización para verificar la integridad y calidad del código , y ademas se puede añadir en producción.  También se pueden hacer despliegues. Aqui mostraremos el como se despliega en Heroku .

Pagina : 

[GitHub Actions documentation - GitHub Docs](https://docs.github.com/en/actions)

Los sistemas de integración continua son servidores como maquinas virtuales que están en la nube, y asi siempre tenemos la misma integración. 

Nosotros podemos configurar un workflow de github actions para ser lanzado cuando un evento ocurra, ya sea un `push`, o un `merge` a alguna rama (generalmente la main),nuestro workflow contiene uno o más trabajos en un orden secuencial o en paralelo. Cada uno de estos trabajos corre en una propia maquina virtual. 

## Workflows:

Un  workflow es un proceso automatizado que podemos configurar para correr uno o mas trabajos, estos son definidos mediante un archivo YAML dentro de nuestro repositorio y se correrá cada que se le asigne un evento o se defina una programación . Estos workflow son definidos en  la carpeta `.github/workflows` del repositorio. Un repositorio puede tener múltiples workflows y cada uno con diferentes tareas. Ya sean: 

- Construir y testear pull request.
- Desplegar la aplicación cada que una nueva “release” es creada.
- Agregar una etiqueta cada que se abre una nueva edición.

También podemos referenciar un workflow dentro de otro workflow

## Events

Un evento es una actividad especifica de el repositorio que activa un `run` del workflow. Por ejemplo, una actividad puede originarse desde github cuando alguien crea un `pull request` , abre un `issue` o hace un `push` de un `commit` al repositorio, también podemos colocarle horarios a los workflows o hacerlo manualmente.

## Jobs:

Un trabajo o un Job es una serie de pasos en un workflow que es ejecutado en el mismo `runner` . Cada uno de estos pasos es un script de shell que se ejecutará o una acción que lo hará. Los pasos se ejecutan en orden y dependen unos de otros , como cada paso se ejecuta en el mismo `runner` entonces podemos compartir información entre pasos, como por ejemplo que uno construya la aplicación y el otro que la pruebe.

Se puede configurar dependencia entre jobs, por defecto cada Job se ejecuta en paralelo. Cuando un trabajo depende de otro este espera a que el otro esté terminado antes de ejecutarse.

Por ejemplo, puedes configurar varios trabajos de compilación para diferentes arquitecturas sin ninguna dependencia de trabajo y un trabajo de empaquetado que dependa de esas compilaciones. Los trabajos de compilación se ejecutan en paralelo y, una vez que finalizan correctamente, se ejecuta el trabajo de empaquetado.

## Actions

Una **action** es una aplicación personalizada para la plataforma GitHub Actions que realiza una tarea compleja pero frecuentemente repetida. Use una action para ayudar a reducir la cantidad de código repetitivo que escribe en sus archivos de **workflow**. Una action puede extraer su repositorio Git de GitHub, configurar la cadena de herramientas correcta para su entorno de compilación o configurar la autenticación para su proveedor de la nube.

Puede escribir sus propias actions o puede encontrar actions para usar en sus workflows en GitHub Marketplace.

## Runners:

Un **runner** es un servidor que ejecuta tus workflows cuando son activados. Cada runner puede ejecutar un solo **job** a la vez.

GitHub proporciona runners de Ubuntu Linux, Microsoft Windows y macOS para ejecutar tus **workflows**. Cada ejecución del workflow se realiza en una máquina virtual nueva y recién aprovisionada.

GitHub también ofrece runners más grandes, que están disponibles en configuraciones más amplias.

## Crear el documento

Vamos a crear el documento YAML y vamos a ver de que consta: 

Un documento tiene este estilo: 

```yaml
name: Say hello # Aqui decimos el como se llama el workflow
	
	
on: # sobre que va a actuar, es decir los eventos
	push: # El evento es push y hay una gran cantidad de eventos
		branches:  # sobre que ramas en push?
			- main  # Sobre la rama main
			
jobs:  # Cuales seran los trabajos que realziara? 
	hello_world: # El primero llamado hello_world 
		run-on: ubuntu-latest # Correra en la ultima version de ubuntu
		steps: # Cuales son los pasos que seguirá?
			- name: Echo the message # Como se va a llamar el paso? (esto es opcional)
			  run: | # Que es lo que va a correr ? usamos el '|' para decir que es mas de una linea
					echo"hola mundo" # Esto es lo que hará
```

Cuando en `yaml` usamos el guion ‘-’ significa que estamos tratando al que contiene los ‘-’ como un arreglo , Para colocar mas steps: 

```yaml
name: Say hellow

on:
	push:
		branches: # como sus hijos tienen '-' entonces es un arreglo
			- main 
			
jobs: 
	hello_world:
		run-on: ubuntu-latest-
		steps: 
			- name: Echo the message
				run: | 
					echo "hola mundo" 
			- name: Dame la fecha # este es otro step con nombre
				run: date
			- run: ls -l # Otro step pero sin nombre
```

En github queda algo como: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image.png)

Donde nos aparece todos los trabajos, como por ahora tenemos solo uno, llamado `hello_world`, solo nos dice eso  y dentro: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%201.png)

[contenido de midudev xd]

cuando ejecutamos `ls -l` ejecutamos un comando para saber los ficheros de la maquina virtual, pero observamos que no tiene ficheros, `total: 0`  .

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%202.png)

Ahora vamos a crear otro workflow, llamaremos `pipeline.yaml` en este se llama pipeline porque es como la tubería donde pasan los procesos que ocurren en nuestra aplicación. Vamos a ver como podemos obtener el código de nuestra aplicación porque como vemos está vacío en `ls -l` .

Existe algo llamado el Marketplace de github , por ejemplo, si necesitamos usar algo que nos coloque todo nuestro repositorio en la maquina virtual tendríamos que configurar la clave SSH , etc. Pero existe una action en el marketplace de github que nos ayuda en eso.

Marketplace: 

[Marketplace](https://github.com/marketplace)

Apartado del marketplace: 

[Checkout - GitHub Marketplace](https://github.com/marketplace/actions/checkout)

Usando el checkout según nos marca el marketplace checkout: 

```yaml
name: Deployment Pipeline

on:
	push: 
		branches:
			- main

jobs: 
	deploy:
		runs-on: ubuntu-18.04
		steps: 
		# Aqui nosotros lo usamos en los pasos
			- uses: actions/checkout@v4 # destinado para crear el repo en la maquina virtual
			  with:
			    fetch-depth: 0
			- uses: actions/setup-node@v2 # Aqui nosotros instalamos node en nuestra maquina virtual (esto es para un proyecto node)
				with:
					node-version: '14'
			- name : Install dependencies 
				run: npm install
			- name: Linter #(Tipico que se use en CI) El linter te asegura que el código integrado es correcto
				run: npm run eslint
				
```

Cuando añadimos este workflow al repositorio, tendríamos dos workflow ya, entonces podemos observar esto: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%203.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%204.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%205.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%206.png)

Tenemos a los dos workflows corriendo al tiempo, luego vemos que podemos elegir entre los workflow. y como ultimo ver como se opera el workflow elegido , en este caso el primero de `Deployment Pipeline` .  Y como última imagen vemos que, al integrar el `Lint`  este fue el problema, y hay un error de deploy.

Continuando con el código: 

```yaml
name: Deployment Pipeline
on:
	push: 
		branches:
			- main

jobs: 
	deploy:
		runs-on: ubuntu-18.04
		steps: 
		# Aqui nosotros lo usamos en los pasos
			- uses: actions/checkout@v4 # destinado para crear el repo en la maquina virtual
			  with:
			    fetch-depth: 0
			- uses: actions/setup-node@v2 # Aqui nosotros instalamos node en nuestra maquina virtual (esto es para un proyecto node)
				with:
					node-version: '14'
			- name : Install dependencies 
				run: npm install
			- name: Linter #(Tipico que se use en CI) El linter te asegura que el código integrado es correcto
				run: npm run eslint
			- name: Build  # Creamos el Build para correrlo y al finalizar el build
				run: npm run build 
			- name: Tests   # Creamos los test para probar si funciona o no
				run: npm run test
```

Nosotros podemos agregar cuantos test queramos, y ver que test están mejor para nosotros, luego ver que mas `uses` nosotros podemos usar.

Dentro de la documentación nos generan este ejemplo: 

```yaml
name: GitHub Actions Demo # Nombre del repo
run-name: ${{ github.actor }} is testing out GitHub Actions 🚀 # Este es un nombre dinamico del run que da el nombre del que activo
on: [push] # cualquier push a cualqueir rama
jobs:
  Explore-GitHub-Actions: # Nombre dle trabajo
    runs-on: ubuntu-latest # corre en ubuntu ultima versión
    steps: # los pasos: 
      - run: echo "🎉 The job was automatically triggered by a ${{ github.event_name }} event." # el evento es push
      - run: echo "🐧 This job is now running on a ${{ runner.os }} server hosted by GitHub!" # nos dice cual es el runner, ahorita ubuntu
      - run: echo "🔎 The name of your branch is ${{ github.ref }} and your repository is ${{ github.repository }}."
      - name: Check out repository code # como vimos este es un nombre de un step
        uses: actions/checkout@v4 # Aqui lo usamos para tener el repo en la maquina virtual
      - run: echo "💡 The ${{ github.repository }} repository has been cloned to the runner." # El repositorio colnado cual es? 
      - run: echo "🖥️ The workflow is now ready to test your code on the runner."
      - name: List files in the repository
        run: |
          ls ${{ github.workspace }}  # esta es la ruta donde se clono el archivo
      - run: echo "🍏 This job's status is ${{ job.status }}." # imprime si es success o failure
```

Seguimos hablando un poco de la documentación tenemos una pequeña explicación acerca de lo básico de los workflows:

Vamos a ver este documento: 

[Accessing contextual information about workflow runs - GitHub Docs](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/accessing-contextual-information-about-workflow-runs#github-context)

Aqui habla sobre todas los métodos o toda la información que trae los diferentes contextos de workflow, como arriba vimos, hay `github.repository` etc, etc.

## Workflows basics:

Un workflow cuenta con los siguientes componentes básicos: 

1. Uno o más eventos (`events`) que serán lanzados en el workflow
2. Uno o más trabajos (`jobs`) donde cada uno se ejecuta en un runner que puede manejar uno o mas pasos
3. Cada paso (`step`) corre un script que tu defines o corre una acción (`action`) donde una extensión reutilizable puede ayudarnos

![overview-actions-simple.webp](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/overview-actions-simple.webp)

## Características avanzadas  de los workflows

### Storing secrets:

 Ahora veremos algo importante de github que son los secrets.  Las **Action Secrets** son token secreto que podemos tener para nuestro github actions. Podemos tenerlas a nivel de repositorio o a nivel de enviroment. Podemos tener variables de entorno para producción y para pre producción.  Entonces tenemos algo así: 

Aqui observamos que creamos un nuevo secreto del repositorio, llamado `HEROKU_API_KEY` este es como el “general”. Nosotros podemos acceder a estos secretos desde los `githubactions`.

```yaml
## Tenemos todo el codiog anterior del yaml

		steps: 
		# Aqui nosotros lo usamos en los pasos
			- uses: actions/checkout@v4 # destinado para crear el repo en la maquina virtual
			  with:
			    fetch-depth: 0
			- uses: actions/setup-node@v2 # Aqui nosotros instalamos node en nuestra maquina virtual (esto es para un proyecto node)
				with:
					node-version: '14'
			- name : Install dependencies 
				run: npm install
			- name: Linter #(Tipico que se use en CI) El linter te asegura que el código integrado es correcto
				run: npm run eslint
			- name: Build  # Creamos el Build para correrlo y al finalizar el build
				run: npm run build 
			- name: Tests   # Creamos los test para probar si funciona o no
				run: npm run test
		##### apartado: 
			- name: Deploy en Heroku 
			 uses: akhilesgns/heroku-deploy@v3.12.12
				with: 
					heroku_api_key: ${{secrets.HEROKU_API_KEY}}#Esta es la foma de leer un secret
					heroku_app_name:  ${{secrets.HEROKU_API}} #Aqui leemos otro llamado HEROKU_API
					heroku_email: ${{secrets.HEROKU_EMAIL}}
		
```

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%207.png)

Tambien, aprovechando, podemos saber de las diferentes formas de crear un evento. Para un pull request tenemos: 

```yaml
on: 
	push:
		branches: [main] # Asi ecambiamos la forma a directamente un array: 
	pull-request: 
		branches: [main] # Solo cuando haya un pull request a main
		types: [opened,syncronize] # Aqui decimos que cuando se abra y cuando se sincronize
```

Aqui hay un problema y no queremos que la pull request también haga el deploy

Para el error mencionado podemos usar toda la información de contexto.

Con el código que tenemos podemos: 

```yaml
name: Deployment Pipeline

on:
	push: 
		branches:
			- main

jobs: 
	deploy:
		runs-on: ubuntu-18.04
		steps: 
		# Aqui nosotros lo usamos en los pasos
			- uses: actions/checkout@v4 # destinado para crear el repo en la maquina virtual
			  with:
			    fetch-depth: 0
			- uses: actions/setup-node@v2 # Aqui nosotros instalamos node en nuestra maquina virtual (esto es para un proyecto node)
				with:
					node-version: '14'
			- name : Install dependencies 
				run: npm install
			- name: Linter #(Tipico que se use en CI) El linter te asegura que el código integrado es correcto
				run: npm run eslint
			- name: Build  # Creamos el Build para correrlo y al finalizar el build
				run: npm run build 
			- name: Tests   # Creamos los test para probar si funciona o no
				run: npm run test
			- name: Deploy en Heroku 
				if: ${{ github.event_name == 'push'}} # En este apartado hace un llamado al contexto de github, y solo pasa a deploy si es un push
			  uses: akhilesgns/heroku-deploy@v3.12.12
				with: 
					heroku_api_key: ${{secrets.HEROKU_API_KEY}}#Esta es la foma de leer un secret
					heroku_app_name:  ${{secrets.HEROKU_API}} #Aqui leemos otro llamado HEROKU_API
					heroku_email: ${{secrets.HEROKU_EMAIL}}
		
```

Ya una vez sabiendo eso, debemos saber otro apartado que es: 

Podemos añadir lo que son proteger mediante reglas a las ramas.

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%208.png)

Cuando damos crear tenemos estas partes. Bypass list son quienes pueden saltarse las reglas. Targets son que ramas se les aplica? y en el apartado de Rules tenemos → 

---

En el apartado de abajo veremos una tabla que hace referencia a cada. Especifica la opcion, que hace, cuando activarla.

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%209.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2010.png)

### Reglas de protección de ramas en GitHub:

| # | Opción | ¿Qué hace? | ¿Cuándo activarla? |
| --- | --- | --- | --- |
| 1 | **Restrict creations** | Solo permite crear ramas coincidentes a usuarios con permiso de omisión (*bypass*). | Para evitar la proliferación de ramas en patrones específicos como `release/*`. |
| 2 | **Restrict updates** | Solo usuarios con permisos pueden hacer *push* a ramas protegidas. | Ideal para ramas críticas (`main`, `prod`) donde todos los cambios deben ir por PR. |
| 3 | **Restrict deletions** | Impide borrar ramas sin permiso especial. | Muy útil para evitar eliminación accidental de ramas importantes. |
| 4 | **Require linear history** | No permite *merge commits* (requiere `rebase` o `squash`). | Activar si se busca mantener un historial limpio. |
| 5 | **Require deployments to succeed** | Solo permite *push/merge* si el deployment en un entorno ha sido exitoso. | Activar si se usa CI/CD y se requiere validación previa en staging o QA. |
| 6 | **Require signed commits** | Exige que los commits estén firmados criptográficamente. | Para entornos donde se exige verificación de autoría o cumplimiento legal. |
| 7 | **Require a pull request before merging** | No permite hacer *push* directo, todo debe pasar por un PR. | Recomendado siempre, para revisión por pares y mantener la calidad. |
| 8 | - Dismiss stale pull request approvals when new commits are pushed | Borra aprobaciones previas si se suben nuevos commits al PR. | Activar cuando se quiera forzar que revisores vuelvan a aprobar ante cambios. |
| 9 | - Require approval of the most recent reviewable push | Solo permite merge si se aprueba la última versión del PR. | Útil para prevenir merges con contenido que no ha sido revisado completamente. |
| 10 | - Require conversation resolution before merging | Impide merge si hay comentarios sin resolver en el PR. | Activar para asegurarse de que todos los problemas discutidos se atiendan. |
| 11 | - Request pull request review from Copilot | Añade automáticamente a GitHub Copilot como revisor del PR. | Activar si usás Copilot para sugerencias automatizadas en la revisión. |
| 12 | **Require status checks to pass** | Exige que pasen ciertos *checks* antes de permitir push o merge. | Fundamental si usás CI (tests, builds, linters, etc.). |
| 13 | - Require branches to be up to date before merging | El PR debe estar actualizado con la rama base para poder mergear. | Activar para evitar errores por versiones desactualizadas del código base. |
| 14 | - Do not require status checks on creation | Permite crear ramas aunque no haya *checks* definidos aún. | Activar solo en etapas tempranas de desarrollo o prototipos. |
| 15 | **Block force pushes** | Prohíbe el `git push --force`. | Activar siempre en ramas protegidas (`main`, `release`, etc.). |
| 16 | **Require code scanning results** | Exige resultados de análisis de seguridad antes del merge. | Activar si usás CodeQL u otra herramienta de seguridad integrada. |

Ya con esto podemos realizar una organización más madura en github. Hablaremos algo más

## Características avanzadas #2

Vamos a hacer el control de Jobs paralelos, vamos a dividir en diferentes trabajos.

```yaml
name: Deployment Pipeline

on:
	push: 
		branches:
			- main

jobs: 
	avoid_redundancy:
		runs-on: ubuntu-18.04
		steps: 
			- name: Cancel Previous Redundant Builds
			  uses: styfle/cancel-workflow-action@0.9.1
			  with: 
				  access_token: ${{github.token}}
		
	lint:
		run-on: ubuntu-18.04
		steps: 
			- uses: actions/checkout@v4
			  with:
			    fetch-depth: 0
			- uses: actions/setup-node@v2
				with:
					node-version: '14'
			- name : Install dependencies 
				run: npm install
			- name: Linter  
				run: npm run eslint
			
	build: 
		run-on: ubuntu-18.04
		steps: 
			- uses: actions/checkout@v4
			  with:
			    fetch-depth: 0
			- uses: actions/setup-node@v2
				with:
					node-version: '14'
			- name : Install dependencies 
				run: npm install
			- name: Build
				run: npm run build
			- uses: actions/upload-artifact@v2 # Aqui lo que hacemos es usar una accion para "empaquetar" un artefacto o algo
				with: 
					name: dist # Aqui decimos que el nombre sea dist
					path: dist  # Y empaquetamos el path que nosotros queremos , esto hace que "subamos a la nube" para usarlo en otro lado
					
	test: 
		needs: [lint,build] # Es una manera de crear dependencia entre jobs, despues de que se ejecuten y se pasen las pruebas, tanto de lint como build, se ejecuta test
		run-on: ubuntu-18.04
		steps: 
			- uses: actions/checkout@v4
			  with:
			    fetch-depth: 0
			- uses: actions/setup-node@v2
				with:
					node-version: '14'
			- name : Install dependencies 
				run: npm install
			- uses: actions/download-artifact@v2 # Aqui ahora no hacemos una subido, si no una bajada
				with: 
					name: dist  # El nombre de lo que queremos guardar es dist
					path: dist  # y le decimos que lo queremos guardar en la carpeta dist
			- name: Test
				run: npm run test # Aqui corremos segun nuestro config.json
				
	deploy:
		needs: [test]
		runs-on: ubuntu-18.04
		steps: 
		# Aqui nosotros lo usamos en los pasos
			- uses: actions/checkout@v4 # destinado para crear el repo en la maquina virtual
			  with:
			    fetch-depth: 0
			- name: Deploy en Heroku 
				if: ${{ github.event_name == 'push'}} # En este apartado hace un llamado al contexto de github, y solo pasa a deploy si es un push
			  uses: akhilesgns/heroku-deploy@v3.12.12
				with: 
					heroku_api_key: ${{secrets.HEROKU_API_KEY}}#Esta es la foma de leer un secret
					heroku_app_name:  ${{secrets.HEROKU_API}} #Aqui leemos otro llamado HEROKU_API
					heroku_email: ${{secrets.HEROKU_EMAIL}}
		
```

Con esto hemos logrado paralelizar todo, un pipeline más complejo y realista.

Así se vería: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2011.png)

Hasta aqui va una pequeña combinación del curso de MiduDev de youtube y algo de documentación, seguiremos con la documentación de github.

---

### Using a matrix

Nosotros podemos usar matrices para correr en diferentes versiones un mismo proyecto, ya sean versiones de `node`, o sean versiones del sistema operativo, tenemos estos dos ejemplos: 

```yaml
jobs:
  example_matrix:
    strategy:
      matrix:
        version: [10, 12, 14]
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.version }}

```

```yaml
jobs:
  example_matrix:
    strategy:
      matrix:
        os: [ubuntu-22.04, ubuntu-20.04]
        version: [10, 12, 14]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.version }}

```

Tambien puede ser un arreglo de objetos: 

Transformando eso en 4 trabajos con trabajos correspondientes

```yaml
matrix:
  os:
    - ubuntu-latest
    - macos-latest
  node:
    - version: 14
    - version: 20
      env: NODE_OPTIONS=--openssl-legacy-provider

```

```yaml
- matrix.os: ubuntu-latest
  matrix.node.version: 14
- matrix.os: ubuntu-latest
  matrix.node.version: 20
  matrix.node.env: NODE_OPTIONS=--openssl-legacy-provider
- matrix.os: macos-latest
  matrix.node.version: 14
- matrix.os: macos-latest
  matrix.node.version: 20
  matrix.node.env: NODE_OPTIONS=--openssl-legacy-provider

```

La documentación nos regala un ejemplo usando esto: 

Por ejemplo, el siguiente flujo de trabajo se activa con el evento `repository_dispatch` y usa información del payload del evento para construir la matriz. Cuando se crea un evento repository dispatch con un payload como el siguiente, la variable `version` de la matriz tendrá un valor de `[12, 14, 16]`.

```json
{
  "event_type": "test",
  "client_payload": {
    "versions": [12, 14, 16]
  }
}

```

```yaml
on:
  repository_dispatch:
    types:
      - test

jobs:
  example_matrix:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        version: ${{ github.event.client_payload.versions }}
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.version }}

```

Hay varios ejemplos bastante bien hechos en la siguiente pagina: 

[Running variations of jobs in a workflow - GitHub Docs](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/running-variations-of-jobs-in-a-workflow)

### Cachear dependencias:

Si tus trabajos reutilizan regularmente dependencias, puedes considerar almacenar en caché estos archivos para ayudar a mejorar el rendimiento. Una vez que se crea el caché, está disponible para todos los flujos de trabajo en el mismo repositorio.

Este ejemplo demuestra cómo almacenar en caché el directorio `~/.npm`:

```yaml
jobs:
  example-job:
    steps:
      - name: Cache node modules
        uses: actions/cache@v4 # Estamos usando algo que nos ayuda a cachear
        env:
          cache-name: cache-node-modules 
        with:
          path: ~/.npm  # Mandamos el path que queremos cachear, recuerda mandarlo en modo linux 
          key: ${{ runner.os }}-build-${{ env.cache-name }}-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-build-${{ env.cache-name }}-
```

Para mas información de cachear dependencias tenemos: 

[Caching dependencies to speed up workflows - GitHub Docs](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/caching-dependencies-to-speed-up-workflows)

### Usando bases de datos y servicio de contenedores:

Si tu trabajo requiere una base de datos o un servicio de caché, puedes usar la palabra clave `services` para crear un contenedor efímero que aloje el servicio. El contenedor resultante estará disponible para todos los pasos en ese trabajo y se eliminará cuando el trabajo se haya completado.

El siguiente ejemplo muestra cómo un trabajo puede usar `services` para crear un contenedor `postgres` y luego usar `node` para conectarse al servicio:

```yaml
jobs:
  container-job:
    runs-on: ubuntu-latest # Corremos en la última versión de ubuntu
    container: node:20-bookworm-slim # Usamos una imagen de node específica
    services: # Definimos los servicios que necesitamos
      postgres: # Nombre del servicio
        image: postgres # Imagen de Docker a usar
    steps:
      - name: Check out repository code # Paso para clonar el repositorio
        uses: actions/checkout@v4
      - name: Install dependencies # Instalamos dependencias
        run: npm ci
      - name: Connect to PostgreSQL # Nos conectamos a PostgreSQL
        run: node client.js
        env: # Variables de entorno necesarias
          POSTGRES_HOST: postgres
          POSTGRES_PORT: 5432
```

**¿Qué hace este código?**

1. Define un trabajo que se ejecuta en un contenedor de Node.js
2. Crea un servicio de PostgreSQL como contenedor separado
3. Configura la comunicación entre el contenedor principal y el servicio de base de datos
4. Ejecuta los pasos necesarios para: 
    - - Clonar el repositorio
    - - Instalar dependencias
    - - Conectarse a PostgreSQL usando variables de entorno

Este patrón es muy útil cuando necesitas realizar pruebas o operaciones que requieren una base de datos en tu pipeline de CI/CD.

### Usando etiquetas para enrutar flujos de trabajo

Si deseas asegurarte de que un tipo particular de ejecutor procese tu trabajo, puedes usar etiquetas para controlar dónde se ejecutan los trabajos. Puedes asignar etiquetas a un ejecutor autohospedado además de su etiqueta predeterminada `self-hosted`. Luego, puedes hacer referencia a estas etiquetas en tu flujo de trabajo YAML, asegurando que el trabajo se enrute de manera predecible. Los ejecutores alojados en GitHub tienen etiquetas predefinidas asignadas.

Este ejemplo muestra cómo un flujo de trabajo puede usar etiquetas para especificar el ejecutor requerido:

```yaml
jobs:
  example-job:
    runs-on: [self-hosted, linux, x64, gpu]
```

Un flujo de trabajo solo se ejecutará en un ejecutor que tenga todas las etiquetas en el array `runs-on`. El trabajo irá preferentemente a un ejecutor autohospedado inactivo con las etiquetas especificadas. Si no hay ninguno disponible y existe un ejecutor alojado en GitHub con las etiquetas especificadas, el trabajo irá a un ejecutor alojado en GitHub.

---

Podemos seguir ahondando en la documentación pero por ahora terminaremos aqui eel apartado de GithubActions 

# Jenkins:

Curso a seguir: 

[Curso Completo de Jenkins Para Principiantes con Docker, Git, Spring Boot, Slack y SonarQube](https://www.youtube.com/watch?v=LZDmM_t4XRg)

Documentación a seguir: 

[Jenkins User Documentation](https://www.jenkins.io/doc/)

Vamos a ahondar en lo que es Jenkins , aqui vamos a hablar un poco de Docker, quizá ahondemos algunos conceptos de ello. 

Vamos también a usar SpringBoot , Slack y SonarQube. 

Empezando con Jenkins hay que saber que es un servido de automatización DI/CD, su arquitectura es importante, existe un master y los workers: 

### Master:

Es el responsable de ser el núcleo de Jenkins y quien gestiona las tareas, distribuye los grupos de trabajos y la interfaz web

### Agents:

Los agentes son maquinas o instancias que se conectan al servidor master de Jenkins para ejecutar los trabajos. 

### Plugins:

Son herramientas instalados desde la interfaz web , en la que se pueda integrar Jenkins con mas tecnologías, como git, Docker, SonarQube, Slack , Kubernets, etc.

### Jobs/ Proyectos:

Es la unidad básica del trabajo. Es el conjunto de tareas o pasos que Jenkins realiza y ejecuta , como la compilación, despliegue, testing etc. 

### Pipeline:

Es un concepto más avanzado que un Job, ya que define todo el flujo de trabajo como código. Una Pipeline permite definir todo el proceso de CI/CD como una serie de etapas y pasos usando código (generalmente en un archivo Jenkinsfile).

**Ejemplo de diferencia:**

Un Job simple podría ser: "Compilar una aplicación Java", donde configuras manualmente los pasos en la interfaz de Jenkins para compilar el código.

Una Pipeline, en cambio, sería: "Compilar, probar, analizar y desplegar una aplicación Java", donde defines en código todas estas etapas

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2012.png)

## Crear app Jenkins

Lo primero que debemos es instalar Jenkins

En la documentación de Jenkins hay muchas maneras de hacerlo: 

[Windows](https://www.jenkins.io/doc/book/installing/windows/)

Aquí hay una versión directa de como hacerlo con Docker (que también podemos ver desde la documentación)

Para eso usaremos un archivo Docker para levantarlo, entonces como primer paso creamos el archivo Dockerfile: 

```docker
# Use the Jenkins base image , toca revisar e instalar la que nos sirve: 
# FROM jenkins/jenkins:lts 
FROM jenkins/jenkins:jdk21

# Switch to the root user
USER root

# Install required packages and Docker
RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common \
        wget && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Maven
ARG MAVEN_VERSION=3.9.8
RUN wget --no-verbose https://downloads.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -P /tmp/ && \
    tar xzf /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /opt/ && \
    ln -s /opt/apache-maven-$MAVEN_VERSION /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/local/bin && \
    rm /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz

# Set up environment variables for Maven
ENV MAVEN_HOME=/opt/maven

# Add Jenkins user to Docker group
RUN usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins
```

Luego de esto corremos la imagen:

```bash
docker build -t jenkins-ci .
```

Para luego correrla en un contenedor: 

```bash
docker run -d -p 8080:8080 -p 5000:5000 --name jenkins jenkins-ci
```

Una vez tenemos esto entramos a los logs: 

```bash
docker logs jenkins
```

Nos genera algo asi: 

```bash
*************************************************************
*************************************************************
*************************************************************

Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

64793fe6d7d04383a9a8fb96f972e0ef

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

*************************************************************
*************************************************************
*************************************************************
```

En donde lo esencial es la contraseña que nos da, ahora bien, como corrimos la imagen en un contenedor llamado jenkins usando el puerto 8080, entonces ingresamos a la pagina: 

Le damos a que instale los plugins requeridos, aunque si queremos mayor personalización podemos seleccionar los que queramos, al hacer click en usar los sugeridos tenemos: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2013.png)

Despues de la instalación (aunque pueden haber algunos problemas, igual viendo los logs vemos que todo se instala) Podemos ingresar y ver para poder crear un usuario del cual debemos acordarnos. 
Despues una vez adentro tenemos una vista como: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2014.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2015.png)

---

Ahora despues de esto es donde empieza el CI.

Vamos a tener que crear un repositorio con algun proyecto, en este caso sera springboot del mismo canal que estamos siguiendo el tutorial. Aunque también hay una serie de videos den la documentación que habla de este tipo de cosas:

[Best Practices](https://www.jenkins.io/doc/book/using/best-practices/)

Ahi observaremos como crear un jenkins en Github, Gitlab, Bitbucket. Luego estan las mejores practicas y muchisimas cosas extra.

Siguiendo el tutorial: 

Aqui creamos el repositorio, iniciamos con github de la forma de siempre: 

```bash
git init
git add .
git commit -m "Curso de Jenkins o que se yo xd" 
## Ahora vamos a hacer la integración en un repositorio, para esto usaremos github
## Cremos el repositorio. 
## y luego lo añadimos
git remote add origin
# Luego hacemos: 
git push -u origin master
# Si ya tienes configurado github, todo estpa bien.
```

Ahora crearemos un pipeline: 

Recordar que un pipeline es un conjunto de etapas o stages que realizan una acción “compleja” . 

Como primera instancia, en la documentación nos comentan algo interesante y es que los pipelines pueden ser escritos de dos maneras diferentes. Puede ser escrito tanto de manera declarativa o de forma de script. Ahora veremos dos ejemplos de ello. 

Anters que nada la documentación nos entrega el siguiente diagrama: 

![realworld-pipeline-flow.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/realworld-pipeline-flow.png)

Es un diagrama sencillo de entender, y podemos observar que al igual que github actions tenemos el poder del paralelismo. Tenemos las siguientes definiciones desde la documentacion:

### Pipeline:

Un Pipeline es un modelo definido por el usuario de un pipeline CD. El código de un Pipeline define todo tu proceso de construcción, que típicamente incluye etapas para construir una aplicación, probarla y luego entregarla.

### Node:

Un nodo es una maquina que es parte del entorno de Jenkins y es capaz de ejecutar un pipeline

### Stage

Un bloque `stage` define una conceptualización propia de los subconjuntos de tareas atravez de todo el pipeline (por ejemplo: “Build”,”Test” y “Deploy” stages)  que es utilizado por muchos plugins para visualizar o presentar el estado/progreso de Jenkins Pipeline.

### Step:

Es una sola tarea. Fundamentalmente, un step le dice a Jenkins que se quiere hacer en un punto particular del tiempo. Por ejemplo, para ejecutar el comando shell `make`, usa el `sh` step: `sh 'make'`. Cuando un plugin extiende el Pipelin DSL, que timipcamente significa que el plugin ha implementado un nuevo step

En los pipelines declarativos, se definen de la siguiente forma en un archivo Groovy: 

>Groovy file: | Declarativo

```groovy
pipeline {
    agent any // - |1| - 
    stages {
        stage('Build') { // - |2| -
            steps {
                // // - |3| -
            }
        }
        stage('Test') { // - |4| -
            steps {
                // // - |5| -
            }
        }
        stage('Deploy') { // - |6| -
            steps {
                // // - |7| -
            }
        }
    }
}
```

1. Ejecuta este Pipeline o cualquiera de sus etapas en cualquier agente disponible.
2. Define la etapa [stage] "Build" (Construcción).
3. Realiza algunos pasos [steps] relacionados con la etapa "Build".
4. Define la etapa [stage] "Test" (Pruebas).
5. Realiza algunos pasos [steps] relacionados con la etapa "Test".
6. Define la etapa [stage] "Deploy" (Despliegue).
7. Realiza algunos pasos [steps] relacionados con la etapa "Deploy".
</aside>

> Groovy file: | Scipted:

```groovy
node {  // - |1| -
    stage('Build') { // - |2| -
        // - |3| -
    }
    stage('Test') { // - |4| -
        // - |5| -
    }
    stage('Deploy') { // - |6| -
        // - |7| -
    }
}
```

En los pipelines de script, se requiere un bloque `node` para hacer el trabajo central a través de todo el Pipeline. Aunque no es un requerimiento obligatorio de la sintaxis del Pipeline con script, confinar el trabajo del Pipeline dentro de un bloque `node` hace dos cosas:

1. Programa los pasos contenidos dentro del bloque para ejecutarse agregando un elemento a la cola de Jenkins. Tan pronto como un executor esté libre en un nodo, los pasos se ejecutarán.
2. Crea un espacio de trabajo (un directorio específico para ese Pipeline en particular) donde se puede trabajar con archivos extraídos del control de origen.

**Precaución:** Dependiendo de tu configuración de Jenkins, algunos espacios de trabajo pueden no limpiarse automáticamente después de un período de inactividad.

Las etapas (`stage`) son opcionales en la sintaxis de Pipeline con script, pero implementarlas proporciona una visualización más clara de cada subconjunto de tareas/pasos en la interfaz de usuario de Jenkins.

Definiciones de cada parte numerada en el Pipeline con script:

1. Ejecuta este Pipeline o cualquiera de sus etapas en cualquier agente disponible.
2. Define la etapa "Build" (Construcción). Los bloques `stage` son opcionales en la sintaxis de Pipeline con script, pero su implementación proporciona una visualización más clara de cada subconjunto de tareas/pasos en la interfaz de usuario de Jenkins.
3. Realiza algunos pasos relacionados con la etapa "Build".
4. Define la etapa "Test" (Pruebas).
5. Realiza algunos pasos relacionados con la etapa "Test".
6. Define la etapa "Deploy" (Despliegue).
7. Realiza algunos pasos relacionados con la etapa "Deploy".
</aside>

En la imagen de la derecha 

Aqui observamos varias cosas importantes, primero encontramos al **User** que es quien se encargará de estar conectado al github, y crear de alguna forma, ya sea médiate un `push` o un `pull request`  o manualmente un **Trigger Build** Esto llama al Controlador de Jenkins que estará escuchando en un puerto, en la imagen vemos el puerto 50000 , luego de esto pasamos al punto numero 2 que es donde empieza a construir en el agente. Esto hace que se llame al 3cer paso que es donde Jenkins extrae todo el código y archivos desde github o el repositorio que queremos. En este Jenkins Agent vemos todo el proceso que hace, entonces tiene el código de Java, luego lo pasa por Maven (o gradle) para después empezar a construir el Jar. Esto genera dos cosas o un **Build Success** o un **Build Failed** , como vemos según sea el status se envía a Jenkins quien es el responsable de ya decidir mostrarnos que paso?.  

![jenkins-pipeline-flow.gif](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/jenkins-pipeline-flow.gif)

## Crear Items:

Uno puede crear tareas, trabajos, o ítems dentro de Jenkins, aqui vamos a hacer click en crear un nuevo ítem (a mi me sale con ese nombre), como podemos ver podes usar diferentes tipos de ítems, aqui usaremos el “estilo libre” en la documentación hay diferencias entre un estilo libre y un pipeline. Luego veremos eso.

Creamos el ítem y nos manda a un “general”

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2016.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2017.png)

Para esta prueba  usare un springboot mío, esperemos que funcione xd, el link es este: 

[https://github.com/Kgnot/Ajedrez](https://github.com/Kgnot/Ajedrez)

En el apartado de Jenkins debemos añadir unas credenciales que son las de github o el repositorio que se quiera, puede ser SSH, un secret, etc. 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2018.png)

Aquí solo debemos rellenar el username y password (dice que el password es el token generado)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2019.png)

Luego tenemos que añadir el comando que queremos que se ejcute al descargar todo el código de github

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2020.png)

Cuando yo le di crear me di cuenta de algo y es que el proyecto esta en java 18 y Jenkins corre Java17 entonces, la documentación de Jenkins nos sirve aqui. Primero vamos a : Dashboard > Manage Jenkins > Script Console. 

Aqui vamos a usar el siguiente script: 

```
/*** BEGIN META {
 "name" : "Check Nodes Version",
 "comment" : "Check the .jar version and the java version of the Nodes against the Master versions",
 "parameters" : [ ],
 "core": "1.609",
 "authors" : [
 { name : "Allan Burdajewicz" }
 ]
 } END META**/

import hudson.remoting.Launcher
import hudson.slaves.SlaveComputer
import jenkins.model.Jenkins

def expectedAgentVersion = Launcher.VERSION
def expectedJavaVersion = System.getProperty("java.version")
println "Master"
println " Expected Agent Version = '${expectedAgentVersion}'"
println " Expected Java Version = '${expectedJavaVersion}'"
Jenkins.instance.getComputers()
        .findAll { it instanceof SlaveComputer }
        .each { computer ->
    println "Node '${computer.name}'"
    if (!computer.getChannel()) {
        println " is disconnected."
    } else {
        def isOk = true
        def agentVersion = computer.getSlaveVersion()
        if (!expectedAgentVersion.equals(agentVersion)) {
            println " expected agent version '${expectedAgentVersion}' but got '${agentVersion}'"
            isOk = false
        }
        def javaVersion = computer.getSystemProperties().get("java.version")
        if (!expectedJavaVersion.equals(javaVersion)) {
            println " expected java version '${expectedJavaVersion}' but got '${javaVersion}'"
            isOk = false
        }

        if(isOk) {
            println " OK"
        }
    }
}
return;
```

Este nos genera la versión que nosotros usamos en este caso 21, y recordar que usamos las 21 solo porque lo dijimos en el DockerFile, ahi buscamos dentro del repositorio de Docker la que nos servia para nuestro entorno Java,  por otro lado si hay algun error etc, podemos seguir el video de la documentación: 

[Upgrading Jenkins Java Version From 17 to 21](https://www.youtube.com/watch?v=8xQVGpWeIe0)

Una vez creamos todo y le damos a start tenemos: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2021.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2022.png)

Aqui vemos el workpace que esta todo clonado

Para entrar al bash de donde estamos trabajando hacemos: 

```bash
docker exec -it jenkins /bin/bash
```

Con el comando de arriba pudimos entrar al bash. En console output podemos encontrar esto: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2023.png)

El comando desglosado: 

- `docker exec`: ejecuta un comando dentro de un contenedor que ya está corriendo.
- `it`:
    - `i`: mantiene la entrada estándar (stdin) abierta.
    - `t`: asigna una pseudo-terminal (como si estuvieras en una terminal real).
- `jenkins`: es el **nombre** o **ID** del contenedor donde quieres ejecutar el comando.
- `/bin/bash`: es el comando que quieres ejecutar dentro del contenedor (en este caso, abrir una shell Bash).

En la imagen vemos que el workspace se ejecuta en:  `/var/jenkins_home/workspace/project1-jenkins`  , entonces ahora nosotros etraremos a esos archivos: 

```bash
jenkins@08e08d648b04:/$ ls -la /var/jenkins_home/workspace/project1-jenkins
total 204
drwxr-xr-x 6 jenkins jenkins   4096 Apr 21 19:37 .
drwxr-xr-x 4 jenkins jenkins   4096 Apr 21 19:37 ..
drwxr-xr-x 8 jenkins jenkins   4096 Apr 21 19:37 .git
-rw-r--r-- 1 jenkins jenkins    490 Apr 21 19:37 .gitignore
drwxr-xr-x 3 jenkins jenkins   4096 Apr 21 19:37 .idea
-rw-r--r-- 1 jenkins jenkins 172810 Apr 21 19:37 Ajedrez.zip
-rw-r--r-- 1 jenkins jenkins   2707 Apr 21 19:37 pom.xml
drwxr-xr-x 3 jenkins jenkins   4096 Apr 21 19:37 src
drwxr-xr-x 7 jenkins jenkins   4096 Apr 21 19:37 target
```

aqui comprobamos que todo esto funciona. 

Ahora crearemos un pipeline usando Ngrok que es Ngrok ? →

**Ngrok** es una herramienta que permite exponer servicios locales (como servidores web, APIs o aplicaciones) a Internet de forma segura y temporal a través de túneles seguros. Cuando ejecutas un servicio en tu máquina local, **Ngrok** crea un túnel y genera una URL pública única que permite acceder a tu servicio desde cualquier lugar.

Las principales características de Ngrok incluyen:

- Túneles seguros con SSL/TLS
- Inspección de tráfico en tiempo real
- Redirección de puertos seguros
- Protección con autenticación básica
- Ideal para pruebas, demostraciones y desarrollo

También debemos tener un concepto claro y es que es un webhook git..

De forma rapida un webhook es una herramienta que permite enviar notificaciones a un servidor web externo cuando ocurren ciertos eventos en github. Más generalmente 

Un webhook es una notificación automatizada, como una "devolución de llamada HTTP", que se envía a una aplicación externa cuando ocurre un evento específico. En esencia, permite a una aplicación notificar a otra sobre un cambio o evento sin tener que sondear constantemente para obtener actualizaciones, facilitando la comunicación en tiempo real y la automatización de flujos de trabajo.

![apa-itu-webhook-zoho-assist-2022-08.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/apa-itu-webhook-zoho-assist-2022-08.png)

Podemos entrar también en determinar que es un Polling pero este no es el lugar. Aunque la imagen explica el concepto tal cual.

La idea aqui es , mediante Ngrok hacer visible a Jenkins, luego configurar un webhook en github , entonces aqui github enviará datos a un servidor es decir a Jenkins que estará disponible vía internet. Jenkins mediante un desencadenador automático va a detectar que le están enviando y el pipeline hará una serie de pasos y asi se hará la integración continua.  

Continuemos con Ngrok: 

Una vez estamos en la página vamos al apartado de docker:

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2024.png)

Aqui seguimos los pasos y terminamos con algo así . Hay que asegurar que pasemos el puerto 8080 para ello. 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2025.png)

Obtendremos una interfaz similar a la anterior. [También podemos instalar Ngrok si nosotros queremos en nuestro ordenador]. Ahora vamos a nuestro gihub en configuraciones, webhooks: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2026.png)

Y agregamos uno nuevo y colocamos lo que nuestro Ngrok tiene para nosotros: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2027.png)

Hay un apartado en el que nos dice que eventos quiere que pase, solo el push , todos o seleccionar? . Aqui podemos configurarlo a nuestra manera. 

Ahora haremos un push: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2028.png)

Después de hacer el push entonces vemos que en github se activo. A veces puede suceder errores, en mi caso hay que verificar de tener el plugin de Gihub en Jenkins y para mi caso la dirección url era: 

```bash
https://5e9b-186-168-241-114.ngrok-free.app/github-webhook/
```

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2029.png)

Ahora nos movemos a Jenkins en `Manage Jenkins > System`  nos encontramos con esta imagen: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2030.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2031.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2032.png)

Esos son los pasos a seguir :D. 

Ahora creamos un nuevo ítem en formato Freestyle project , en **General** habilitamos la marca de Github project y colocamos la url de nuestro proyecto, hacemos lo mismo en el apartado de **Source Code Management**  como ya hicimos antes, ahora en el apartado de **Triggers** activamos la casilla  GitHub hook trigger for GITScm polling , creamos los pasos como hicimos con anterioridad y guardamos , para ver este **trigger** en acción vamos a crear un push: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2033.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2034.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2035.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2036.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2037.png)

Aqui logramos observar que todo salio perfectamente, el trigger funcionó bien.

Esto es como lo básico a entender. 

Podemos hacer muchísimas cosas, realmente es necesario entender el sistema en general , podemos agregar plugins para crear una notificación directamente a Slack por ejemplo, debemos seguir : 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2038.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2039.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2040.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2041.png)

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2042.png)

__Para sonarqube: 

![image.png](src/Github%20Actions%20,%20Jenkins%20(CI%20CD)/image%2043.png)

En additional arguments, podemos usar `-X` . Esto después de seguir todos los pasos de SonarQube

Como vemos Slack ya nos da una serie de pasos, toca realizarlas y listo.

Podemos añadir tambien SonarQube que nos ayuda a verificar todo el código etc. 

## Crear un Pipeline:

El video se quedo re corto jajaj, vamos a leer lo que es la documentación.
Dentro de la documentación nos lo define como un conjunto de plugins que admiten implementar e integrar CD dentro de Jenkins (continuos delivery).
La documentación nos comenta sobre lo mismo que en github actions, pero más allá de eso dicen que la manera de definir un Pipelines de Jenkins es mediante un archivo `JenkinsFile` que a su vez puede ser comprometido al control de versiones del repositorio. Algo similar como los `DockerFile`
Nos habla sobre los beneficios de un `JenkinsFile`:
	- Automáticamente crear Pipelines de producción para todas las ramas y pull request.
	- Automatizar una revisión de código mediante un Pipeline.
	- Camino de pasos para el Pipeline
	- Una sola fuente de la verdad en los Pipelines que puede ser vista y editada por múltiples miembros de el proyecto.
Se puede hacer el Pipeline tanto de forma visual "UI" como en un archivo, un `JenkinsFile`. Aunque se consideran buenas prácticas el archivo.
Ahora, que diferencias hay entre un "Freestyle" y una "Pipeline". Como vimos anteriormente fueron solo proyectos "Freestyle", entonces: 
[Diferencia entre Pipeline y Freestyle](https://www.youtube.com/watch?embeds_referring_euri=https%3A%2F%2Fwww.jenkins.io%2F&source_ve_path=Mjg2NjQsMTY0NTAz&v=IOUm1lw7F58&feature=youtu.be)
Dentro del video se nos es creado las dos formas. 
En el primer ejemplo usamos los Freestyle , creamos 3 proyectos: f1, f2, f3 . Cada uno de estos hace una acción, por el momento es algo simple, como por ejemplo decir algo en el terminal, entonces:
- f1 dice "hola1"
- f2 espera o duerme por 60 segundos
- f3 dice "hola3"
Es algo simple y sencillo. Ahora pasa a hacerlo mediante los pipelines y mediante un apartado de código: 
``` Groovy
pipeline {
	agent any
	stages {
		stage('Hello1') {
			steps {
				sh 'echo hello'
			}
		}
		stage('sleep') {
			steps {
				sh 'sleep 60'
			}
		}
		stage('Hello2') {
			steps{
				sh 'echo hello2'
			}
		}
	}
}
```
Con este apartado de código recrea todo lo que anteriormente se hacía, todo en un mismo bloque. 
Luego nos habla de, entonces que diferencias hay? Nos comenta que una de las mayores diferencias es la durabilidad, esto se refiere a esa durabilidad de cuando se reinicia el controlador de Jenkins. Todos los trabajos de Jenkins esta corriendo, una vez el controlador se apaga, automáticamente se reinicia y empieza a correr desde donde lo dejaron. Por otro lado, los "Freestyle Jobs" no hace eso. Este lo demuestra matando a mitad de un "run" el servidor. Al volverlo a levantar, los "Freestyle" se quedan sin seguir nada mientras que el Pipeline muestra los siguientes logs: 
![Pasted image 20250423221140.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250423221140.png)
Aqui observamos que en un apartad de `Resuming build at Tue Feb 01 ...` es decir que vuelve a seguir ejecutando desde donde se dejo sin importar si se cierra el servidor.
Además de esto hay varios videos donde sigue explicando los conceptos en los que se diferencian, aunque básicamente:
> - **Durabilidad**: Pipelines sobreviven al apagado del servidor
> - **Pausable**: Los pipelines pueden parase y esperar algún input humano antes de completar el trabajo por el cual fue creado
> - **Versatilidad**:Estos entienden el mundo real de los requerimientos de CD, incluyendo la habilidad de `fork, join, loop` y trabajar en paralelo con algún otro Pipeline.
> - **Eficiencia**: Estos puede reestablecerse desde cualquier punto de guardado
> - **Extensible**:Tiene muchos plugins y extensiones customizadas que se puede integrar. 

Esas son los puntos en los que más se diferencia entre un Pipeline y un "Freestyle Job".

---
### Empezar con los pipelines
Como primera parte necesitamos unos requisitos, estos son: 
> - Jenkins 2.x o después, en versiones antiguas es posible no trabaje bien
> - El plugin del Pipeline el cual se instala en los "Plugins sugeridos"

Recordemos que hay dos maneras de crear un Pipeline, tanto de manera declarativa como de un script (Que hablamos arriba). Nos comenta los diferentes caminos en que un Pipeline puede ser escrito: 
- A través de Blue Ocean (que es la interfaz de Jenkins)
- A través del clásico UI
- En un SCM -> donde podemos escribir un `Jenkinsfile` manualmente que puede asegurar en tu repositorio.
### Empecemos con un Script: 
![Pasted image 20250424143638.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424143638.png)
Aquí vamos a Pipeline. 
![Pasted image 20250424152509.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424152509.png)
Vamos a ver algo similar a esto. Aqui podemos encontrar una descripción, aunque la parte más importante la encontramos como: 
![Pasted image 20250424152940.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424152940.png)
Aqui vemos un script que podemos modificar, entonces para crear un Pipeline de formato script podemos colocar: 
``` Groovy
node {
    stage('Results') {
        echo 'Hello world'
        
    }
}

```
Esto nos da a nosotros lo que ya hemos visto antes, un mensaje de "Hello world" en la consola. El output es el siguiente: 
![Pasted image 20250424153409.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424153409.png)
Como observamos tenemos quien empezó el Pipeline, El stage que corre, etc. Está toda la información ahi. 
Entonces ¿Cómo es la forma declarativa? es muy similar y ahora veremos que diferencias tienen: 
```Groovy
pipeline {
    agent any

    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
    }
}

```
Como vemos, son muy similares pero tenemos una diferencia y es que en la forma declarativa asignamos un `agent` que es una maquina virtual, luego en vez de dar por supuesto un apartado de pasos, aqui si los enumeramos, ahora bien, adentro colocamos cada uno de los pasos y ademas, le damos un nombre al paso. Ambos generan exactamente el mismo output. 
En la documentación hay mucha información sobre esto. 
### Y el JenkinsFile?
Para esto vamos a realizar los siguientes pasos, entrando en nuestro github y luego a opciones , vamos a `Developer settings` : 
![Pasted image 20250424155633.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424155633.png)
Y vamos al apartado de Personal Access Token en la cual creamos un Token (classic). 
![Pasted image 20250424155745.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424155745.png)
Le colocamos un nombre, como por ejemplo "Ajedrez Repository - Jenkins" , a continuación le brindamos todos los que necesitamos, en nuestro caso: 
![Pasted image 20250424160152.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424160152.png)
Nos da un token, en este caso es un token semanal y toca guardarla porque solo se muestra una sola vez. 
ahora vamos al repositorio y vamos al apartado de Webhooks que hemos ya visto y enlazamos al servidor de Jenkins. 
Ahora en nuestra carpeta de archivos vamos a crear el archivo Jenkins:
``` Groovy
pipeline {

    agent any
    // Este apartado de tools coje lo que se esta por predeterminado en el servidor de Jenkins, como lo tenemos global no lo ponemos, pero es algo a tomar en cuenta
    tools {  
        maven 'Maven 3.6.3'
        jdk 'JDK 18'
    }

    stages {
        stage ('Checkout') {
            steps {
                git 'https://github.com/Kgnot/Ajedrez.git'
            }
        }
        stage ('Test') {
            steps {
                echo 'Ejecutando pruebas...'
            }
        }
        stage ('Build') {
            steps {
                echo 'Construyendo el proyecto...'
                sh 'mvn clean package'
            }
        }
    }
     post {
        success {
            echo '¡Build completado con éxito!'
        }
        failure {
            echo 'Ocurrió un error en el pipeline.'
        }
    }
}
```
Después de esto ya podemos subirlo a nuestro repositorio: ![Pasted image 20250424164302.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424164302.png)
Ahora entramos en nuestro Servidor de Jenkins y que me cree una tarea. Esta tarea va a ser la siguiente, creamos una nueva Pipeline y le configuramos lo siguiente: ![Pasted image 20250424165005.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424165005.png)
Como nuestro Jenkins esta enlazado con nuestro github entonces no nos genera error y no es necesario el token de acceso, de lo contrario o normalmente se coloca el token de acceso en el repositorio de esa forma, es decir -> `https://<token>@github.com/Kgnot/Ajedrez#` 

> ==Como anotación importante, el archivo se llama "JenkinsFile" no "JenkinsFile" , error mío.==

Ahora, después de hacer todo eso, solo debemos correr el Pipeline que inmediatamente aparecerá:
![Pasted image 20250424170255.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424170255.png)
Esto significa que pudo identificar el archivo ==Jenkinsfile== y podemos ver al final: 
![Pasted image 20250424170406.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424170406.png)![Pasted image 20250424170424.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424170424.png)![Pasted image 20250424170430.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424170430.png)

Cada una de los pasos que realizo y como todo quedó bien. Podemos tambien entrar a cada uno de los nodos y revisar como lo hizo, etc. 

Recordemos que nosotros activamos lo que era que escuchara los trigers de github, entonces, si hacemos un push por ejemplo: 
![Pasted image 20250424171726.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424171726.png)
![Pasted image 20250424172539.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424172539.png)
Aqui vemos que la corre y si vamos al github: 
![Pasted image 20250424172604.png](src/Github%20Actions%20%2C%20Jenkins%20%28CI%20CD%29/Pasted%20image%2020250424172604.png)
Entonces entendemos como es el flujo de todo esto.
> Como una nota adicional, tenemos que tener en cuenta que si hacemos Ngrok de forma local o un formato local, siempre hay que estar actualizando el webhook ya que este no siempre es el mismo al desplegarse 

Siendo no más, hasta aqui el curso introductorio de CI/CD de github actions y Jenkins usando videos y documentación.

---
Quizá algún termino que podemos ver es este: SCM 
En el contexto de **Jenkins** y los **Pipelines**, **SCM** significa **Source Control Management** o también conocido como **Version Control System (VCS)**.
#### ¿Cómo se relaciona con Jenkins?
Cuando configuras un **Pipeline** en Jenkins, muchas veces le dices:

> “Ey Jenkins, el código está en este repositorio Git. Cuando haya un cambio, haz esto…”

Ahí es donde entra **SCM**. Jenkins **se conecta a tu repositorio de código** (SCM) y desde ahí empieza a trabajar: compilar, probar, desplegar, etc.
##### En español simple:

Es **el sistema que se encarga de guardar, versionar y gestionar el código fuente de tu proyecto**.

---

# Jenkins v2: 

Ahora vamos a tocar jenkins para manejar un sistema de trabajos, vamos a automatizar su verificación de código usando sonarQube y vamos a separarlo de la mejor forma: 
![[Pasted image 20260314185245.png]]


Primero entrando a la suite de Jenkins



# Bibliografía
- [GitHub Actions documentation - GitHub Docs](https://docs.github.com/en/actions)
- [Marketplace](https://github.com/marketplace)
- [Checkout - GitHub Marketplace](https://github.com/marketplace/actions/checkout)
- [Running variations of jobs in a workflow - GitHub Docs](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/running-variations-of-jobs-in-a-workflow)
- [Caching dependencies to speed up workflows - GitHub Docs](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/caching-dependencies-to-speed-up-workflows)
- En el canal de midudev sobre Github Actions
- [Jenkins Bibliografía](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/)
- [Curso Completo de Jenkins Para Principiantes con Docker, Git, Spring Boot, Slack y SonarQube](https://www.youtube.com/watch?v=LZDmM_t4XRg)
- [Canal de YouTube sobre Jobs con Jenkins y JenkinsFile](https://www.youtube.com/watch?v=mnuEWQuWNeo)
