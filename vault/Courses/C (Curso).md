Este curso estará dirigido a específicamente C. 

# Mapa mental:

En lenguajes como Python, Java o Javascript, uno le pide al intérprete o a la máquina virtual: "Oye dame esta lista y méteme estas cosas". Y ellos se encargan de todo: 
- Buscar un espacio en la  memoria
- guardarlo
- limpiarlo
En C somos nosotros quienes hacemos eso.
- Le pedimos la memoria explícitamente:  `malloc()`,`calloc()`
- Decidimos exactamente que poner ahí con estructuras o punteros
- Y lo más importante, necesitamos liberar la memoria al no necesitarla `free()`

En C hay estructuras, a diferencia de otros sistemas de programación. El equivalente a la clase es la `struct`. La manera de usarse es: 

```c

struct punto {
	int x;
	int y;
}

// y podemos crear un punto :
struct Punto mi_punto;
mi_punto.x = 10;
mi_punto.y=20;
```

### Cómo "Diseñar" en C: De Abajo a Arriba (Bottom-Up)

Si vienes de lenguajes con clases, probablemente piensas en términos de objetos que interactúan.

En C, el diseño suele ser más de abajo a arriba:
1. **Define tus datos:** ¿Qué información necesitas manejar? Ahí van tus `struct`. Un `struct` para un cliente, otro para un producto, etc. A veces tendrás `struct` que contienen otras `struct`.
2. **Define las operaciones básicas:** Para cada `struct`, piensa en las funciones fundamentales que las manipulan: `cliente_nuevo()`, `cliente_guardar()`, `producto_calcular_precio()`. Normalmente, la primera función es una que reserva memoria e inicializa la estructura (un "constructor" artesanal) y otra que la libera (un "destructor").
3. **Construye la lógica:** Usa tus tipos de datos y funciones básicas para construir la lógica de nivel superior.



# Conceptos de C

Aqui damos por hecho que se sabe todo lo relacionado a estructuras básicas como `if`, `for`,`while`, `do-while`. Ya contando con eso, vamos a ver desde punteros, y cosas mas enfocadas en el lenguaje, el tema de variables entraremos en especificas, no en las mismas de `int`, `char`, `boolean`,etc.

## Puntero: 
Un puntero es una manera en la que podemos guardar una dirección de memoria, el puntero se declara del tipo del cual contiene el espacio de memoria a donde va a apuntar. Para esto necesitaremos una tabla que podemos encontrar en cualquier lugar, es la siguiente. (es para el tema del `print`).

| Tipo      | Formato     |
| --------- | ----------- |
| int       | `%d` o `%i` |
| char      | `%c`        |
| puntero   | `%p`        |
| dirección | `%p`        |

```c
#include <stdio.h>

int main(void) {
    int a = 2;
    int *i = &a;

    printf("Valor apuntado: %d\n", *i);
    printf("Valor directo: %d\n", a);
    printf("Direccion: %p\n", (void*) i);

    return 0;
}

```

Aqui especificamos una variable a que se guarda en algún lugar de nuestra memoria RAM. Y luego especificamos una variable puntero del mismo tipo del que es a donde guardamos la referencia a esa variable. 

Luego al imprimirlas, generamos el valor, como vemos para imprimir el valor imprimimos el puntero como tal porque este apunta a lo que está adentro de esa dirección. : 
![[Pasted image 20260217225706.png]]

Nosotros casteamos por comodidad, ya que el especificador: `%p` espera un argumento de tipo `void *`

El tema de los punteros también nos ayuda a cambiar la variable interna que hay en la dirección de memoria, la idea es pasarla como puntero: 
```c
#include <stdio.h>  
  
void cambiar(int *);  
  
int main(void) {  
    int a = 2;  
  
    int *i = &a;  
  
    printf("%d\n", *i);  
    printf("%i\n", a);  
    cambiar(i);  
    printf("%i\n", a);  
  
    return 0;  
}  
  
  
void cambiar(int *a) {  
    *a = 5;  
}
```
Esto nos genera 5 como print final, y así pudimos cambiar en una función externa lo que es una variable.

==Algo que no se menciona pero hacer `int *a` crea un puntero de tipo int, y cuando hacemos `*a = ...` estamos desreferenciando al puntero, es decir, extrayendo lo de adentro. ==

### Punteros genericos

Un puntero generico es u puntero de solo lectura que puede apuntar a cualquier tipo de dato sin poder modificarlo. Es súper común en funciones que trabajan con datos "desconocidos".
```C
const void *a;
```
- `void *`: Puntero **genérico** (puede apuntar a int, char, struct, etc.)
- `const`: **No puedes modificar** los datos apuntados (*a = 5; → error)
- `a`: Nombre de la variable puntero

**¿Por qué "void"?** Porque no sabe ni le importa qué tipo contiene —¡es como una caja misteriosa!

ejemplo: 

```C
#include <stdlib.h>
#include <stdio.h>

int cmp_int(const void *a, const void *b) { 
    return (*(int*)a - *(int*)b);
}

int main() {
    int numeros[] = {64, 34, 25, 12, 22, 11, 90};
    qsort(numeros, 7, sizeof(int), cmp_int);
    
    for(int i = 0; i < 7; i++)
        printf("%d ", numeros[i]);  // 11 12 22 25 34 64 90
}

```
lo que pasa dentro de la función `cmp_int`:
```C
int cmp_int(const void *a, const void *b) {
    int va = *(int*)a;  // "Convierto" void* → int*
    int vb = *(int*)b;  // "Convierto" void* → int*
    return (va - vb);
}

```

| Expresión  | Tipo Resultante | Significado        |
| ---------- | --------------- | ------------------ |
| `a`        | `void*`         | Dirección sin tipo |
| `(int*)a`  | `int*`          | **Puntero a int**  |
| `*(int*)a` | `int`           | **El valor int**   |

## Structs:
Structs agrupan datos relacionados lógicamente. Son piedra angular de C para datos completos y hardware. 
Su sintaxis básica: 
```C
struct Nombre {
	tipo1 miembro1;
	tipo2 miembro2;
};

struct Nombre var; // variable

typedef struct {...} Alias; // este es el recomendado
```
Podemos crear Structs anidados: 
```C
typedef struct {
    int x, y;
} Punto;

typedef struct {
    Punto pos;    // Anidado
    int vida;
} Enemigo;

Enemigo e = {{10, 20}, 100};  // Inicialización
e.pos.x = 15;                 // Acceso anidado
```

Algo a tener en cuenta y es importante es el Padding y Alineación: 
El compilador agrega bytes vacíos para alinear en hardware, entonces: 
```C
#include <stdio.h>  
  
typedef struct {  
    char a;  
    int b;  
    char c;  
} Ejemplo;  
  
typedef struct {  
    int b;  
    char c;  
    char a;  
} Ejemplo2;  
  
int main() {  
    printf("Tamanio: %lu ", sizeof(Ejemplo));  
    printf("Tamanio: %lu", sizeof(Ejemplo2));  
    return 0;  
}
```
El resultado de esto es: 
```bash
/home/kgnot/CLionProjects/practica/cmake-build-debug/practica
Tamanio: 12 Tamanio: 8
Process finished with exit code 0
```

Como podemos observar tenemos dos tipos de tamaño diferente para esto, y además, veremos a futuro, podemos usar que evite completamente el padding: 
```C
#pragma pack(1)  
typedef struct {  
    char a;  
    int b;  
    char c;  
} Ejemplo3;
#pragma pack()
```
Esto nos genera el siguiente resultado: 
```bash
Tamanio E1: 12 
Tamanio E2: 8 
Tamanio E3: 6 
```
Ahora como vemos el tamaño es de 6, lo cual es muchísimo más óptimo.  El orden óptimo es: ==Mayor -> menor tamaño==
### Structs anónimas: 
Las structs anónimas son simplemente una struct que lo único que hace es declarar una variable específica según una estructura. Por ejemplo: 
```C
#include <stdio.h>  
  
struct {  
    unsigned short icon: 8;  
    unsigned short color: 4;  
    unsigned short underline: 1;  
    unsigned short blink: 1;  
} screen[25][80];  
  
int main() {  
    screen[0][1].color = 1;  
    printf("screen [0][1] -> color : %d", screen[0][1].color);  
    return 0;  
}
```
Simplemente, define el formato y declara una variable con un nombre.
### Bitfields: 
Cuando vimos las structs anónimas vimos que hay un número después de cada elemento del struct, esto nos indica la cantidad de bits que necesitamos, por lo que en total usamos 14 bits para la declaración de la strcut anterior.
Muy típico en:
- Drivers
- Hardware
- Control de flags
- Simulación de memoria de video

Los bitfields:

- No tienen layout garantizado por el estándar.
- El orden de bits depende del compilador.
- No son portables entre arquitecturas distintas.
- Pueden generar código ineficiente.

Por eso en sistemas críticos muchas veces se prefiere:`uint16_t value;` y manipular bits con máscaras: 
`value |= (1 << 3);`.
Más control y más portables

***
Este es un detalle que no entedí tanto, pero lo entenderé al volver: 
Accede **bits individuales** de registers hardware.

```c
typedef struct {
    unsigned enable : 1;     // 1 bit
    unsigned modo    : 2;    // 2 bits (0-3)
    unsigned reserva : 5;    // Padding bits
    unsigned valor   : 24;   // 24 bits
} Registro;  // Total: 32 bits = uint32_t
```

**Uso hardware:**
```c
Registro *reg = (Registro*)0x40000000;  // Dirección register
reg->enable = 1;                        // Bit 0 = 1
reg->modo = 2;                          // Bits 1-2 = 10
```
`

**¡Perfecto para UART, GPIO, timers!** Padding implementation-defined
***
### Union

Estos comparten la misma memoria. 
```c
union Datos {
    int i;
    float f;
    char c[4];
};  // sizeof=4 bytes

union Datos d;
d.i = 65;
printf("%c\n", d.c[0]);  // 'A'
```

Un ejemplo general de un struct: 
```c
// Sensor struct
typedef struct __attribute__((packed)) {
    uint16_t temperatura : 12;
    uint16_t humedad     : 12;
    uint8_t checksum     : 8;
} LecturaSensor;  // Exacto 4 bytes para protocolo

// Array para buffer DMA
LecturaSensor buffer[128];
```
## Const, Volatile, Extern, Static

Cuando estamos en C hay dos tipos de modificadores o palabras clave que necesitamos conocer: `const`,`volatile`.

### Const: 
Este se usa para valores que no cambian, un "prometo no cambiar esto" (o tal vez sí). Es una herramienta de contrato entre yo y el compilador (y otros programadores)
```c
#include <stdio.h>  
  
int main(void) {  
    // tecicamente le decimos que no va a cambiar  
    const int velocidad_maxima = 120;  
    // aqui no podemos poner como: velocidad_maxima = 130; esto traeria porblemas de compilación  
  
    // PERO:  
    int *tramposo = (int *) &velocidad_maxima;  
    // aqui le decimos que *tramposo es una dirección de memoria a velocidad maxima  
    // porque lo casteamos? porque por defecto lo hace, ya que un const int no puede ser un int    // pero al internamente castearlo, hacemos el trabajo más sencillo al compilador    int *trampa = &velocidad_maxima;  
  
    *tramposo = 130; // esto funciona pero no es la idea  
    *trampa = 100;  
  
    printf("Velocidad: %i",velocidad_maxima);  
      
    return 0;  
}
```
Los 3 sabores distintos: 
```c
int valor = 10;
int otro = 20;
const int *p1 = &valor;  // 1. El dato es constante, el puntero no
// *p1 = 30; ERROR (el dato es const)
p1 = &otro;  // OK (puedo apuntar a otro lado)
int * const p2 = &valor; // 2. El puntero es constante, el dato no
*p2 = 30;  // OK (puedo modificar el dato)
// p2 = &otro; ERROR (p2 es constante)
const int * const p3 = &valor; // 3. Todo constante
// *p3 = 30; ERROR
// p3 = &otro; ERROR
```
### Volatile: 
Aqui le dicemos al compilador como confia en mí, esto CAMBIA mágicamente.

**Mentalidad C:** `volatile` le dice al compilador: "Oye, optimizador, NO TOQUES esta variable. No asumas nada sobre ella. Cada vez que la uses, ve a la memoria REAL a leerla/escribirla."

**¿Por qué existe?** Los compiladores optimizan. Si ven que lees la misma variable dos veces seguidas sin escribirla, piensan: "total, como no cambió, uso el primer valor guardado". Pero hay situaciones donde SÍ cambia sin que el código lo vea:
```C
// Imagina que la dirección 0xFFFF0000 es un registro de estado de un sensor
#define ESTADO_SENSOR ((volatile unsigned int*)0xFFFF0000)

while (*ESTADO_SENSOR == 0) {
    // Esperando a que el sensor tenga datos
    // Sin volatile, el compilador podría leer ESTADO_SENSOR UNA VEZ
    // y quedar atrapado en un bucle infinito aunque el hardware cambie el valor
}
```
Tambien en variables compartidas entre hilos> 
```C
volatile int bandera_interrupcion = 0;

void interrupcion_del_temporizador() {
    bandera_interrupcion = 1; // Esto ocurre ASINCRÓNICAMENTE
}

int main() {
    while (!bandera_interrupcion) {
        // Haciendo otras cosas
        // Sin volatile, el compilador podría optimizar esto a:
        // if (!bandera_interrupcion) { while(1) { ... } }
        // Y NUNCA vería el cambio
    }
    printf("¡Temporizador terminado!\n");
}
```

A pesaar de esto hay algo que debemos de decir y es: **Pueden combinarse**
```C
// Un registro de solo lectura del hardware
volatile const int *registro_entrada = (volatile const int*)0xFFFF1000;
// - volatile: porque el hardware lo cambia sin avisar
// - const: porque yo no debo escribir en él
// - puntero a int: porque es un registro de 32 bits
```

### Extern

Siendo breves extern indica que una variable o función está definida en otro archivo. Sirve para compartir símbolos entre múltiples `.c`.

Un ejemplo de esto es:
```C fold=main.c
#include <stdio.h>
#include <stdint.h>

extern uint16_t system_clock; // aqui decimos que lo definimos en otro archivo


int main(){
	printf("Extern system_clock:  %u",system_clock);
	
	return 0;
}

```
```c fold=config.c
#include <stdint.h>  
  
uint16_t system_clock = 16000u;
```

Esto funciona perfectamente, ahora si agregamos otra clase con esa misma palabra, pues el linker falla: 
```text
/home/kgnot/.local/share/JetBrains/Toolbox/apps/clion/bin/cmake/linux/x64/bin/cmake --build /home/kgnot/CLionProjects/practica/cmake-build-debug --target practica -j 10
[2/2] Linking C executable practica
FAILED: practica 
: && /usr/bin/cc -g -Wl,--dependency-file=CMakeFiles/practica.dir/link.d CMakeFiles/practica.dir/main.c.o CMakeFiles/practica.dir/config.c.o CMakeFiles/practica.dir/config2.c.o -o practica   && :
/usr/bin/ld: CMakeFiles/practica.dir/config2.c.o:/home/kgnot/CLionProjects/practica/config2.c:3: definiciones múltiples de `system_clock'; CMakeFiles/practica.dir/config.c.o:/home/kgnot/CLionProjects/practica/config.c:3: primero se definió aquí
collect2: error: ld returned 1 exit status
```
Cómo vemos, es definiciones múltiples, y nos dice donde se definió primero.


### Static
El estatic cambia lo que es el alcance (linkage).

Tiene dos usos distintos:

#### static en variables globales:
```c
static utin32_t contador;
```
Significa: 
> Esta variable solo existe dentro de este archivo `.c`

No se puede usar extern desde otro archivo.
Se llama internal linkage, y esto es importante para encapsular módulos, evitar conflictos en nombres y reducir errores de linking. 

#### static dentro de una función: 
```C
void funcion(void)
{
    static uint32_t contador = 0;
    contador++;
}
```
Aquí significa: 
- La variable mantiene su valor entre llamadas
- Solo es visible dentro de la función
Es almacenamiento estático, no está en stack

| Tipo                  | Vida              | Alcance        |
| --------------------- | ----------------- | -------------- |
| Variable local normal | stack             | solo función   |
| `static` local        | toda la ejecución | solo función   |
| global normal         | toda la ejecución | visible extern |
| global `static`       | toda la ejecución | solo archivo   |


## Typedef: 

Una declaración `typedef` es una declaración con `typedef` como clase de almacenamiento. El declarador se convierte en un nuevo tipo. Puede utilizar declaraciones `typedef` para construir nombres más cortos o más significativos para tipos ya definidos por C o para tipos que haya declarado. Los nombres de `typedef` permiten encapsular detalles de la implementación que pueden cambiar.

Una declaración `typedef` no crea nuevos tipos. Crea sinónimos de tipos existentes o nombres para tipos que se podrían especificar de otras maneras. Cuando se usa como especificador de tipo, puede combinarse con determinados especificadores de tipo, pero no con otros. Los modificadores aceptables son `const` y `volatile`.

Ejemplos: 
```C
#include <stdio.h>  
#include <stdlib.h>  
  
  
typedef struct club {  
    char name[30];  
    int size, year;  
} Group;  
  
int main(void) {  
    Group *group = malloc(sizeof(Group));  
    group->size = 3;  
  
    printf("Grupo size: %d", group->size);  
  
    free(group);  
    return 0;  
}
```

Otros ejemplos de esto: 

```C
// Sintaxis básica: typedef tipo_existente nuevo_nombre;
typedef int Entero;           // Ahora "Entero" es lo mismo que "int"
Entero mi_variable = 10;      // Código válido

typedef unsigned char byte;    // Muy usado en sistemas embebidos
byte datos[256];               // Un array de 256 bytes
```

Un typedef un poco más complejo es: 
```C
#include <stdio.h>  
typedef void fv(int), (*const pfv)(int);  
  // el typedef declara dos variables, fv y pfv
  // uno declara una funcion que recibe un int y no devuelve nada
  // el otro es un puntero a una función
  
void hacer_algo(int);  
fv otra_cosa;  // aqui, al igual que arriba, declaramos más rapidamente la función
  
int main(void) {  
    const pfv ha = hacer_algo;  //aqui creamos las referencias
    const pfv oc = otra_cosa;  
    ha(2);   // aqui las usamos
    oc(3);  
  
    return 0;  
}  
  // y aqui la definicion de cada una
void hacer_algo(int a) {  
    printf("Hola, hice algo\n");  
}  
  
void otra_cosa(int b) {  
    printf("hola, hice otra cosa");  
}

```
Esta idea tiene como caso de uso la simulación de clases y polimorfismo por ejemplos: 
```C
#include <stdio.h>  
typedef void fv(int), (*const pfv)(int);  
  
typedef struct {  
    pfv dibujar;  
} Objeto;  
  
fv dibujarCirculo;  
fv dibujarOtraCosa;  
  
void dibujarCirculo(int diametro) {  
    printf("hola, hice dibujar circulo");  
}  
  
void dibujarOtraCosa(int diametro) {  
    printf("hola, hice dibujar otra cosa");  
}  
  
int main(void) {  
    const Objeto circulo = {dibujarCirculo};  
    const Objeto cosa = {dibujarOtraCosa};  
  
    circulo.dibujar(2);  
    printf("\n");  
    cosa.dibujar(2);  
}
```



## Concepto de cabeceras (.h) y código (.c)
En C, la separación entre interfaz e implementación es física.

- **Archivo de Cabecera (`punto.h`):** Es como el "contrato" o la interfaz pública. Aquí declaras tus `struct` (el molde) y las funciones que quieres que otros archivos puedan usar. **No pones código aquí (normalmente).**

```c
// punto.h
#ifndef PUNTO_H // Esto es un "include guard" para no duplicar
#define PUNTO_H

struct Punto {
    int x;
    int y;
};

// Declaración (prototipo) de la función
void mover_punto(struct Punto *p, int dx, int dy);
void mostrar_punto(struct Punto p);

#endif
```
**Archivo de Código (`punto.c`):** Aquí está la implementación privada. Incluyes tu propio `.h` y escribes el código de las funciones.

```c
// punto.c
#include <stdio.h>
#include "punto.h" // Incluyo mi propia interfaz

void mover_punto(struct Punto *p, int dx, int dy) {
    p->x += dx;
    p->y += dy;
}

void mostrar_punto(struct Punto p) {
    printf("(%d, %d)\n", p.x, p.y);
}
```
Luego, en tu `main.c`, solo incluyes `punto.h` y usas las funciones sin saber _cómo_ están implementadas. Esto es la base de la modularidad en C.


## Memoria

### ¿Cómo se organiza la memoria en C?

Cuando se compila en C, la memoria se divide en regiones bien definidas: 

```text
┌─────────────────────┐  ← Dirección alta
│       STACK         │  ← Crece hacia abajo ↓
│         ↓           │
│    (espacio libre)  │
│         ↑           │
│       HEAP          │  ← Crece hacia arriba ↑
├─────────────────────┤
│        BSS          │  ← Variables globales/estáticas NO inicializadas
├─────────────────────┤
│       DATA          │  ← Variables globales/estáticas inicializadas
├─────────────────────┤
│       TEXT          │  ← Código (instrucciones)
└─────────────────────┘  ← Dirección baja (0x00000000)
```
En código se puede ver de esta forma: 
```c
int global_init = 42;        // → DATA
int global_uninit;           // → BSS (se inicializa a 0)
const int constante = 10;    // → TEXT (read-only)

void foo() {
    int local = 5;           // → STACK
    int *p = malloc(100);    // → HEAP (el puntero 'p' está en stack)
}
```

### Tamaño de las variables: 
Las variables cambian su tamaño dependiendo del sistema operativo o de la arquitectura del dispositivo, en Linux con arquitectura de 64 bits tenemos: 
```text
Int: 4 
Char: 1 
Boolean 1 
Float: 4 
Double: 8 
Long: 8 
LongLong: 8 
LongDouble: 16 
Pointer: 8 
Pointer-int: 8 
```

### Stack :
 El stack es automático, rápido y limitado. Funciona como una pila LIFO gestionada por el compilador.
 ```c
void funcion_a() {
    int x = 10;         // Stack frame de funcion_a
    int arr[100];       // 400 bytes en el stack
    funcion_b();        // Se apila un nuevo frame
}                       // Al salir, el frame se destruye automáticamente

void funcion_b() {
    int y = 20;         // Stack frame de funcion_b
    // y, x coexisten en el stack mientras funcion_b esté activa
}
 ```
 
 ### Heap:
 Esta es la memoria dinamica. 
` malloc/calloc/reaclloc/free`
Aqui hay un tema gigante por donde ir , pero báiscamente: 
```C
#include <stdio.h>  
#include <stdlib.h>  
#include <string.h>  
#include <malloc.h>  
  
  
int main() {  
    int resultado = 0;  
    int *arr = NULL;  
    int *arr2 = NULL;  
    void *temp = NULL;  
  
    // este es el ejemplo donde reservamos  
    arr = (int *) malloc(10 * sizeof(int));  
    if (arr == NULL) {  
        resultado = -1;  
        goto cleanup;  
    }  
    // como ejemplo de memset - memoria estatica y no causa leaks:  
    char texto[10];  
    memset(texto, 'A', 9);  
    texto[9] = '\0'; // las cadenas de texto siempre deben terminar asi, es importante  
    printf("Cadena: %s\n", texto);  
    arr2 = (int *) calloc(10, sizeof(int));  
  
    if (arr2 == NULL) {  
        goto cleanup;  
    }  
    temp = (int *) realloc(arr, 20 * sizeof(int));  
    if (temp == NULL) {  
        resultado = -1;  
        goto cleanup;  
    }  
    // aqui da porque 40 es multuplo de 8  
    printf("Arr Size: %zu\n", malloc_usable_size(arr));  
    arr = temp;  
    // aqui da 88 por temas de fastbins y smalbins  
    printf("Arr Size: %zu\n", malloc_usable_size(arr));  
  
cleanup:  
    free(arr);  
    free(arr2);  
    return resultado;  
}
```

Ya que estamos usamos GOTO para ir a una declaración del sistema declarada por una identación.
Hay otro tema importante y es el código de arriba le hace falta algo y es que aqui solo liberamos `arr` pero no liberamos el puntero, solo liberamos la memoria donde este apuntaba. Entonces cómo mejoramos el código? de la siguiente forma: 
```C
#include <stdio.h>  
#include <stdlib.h>  
#include <string.h>  
#include <malloc.h>  
  
void safe_free(void **ptr) {  
    if (ptr != NULL && *ptr != NULL) {  
        free(*ptr);  
        *ptr = NULL; // Esto pone la variable original en NULL  
    }  
}  
  
int main() {  
    int resultado = 0;  
    int *arr = NULL;  
    int *arr2 = NULL;  
    void *temp = NULL;  
  
    // este es el ejemplo donde reservamos  
    arr = (int *) malloc(10 * sizeof(int));  
    if (arr == NULL) {  
        resultado = -1;  
        goto cleanup;  
    }  
    // como ejemplo de memset - memoria estatica y no causa leaks:  
    char texto[10];  
    memset(texto, 'A', 9);  
    texto[9] = '\0'; // las cadenas de texto siempre deben terminar asi, es importante  
    printf("Cadena: %s\n", texto);  
    arr2 = (int *) calloc(10, sizeof(int));  
  
    if (arr2 == NULL) {  
        goto cleanup;  
    }  
    temp = (int *) realloc(arr, 20 * sizeof(int));  
    if (temp == NULL) {  
        resultado = -1;  
        goto cleanup;  
    }  
    // aqui da porque 40 es multuplo de 8  
    printf("Arr Size: %zu\n", malloc_usable_size(arr));  
    arr = temp;  
    // aqui da 88 por temas de fastbins y smalbins  
    printf("Arr Size: %zu\n", malloc_usable_size(arr));  
  
cleanup:  
    safe_free((void **) &arr);  
    safe_free((void **) &arr2);  
    return resultado;  
}
```
Para hacernos una idea en una tabla: 

| Estado                 | Método Tradicional (`free(arr)`)                   | Método Robusto (`safe_free(&arr)`)            |
| ---------------------- | -------------------------------------------------- | --------------------------------------------- |
| **Antes de liberar**   | `arr` apunta a `0x123` (Memoria válida)            | `arr` apunta a `0x123` (Memoria válida)       |
| **Ejecutando**         | El sistema marca `0x123` como libre.               | El sistema marca `0x123` como libre.          |
| **Después de liberar** | `arr` **sigue valiendo** `0x123`.                  | `arr` **ahora vale** `NULL` (0x0).            |
| **Seguridad**          | =={red}**Peligro:** El puntero es un "fantasma".== | =={green}**Seguro:** El puntero está vacío.== |
### Patrones avanzados: 
Estos patrones la verdad, yo no los comprendo del todo, pero me hago una idea, no los profundisare por temas de tiempo, pero aqui dejo los ejemplos: 
#### Arena Allocator (Allocator de region)
Útil cuando se necesita muchas allocaciones temporales y liberar todo de golpe: 
```C
typedef struct {
    uint8_t *buffer;
    size_t   size;
    size_t   offset;
} Arena;

Arena arena_create(size_t size) {
    return (Arena){
        .buffer = malloc(size),
        .size   = size,
        .offset = 0
    };
}

void* arena_alloc(Arena *a, size_t size) {
    // Alineación a 8 bytes
    size = (size + 7) & ~7;
    if (a->offset + size > a->size) return NULL;
    void *ptr = a->buffer + a->offset;
    a->offset += size;
    return ptr;
}

void arena_reset(Arena *a) {
    a->offset = 0;  // "Libera" todo de golpe, O(1)
}

void arena_destroy(Arena *a) {
    free(a->buffer);
    a->buffer = NULL;
}

// Uso:
Arena arena = arena_create(1024 * 1024); // 1 MB
int   *nums  = arena_alloc(&arena, 100 * sizeof(int));
char  *texto = arena_alloc(&arena, 256);
// ... trabajar ...
arena_reset(&arena);   // liberar todo instantáneamente
arena_destroy(&arena);
```
#### Gestión de strings dinámica
```C
typedef struct {
    char  *data;
    size_t len;
    size_t cap;
} String;

String str_new(const char *init) {
    size_t len = strlen(init);
    String s = { malloc(len + 1), len, len + 1 };
    memcpy(s.data, init, len + 1);
    return s;
}

void str_append(String *s, const char *suffix) {
    size_t slen = strlen(suffix);
    size_t new_len = s->len + slen;
    if (new_len + 1 > s->cap) {
        s->cap = (new_len + 1) * 2;
        s->data = realloc(s->data, s->cap);
    }
    memcpy(s->data + s->len, suffix, slen + 1);
    s->len = new_len;
}

void str_free(String *s) { free(s->data); s->data = NULL; }
```

### Bitwise - flags

El bitwise es la forma en que hacemos operaciones a nivel de bits.
Imaginemos que queremos representar esto: 
```C
struct {
    uint8_t error : 1;
    uint8_t ready : 1;
    uint8_t busy  : 1;
} status;

```
Pero ahora usando un entero normal y operaciones bitwise> 
Primero debemos definir el registro
```C
#inlcude <stdint.h>

uint8_t status = 0;
```
Ahora status es un byte con 8 bits disponibles: 
```text
bit: 7 6 5 4 3 2 1 0
```
Aqui queremos definir lo siguiente: 
- bit 0 -> Error
- bit 1 -> Ready
- bit 2 -> Busy
Entonces definimos las máscaras: 
```C
#define STATUS_ERROR (1<<0)
#define STATUS_READY (1<<1)
#define STATUS_BUSY (1<<2)

//Por lo que con esto tenemos lo siguiente 

STATUS_ERROR = 00000001
STATUS_READY = 00000010
STATUS_BUSY  = 00000100

```

#### ¿Cómo activamos una flag?: 
Usamos OR: 
```C
status |= STATUS_READY;
```
Esto nos generda
```text
00000000
OR 00000010
-----------
   00000010
```
Y READY queda activado.
#### ¿Cómo desactivamos una flag?
Usamos AND con negación: 
```C
status &= ~STATUS_READY;
```
Entonces: 
```text
~00000010 = 11111101
AND
00000010
---------
00000000
```
Y READY se apaga
#### ¿Cómo leemos una flag?
Usamos AND: 
```C
if (status & STATUS_READY) {
    // está activo
}
```
Si el resultado es distinto de 0 → el bit está encendido.
#### ¿Cómo Alternamos (toggle)?
Con XOR:
```c
status ^= STATUS_BUSY;
```
#### Ventaja frente a bitfields:
Con bitwise tú controlas:

- Qué bit usas
- En qué posición
- Cómo se empaqueta
- Cómo se escribe en memoria

En microcontroladores como STM32 esto es exactamente lo que haces cuando manipulas registros:
```c
RCC->AHB1ENR |= (1 << 3);
```
Eso es activar un bit en un registro hardware.
*** 
¿Qué es un registro?
Un registro es una celda de memoria interna de acceso inmediato usada por la CPU o por un periférico para operar o configurarse.
Un registro es un bloque de bits con significado específico que la CPU o el hardware interpreta directamente.
-> Se recomienda consultar internet para ver más. 

***

## Memoria parte 2 - microcontroladores
### ¿Qué es una dirección de memoria?
Imaginemos que el microcontrolador tiene un bus de direcciones de 32 bits. Eso significa que puede "apuntar" a cualquier posicion de `0x00000000` hasta `0xFFFFFFFF`.
Básicamente: 
```text
32 bits → 2^32 = 4,294,967,296 posiciones = 4 GB de espacio direccionable
```
Cada dirección apunta a 1 byte. El procesador Cortex-M4 puede "hablar" con cualquier cosa que sea mapeada en ese espacio, ya sea RAM, FLASH, o un registro de un periférico. Todo comparte el mismo bus.

Esto se llama memoria unificada o arquitectura Von Neumann | Harvard modificada. Tenemos el siguiente mapa de memoria 

Vamos a usar un ejemplo de STM32F4 que es más sencillo que STM32N6...
Cómo ejemplo tenemos lo siguiente: 
![[Pasted image 20260219104221.png]]

### Linker script -> El corazón de todo
El linker script (`.ld`) define cómo se mapea la memoria. Aquí podemos observar uno funcional: 
```ld
/* STM32F407 - memory.ld */

MEMORY {
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 1024K
    SRAM  (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}

SECTIONS {
    /* Código e instrucciones → FLASH */
    .text : {
        KEEP(*(.isr_vector))   /* Tabla de vectores PRIMERO */
        *(.text*)
        *(.rodata*)            /* Constantes (read-only data) */
    } > FLASH

    /* Variables inicializadas: el valor inicial vive en FLASH,
       en runtime se copian a SRAM (lo hace el startup code) */
    .data : {
        _data_start = .;
        *(.data*)
        _data_end = .;
    } > SRAM AT > FLASH       /* AT > FLASH = LMA en flash, VMA en SRAM */

    _data_load = LOADADDR(.data);  /* Dirección en FLASH del initializer */

    /* Variables no inicializadas → SRAM (se ponen a 0 en startup) */
    .bss : {
        _bss_start = .;
        *(.bss*)
        *(COMMON)
        _bss_end = .;
    } > SRAM

    /* Stack al final de SRAM */
    _stack_top = ORIGIN(SRAM) + LENGTH(SRAM);
}
```


### Gestión de memoria en STM32: 
Lo mejor que se puede hacer es evitar las variables dinámicas, evitar malloc/free. 
```C
// En bare metal, malloc usa el heap de newlib
// Problemas: fragmentación, no determinista, puede fallar silenciosamente
// En sistemas críticos (automotriz, médico): PROHIBIDO por normas MISRA/DO-178

// ALTERNATIVA: Allocación estática total
#define MAX_SENSORES 8
#define BUFFER_SIZE  256

static uint8_t  rx_buffer[BUFFER_SIZE];  // En BSS
static uint16_t adc_values[MAX_SENSORES];
static uint8_t  uart_pool[4][64];        // Pool estático de buffers UART
```

Generar un POOL estático para STM32: 
```c
// pool_static.h - Sin malloc, completamente determinista
#define POOL_COUNT 16

typedef struct {
    uint8_t data[64];
    uint8_t in_use;
} UartBuffer;

static UartBuffer uart_pool[POOL_COUNT];

UartBuffer* pool_get(void) {
    for (int i = 0; i < POOL_COUNT; i++) {
        if (!uart_pool[i].in_use) {
            uart_pool[i].in_use = 1;
            return &uart_pool[i];
        }
    }
    return NULL; // Pool agotado → manejar error
}

void pool_release(UartBuffer *buf) {
    if (buf) buf->in_use = 0;
}
```
Y para terminar, tenemos: 
![[Pasted image 20260219131617.png]]
## Preprocesadores
El preprocesador es un programa que modifica tu código FUERA del lenguaje C antes de que el compilador lo vea. Reconoce por líneas que empiezan con `#`.
### Las directivas principales: 
1. `#include` - Para incluir archivos> 
```C 
#include <stdio.h> // el sistem busca en /usr/include
#include "miarchivo.h" // busca en el directorio actual
```
Esto copia y pega el archivo en tu código. 

1. `#define`- Macros y constantes
```C 
#define PI 3.14159
#define CUADRADO(x) ((x)*(x)) // esta es una funcion macro
#define MAX(a,b) ((a)>(b)?(a):(b))
```
Su uso: 
```c
area = PI * r * r;           // → area = 3.14159 * r * r;
dist = CUADRADO(5);          // → dist = ((5)*(5));
```

En sistemas embebidos modernos, se prefiere:
- `#define` → solo para macros reales
- `const` → para constantes

Y los `#define` globales son mejor colocarlos en un archivo `.h`.

```c fold=config.h
#ifndef CONFIG_H
#define CONFIG_H

#define TAM_VECTOR 30000U
#define MAX_VALUE  7000U
#define SYSTEM_CLOCK 16000000U

#endif
```

Luego usamos solamente `#include "config.h"` en los archivos correspondientes. 

*** 
Cómo una aclaración importante es: 
![[Pasted image 20260220082053.png]]

Esto nos define a nosotros en algunos preprocesadores como MISRA-C que se usa en microcontroladores ARM (generalmente). Su uso es el siguiente: 

```c
typedef struct
{
  __I  uint32_t IDR;   // Input Data Register (solo lectura)
  __O  uint32_t BSRR;  // Bit Set Reset Register (solo escritura)
  __IO uint32_t ODR;   // Output Data Register (R/W)
} GPIO_TypeDef;
```
Eso se transforma en:
```c
typedef struct
{
  volatile const uint32_t IDR;
  volatile uint32_t BSRR;
  volatile uint32_t ODR;
} GPIO_TypeDef;
```

2. Condicionales
Hay condicionales de compilación: 
```C
#define DEBUG 1

#if DEBUG
    printf("Debug: x=%d\n", x);
#endif

#ifdef WINDOWS
    #include <windows.h>
#else
    #include <unistd.h>
#endif

```
3. `pragma`
Estos son las directivas al compilador:
```C
#pragma pack(1) // sin padding en structs
#pragma once // incluye solo una vez
```

cosas a tener en cuenta: 
```C
// sensor.h - idempotencia
#ifndef SENSOR_H         // ¿SENSOR_H ya definida?
#define SENSOR_H         // NO → defínela ahora

typedef struct { int x; } Sensor;

#endif                   // Fin del bloque



```
`#ifndef SENSOR_H  →  FALSO (ya existe) → salta TODO hasta #endif` > 
**Resultado:** Header incluido **UNA SOLA VEZ** aunque lo incluyas 100 veces.

para más documentación:  https://www.ibm.com/docs/es/i/7.5.0?topic=reference-preprocessor-directives

## Tablas look-up (LUT)

Una **look-up table (LUT)** es una técnica donde reemplazas un cálculo por una **tabla precalculada en memoria**.

En vez de calcular algo cada vez, haces:

```C
resultado = tabla[indice];
```

Supón que quieres `sin(x)` en un micro sin FPU.

Calcular seno:
- es costoso
- usa `float`
- aumenta tamaño de firmware
Alternativa:
```C
static const uint16_t tabla_seno[360] = {
    0, 114, 229, ...
};
```
Luego 
```c
valor = tabla_seno[angulo];
```
## Concurrencia

-- Voy a terminar aquí por el tema de estudiar el Sistema embebido a totalidad. 

## Multi-file projects, makefiles, GCC

## Linkers: 
El **linker** (enlazador) es la herramienta que une todos los archivos compilados y genera el ejecutable final.

En C el proceso ocurre en 3 etapas:
1. **Preprocesador** → expande `#include`, `#define`
2. **Compilador** → convierte cada `.c` en un `.o` (código objeto)
3. **Linker** → une todos los `.o` y resuelve referencias externas
# C para Embedded: Fundamentos Sólidos.

