# Git

Git es un controlador de versiones de cualquier cosa, especializado básicamente en código.

Una de los primeros comandos encontrados es el : `ls` : 

![image.png](src/Git/image.png)

Nos permite ver todos los archivos o ficheros que nosotros tenemos, para movernos a alguno de estos directorios es con el comando `cd` .

![image.png](src/Git/image%201.png)

Como vemos pudimos cambiar de fichero atras usando `cd ../` que básicamente es cambiar de vista.

Para saber cuál es la ruta en la que me encuentro uso : `pwd` .

![image.png](src/Git/image%202.png)

Para crear una carpeta usamos el comando `mkdir "__nombre_carpeta__"`  de esa forma

Con el comando `. code` abrimos visual studio normalmente.

Ahora entrando en lo que son los comandos de Git tenemos a `git init` que se encarga de crear un sistema de versionado de código o de ficheros básicamente. Luego tenemos lo que son las ramas en github, aqui usamos, para crear una rama `git branch "__nombre_rama__"`  , para movernos entre reamas usamos `git checkout "__nombre_rama__"` , una manera rápida de crear una rama y moverse es `git checkout -b "__nombre_rama__"` .  Ahora vamos con `git add <file>` que lo que hace es agregar o añadir los elementos y guardarlos, es como crear una primera fotografía, con `git status` miramos algunas cosas importantes de git como por ejemplo, si hay ficheros etc. Ahora `git commit -m "__comentario__"`  guarda la fotografía preparada en `git add <file>` . Luego de todo esto como hacemos para saber que se ha hecho?  si se ha guardado o no, que ha pasado?, aquí usamos `git log` que muestra:

![image.png](src/Git/image%203.png)

Aquí podemos observar el commit hecho, luego el código hash y después el autor del commit , el autor, la fecha y por último el mensaje puesto. Con `git status` vemos: 

![image.png](src/Git/image%204.png)

Existen mas alternativas dentro de log, en este caso tenemos `git log --graph` que nos muestra:

![image.png](src/Git/image%205.png)

Que es lo más parecido a una rama.

Podemos crear alias , por ejemplo: `git config --global alias.tree "log --graph --decorate --all --online"`  esto hace que nosotros podamos usar `git tree` como un alias de todo lo anterior

---

Si nosotros no queremos que a un fichero le tomemos una fotografía , podemos usar un `.gitignore` que es un archivo en el que ponemos todos los tipos de ficheros que queremos que se ignore en la fotografía. Para crearlo usamos `touch .gitignore` aqui podemos colocar algo como:

```bash
**/.DS_Store 
```

Aqui decimos que cualquier fichero que tenga ese nombre dentro del proyecto ignórelo.

---

Teniendo en cuenta el concepto de rama nace el siguiente comando, a veces necesitamos saber que diferencias hay entre ramas?, usamos `git diff` con esto sabemos que cambios hemos hecho desde le último commit. 

También podemos desplazarnos entre commits hechos, podemos hacer un `git checkout <hash_commit>`  este hash lo determinamos con `git log` , con esto logramos visualizar el estado del commit al que fuimos, para posicionarnos ahi necesitamos ahora apuntar ahi, para eso usamos `git checkout HEAD` esto nos ayuda a establecernos en un commit que antes solo veíamos. 

---

Vamos a ver el comando `git reset` este comando en primera instancia hace que los cambios hechos después no valgan, es decir, resetear desde un commit anterior, ahora podemos entrar en `git reset --hard <commit>` que lo que hace es “borrar” todos los commits después del que nos estamos posicionando, visualmente podemos hacer: 

![image.png](src/Git/image%206.png)

![image.png](src/Git/image%207.png)

El la primera imagen vemos todos los commits, en la segunda hacemos un `git reset --hard <commit>` ,  como vemos “elimina” todos los commits después, sin embargo si hacemos `git checkout cd71041` hacemos que nuestro `<HEAD>` este en el commit “adelantado” al `<MAIN>` , es decir: 

![image.png](src/Git/image%208.png)

Entonces nosotros podemos hacer el comando `git reset cd71041` y se reestablece todo lo que teníamos anteriormente. Sin embargo el comando `git reset --hard <commit>` sirve mucho para “borrar” los cambios que no sirvieron. 

También encontraremos un comando como `git reflog` que nos da todo lo que hemos realizado: 

![image.png](src/Git/image%209.png)

De abajo hacia arriba vemos, el commit inicial, luego que hemos movido la cabeza, hemos hecho `checkout` etc. y al final vemos como hemos hecho un `reset` .

Otro nuevo concepto es el apartado de los tag , un tag almenos en programación hace referencia a una versión especifica o algo que quiero señalar y que es importante. Para eso existe el comando `git tag <nombre>` en el cual podemos crear un tag para un sistema general visualmente: 

![image.png](src/Git/image%2010.png)

podemos mirar el listado de tags usando `git tag` a secas, de esta forma: 

![image.png](src/Git/image%2011.png)

Me aparecen todos los tags que he colocado. Para movernos entre tags es tan facil como usar un `git checkout tags/<nombre_tag>` , así colocamos el `HEAD` en un tag, o nos movemos: 

![image.png](src/Git/image%2012.png)

Así ya no tendremos que mirar el id o hash del commit, así es más sencillo.

---

Seguimos mirando el apartado de git y una de sus cosas más potentes es la idea de rama o “branch” en ingles. La cual nos hace crear de otro punto una forma de trabajar en los mismos ficheros pero sin mezclarlos, para eso usamos dos comandos: `git branch <nombre_rama>`  para crear la rama y `git switch <nombre_rama>`  para movernos a esa rama, asi queda: 

![image.png](src/Git/image%2013.png)

Aquí observamos como `HEAD` esta apuntando directamente a `login` que es la nueva rama que se creo, pero no esta apuntando a `main` que es la que hemos trabajado desde siempre. Visualmente: 

![image.png](src/Git/image%2014.png)

Ahora hablando del concepto de ramas es importante adentrarnos a algo llamado `merge` que tiene que ver con combinar dos ramas.

Imaginemos que estamos trabajando en la rama `login` y alguien hace cambios dentro de la rama `main` , entonces queremos traer esos cambios de la rama `main` a la rama `login` , por lo que nosotros, estando en la rama `login` hacemos el siguiente comando: 

`git merge main`  genéricamente sería `git merge <rama_a_combinar_en>`  , al hacer ese comando entonces añadimos quedando gráficamente de esta forma: 

![image.png](src/Git/image%2015.png)

Aqui vemos como después de un cambio en main sacamos un commit en `login` donde hemos combinado todo lo que ha sucedido en `main`. 

---

Esto nos crea un nuevo concepto que son los conflictos dentro de Git. Los conflictos ocurren cuando se tocan dos líneas de código , entonces git nos dice que no se puede, que hay dos versiones diferentes de la misma línea. Entonces aqui nosotros decidimos que hacer? eliminamos el nuestro y traemos la que queríamos del `merge`. Cabe aclarar que estos conflictos de versionado de ficheros ocurre cuando se intenta hacer un `merge` de un lugar a otro. Al final el flujo de trabajo quedaría de la siguiente forma: 

![image.png](src/Git/image%2016.png)

Aqui vemos el conflicto en pantalla, luego de resuelto podemos graficarlo : 

![image.png](src/Git/image%2017.png)

---

Ahora miraremos otro problema, por ejemplo, si debo moverme de rama pero no quiero guardar lo que tengo en un commit porque aun hay errores, no he manejado cosas bien o aun estoy en fase de prueba que no merece un commit uso un `git stash` .

![image.png](src/Git/image%2018.png)

Para mirar los listados de los `stash` que manejo entonces uso el comando `git stash list` . Ya después de esto es posible cambiar de rama, por ejemplo ir a la `main` y hacer algo que necesitaba hacer. En el momento en que vuelvo con un `switch` a la rama en la que hice el `stash` no aparece el cambio, entonces una vez posicionado en la rama donde en teoría está el `stash` para recuperar ese guardado de forma temporal `git stash pop` lo que me genera un mensaje como: 

![image.png](src/Git/image%2019.png)

Una vez acabado el `stash`  puedo hacer el `git add .` y el commit de siempre. Si al final yo quiero eliminar el `stash` hago un `git stash drop` y elimino lo que estaba en el `stash`

---

Cuando una rama ya no aporta nada, podemos eliminar esa rama, ¿Cómo la eliminamos? la manera más sencilla es usar el comando `git branch -d <nombre_rama>` . Las ramas son “temporales” 

---

Ahora tenemos que ver como es la integración con github, vamos a ir a esta página :

[Configuración de Git - Documentación de GitHub](https://docs.github.com/es/get-started/git-basics/set-up-git)

Aqui entenderemos como se sube la clave SSH y se configuran las claves etc.

Luego de esto creamos nuestro repositorio en Github normalmente y a partir de ahi tenemos algunos comandos que nos dan. Github nos ayuda dándonos: 

![image.png](src/Git/image%2020.png)

Con esto podemos observar que usa un comando llamado `git remote add origin git@github.com:<nombre_cuenta>/<nombre_repositorio>.git` , y luego hacemos un `git push -u origin main` este comando es el inicial para manejar los repositorios de github donde subiremos todo lo local a remoto.

Ahora entramos en otros dos comandos que son importantes, esta el `git fetch` que descarga el historial pero no los cambios y `git pull`que descarga el historial y los cambios.

---

Hay tres conceptos importantes ahora que entramos en github . 

Tenemos a `git clone`  que se puede mediante `ssh` ,`https` . Nos permite clonar una repositorio y si tenemos permisos, poder modificar lo que nosotros queramos. 

Tenemos también los famosos `fork` que son necesarios cuando queremos clonar todo un repositorio a el nuestro y desde ahi hacer algunos cambios, etc. 

Por último tenemos lo que son los `pull request` o los famosos `pr` que lo que hacemos es mandar una petición de que nuestro código que hicimos `fork` sea combinado o `merged` dentro del repositorio principal. Mandamos un `pr` desde nuestro **Head repository** a el **Base repository .**

Nosotros también podemos  manejar los errores o conflictos dentro de los `pr` , esto se maneja normalmente en github ya que es una herramienta propia de github.

## Hablando de los flujos de trabajo tenemos el siguiente articulo:

[Gitflow Workflow | Atlassian Git Tutorial](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)

Aqui nos menciona lo que es Gitflow, inicia diciendo que es una alternativa al manejo de modelado de ramas de git, básicamente implica el uso de ramas de nuevas características o features y múltiples ramas primarias. Gitflow tiene numerosas y vividoras ramas y muchos commits. Bajo este modelo los desarrolladores crean ramas de características que retrasan su fusión con la rama principal. Estas ramas de características de larga duración tienen mayor colaboración y un pequeño riesgo de desviarse de la rama principal; y también puede introducir actualizaciones conflictivas.

### Como esto funciona? :

![image.png](src/Git/image%2021.png)

Introduce el termino de `Main` y `Develop` en el cual vemos como usamos `tags` dentro de `Main` para de esta manera crear el versionado de la aplicación mientras que en la rama `Develop` hace todo lo necesario.

Nos da dos comparaciones, como se haría esto sin git-flow :

```bash
git checkout develop
git push -u origin develop
```

En vez, usando la librería de Gitflow, ejecutamos el comando `git flow init`  en un repositorio existente y creará la rama `develop` .

### Características de las ramas:

Como primer paso tenemos que crear el repositorio. Y nos dice que consideremos cada nueva feature o característica nueva de la aplicación como una rama extra dentro de la rama `Developer`, asi generando el siguiente diagrama: 

![image.png](src/Git/image%2022.png)

Y ahora va la comparación, entonces, como sería sin ninguna extensión de git-flow :

```bash
git checkout develop
git checkout -b feature_branch
```

y usando la extensión solo tendríamos que colocar: 

```bash
git flow feature start feature_branch
```

Y cuando terminamos una rama de alguna característica debemos: 

```bash
git checkout develop
git merge feature_branch
```

Mientras que con la extensión: 

```bash
git flow feature finish feature_branch
```

### Release branches

En este apartado es una rama que abrimos desde la rama `Developer` para efectuar un pequeño cambio o ajustar cosas que van a pasar a producción , esta rama lo que hace es que al momento de que se cierre, va a combinarse con la rama `main` , crea un tag sobre esa rama y se cierra sobre la rama `Developer`

![image.png](src/Git/image%2023.png)

Ahora vamos a ver las diferencias de usar git-flow y no usarlo: 

Sin usar git-flow: 

```bash
git checkout develop
git checkout -b release/0.1.0
```

Usando la extensión de git-flow:

```bash
git flow release start 0.1.0 
```

Y al finalizar debemos hacer: 

```bash
git checkout main
git merge release/0.1.0
```

usando git-flow:

```bash
git flow release finish '0.1.0'
```

### Hotfix branches:

Aqui empezamos a usar el término de Hotfix en el cual quiere decir de por ejemplo: Encontramos un error en producción y debemos arreglarlo rápidamente hacemos un hotfix . El diagrama corresponde con:

![image.png](src/Git/image%2024.png)

Y ahora vienen las comparaciones: 

Sin usar la extensión de git-flow: 

```bash
git checkout main
git checkout -b hotfix_branch
```

Usando la extensión de git-flow: 

```bash
git flow hotfix start hotfix_branch
```

Y algo similar cuando finalizamos: 

```bash
git checkout main
git merge hotfix_branch
git checkout develop
git merge hotfix_branch
git branch -D hotfix_branch
```

Mientras que si usamos la extensión git-flow:

```bash
git flow hotfix finish hotfix_branch
```

---

Debemos ponernos a hacer proyectos y entender más todo esto que es de git, github y git-flow. 

Ahora vamos a abordar dos comandos de git que mucha gente le tienen una espina

`git cherry-pick`, `git rebase` , el `cherry-pick` es la posibilidad de obtener un commit concreto a la rama que queramos.

`git rebase` es para traernos una rama a un punto concreto y casi modificar el historial de commits

## Git Cherry-Pick y Rebase en detalle

### Cherry-Pick

El comando `git cherry-pick` permite tomar un commit específico de cualquier rama y aplicarlo en la rama actual. Es como "copiar y pegar" un commit específico.

Ejemplo de uso:

```bash
git cherry-pick abc123
```

Casos de uso comunes:

- Cuando necesitas traer un `fix`específico de una rama a otra sin hacer `merge` completo
- Para recuperar commits perdidos después de un mal `merge`
- Cuando quieres aplicar un cambio específico de una rama feature a main sin traer todos los cambios

### Git Rebase

El `git rebase` reorganiza el historial de commits, moviendo un conjunto de commits a una nueva base. Es como "trasplantar" una rama a otro punto de la historia.

Ejemplo de uso:

```bash
git checkout feature
git rebase main
```

Casos de uso comunes:

- Mantener una rama feature actualizada con los últimos cambios de main
- Limpiar el historial de commits antes de hacer un merge
- Reorganizar commits para tener un historial más limpio y lineal

**¡Importante!** Nunca uses rebase en commits que ya han sido compartidos en el repositorio remoto, ya que esto puede causar conflictos para otros desarrolladores.

### Diferencias clave

Mientras que cherry-pick se usa para mover commits específicos, rebase se utiliza para reorganizar series completas de commits. Cherry-pick es más seguro para usar en ramas compartidas, mientras que rebase debe usarse con precaución en trabajo colaborativo.

# Comandos totales:

- `ls`: Abrir sistema de archivos o ficheros
- `cd` : Moverme en el sistema de archivos o ficheros
- `pwd` : Para saber la ruta de en donde me encuentro
- `mkdir`: Para crear una carpeta
- `git init`: Para empezar o iniciar el versionado de ficheros
- `git branch "__new_rama__"` : Para crear una rama dentro de nuestro versionado de ficheros
- `git chekcout "__rama__"`   : Para posicionarse a una rama
- `git checkout -b`  : Para crear una rama y posicionarse allí
- `git add <file>` : Para tomar una fotografía o guardar los elementos o ficheros de ese momento actual, en otras palabras las prepara.
- `git status` : Que sucede con cada fichero?
- `git commit -m "__mensaje__"` : Es una forma de guardar lo preparado en `git add <file>` , necesita un mensaje o comentario
- `git log`: Nos da información de todo lo que se ha hecho en la rama
- `git log --graph` : Para dar una noción de rama en consola , y hay más por ejemplo `git log --graph --all -oneline` y nos da algo más reducido
- `git config --global alias.<nombre_alias> "<comando_alias>"` : Esto crea un alias que ejecuta el comando cuando llamamos al nombre del alias puesto
- `git diff` : Sabemos que cambios hemos hecho desde el último commit, también podemos hacer un `git diff <nombre_rama>` , esto hace que podamos comprar dos ramas, la que estoy apuntando o en la que me posiciono con la que estoy agregando en el comando.
- `touch <nuevo_archivo>` : Usamos este comando para crear un nuevo archivo como en `.gitignore` explicado en el documento .
- `git checkout <hash_commit>` : Con esto podemos solo ver un commit viejo
- `git checkout HEAD`: Con esto hacemos que apuntemos a la rama en la que estamos
- `git checkout HEAD -- archivo` : Descarta cambios locales de ese archivo.
- `git checkout HEAD .` : Descarta cambios locales en todos los archivos.
- `git reset --hard <hash_commit>` : Nos coloca el `MAIN` en el commit asignado “eliminando” los commits después de ese
- `git reset --soft <hash_commit>` : Mueve el puntero del `MAIN` al commit indicado y los cambios los mantiene pero los prepara para un nuevo commit.
- `git reset --mixed <hash_commit>` : Mueve el puntero de la rama `MAIN`  a el commit indicado, sirve para deshacer commits y volver a pensar que archivos preparo.
- `git reflog`: Sirve para ver todos los cambios hechos en un versionado de ficheros.
- `git tag <nombre_tag>` , `git tag` : Estos dos comandos nos ayuda a colocar o crear tags en momentos importantes de nuestro sistema de versionado de ficheros, el primero crea los tags, el segundo nos hace verlo y usando `git checkout tags/<nombre_tag>`  podemos desplazarnos allí fácilmente.
- `git merge <rama_a_combinar_en>` : Se usa para combinar dos ramas, posicionados en una , usamos el comando para obtener los nuevos datos de la rama llamada en `merge` a la rama en la que nos encontramos.
- `git stash` ,`git stash list` , `git stash pop`, `git stash drop`: Esto sirve para crear “commits” temporales a la hora de cambiar de una rama, etc. Útil para guardar algo mientras me muevo a otra rama, uso `git stash pop` para volver a donde esta el `stash` o `git stash drop` para eliminar lo que estaba haciendo.
- `git remote add origin ___` : El apartado de `remote` nos permite comunicarnos con repositorios que están en la nube como github, gitlab, etc. El `add` hace que le añadamos un nuevo repositorio remoto al proyecto y `origin` es el nombre que le damos al remoto.
- `git push origin main` : Con esto subimos lo local a remoto.
- `git pull origin main` : Aqui se usa para bajar los cambios de remoto a local.