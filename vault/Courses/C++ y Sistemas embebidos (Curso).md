---
type: course
status: en_progreso
tags: [course, C++ y Sistemas embebidos (Curso)]
date_started: 2024-05-20
---

***
Este será un curso dedicado a `c+ +`, no será dedicado desde el inicio, tal como principiante. Será más enfocado a llevar y entender las "mañas" que contiene este lenguaje de programación, entender a `c+ + ` como lenguaje y poder adoptar arquitecturas comunes aquí y llevarlo también a cosas embebidas como ESP32.
***
# Fase 1.
En la primera fase y curso vamos a hablar un poco de lo que es C++ junto con el libro [A Tour of C++](https://elhacker.info/manuales/Lenguajes%20de%20Programacion/C++/A%20Tour%20of%20C++%20-%20Bjarne%20Stroustrup%20(Addison-Wesley,%202014)(193p).pdf).

C++ es un lenguaje compilado, eso significa que cada archivo fuente pasa por un compilador que lo convierte a archivos objeto que luego se junta y se crea un archivo ejecutable: 
![Pasted image 20251225113821.png](images/Pasted%20image%2020251225113821.png)
Ya sabemos cosas básicas del programa más común de todos: 
```c++
#include <iostream>  
  
int main() {  
    std::cout << "Hello World!\n";  
}
```
Aqui sabemos que el `#include` inserta lo que son las librerías, y luego usamos dos operadores:
- `::` Operador de resolución de ámbito, sirve para acceder a variables, funciones, clases, strcuts, etc. de ámbitos específicos, como `namespaces`, `clases` o un ámbito global.
- `<<` Operador de inserción o corrimiento a izquierda (left shift) para bits, solo que en `iostream` es un operador sobrecargado.
Un pequeño ejemplo de ello se encuentra en el siguiente fragmento de código: 
```c++
#include <iostream>  
  
using std::cout;  
  
  
int x = 10;  
  
namespace henryxd {  
    int x = 15;  
}  
  
  
int main() {  
    int x = 20;  
  
    cout << "Local: " << x << std::endl;  
    cout << "Global: " << ::x << std::endl;  
    cout << "henryxd: " << henryxd::x << std::endl;  
    return 0;  
}
```
Esto nos genera el siguiente resultado: 
![Pasted image 20251225122006.png](images/Pasted%20image%2020251225122006.png)
Aquí observamos las 3 diferentes, e incluso hay más, formas de usar el operador `::` y el operador `<<` es un corrimiento de bits. es decir: 
```c++
int main() {  
    int numero = 3 << 3;  
    cout << numero << std::endl;  
    return 0;  
}
```
Aqui hacemos un corrimiento de bits como 3 es `11` en binario, y corremos 3, entonces: `11000` y eso da 24. Cómo vemos:
![Pasted image 20251225122305.png](images/Pasted%20image%2020251225122305.png)
## Funciones: 
Las funciones en c++ tienen la estructura genérica de muchos tipos de funciones en otros lenguajes como Java.
```cpp
return_type nombre(tipo_parametro param) {
    // cuerpo
    return valor;  // si no es void
}
```

Podemos usar el `auto` como un tipo de variable autoinferible en c++.
Por lo general se usa una declaración y una definición: 
```cpp
// .h o arriba
double square(double);

// .cpp o abajo
double square(double x) { return x*x; }
```

Al igual que otros lenguajes, existe la sobrecarga de funciones y los genéricos que en este caso son los `template`.
```cpp
template<typename T>
void print(T x) { cout << x; }  // ¡Funciona con TODO!
```
## Tipos variables y aritmética
Aqui solo daremos una que otra cosa que sea única de c++.
En C++, **todo tiene un tipo**, y el tipo define:

- Qué valores puede almacenar
- Qué operaciones se pueden realizar

Los tipos básicos están **muy cerca del hardware**, por eso su tamaño **no es fijo por estándar**, sino _dependiente de la implementación_. Aun así, en la práctica suelen ser:

|Tipo|Tamaño típico|Notas|
|---|---|---|
|`bool`|1 byte|Solo `true` o `false`|
|`char`|1 byte|Unidad base de tamaño|
|`int`|4 bytes|Enteros con signo|
|`unsigned`|4 bytes|Enteros sin signo|
|`double`|8 bytes|Doble precisión|
El tamaño real se puede consultar con `sizeof(int)`

### Variable, objetos y valores: 
- Objeto: memoria reservada
- Valor: bits interpretados según tipo
- variable: Objeto con nombre
### Inicialización:
C++ permite varias formas de inicializar y la más recomendada es `{}`
```cpp
int a {10};
double d {3.14};
```
Este tiene ventajas como que me genera error cuando una inicialización está mal, es decir: 
```cpp
int x = 7.9;   // compila, x = 7 (pierde información)
int y {7.9};  // ERROR en compilación
```
### Operadores bit a bit: 
Estos operadores **no trabajan con valores lógicos**, sino **directamente con los bits** del número.
Supongamos: 
```cpp
int a {5}; // 0101
int b {3}; //0011
```
Con los distintos operadores: 
- `a & b` respuesta es 1 porque `0001 -> 1`, pues analiza bit por bit 
- `a | b ` respuesta es 7 porque `0111 -> 7`.
- `a ^ b` Este es el operador `XOR` que es un `or` exclusivo. Resultado es 6 `0110 -> 6`.
- `~` Complemento bit a bit invierte todos los bits
### Ideas clave para recordar

- El tamaño de los tipos depende del sistema, pero sigue patrones comunes
- `char` es la unidad base
- `{}` es la forma más segura de inicializar
- Evita conversiones silenciosas
- Operadores bit a bit trabajan a nivel de bits, no de lógica
- C++ prioriza control y eficiencia, incluso si eso implica más responsabilidad

## Scope (alcance)
Los scope determinan desde donde hasta donde es visible un nombre en el programa.
### Scope Local: 
El nombre es local cuando se declara: 
- Dentro de una función
- Dentro de un bloque `{ }`
- Como parametro de una función o lambda
## Lifetime
Un objeto se construye antes de usarse y se destruye al final de su lifetime.
### 1. Objetos automáticos (locales)

Son los más comunes:

```cpp
void f() {    
 int x {5}; 
}`
```

- Se construyen al entrar al bloque
- Se destruyen al salir del bloque
- El compilador gestiona su memoria automáticamente

---

### 2. Objetos de namespace (globales)

`vector<int> vec;`

- Se construyen antes de `main()`
- Se destruyen al finalizar el programa
- El orden entre distintos archivos **no está garantizado** (fuente común de bugs)

---

### 3. Miembros de clase

`struct Record {     string name; };`

- Se construyen cuando se construye el objeto `Record`
- Se destruyen cuando se destruye ese objeto
- El orden de destrucción es inverso al de construcción

---

### 4. Objetos creados con `new`

`auto p = new Record{"Hume"};`

- No tienen nombre propio (solo el puntero)
- **No se destruyen automáticamente**
- Viven hasta que se llama a `delete`

⚠️ Si no se llama a `delete` → **memory leak**

Por eso en C++ moderno se evita `new` directamente y se prefieren:

- `std::unique_ptr`
- `std::shared_ptr`
### 5. Objetos temporales

`string s = string{"hola"};`

- No tienen nombre
- Su lifetime suele terminar al final de la expresión
- El compilador puede optimizarlos (RVO, elisión de copias)

## Constantes: 
C++ soporta dos nociones de inmutabilidad. 
- `const` El cual significa más o menos "Prometo no cambiar este valor". Esto es principalmente usado en interfaces específicas, así los datos pueden ser pasados a una función sin miedo de ser modificado. El compilador se esfuerza en hacer la promesa hecha por `const`.
- `constexpr`: Significa más o menos "Ser evaluado en tiempo de compilación". Este es usado principalmente para constantes específicas, y puedan ser puestas como solo lectura en la memoria y más rendimiento (donde es muy poco probable de ser corrompida).

Por ejemplo:

```c++
//1. Const en variables
const int max_users=100;
//2. en parametros de funcion (que es muy común)
//- Evita copias de referencia, y garantiza que la función no modifique el argumento
void print_size(const vector<int>& v){
	//v.push_back(10); // esto generaría un error
	cout << v.size();
}

// 3. const con punteros (SUPER IMPORTNATE)
const int* p;   // el valor apuntado es const
int* const q;   // el puntero es const

```
Tenemos :
![Pasted image 20251225182242.png](images/Pasted%20image%2020251225182242.png)
### Regla práctica moderna

- Usa **`constexpr`** cuando el valor **debe ser constante en compile time**
- Usa **`const`** para **proteger datos y APIs**
- Si algo puede ser `constexpr`, **hazlo `constexpr`**

### Tipos de errores encontrados en el uso de `const` y `constexpr`:
## Errores con `const` y `constexpr`

1. **Creer que `const` hace un objeto completamente inmutable**  
    `const` solo impide modificar el objeto _a través de ese nombre_, no desde otros accesos.
2. **Declarar un `const` sin inicializar**  
    Todo objeto `const` debe inicializarse obligatoriamente.
3. **Olvidar `const` en parámetros de funciones**  
    Permite modificaciones accidentales y rompe contratos de interfaz.
4. **Confundir `const int*` con `int* const`**  
    En uno es constante el dato; en el otro, el puntero.
5. **Olvidar marcar métodos como `const`**  
    Impide llamar al método sobre objetos `const` y rompe semántica lógica.
6. **Asumir que `constexpr` siempre se evalúa en tiempo de compilación**  
    Solo ocurre si los argumentos son constantes en compile time.
7. **Usar valores de runtime en inicializaciones `constexpr`**  
    Cualquier dependencia de runtime inválida `constexpr`.
8. **Usar `constexpr` cuando solo se necesita `const`**  
    No todo valor constante puede conocerse en tiempo de compilación.
9. **Creer que `constexpr` garantiza memoria de solo lectura**  
    El estándar no lo exige; es una posible optimización.
10. **Usar `const` donde se requiere una constante en compile time**  
    Ejemplo típico: tamaño de arrays.
11. **Usar operaciones no permitidas dentro de funciones `constexpr`**  
    Especialmente relevantes en estándares antiguos (C++11/14).
12. **Pensar que un constructor `constexpr` siempre crea objetos en compile time**  
    Solo ocurre si el objeto también es `constexpr`.
13. **No entender la extensión de lifetime con `const&` a temporales**  
    Es un caso especial que evita referencias colgantes.
14. **Usar `#define` en lugar de `constexpr` para constantes**  
    Pierdes tipo, scope y comprobación por el compilador.

## Punteros, Arreglos y referencias. 

Este es el apartado, quizá, más importante de c++. 
Primero miraremos el libro, nos comenta que un arreglo de elementos de tipo char se puede declarar de la siguiente forma: 
```cpp
char v[6]; // un arreglo de 6 caracteres
```
Y similarmente un puntero se puede declarar de esta forma: 
```cpp
char* p; // puntero a un caracter
```
En sí `[]` significa "arreglo de" y `*` significa "Puntero a". Todos los arreglos tienen 0 como su cota inferior y `v` tiene 6 elementos, El tamaño de un arreglo debe ser una expresión constante `constexpr`.
Una variable de tipo puntero puede mantener la dirección de un objeto del tipo apropiado:
Entonces: 
```cpp
char *p = &v[3]; // P es un puntero al cuarto elemento de v
char x = *p; // *p es el objeto que p apunta a
```

En la expresión, el prefijo unario `*` significa"contenido de" y el prefijo unario `&` significa"dirección de". Nosotros podemos representar el resultado graficamente cómo: 
![Pasted image 20251225185706.png](images/Pasted%20image%2020251225185706.png)

Otra manera en el que podemos usar `&` es tambien para llamar por referencia y no por copia, es decir, en el siguiente ejemplo creamos una copia: 
```c++
#include <iostream>  
  
using std::cout;  
using std::cin;  
using std::endl;  
  
void verArreglo(const int *);  
  
int main() {  
    int a[3]{0, 1, 3};  
  
    // Aqui copiamos  
    for (auto i: a) {  
        i = 0;  
    }  
    cout << "Res: " << endl;  
    verArreglo(a);  
  
    for (auto &i: a) {  
        i = 0;  
    }  
    cout << "\nRes: " << endl;  
    verArreglo(a);  
  
    return 0;  
}  
  
void verArreglo(const int *a) {  
    for (auto i{0}; i < 3; i++) {  
        cout << a[i] << ", ";  
    }  
}
```
En este ejemplo hacemos dos cosas, en la primera copiamos y la `i` es una copia del elemento en a, mientras que en la segunda con la referencia creamos ya no una copia, referenciamos exactamente del elemento que recorre. Esta referencia se puede colocar en funciones.

## User-defined Types:
Los tipos definidos por el susuario es lo más importante que contiene c++, y son esas estructuras que podemos crear tales como `struct`, `class`, `enum`, `union`, etc. 

Lo primero que veremos será: 
### Structures
Las estructuras tipo `struct` es el primer paso para construir un nuevo tipo y por lo general organiza los elementos para crear una estructura.
```cpp
struct Vector {
	int sz; // numero de elementos
	double* elem; // puntero a los elementos
}
```
Y podemos crearlo como `Vector v`, este es un vector o un arreglo de `double`.  
Para inicializar el vector usamos la siguiente función: 
```cpp
void vector_init(Vector &v, int sz) {  
    v.sz = sz;  
    v.elements = new double[v.sz];  // asigna una matriz de sz doubles
}
```
El uso en totalidad puede ser el siguiente: 
```cpp
#include <iostream>  
  
using std::cout;  
using std::cin;  
using std::endl;  
  
  
struct Vector {  
    int sz;  
    double *elements;  
};  
  
void vector_init(Vector &,int);  
  
  
int main() {  
    Vector v{}; // creamos el vector  
    vector_init(v, 3);  
  
    for (int i = 0; i < v.sz; i++) {  
        cin >> v.elements[i];  
    }  
    double sum = 0;  
    for (int i = 0; i < v.sz; i++) {  
        sum += v.elements[i];  
    }  
    cout << sum << endl;  
  
    delete[] v.elements;  
  
    return 0;  
}  
  
  
void vector_init(Vector &v, const int sz) {  
    v.sz = sz;  
    v.elements = new double[v.sz];  
}
```
### Classes:
Ya sabemos lo que es una clase, pero veremos como se define una clase.
```cpp
class Vector {  
private:  
    int sz;  
    double *elements;  
  
public:  
    explicit Vector(const int i): sz{i}, elements{new double[i]} {  
    };  
  
    ~Vector() {  
        delete[] elements;  
    }  
  
    double &operator[](const int i) const { return elements[i]; };  
    int size() const { return sz; };  
};
```
Esta clase lo que hace, con `explicit` hacemos que el compilador no adivine intenciones. Luego tenemos el destructor, luego una sobrecarga de operador y por último una función o método que nos entrega el tamaño del vector. El main se vería: 
```c++
int main() {  
    Vector v(5);  
  
    v[2] = 3;  
    cout << v[2] << endl;  
  
    return 0;  
}
```
Sin la sobrecarga del operador sería imposible asignar un valor, al menos, no de forma tan sencilla.

## Union:
Una `union` es un `struct` pero con la diferencia de que todos sus miembros comparten la misma dirección de memoria. Es decir:

- todos empiezan en la **misma dirección**
- el tamaño total es el del **miembro más grande**.
- solo uno puede estar “activo” a la vez

Tenemos la siguiente estructura: 
```cpp
struct S{
	int i;
	double d;
};
```
Supongamos que esta estructura se quiere solo, o es `int` o es `double`. Per aqui se pierde memoria, para ello usamos las uniones: 
```cpp
struct Entry{
	char* name;
	Type t;
	char* s;
	int i;
};
// Como lo solucionamos?: 
union Value {
	char* s;
	int i;
};

struct Entry{
	char* name;
    Type t;
    Value v;
};
```
Para eso serviría, aunque el libro nos recomienda no usarlas mucho por los problemas adyacentes, ya que no es `safe`.
Para ello hay otras variantes cómo: 
```cpp
std::variant
```
Por ejemplo: 
```cpp
std::variant<int, std::string> v;
```
Hay una frase por si es necesaria: 
> `Templates` crean tipos distintos en compilación;  
>`unions` permiten que un mismo objeto cambie de tipo en ejecución.

## Enumerations:
Como adición a las clases, c++ soporta una forma sencilla y rápida de enumerar valores, por ejemplo
```cpp
enum class Color{red,blue,green};
enum class Traffic_light { green, yellow, red };

// y se usa: 
//...
Color col = Color::red;
Traffic_light light = Traffic_light::red;
```
Internamente, son numeraciones, 1,2,3 ... Por ejemplo: 
```cpp
enum class Color { red, green, black };  
  
  
int main() {  
    int a = static_cast<int>(Color::black);  
  
    cout<< a << endl;  
  
    return 0;  
}
```
Este nos genera el siguiente resultado: 
![Pasted image 20251226110603.png](images/Pasted%20image%2020251226110603.png)

Vamos a ver u uso útil en los enums, el primer caso es para mejorar el rendimiento, declaramos que la forma de su enumeración sera en enteros sin signo hasta 255. De esta forma: 
```cpp
enum class Status : uint8_t {
	ok,  
	error,  
	timeout
};
```
De esta forma se ahorra memoria para ello.
Ahora imaginemos que tenemos diferentes tipos de Permisos, y estos permisos pueden ser combinados, etc. Podemos pensar en hacer: 
```cpp
enum class Permission : uint8_t{
	read;
	write;
	exec;
};
```
Pero pasa algo y es que no podemos asignar dos tipos de permiso a un mismo usuario
## La regla de los 0 / 3 / 5
C++ nos crea por defecto los destructores y los constructores porque en la mayoría de los casos es suficiente. Pero a veces no es lo que queremos, a veces, nuestra clase necesita un constructor de copia personalizada, esto porque internamente puede tener, por ejemplo, un puntero, y al hacer la copia, COPIA ese puntero mas no crea otro elemento a donde copia ese puntero.
La regla de los 3 dice:
> Si tienes que definir un constructor de copia, un operador asignación o un destructor específico para una clase, entonces necesitas los 3.

En este caso pongamos un ejemplo .
**Para el caso del 0.**
Si nuestra clase no gestiona recursos entonces, no hacer nada, todo se crea por defecto. Ejemplo: 
```cpp
class Person {
	std::string name;
	int age;
}
```
**Ahora para el caso de la regla de 3**
Si necesitamos a alguno de los 3, entonces necesitamos los 3, por ejemplo
```cpp
class Cedula{
private:
	int numero;
	std::string tipo;
}

class Person {
private:
    std::string nombre;
    Cedula* cedula;

public:
    Person(std::string n, Cedula* c)
        : nombre{std::move(n)}, cedula{c} {}

    // 1. Destructor
    ~Person() {
        delete cedula;
    }

    // 2. Copy constructor
    Person(const Person& other)
        : nombre{other.nombre},
          cedula{ other.cedula ? new Cedula(*other.cedula) : nullptr }
    {}

    // 3. Copy assignment
    Person& operator=(const Person& other) {
        if (this != &other) {
            nombre = other.nombre;

            delete cedula;
            cedula = other.cedula
                ? new Cedula(*other.cedula)
                : nullptr;
        }
        return *this;
    }
};

```

Y entonces, que es el `Copy assignment` ? 
- El **copy assignment operator** es el operador `=` sobrecargado para **asignar un objeto existente a OTRO objeto YA CREADO** de la misma clase.
Es decir, que al hacer `Person a = b` siendo `b` una persona. Se hace la copia. Eso soluciona.

**Ahora, la ley del 5**.

La ley del 5 toca iniciar pensando en que copiar y mover no son lo mismo
- Copias -> duplica el recurso
- Mover -> transfiere el recurso (robarlo)

Imaginemos que tenemos el siguiente objeto:
```cpp
Persona p1("Juan",new Cedula(123,"DNI"));
```
Ahora hacemos: 
```cpp
Persona p2 = p1;
```
Esto es copia, solo necesitamos la regla de 3.
Ahora imaginemos que tenemos un temporal y que claramente necesitamos es moverlo, no copiarlo, porque copiarlo consume más recursos y tenemos recursos limitados.
```cpp
Persona 3 = crear_person(); // este crear_persona será un temporal
```
¿Entonces, para que copiar algo que va a morir inmediatamente?
Aqui es donde se cambia de `ownership`.

Entonces añadimos los dos metodos que nos faltan: 
```cpp
//1.
Person(Person&& other);
//2.
Person& operator=(Person&& other);
```
El `&&` significa: _referencia a un objeto temporal_

Por lo que: 
```cpp
Person(Person&& other) noexcept
    : nombre{std::move(other.nombre)},
      cedula{other.cedula}
{
    other.cedula = nullptr;
}
```
y:
```cpp
Person& operator=(Person&& other) noexcept {
    if (this != &other) {
        delete cedula;          // libera lo viejo
        nombre = std::move(other.nombre);
        cedula = other.cedula;  // roba el recurso
        other.cedula = nullptr;
    }
    return *this;
}
```
**Por qué `noexcept` es importante**

Muchísimas optimizaciones del STL **solo usan move si es noexcept**.

Si no:
- `std::vector` copia
- pierde rendimiento

Regla práctica:

> Move constructor y move assignment **siempre noexcept** si puedes garantizarlo.

Los ejemplos de uso: 
```cpp
Person p = crear_persona();   // move
v.push_back(std::move(p));    // move
```
***
Para evitar todo eso en c++ moderno tenemos: 
```cpp
class Person {
	std::string nombre;
	std::unique_ptr<Cedula> cedula;	
};
```
Y aqui ya aplicaría la regla del 0.


# Fase 2: 

Aqui entramos a temas de modularidad y conocer más sobre las clases, errores, modulos, headers, etc. Esto nos ayudará.

## Modularidad

Un programa en c++ no es solo un archivo, es un conjunto de partes tales como: 
- Funciones
- tipos definidos por el usuario
- clases
- plantillas
- librerias
Para que esto sea manejable, C++ separa qué se puedas de como está hecho.
### Interfaz vs implementación
#### Interfaz 
Es lo que otros necesitan saber para usar una parte del programa, es decir. En c++ la interfaz se expresa con declaraciones:
- Qué funciones existen
- Qué tipos existen
- Qué métodos públicos tiene una clase
- Qué reciben y qué devuelven
Un ejemplo de una interfaz es la siguiente: 
```cpp
double sqrt(double);

class Vector {
public:
	Vector(int s);
	double& operator[](int i);
	int size();
}
```
Aquí solo se declaran cosas, `sqrt` existe y sabes cómo usar `Vector`, pero no sabes su implementación y no necesitas saberlo para usarlo.
#### Implementación:
La implementación ya es el código que "hace algo".
Ejemplo:
```cpp
double sqrt(double d){
	// algoritmo
}

// Y para Vector: 

Vector::Vector(int s) : elem{new double[s]}, sz{s} {}

double& Vector::operator[](int i) {
    return elem[i];
}

int Vector::size() {
    return sz;
}
```

***
#### Archivos `.h` y `.cpp`
Con esto en mente podemos diferencias los dos tipos de archivos que hay, esta el header que es el `.h` el cual contiene lo que es la **interfaz**.
- Declaraciones
- Clases
- Firmas de funciones
- Sin lógica compleja

Cómo por ejemplo: 
```cpp
class Vector {
public:
    Vector(int s);
    double& operator[](int i);
    int size();
private:
    double* elem;
    int sz;
};
```
Este es un contrato.

Por otro lado, está el archivo `.cpp` el cual es la **implementación**
siguiendo con el ejemplo: 
```cpp
#include "Vector.h"

Vector::Vector(int s)
	: elem{new double[s]}, sz{s} {}
	
double& Vector::operator[](int i) {
    return elem[i];
}

int Vector::size() {
    return sz;
}
```

Y a la hora de usarlo desde otro archivo: 
```cpp
#include "Vector.h"
#include <cmath>

double sqrt_sum(Vector& v) {
    double sum = 0;
    for (int i = 0; i != v.size(); ++i)
        sum += sqrt(v[i]);
    return sum;
}
```
Aqui este archivo no tiene ni dea de como vector guarda los datos, pero solo sabe que los guarda

Un gráfico interesante puede ser: 
![Pasted image 20251228091048.png](images/Pasted%20image%2020251228091048.png)

## Namespaces:

En adición a las funciones, clases y enumeraciones, C++ ofrece `namespaces` como un mecanismo de expresar alguna declaración como hijo de otra y estos nombres no pueden cruzarse con otros nombres. Por ejemplo yo podría querer experimentar con mi propio tipo de número complejo.
```cpp
namespace My_code{
	class complex {
		//...
	}

	complex sqrt(complex);
	//...
	
	int main();

}

int My_code::main()
{
	complex z {1,2};
	auto z2 = sqrt(z);
	std::cout << '{' << z2.real() << ',' << z2.imag() << "}\n";
	//..
}

int main(){
	return My_code::main();
}
```
``
## Manejo de errores, excepciones e invariantes en c++

### 1. Introducción: El problema real de los errores.
En programas pequeños, los errores suelen manejarse con `if`, valores especiales o mensajes por consola.
En programas reales y grandes, esto NO ESCALA.

En c++ el manejo de errores es un problema de diseño, no solo de sintaxis.

La idea central es: 
- Detectar errores donde ocurren
- Manejarlos donde tiene sentid
Esto requiere: 
- Buenos tipos
- abstracciones claras
- reglas bien definidas sobre qué es válido y qué no.
### 2. El sistema de tipos como primera defensa: 
C++ fomenta que no trabajes solo con `int`,`char`,`double`.
En su lugar
- Defines tipos propios
- usas contenedores
- encapsulas comportamiento
Esto tiene un efecto clave: 
- Muchos errores **no compilan**
- Otros se detectan antes de ejecutarse
Ejemplo conceptual:
- No tiene sentido aplicar una operación de árbol a un botón
- El tipo correcto envía ese error

Así el compilador es el primer detector de errores, 

### 3. Detectar errores vs. manejarlos
En código bien diseñado: 
- Quien detecta el error, no decide qué hacer
- Quien decide que hace, no siempre puede detectar el error

Ejemplo con `Vector`:
- `Vector` detecta un acceso fuera de rango
- `Vector` no sabe si el programa debe: 
	- terminar
	- reintentar
	- mostrar un mensaje
	- ignorar el error
- Por eso, `Vector` lanza una excepción.

### 4. Qué es una excepción

Una excepción es un mecanismo para decir:
> "No puedo continuar correctamente; alguien más arriba debe decidir"

cuando se lanza una excepción: 
- Se interrumpe el flujo normal
- Se busca un manejador adecuado
- Se destruyen objetos locales correctamente
Esto evita:
- Estados inconsistentes
- Fugas de memoria
- Errores silenciosos

### 5. `Try` y `Catch`: manejo explícito

El código que puede fallar se envuelve en un bloque `try`.

Si ocurre un error: 
- Se entra al `catch` correspondiente
- Solo si alguien quiere manejar ese error
Esto hace el flujo de errores: 
- Explícito
- Legibe
- Estructurado
No todo código necesita `try`.

Solo aquel donde tiene sentido reaccionar.

### 6. RAII y excepciones 

RAII significa que: 
- Los recursos están ligados a la vida de los objetos
Cuando ocurre una excepción
- Los destructores se ejecutan
- La memoria se libera
- Los recursos se limpian
Esto es una de las mayores ventajas de C++ 

### 7. `noexcept`: Promesas fuertes
Una función marcada como `noexcept` promete: 
> No lanzar excepciones bajo ninguna circunstancia

Si esta promesa se rompe el programa termina inmediatamente.
Se usa cuando el error no es recuperable, está en destructores, o está en código crítico.

### INVARIANTES: 
Un invariante es una condición que siempre debe cumplirse para que un objeto sea válido.

Ejemplo conceptual para `Vecotr`:
- El tamaño no puede ser negativo
- El puntero debe apuntar a memoria válida
- El número de elementos debe coincidir con el tamaño
Si el invariante no se cumple: 
- El objeto no debería existir

Aqui es donde entra el constructor y es que este tiene una responsabilidad clave, el cual es establecer el invariante

Si no puede hacer ese algo, entonces lanza la excepción y el objeto no se crea, así se garantiza que todo objeto existen es válido y el resto del código puede confiar en eso.

### Static_assert

Un `static_assert` es una verificación en tiempo de compilación

sirve para decirle al compilador: 
> "Si esta condición no se cumple, NO compiles el programa".

No es un `if`.
No se ejecuta en runtime
No cuesta rendimiento

Estos existen para errores que no dependen de datos del usuario, de los que dependen del diseño del programa y dependen de tipos, tamaños y supuestos.
> Supuestos peligrosos: 
> - “int tiene 4 bytes”
> -  “este enum cabe en un byte”
> - “este tipo es trivial”    
> - “este template solo acepta tipos numéricos”

Así que `static_assert` sirve para documentar y hacer cumplir esos supuestos.

¿Cómo es la forma básica?:
```cpp
static_assert(condición,"mensaje de error");
// por ejemplo
static_assert(sizeof(int) == 4, "Se asume int de 32 bits");
```
En c++ moderno podemos encontrar: 
```cpp
#include <type_traits>

template<typename T>
struct Vector {
    static_assert(std::is_arithmetic_v<T>,
                  "Vector solo acepta tipos numéricos");
};
```
Aquí:

- el error ocurre **al instanciar el template**
- no al ejecutar el programa

Esto evita mal uso del código.

También tenemos: 
Sirve para reforzar **invariantes estructurales**.
```cpp
struct Header {
    uint32_t magic;
    uint16_t version;
};

static_assert(sizeof(Header) == 6,
              "Layout binario incorrecto");
```
Muy útil en:

- serialización
- archivos binarios
- redes
- drivers
- sistemas embebidos
O en templates: 
```cpp
template<typename T>
void serialize(const T& obj) {
    static_assert(std::is_trivially_copyable_v<T>,
                  "Tipo no serializable");
}
```
Aquí:

- el error es claro
- el mensaje es explícito
- el usuario no puede usar mal la función

## Clases y más: 

Una clase es una unidad de diseño que combina datos, operaciones, reglas y control de recursos. En si la clase define qué se puede hacer, no solo cómo se guarda.

Una abstracción se basa en solo mostrar lo necesario para usar algo concretamente. Por ejemplo: 
- No sabes como funciona un motor
- PERO -> Sabes como usar el volante y los pedales

Cuando hablamos de interfaces, hablamos de contratos. En c++ una interfaz se expresa con clases abstractas: 
```cpp
class Container {
public:
	virtual double& operator[](int)=0;
	virtaul int size() const = 0;
	virtual ~Container() {}
}
```
El `virtual` significa: 
> "La función que se ejecuta se decide en runtime, no en compilación"

Sin `virtual` el compilador decide según el tipo estático, con virtual decide según el tipo real del objeto.
Tenemos dos formas de inicializar.
Esta por `Vector v(10)` y esta `Vector *v = new Vector(10)`, las diferencias son que en la primera: 

```text
------------------Vector v(10)
Características:
- vive en el stack
- destrucción automática
- vida ligada al scope
- más rápido
- más seguro
Uso ideal cuando:
- el tamaño de vida es claro
- no necesitas polimorfismo
- no compartes ownership

------------------Vector *v = new Vector(10)

Características:
- vive en el heap
- debes liberar manualmente (`delete`)
- puede sobrevivir al scope
- más flexible
- más peligroso
Se usa cuando:
- necesitas polimorfismo
- el tiempo de vida no es claro
- el objeto debe compartirse
- se devuelve desde fábricas
Problema:
- fugas
- dobles delete
- ownership confuso
```

El primero se usa siempre que se pueda.

Ahora un detalle y es que las funciones virtuales se iguala a 0 para significar que es una función virtual pura.

***
Ahora hablemos de la herencia en c++.
Una herencia significa que una clase derivada extiende o implementa otra clase base y su sintaxis es: 
```cpp
class Derivada : public Base {
    // ...
};
```

¿Pero ... hay interfaces y abstracciones?. Se hizo un ejemplo que relaciona todo lo conocido en otros lenguajes como JAVA: 
```cpp
#include <iostream>  
#include <utility>  
  
using namespace std;  
  
class Persona {  
public:  
    Persona(string nombre, const int edad): nombre{std::move(nombre)}, edad(edad) {  
    }  
  
    virtual ~Persona() = default;  
  
protected:  
    string nombre;  
    int edad;  
};  
  
  
class Caminable {  
public:  
    virtual void caminar() = 0;  
  
    virtual ~Caminable() = default;  
};  
  
  
class Estudiante : public Persona, public Caminable {  
public:  
    Estudiante(string const &nombre, int const edad): Persona(nombre, edad) {  
    }  
  
    void caminar() override {  
        cout << "Caminando como : " << this->nombre << " con edad: " << this->edad << endl;  
    };  
};  
  
  
void mover(Caminable& c) {  
    c.caminar();  
}  
  
int main() {  
    Estudiante e{"Henry", 15};  
    mover(e);  
}
```

Aqui ilustra una "abstracción", una "interfaz" y una implementación de ambas por medio de herencia multiple, aunque esto es más como un tipo y un comportamiento.

***
## Templates 

Vamos a hablar de los template son una forma de escribir código genérico.
Tenemos templates en funciones: 
```cpp
T max(T a , T b){
	return (a>b) ? a: b;
}
```
También estan los templates de clases: 
```cpp
template<typename T>
class Box{
	T value;
	
public:
	Box(T c) :value(v){}
	T get() const {return value;}

}


/// su uso: 

Box<int> a(10);
Box<double> b(3.14);
```

## Typedef: 
`typedef` crea un alias de tipo, es decir: 
```
typedef usigned int uint;
```
y ahora usamos: 
```cpp
uint x = 10;
```
A veces hay problemas con `typedef` que se vuelve poco legible, ahora vamos a mirar otro
## Using:
Este es un reemplazo moderno de `typedef`. Asi que `using` hace lo mismo pero mejor 

un alias simple: 
```cpp
using uint = unsigned int;`
```
Esto lo hace mas claro y más moderno.
Tambien tenemos algo que son los alias con templates (esto es muy importante):

Usando el `typedef` :
```cpp
template<typename T>
struct Vec {
	typedef std::vector<T> type;
};
```
Con `using`:
```cpp
template<typename T>
using Vec = std::vector<T>;
```
De ambas formas podemos usar: 
```cpp
Vec<int> v;
```
***
Algo importante son los alias semánticos a la hora de diseñar, podemos hacer: 
```cpp
using UserId = int;
using FileDescriptor = int;
```
Y aunque ambos sean `int` el significado semántico cambia (cosa que siento que hoy día no es tan útil).

## Relación con templates y `using`
El ejemplo típico es: 
```cpp
template<typename T>
using Ptr = T*;

Ptr<int> p; // int*
```
> NOTA
>`typename`
> en C++ es una palabra clave usada principalmente en plantillas para indicar al compilador que un identificador dependiente de una plantilla es un tipo, no una variable miembro

## Threads: 
Un thread es una línea de ejecución independiente dentro de un proceso, en c++ el estándar es: 
```c++
#include <thread>

void work(){
	//..
}

int main() {

	std::thread t(work);
	t.join();
}
```
Por lo que se entiende no hay hilos en los ESP32. Asi que seguiremos con otra idea:
## Task

En sistemas embebidos modernos (ESP32 con FreeRTOS), una Task es: 
> Una función que se ejecuta de forma independiente y concurrente, gestionada por el scheduler del sistema operativo en tiempo real.

### Caracteristicas clave: 
- Tiene su **propio stack**
- Tiene **prioridad**
- Puede dormir (`delay`, `vTaskDelay`)
- Puede ser suspendida / reanudada
- Vive “para siempre” (normalmente un `while(true)`)

El ejemplo conceptual: 
```cpp
void SensorTask(void* pv) {
	while(true){
		leerSensor();
		vTaskDelay(1000 / portTICK_PERIOD_MS)
	}
}
```
Mentalidad correcta:

- Una task **no es una función normal**
- Es un _proceso pequeño_
- No debe bloquear innecesariamente
- No debe hacer trabajo pesado sin pensar
## ISR
Una ISR es un código que ejecuta cuando ocurre un evento hardware.
Por ejemplo: 
- Se presiona un botón
- Llega un byte por UART
- Se dispara un timer
- Se completa una conversión ADC
### Reglas de oro de una ISR

Esto es **crítico**, memorízalo:

1. ⚠️ **Debe ser MUY corta**
2. ⚠️ **No debe bloquear**
3. ⚠️ **No debe usar `delay()`**
4. ⚠️ **No debe usar memoria dinámica (`new`, `malloc`)**
5. ⚠️ **No debe hacer lógica compleja**

Una ISR **NO es un lugar para pensar**, solo para reaccionar.

Ejemplo:

```cpp
void IRAM_ATTR onButtonPress() { // señalizar algo y salir }
```
Estas solo avisan NO procesa.
## Queue
Aquí hay un puente correcto entre ISR y Task.
Una queue es: 
> Un mecanismo seguro para comunicar datos entre task, o entre una ISR y una task.

Es necesaria porque: 
- ISR y Task viven en mundos diferentes
- Compartir variables directamente es peligroso
- Las queues están diseñadas para RTOS

El patrón generalmente viene siendo
1. ISR detecta un evento
2. ISR envía un mensaje a una Queue
3. Task recibe el mensaje y procesa
Algo como arquitectura de eventos.



***
# Fase 3 - Arquitectura: 

Aqui tendremos ayuda de diferentes paginas y articulos

## Las cuatro capas del software embebido
La arquitectura en capas o «_layered architecture_» es la arquitectura de software más extendida y tradicional. Sigue la estructura organizativa y comunicativa tradicional de las empresas IT y es la más empleada en el software embebido.

Consiste en capas independientes que se comunican entre sí mediante interfaces concretas. Si las interfaces están bien diseñadas y se mantienen, las capas pueden ser intercambiables. Por ejemplo, una aplicación de un ARM Cortex-M0 podría ser usada por un microcontrolador AVR
![Pasted image 20251228160141.png](images/Pasted%20image%2020251228160141.png)
Generalmente esta arquitectura consta de 4 capas: 
- drivers
- capa de abstracción del hardware
- middlewares o servicios 
- capa de aplicación.

### 1. Drivers: 
Esta capa controla directamente el silicio del microcontrolador. Este control se realiza principalmente controlando registros del microcontrolador. Los provee el fabricante del silicio o bien se implementan siguiendo las especificaciones del datasheet.
### 2. Capa de abstracción del hardware o HAL
La HAL como su nombre indica, implementa la abstracción del hardware.

Diferentes microcontroladores necesitarán drivers diferentes para la misma funcionalidad, pues su arquitectura y periféricos pueden ser diferentes y tener diferentes características. Esta capa permite reutilizar el software cuando cambias de microcontrolador.

En ocasiones esta capa viene junto a los drivers, que ofrecen una interfaz estandarizada de acceso a los periféricos y funcionalidades del microcontrolador. No se debe confundir el driver (implementa el control del silicio o periférico) de la HAL que no es más que una interfaz abstracta que simplifica o homogeniza las APIs de los drivers.
Como usuario de esta capa, podrás utilizar directamente los protocolos y funcionalidades que son comunes entre todos los microcontroladores.
### 3. Capa de servicio o middlewares
Aquí se encuentran las librerías, servicios, protocolos y todo lo que es software que emplea la aplicación que está a medio camino entre la aplicación y la HAL/Drivers. Es la base software de la aplicación. Por ejemplo: una librería que implementa el protocolo MQTT sería un middleware.
### 4. Capa de aplicación
Aquí se encuentra la lógica de nuestro producto. Si por ejemplo estamos desarrollando un controlador de temperatura para una cama caliente de una impresora 3D, aquí se implementaría la lógica de cuando se corta la corriente, cuando se mide la temperatura, con que cadencia, etc.

## Algunos patrones de diseño

Aqui anotaré unos patrones de diseño necesarios
### Patrón observer: 
El patrón observer consta de dos partes importantes: 
```cpp
class IObserver {  
public:  
    virtual ~IObserver() = default;  
    virtual void Update() = 0;  // Método puramente virtual  
};  
  
// Interfaz para Subject  
class ISubject {  
public:  
    virtual ~ISubject() = default;  
    virtual bool Add(IObserver* observer) = 0;  
    virtual bool Remove(IObserver* observer) = 0;  
    virtual void Notify() = 0;  
};
```

Estas dos interfaces son las principales, una de `Observer` y otra de `Subject`. 
Asi podemos generar las implementaciones reales:
```cpp
// Observer concreto  
class ConcreteObserver : public IObserver {  
public:  
    explicit ConcreteObserver(const int newVal = 0) : val(newVal) {}  
  
    void Update() override {  
        cout << "El observador está siendo notificado ...\n";  
        this->val++;  
    }  
  
    void Print() const {  
        cout << "Val: " << this->val << endl;  
    }  
  
private:  
    int val;  
};  
  
// Otro tipo de Observer concreto (para demostrar la flexibilidad)  
class AnotherObserver : public IObserver {  
public:  
    void Update() override {  
        cout << "¡Otro tipo de observador recibió la notificación!\n";  
    }  
};  
  
// Subject concreto  
class ConcreteSubject : public ISubject {  
public:  
    ConcreteSubject() = default;  
  
    bool Add(IObserver* newObserver) override {  
        if (observers.size() >= 5) {  
            return false;  
        }  
        observers.push_back(newObserver);  
        return true;  
    }  
  
    bool Remove(IObserver* observer) override {  
        for (auto it = observers.begin(); it != observers.end(); ++it) {  
            if (*it == observer) {  
                observers.erase(it);  
                return true;  
            }  
        }  
        return false;  
    }  
  
    void Notify() override {  
        for (IObserver* observer : observers) {  
            observer->Update();  
        }  
    }  
  
private:  
    vector<IObserver*> observers;  // Mejor usar vector que array fijo  
};
```
Y su uso: 
```cpp
int main() {  
    ConcreteSubject sujeto;  
    ConcreteObserver observador1;  
    ConcreteObserver observador2(10);  
    AnotherObserver observador3;  // ¡Diferente tipo de observador!  
  
    sujeto.Add(&observador1);  
    sujeto.Add(&observador2);  
    sujeto.Add(&observador3);  // Funciona porque todos implementan IObserver  
  
    for (int i = 0; i < 6; ++i) {  
        sujeto.Notify();  
    }  
  
    observador1.Print();  
    observador2.Print();  
  
    return 0;  
}
```

En el cual puede que podamos hacer mucho mejor ese tipo de cosas.

### Patrón command: 

El patrón command es basicamente un objeto que tenemos que puede estar en varias partes, no necesariamente el mismo concreto pero al menos la misma interfaz. En este caso una luz que puede estar en la cocina, baño, habitación, etc. 
Luego una interfaz que sea comun para todas, el `Comando` y luego sus implementaciónes concretas para cada funcionalidad. Cómo apagar luz y encender luz, cosas que ese objeto haga y asi se separa funcionalidades. Luego tenemos el Invoker o invocador que es quien lo usa, es quien hace que el comando se ejecute, como presionar un botón de un control (el control es nuestro invocador).
Luego es la implementación de todo. La IA nos ayuda a hacerlo y queda así:

```cpp
#include <iostream>  
#include <utility>  
#include <vector>  
  
using namespace std;  
  
/*-----------------------------------------------------------------------------  
 *  RECEIVER - El que realmente hace el trabajo *-----------------------------------------------------------------------------*/  
class Light {  
private:  
    string ubicacion; // "Sala", "Cocina", etc.  
    bool encendida;  
  
public:  
    explicit Light(string ubic) : ubicacion(std::move(ubic)), encendida(false) {  
    }  
  
    void Encender() {  
        encendida = true;  
        cout << "Luz de " << ubicacion << " encendida\n";  
    }  
  
    void Apagar() {  
        encendida = false;  
        cout << "Luz de " << ubicacion << " apagada\n";  
    }  
};  
  
class TV {  
private:  
    bool encendida;  
  
public:  
    TV() : encendida(false) {  
    }  
  
    void Encender() {  
        encendida = true;  
        cout << "TV encendida\n";  
    }  
  
    void Apagar() {  
        encendida = false;  
        cout << "TV apagada\n";  
    }  
  
    static void SubirVolumen() {  
        cout << "Volumen de TV aumentado\n";  
    }  
};  
  
/*-----------------------------------------------------------------------------  
 *  COMMAND - Interfaz *-----------------------------------------------------------------------------*/  
class ICommand {  
public:  
    virtual ~ICommand() = default;  
  
    virtual void Execute() = 0; // El método principal del patrón  
};  
  
/*-----------------------------------------------------------------------------  
 *  CONCRETE COMMANDS - Comandos específicos *-----------------------------------------------------------------------------*/  
class EncenderLuzCommand final : public ICommand {  
private:  
    Light *luz;  
  
public:  
    explicit EncenderLuzCommand(Light *l) : luz(l) {  
    }  
  
    void Execute() override {  
        luz->Encender();  
    }  
};  
  
class ApagarLuzCommand final : public ICommand {  
private:  
    Light *luz;  
  
public:  
    explicit ApagarLuzCommand(Light *l) : luz(l) {  
    }  
  
    void Execute() override {  
        luz->Apagar();  
    }  
};  
  
class EncenderTVCommand final : public ICommand {  
private:  
    TV *tv;  
  
public:  
    explicit EncenderTVCommand(TV *t) : tv(t) {  
    }  
  
    void Execute() override {  
        tv->Encender();  
    }  
};  
  
class ApagarTVCommand final : public ICommand {  
private:  
    TV *tv;  
  
public:  
    explicit ApagarTVCommand(TV *t) : tv(t) {  
    }  
  
    void Execute() override {  
        tv->Apagar();  
    }  
};  
  
/*-----------------------------------------------------------------------------  
 *  INVOKER - Control remoto que ejecuta comandos *-----------------------------------------------------------------------------*/  
class ControlRemoto {  
private:  
    vector<ICommand *> comandos;  
  
public:  
    void AgregarComando(ICommand *cmd) {  
        comandos.push_back(cmd);  
    }  
  
    void PresionarBoton(int const indice) const {  
        if (indice >= 0 && indice < comandos.size()) {  
            cout << "Ejecutando comando " << indice << "...\n";  
            comandos[indice]->Execute();  
        }  
    }  
  
    void MostrarBotones() {  
        cout << "\n----- Control Remoto -----\n";  
        for (int i = 0; i < comandos.size(); i++) {  
            cout << "Botón " << i << ": " << typeid(*comandos[i]).name() << "\n";  
        }  
        cout << "--------------------------\n\n";  
    }  
};  
  
/*-----------------------------------------------------------------------------  
 *  CLIENT - Usa el sistema *-----------------------------------------------------------------------------*/  
int main() {  
    // Crear receivers (los objetos que hacen el trabajo real)  
    Light *luzSala = new Light("Sala");  
    Light *luzCocina = new Light("Cocina");  
    TV *television = new TV();  
  
    // Crear comandos concretos  
    ICommand *encenderSala = new EncenderLuzCommand(luzSala);  
    ICommand *apagarSala = new ApagarLuzCommand(luzSala);  
    ICommand *encenderCocina = new EncenderLuzCommand(luzCocina);  
    ICommand *encenderTV = new EncenderTVCommand(television);  
    ICommand *apagarTV = new ApagarTVCommand(television);  
  
    // Crear el invoker (control remoto)  
    ControlRemoto *control = new ControlRemoto();  
  
    // Configurar los botones del control  
    control->AgregarComando(encenderSala); // Botón 0  
    control->AgregarComando(apagarSala); // Botón 1  
    control->AgregarComando(encenderCocina); // Botón 2  
    control->AgregarComando(encenderTV); // Botón 3  
    control->AgregarComando(apagarTV); // Botón 4  
  
    // Mostrar configuración    control->MostrarBotones();  
  
    // Usar el control remoto  
    cout << "=== Usando el control remoto ===\n\n";  
    control->PresionarBoton(0); // Encender luz de sala  
    control->PresionarBoton(2); // Encender luz de cocina  
    control->PresionarBoton(3); // Encender TV  
    control->PresionarBoton(1); // Apagar luz de sala  
    control->PresionarBoton(4); // Apagar TV  
  
    // Limpiar memoria    delete luzSala;  
    delete luzCocina;  
    delete television;  
    delete encenderSala;  
    delete apagarSala;  
    delete encenderCocina;  
    delete encenderTV;  
    delete apagarTV;  
    delete control;  
  
    return 0;  
}
```

Si no estoy mal ahí hay unos errores de fuga de memoria, pero sn cosas que debemos mejorar. La idea, se entiende.

### CRTP: 
Este es un patrón exclusivo de c++, el cual tiene que ver con la manera de crear polimorfismo, normalmente nosotros hacemos lo siguiente: 
```cpp
class AnimalVirtual {  
public:  
    virtual void HacerSonido() {  
        cout << "Sonido genérico\n";  
    }  
  
    virtual ~AnimalVirtual() {}  
};  
  
class PerroVirtual : public AnimalVirtual {  
public:  
    void HacerSonido() override {  
        cout << "Guau!\n";  
    }  
};  
  
class GatoVirtual : public AnimalVirtual {  
public:  
    void HacerSonido() override {  
        cout << "Miau!\n";  
    }  
};
```

Sin embargo esto ocupa 8 bytes, y es espacio que necesitamos cuando hacemos sistemas embebidos. 
En cambio nosotros usamos el patrón el cual nos dice a nosotros que extendemos de una clase tipada que se llama a ella misma, es decir: 
```cpp
template<typename Derivada>  
class Animal{  
protected:   
    string nombre;  
    int edad;  
    bool hambriento;  
public:  
    Animal(): edad(0),hambriento(false){}  
      
    //funciones comunes  
    void setNombre(string n) {nombre = n;}  
    void setEdad(int e) {edad = e; }  
      
    void comer(){  
        cout<< nombre<<" está comiendo ... \n";  
        hambriento = false;  
        // luego de comer hace un sonido , aqui debemos confiar ciegamente al llamarlo  
        static_cast<Derivada*>(this)->hacerSonido();  
    }  
    void TenerHambre() {   
        hambriento = true;   
        cout << nombre << " tiene hambre y hace: ";   
        static_cast<Derivada*>(this)->hacerSonido();   
    }  
      
    void presentarse(){  
        cout<< "hola soy "<< nombre  
            <<", tengo "<<edad<<" años y hago: ";  
        static_cast<Derivada*>(this)->hacerSonido();  
    }  
};
```
Luego las clases derivadas implementan lo especifico: 

```cpp
class Perro: public Animal<Perro> {

public: 
	void hacerSonido(){
		cout<< "guau!\n";
	}
	
	void perseguir(){
		cout<< nombre << " persigue la pelota\n";
	}
};

class Gato: public Animal<Gato> {

public: 
	void hacerSonido(){
		cout<< "miao!\n";
	}
	
	void arañar(){
		cout<< nombre << " araña la cama\n";
	}
};
```

Y en el main: 
```cpp
int main() {  
    cout << "=== CON CRTP (código reutilizable) ===\n";  
  
    Perro perro;  
    perro.setNombre("Firulais");  
    perro.setEdad(3);  
    perro.presentarse();  // ← Método común de Animal  
    perro.TenerHambre();  // ← Método común de Animal  
    perro.comer();        // ← Método común de Animal  
    perro.perseguir();    // ← Método específico de Perro  
  
    cout << "\n";  
  
    Gato gato;  
    gato.setNombre("Peluza");  
    gato.setEdad(2);  
    gato.presentarse();   // ← Mismo método común  
    gato.TenerHambre();   // ← Mismo método común  
    gato.comer();         // ← Mismo método común  
    gato.arañar();        // ← Método específico de Gato  
  
    return 0;  
}
```

Básicamente es eso, es un poco raro. Aqui hay una implementación, según la IA, más real: 

```cpp
#include <iostream>
using namespace std;

/*-----------------------------------------------------------------------------
 *  Ejemplo REAL donde CRTP es MUY útil
 *-----------------------------------------------------------------------------*/

// SIN CRTP: Tienes que implementar TODOS los operadores en CADA clase
class Numero {
private:
    int valor;
public:
    Numero(int v) : valor(v) {}
    
    bool operator==(const Numero& o) const { return valor == o.valor; }
    bool operator!=(const Numero& o) const { return valor != o.valor; }  // Repetitivo
    bool operator<(const Numero& o) const { return valor < o.valor; }
    bool operator>(const Numero& o) const { return valor > o.valor; }    // Repetitivo
    bool operator<=(const Numero& o) const { return valor <= o.valor; }  // Repetitivo
    bool operator>=(const Numero& o) const { return valor >= o.valor; }  // Repetitivo
};

// CON CRTP: Solo implementas == y <, los demás son gratis
template <typename T>
class Comparable {
public:
    bool operator!=(const T& o) const {
        return !(static_cast<const T&>(*this) == o);
    }
    bool operator>(const T& o) const {
        return o < static_cast<const T&>(*this);
    }
    bool operator<=(const T& o) const {
        return !(o < static_cast<const T&>(*this));
    }
    bool operator>=(const T& o) const {
        return !(static_cast<const T&>(*this) < o);
    }
};

class NumeroCRTP : public Comparable<NumeroCRTP> {
private:
    int valor;
public:
    NumeroCRTP(int v) : valor(v) {}
    
    // Solo implementas estos dos
    bool operator==(const NumeroCRTP& o) const { return valor == o.valor; }
    bool operator<(const NumeroCRTP& o) const { return valor < o.valor; }
    
    // Los otros 4 operadores (!=, >, <=, >=) los obtienes GRATIS
};

int main() {
    cout << "=== Operadores con CRTP ===\n";
    
    NumeroCRTP a(10);
    NumeroCRTP b(20);
    
    cout << "a == b: " << (a == b) << "\n";  // Tu implementación
    cout << "a != b: " << (a != b) << "\n";  // Gratis de CRTP
    cout << "a < b: " << (a < b) << "\n";    // Tu implementación
    cout << "a > b: " << (a > b) << "\n";    // Gratis de CRTP
    cout << "a <= b: " << (a <= b) << "\n";  // Gratis de CRTP
    cout << "a >= b: " << (a >= b) << "\n";  // Gratis de CRTP
    
    return 0;
}
```

Su uso es:
![Pasted image 20251228221832.png](images/Pasted%20image%2020251228221832.png)


### Strategy

Para entender el problema y la esencia del patrón strategy se vera un par de ejemplos. Cómo bien sabemos a veces necesitamos cambiar el COMPORTAMIENTO de un objeto en runtime, para ello encapsulamos cada algoritmo de forma separada, por ejemplo
```cpp
#include <iostream>  
  
using namespace std;  
  
  
class IEstrategia {  
public:  
    virtual ~IEstrategia() = default;  
  
    virtual void Ejecutar() = 0;  
};  
  
// Estrategias concretas:  
  
class EstrategiaA final : public IEstrategia {  
public:  
    void Ejecutar() override {  
        cout << "Ejecutando EstrategiaA" << endl;  
    }  
};  
  
class EstrategiaB final : public IEstrategia {  
public:  
    void Ejecutar() override {  
        cout << "Ejecutando EstrategiaB" << endl;  
    }  
};  
  
// El contexto que usa la estrategia:  
  
class Contexto {  
private:  
    IEstrategia *estrategia;  
  
public:  
    explicit Contexto(IEstrategia *estrategia) : estrategia(estrategia) {  
    }  
  
    ~Contexto() {  
        delete estrategia;  
    }  
  
    void SetEstrategia(IEstrategia *estrategia) {  
        this->estrategia = estrategia;  
    }  
  
    void Ejecutar() {  
        cout << "Ejecutando Contexto" << endl;  
        estrategia->Ejecutar();  
    }  
};  
  
int main() {  
    cout << "=== PATRÓN STRATEGY ESENCIAL ===\n\n";  
  
    EstrategiaA estrategiaA;  
    EstrategiaB estrategiaB;  
  
    Contexto contexto(&estrategiaA);  
    contexto.Ejecutar();  // Usa estrategia A  
  
    cout << "\nCambiando estrategia...\n\n";  
  
    contexto.SetEstrategia(&estrategiaB);  
    contexto.Ejecutar();  // Usa estrategia B  
  
    return 0;  
}
```

Esto lo hace de forma sencilla .
Un ejemplo de tipo firmware tenemos: 
```cpp
#include <iostream>
using namespace std;

/*-----------------------------------------------------------------------------
 *  EJEMPLO REALISTA: Sistema de control de motor en un robot
 *  
 *  Contexto: Tienes un motor que puede operar en diferentes modos según
 *            las condiciones (batería baja, modo eco, modo turbo, etc.)
 *-----------------------------------------------------------------------------*/

// Tipos de datos típicos en embebidos
typedef unsigned char uint8_t;
typedef unsigned int uint16_t;

/*-----------------------------------------------------------------------------
 *  ESTRATEGIA: Cómo controlar el motor
 *-----------------------------------------------------------------------------*/

class IControlMotor {
public:
    virtual ~IControlMotor() {}
    
    // Calcula el PWM (0-255) según la velocidad deseada
    virtual uint8_t CalcularPWM(uint8_t velocidadDeseada) = 0;
    
    // Retorna el consumo estimado en mA
    virtual uint16_t ObtenerConsumo(uint8_t pwm) = 0;
};

/*-----------------------------------------------------------------------------
 *  ESTRATEGIAS CONCRETAS
 *-----------------------------------------------------------------------------*/

// Modo Normal: Control directo
class ModoNormal : public IControlMotor {
public:
    uint8_t CalcularPWM(uint8_t velocidadDeseada) override {
        // PWM = velocidad directamente
        return velocidadDeseada;
    }
    
    uint16_t ObtenerConsumo(uint8_t pwm) override {
        // Consumo proporcional al PWM
        return pwm * 10;  // ~10mA por cada unidad de PWM
    }
};

// Modo Eco: Reduce consumo
class ModoEco : public IControlMotor {
public:
    uint8_t CalcularPWM(uint8_t velocidadDeseada) override {
        // Reduce al 70% para ahorrar energía
        return (velocidadDeseada * 70) / 100;
    }
    
    uint16_t ObtenerConsumo(uint8_t pwm) override {
        // Consumo optimizado
        return pwm * 7;  // Menos consumo por unidad
    }
};

// Modo Turbo: Máxima potencia
class ModoTurbo : public IControlMotor {
public:
    uint8_t CalcularPWM(uint8_t velocidadDeseada) override {
        // Boost al 120% (limitado a 255)
        uint16_t pwm = (velocidadDeseada * 120) / 100;
        return (pwm > 255) ? 255 : pwm;
    }
    
    uint16_t ObtenerConsumo(uint8_t pwm) override {
        // Alto consumo
        return pwm * 15;
    }
};

// Modo Batería Baja: Conservar energía
class ModoBateriaLow : public IControlMotor {
public:
    uint8_t CalcularPWM(uint8_t velocidadDeseada) override {
        // Limita a máximo 50% para no agotar batería
        uint8_t pwm = (velocidadDeseada * 50) / 100;
        return (pwm > 128) ? 128 : pwm;
    }
    
    uint16_t ObtenerConsumo(uint8_t pwm) override {
        return pwm * 6;  // Consumo mínimo
    }
};

/*-----------------------------------------------------------------------------
 *  CONTEXTO: Controlador del Motor
 *-----------------------------------------------------------------------------*/

class ControladorMotor {
private:
    IControlMotor* estrategia;
    uint8_t velocidadActual;
    uint16_t voltajeBateria;  // En mV (milivolts)

public:
    ControladorMotor() 
        : estrategia(nullptr), velocidadActual(0), voltajeBateria(12000) {}
    
    void SetModo(IControlMotor* modo) {
        estrategia = modo;
        cout << "Modo de motor cambiado\n";
    }
    
    void SetVelocidad(uint8_t velocidad) {
        if (estrategia == nullptr) {
            cout << "ERROR: No hay estrategia configurada\n";
            return;
        }
        
        // Calcular PWM según la estrategia actual
        uint8_t pwm = estrategia->CalcularPWM(velocidad);
        uint16_t consumo = estrategia->ObtenerConsumo(pwm);
        
        velocidadActual = velocidad;
        
        // En hardware real, aquí escribirías al registro PWM
        // Ej: PWM_REGISTER = pwm;
        
        cout << "Velocidad deseada: " << (int)velocidad << "\n";
        cout << "PWM aplicado: " << (int)pwm << "\n";
        cout << "Consumo estimado: " << consumo << " mA\n";
    }
    
    void ActualizarBateria(uint16_t voltaje) {
        voltajeBateria = voltaje;
    }
    
    uint16_t GetVoltajeBateria() {
        return voltajeBateria;
    }
};

/*-----------------------------------------------------------------------------
 *  SISTEMA DE GESTIÓN: Cambia estrategias según condiciones
 *-----------------------------------------------------------------------------*/

class SistemaGestion {
private:
    ControladorMotor* motor;
    
    // Estrategias disponibles
    ModoNormal modoNormal;
    ModoEco modoEco;
    ModoTurbo modoTurbo;
    ModoBateriaLow modoBateriaLow;
    
    IControlMotor* modoActual;

public:
    SistemaGestion(ControladorMotor* m) 
        : motor(m), modoActual(nullptr) {
        // Por defecto, modo normal
        CambiarAModoNormal();
    }
    
    void CambiarAModoNormal() {
        modoActual = &modoNormal;
        motor->SetModo(modoActual);
        cout << ">>> MODO NORMAL activado\n\n";
    }
    
    void CambiarAModoEco() {
        modoActual = &modoEco;
        motor->SetModo(modoActual);
        cout << ">>> MODO ECO activado\n\n";
    }
    
    void CambiarAModoTurbo() {
        modoActual = &modoTurbo;
        motor->SetModo(modoActual);
        cout << ">>> MODO TURBO activado\n\n";
    }
    
    // Cambio automático según voltaje de batería
    void VerificarYAjustar() {
        uint16_t voltaje = motor->GetVoltajeBateria();
        
        cout << "Voltaje batería: " << voltaje << " mV\n";
        
        if (voltaje < 10500) {  // Menos de 10.5V
            if (modoActual != &modoBateriaLow) {
                modoActual = &modoBateriaLow;
                motor->SetModo(modoActual);
                cout << ">>> MODO BATERÍA BAJA activado automáticamente\n\n";
            }
        }
    }
};

/*-----------------------------------------------------------------------------
 *  SIMULACIÓN DE FUNCIONAMIENTO
 *-----------------------------------------------------------------------------*/

int main() {
    cout << "=== CONTROL DE MOTOR - PATRÓN STRATEGY ===\n\n";
    
    ControladorMotor motor;
    SistemaGestion sistema(&motor);
    
    // Escenario 1: Funcionamiento normal
    cout << "--- Escenario 1: Operación normal ---\n";
    sistema.CambiarAModoNormal();
    motor.SetVelocidad(100);
    
    cout << "\n--- Escenario 2: Activar modo eco ---\n";
    sistema.CambiarAModoEco();
    motor.SetVelocidad(100);  // Misma velocidad, menos PWM
    
    cout << "\n--- Escenario 3: Modo turbo ---\n";
    sistema.CambiarAModoTurbo();
    motor.SetVelocidad(100);  // Misma velocidad, más PWM
    
    cout << "\n--- Escenario 4: Batería bajando ---\n";
    motor.ActualizarBateria(11000);  // 11V
    sistema.VerificarYAjustar();
    motor.SetVelocidad(100);
    
    cout << "\n--- Escenario 5: Batería crítica ---\n";
    motor.ActualizarBateria(10000);  // 10V - crítico
    sistema.VerificarYAjustar();
    motor.SetVelocidad(100);  // Automáticamente limita velocidad
    
    cout << "\n--- Escenario 6: Intentar velocidad alta en batería baja ---\n";
    motor.SetVelocidad(200);  // Intentamos alta velocidad
    
    return 0;
}
```
Otros casos de uso embebidos son: 
- Protocolos de comunicación: UART, SPI, I2C
- Algoritmos de filtrado: Filtro paso bajo, Kalman, media móvil
- Estrategias de ahorro de energía: Sleep, Deep Sleep, Active
- Modos de operación de sensores: Alta precisión, bajo consumo, rápido
### Facade
El patrón facade resuelve el problema en el que un subsistema tiene muchas clases complejas y dificiles de usar, asi que se crea una clase "fachada" que simplifica la interfaz. 
```cpp
#include <iostream>  
using namespace std;  
  
/*-----------------------------------------------------------------------------  
 *  ESENCIA DEL PATRÓN FACADE * *  Problema: Un subsistema tiene muchas clases complejas y difíciles de usar *  Solución: Crear una clase "fachada" que simplifique la interfaz *-----------------------------------------------------------------------------*/  
// Subsistema complejo (muchas clases interdependientes)  
class ComponenteA {  
public:  
    void OperacionA1() { cout << "ComponenteA: Operación A1\n"; }  
    void OperacionA2() { cout << "ComponenteA: Operación A2\n"; }  
};  
  
class ComponenteB {  
public:  
    void OperacionB1() { cout << "ComponenteB: Operación B1\n"; }  
    void OperacionB2() { cout << "ComponenteB: Operación B2\n"; }  
};  
  
class ComponenteC {  
public:  
    void OperacionC1() { cout << "ComponenteC: Operación C1\n"; }  
};  
  
// FACADE: Interfaz simplificada  
class Facade {  
private:  
    ComponenteA* compA;  
    ComponenteB* compB;  
    ComponenteC* compC;  
  
public:  
    Facade() {  
        compA = new ComponenteA();  
        compB = new ComponenteB();  
        compC = new ComponenteC();  
    }  
  
    ~Facade() {  
        delete compA;  
        delete compB;  
        delete compC;  
    }  
  
    // Operación simplificada que coordina el subsistema  
    void OperacionSimple() {  
        cout << "Facade: Coordinando operación simple...\n";  
        compA->OperacionA1();  
        compB->OperacionB1();  
        compC->OperacionC1();  
    }  
};  
  
int main() {  
    cout << "=== PATRÓN FACADE ESENCIAL ===\n\n";  
  
    // SIN Facade (complejo)  
    cout << "--- Sin Facade (el cliente debe conocer todo) ---\n";  
    ComponenteA a;  
    ComponenteB b;  
    ComponenteC c;  
    a.OperacionA1();  
    b.OperacionB1();  
    c.OperacionC1();  
  
    cout << "\n--- Con Facade (simple) ---\n";  
    Facade facade;  
    facade.OperacionSimple();  // ¡Una sola llamada!  
  
    return 0;  
}
```

Esta es un ejemplo bastante completo de que se usaría en sistemas embebidos: 
```cpp
#include <cstdint>  
#include <iostream>  
using namespace std;  
  
/*-----------------------------------------------------------------------------  
 *  EJEMPLO REALISTA: Inicialización y lectura de sensores en un dispositivo IoT * *  Contexto: Tienes múltiples sensores (temperatura, humedad, presión) que *            requieren inicialización compleja, calibración, conversión de datos * *  Sin Facade: El código principal debe conocer todos los detalles *  Con Facade: Una interfaz simple para "obtener datos del ambiente" *-----------------------------------------------------------------------------*/  
// Tipos de datos embebidos  
typedef unsigned char uint8_t;  
typedef unsigned short uint16_t;  
typedef short int16_t;  
  
/*-----------------------------------------------------------------------------  
 *  SUBSISTEMA COMPLEJO: Hardware de sensores *-----------------------------------------------------------------------------*/  
// Sensor de temperatura DHT22  
class SensorDHT22 {  
private:  
    uint8_t pin;  
    bool inicializado;  
  
public:  
    SensorDHT22(uint8_t p) : pin(p), inicializado(false) {}  
  
    bool Inicializar() {  
        cout << "[DHT22] Configurando pin GPIO " << (int)pin << "...\n";  
        cout << "[DHT22] Esperando estabilización (2 segundos)...\n";  
        cout << "[DHT22] Enviando secuencia de inicio...\n";  
        inicializado = true;  
        return true;  
    }  
  
    bool LeerDatosRaw(uint8_t* buffer) {  
        if (!inicializado) return false;  
        cout << "[DHT22] Leyendo 40 bits de datos...\n";  
        // Simular lectura  
        buffer[0] = 0x02;  // Humedad high  
        buffer[1] = 0x8C;  // Humedad low  
        buffer[2] = 0x01;  // Temperatura high  
        buffer[3] = 0x5E;  // Temperatura low  
        buffer[4] = 0xEF;  // Checksum  
        return true;  
    }  
  
    bool VerificarChecksum(uint8_t* buffer) {  
        cout << "[DHT22] Verificando checksum...\n";  
        return true;  // Simplificado  
    }  
};  
  
// Sensor de presión BMP280  
class SensorBMP280 {  
private:  
    uint8_t i2c_address;  
    int16_t cal_t1, cal_t2, cal_t3;  // Coeficientes de calibración  
  
public:  
    SensorBMP280(uint8_t addr) : i2c_address(addr) {}  
  
    bool Inicializar() {  
        cout << "[BMP280] Configurando I2C en dirección 0x"  
             << hex << (int)i2c_address << dec << "...\n";  
        cout << "[BMP280] Leyendo ID del chip...\n";  
        cout << "[BMP280] Configurando oversampling...\n";  
        return true;  
    }  
  
    bool LeerCoeficientesCalibacion() {  
        cout << "[BMP280] Leyendo coeficientes de calibración de EEPROM...\n";  
        cal_t1 = 27504;  
        cal_t2 = 26435;  
        cal_t3 = -1000;  
        return true;  
    }  
  
    uint32_t LeerPresionRaw() {  
        cout << "[BMP280] Leyendo ADC de presión (20 bits)...\n";  
        return 415148;  // Valor simulado  
    }  
  
    int32_t CompensarTemperatura(uint32_t adc_t) {  
        cout << "[BMP280] Aplicando compensación de temperatura...\n";  
        // Fórmula compleja del datasheet  
        return 2508;  // 25.08°C  
    }  
  
    uint32_t CompensarPresion(uint32_t adc_p, int32_t t_fine) {  
        cout << "[BMP280] Aplicando compensación de presión...\n";  
        // Fórmula compleja del datasheet  
        return 100653;  // 1006.53 hPa  
    }  
};  
  
// Driver I2C (bajo nivel)  
class I2C_Driver {  
public:  
    static bool Inicializar(uint32_t velocidad) {  
        cout << "[I2C] Inicializando bus a " << velocidad << " Hz...\n";  
        cout << "[I2C] Configurando pull-ups...\n";  
        return true;  
    }  
  
    static void ConfigurarPines(uint8_t sda, uint8_t scl) {  
        cout << "[I2C] SDA=GPIO" << (int)sda  
             << ", SCL=GPIO" << (int)scl << "\n";  
    }  
};  
  
// Driver GPIO (bajo nivel)  
class GPIO_Driver {  
public:  
    static void ConfigurarPin(uint8_t pin, bool es_salida) {  
        cout << "[GPIO] Configurando pin " << (int)pin  
             << " como " << (es_salida ? "OUTPUT" : "INPUT") << "\n";  
    }  
};  
  
/*-----------------------------------------------------------------------------  
 *  FACADE: Interfaz simplificada para el sistema de sensores *-----------------------------------------------------------------------------*/  
struct DatosAmbientales {  
    float temperatura;     // °C  
    float humedad;        // %  
    float presion;        // hPa  
    bool valido;  
};  
  
class SistemaMonitoreoAmbiental {  
private:  
    SensorDHT22* dht;  
    SensorBMP280* bmp;  
    bool sistemaListo;  
  
public:  
    SistemaMonitoreoAmbiental() : sistemaListo(false) {  
        dht = new SensorDHT22(4);   // GPIO 4  
        bmp = new SensorBMP280(0x76); // Dirección I2C  
    }  
  
    ~SistemaMonitoreoAmbiental() {  
        delete dht;  
        delete bmp;  
    }  
  
    // Método SIMPLE: Inicializar todo el sistema  
    bool Inicializar() {  
        cout << "\n=== INICIALIZANDO SISTEMA DE MONITOREO ===\n\n";  
  
        // 1. Configurar hardware de bajo nivel  
        cout << "Paso 1: Configurando hardware...\n";  
        I2C_Driver::ConfigurarPines(21, 22);  // SDA, SCL  
        I2C_Driver::Inicializar(100000);      // 100kHz  
        GPIO_Driver::ConfigurarPin(4, false); // DHT22  
  
        // 2. Inicializar sensores        cout << "\nPaso 2: Inicializando sensores...\n";  
        if (!dht->Inicializar()) {  
            cout << "ERROR: DHT22 falló\n";  
            return false;        }  
  
        if (!bmp->Inicializar()) {  
            cout << "ERROR: BMP280 falló\n";  
            return false;        }  
  
        // 3. Calibración  
        cout << "\nPaso 3: Calibrando sensores...\n";  
        if (!bmp->LeerCoeficientesCalibacion()) {  
            cout << "ERROR: Calibración falló\n";  
            return false;        }  
  
        sistemaListo = true;  
        cout << "\n✓ Sistema listo para operar\n";  
        return true;  
    }  
  
    // Método SIMPLE: Obtener todas las lecturas  
    DatosAmbientales ObtenerDatos() {  
        DatosAmbientales datos = {0, 0, 0, false};  
  
        if (!sistemaListo) {  
            cout << "ERROR: Sistema no inicializado\n";  
            return datos;  
        }  
  
        cout << "\n=== LEYENDO SENSORES ===\n";  
  
        // Leer DHT22 (temperatura y humedad)  
        uint8_t buffer[5];  
        if (dht->LeerDatosRaw(buffer) && dht->VerificarChecksum(buffer)) {  
            datos.temperatura = ((buffer[2] << 8) | buffer[3]) / 10.0;  
            datos.humedad = ((buffer[0] << 8) | buffer[1]) / 10.0;  
        }  
  
        // Leer BMP280 (presión y temperatura)  
        uint32_t adc_p = bmp->LeerPresionRaw();  
        uint32_t adc_t = 519888;  // Simulado  
        int32_t t_fine = bmp->CompensarTemperatura(adc_t);  
        datos.presion = bmp->CompensarPresion(adc_p, t_fine) / 100.0;  
  
        datos.valido = true;  
        cout << "✓ Lecturas completadas\n";  
  
        return datos;  
    }  
  
    // Método SIMPLE: Mostrar datos  
    void MostrarDatos(const DatosAmbientales& datos) {  
        if (!datos.valido) {  
            cout << "\n[!] Datos inválidos\n";  
            return;  
        }  
  
        cout << "\n╔════════════════════════════════╗\n";  
        cout << "║  CONDICIONES AMBIENTALES       ║\n";  
        cout << "╠════════════════════════════════╣\n";  
        cout << "║  Temperatura: " << datos.temperatura << " °C" << "\n";  
        cout << "║  Humedad:     " << datos.humedad << " %"     << "\n";  
        cout << "║  Presión:     " << datos.presion << " hPa"   << "\n";  
        cout << "╚════════════════════════════════╝\n";  
    }  
  
    // Método SIMPLE: Verificar condiciones de alerta  
    bool HayAlerta(const DatosAmbientales& datos) {  
        if (!datos.valido) return false;  
  
        bool alerta = false;  
  
        cout << "\n=== VERIFICANDO ALERTAS ===\n";  
  
        if (datos.temperatura > 30.0) {  
            cout << "[!] ALERTA: Temperatura alta\n";  
            alerta = true;  
        }  
  
        if (datos.humedad > 80.0) {  
            cout << "[!] ALERTA: Humedad alta\n";  
            alerta = true;  
        }  
  
        if (datos.presion < 980.0) {  
            cout << "[!] ALERTA: Presión baja (tormenta posible)\n";  
            alerta = true;  
        }  
  
        if (!alerta) {  
            cout << "✓ Condiciones normales\n";  
        }  
  
        return alerta;  
    }  
};  
  
/*-----------------------------------------------------------------------------  
 *  COMPARACIÓN: Con y sin Facade *-----------------------------------------------------------------------------*/  
void CodigoSinFacade() {  
    cout << "=== SIN FACADE (CÓDIGO COMPLICADO) ===\n\n";  
  
    // El programador debe conocer TODOS los detalles  
    I2C_Driver::ConfigurarPines(21, 22);  
    I2C_Driver::Inicializar(100000);  
    GPIO_Driver::ConfigurarPin(4, false);  
  
    SensorDHT22 dht(4);  
    SensorBMP280 bmp(0x76);  
  
    dht.Inicializar();  
    bmp.Inicializar();  
    bmp.LeerCoeficientesCalibacion();  
  
    uint8_t buffer[5];  
    dht.LeerDatosRaw(buffer);  
    dht.VerificarChecksum(buffer);  
  
    float temp = ((buffer[2] << 8) | buffer[3]) / 10.0;  
    float hum = ((buffer[0] << 8) | buffer[1]) / 10.0;  
  
    // ... y mucho más código complejo  
  
    cout << "Temperatura: " << temp << "°C\n";  
    cout << "Humedad: " << hum << "%\n";  
    cout << "\n→ El programador necesita conocer TODOS los detalles\n";  
}  
  
void CodigoConFacade() {  
    cout << "\n\n=== CON FACADE (CÓDIGO SIMPLE) ===\n";  
  
    // Interfaz simple  
    SistemaMonitoreoAmbiental sistema;  
  
    sistema.Inicializar();  
  
    DatosAmbientales datos = sistema.ObtenerDatos();  
  
    sistema.MostrarDatos(datos);  
    sistema.HayAlerta(datos);  
  
    cout << "\n→ El programador solo usa 3 métodos simples\n";  
}  
  
/*-----------------------------------------------------------------------------  
 *  MAIN *-----------------------------------------------------------------------------*/  
int main() {  
    cout << "╔══════════════════════════════════════════╗\n";  
    cout << "║  PATRÓN FACADE EN SISTEMAS EMBEBIDOS     ║\n";  
    cout << "╚══════════════════════════════════════════╝\n\n";  
  
    // Mostrar diferencia  
    CodigoSinFacade();  
    CodigoConFacade();  
  
    cout << "\n\n=== VENTAJAS DEL FACADE ===\n";  
    cout << "✓ Oculta complejidad del hardware\n";  
    cout << "✓ Interfaz simple y clara\n";  
    cout << "✓ Fácil de testear\n";  
    cout << "✓ Cambios en hardware no afectan código principal\n";  
    cout << "✓ Reduce acoplamiento\n";  
  
    return 0;  
}
```
Y visualmente: 
![Pasted image 20251229121043.png](images/Pasted%20image%2020251229121043.png)


***
Hemos visto varios patrones de diseño que se utilizan en firmware embebido, también es usual ver estados explícitos con `enum` y `switch

Y ahora, pasando a estructuras de proyectos prácticos, tenemos diferentes maneras de crearlo, ya que hay diferentes frameworks para ello. Dos más conocidos puede ser PlatformIO y expressif. 
- https://www.gotoiot.com/pages/articles/platformio_vscode_usage/index.html
- https://developer.espressif.com/blog/2024/12/how-to-create-an-esp-idf-component/#:~:text=It%20is%20recommended%20that%20the,to%20create%20the%20folder
Ahi encontramos dos ejemplos de creación de programas, aunque en el segundo se toma por componentes.
Tambien estan links donde encontramos más temas sobre eso en expressif:
- https://visualgdb.com/documentation/espidf/#:~:text=Project%20Structure
## Bibliografia
- https://oravatec.com/blog/las-4-capas-del-software-embebido/#:~:text=Generalmente%20esta%20arquitectura%20consta%20de,servicios%20y%20capa%20de%20aplicaci%C3%B3n
- 