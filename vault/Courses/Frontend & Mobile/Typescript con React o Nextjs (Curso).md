---
type: course
status: en_progreso
tags: [course, Typescript con React o Nextjs]
date_started: 2024-05-20
---

Typescript es una herramienta que en sí necesita de un `tsconfig.json` el cual es un archivo de configuración, normalmente descrito de la siguiente forma: 
```json
{
  "compilerOptions": {
    // Versión de JavaScript a la que se compilará el código.
    "target": "ES2017",
    // Define qué librerías de tipos están disponibles.
    // "dom": Para usar document, window, etc. (Navegador).
    // "esnext": Para usar las últimas características de JS.
    "lib": ["dom", "dom.iterable", "esnext"],
    // Permite importar archivos .js dentro de archivos .ts.
    // Útil si estás migrando un proyecto viejo poco a poco.
    "allowJs": true,
    // Opción de rendimiento. Le dice a TS que no chequee los tipos dentro de node_modules.
    // Ahorra mucho tiempo de compilación.
    "skipLibCheck": true,
    // Activa todas las verificaciones de tipo estrictas (noImplicitAny, strictNullCheck, etc.).
    // Te obliga a ser preciso con los tipos y evita muchos errores en tiempo de ejecución.
    "strict": true,
    // Le dice a TS que solo verifique errores, que no genere los archivos .js finales.
    // Next.js (o Webpack) se encarga de la compilación real a JS.
    "noEmit": true,
    // Permite importar módulos CommonJS (formato antiguo de Node) como si fueran ES Modules.
    // Hace que importar librerías viejas sea mucho más fácil.
    "esModuleInterop": true,
    // Qué sistema de módulos usar para el código generado. "esnext" es el más moderno.
    "module": "esnext",
    // ESTRATEGIA MODERNA de resolución de módulos.
    // Le dice a TS: "No intentes adivinar las rutas como lo haría Node.js viejo,
    // hazlo como lo hace un bundler moderno (Next.js, Vite, Webpack)".
    "moduleResolution": "bundler",
    // Te permite importar archivos JSON y obtener tipado para ellos.
    // Ej: import config from './config.json'
    "resolveJsonModule": true,
    // Asegura que cada archivo pueda ser transpilado independientemente.
    // Necesario para herramientas rápidas como SWC (que usa Next.js por debajo).
    "isolatedModules": true,
    // Transformación de JSX para React.
    // "react-jsx" es la versión nueva (JSX Transform), que no requiere importar React en cada archivo.
    // Si ves archivos antiguos, ponen "react".
    "jsx": "react-jsx",
    // Guarda información de compilaciones anteriores para hacer la siguiente más rápida.
    "incremental": true,
    // Plugins específicos para el IDE/Editor.
    // Aquí le decimos que use el plugin oficial de Next.js para mejores sugerencias.
    "plugins": [
      {
        "name": "next"
      }
    ],


    // ALIAS DE RUTAS (Path Mapping)
    // Esto te permite usar el símbolo @ para referirte a la raíz del proyecto.
    // En vez de: import Button from '../../../components/Button'
    // Usas:    import Button from '@/components/Button'
    "paths": {
      "@/*": ["./*"]
    }
  },

  // Archivos que TypeScript debe "leer" o incluir en el chequeo de tipos.
  "include": [
    "next-env.d.ts",   // Tipos globales que Next.js genera automáticamente.
    "**/*.ts",         // Todos los archivos TypeScript.
    "**/*.tsx",        // Todos los archivos TypeScript React.
    ".next/types/**/*.ts", // Tipos generados por Next.js en la carpeta .next
    ".next/dev/types/**/*.ts",
    "**/*.mts"         // Módulos TypeScript modernos (.mts)
  ],

  // Archivos a IGNORAR.
  // "node_modules" se ignora porque ahí ya hay tipos (archivos .d.ts) oficiales.
  "exclude": ["node_modules"]
}
```

# Bases de Typescript

Typescript es JavaScript con sintaxis para tipos.
![Pasted image 20260108105351.png](images/Pasted%20image%2020260108105351.png)

Se escribe de forma similar con la diferencia de que uno tiene un tipado fuerte y el otro un tipado débil y dinámico, esto quiere decir: 
```javascript
function procesarPedido(cliente,monto,esVip){
	// No sabemos si cliente es un string o un objeto especifico
	let descuento = 0;
	if(esVip){
		// aqui asumimos que monto es numerico, y que esVip es un booleano
		descuento = monto*0.20;
	}
	return {
		id: Math.random(),
		clienteFinal: cliente.toUpperCase(), // si cliente no es String explota
		total: monto - descuento
	}
}

const resultadosJS = procesarPedido("Juan", "100", true)

console.log(resutladoJS.total)
// aqui es 80, pero si fuera suma, no seria 80 sería 10020. porque concatenaria los Strings.
```
En typescript sería: 
```typescript
type Categoria = "electronica" | "ropa" | "hogar"; // permitimos 3 valores

interface Producto {
	id: number;
	nombre: string,
	precio: number,
	categoria: Categoria;
}

interface PedidoProcesado {
	idPedido: string;
	cliente: string;
	totalPagar: number;
	tieneDescuento: booelan
}

function procesarPedidoSeguro (
	nombreCliente: string,
	monto: number,
	esVip: boolean,
	productos Producto[]
):PedidoProcesado {

	let descuento: number = 0;
	let mensaje: string = "";
	
	if(esVip){
		descuento= monto *0.20; // es una multiplicación verificada de numberos
		mensaje = " Cliente VIP aplicado"
	}
	
	productos.forEach((prod)=> {
		// alguna lógica de productos
		console.log(`Agregando: ${prod.nombre}`)
	});
	
	return {
		idPedido: crypto.randomUUID(),
		cliente: nombreCliene.toUpperCase(),
		totalPagar: monto - descuento,
		tieneDescuento: descuento > 0
	}
}

// una llamada correcta: 

const misProductos: Producto [] = [
	{id:1,nombre:"Laptop",precio:1000,categoria:"electronica"},
	{id:2, nombre:"Camisa",precio:50,categoria: "ropa"}
];

const resultadoTS = procesarPedidoSeguro("Ana),1000,true,misProductos);
console.log(resultadoTS.cliente); // esto es correcto y existe
```

Typescript es mucho más verboso, pero hace mucho más seguro el código y genera una escalabilidad del código mucho mejor de lo que JavaScript puede realizar. 

## Compilación vs Ejecución

Las diferencias de cómo funciona Javascript y Typescript. 

JavaScript es un lenguaje interpretado que el navegador o Node.js ejecutan directamente sin pasos intermedios. TypeScript, en cambio, necesita un paso extra llamado **transpilación**.

Este proceso convierte el código TypeScript (que tiene tipos y sintaxis moderna) en código JavaScript puro y plano que el navegador pueda entender. Así, el ordenador nunca ejecuta TypeScript directamente; **compila** para generar el JavaScript final que luego se **ejecuta**.

## Tipos básicos e inferencia de typescript

### La Inferencia de Tipos (La "magia" de TypeScript)

TypeScript es inteligente. A menudo **no necesitas escribir los tipos manualmente**. El compilador los deduce mirando el valor que le asignas a una variable.

A esto se le llama **Inferencia**.

**¿Cómo funciona?** Si escribes `let x = 5`, TypeScript piensa: _"Ah, le asignó un número entero, así que `x` es un `number` para siempre"_. Si luego intentas hacer `x = "hola"`, TypeScript te dará error, porque él ya decidió que `x` es un número.

- **¿Cuándo usarla?** Siempre que puedas. Escribe menos código y es más limpio.
- **¿Cuándo NO usarla?** Cuando declaras una variable sin valor inicial (`let x;`), ahí TS no sabe qué es y le debes poner el tipo a mano (`let x: number;`).

### 2. Los Tipos Básicos

Estos son los ladrillos fundamentales con los que construyes tus datos. Se diferencian un poco de otros lenguajes (como Java o C#):

1. **`string`**: Texto. Siempre con comillas (simples, dobles o backticks).
2. **`number`**: Cualquier número (enteros, decimales, positivos, negativos). No hay `int` o `float` por separado.
    - _Ejemplo:_ `let edad = 25;`, `let precio = 10.50;`
3. **`boolean`**: Lógica pura. Solo `true` o `false`.
4. **`any`**: El "comodín". Apaga el tipado. La variable puede ser lo que sea.
    - _Úsalo solo en emergencias_, ya que pierdes la protección de TypeScript.
5. **`unknown`**: Similar a `any`, pero más seguro. Te obliga a chequear qué es la variable antes de usarla.
6. **`void`**: Se usa en funciones para decir "esta función no devuelve nada".
7. **`null` y `undefined`**: Representan la ausencia de valor (o valor vacío/definido).

## Fundamentos Avanzados de Variables

### Sprites (Spread Operator) en Arrays y Objetos:
Aunque es sintaxis de JavaScript moderno, en TS es vital enteder cómo mantiene la inmutabilidad (copiar datos sin modificar el original).

El concepto son `...` (tres puntos)
- En arrays: Copia o fusiona las listas:
	```typescript
	const lista1 = [1,2];
	const lista2 = [...lista1,3,4]; // restultado es [1,2,3,4]
	```
- En objetos: Copia propiedades 
	```typescript
	const usuario = {nombre: "juan",edad:20};
	const usuarioActualizado = {...usuario, edad:21}; // esto sobre escribe la edad pero copia el resto 
	```
### Tipado Estricto y flexible: 

#### Union Types: 
Permite que una variable sea **una cosa O otra**. Esecnail para manejar datos que pueden cambiar de forma.

- Simbolo: `|`
- Ejemplo:
```typescript
let id: string | number;
id = 123; // Correcto
id = 'abc'; // Correcto
```

#### Type Guards (Guardas de tipo)

Cuando se usa Union Types, a veces el código no sabe qué método tiene (ej: `.lenght` existe en string pero no en number). Los _type guards_ verifican el tipo en tiempo de ejecución para que TypeScript sepa que hacer: 
```typescript
function imprimirId(id:string | number){
	if(typeof id === "string"){
		//hace algo que solo se puede hacer con string
	} else{
	
		//hace otra cosa que solo se puede hacer con number
	}
}
```
### Estructura de datos: 
#### Interfaces vs Types
A menudo causan confusión, pero tienen reglas claras.
- `Interface`: Define la "forma" de un objeto. Se pueden extender (heredar) y se pueden implementar en clases
	- Uso: Contratos públicos, formas de datos: 
	```typescript
	interface User {
		id: number;
		name: string;
	}
	```
- `type`: Este es un alias. Puede definir primitas complejas, uniones o tuplas.
	- Uso: Alias de uniones, tipos que son la unión de varias cosas. 
	```typescript
	type ID = string | number
	type Coordenada = [number,number] // es una tupla, un array fijo
	```
	
### Programación orientada a objetos (POO) con TS:
#### Clases y modificadores de acceso:
Typescript trae keywords que faltan en JavaScript: `public`, `private`, `protected`. Esto permite encapsulamiento real.
- `public`: Accesible desde cualquier parte (es el default)
- `private`: Solo accesible dentro de la clase
- `protected`: Accesible dentro de la clase y sus clases hijas
#### Herencia: 
Permite crear una clase "hija" que hereda todo de la "padre" y puede agregar o sobrescribir funcionalidades.
- Keyword: `extends`
- Ejemplo: 
```typescript
class Animal {comer() {console.log("ñam")}}
class Perro extends Animal {ladrar() {console.log("Guau");}}}
```

### Genéricos: 
Este es el concepto más importante para crear código reutilizable. Permite escribir una función o clase que funcione con cualquier tipo, pero manteniendo la seguridad de ese tipo. 

Imagina una función que devuelve el primer elemento de un array. Si le pasas números, devuelve un número. Si le pasas textos, devuelve un texto. La lógica es la misma, el tipo cambia
- Símbolo clave: "letra T por convención de Type"
- Ejemplo: 
```typescript
function devolverPrimero(Lista: T[]):T {
	return lista[0];
}
const num = devolverPrimero([1,2,3,4]) // devuelve un number
const tex = devolverPrimero(["a", "b"]); // tex es inferido como string
```

## Patron de diseño básico

### Patrón adaptador: 
Es muy útil en la vida real cuando tienes una clase que hace lo que necesitas, pero no tiene una interfaz que tu sistema espera. 
![Pasted image 20260108145949.png](images/Pasted%20image%2020260108145949.png)

Entonces tenemos: 
```typescript
interface TemperaturaEnCelsius {
	obtenerTemperaturaEnCelsius(): number;
}

  
// Adaptee  
class TemperaturaEnFahrenheit {  
  constructor(private temperaturaEnFahrenheit: number) {}  
  
  obtenerTemperaturaEnFahrenheit(): number {  
    return this.temperaturaEnFahrenheit;  
  }  
}  
  
// Adaptador  
class AdaptadorDeTemperatura implements TemperaturaEnCelsius {  
  constructor(private adaptee: TemperaturaEnFahrenheit) {}  
  
  obtenerTemperaturaEnCelsius(): number {  
    // Adaptar de Fahrenheit a Celsius  
    return (this.adaptee.obtenerTemperaturaEnFahrenheit() - 32) / 1.8;  
  }  
}


```

Otro ejemplo digamos, con whatsapp como interfaz: 

```typescript
export interface MessageService {
  sendMessage(to: string, message: string): Promise<void>;
}

// WhatsAppBusinessAPI.ts
export class WhatsAppBusinessAPI {
  async sendTextMessage(phoneNumber: string, body: string): Promise<void> {
    console.log(`📲 WhatsApp message sent to ${phoneNumber}: ${body}`);
  }
}


// WhatsAppAdapter.ts
import { MessageService } from "./MessageService";
import { WhatsAppBusinessAPI } from "./WhatsAppBusinessAPI";

export class WhatsAppAdapter implements MessageService {
  private whatsappApi: WhatsAppBusinessAPI;

  constructor(whatsappApi: WhatsAppBusinessAPI) {
    this.whatsappApi = whatsappApi;
  }

  async sendMessage(to: string, message: string): Promise<void> {
    await this.whatsappApi.sendTextMessage(to, message);
  }
}

// NotificationService.ts
import { MessageService } from "./MessageService";

export class NotificationService {
  constructor(private messageService: MessageService) {}

  async notifyUser(userPhone: string, text: string) {
    await this.messageService.sendMessage(userPhone, text);
  }
}

//**---

// main.ts
import { WhatsAppBusinessAPI } from "./WhatsAppBusinessAPI";
import { WhatsAppAdapter } from "./WhatsAppAdapter";
import { NotificationService } from "./NotificationService";

const whatsappApi = new WhatsAppBusinessAPI();
const whatsappAdapter = new WhatsAppAdapter(whatsappApi);

const notificationService = new NotificationService(whatsappAdapter);

notificationService.notifyUser("+521234567890", "Hola desde el patrón Adaptador");

```

## Decoradores: 

una sintaxis para modificar clases o propiedades. Es la base de como funcionan frameworks como NestJS o Angular. 

```typescript
@Component({selector: 'app-root}) // este es un decorador de clase
class AppComponent{}
```
## Utility Types (Herramientas finales)

Estas son funciones de TypeScript que transforman tipos instantáneamente. Te ahorrarán horas de escribir código.

- **`Partial`**: Hace opcional todas las propiedades de un tipo   

```typescript
interface User { id: number; name: string; email: string; }
// Queremos actualizar un usuario, pero no todos los campos a la vez.
    
    function updateUser(id: number, campos: Partial<User>) {
    
    // Ahora campos puede ser solo { name: "Nuevo" } y es válido.
    
    }
``` 
- **`Required`**: Lo contrario de `Partial`. Todo se vuelve obligatorio.

- **`Omit`**: Crea un nuevo tipo quitando una propiedad.
```typescript
/ Tipo para crear usuario (sin id, porque lo genera la DB)

type NuevoUsuario = Omit<User, 'id'>;

// Ahora NuevoUsuario solo tiene { name, email }
```    

***
# NEXT JS: 

Este apartado de NEXTJS va a seguir lo que la documentación nos dice: 
https://nextjs.org/

Después de seguir la instalación debemos de NextJS, tenemos que ver la estructura del proyecto: 

## Estructura del proyecto: 
### Raiz del proyecto: 
En la carpeta principal. verás archivos de configuración que no tocas tanto, pero que definene cómo se compila todo

- **`package.json`**: Tus dependencias (librerías) y scripts (`npm run dev`, `build`, etc.).
- **`tsconfig.json`**: (¡El que vimos antes!) La configuración de TypeScript.
- **`next.config.js`**: Configuración específica de Next.js (redirecciones, imágenes, Webpack, etc.).
- **`.next`**: Esta es la carpeta **INVISIBLE** (se crea sola). Ahí es donde Next.js guarda los archivos compilados y cacheados. **No la toques ni la borres a menos que tengas un error raro de compilación.**

### El directorio `app/` (El corazón de la aplicación)

Esta es la parte más importante. Todo lo que propongas aquí se mapea automáticamente a una URL de tu web-

La documentaci´n explica que el `app` es la carpeta princiapal de las rutas. Aquí funciona asi: 
```sinformato
Carpeta = Ruta URL, Archivo page.tsx = contenido de la página
```
Un ejemplo del a estructura: 
```
app/
├── layout.tsx       <-- (Obligatorio en la raíz) La plantilla general (Header/Footer)
├── page.tsx         <-- La página principal (tucuenta.com/)
├── about/
│   └── page.tsx     <-- La página /about
├── dashboard/
│   ├── layout.tsx   <-- Layout específico para el dashboard (ej: Sidebar)
│   └── settings/
│       └── page.tsx <-- La página /dashboard/settings
```

#### Archivos especiales dentro de `app/`
La documentación detalla estos archivos especiales que next.js reconoce automáticamente 
- **`page.tsx`**: Define la **UI única** de una ruta. Es obligatorio para que la ruta sea accesible.
- **`layout.tsx`**: Define UI **compartida**. Se usa para envolver las páginas (por ejemplo, poner la barra de navegación en `app/layout.tsx` para que salga en todas las páginas).
- **`loading.tsx`**: Define una UI de carga (un spinner o esqueleto) que se muestra automáticamente mientras la página está trayendo datos o cargando. Next.js hace esto por ti.
- **`error.tsx`**: Define una UI que se muestra si la página se rompe (crash).
- **`not-found.tsx`**: Define una UI personalizada cuando el usuario entra a una URL que no existe (404).
- **`route.ts`**: (Importante) Aquí defines las **API Routes** dentro del app router. Es decir, tus backends internos para que Tauri u otros clientes llamen.
### La carpeta `public/`

Aquí van los archivos estáticos: Imágenes (`logo.png`, `hero-bg.jpg`), fuentes, robots.txt, favicon.ico. 

- Regla: Todo lo que pongas aquí se sirve tal cual en la raíz.
- Si pones `image.png` en `public`, lo accedes en tu código como `<img src="/image.png" />`

### Organización del código ("Colocation")

La documentación menciona que no estás obligado a poner todos tus componentes en una carpeta aparte. Puedes usar la **Colocation**.

Esto significa que si tienes un componente que solo usa la página `about`, puedes poner el archivo `Button.tsx` dentro de la carpeta about, en lugar de en una carpeta global `components`.

Por ejemplo: 
```
app/
  about/
    page.tsx
    components/  <-- Solo para About
      Button.tsx
```

### Carpetas comunes (Convención de la comunidad)

Aunque Next.js es flexible, la documentación y la comunidad suelen crear estas carpetas extra para ordenar: 

- **`components/`**: Componentes reutilizables en toda la app (Botones, Modales).
- **`lib/` o `utils/`**: Funciones auxiliares (ej: función para formatear fechas, conexión a base de datos).
- **`hooks/`**: Custom Hooks de React (ej: `useAuth`).

### Component hierarchy
The components defined in special files are rendered in a specific hierarchy:

- `layout.js`
- `template.js`
- `error.js` (React error boundary)
- `loading.js` (React suspense boundary)
- `not-found.js` (React error boundary for "not found" UI)
- `page.js` or nested `layout.js`

![Pasted image 20260108161549.png](images/Pasted%20image%2020260108161549.png)

### Private folders

Private folders can be created by prefixing a folder with an underscore: `_folderName`

This indicates the folder is a private implementation detail and should not be considered by the routing system, thereby **opting the folder and all its subfolders** out of routing.

![Pasted image 20260108161642.png](images/Pasted%20image%2020260108161642.png)
### Route groups
Route groups can be created by wrapping a folder in parenthesis: `(folderName)`

This indicates the folder is for organizational purposes and should **not be included** in the route's URL path.

![Pasted image 20260108161715.png](images/Pasted%20image%2020260108161715.png)

Para mayo información: https://nextjs.org/docs/app/getting-started/project-structure

## Layaouts and Pages 

NextJS usa un sistema de routing basado en archivos, esto significa que puedes usar carpetas y archivos para definir las rutas. Este apartado va a guiarte a travez de ello.

### Creando una página: 

Una página es UI que es renderizada en una ruta específica. Para crear una página, añadimos un archivo`page`dentro del directorio de  `app`y un `default export`. Por ejemplo, para crear la página index (`/`).
![Pasted image 20260108170427.png](images/Pasted%20image%2020260108170427.png)
```typescript
export default function Page(){
	return <h1> Hello Next.js! <h/1>
}
```

### Creando un layout

Un layout es una UI que es compartida entre diferentes páginas. En la navegación, los layouts preservan el estado, permanece interactivo y no hacer renderer.

Podemos definir un layout exportando por defecto un componente React de un archivo `layout`. El componente debe aceptar un `children` como parámetro el cual puede ser una página u otro layout.

Por ejemplo, para crear un layout que acepte a tu index como una página hija, añadimos al archivo `layout` dentro del directorio de `app`.
![Pasted image 20260108174159.png](images/Pasted%20image%2020260108174159.png)

```tsx
export default function DashboardLayout({
children
}): {
	children: React.ReactNode
}) {
	return (
	<html lang="en">
		<body>
			<main> {children} </main>
		</body>
	</html>
	)
}
```
Este layout es llamado "root layout" debido a que está definido la raíz de la aplicación en el directorio `app`.
Este root layout es requerido y debe contener `html` y `body` como tags.

### Crear una ruta anidada o `nested route`
Una ruta anidad es una ruta compuesta por múltiples URL segmentos. Por ejemplo, la ruta `/blog/[slug]` está compuesta de tres segmentos: 
- `/` (Root segment)
- `blog` (segment)
- `[slug]` (leaf segment)
En Next.JS:
- Las **carpetas** son usadas para definir los segmentos de la ruta
- Los **archivos** (como `page` y `layout`) son usados para crear UI que se muestra en el segmento.
Para crear rutas anidad podemos crear carpetas dentro de otras. Por ejemplo: 
![Pasted image 20260109093230.png](images/Pasted%20image%2020260109093230.png)

```typescript title=app/blog/page.tsx

// Dummy imports
import { getPosts } from '@/lib/posts'
import { Post } from '@/ui/post'
 
export default async function Page() {
  const posts = await getPosts()
 
  return (
    <ul>
      {posts.map((post) => (
        <Post key={post.id} post={post} />
      ))}
    </ul>
  )
}

```

Podemos seguir haciendo anidaciones. ![Pasted image 20260109093400.png](images/Pasted%20image%2020260109093400.png)
Y en el código: 
```typescript title=app/blog/[slug]/page.tsx
interface Props {
    params: Promise<{ slug: string }>
}
export function generateStaticParams() {
    return [
        { slug: "hello" },
        { slug: "world" },
    ]
}

export default async function Page({
    params,
}: Props) {
	const { slug } = await params
    return <h1>Slug: {slug}</h1>
}
```

Aquí lo que hacemos es crear rutas dinámicas, es decir, podemos ir a: 
- `http://localhost:3000/dashboard/world`
- `http://localhost:3000/dashboard/hello`
y ambas son válidas y dirán: 

`SLUG:___` Donde en el `___` estará `world` o `hello` dependiendo de la ruta elegida.

### Layouts anidados

Por defecto, los layouts en un sistema de carpetas ya son anidados, el cual significa que estos encierran un layout hijo mediante la propiedad `children`. Tú puedes crear layouts anidados añadiendo `layout` dentro de un segmento de ruta específica (carpeta)

Por ejemplo: 
![Pasted image 20260109114302.png](images/Pasted%20image%2020260109114302.png)

Ahí añadimos un layout a la carpeta `blog`, usando: 
```typescript title=app/blog/layout.tsx icon=typescript
export default function BlogLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return <section>{children}</section>
}
```

Hay apartados como usar el `Readonly` el cual es para que una vez renderizado los children, esta prohibido intentar modificarlos o sobreescribirlos.
Por ejemplo: 
```tsx
import type { Metadata } from "next";

import { Geist, Geist_Mono } from "next/font/google";

import "./globals.css";

  

const geistSans = Geist({

  variable: "--font-geist-sans",

  subsets: ["latin"],

});

  

const geistMono = Geist_Mono({

  variable: "--font-geist-mono",

  subsets: ["latin"],

});

  

export const metadata: Metadata = {

  title: "Create Next App",

  description: "Generated by create next app",

};

  

import Navbar from "./components/Navbar";

  

// ... existing imports

  

export default function RootLayout({

  children,

}: Readonly<{

  children: React.ReactNode;

}>) {

  return (

    <html lang="en">

      <body className={`${geistSans.variable} ${geistMono.variable}`}>

        <Navbar />

        {children}

      </body>

    </html>

  );

}
```

### Renderizado con parámetros de búsqueda
En una página con server component, se puede acceder a la búsqueda de parámetros usando la propiedad `searchParam`.

#### ¿Primero qué son?:
Son los datos que pasas en la URL para filtrar, buscar o paginar.
Ejemplo: `tienda.com/productos?categoria=zapatos&talla=40`
- `categoria=zapatos`
- `talla=40`
La forma en que la documentación nos comenta sobre eso es: 
```typescript title=app/page.tsx
export default async function Page({
	searchParams,
}: {
		searchParams:Promise<{[key:string]:string|string[]|undefined}>
}) {
	const filters = (await searchParams).filters
}
```

Otro ejemplo para ello: 
```typescript title=app/buscar/page.tsx
// Definimos que el componente recibe 'searchParams'
interface PageProps {
  searchParams: {
    q?: string;      // 'q' es opcional (?) porque puede no venir en la URL
    lang?: string;
  };
}

export default function BuscarPage({ searchParams }: PageProps) {
  // Aquí searchParams ya es un objeto listo para usar.
  // No necesitas hacer "url.split('?')..."
  
  const query = searchParams.q || "";
  const idioma = searchParams.lang || "en";

  return (
    <div>
      <h1>Resultados para: {query}</h1>
      <p>Idioma seleccionado: {idioma}</p>
      
      {/* Puedes usar estos params para buscar en tu base de datos */}
      <p>Mostrando resultados de base de datos para: {query}...</p>
    </div>
  );
}
```
Aunque esto en un proyecto donde Next.js es meramente el front-end puede resultar ocasional.

### Linking entre páginas

Nosotros podemos usar el componente `<Link>` para navegar entre rutas. `<Link>` es un componente construido en Next.js que extiende del tag HTML `<a>` que provee un `prefetching` y una navegación `client-side`
>El **prefetching** es cuando, por ejemplo, haces hover sobre un link y automáticamente descarga todo para que a la hora de hacer click cargue inmediatamente.
>El **client-side** es una forma que se tiene para interceptar el click y cambiar el contenido de la pantalla inmediatamente sin recargar, así la página no "parpadea" y genera una transición suave.

Como ejemplo: 
```tsx title=app/ui/post.tsx
impor Link from 'next/Link'

export default async function Post({post}){
	const post = await getPosts();
	
	return (
		<ul>
			{post.map((posts)=> (
				<li key={posts.slug}>
				<Link href={`/blog/${posts.slug}`}>{posts.title}</Link>
				</li>
			))}
		</ul>
	)
}
```

Algo para saber: 
**Good to know**: `<Link>` is the primary way to navigate between routes in Next.js. You can also use the [`useRouter` hook](https://nextjs.org/docs/app/api-reference/functions/use-router) for more advanced navigation.
#### `useRouter`
El `hook` `useRouter` nos permite cambiar programáticamente la ruta dentro de nuestros componentes de cliente.

>**Recommendation:** Use the [`<Link>` component](https://nextjs.org/docs/app/api-reference/components/link) for navigation unless you have a specific requirement for using `useRouter`.

```tsx title=app/example-client-component.tsx
`use client`

import {useRouter} from 'next/navigation'

export default function Page(){
	const router = userRouter()
	
	return (
		<button type="button" onClick={() => router.push('/dashboard')}>
		Dashboard
		</button>
	)
}
```

### Streaming de datos

Existe un problema que es acerca de la latencia de datos (sequencial loading), y que es este problema y porque se resuelve con _Streaming_.

Imaginemos un Dashboard (Panel de control) que carga dos cosas: 

1. Datos de usuario: Tú (tu nombre, foto)
2. Métricas de ventas: Gráficos complejos que tardan 5 segundos en calcularse en la base de datos.

Sin streaming (carga secuencial):
1. El usuario entra al Dashboard
2. Next.js espera a que los Datos de Usuario terminen. (rápidas)
3. Luego, empieza a pedir las Métricas de Ventas (Lentas)
4. Mientras cargan las métricas, TODO el dashboard está bloqueado. El usuario no ve su foto, no ve nada. Solo ve un círculo girando por 5 segundos
5. Al final de los 5 segundos, se pinta todo junto.

Esto es una mala experiencia de usuario. El usuario espera más tiempo del necesario para ver una parte de la información que sí estaba lista.

La solución está en **suspense** y **streaming** (Parallel Rendering), y es que next.js utiliza una característica de `React` llamada `Suspense` para permitir el Streaming (flujo continuo)

La documentación explica que ahora puedes renderizar partes de la página independientemente.

¿Cómo funciona?: 
```tsx
import {Suspense} from 'react'
import Reviews from './components/Reviews' // este es el componente lento


export default function ReviewsPage(){
	return (
	<div>
		<h1>Reseñas</h1>
		<Suspense fallback={<p> Cargando reseñas ... </p>}
			<Reviews/>
		</Suspense>
	</div>
	);

}

```

***
La documentación hace una distinción importante entre **Suspense** y **Streaming**:

1. `<Suspense>`: Define una parte de la página que puede esperarse. Mientras tanto, muestra lo que pongas en `fallback`
2. Streaming: Es cómo Next.js envía HTML del servidor al navegador.

- Sin streaming: El servidor espera a que la página esté 100% lista, envía un solo paquete HTML gigante, y el navegador lo pinta de golpe.
- Con streaming: El servidor envía el HTML en trozos (chunks)
	- -Chunk 1: El `<h1>Reseñas</h1>`.
	- Chunk 2: El `<p>Cargando reseñas...</p>` (el fallback).
	- ... (el servidor sigue trabajando en la BD) ...
	- Chunk 3: El servidor envía el código del componente `<Reviews />`.
	- JavaScript en el navegador reemplaza el texto "Cargando" con el componente real.
La documentación también suele mencionar (o está relacionado) que **no necesitas poner `<Suspense>` manualmente en todas partes**.

- Next.js tiene un archivo especial `loading.tsx`.
- Si creas `app/dashboard/loading.tsx`, automáticamente Next.js envuelve toda la página `page.tsx` en un `<Suspense>` usando ese `loading.tsx` como `fallback`.
- Esto es un atajo para tener streaming global en esa ruta sin ensuciar tu código con etiquetas `Suspense` alrededor de todo.


### Flujo: Pages vs Layouts

Para visualizarlo, imagina que tu aplicación web es un documento de Word o PowerPoint: 
- Layout: El fondo que se mantiene constante. Tiene el logotipo, la barra de navegación, el pie de página y los estilos globales. No cambia mientras navegas.
- Page: Es el contenido, lo que va "dentro" del marco. Cambia según la URL en la que estés (Inicio, Nosotros, Contacto).

¿Como funciona el flujo técnico?

Next.js anida los componentes. Tu código sigue una jerarquía de carpetas. Cuando un usuario visita una URL:
1. Next.js busca el Layout más cercano: Generalmente empieza por el `RootLayout`
2. Next.js busca la Page específica: Busca el archivo `page.tsx` dentro de la carpeta correspondiente a la URL.

Visualmente: 
```tsx
<RootLayout>
  <Navbar />
  {/* Aquí es donde Next.js inyecta la Page actual */}
  <PageAbout /> 
</RootLayout>
```

**Regla de oro:**

- Si el componente debe verse en **todas** (o varias) las páginas -> **Layout**.
- Si el componente es el **contenido principal** que cambia -> **Page**.


## Hooks: 

Los hooks son como "enchufes" que nos permiten agregar fubncionalidad a tus componentes funcionales.

Aqui hay una guía de los más esenciales: 

> **Nota Importante para Next.js:** En Next.js (App Router), los Hooks **solo funcionan** si agregas la línea `"use client";` en la parte superior de tu archivo. Si no la pones, tu componente es del "Servidor" y los hooks darán error.

### `useState` (El memoria)
- Tipo: Gestión de Estado (Datos que cambian)
- Caso de Uso: Necesitas que la interfaz "reaccione" y se actualice visualmente cuando cambia un dato
- ¿Cuándo usarlo?: Cuando piensas "Esta variable va a cambiar en el tiempo y necesito que la pantalla se vuelva a pintar cuando eso pase".
- Ejemplo sencillo:
```tsx
"use client"

import {useState} from "react"

export default function Contador(){
	//sintaxis: 
	//Sintaxis: [valorActual, funcionParaActualizar] = useState<tipo>(valorInicial)

	const [contador,setContador] = useState<number>(0);
	
	return (
	<div>
		<p> Haz hecho clic {contador} veces </p>
		<button onClick ={() => {
			setContador(contador+1)
		}}>
		Aumentar
		</button>
	</div>
	)
}
```
### `useEffect` (El trabajador)
- Tipo: Efecto secundario (Side Effect)
- Caso de uso: Necesitas ejecutar código fuera del flujo normal de pintar la pantalla. Ejemplos Llamar a una API (base de datos), cambiar el título de la pestaña del navegador, configurar un temporizador o suscribirte a un evento
- ¿Cuándo usarlo?: Cuando pienses "Necesito que esto pase cuando el componente se cargue por primera vez" o "Necesito que esto pase cada que X cariable cambie"
- Ejemplo sencillo:
```tsx
"use client";

import {useState, useEffect} from "react";

export default function Reloj(){
	const [hora, setHora] = useState(new Date());
	
	useEffect(() => {
	// código a ejectuar: Crear un intervalo que actualice la hora cada segundo
	const intervalo = setInterval(() => {
		setHora(new Date())
	},1000);
	// Función de limpieza: Detener el intervalo si el componente se destruye
	return () => clearInterval(intervalo);
	}, []); // El array vacío [] significa "solo ejecuta el montar el componente"
	
  return <h1>Son las: {hora.toLocaleTimeString()}</h1>;

}
```

Este `Hook` es importante de ahondar, entonces. `useEffect` sincroniza el componente con algo externo a React, especificamente es: 
"Sistemas externos" = todo lo que no está controlado por react; pero entonces que considera React "externo"? : 
- APIs (fetch)
- Timers (`setInterval`,`setTimeout`)
- Subscripciones (eventos, websockets)
- DOM imperativo
- `document.title`
- LocalStorage
- APIS del navegador
Todo eso vive fuera del render.

React tiene una regla dura: 
> El render debe ser puro

Esto significa: 
- No side effects
- No async
- No mutaciones
- No timers
- No IO
Entonces React dice: "Si necesitas hacer algo impuro, hazlo despues del render -> `useEffect`"

Y cuándo se ejecuta realmente? ...
```ts
useEffect(() => {
	//efecto
},[deps]);
```
Ciclo:
1. React renderiza
2. React pinta la UI
3. Reacte ejecuta el effect
4. (Si cambia algo) -> re-render
5. Cleanup del effect anterior
6. Nuevo effect
Siempre después de pintar.

#### El array de dependencias:
Es una lista de valores de los que no depende el efecto

React garantiza: 
>Si alguno de estos valores cambia, vuelvo a sincronizar

##### Casos:
###### `[]` -- montar / desmontar:
```ts
useEffect(() => {
	//setup
	
	return () => {
	//cleanup
	}
},[]);
```
- Setup -> una vez
- Cleanup -> al desmontar
Ej.: Timers, listeners, subscripciones

##### `[x]` -- Sincronización puntual
```ts
useEffect(() => {
	document.title = `User ${x}`
},[x]);
```
Cada vez que `x` cambia:
- cleanup (si hay)
- nuevo effect
### `useContext` (El transmisor global)
- Tipo: Gestión de estado global
- Caso de uso: Tienes datos (como el tema oscuro/claro, o el usuario logueado) que necesitan ser accedido por muchos componentes en diferentes partes de la aplicación, sin tener que pasarlos manualmente uno por uno (evitando el "Prop Drilling").
- ¿Cuándo usarlo?: Cuando pienses -> "Estoy harto de pasar esta propiedad por 5 componentes que no la usan solo para que llegue al sexto".
- Ejemplo sencillo: 
	1. Creas un contexto.
	2. Envuelves tu App en un `provider`.
	3. En cualquier componente hijo, haces `const tema = useContext(TemaContext)`.
Uno de los ejemplos en el apartado del tema.

1. Como primero debemos ==**crear el contexto**==
```ts
"use client";

import {createContext, useContext, useState} from "react";

type Theme = "light" | "dark";

type ThemeContextType = {
	theme : Theme;
	toggleTheme: () => void;
};

const ThemeContext = createContext<ThemeContextType | null>(null);
```

2. ==Provider== (La fuente de la verdad)
```ts
export function ThemeProvider({children}:{children: React.ReactNode }){
	const [theme, setTheme] = useState<Theme>("light");
	
	const toogleTheme = () => {
		setTheme((t) => (t === "light" ? "dark" : "light"));
	};

}
```

3. Hook seguro:
```ts
export function useTheme () {
	const context = useContext(ThemeContext);
	if(!context){
		throw new Error("useTheme must be used within ThemeProvider");
	}
	return context;
}
```

4. Ahora, en el momento de consumir el contexto: 
```tsx

function ThemeButton() {
	const {theme, toggleTheme } = useTheme();
	
	return (
	<button onClick={toggleTheme}>
		Tema actual: {theme}
	</button>
	);
}
```

5. El uso real: 
```tsx
<ThemeProvider>
	<Navbar/>
	<Page/>
</ThemeProvider>
```

Otro de los usos y más importantes es el de autenticación:

Aqui hay dos o quizá varias formas de hacerlo, por lo que vamos a ver varias; adelantando un concepto que veremos más adelante.
Con AuthContext: 
```tsx
"use client"

import {createContext, useContext, useState} from "react";

type User = {
	id: string;
	name: string;
};

type AuthContextType = {
	user: User | null;
	login: (user: User) => void;
	logout: () => void;
};

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({children}:{children: React.ReactNode}){
	const [user, setUser] = useState<User | null>(null);
	
	return (
		<AuthContext.Provider
			value={{
				user,
				login: setUser,
				logout: () => setUser(null),
			}}
		>
			{children}
		</AuthContext.Provider>
	);
}

export function useAuth(){
	const ctx = useContext(AuthContext);
	if(!ctx) throw new Eerror("useAuth outside provider");
	return ctx;
}
```
Su uso tipico sería: 
```tsx
function Navbar() {
  const { user, login, logout } = useAuth();

  return user ? (
    <>
      <span>{user.name}</span>
      <button onClick={logout}>Logout</button>
    </>
  ) : (
    <button onClick={() => login({ id: "1", name: "Juan" })}>
      Login
    </button>
  );
}
```

Este apartado tiene unas limitaciones, el cual el usuario puede escribir `/dashboard` en la URL y/o puede acceder asi no hay protección del servidor.
Otra cosa que podemos hacer es crear un "Guardian" es decir, generar un componente que envuelva todas las páginas protegidas: 
```tsx
// components/auth-guard.tsx

"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "./auth-context"; // Tu contexto

export default function AuthGuard({ children }: { children: React.ReactNode }) {

const { user, loading } = useAuth();
const router = useRouter();

useEffect(() => {
	if (!loading && !user) {
		router.push("/login"); // Redirección en el cliente
	}
}, [user, loading, router]);

if (loading) return <p>Cargando...</p>;

if (!user) return null; // Previene "flash" de contenido protegido

return <>{children}</>;
}
```

Está mediante middleware, sin embargo. Eso lo tocaré después, quedará como TODO. Ya que me enfoco ahora en Next con Tauri.

### `UseRef` (El recuerdo silencioso)
- Tipo: Referencia Mutable persistente.
- Caso de Uso: Necesitas acceder a un elemento del DOM directamente.(ej: hacer foco en un input) o guardar un valor que no debe provocar que la pantalla se repinte cuando cambie.
- ¿Cuándo usarlo?: Cuando piensas: "Necesito que este valor se guarde entre renderizados, pero NO quiero que React se entere ni vuelva a pintar todo cuando cambie" o "Necesito manipular este input directamente con JS puro".
- Ejemplo Sencillo:
```tsx
"use client";

import {useRef} from "react";

export default function Buscador() {
	const inputRef = useRef<HTMLInputElement>(null);
	
	const hacerFoco = () => {
		// accedemos al elemento real del DOM sin renderizar de nuevo
		inputRef.current?.focus();
	};
	
	return (
	<div>
		<input ref={inputRef} type="text" placeholder ="Buscar..."/>
		<button onClick={hacerFoco}>Hacer foco en el input</button>
	</div>
	);
}
```

### `useMemo` (El calculador Caché)
- Concepto: Memoriza el resultado de una función constosa.
- ¿Para qué sirve? Imagina que tienes una lista de 10.000 products y tienes que filtrar los que valen más de $100. Si haces ese cáculo en cada renderizado, tu web se pondrá lenta. `useMemo` guarda el resultado y solo vuelve a calcularlo si cambian los datos de entrada.
- ¿Cuándo usarlo?: Cálculos matemáticos pesados, filtrado de listas frandes y ordenamiento.
- Ejemplo:
```tsx
const listaFiltrada = useMemo(()=>{
	return productos.filter(p => p.precio>100);
},[productos]); // solo recaulcula si productos cambia.
```

### `useCallback` (El estabilizador de las funciones)
- Concepto: Memoriza la definición de una función en sí.
- ¿Para qué sirve?: En react, las funciones se recrean en cada render. Si pasas una función a un componente hijo optimizado, ese hijo se volverá a renderizar innecesariamente porque "cree" que la función cambió. `useCallback` mantiene la misma referencia de función en la memoria.
- ¿Cuándo usarlo?: Cuando pasas funciones a componentes hijos que están envueltos en `React.memo` o cuando esa función es una dependencia de otro hook.
- Ejemplo: 
```tsx
const handleClick = useCallback(() => {
	console.log('Clickeado');
},[]); // esta función nunca cambia
```
Podemos decir tambien como: 
```tsx
const fn = useCallback(() => {
  // lógica
}, [deps]);
// mientras deps no cambien, esta funcion sera la misma (misma referencia).
```
Por ejemplo, evita re-renders de componentes hijos: 
```tsx
function Parent() {
  const [count, setCount] = useState(0);

  const onClick = () => {
    console.log("click");
  };

  return <Child onClick={onClick} />;
}
```
Aqui cada render 
- `onClick`es nueva
- `Child` renderiza aunque nada cambie
Mientras que usando `useCallback`:
```tsx
const onClcick = useCallback(() => {
	console.log("click");
}.[]);
```
Aqui la función es la misma y `Child` puede evitar renderizar.

También para dependencias estables en `useEffect`
Digamos el siguiente código: 
```tsx
function Example() {
	const handler = () => {
		console.log("event");
	};
	
	useEffect(() => {
		window.addEventListener("resize",handler);
		return () => window.removeEventListener("resize",handler);
	},[handler]);
}
```
Aqui el problema es que `handler` siempre cambia, entonces `useEffect` se ejecuta siempre, la solución sería la siguiente: 
```tsx
const handler = useCallback(() => {
	console.log("event");
},[]);
```
> Una regla es que si nadie depende de la referencia de esa función, no uses el `useCallback`

### `useReducer` (El Gestor de Lógica Compleja)

- **Concepto:** Una alternativa a `useState` para lógica de estado compleja.
- **¿Para qué sirve?** En lugar de tener varios `setContador`, `setNombre`, `setEdad` sueltos, tienes una sola función `dispatch` que envía "acciones" (ej: `AUMENTAR`, `DISMINUIR`). Es como un mini-Redux.
- **¿Cuándo usarlo?** Cuando el estado de un componente depende de lógica compleja o muchos sub-valores interrelacionados (ej: un carrito de compras).
- **Ejemplo:**
    
```tsx
const [state, dispatch] = useReducer(reducer, initialState);
    
    // dispatch({ type: 'INCREMENTAR' });
    
```
### `useId` (El Generador de Identidad)

- **Concepto:** Genera un ID único que es estable entre renderizados.
- **¿Para qué sirve?** En HTML (especialmente para formularios y accesibilidad), los `input` necesitan un `id` que coincida con su `label`.
- **¿Cuándo usarlo?** Para conectar etiquetas (`label`) con inputs sin miedo a que se repitan IDs si tienes varios componentes iguales en la página.
- **Ejemplo:**
```tsx
	

const id = useId();
	
	return (
	
	<div>
	
	<label htmlFor={id}>Email</label>
	
	<input id={id} type="text" />
	
	</div>
	
	);
```

### `useTransition` (El Gestor de Prioridad)

- **Concepto:** Marca una actualización de estado como "no urgente" (transición).
- **¿Para qué sirve?** Mejora la percepción de rendimiento. Permite que React actualice primero cosas importantes (como lo que escribes) y deje para después cosas pesadas (como filtrar una lista gigante).
- **¿Cuándo usarlo?** En interfaces donde escribir en un input provoca que la pantalla se "trabe" momentáneamente mientras se calcula algo.
- **Ejemplo:**
    
```tsx    
const [isPending, startTransition] = useTransition();

  

const handleChange = (e) => {

// Update urgente (lo que escribes)

setInputValue(e.target.value);

// Update no urgente (filtrado pesado)

startTransition(() => {

setFilter(e.target.value);

});

}
```

### Resumen general: 
| Hook | Categoría | Propósito Principal | ¿Cuándo usarlo? |
| :--- | :--- | :--- | :--- |
| **`useState`** | Básico | Guardar datos en memoria. | Cuando necesitas que la UI cambie al cambiar una variable. |
| **`useEffect`** | Básico | Efectos secundarios. | Para llamar APIs, eventos DOM, o al montar el componente. |
| **`useContext`** | Básico | Estado global. | Para pasar datos a componentes lejanos sin "prop drilling". |
| **`useRef`** | Básico | Referencia persistente. | Para acceder al DOM directamente o guardar valores sin re-render. |
| **`useMemo`** | Optimización | Memoria de valores. | Para cálculos pesados que no quieres repetir en cada render. |
| **`useCallback`** | Optimización | Memoria de funciones. | Para evitar que hijos se re-rendericen por cambios en funciones. |
| **`useReducer`** | Avanzado | Lógica compleja. | Cuando la lógica de estado es muy compleja (ej. formularios grandes). |
| **`useId`** | Utilidad | Identificador único. | Para generar IDs únicos en formularios (accesibilidad). |
| **`useTransition`** | Performance | Prioridad de updates. | Cuando una actualización de estado bloquea la interfaz de usuario. |


## El middleware:

TODO

