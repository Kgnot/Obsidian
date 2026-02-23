---
type: course
status: en_progreso
tags: [course, Java semi-avanzado (Curso)]
date_started: 2024-05-20
---

# Java semi-avanzado

# Streams y expresiones lambda

 Los Streams permiten realizar operaciones de manera declarativa, facilitando la escritura de código más legible y conciso.

Podemos crear Stream partiendo de un arreglo a lista : 

```java
String[] arr = {"a", "b", "c"};
Stream<String> stream = Arrays.stream(arr);
Stream<String> streamOf = Stream.of("a", "b", "c");
List<String> list = Arrays.asList(arr);
Stream<String> streamFromList = list.stream();

// cuando lo hacemos directamente de listas estas contienen la funcion: 

List<String> paises = new ArrayList(){"Arabia","Colombia","Peru","China"};
// podemos hacerlo con lambda: 
paises.stream().forEach(cualquierLetraxD-> System.out.println(" "+cualquierLetraxD));
// o por referencia de metodos
paises.stram().forEach(System.out::println);
// ambas daran el mismo resultado
```

Los streams tienen muchas operaciones de las más famosas entran los “parallels”

```java
List<String> paises = new ArrayList(){"Arabia","Colombia","Peru","China"};
paises.stream().parallel().forEach(System.out::println);
// Esto hace que cada uno de los items de paises se corra de forma paralela, o en su mayoría
```

Recordar que esto de los Streams tambien usa un patrón de diseño llamado Pipeline

```java
// Este consiste rapidamente en poder concatenear funciones: 
List<String> paises = new ArrayList(){"Arabia","Colombia","Peru","China"};
paises.stream().filter(paises -> paises.startWith("C")).forEach(System.out::println);
// Esto me devolverá Colombia y China

// Tambien podemos hacerlo por rerfferencia de fucniones, podemos crear: 

public boolean filterCities(String city)
{
	return city.startWith("C")
}

//---

paises.stream().filter(Main::filterCities)
						.forEach(System.out::println);

```

Los stream tienen metodos terminales y no terminales, los metodos terminales son como “forEach” mientras hay otros no terminales como “filter”. Podemos también usar Collection como método terminal. PE:

```java
List<String> filterPaises = paises.stream()
						.filter(Main::filterCities)
						.collect(Collection.toList());
```

Nota para recordar y es que si un Stream no tiene ningún método terminal no se ejecuta absolutamente nada.

# WebScraper con Concurrencia:

Lo primero para empezar es descargar la información de la web: 

```java
public class Main{

	public static void main(String... args) throw IOException
	{
		// Downlosads webs 
		String url = "https://www.bbc.com/"; // es la priemra pagina web que vamos a visitar
		URL url = new URL(url);	
		HttpURLConnection conn = (HttpURLConnection) url.openConnection(); // asi nos conectamos a esa url - ademas de parcearla
		
		String encoding = conn.getContentEncodign(); // aqui traemos la cabecera 
		InputStream input = null; // creamos solo una referencia
		input= conn.getInputStream(); // aunque se podría hacer en una sola linea
			String result = new BufferedReader(new InputStreamReader(input))
																.lines().collect(Collection.joining()); //el Lines nos genera un Stream y con collect lo juntamos
			// absolutamente todo usando Collection.joining() :D, este genera un Strnig
		
	}

}
```

Haciéndolo más lindos tenemos: 

```java
public class Main{

	public static void main(String... args){
		// Downlosads webs 
		List<String> links = new ArrayList();
		links.add("https://www.bbc.com/");
		links.add("https://www.bbc.com/boxeo");
		links.add("https://www.bbc.com/futbol");
		links.add("https://www.bbc.com/hockey");
		links.add("https://www.bbc.com/baloncesto");

		links.stream().parallel().forEach(Main::getWebContent);		
		
	}
	
	private static String getWebContent(String link)
	{
		try{
			URL url = new URL(url);	
			HttpURLConnection conn = (HttpURLConnection) url.openConnection(); // asi nos conectamos a esa url - ademas de parcearla
			
			String encoding = conn.getContentEncodign(); // aqui traemos la cabecera 
			InputStream input = null; // creamos solo una referencia
			input= conn.getInputStream(); // aunque se podría hacer en una sola linea
			String result = new BufferedReader(new InputStreamReader(input))
																	.lines().collect(Collection.joining()); //el Lines nos genera un Stream y con collect lo juntamos
				// absolutamente todo usando Collection.joining() :D, este genera un Strnig
	
			return result;
		}
		catch(IOException e)
		{
		System.out.printl("Hay error: "+e.getMessage());
		}
		return null;
	}
}
```

En el ejemplo de arriba hablamos de concurrencia, y encontramos que es mucho más rapido hacer las consultas con el `parallel()` .

Existen también los `syncronized`  que básicamente son los mismos `async` en javascript :D

# Variables Atómicas

### ¿Qué son las variables atómicas?

Son **clases especiales** en el paquete `java.util.concurrent.atomic` que permiten **operaciones atómicas** sobre variables compartidas en un entorno multihilo (concurrencia). Estas operaciones atómicas son indivisibles, lo que significa que **no pueden ser interrumpidas por otros hilos**, evitando problemas típicos de **condiciones de carrera**.

### ¿Para qué sirven?

Son una **alternativa ligera** a usar `synchronized` o `ReentrantLock` cuando solo necesitas actualizar una variable simple (como un contador) de forma segura en múltiples hilos.

### Ejemplos de clases atómicas

| Clase | Tipo que maneja |
| --- | --- |
| `AtomicInteger` | int |
| `AtomicLong` | long |
| `AtomicBoolean` | boolean |
| `AtomicReference<T>` | referencia a cualquier objeto |

### ¿Por qué son eficientes?

Internamente usan **instrucciones CPU de bajo nivel** (como CAS) que son soportadas directamente por el hardware, evitando bloqueos pesados como los de `synchronized`.

Un ejemplo de código es el siguiente: 

```java
public class Main
{
	public static void main(String... str)
	{
		Contador cont = new Contador();
		
		Thread hilo1 = new Thread(cont,"hilo1");
		Thread hilo2 = new Thread(cont,"hilo2");
		
		hilo1.start();
		hilo2.start(;
		
		hilo1.join();
		hilo2.join();
		
		System.out.println(cont.cont);
		
	}

	// Creamos la clase necesaria que queremos hacer en hilos
	static class Contador extends Thread
	{
			public AtomicInteger cont = new AtomicInteger(0);
			
			public void run(){
				for(int i = 0 ; i < 100_000_000; i++)
				{
					cont.addAndGet(1);
				}
			
			}
	}
}
```

La clase de arriba hacemos los start para iniciar cada uno de los hilos, luego con el join hacemos que espere a que se termine cada uno de los hilos. Estos no se sobrescribirán uno sobre otro ya que usa la clase `AtomicInteger`  para que no hayan conflictos en lectura y seteo del atributo. 

Luego que terminen los dos hilos, el valor impreso será 2’000.000 :D

# Tipos de problemas al trabajar con concurrencia

Hay 3 tipos de problemas a  la hora de trabajar con concurrencia: 

- Deadlock
- Livelock
- Starvation

### ¿Qué es un Deadlock?

Un **deadlock** ocurre cuando **dos o más hilos quedan bloqueados indefinidamente** porque cada uno está esperando un recurso que tiene el otro.

En otras palabras, **ninguno puede continuar porque ambos están esperando que el otro suelte un recurso**. Es como cuando dos personas se quedan atoradas en una puerta porque ninguna quiere ceder el paso.

```java
public class Main {
    public static void main(String[] args) {
// Create participants and resources
        Fox robin = new Fox();
        Fox miki = new Fox();
        Food food = new Food();
        Water water = new Water();
// Process data
        ExecutorService service = null;
        try {
            service = Executors.newScheduledThreadPool(10);
            service.submit(() -> robin.eatAndDrink(food,water));
            service.submit(() -> miki.drinkAndEat(food,water));
        } finally {
            if(service != null) service.shutdown();
        }
    }
}

class Food {}

class Water {}

class Fox {
    public void eatAndDrink(Food food, Water water) {
        synchronized(food) {
            System.out.println("Robin: Got deadlock.Food!");
            move();
            synchronized(water) {
                System.out.println("Robin: Got deadlock.Water!");
            }
        }
    }
    public void drinkAndEat(Food food, Water water) {
        synchronized(water) {
            System.out.println("Miki: Got deadlock.Water!");
            move();
            synchronized(food) {
                System.out.println("Miki: Got deadlock.Food!");
            }
        }
    }
    public void move() {
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
// Handle exception
        }
    }
}
```

Aquí es sencillo de entender que es lo que deseamos, el único inconveniente es: 

```java
   ExecutorService service = null;
        try {
            service = Executors.newScheduledThreadPool(10);
            service.submit(() -> robin.eatAndDrink(food,water));
            service.submit(() -> miki.drinkAndEat(food,water));
        } finally {
            if(service != null) service.shutdown();
        }
```

En este fragmento de código nosotros usamos la interfaz: `ExecutorService` la cual es una interfaz que nos ayuda a crear hilos de manera sencilla y rápida. 

Aquí nosotros usamos el método `newScheduleThreadPool(*num*)` para decir cuantos hilos va a tener de “pool”. Luego usamos el `submit()` para ejecutar una función mediante una función lambda, hilos. Y después del try usamos un `finally` para que al final de todo el servicio de pool de hilos se cierre y deje de consumir innecesariamente memoria. 

### ¿Qué es un Livelock?

Un **livelock** es un problema de concurrencia donde **dos o más hilos están constantemente cambiando de estado en respuesta a lo que hace el otro, pero ninguno logra progresar**.

Es como cuando dos personas intentan cruzar una puerta al mismo tiempo, y ambos ceden el paso, luego intentan avanzar al mismo tiempo, vuelven a ceder, y así infinitamente. Ambos **están "vivos" (en ejecución), pero atrapados en un ciclo sin fin.**

```java
public class Main {
    public static void main(String[] args) {
// Create participants and resources
        Fox robin = new Fox();
        Fox miki = new Fox();
        Food food = new Food();
        Water water = new Water();
// Process data
        ExecutorService service = null;
        try {
            service = Executors.newScheduledThreadPool(10);
            service.submit(() -> robin.eatAndDrink(food,water));
            service.submit(() -> miki.drinkAndEat(food,water));
        } finally {
            if(service != null) service.shutdown();
        }
    }
}

class Food {}

class Water {}

class Fox {
    public void eatAndDrink(Food food, Water water) {
        synchronized(food) {
            System.out.println("Got Food!");
            move();
        }
        drinkAndEat(food, water);
    }
    public void drinkAndEat(Food food, Water water) {
        synchronized(water) {
            System.out.println("Got Water!");
            move();
        }
        eatAndDrink(food, water);
    }
    public void move() {
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
// Handle exception
        }
    }
}
```

## ¿Qué es un Startvation?

En términos simples, **starvation** (o inanición) ocurre cuando **un hilo nunca consigue acceso a un recurso compartido** porque **otros hilos constantemente lo acaparan**.

Es como si estuvieras en la fila de un buffet, pero siempre dejan pasar a la gente VIP y tú te quedas esperando... y esperando... y esperando...

```java
public class Main {
    public static void main(String[] args) {
// Create participants and resources
        Fox robin = new Fox();
        Fox miki = new Fox();
        Elephant dumbo = new Elephant();
        Food food = new Food();
// Process data
        ExecutorService service = null;
        try {
            service = Executors.newScheduledThreadPool(10);
            service.submit(() -> dumbo.eat(food));
            service.submit(() -> robin.eat(food));
            service.submit(() -> miki.eat(food));
        } finally {
            if(service != null) service.shutdown();
        }
    }
}

class Food {}

class Elephant {
    public void eat(Food food) {
        synchronized(food) {
            System.out.println("Elephant got Food!");
            try {
                Thread.sleep(60 * 1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

class Fox {
    public void eat(Food food) {
        move();
        synchronized(food) {
            System.out.println("Got Food!");
        }
    }
    public void move() {
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            // Handle exception
        }
    }
}
```

## Diferencias entre Deadlock, Livelock y Star

| Concepto | Deadlock | Livelock | Starvation |
| --- | --- | --- | --- |
| **¿Hilos activos?** | No | Sí, pero atrapados | Sí, pero ignorados |
| **¿Hilos progresan?** | No | No | No, por falta de acceso |
| **Causa** | Espera circular | Respuesta mutua sin progreso | Injusticia o prioridad desbalanceada |

| **Problema** | **Descripción** | **Causa Común** | **Estado de los Hilos** | **Ejemplo Real** | **Solución Típica** |
| --- | --- | --- | --- | --- | --- |
| **Deadlock** | Dos o más hilos quedan **bloqueados permanentemente**, esperando recursos que tiene el otro. | Espera circular de recursos. | **Bloqueados** (no avanzan) | Dos carros en una calle angosta, cada uno bloqueando el paso del otro. | Ordenar el acceso a recursos o usar timeouts. |
| **Livelock** | Dos o más hilos **siguen ejecutando, pero nunca progresan**, porque ceden el paso mutuamente. | Respuesta mutua infinita. | **Activos**, pero no avanzan | Dos personas cediéndose el paso al mismo tiempo y ninguna cruza la puerta. | Evitar comportamiento de cortesía recíproca. |
| **Starvation** | Un hilo de baja prioridad **nunca obtiene acceso** a un recurso porque otros hilos siempre lo acaparan. | Políticas de prioridad injustas. | **Activos**, pero ignorados | Clientes normales nunca son atendidos en un call center porque hay demasiados VIP. | Usar locks **justos** (ReentrantLock(true)), colas FIFO o políticas de fairness |

# Optional en java:

Los optional nos brindan a nosotros una solución a los `NullPointerException` mediante una clase contenedora que intenta representar un valor que puede o no puede estar presente, así puede devolver un valor presente o uno no presente o empty. Nos brinda cosas como: 

- Obliga al programador a **manejar el caso donde el valor no existe**.
- Hace más explícito que un método **podría no devolver nada**.
- Facilita el uso de **programación funcional**.

```java
// Un ejemplo de Optional viene siendo en: 
List<String> countries = new ArrayList(){"Colombia","Japón","Argentina"};

// Si deseamos recorrer la list y buscar por ejemplo un elemento
Optional<String> country = countries.stream().filter(c->c.startsWith("Arg")).findFirst(); // esto nos devuelve un optional. Y :
country.ifPresent(System.out::println);

// Optional nos da varios métodos para evaluar si esta o no el dato. y evitar el NullPointerException 
// Como es el "isPresent" para saber si esta presente y m'as
```

## Métodos de `Optional`

| Método | Descripción | Ejemplo |
| --- | --- | --- |
| **`empty()`** | Devuelve un `Optional` vacío (sin valor). | `Optional<String> opt = Optional.empty();` |
| **`of(valor)`** | Crea un `Optional` con el valor. Si el valor es `null`, lanza excepción. | `Optional<String> opt = Optional.of("Hola");` |
| **`ofNullable(valor)`** | Crea un `Optional` que puede ser vacío si el valor es `null`. | `Optional<String> opt = Optional.ofNullable(obtenerNombre());` |
| **`isPresent()`** | Devuelve `true` si el Optional tiene valor. | `if (opt.isPresent()) { ... }` |
| **`isEmpty()` (Java 11)** | Devuelve `true` si el Optional está vacío. | `if (opt.isEmpty()) { ... }` |
| **`get()`** | Devuelve el valor si está presente, lanza excepción si está vacío (⚠️ peligroso). | `String valor = opt.get();` |
| **`ifPresent(Consumer)`** | Ejecuta un `Consumer` si hay valor. | `opt.ifPresent(v -> System.out.println(v));` |
| **`ifPresentOrElse(Consumer, Runnable)` (Java 9)** | Ejecuta una acción si hay valor o una alternativa si no hay. | `opt.ifPresentOrElse(v -> System.out.println(v), () -> System.out.println("Vacío"));` |
| **`orElse(valor)`** | Devuelve el valor o uno por defecto si está vacío. | `String nombre = opt.orElse("Desconocido");` |
| **`orElseGet(Supplier)`** | Igual que `orElse`, pero usando una función. | `String nombre = opt.orElseGet(() -> generarNombre());` |
| **`orElseThrow()`** | Lanza `NoSuchElementException` si está vacío. | `String nombre = opt.orElseThrow();` |
| **`orElseThrow(Supplier)`** | Lanza una excepción personalizada si está vacío. | `String nombre = opt.orElseThrow(MiExcepcion::new);` |
| **`map(Function)`** | Transforma el valor si está presente. | `Optional<String> mayus = opt.map(String::toUpperCase);` |
| **`flatMap(Function)`** | Igual que `map`, pero la función devuelve otro `Optional`. | `opt.flatMap(this::buscarApodo);` |
| **`filter(Predicate)`** | Deja pasar el valor solo si cumple una condición. | `Optional<String> valido = opt.filter(n -> n.length() > 3);` |
| **`stream()` (Java 9)** | Convierte el Optional en un Stream de 0 o 1 elementos. | `opt.stream().forEach(System.out::println);` |

Ejemplo practico:

```java
public class EjemploOptional {

    public static void main(String[] args) {
        Optional<String> nombre = Optional.ofNullable(obtenerNombre());

        nombre.ifPresentOrElse(
            n -> System.out.println("Hola, " + n.toUpperCase()),
            () -> System.out.println("Hola, Invitado")
        );

        String nombreFinal = nombre
            .filter(n -> n.length() > 3)
            .map(String::toUpperCase)
            .orElse("SIN NOMBRE");

        System.out.println("Nombre final: " + nombreFinal);
    }

    static String obtenerNombre() {
        return Math.random() > 0.5 ? "Carlos" : null;
    }
}
```

![image.png](src/Java%20semi-avanzado/image.png)

# Lambda de Java

El paquete proporciona interfaces funcionales estándar basadas en bibliotecas para requisitos comunes con su correspondiente expresión lambda, que el programador puede utilizar en su código en lugar de crear interfaces funcionales nuevas.

## Consumer

Los consumer son una interfaz que:

- Recibe un solo argumento de cualquier tipo
- No devuelve nada
- Su función es realizar alguna acción como imprimir, guardar, registrar.

```java
// Como ejemplos de código tenemos
Consumer<String> imprimir = mensaje -> System.out.println("mensaje: "+mensaje);
imprimir.accept("Hola de un mensaje" );

// Podemos hacerlo más bonito de la siguiente forma: 
public class Main {
    public static void main(String... args)
    { 
        decirAlgo(System.out::println,"hola desde funcion");
    }    

    public static <T> void decirAlgo(Consumer<? super T> consum, T t)
    {
        consum.accept(t);
    }
}

// Y aunque el ejemplo de arriba tencicamente no sirve para mucho, es muy util este consumer en la clase List ya que el foreach tiene esta forma: 

  default void forEach(Consumer<? super T> action) {
        Objects.requireNonNull(action);
        for (T t : this) {
            action.accept(t);
        }
    }
   
   // Donde con un consumer creamos todo :D
```

## Function

Los Function a diferencia de algun consumer , este recibe un valor y recibe otro no necesariamente iguales, un buen ejemplo de este son los “map” en los Stream: 

```java
// En function está: 
<R> Stream<R> map(Function<? super T, ? extends R> mapper);
// Lo que nosotors podemos hacer: 

List<String> nombres =  Arrays.asList("Maria","jose","Juan");
nombres.stream()
				.map(m -> m+"| se agrego "  ) // Aqui devuelve algo, que devuelve?
				.forEach(System.out::println);

// Lo que esperamos es: 
```

Maria| se agrego
jose| se agrego
Juan| se agrego

Como observamos el map nos devuelve en cada uno algo, es porque esta es una Function<T,R> . En esté caso significa que este Function acepta  cualquier supertipo de T y devuelve cualqueir subtipo de R. Esto hace que sea más flexible :D . En nuestro caso “usamos” una “Function<String,String>” .

## Predicate

En este caso evaluamos una condición sobre un valor, básicamente solo creamos un predicate, como un filter :D.

```java
// Estrucutra de la interfaz: 
Stream<T> filter(Predicate<? super T> predicate);

// usando el mismo ejemplo del pasado :
List<String> nombres =  Arrays.asList("Maria","jose","Juan","julian");
nombres.stream()
				.map(m -> m+"| se agrego "  ) // Aqui devuelve algo, que devuelve?
				.filter(m -> m.startWith("ju"))
				.forEach(System.out::println);
				
// La respuesta esperada es:
```

julian| se agrego 

### Aqui una tabla de más funciones o interfaces de esta librería  :D

| Interfaz | Parámetros | Retorno | Descripción |
| --- | --- | --- | --- |
| **Consumer<T>** | 1 | `void` | Ejecuta una acción con un valor, no devuelve nada. |
| **BiConsumer<T, U>** | 2 | `void` | Igual a Consumer, pero con dos valores. |
| **Function<T, R>** | 1 | 1 (de otro tipo) | Recibe un valor y devuelve otro (pueden ser distintos). |
| **BiFunction<T, U, R>** | 2 | 1 | Igual que Function, pero con dos valores de entrada. |
| **Predicate<T>** | 1 | `boolean` | Evalúa una condición sobre un valor. |
| **BiPredicate<T, U>** | 2 | `boolean` | Igual que Predicate, pero con dos valores de entrada. |
| **Supplier<T>** | 0 | 1 | No recibe nada, solo **genera y devuelve un valor**. |
| **UnaryOperator<T>** | 1 | 1 (mismo tipo) | Una `Function` que devuelve el mismo tipo. |
| **BinaryOperator<T>** | 2 | 1 (mismo tipo) | Operador binario que combina dos valores del mismo tipo. |

# Fechas en Java.

Antes se usaba la clase calendario o `Calendar`  ahora se usa la clase `LocalDate`,`LocalTime`,`LocalDateTime`. De la siguiente forma: 

```java
// uno de los ejemplos rapidos serían: 
Calendar c =  Calendar.getInstance();
c.set(2022,Calendar.JANUARY,1); // Esto era mutable y la verdad poco util
// Con la llegada de LocalDate, LocalTime y LocalDateTime todo mejora: 
LocalDate d =  LocalDate.of(2022,Month.JANUARY,1); 
LocalTime t = LocalTieme.of(10,0); 
LocalDateTime dt = LocalDateTime.of(d,t) // esto tiene muchos argumentos pero podria ser así. Los argumentos se verán cuando se use :D
// Hay otro llamado: 
DataZoneTime // -> Usado para trabajar con varias zonas del mundo pero es un poco complejo por lo que dicen

// Dentro de datetime podmos usar el metodo "minus" para restar lo que deseemos se vería de esta forma: 
```

![image.png](src/Java%20semi-avanzado/image%201.png)

Donde me genera nuevos objetos de `LocalDateTieme` como podemos observar. Existen muchos métodos para saber  si una fecha es anterior o no a otra, etc. Tambien hay Formatos de fecha

![image.png](src/Java%20semi-avanzado/image%202.png)

![image.png](src/Java%20semi-avanzado/image%203.png)

# Variables atómicas

Aquí veremos un uso más funcional de las variables atómicas. 

Supongamos que tenemos una página web para comprar vuelos online, queremos calcular el precio promedio y el precio más bajo de un vuelo, eso debemos consultar distintas aerolineas en el mundo. 

```java
public class Main()
{
		private static Map<String,Double> priceByAirline = new HashMap<>();

		public static void main(String... str)
		{
				init();
				String from = "BCN"; // aeropuerto de barcelona
				String to = "JFK"; // aeropuerto de new york
				Double lowestPrice = getLowestPrice(from,to);
				Double avgPrice = getAvgPrice(from,to);
						
		}
		
		private Double getLowestPrice(String from, String to)
		{
			// Aquí buscaría
			AtomicReference<Double> lowerPrice = new AtomicReference<>(null);
			priceByAirline.keySet().stream().parallel().forEach(airline ->  {
					Double price = getPriceTrip(airline,from,to);
					if(lowestPrice.get() == null || lowestPrice.get()>price)
					{
						lowestPrice.set(price);
					}
				}
			);
			
			return lowestPrice.get();
		}
		
		// Promedio
		private Double getAvgPrice(String from, String to)
		{
			// Aquí buscaría
			AtomicReference<Double> totalPrice= new AtomicReference<>(0.0);
			priceByAirline.keySet().stream().parallel().forEach(airline ->  {
					Double price = getPriceTrip(airline,from,to);
					Double result = totalprice.get() + price;
					totalprice.set(result);
				}
			);
			
			
			return lowestPrice.get()/ priceByAirline.keySet().size();
		}
		
		private static init(){
					priceByAirline.put("American Airlines",550.0);
					priceByAirline.put("US Airways",610.0);
					priceByAirline.put("Delta Airlines",580.0);
					priceByAirline.put("Singapur Airlines",450.0);
					priceByAirline.put("Sky Airlines",500.0);
					priceByAirline.put("Aeromexico",750.0);
					//Aqui simulamos: 
	
	
		}
		
		
		//una función de modo de ejemplo sobre la obtencion de la información:
		
		public static Double getPriceTrip(String airline,String from,String to){
					// En una aplicaicon normal aqui hariamos la petición a un servidor para una aerolinea :D. simulando la peticion:
					
					try{
						Thread.sleep(1500);
					}
					catch(InterruptedException e){										
						e.printStackTrace();
					}
					priceByAirline.get(airline);
				}
		}
		
		

}

```

*Una nota es que `AtomicReference` hace atómica a cualquier objeto :D .* 

# Árbol de excepciones de JAVA.

![Excepciones en java.jpg](src/Java%20semi-avanzado/Excepciones_en_java.jpg)

![image.png](src/Java%20semi-avanzado/image%204.png)

Algo que debemos anotar, es que en la `Exceptions` existen las excepciones controladas y no controladas. Aqui podemos ver un ejemplo sencillo: 

```java
public class Main{

	public static void main(String ...args)
	{
		//podemos usar una propiedad finally dentro de la necesidad de controlar una excepcion es decir, despues de usar try catch:
		try{
			excepcionControlada();
		}
		catch(Exception e)
		{
		} finally{
			// esta linea siempre se ejecutaria, asi este bien o mal. Serviria para quitar recursos por ejemplo
			// o cerrar la conexión
		}
		
	}
	//Excepcion controlada
	private static void excepcionControlada() throws Excepction	{
		throw new Exception();
	}
	//Excecpcion no controlada
	private static float excepcionNoControlada()
	{
	// Este es un AritmeticException
		return 10/0; 
	}

}
```

Un ejemplo completo sería: 

```java
public class Main {

    public static void main(String[] args) throws Exception {
        try {
            uncheckedTwoExceptions(false);
        } catch(ArithmeticException | NullPointerException e) {
            System.out.println("Runtime Exception");
        }
    }

    // Many Catchs
    public static void exampleCustomException() {
        throw new CustomException();
    }

    // Many Catchs
    public static void manyCatchsExample() {
        try {
            checkedTwoExceptions(false);
        } catch(RuntimeException e) {
            System.out.println("Runtime Exception");
        } catch(Exception e) {
            System.out.println("Exception");
        } catch(Throwable e) {
            System.out.println("Exception");
        }
    }

    // Checked Exceptions
    private static void uncheckedTwoExceptions(boolean flag) throws Exception {
        if (flag) {
            throw new ArithmeticException();
        } else {
            throw new NullPointerException();
        }
    }

    // Checked Exceptions
    private static void checkedTwoExceptions(boolean flag) throws Exception {
        if (flag) {
            throw new Exception();
        } else {
            throw new RuntimeException();
        }
    }

    // Finally
    private static void finallyExample() throws Exception {
        try {
            checkedException();
        } catch(Exception e) {
            System.out.println(e.getMessage());
            throw new Exception();
        } finally {
            System.out.println("End");
        }
    }

    // Checked Exceptions
    private static void checkedException() throws Exception {
        throw new Exception();
    }

    // Unchecked Exceptions
    private static void exampleArithmeticException() {
        double number = 10 / 0;
    }

}
```

# Interfaces:

Hay 3 tipos de interfaces, Interfaces normales, las interfaces como anotaciones, y las interfaces funcionales

## Interfaces normales

Las interfaces normales en Java definen un contrato que las clases que las implementan deben cumplir. Contienen métodos abstractos (sin implementación) y, desde Java 8, también pueden incluir métodos default y static con implementación.

```java
// Ejemplo de interfaz normal
public interface Vehicle {
    // Método abstracto (sin implementación)
    void accelerate(int speed);
    
    // Método default (con implementación)
    default void startEngine() {
        System.out.println("Engine started");
    }
    
    // Método estático
    static int getWheelCount(String vehicleType) {
        if ("car".equalsIgnoreCase(vehicleType)) {
            return 4;
        } else if ("motorcycle".equalsIgnoreCase(vehicleType)) {
            return 2;
        }
        return 0;
    }
}

// Implementación de la interfaz
public class Car implements Vehicle {
    @Override
    public void accelerate(int speed) {
        System.out.println("Car accelerating to " + speed + " km/h");
    }
    
    // No es necesario implementar el método default
}

```

## Interfaces como anotaciones

Las interfaces de anotación son un tipo especial de interfaz que se utilizan para crear anotaciones personalizadas en Java. Se definen con el símbolo @ antes de la palabra clave interface.

```java
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

// Definición de una interfaz de anotación
@Retention(RetentionPolicy.RUNTIME) // Indica cuándo la anotación debe estar disponible
@Target(ElementType.METHOD)         // Indica dónde se puede aplicar la anotación
public @interface Test {
    // Elementos de la anotación (similares a métodos)
    String description() default "No description";
    boolean enabled() default true;
}

// Uso de la anotación
public class TestClass {
    @Test(description = "Prueba de suma", enabled = true)
    public void testSum() {
        // código de prueba
    }
    
    @Test // Usando valores por defecto
    public void testSubtract() {
        // código de prueba
    }
}

```

## Interfaces funcionales

Las interfaces funcionales son interfaces que contienen exactamente un método abstracto. Se utilizan principalmente con expresiones lambda en Java 8 y posteriores. Pueden ser marcadas con la anotación @FunctionalInterface.

```java
// Definición de una interfaz funcional
@FunctionalInterface
public interface Calculator {
    int calculate(int a, int b);
    
    // Puede tener métodos default
    default void printInfo() {
        System.out.println("Esta es una calculadora simple");
    }
}

public class Main {
    public static void main(String[] args) {
        // Implementación usando clase anónima
        Calculator addition = new Calculator() {
            @Override
            public int calculate(int a, int b) {
                return a + b;
            }
        };
        
        // Implementación usando expresión lambda
        Calculator subtraction = (a, b) -> a - b;
        Calculator multiplication = (a, b) -> a * b;
        Calculator division = (a, b) -> b != 0 ? a / b : 0;
        
        System.out.println("Suma: " + addition.calculate(10, 5));         // 15
        System.out.println("Resta: " + subtraction.calculate(10, 5));     // 5
        System.out.println("Multiplicación: " + multiplication.calculate(10, 5)); // 50
        System.out.println("División: " + division.calculate(10, 5));     // 2
        
        // Uso de método default
        addition.printInfo();
    }
}

```

En Java 8 se introdujeron varias interfaces funcionales predefinidas en el paquete java.util.function, como:

- **Consumer<T>**: Acepta un argumento y no devuelve nada (método accept)
- **Supplier<T>**: No acepta argumentos pero devuelve un valor (método get)
- **Function<T, R>**: Acepta un argumento y devuelve un resultado (método apply)
- **Predicate<T>**: Acepta un argumento y devuelve un boolean (método test)

```java
import java.util.function.Consumer;
import java.util.function.Supplier;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.ArrayList;
import java.util.List;

public class FunctionalInterfacesExample {
    public static void main(String[] args) {
        // Consumer
        Consumer<String> printConsumer = s -> System.out.println(s);
        printConsumer.accept("Hola mundo"); // Imprime: Hola mundo
        
        // Supplier
        Supplier<Double> randomSupplier = () -> Math.random();
        System.out.println(randomSupplier.get()); // Imprime un número aleatorio
        
        // Function
        Function<String, Integer> lengthFunction = s -> s.length();
        System.out.println(lengthFunction.apply("Java")); // Imprime: 4
        
        // Predicate
        Predicate<Integer> isEven = n -> n % 2 == 0;
        System.out.println(isEven.test(4)); // Imprime: true
        System.out.println(isEven.test(3)); // Imprime: false
        
        // Ejemplo más complejo con una lista
        List<String> names = new ArrayList<>();
        names.add("Ana");
        names.add("Juan");
        names.add("Pedro");
        names.add("María");
        
        // Filtrar nombres que empiezan con 'J'
        names.stream()
             .filter(name -> name.startsWith("J"))
             .forEach(printConsumer);
    }
}
```