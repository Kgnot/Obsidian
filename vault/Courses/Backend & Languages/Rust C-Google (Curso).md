---
type: course
status: en_progreso
tags: [course, Rust C-Google (Curso)]
date_started: 2024-05-20
---

# Rust Curso-Google

[Estructura del curso - Comprehensive Rust 🦀](https://google.github.io/comprehensive-rust/es/running-the-course/course-structure.html)

# Fundamentos de RUST:

### El ecosistema de Rust:

El ecosistema de rust se compone de varias herramientas, donde se incluyen: 

- `rustc:`  El compilador de Rust que convierte archivos `.rs` en binarios y otros formatos intermedios.
- `cargo:` Herramienta de compilación y gestión de dependencias de Rust. Cargo también incorpora un ejecutor de pruebas que se utiliza para realizar pruebas unitarias.
- `rustup:` El instalador y actualizador de cadenas de herramientas de Rust. Se utiliza para instalar y actualizar `rust` y `cargo` cuando se lanzan nuevas versiones. También se puede tener varias versiones de Rust instaladas y permite cambiar de versión facilmente.

# Dia 1: Te damos la bienvenida.

## ¿Qué es RUST?:

- Rust es u lenguaje compilado estático similar a c++ que usa LLVM
- Rust es compatible con muchas plataformas y arquitecturas: [x86 , ARM , WebAssembly, etc] [Linux,Mac,Windows , …]
- Rust se utiliza en una gran variedad de dispositvos.

Básicamente satisface las mismas necesidades que C++ [Fran flexibilidad, nivel alto de control, no tiene runtime ni garbage collection, se reduce verticalmente a dispositivos limitados como los controladores]

## Ventajas de Rust:

Estas son algunas de las ventajas competitivas de Rust:

- *Seguridad de la memoria durante el tiempo de compilación:* se evitan clases completas de errores de memoria durante el tiempo de compilación
    - No hay variables no inicializadas.
    - No hay errores double free.
    - No hay errores use-after-free.
    - No hay punteros `NULL`.
    - No se olvidan las exclusiones mutuas bloqueadas.
    - No hay condiciones de carrera de datos entre hilos.
    - No se invalidan los iteradores.
- *No hay comportamientos indefinidos en el tiempo de ejecución:* es decir, una instrucción de Rust nunca queda sin especificar
    - Se comprueban los límites de acceso a los arrays.
    - Se define el desbordamiento de enteros (*panic* o *wrap-around*).
- *Características de los lenguajes modernos:* es tan expresivo y ergonómico como los lenguajes de nivel superior
    - Enumeraciones (*Enums*) y coincidencia de patrones.
    - Genéricos.
    - Sin *overhead* de FFI.
    - Abstracciones sin coste.
    - Excelentes errores de compilación.
    - Gestor de dependencias integrado.
    - Asistencia integrada para pruebas.
    - Compatibilidad excelente con el protocolo del servidor de lenguaje.

## Hola, Mundo

El programa más simple del mundo: 

```rust
fn main(){
	println!("Hola, mundo");
}
```

Lo que vemos: 

- Las funciones se introducen con `fn`
- Los bloques se delimitan con llaves como c++, c , java
- la función `main` es el punto de entrada del programa
- Rust tiene macros [Las **macros en Rust** son una forma avanzada de metaprogramación que permite escribir código que genera más código en tiempo de compilación.
]

## Variables

Rust ofrece seguridad de tipos mediante tipado estatico

```rust
fn main() {
	let x: i32 = 10;
	println!("x: {x}");
}
```

Las variables en Rust de por si son inmutables, para hacerlas mutables agregamos `mut` luego de `let`. Los tipos son: 

![image.png](src/Rust%20Curso-Google/image.png)

Los tipos tienen la siguiente anchura:

- `iN`, `uN`, and `fN` son *N* bits de capacidad,
- `isize` y `usize` tienen el ancho de un puntero,
- `char` tiene un tamaño de 32 bits,
- `bool` tiene 8 bits de ancho.

## Aritmética:

```rust
fn interproduct(a:i32, b:i32,c:i32) -> i32 {
		return a * b + b * c + c * a;
}
fn main() {
    println!("resultado: {}", interproduct(120, 100, 248));
}
```

En rust se maneja el desbordamiento, por ejemplo: 

- En C/C++, si un número entero supera su límite (por ejemplo, `i16` va de -32,768 a 32,767), el comportamiento es **indefinido**, lo que significa que puede variar según la plataforma o el compilador.
- **En Rust, el desbordamiento está definido, pero depende del modo de compilación:**
    - **Modo de depuración (`debug`)**: Rust **detendrá el programa** (`panic`) si ocurre un desbordamiento.
    - **Modo de lanzamiento (`release`)**: Rust **envuelve** el número (`wrapping`), volviendo al valor mínimo permitido.
    
    **Ejemplo de desbordamiento en Rust:**
    
    ```rust
    fn main() {
        let x: i16 = 32_767; // Máximo valor para i16
        let y = x + 1; // Desbordamiento
    
        println!("Resultado: {}", y); // En debug: panic, en release: -32,768
    }
    ```
    
    Rust ofrece métodos específicos para manejar el desbordamiento de enteros:
    
    | Método | Descripción |
    | --- | --- |
    | `.wrapping_add(x)` | Envuelve el número (comportamiento en release). |
    | `.saturating_add(x)` | Se mantiene en el valor máximo o mínimo permitido. |
    | `.overflowing_add(x)` | Devuelve una tupla `(resultado, ocurrió_desbordamiento)`. |
    | `.checked_add(x)` | Retorna `None` si hay desbordamiento, `Some(resultado)` si no. |
    
    Ejemplo:
    
    ```rust
    fn main() {
        let a: i16 = 32_767;
        let b: i16 = 1;
    
        println!("Wrapping: {}", a.wrapping_add(b));   // -32,768 (envuelve)
        println!("Saturating: {}", a.saturating_add(b)); // 32,767 (se queda en el límite)
        println!("Checked: {:?}", a.checked_add(b)); // None (desbordamiento detectado)
    }
    ```
    
    ## Inferencia de tipos:
    
    Rust crea una inferencia de tipos para determinar el tipo dela variable, por ejemplo: 
    
    ```rust
    	fn takes_u32(x:u32)
    	{
    		println!("u32: {x}")
    	}
    	
    	fn takes_i8(y:i8)
    	{
    		println!("i8: {y}")
    	}
    	
    	
    	fn main(){
    		let x = 20;
    		let y = 10;
    		
    		takes_u32(x);
    		takes_i8(y); 
    		// en este lado nosotros estamos infiriendo que x es un u32 y que y es un i8
    		// Es decir un entero sin signo de 32 bits y con la i un entero de 8 bits
    	
    	}
    ```
    
    ### Ejercicio de fibonacci:
    
    ```rust
    fn fib(n: u32) -> u32 {
        if n < 2 {
            return n;
        } else {
            return fib(n - 1) + fib(n - 2);
        }
    }
    
    fn main() {
        let n = 20;
        println!("fib({n}) = {}", fib(n));
    }
    ```
    

## Control de flujo

### Expresiones If:

Se pueden usar las expresiones if de la misma forma que se usa en otros lenguajes: 

```rust
fn main() {
    let x = 10;
    if x == 0 {
        println!("cero!");
    } else if x < 100 {
        println!("muy grande");
    } else {
        println!("enorme");
    }
}

// aunque tambien se puede usar como expresion: 
fn main() {
    let x = 10;
    let size = if x < 20 { "pequeño" } else { "grande" };
    println!("tamaño del número: {}", size);
}

```

### Bucles en Rust

Hay 3 palabras claves en Rust como lo es `while`,`loop`,`for`: 

Bucles While: 

la palabra while es muy similar a la de otros lenguajes y ejecuta el cuerpo de la función mientras la condición sea verdadera. 

```rust
fn main() {
    let mut x = 200;
    while x >= 10 {
        x = x / 2;
    }
    println!("x final: {x}");
}
```

Bucles FOR: 

Este bucle  for al igual que en otros lenguajes itera sobre rangos de valores o de las entradas de una colección: 

```rust
fn main(){
	for x in 1..5{
		println!("x : {x}");
	}
	
	for elem in [1,2,3,4,5,6,7]{
		println!("elem: {elem}");
	}

}
```

El bucle loop: 

Este bucle itera hasta encontrar un break, siento que esta relacionado con lo que es el while(true). 

```rust
fn main(){
	let mut i =0 ; 
	loop {
		i+=1;
		println!("{i}");
		if i > 100 {
			break;
		}
	}

}
```

### Break and continue:

Al igual que en programas como Java, se usa de la misma manera, el continue se usa para decirle al bucle que queremos que siga a la siguiente condición de la iteración; mientras que el break se usa para romper toda la iteración. 

```rust
fn main() {
    let mut i = 0;
    loop {
        i += 1;
        if i > 5 {
            break;
        }
        if i % 2 == 0 {
            continue;
        }
        println!("{}", i);
    }
}
```

Etiquetas: 

Las etiquetas funcionan para poder nombrar los bucles y poder romper el que se desee, por ejemplo: 

```rust
fn main() {
    let s = [[5, 6, 7], [8, 9, 10], [21, 15, 32]];
    let mut elements_searched = 0;
    let target_value = 10;
    'outer: for i in 0..=2 {
        for j in 0..=2 {
            elements_searched += 1;
            if s[i][j] == target_value {
                break 'outer;
            }
        }
    }
    print!("elementos travesados: {elements_searched}");
}
```

Bloques: 

En Rust existen los bloques la cual es una serie de codigo en el cual cada bloque tiene el tipo y valor de la ultima linea de código:

```rust
fn main() {
    let z = 13;
    let x = {
        let y = 10;
        println!("y: {y}");
        z - y
    };
    println!("x: {x}");
}
// aqui nosotros observamos que el x (no mutable por cierto) obtiene el valor de z-y.
// Donde el valor es un isize 
```

Ambitos y Shadowing: 

Los ambitos son fragmentos de código en el cual podemos declarar variables, y hacer operaciones, sin embargo se limita a solo ese ambito. Mientras que el Shsadowing se especifica más hacia el poder definir y redefinir una variable sin importar si se cambia de tipo o no, por ejemplo: 

```rust
fn main() {
    let a = 10;
    println!("antes: {a}");
    {
        let a = "hola";
        println!("ámbito interno: {a}");

        let a = true;
        println!("sombreado en el ámbito interno: {a}");
    }

    println!("después: {a}");
}
```

En el ejemplo anterior se redefine dentro del bloque, y si queremos asegurar que las variables creadas en el ámbito son del ámbito entonces podemos crear una variable adentro e intentar nombrarla afuera, de esa forma sabremos que no se crea, si no es temporal. Lo mismo sucede en el código anterior en el cual podemos observar que a primero es 10 y luego tambien es 10 ya que lo que sucede dentro del ámbito se queda dentro del ámbito. 

![image.png](src/Rust%20Curso-Google/image%201.png)

### Funciones:

```rust
fn gcd(a: u32, b: u32) -> u32 {
    if b > 0 {
        gcd(b, a % b)
    } else {
        a
    }
}

fn main() {
    println!("gcd: {}", gcd(143, 52));
}
```

- Los parámetros de declaración van seguidos de un tipo (al contrario que en algunos lenguajes de programación) y, a continuación, de un tipo de resultado devuelto.
- La última expresión del cuerpo de una función (o de cualquier bloque) se convierte en el valor devuelto. Basta con omitir el carácter `;` al final de la expresión. La palabra clave `return` puede ser utilizado para devolver valores antes del fin de la función, pero la sintaxis de “valor desnudo” es idiomático al fin de una función.
- Algunas funciones no devuelven ningún valor, devuelven el “tipo unitario”, `()`. El compilador deducirá esto si se omite el tipo de retorno `> ()`.
- El sobrecargo de funciones no existe en Rust – cada función tiene una única implementación.
    - Siempre toma un número fijo de parámetros. No se admiten argumentos predeterminados. Las macros se pueden utilizar para admitir funciones variádicas.
    - Siempre se utiliza un solo conjunto de tipos de parámetros. Estos tipos pueden ser genéricos, lo cual discutiremos mas tarde.

### Macros:

Las macros se amplían a código de Rust durante la compilación y pueden adoptar un número variable de argumentos. Se distinguen por utilizar un símbolo `!` al final. La biblioteca estándar de Rust incluye una serie de macros útiles.

- `println!(format, ..)` imprime una linea a la salida estándar (“standard output”), aplicando el formato descrito en [`std::fmt`](https://doc.rust-lang.org/std/fmt/index.html).
- `format!(format, ..)` funciona igual que `println!`, pero devuelve el resultado en forma de cadena.
- `dbg!(expression)` registra el valor de la expresión y lo devuelve.
- `todo!()` marca un fragmento de código como no implementado todavía. Si se ejecuta, activará un error pánico.
- `unreachable!()` marca un fragmento de código como inaccesible. Si se ejecuta, activará un error pánico.

```rust
fn factorial(n: u32) -> u32 {
    let mut product = 1;
    for i in 1..=n {
        product *= dbg!(i);
    }
    product
}

fn fizzbuzz(n: u32) -> u32 {
    todo!()
}

fn main() {
    let n = 4;
    println!("{n}! = {}", factorial(n));
}
```

El resultado de esto es los “log” de lo que se quizo realizar, es decir en `dbg!(i)` . Aquí veriamos en donde está esta linea :D 

![image.png](src/Rust%20Curso-Google/image%202.png)

Como observamos, aparece: `[src/main.rs:4:20]` el cual nos quiere decir el archivo y la linea. 

Un ejemplo de código: 

```rust
/// Determina la longitud de la secuencia de Collatz que empieza por `n`.
fn collatz_length(mut n: i32) -> u32 {
    let mut len = 1;
    while n > 1 {
        n = if n % 2 == 0 { n / 2 } else { 3 * n + 1 };
        len += 1;
    }
    len
}

#[test]
fn test_collatz_length() {
    assert_eq!(collatz_length(11), 15);
}

fn main() {
    println!("Longitud: {}", collatz_length(11));
}
```

Para que se usa el `#[test]` , este se usa para aplicar pruebas unitarias y para poder ser corridas necesitamos usar el apartado de `cargo test` .

## Tuplas y Arrays:

### Arrays:

Cuando creamos arrays estmos creandouna lista, o una lista muilti dimencional, aqui vemos algo de codigo: 

```rust
fn main(){
	let mut a : [i8;10] = [42;10];
	a[5] = 0;
	println!("a:{a:?}")

}
```

Aqui vamos a explicarlo, entonces temeos: 

- Un valor del tipo array `[T;N]` contiene `N`(una constante en tiempo de compilación) elementos del mismo tipo T. Tenemos que tener en cuenta que la longitud del array es parte de su tipo, lo que significa que `[u8;3]` y `[u8,4]` se consideran dos tipos diferentes. Luego veremos los slice que tiene un tamaño detemrinado en tiempo de ejecución.
- Podemos usar literales para asignar valores a arrays, un literal es básicamente un valor de una variable como: 36, “hola”, ‘e’ , false, etc.
- El macro de impresion `println!` solicita la implementación de depuración con el parámetro de formato `?`:`{}` ofrece la salida predeterminada y `{:?}` ofrece la salida de depuración.
Tipos como números enteros y cadenas implementan la salida de depuración. Esto significan que tenemos que usar la salida de depuración en este caso
- Si se añade #, por ejemplo `{a:#?}` , se da formato al texto para facilitar la lectura. pe:

ante este codigo tenemos la salida al otro lado.

```rust
fn main()
{
    let mut  a:[i8;10] = [45;10];

    a[5] = 0;
    println!("a: {a:#?}");
    let a = "xc";
    println!("{}", a);

}
```

![image.png](src/Rust%20Curso-Google/image%203.png)

### Tuplas:

Primero vamos a ver algo del código: 

```rust
fn main() {
	let t: (i8,bool) = (7,true);
	println!("t.0: {}",t.0);
	println!("t.1: {}",t.1);
}
```

![image.png](src/Rust%20Curso-Google/image%204.png)

- Al igual que los arrays, las tuplas tienen una longitud fija.
- Las tuplas agrupan valores de diferentes tipos en un tipo compuesto.
- Se puede acceder a los campos de una typla mediante el punto y el indice del valor, como ya vimos, usando `t.1` o `t.0`.
- La tupla vacía `()` es llamado el “tipo de unidad” y significa la ausencia de un valor de retorno, parecido a void.

### Iteración de arreglos (Arrays):

La insturcción `for` permite iterar sobre arrays, pero no sobre tuplas. 

```rust
fn main() {
	let primes = [2,3,5,7,11,13,17,19];
	for prime in primes{
		for i in 2..prime{
			assert_ne!(prime%i,0);
		}	
	}

}
```

Aqui lo que nosotros hacemos es asegurarnos de que todos son primos, en el primer `for` ponemos que itere en cada primo de los “primes” luego en el segundo nos aseguramos de que el modulo de cada uno sea diferente de cero y lo aseguramos con el comando de `assert_ne!`que es una macro que nos asegura una negación. 

> La macro `assert_ne!` es nueva. También existen las macros `assert_eq!` y `assert!`. Estas variantes siempre se comprueban mientras las variantes de solo depuración, como `debug_assert!`, no compilan nada en las compilaciones de lanzamiento.
> 

### Patrones y desestructuración

Cuando uno trabaja con tuplas y otros valores estructurados, es común querer extraer valores interiores a variables locales. Uno puede manualmente acceder a los valores interiores: 

```rust
fn print_tuple(tuple:(i32,i32)){
	let left = tuple.0;
	let right = tuple.1;
	println!("left: {left}, right: {right}");
}
```

Aun asi, Rust provee la coincidencia de patrones para destructurar un valor en sus partes constitutyentes: 

```rust
fn print_tuple(tuple:(i32,i32)){
	let (left,right) = tuple;
	println!("left: {left}, right: {right}");
}
```

- Los patrones usados aquí son “irrefutables”, es decir que el
compilador puede estáticamente verificar que el valor a la derecha del `=` tiene la misma estructura que el patrón.
- Un nombre de variable es un patrón irrefutable que siempre coincide con cualquier valor, así que también podemos usar `let` para declarar una sola variable.
- Los patrones también se pueden usar en los condicionales, dejando
que la comparación de igualdad y el desestructuramiento ocurren al mismo tiempo. Esta forma de coincidencia de patrones sera discutido mas a
fondo mas tarde.
- Edita los ejemplos anteriores para enseñar el error de compilador cuando el patrón no coincide con el valor

```rust
// Ejemplo propuesto en el curso y resuelto por mi: 
#![allow(unused_variables, dead_code)]

fn transpose(matrix: [[i32; 3]; 3]) -> [[i32; 3]; 3] {
    let mut transposed = [[0; 3]; 3];
  for i in 0..3 {
      for j in 0.. 3{
          transposed[i][j] = matrix[j][i];
      }
  }
    return transposed;
}

#[test]
fn test_transpose() {
    let matrix = [
        [101, 102, 103], //
        [201, 202, 203],
        [301, 302, 303],
    ];
    let transposed = transpose(matrix);
    assert_eq!(
        transposed,
        [
            [101, 201, 301], //
            [102, 202, 302],
            [103, 203, 303],
        ]
    );
}

fn main() {
    let matrix = [
        [101, 102, 103], // <-- el comentario hace que rustfmt añade una nueva línea
        [201, 202, 203],
        [301, 302, 303],
    ];

    println!("matriz: {:#?}", matrix);
    let transposed = transpose(matrix);
    println!("traspuesto: {:#?}", transposed);
}
```

## Referencias:

### Enums compartidas

Una referencia ofrece una forma de acceder a otro valor sin asumir la responsabilidad del valor. También se denomina “préstamo”. Las referencias compartidas son de solo lectura y los datos a los que se hace referencia no pueden cambiar.

```rust
fn main()
{
	let a = 'A';
	let b = 'B';
	let mut r: &char = &a;
	println!("r:{}",*r);
	r = &b;
	println!("r:{}",*r);
	
}
```

Una referencia compartida a un tipo `T` tiene el tipo `&T`.Se crea un valor de referencia con el operador `&`. El operador `*`"desreferencia” una referencia, dando lugar a su valor. 

Para tener una mayor idea de este concepto tendremos el siguiente código: 

```rust
fn modificar(x: &mut i32) { // Recibe una referencia mutable
    *x = 20; // Desreferenciamos y modificamos el valor original
}

fn main() {
    let mut a = 10;
    modificar(&mut a);  // Pasamos a como referencia mutable
    println!("a: {}", a);  // Imprime 20
}
```

Rust no acepta lo que son llamadas “Referencias colgantes” o “dangling reference” que se da cuando se hace referencia a un elemenot que se elimina como por ejemplo la siguiente funcion: 

```rust
fn x_axis(x: &i32) -> &(i32, i32) {
    let point = (*x, 0); // `point` es una variable local
    return &point;       //ERROR: Devuelve referencia a `point`, que será eliminado
}
```

### Referencias Exclusivas

Las referencias exclusivas, también denominadas referencias mutables, permiten cambiar el valor al que hacen referencia. Tienen el tipo `&mut T`. Tal como vimos en el ejemplo de arriba, por ejemplo: 

```rust
fn main() {
    let mut point = (1, 2);
    let x_coord = &mut point.0;
    *x_coord = 20;
    println!("point: {point:?}");
}

```

![image.png](src/Rust%20Curso-Google/image%205.png)

Aquí la respuesta se cambia ya que es una referencia mutable o referencia exclusiva.

### Slice:

Un slice es una referencia a una parte de una coleccion sin copiar los datos, basicamente: 

```rust
fn main(){
	let mut a: [i32;6] = [10,20,30,40,50,60];
	println!("a: {a:?}");
	
	let s: &[i32] = &a[2..4];
	println!("s: {s:?}");
}
// Aqui podemos hablar de ciertas cositas, como por ejemplo: 
/*
1. no es necesario usar siempre el indice 0 es decri: &a[0..a.len()] es lo mismo que  &a[..a.len()]
2. Podemos hacer lo mismo para evitar el ultimo indice: &[2..a.len()] es igual que &a[2..]
3. Para poner todo el objeto es solo usar: &a[..]
*/
```

En este caso `s` es una referencia a un slice de `i32` , y como vemos ya no se menciona la longitud del array, esto nos permite hacer operaciones con otros slice con longitud diferente.

## Cadenas de texto (String)

Ahora podemos entender los dos tipos de cadenas de Rust: 

- `&str` es un slice de bytes codificados en UTF-8, parecido a `&[u8]` .
- `String` es un buffer adueñado de bytes codificados en UTF-8, parecido a `Vec<T>` .

```rust
fn main() {
	let s1: &str = "mundo";
	println!("s1: {s1}");
	
	let mut s2: String  = String::from("¡Hola!");
	println!("s2: {s2}");
	s2.push_str(s1);
	println!("s2: {s2}");
	
	let s3: &str = &s2[s2.len() - s1.len()..];
	println!("s3: {s3}");
}
```

- `&str` introduce un slice de cadena, que
es una referencia inmutable a los datos de cadena codificados en UTF-8 y almacenados en un bloque de memoria. Los literales de cadena (`"Hello"`) se almacenan en el binario del programa.
- El tipo `String` de Rust es un envoltorio que rodea a un vector de bytes. Como sucede con `Vec<T>`, tiene propietario.
- Al igual que ocurre con muchos otros tipos, `String::from()` crea una cadena a partir de un literal de cadena. `String::new()` crea una cadena vacía a la que se pueden añadir datos de cadena mediante los métodos `push()` y `push_str()`.
- La macro `format!()` es una forma práctica de generar una cadena propia a partir de valores dinámicos. Acepta la
misma especificación de formato que `println!()`.
- Puedes tomar prestados slices `&str` de `String` a través de `&` y, de forma opcional, la selección de intervalos. Si seleccionas un
intervalo de bytes que no esté alineado con los límites de caracteres,
la expresión activará un pánico. El iterador `chars` itera sobre los caracteres y se aconseja esta opción a intentar definir los límites de los caracteres correctamente.
- Para los programadores de C++: piensa en `&str` como el `const char*` de C++, pero uno que siempre apunta a una cadena válida en la memoria. El `String` de Rust es parecido a `std::string` de C++ (la diferencia principal es que solo puede contener bytes
codificados en UTF-8 y nunca utilizará una optimización de cadena
pequeña).
- Los literales de cadenas de bytes te permiten crear un valor `&[u8]` directamente:

```rust
fn main() {
    let texto: &str = "Hola";       
    let bytes: &[u8] = b"Hola";      

    println!("{}", texto); // Output: Hola
    println!("{:?}", bytes); // Output: [72, 111, 108, 97]
}
```

Ejercicio de Geometria: 

Crearemos algunas funciones de utilidad para la geeomtria tridimensional represntanddo un punto como [f64;3]. Vamos a decidir las firmas de las funciones: 

```rust

fn magnitude(vector: &[f64;3]) -> f64 {
    let mut sum:f64 = 0.0;
    for i in 0..3 {
        sum += vector[i].powf(2.0);
    }
    sum = sum.sqrt();
    return sum;
}
fn normalize(vector : &mut [f64;3]) -> (){
    let magnitude = magnitude(&vector);
    for i in 0..3
    {
        vector[i] = vector[i]/magnitude;
    }

}
fn main() {
    println!("Magnitud de un vector unitario: {}", magnitude(&[0.0, 1.0, 0.0]));

    let mut v = [1.0, 2.0, 9.0];
    println!("Magnitud de {v:?}: {}", magnitude(&v));
    normalize(&mut v);
    println!("Magnitud de {v:?} después de la normalización: {}", magnitude(&v));
}
```

## Tipos definidos por el usuario:

### Estructuras con nombre

De la misma forma que en C y C++, Rust admite estructuras (struct) presonalizadas: 

```rust
struct Person {
    name: String,
    age: u8
}

fn describe(person:&Person){
    println!("{} tiene {} años",person.name, person.age);
}

fn main(){
    let mut peter = Person {name: String::from("Peter"), age: 27};
    describe(&peter);
    peter.age = 28;
    describe(&peter);

    let name = String::from("Avery");
    let age = 39;
    let avery = Person { name, age };
    describe(&avery);

    let jackie = Person { name: String::from("Jackie"), ..avery };
    describe(&jackie);
}
```

![image.png](src/Rust%20Curso-Google/image%206.png)

Como observamos se encuentra de forma totalmente normal. 

### Estructuras de tuplas:

Si los nombres de los campos no son como tal importantes, podemos usar una estructura de tupla: 

```rust
struct Point(i32,i32);

fn main()
{
	let p = Point(17,23);
	println!("({},{})",p.0,p.1);

}
```

Esto se suele utilizar para envoltorios de campo único (denominados newtypes):

Este patron Newtype se usa para crear tipos seguros y especificos a partir de tipos primitivos como `f64`, `i32`, etc. Se logra envolviendo un solo campo dentro de un struct.

El podemos que decir es: 

```rust
struct PoundsOfForce(f64);
struct Newtons(f64);
fn compute_thruster_force() -> PoundsOfForce {
    todo!("Pregunta a un científico aeroespacial de la NASA")
}
fn set_thruster_force(force: Newtons) {
    // ...
}
fn main() {
    let force = compute_thruster_force();
    set_thruster_force(force);
}
```

En este codigo vemos como, aunque  los dos valores son de `f64` nosotros creamos dos structs para manejar un pseudotipado y no caer en errores

### Enumeraciones:

La palabra clase `enum` permite crear un tipo que tiene diferentes variantes:

```rust
#[derive(Debug)]
enum Direction{
    Left,
    Right,
}

#[derive(Debug)]
enum PlayerMove{
    Pass,                   // Variante simple
    Run(Direction),         // Variabte de forma tupla
    Teleport {x:u32,y:u32}, // Variante de forma struct
}

fn main() {
    let m: PlayerMove = PlayerMove::Run(Direction::Left);
    println!("En este turno: {:?}", m);
}
```

![image.png](src/Rust%20Curso-Google/image%207.png)

Como vemos los `enum` se parecen un poco a como se definenen en otros lenguajes como Java. 

Como se almacena un enum?

Rust almacena dos cosas para un `enum:` 

1. El valor de la variante (Que se llama discriminante)
2. Los datos asociados a la variante (Solo si los tiene)

> Este apartado esta dedicado a un fragmeento de la pagina debido a que no loe entendí tan bien:
> 
> 
> Puntos Clave:
> 
> - Las enumeraciones te permiten colectar un conjunto de valores en un solo tipo.
> - `Direction` es un tipo con variantes. Hay dos valores de `Direction`: `Direction::Left` y `Direction::Right`.
> - `PlayerMove` es un tipo con tres variantes.
> Además de las cargas útiles, Rust almacenará un discriminante para saber qué variante se encuentra en un valor `PlayerMove` en el tiempo de ejecución.
> - Este es un buen momento para comparar las estructuras y las enumeraciones:
>     - En ambas puedes tener una versión sencilla sin campos (estructura
>     unitaria) o una versión con distintos tipos de campos (variantes con
>     carga útil).
>     - Incluso podrías implementar las distintas variantes de una
>     enumeración con estructuras diferentes, pero entonces no serían del
>     mismo tipo como lo serían si estuvieran todas definidas en una
>     enumeración.
> - Rust usa muy poco espacio para almacenar el discriminante.
>     - Si es necesario, almacena un número entero del tamaño más pequeño requerido
>     - Si los valores de la variante permitidos no cubren todos los patrones de bits, se utilizarán patrones de bits no válidos para codificar el
>     discriminante (la “optimización de nicho”). Por ejemplo, `Option<&u8>` almacena un puntero en un número entero o `NULL` para la variante `None`.
>     - Puedes controlar el discriminante si es necesario (por ejemplo, para asegurar la compatibilidad con C):
>     
>     ```rust
>     #[repr(u32)]
>     enum Bar {
>         A, // 0creo que
>         B = 10000,
>         C, // 10001
>     }
>     
>     fn main() {
>         println!("A: {}", Bar::A as u32);
>         println!("B: {}", Bar::B as u32);
>         println!("C: {}", Bar::C as u32);
>     }
>     ```
>     
>     - Sin `repr`, el tipo discriminante ocupa 2 bytes, debido a que 10001 se cabe en 2 bytes.
>     
>     ## [Más información](https://google.github.io/comprehensive-rust/es/user-defined-types/enums.html#m%C3%A1s-informaci%C3%B3n)
>     
>     Rust cuenta con varias optimizaciones que puede utilizar para hacer que las enums ocupen menos espacio.
>     
>     - Optimización de puntero nulo: para [algunos tipos](https://doc.rust-lang.org/std/option/#representation), Rust asegura que `size_of::<T>()` es igual a `size_of::<Option<T> >()`.
>         
>         Fragmento de código de ejemplo si quieres mostrar cómo puede ser la 
>         representación bit a bit en la práctica. Es importante tener en cuenta 
>         que el compilador no ofrece garantías con respecto a esta 
>         representación, por lo tanto es totalmente inseguro.
>         
>         ```rust
>         use std::mem::transmute;
>         
>         macro_rules! dbg_bits {
>             ($e:expr, $bit_type:ty) => {
>                 println!("- {}: {:#x}", stringify!($e), transmute::<_, $bit_type>($e));
>             };
>         }
>         
>         fn main() {
>             unsafe {
>                 println!("bool:");
>                 dbg_bits!(false, u8);
>                 dbg_bits!(true, u8);
>         
>                 println!("Option<bool>:");
>                 dbg_bits!(None::<bool>, u8);
>                 dbg_bits!(Some(false), u8);
>                 dbg_bits!(Some(true), u8);
>         
>                 println!("Option<Option<bool>>:");
>                 dbg_bits!(Some(Some(false)), u8);
>                 dbg_bits!(Some(Some(true)), u8);
>                 dbg_bits!(Some(None::<bool>), u8);
>                 dbg_bits!(None::<Option<bool>>, u8);
>         
>                 println!("Option<&i32>:");
>                 dbg_bits!(None::<&i32>, usize);
>                 dbg_bits!(Some(&0i32), usize);
>             }
>         }
>         ```
>         

### Static:

Las variables estáticas viviran durante toda la ejecución del programa y, por lo tanto, no se moverán:

```rust
static BANNER: &str = "Bienvenido a RustOS 3.14";

fn main(){
	println!("{BANNER}");
}
```

Estas no son insertadas y tienen una ubicación de memoria real asociada.  Esto resulta útil para código insertado y no seguro. Además, la  variable continúa durante toda la ejecución del programa. Cuando un valor de ámbito global no tiene ningún motivo para necesitar identidad de objeto, se suele preferir `const`.

- Por su parte, `static` se parece a una variable global mutable en C++.
- `static` proporciona la identidad del
objeto: una dirección en la memoria y en el estado que requieren los
tipos con mutabilidad interior, como `Mutex<T>`.

Mas informacion:

Dado que se puede acceder a las variables `static` desde cualquier hilo, deben ser `Sync`. Mutabilidad interior es posible a través de un [`Mutex`](https://doc.rust-lang.org/std/sync/struct.Mutex.html), atómico o parecido.

Datos locales al hilo se pueden crear con el macro `std::thread_local`.

### Const:

Las variables constantes se evalúan en tiempo de compilación y sus valores se insertan donde sean utilizados: 

```rust
const DIGEST_SIZE: usize = 3;
const ZERO: Option<u8> = Some(42);

fn compute_digest(text: &str) -> [u8; DIGEST_SIZE] {
    let mut digest = [ZERO.unwrap_or(0); DIGEST_SIZE];
    for (idx, &b) in text.as_bytes().iter().enumerate() {
        digest[idx % DIGEST_SIZE] = digest[idx % DIGEST_SIZE].wrapping_add(b);
    }
    digest
}

fn main() {
    let digest = compute_digest("Hello");
    println!("digest: {digest:?}");
}
```

Según el libro [Rust RFC Book](https://rust-lang.github.io/rfcs/0246-const-vs-static.html), se insertan cuando se utilizan.

Sólo se pueden llamar a las funciones marcadas como `const` en tiempo de compilación para generar valores `const`. Sin embargo, las funciones `const` se pueden llamar en *runtime*.

Tiempo de compliación: 

Es el momento en el que el compilador (como `rustc`) analiza y traduce tu código fuente a un programa ejecutable. Durante esta fase:

- Se verifica que el código sea válido (tipo de datos, sintaxis, etc.).
- Se optimiza el código.
- Se generan errores si hay problemas en la lógica que el compilador puede detectar.
- Se pueden calcular valores constantes

Runtime:

Es cuando el programa ya ha sido compilado y está en ejecución en la computadora.

En esta fase:

- Se asigna memoria para variables.
- Se ejecutan cálculos que no podían resolverse en la compilación.
- Se gestionan entradas y salidas (`println!`, leer archivos, etc.).
- Se ejecuta la lógica del programa.

### Aliases de tipo:

Un alias de tipo crea un nombre para otro tipo. Ambos tipos se pueden utilizar insitintamente.

```rust
enum CarryableConcreteItem {
	Left,
	Right,
}

type Item = CarryableConcreteItem;

// Los alias resultan más de utilidad con tipos largos y complejos: 
use std::cell::RefCell;
use std::sync::{Arc,RwLock};
type PlayerInventory = RwLocj<Vec<Arc<RefCell<Item>>>>;
```

Esto es algo parecido a los typedef.

### Para finalizar la seccion:

```rust
#[derive(Debug)]
/// Un evento en el sistema de ascensores al que debe reaccionar el controlador.
enum Event {
    CarArrived(i32),
    CarDoorOpened,
    CarDoorClosed,
    ButtonPressed(Button)
}
type Floor = i32; // creamos el tipo
/// Un sentido de la marcha.
#[derive(Debug)]
enum Direction {
    Up,
    Down,
}
// Necesitamos un boton accesible para el usuario
#[derive(Debug)]
enum Button {
    LobbyCall(Direction,Floor),
    CarFloor(Floor),
}

/// El ascensor ha llegado a la planta indicada.
fn car_arrived(floor: i32) -> Event {
    Event::CarArrived(floor)
}

/// Las puertas del ascensor se han abierto.
fn car_door_opened() -> Event {
    Event::CarDoorOpened
}

/// Las puertas del ascensor se han cerrado.
fn car_door_closed() -> Event {
    Event::CarDoorClosed
}

/// Se ha pulsado el botón direccional de un ascensor en la planta indicada.
fn lobby_call_button_pressed(floor: i32, dir: Direction) -> Event {
    Event::ButtonPressed(Button::LobbyCall(dir,floor))
}

/// Se ha pulsado el botón de una planta en el ascensor.
fn car_floor_button_pressed(floor: i32) -> Event {
    Event::ButtonPressed(Button::CarFloor(floor))
}

fn main() {
    println!(
        "Un pasajero de la planta baja ha pulsado el botón para ir hacia arriba: {:?}",
        lobby_call_button_pressed(0, Direction::Up)
    );
    println!("El ascensor ha llegado a la planta baja: {:?}", car_arrived(0));
    println!("Las puertas del ascensor se han abierto: {:?}", car_door_opened());
    println!(
        "Un pasajero ha pulsado el botón de la tercera planta: {:?}",
        car_floor_button_pressed(3)
    );
    println!("Las puertas del ascensor se han cerrado: {:?}", car_door_closed());
    println!("El ascensor ha llegado a la tercera planta: {:?}", car_arrived(3));
}
```

---

# Dia 2:

## Correspondencia de Patrones

### Correspondencia de Valores:

La palabra clave `match` te permite comprar un valor con uno o varios *patrones*. Las comparaciones se hacen arriba a abajo y el primer patrón que coincida gana.

Los patrones pueden ser valores simples, del mismo modo que `switch` en C y C++:

```rust
#[rustfmt::skip]
fn main() {
	let input = 'x';
	 match input {
        'q'                       => println!("Salir"),
        'a' | 's' | 'w' | 'd'     => println!("Desplazarse"),
        '0'..='9'                 => println!("Introducción de números"),
        key if key.is_lowercase() => println!("Minúscula: {key}"),
        _                         => println!("Otro"),
    }

}
```

`_` es un patrón comodín que coincide con cualquier valor. Las expresiones *deben* ser exhuastivas, lo que significa que deben tener encuenta todas las posibilidades, por lo que `_` a menudo se usa como un caso final que atrapa todo. 

`match` puede ser usado como una expresión. Al igual que con `if let`, cada brazo de coincidencia debe ser del mismo tipo. El tipo de la última expresión del bloque, si la hay. En el ejemplo anterior, el tipo es `()`.

Una variable del patrón (en este ejemplo, `key`) creará un enlace que se puede usar dentro del brazo de coincidencia.

Una protección de coincidencia hace que la expresión coincida únicamente si se cumple la condición

<aside>
💡

Puntos clave: 

- Puedes señalar cómo se usan algunos caracteres concretos en un patrón
    - `|`como `or`
    - `..` puede ampliarse tanto como sea necesario
    - `1..=5` representa un rango inclusivo
    - `_` es un comodín
- Las guardas de coincidencia, como característica sintáctica independiente, son importantes y necesarios cuando queremos expresar de forma concisa ideas más complejas de lo que permitirían los patrones por sí solos.
- No son lo mismo que una expresion `if` independiente dentro del brazo de coincidencias.
Una expresion `if` dentro del bloque de ramas ()después de `=>`) se produce tras seleccionar el brazo de coincidencias. Si no se cumple la condición `if` dentro de ese bloque, no se tienen en cuenta otros brazos de la expresión `match` original.
- La condición definida en el guarda se aplica a todas las expresiones de un patrón con un `|`.
</aside>

### Structs:

Al igual que las tuplas, las estructuras se pueden desestructurar con la coincidencia: 

```rust
struct Foo {
 x: (u32,u32),
 y: u32,
}

#[rustfmt::skip]
fn main(){
	let foo = Foo{x:(1,2),y:3};
	 match foo {
        Foo { x: (1, b), y } => println!("x.0 = 1, b = {b}, y = {y}"),
        Foo { y: 2, x: i }   => println!("y = 2, x = {i:?}"),
        Foo { y, .. }        => println!("y = {y}, se han ignorado otros campos"),
    }
}
```

- Cambia los valores literales de `foo` para que coincidan con los demás patrones.
- Añade un campo nuevo a `Foo` y realiza los cambios necesarios en el patrón.
- La diferencia entre una captura y una expresión constante puede ser difícil de detectar. Prueba a cambiar el `2` del segundo brazo por una variable y observa que no funciona. Cámbialo a `const` y verás que vuelve a funcionar.

### Enumeraciones:

Al igual que las tuplas, las enumeraciones también se pueden desestructurar con la coincidencia:

Los patrones también se pueden usar para enlazar variables a partes de los valores. Así es como se inspecciona la estructura de tus tipos. Empecemos con tipo `enum` sencillo: 

```rust
enum Result{
	Ok(i32),
	Err(String)
}

fn divide_in_two(n:i32) -> Result{
	if n%2 == 0{
		Result::ok(n/2)
	} else {
		Rsult::Err(format!("No se puede dividir {n} en dos partes iguales"))
		}
}

fn main(){
	let n = 100;
	match divide_in_two(n) {
		Result::Ok(half) => println!("{n} dividido entre dos es {half}"),
		Result::Err(msg) => println!("se ha producido un error : {msg}"),
	}
}
```

Aquí hemos utilizado los brazos para *desestructurar*  el valor de `Result`. En el primer brazo, `half` esta vinculado al valor que hay dentro de la variante `Ok`. En el segundo, `msg` está vinculado al mensaje de error.

<aside>
❓

- La expresion `if/else` devuelve una enumeración que más tarde se descomprime con `match`.

</aside>

### Control de Flujo Let:

Rust tienes algunas construcciones de control de flujo que difieren de otros lenguajes. Se utilizan para el patrón coincidencia: 

- Expresiones `if let`
- Expresiones `let else`
- Expresiones `while let`

Expresiones if let. 

La expresión `if let` nos permite ejecutar código diferente en función de si es un valor coincide con su patrón: 

```rust
use std::time::Duration;

fn sleep_for(secs:f32) {
	if let Ok(dur) = Duration::try_from_secs_f32(secs){
		std::thread::sleep(dur);
		println!("horas de sueño: {:?}",dur);
	}
}

fn main()
{
	sleep_for(-10.0);
	sleep_for(0.8);

}
```

Podemos decir que `if let` se usa en vez de `match` cuando solo hay un valor que encesitamos dar, por ejemplo: 

```rust
fn buscar_usuario(id: i32) -> Option<String> {
    if id == 1 {
        Some(String::from("Juan"))
    } else {
        None
    }
}

fn main() {
    let usuario = buscar_usuario(1);

    if let Some(nombre) = usuario {
        println!("Usuario encontrado: {}", nombre);
    } else {
        println!("Usuario no encontrado");
    }
}
```

Como observamos un uso básico del `if let`.

Expresiones `let else` :

En el caso habitual de coincidencia con un patrón y retorno de la función, utiliza `let else`. El caso “else” debe divergir(`return`,`break` o pánico; cualquier acción es válida menos colocarlo al final del bloque).

```rust
fn hex_or_die_trying(maybe_string:Option<String>)->Result<u32,String>{
	let s = if let Some(s) = maybe_string {
		s
	} else {
		return Err(String::from("se ha obtenido None"));
	};
	let first_byte_char = if let Some(first_byte_char) = s.chars().next() {
        first_byte_char
    } else {
        return Err(String::from("se ha encontrado una cadena vacía"));
    };
    
	if let Some(digit) = first_byte_char.to_digit(16) {
        Ok(digit)
    } else {
        Err(String::from("no es un dígito hexadecimal"))
    }

}

fn main() {
    println!("resultado: {:?}", hex_or_die_trying(Some(String::from("foo"))));
}
```

Al igual que con `if let`, hay una variante `while let` que prueba repetidamente un valor con respecto a un patrón. 

```rust
fn main() {
	let mut name = String::from("comprehensive Rust");
	while let Some(c) = name.pop() {
		println!("character: {c}");
	}

}
```

Aquí, [`String::pop`](https://doc.rust-lang.org/stable/std/string/struct.String.html#method.pop) devolverá `Some(c)` hasta que la cadena este vacía, cuando empezara a devolver `None`. `while let` nos permite seguir iterando a través de todos los elementos.

Resumen del libro: 

[if-let](https://google.github.io/comprehensive-rust/es/pattern-matching/let-control-flow.html#if-let)

- A diferencia de `match`, `if let` no tiene que cubrir todas las ramas, pudiendo así conseguir que sea más conciso que `match`.
- Un uso habitual consiste en gestionar valores `Some` al trabajar con `Option`.
- A diferencia de `match`, `if let` no admite cláusulas guardia para la coincidencia de patrones.

[let-else](https://google.github.io/comprehensive-rust/es/pattern-matching/let-control-flow.html#let-else)

Las instrucciones `if-let` se pueden apilar, tal y como se muestra. La construcción `let-else` permite aplanar este código anidado. Reescribe esta rara versión para que los participantes puedan ver la transformación.

[while-let](https://google.github.io/comprehensive-rust/es/pattern-matching/let-control-flow.html#while-let)

- Señala que el bucle `while let` seguirá funcionando siempre que el valor coincida con el patrón.
- Puedes reescribir el bucle `while let` como un ciclo infinito con una instrucción if que rompe el bucle si `name.pop()` no devuelve un valor para desenvolver. `while let` proporciona azúcar sintáctico para la situación anterior.

### Ejercicio: Evaluacion de expresiones:

El mero hpta ejercicio boffff. 

```rust
/// Operación que se puede llevar a cabo en dos subexpresiones.
#[derive(Debug)]
enum Operation {
    Add,
    Sub,
    Mul,
    Div,
}

/// Una expresión en forma de árbol.
#[derive(Debug)]
enum Expression {
    /// Operación en dos subexpresiones.
    Op { op: Operation, left: Box<Expression>, right: Box<Expression> },

    /// Un valor literal
    Value(i64),
}

fn eval(e: Expression) -> Result<i64, String> {
    match e {
        Expression::Value(value) => Ok(value),
        Expression::Op { op, left, right } => {
            let left_value = eval(*left)?;
            let right_value = eval(*right)?;
            match op {
                Operation::Add => Ok(left_value + right_value),
                Operation::Sub => Ok(left_value - right_value),
                Operation::Mul => Ok(left_value * right_value),
                Operation::Div => {
                    if right_value == 0 {
                        Err(String::from("división entre cero"))
                    } else {
                        Ok(left_value / right_value)
                    }
                }
            }
        }
    }
}

#[test]
fn test_value() {
    assert_eq!(eval(Expression::Value(19)), Ok(19));
}

#[test]
fn test_sum() {
    assert_eq!(
        eval(Expression::Op {
            op: Operation::Add,
            left: Box::new(Expression::Value(10)),
            right: Box::new(Expression::Value(20)),
        }),
        Ok(30)
    );
}

#[test]
fn test_recursion() {
    let term1 = Expression::Op {
        op: Operation::Mul,
        left: Box::new(Expression::Value(10)),
        right: Box::new(Expression::Value(9)),
    };
    let term2 = Expression::Op {
        op: Operation::Mul,
        left: Box::new(Expression::Op {
            op: Operation::Sub,
            left: Box::new(Expression::Value(3)),
            right: Box::new(Expression::Value(4)),
        }),
        right: Box::new(Expression::Value(5)),
    };
    assert_eq!(
        eval(Expression::Op {
            op: Operation::Add,
            left: Box::new(term1),
            right: Box::new(term2),
        }),
        Ok(85)
    );
}

#[test]
fn test_error() {
    assert_eq!(
        eval(Expression::Op {
            op: Operation::Div,
            left: Box::new(Expression::Value(99)),
            right: Box::new(Expression::Value(0)),
        }),
        Err(String::from("división entre cero"))
    );
}

fn main() {}
```

## Métodos y Traits

### Métodos:

Rust permite asociar funciones a los nuevos tios. Para ello, usa un bloque `impl`:

```rust
struct Race{
	name: String,
	laps: Vec<i32>,
}

impl Race {
	// No hay receptor, método estática
	fn new(name: &str) -> Self{
		Self { name: String::from(name), laps: Vec::new()}
		
		fn add_lap(&mut self, lap:i32){
			self.laps.push(lap);
		}
		
		
	}

	fn print_laps(&self){
		println!("Se han registrado {} vueltas de {}", self.laps.len(), self.name);
		for (idx,lap) in self.laps.iter().enumerate() {
			println!("Vuelta {idx}: {lap} s");
		}
	}
	
	// Propiedad exclusiva de self
	fn finish(self) {
        let total: i32 = self.laps.iter().sum();
        println!("La carrera {} ha terminado. Duración total de la vuelta: {}.", self.name, total);
    }
}

fn main() {
    let mut race = Race::new("Gran Premio de Mónaco");
    race.add_lap(70);
    race.add_lap(68);
    race.print_laps();
    race.add_lap(71);
    race.print_laps();
    race.finish();
    // race.add_lap(42);
}
```

El argumento `self` denomina el “receiver” (receptor) - el objeto sobre cual el método actuará. Hay varios receivers comunes para un método:

- `&self`: toma prestado el objeto del
llamador utilizando una referencia compartida e inmutable. El objeto se
puede volver a utilizar después.
- `&mut self`: toma prestado el objeto del llamador mediante una referencia única y mutable. El objeto se puede volver a utilizar después.
- `self`: asume el *ownership* del
objeto y lo aleja del llamador. El método se convierte en el propietario del objeto. El objeto se eliminará (es decir, se anulará la asignación) cuando el método devuelva un resultado, a menos que se transmita su *ownership* de forma explícita. El *ownership* completa no implica automáticamente una mutabilidad.
- `mut self`: igual que lo anterior, pero el método puede mutar el objeto.
- Sin receptor: se convierte en un método estático de la estructura.
Normalmente se utiliza para crear constructores que se suelen denominar `new`.

```rust
// Otro código para enteder mejor un poco la sintaxis: 
struct Auto {
    marca: String,
    modelo: String,
    encendido: bool,
}

impl Auto {
    // Método que usa `&self` (referencia inmutable)
    fn info(&self) {
        println!("Auto: {} {} - Encendido: {}", self.marca, self.modelo, self.encendido);
    }

    // Método que usa `&mut self` (referencia mutable)
    fn encender(&mut self) {
        self.encendido = true;
        println!("El auto ha sido encendido.");
    }

    // Método que usa `self` (toma la propiedad)
    fn destruir(self) {
        println!("El auto {} {} ha sido destruido.", self.marca, self.modelo);
    }
}

fn main() {
    let mut mi_auto = Auto {
        marca: String::from("Toyota"),
        modelo: String::from("Corolla"),
        encendido: false,
    };

    mi_auto.info();  // Llama al método `info`
    mi_auto.encender(); // Modifica la estructura
    mi_auto.info();  // Ahora el auto está encendido

    // mi_auto.destruir(); // Si lo llamamos, ya no podríamos usar `mi_auto`
}

```

### Traits:

Rust te permite abstraer sobre tipos con *traits.* Son similares a las interfaces: 

```rust
trait Pet{
	fn talk(%self)->String;
	fn greet(&self);
}
```

- Un trait define una serie de métodos que los tipos deben tener para implementar el trait.
- En la sección de “Genéricos” a seguir, veremos como construir
funcionalidad que es genérico sobre todos los tipos implementando un
trait.

Implementación de Traits.

```rust
trait Pet {
	fn talk(&self)->String;
	
	fn greet(%self) {
		println!("Eres una monada, como te llamas? xddd {}",self.talk());
	}
}

struct Dog {
	name: String,
	age: i8
}

impl Pet for Dog {
	fn talk(&self) -> String {
        format!("¡Guau, me llamo {}!", self.name)
    }
}

fn main() {
    let fido = Dog { name: String::from("Fido"), age: 5 };
    fido.greet();
}
```

Los *traits* pueden especificar implementaciones predeterminadas de algunos métodos. Implementaciones predeterminadas pueden usar todos los métodos de un trait (incluso los métodos que los usuarios deben implementar ellos mismos). En este caso, `greet` es predeterminado y utiliza `talk`.

Para implementar `Trait` para un tipo `Type`, utiliza un bloque `impl Trait for Type { .. }`.

Creo que no se toca el `Type` entonces rapidamente que es?: 

### Type [Auxiliar]

En Rust, la palabra clave `type` se usa para crear un **alias de tipo**. Esto NO crea un nuevo tipo, solo le da un nombre más facíl de recordar a un tipo existente jijij

### Supertraits:

Un trait puede requerir que los tipos que lo implementan tambien implementen otros traits, llamados *supertraits.* Aquí, cualquier tipo implementado `Pet` también debe implementar `Animal`.

```rust
trait Animal {
	fn leg_count(&self)->u32;
}
trait Pet: Animal {
	fn name(&señf)->String;
}
struct Dog(String);

impl Animal for Dog{
	fn leg_count(&self) -> u32 {
        4
    }
}
impl Pet for Dog {
    fn name(&self) -> String {
        self.0.clone()
    }
}

fn main() {
    let puppy = Dog(String::from("Rex"));
    println!("{} tiene {} piernas", puppy.name(), puppy.leg_count());
}
```

Algunas veces esto es llamado “herencia de traits”, pero los estudiantes no deben esperar que esto se comporte como la herencia OO (object-oriented). Solo especifica un requerimiento adicional sobre las implementaciones de un trait.

### Tipos de datos asociados

Los tipos asociados son tipos guarda-espacio que han sido proveídos por la implementación del trait.

```rust
struct Meters(i32);
struct MeterSquared(i32);

trait Multiply{
	type Output;
	fn multiply(&self,other:&Self)->Self::Output;
}

impl Multiply for Meters{
	type Output = MeterSquared;
	fn multiply(&self,other:&Self) ->Self::Output{
		MetersSquared(self.0 * other.0)
	}
}
```

- `type Output;` define un **tipo asociado**. En este caso, el resultado de `multiply` será un tipo diferente (metros cuadrados).
- `fn multiply(&self, other: &Self) -> Self::Output;` define un método que:
    - Recibe `&self` (una referencia inmutable al primer operando).
    - Recibe `other: &Self` (una referencia inmutable al segundo operando).
    - Devuelve `Self::Output`, es decir, el resultado de multiplicar dos valores del mismo tipo.

Aquí, `Self` representa **el tipo que implementará este `trait`**.

## Derivación de Traits

Los traits compatibles se pueden implementar de forma automática en los tipos personalizados de la siguiente manera: 

```rust
#[derive(Debug,Clone,Default)]
struct Plater {
	name: String,
	strenght: u8,
	hit_points: u8
}

fn main(){
	let p1 = Player::default(); // El trait predeterminado añade el constructor 'default'
	let mut p2 = p1.clone(); // Trait de clonador
	p2.name = String::from("EldurScrollz");
	// el trait Debug permite que sea compatible con imprimir con '{:?}'
	println!("{:?} contra {:?} ",p1,p2);
}
```

### Ejercicio : trait de registro:

```rust
use std::fmt::Display;

pub trait Logger {
    /// Registra un mensaje con el nivel de verbosidad determinado.
    fn log(&self, verbosity: u8, message: impl Display);
}

struct StderrLogger;

impl Logger for StderrLogger {
    fn log(&self, verbosity: u8, message: impl Display) {
        eprintln!("verbosidad={verbosity}: {message}");
    }
}

fn do_things(logger: &impl Logger) {
    logger.log(5, "Para tu información");
    logger.log(2, "Oh, oh");
}

struct VerbosityFilter
{
    max_verbosity: u8,
    inner: StderrLogger,
}

impl Logger for VerbosityFilter {
    fn log(&self, verbosity: u8, message: impl Display) {
        if verbosity <= self.max_verbosity {
            self.inner.log(verbosity, message);
        }
    }
}

fn main() {
    let l = VerbosityFilter { max_verbosity: 3, inner: StderrLogger };
    do_things(&l);
}
```

## Genericos

Rust admite el uso de genéricos, lo que permite abstraer los algoritmos o las estructuras de datos (comomo el ordenamiento o un arbol binario) sobre los tipos utilizados o almacenados. 

```rust
fn pick<T>(n:i32,event:T,odd:T) -> T {
	if n %  2 == 0{
		event
	}
	else {
		odd
		}
}
fn main() {
	println!("numero elegido: {:?}",pick(97,222,333));
	println!("tupla elegida: {:?}", pick(28, ("perro", 1), ("gato", 2)));

}
```

Rust infiere un tipo para T en función de los tipos de los argumentos y del valor devuelto.

Es similar a las plantillas de C++, pero Rust compila de forma parcial la función genérica de forma inmediata, por lo que debe ser válida para todos los tipos que coincidan con las restricciones. Por ejemplo, prueba a modificar `pick` para que devuelva `even+odd` si `n==0` .Aunque solo se use la instanciación `pick` con números enteros, Rust seguirá considerando que no es válida. En cambio, c++ lo permitiría.

Código genérico es convertido en código no genérico basada en los sitios de ejecución. Se trata de una abstracción sin coste: Se obtiene exactamente el mismo resultado que si se hubiesen programado de forma manual las estructuras de datos sin la abstracción. 

### Tipos de Datos Genéricos:

Puedes usar genéricos para abstraer el tipo de campo concreto: 

```rust
#[derive(Debug)]
struct Point<T>{
	x:T,
	y:T,
}

impl<T> Point<T> {
 fn coords(&self) -> (&T, &T) {
        (&self.x, &self.y)
    }

    fn set_x(&mut self, x: T) {
        self.x = x;
    }
}

fn main() {
    let integer = Point { x: 5, y: 10 };
    let float = Point { x: 1.0, y: 4.0 };
    println!("{integer:?} y {float:?}");
    println!("coordenadas: {:?}", integer.coords());
}
```

### Traits Gnéricos:

Los traits también pueden ser genéricos, como los tipos y las funciones. Los parámetros de un trait obtienen tipos concretos cuando es usado : 

```rust
#[derive(Debug)]
struct Foo(String);

impl From<u32> for Foo {
    fn from(from: u32) -> Foo {
        Foo(format!("Convertido del numero entero: {from}"))
    }
}

impl From<bool> for Foo {
    fn from(from: bool) -> Foo {
        Foo(format!("Convertido del bool: {from}"))
    }
}

fn main() {
    let from_int = Foo::from(123);
    let from_bool = Foo::from(true);
    println!("{from_int:?}, {from_bool:?}");
}
```

El trait `from` sera discutido mas tarde, pero su definicion en la documentacion std es simple.

Las implementaciones del trait no necesitan cubrir todos los parámetros de tipos posibles.
Aquí, `Foo::from("hello")` no compilaría porque no hay una implementación `From<&str>`para `Foo`.

Tipos genéricos toman tipos como entradas, mientras tipos asociados son tipos de salida. Un trait puede tener varias implementaciones para diferentes tipos de entrada.

De hecho Rust requiere que a lo más solo una implementación de un trait coincida con cualquier tipo T. A diferencia de otros lenguajes, Rust no tiene una heurística para escoger la coincidencia “más especifica”. Hay trabajo corriente para implementar esta heurística, llamado **especializacion**. 

### Trait Bounds

Cuando se trabaj con genéricos, a menudo se prefiere que los tipos implementen alguún trait, de forma que se pueda llamar a los métodos de este trait. 

Puedes hacerlo con `T: Trait` o `impl Trait` : 

```rust
fn duplicate<T: Clone>(a: T) -> (T,T) { // El tipo T tiene que si o si implementar clone
	(a.clone(), a.clone())
}

fn main() {
    let foo = String::from("foo");
    let pair = duplicate(foo);
    println!("{pair:?}");
}
```

También podemos usar una clausula where: 

```rust
fn duplicate<T>(a: T) -> (T, T)
where
    T: Clone,
{
    (a.clone(), a.clone())
}
```

Es exactamente igual que la parte de arriba pero siendo una clausula explicita. 

### `impl` Trait:

De forma similar a los límites `traits`, se puede usar la sintaxis `impl Trait` en argumentos de funciones y valores devueltos: 

```rust
// Azúcar sintáctico para:
//   fn add_42_millions<T: Into<i32>>(x: T) -> i32 {
fn add_42_millions(x: impl Into<i32>) -> i32 {
    x.into() + 42_000_000
}

fn pair_of(x: u32) -> impl std::fmt::Debug {
    (x + 1, x - 1)
}

fn main() {
    let many = add_42_millions(42_i8);
    println!("{many}");
    let many_more = add_42_millions(10_000_000);
    println!("{many_more}");
    let debuggable = pair_of(27);
    println!("depurable: {debuggable:?}");
}
```

`impl Trait` te deja trabajar con tipos que no puedes nombrar. El significado de `impl Trait` es un poco diferente dependiendo de su posición.

- En el caso de los parámetros, `impl Trait` es como un parámetro genérico anónimo con un límite de trait.
- En el caso de un tipo de resultado devuelto, significa que este es un tipo concreto que implementa el trait, sin nombrar el tipo. Esto puede
ser útil cuando no quieres exponer el tipo concreto en una API pública.
    
La inferencia es más complicada en la posición de retorno. Una función que devuelve `impl Foo` elige el tipo concreto que devuelve, sin escribirlo en el código fuente. Una función que devuelve un tipo genérico como `collect<B>() -> B` puede devolver cualquier tipo que cumpla `B`, y es posible que el llamador tenga que elegir uno, como con `let x: Vec<_> = foo.collect()` o con la sintaxis turbofish, `foo.collect::<Vec<_>>()`.