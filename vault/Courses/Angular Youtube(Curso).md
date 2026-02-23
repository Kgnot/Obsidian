---
type: course
status: en_progreso
tags: [course, Angular Youtube(Curso)]
date_started: 2024-05-20
---

Como proyecto final, creare la pagina web de mi papá

---
Antes de decir como crear aplicaciones en angular, debemos mirar cositas pequeñas de TypeScript. 
TypeScript es intuitivo si se viene con bases de otros lenguajes, pero hay que entender al menos este código: 
```typescript
function gentlemanApproves<T extends { new (...args: any[]) => {}}>( constructor:T , _context: ClasssDecoratorContext){
	return class extends constructor{
		gentleman = 'yes';
	}
}
```
Esa es una función que funciona como un decorador para una clase, se usa de la siguiente manera: 
```typescript
@gentlemanApproves
class MyClass {
	constructor(){}
}
```
De esta forma podemos usarlo: 
```typescript
const instance: MyClass = new MyClass();

console.log((instance as any).gentleman); //  yes
```
Ahora vamos con el decorado de un método, extender el cómo funciona un método. 

---
```typescript
type methodDecoratorStructure = (
	method:Function,
	context: ClassMethodDecoratorContext
) => PorpertyDescriptor | void; 
```
Esa es la forma o la shape, es decir lo anterior, ahora para hacer un decorador se hace una función: 
```typescript
function logMethod(method:Function, context:ClassMehtodDecoratorContext){

	return function (...args : any[]) {
			console.log(`Method : ${String(context.name)} called with argumens: ${args}`);
			const result = method.apply(this, args);
			console.log(result)
			return result;
	}
}
```
Y la manera en la que se usa: 
```typescript
class Calculadora{
	
	@logMethod
	suma(a:number, b:number){
	return a+b;
	}
}
```
El resultado es: ' Method sum called with arguments: 1,2' , 3 . 
Es una buena idea para crear loggers, por ejemplo

---
Para decorar un parametro de un método: 
```typescript

function registrarYModificarArgumentos(
	method: Function,
	context: ClassMethodDecoratorContext
){
	return function (...args: any[]){
	const argsModified = args.map((args)=> {
		typeof === 'string'? arg.toUpperCase(): arg;
	})
	return method.apply(this,argsModified);
	}
}

class Saludar{

	@registrarYModificarArgumentos
	saludar(parametro:string){
		console.log(`hola ${parametro}`)
	}
}
```

---
Para decorar las 'properties': 
```typescript
function mayus(_target:any, context:ClassAccessorDecoratorContext){
	return{
		get(this:any){
			return this[`_${String(context.name)}`].toUpperCase();
		}
		set(this:any, value:string){
			this[`_${String(context.name)}`] = value.toUpperCase();
		}
	}
}


// El uso en una clase: 

class Persona { 
	@mayus
	accessor name:string
	constructor (name:string) {
	this.name = name} 

}



```

De esta manera entendemos lo que son los decoradores, que si lo comparamos con java se parece mucho a los `@interface` juntándonos con cosas como ByteBudded (si mal no recuerdo)  explotando la capacidad reactiva de Java. 

# Angular, inicios: 
Para iniciar con Angular es necesario primero isntalar un manejador de paquetes como npm, bun, etc. y paso siguiente: 
```typescript
npm install -g @angular/cli
```
Al hacer eso se instala lo que es angular. El prefijo que se usa es: `ng`.  Podemos usar un comando para que siempre se instalen los paquetes con bun, o con el que deseemos. Por otro lado para crear un proyecto hacemos: 
```typescript
ng new <project-name>
```
Automáticamente, se inicia git y al tiempo añade un archivo de vscode. Nos da a elegir las opciones de nuestro proyecto y ya. 

---
Angular tiene algo llamado componentes, este tiene su historia, pero ahora no es importante, quizá para un trabajo, o para trabajar en versiones anteriores a la 17/18. Estos componentes usan lo que se mencionó al inicio del documento. Ahora veremos: 
### Modelo de un componente: 
```typescript

function Component(config:{selector:string,template:string}){

	return function (target:any){
		target.prototype.selector = config.selector;
		target.prototype.template = config.template
	}
}


@Component({
	selector:'app-component',
	template: '<h1> {{titulo}} </h1> '
}
)
class MyComponent{
	selector!:string;
	template!:string;
	
	
	titulo:string = "Soy un componente"
}
```

## Elementos de Angular: 

Sabemos qué angular es un tipo de plataforma estructural (conjunto de frameworks), que significa que brinda funcionalidad a algo que no lo tenía, en este caso , funciones extra al DOM. 

### Componente: 
Un componente, al igual que en cualquier otra plataforma, o framework o biblioteca, es, la unidad lógica mínima que se encarga de manejar una cosa por vez. 
Hay dos tipos de componentes: 
- Componente TONTO      
- Componente Inteligente
Hay una gran cantidad de arquitecturas a usar aqui como son: 
1. Patrón contenedor/presentacional
2. Scream Architecture
3. Clean Architecture
4. Single Source of Truth Architecture
El que usaremos es el patrón contenedor/presentacional [patron](https://medium.com/@vitorbritto/react-design-patterns-the-container-presentational-pattern-775b91aa0c49) .
* Presentacional -> Usado para  mostrar datos y manejar la UI. 
* Contenedor -> Maneja la lógica de negocios y también la comunicación con entidades externas.
#### Componente contenedor
Un ejemplo en código de lo que es un contenedor es: 
```typescript
@Component({
	standalone = true,
	selector = 'app-user',
	template = `<app-user-container [userName] = "userNameSignal()"/>`,
	imports = [UserProfileComponent]
})
export class UserComponent{
	userService = inject(UserService);
	userNameSignals = this.userService.userNameSignals;

}
```
Este es un contenedor porque tiene comunicación con entidades externas en este caso, usa un servicio para inyectar el nombre, es decir, pasar el nombre a otro componente. 
#### Componente Presentador
**Un presentador**: 
```typescript
@Component({
	standalone = true,
	selector = 'app-user-profile',
	template = `<div>{{username}}</div>`
})
export class UserProfileComponent{
	userName: string = "Gentleman"
}
```
Realmente este no hace nada, solo es un presentador, agarra un dato y lo muestra.

---
Los componen usan los decoradores para definir la funcionalidad extra que le estamos diciendo, en el *selector* le decimos como es que se va a cargar dentro del HTML, es decir, para llamar al componente cuya clase es `UserComponent` usamos en HTML: `<app-user/>`, y Angular lo sabe gracias al decorador de `Component`.
El *template* nos dice cuál es el HTML que renderiza, podemos usar tanto `template` como `templateUrl` que es más recomendable, ya que usa una ruta a un HTML a usar. También podemos usar un `styleUrl` o en su defecto `style`. 

Los `imports` es de lo más importante de Angular al igual que el `standalone`. Standalone es algo nuevo en Angular, lo que antes se trabajaba eran módulos, un decorador `@NgModule`, 

### Directivas: 
Las directivas son aquello que dan ese toque estructural que hablamos, darle una funcionalidad extra a algo que antes no lo tenía, como por ejemplo: 
- ngClass
- ngStyle
- ngIf
- ngFor
ese algo es un elemento del DOM. Hay dos tipos. 
#### Directiva estructural
Es la cual modifica la estructura del elemento el cual se aplica, como por ejemplo: 
```html
<div *ngIf=""></div>
<div *ngFor=""></div>
```
#### Directiva de atributos: 
Son todas aquellas que son atributos sobre el elemento, por ejemplo agregar un style o no, dependiendo algo: 
```html
<div [style]="{}" ></div>
<div [ngClass]="{'active':isActive}" ></div> <!-- Agregar una clase dependiendo de una condicion--> 
```
¿Cómo sabemos que es un atributo?, por los corchetes cuadrados. 

#### Crear directivas
##### Creacion de una directiva estructural
Para crear una directiva hacemos: 
```typescript
@Directive({
	standalone:true,
	selector:'[appShowOnScreenSize]'
})
export class appShowOnScreenSizeDirective implements OnInit{
	@Input() appShowOnScreenSize: 'small'|'medium'|'large'
	
	constructor (
		private templateRef: TemplateRef<any>,
		private viewContainer: ViewContainerRef
	){
	
	}
	ngOnInit{
		// un ngOnInit 
		this.updateView();
		window.addEventListener('resize',this.updateView.bind(this));
	}
	
	private updateView(){
		const width = window.innerWidth;
		
		this.viewContainer.clear();
		if(this.shouldShowContent(width)){
			this.viewContainer.createEmbeddedView(this.templateRef);
		}
	}
	
	private shouldShowContent(width::number):boolean{
		if(this.appShowScreenSize === 'small' && width<600)
		{
			return true;
		}
		if(this.appShowScreenSize === 'medium' && width>= 600 && width <= 1024)
		{
			return true;
		}
		
		if(this.appShowScreenSize === 'large' && width>= 1024)
		{
			return true;
		}
		return false; 
	}
}
```
Cuando en el selector usamos `[]` le decimos que es una directiva; sin embargo, vemos que su función es renderizar o no algo, por lo tan, es una directiva estructural.
¿Cómo se llega a utilizar?: 
```html
<div *appShowOnScreenSize="'small'"> Contenido para pantallas pequeñas </div>
```

##### Creación de una directiva de atributos: 
```typescript
@Directive({
	standalone:true,
	selector:"[appHighLight]"
})
export class HighLightDirective{
	constructor(
	private el:ElementRef,
	private renderer: Renderer2
	){
	}
	
	@HostListener("mouseenter") onMouseEnter(){
		this.renderer.setStyle(
			this.el.nativeElement, "background-color", "yellow");
	}
	
	@HostListener("mouseleave) onMmouseLeave(){
		this.renderer.removeStyle(
			this.el.nativeElement, "background-color");
	}

}
```
Para usarlo: 
```html
<p appHighLight> Pasa sobre este texto para resaltar su contenido </p>
```

### Servicios:
Los servicios se usan: 
1. Para la lógica del negocio (según)
2. Para conectarse con entidades externas
3. Para compartir información
Un servicio es un **SINGLETON**, es decir que hay una única instancia del servicio. Esa instancia se comparte a través de la app, la información que este contiene se comaparte a través de toda la app.  Los servicios son inyectables.

- `provideIn: 'root'` -> única instancia en toda la aplicación
```typescript
@Injectable({
	providedIn:'root', // significa que se inyecta en toda la app
})
export class AuthService{
	isAuthenticated: boolean = false;
	
	changeAuthenticated(){
		this.isAuthenticated = true;
	}
	
	static login(){
		console.log('Usuario no autenticado');
	}
	
}
```
- `providedIn; 'any'`-> se va a inyectar en el módulo más cercano al que lo solicite por primera vez | Esto sirve para cuando queramos optimizar la carga. 
```typescript
@Injectable({
	providedIn: 'any'
})
export class LogginService{
	log(message:string){
		console.log('log: ', message)
	}
}
```
Esto es para utilizar un servicio en un componente y sus hijos, así que: 
```typescript
@Component({
	selector: 'app-local',
	template: '<p>contenido del componente local</p>'
	providers: [LocalService]
})
export class LocalComponent{
	localService = inject(LocalService)
	
}
```
Es una instancia única y aislada del resto de los componentes y componentes hijos.

### Tipos de providers: 
#### `useClass` - Clase concreta
```typescript
@Injectable()
export class MockDataService{
	getData() {
		return 'mock data';
	}
}

@Inectable()
export class RealDataService{
	getData(){
		return 'real data';
	}
}


// ahora creamos el componente: 

@Component({
	standalone: true,
	selector: 'app-root',
	template :'<p>{{data}}</p>',
	providers: [
	{ provide: MockDataService, useClass: RealDataService}
	]
})
export class AppComponent{
	dataService = inject(MockDataService);
	data = this.dataService.getData();
}


```
#### **`useValue`** - Valor Estático
**Proporciona un valor predefinido (objeto, función, primitivo).**
`{ provide: Token, useValue: valor }`
```typescript
// Configuración de app
export const APP_CONFIG = {
  apiUrl: 'https://api.midominio.com',
  timeout: 5000,
  version: '1.0.0'
};

// Constante simple
export const MAX_RETRIES = 3;

// Providers
providers: [
  { provide: 'APP_CONFIG', useValue: APP_CONFIG },
  { provide: 'MAX_RETRIES', useValue: 3 },
  { provide: 'API_KEY', useValue: 'abc123' }
]

// Uso con @Inject
constructor(@Inject('APP_CONFIG') private config: any) {}
```
#### **`useFactory`** - Función Factory
**Proporciona un valor creado por una función factory.**
```typescript
@Injectable()
export class DataService{
	apiUrl:string = '';
}


export function dataServiceFactory(hostname:string){
	const apiUrl = hostname === 'localhost'
	?"https://localhost:3000"
	:"https://rickandmorty.com"
	return new DataService(apuUrl);
}


@Component({
	standalone: true,
	selector: 'app-root',
	template :'<p>{{data}}</p>',
	providers: [
	{ provide: DataService, useFactory: dataServiceFactory()}
	]
})
export class AppComponent{
	dataService = inject(DataService);
	data = this.dataService.apiUrl 
}

```
#### ## **`useExisting`** - Alias
**Proporciona un alias para otro token existente.**
```typescript
@Injectable()
export class BaseService{
	getData(){
		return 'base data'
	}
}

@Injectable()
export class DerivedService{
	baseService  = inject(BaseService)
	
	getData() {
		return this.baseService.getData() + ' - derived';
	}
}


// ahora hacemos el componente: 

@Component({
	standalone: true,
	selector: 'app-root',
	template: '<p>{{data}}</p>',
	providers:[
		BaseService,
		{provde:DerivedService,useExisting:BaseService}
	]
})
export class AppComponent{
	derivedService = inject(DerivedService)
	data:string = this.derivedService.getData();

}
```
Se usa cuando tienes dos tokens de inyección y deseas que ambos usen la misma instancia.

tenemos el siguiente esquema: 
* * *
```text
providers: [
  { provide: Token, useClass: Clase }, 
  { provide: Token, useValue: valor }, 
  { provide: Token, useFactory: factory },
  { provide: Token, useExisting: token }
]
```
***

## Angular CLI y Proyecto
El angular CLI es la interfaz de línea de comandos que nos brinda Angular, esta toma encuentra el archivo: `angular.json` , específicamente la línea de `schematics` : 
```json
"projects": {  
  "angular-control-flow-syntax": {  
    "projectType": "application",  
    "schematics": {  
      "@schematics/angular:component": {  // Esta Parte 
        "style": "scss",  
        "skipTests": true  
      }
```

Algo que debemos de ver es como renderizar algo. Usamos `ng g component <nombre_componente>` para crear un componente, existe también para crear un servicio, etc. 
Cuando se crea uno componente este nos genera una carpeta con: `html`,`.ts`,`.scss`. 
en esta carpeta vamos a ver lo que es el html, ahi podemos hacer : 
```html

```

***
## Servicios
Los servicios en Angular es una clase que encapsula lógica reutilizable y que se puede inyectar en distintos componentes u otros servicios.
Sus funciones varian del proyecto pero generalmente cumplen: 
- Llamadas HTTP
- Lógica del negocio
- Almacenamiento Local
- Comunicación entre componentes
- etc.
Para crearlo Angular nos da: 
```cmd
ng g service <nombre y/o ruta del componente>
```
Al ser creada nos genera dos archivos: 
1. Un archivo que es el servicio en si
2. Un archivo de testing por lo general marcado como`.spect.ts`.
En nuestro caso haremos un servicio que retornara personajes, lo común, entonces: 
```typescript
import {inject, Injectable} from '@angular/core';  
import {HttpClient} from '@angular/common/http';  
import {Observable} from 'rxjs';  
import {Character} from '../models';  
  
@Injectable({  
  providedIn: 'root'  
})  
export class CharacterService {  
  private apiUrl = 'https://api.examples.com/characters';  
  private http = inject(HttpClient); /* nos ayuda a hacer peticiones la backend*/  
  
  getCharacters(): Observable<Character[]> {  
    return this.http.get<Character[]>(this.apiUrl);  
  }  
  
  updateCharacters(character: Character): Observable<Character> {  
    return this.http.put<Character>(`${this.apiUrl}`, character)  
  }  
  
  deleteCharacter(id: number): Observable<void> {  
    return this.http.delete<void>(`${this.apiUrl}/${id}`)  
  }  
  
}
```
Cómo vemos el propio Angular nos brinda ayudas, en este caso tenemos el `HttpClient` que es parte del ecosistema de Angular, este nos devuelve un `Observable` veremos un par de diferencias: 
#### Observable: 
Un observable a diferencia de una promesa es un canal de comunicaciones, después nuestros elementos como componentes, escuchan, observan y se suscriben a este Observable, entonces pueden estar atentos al contenido que pasa por el canal. Al ser un observable, nosotros podemos añadir metodos sobre el observable mediante `pipe`;
```typescript
getCharacters(): Observable<Character[]> {  
  return this.http  
    .get<Character[]>(this.apiUrl)  
	.pipe(map(characters => {
		return characters.map(c=> ({
			...c, name:c.name.toUpperCase()	
		})) 
	}));  
}
```
Ahora, de esta forma, cada que quiera los personajes, no solo obtendré los personajes sino que estos vendrán modificados.

#### Promesa: 
`Promise` promete que algo va a suceder, aunque puede terminar tanto bien como mal. La promesa cumple una sola vez, nos da el dato y se termina.

### Adaptadores 
Los adaptadores siguen el patrón adapter, y cumplen la misma función que este intenta dar, en este caso pueden ser funciones simples como: 
```typescript
import {Character} from '../models';  
  
export const characterAdapter = (character: Character): Character => {  
  return {...character, name: character.name.toUpperCase()}  
}  
  
export const characterAdapterArray = (characters: Character[]): Character[] => {  
  return characters.map(characterAdapter)  
}
```
y se usaría: 
```typescript
getCharacters(): Observable<Character[]> {  
  return this.http  
    .get<Character[]>(this.apiUrl)  
    .pipe(map(characterAdapterArray));  
}
```
 
 ***

### Uso de observables: 
Hay muchas maneras usar los observables, primero partamos de las maneras menos óptimas.
#### Opción 1: 
Con una suscripción: 
```typescript
@Component({  
  standalone: true,  
  selector: 'app-root',  
  imports: [RouterOutlet],  
  templateUrl: './app.html',  
  styleUrl: './app.scss'  
})  
export class App {  
  title = 'Angular-services';  
  characterService = inject(CharacterService);  
  characters: Character[] = [] as Character[];
  
	constructor() {
		this.characterService.getCharacters().suscribe((chars) => {
			this.characters = chars;
		})
	}  
}
```

#### Opción 2:
Mediante un `pipe`: 
```typescript
@Component({  
  standalone: true,  
  selector: 'app-root',  
  imports: [RouterOutlet],  
  templateUrl: './app.html',  
  styleUrl: './app.scss'  
})  
export class App {  
  title = 'Angular-services';  
  characterService = inject(CharacterService);  
  characters: Character[] = [] as Character[];
  
	constructor() {
		this.characterService
		.getCharacters()
		.pipe(takeUntilDestroyed())
		.suscribe((chars) => {
			this.characters = chars;
		});
	}  
}
```

#### Opción 3:
Mediante un `pipe async`
```typescript
@Component({  
  standalone: true,  
  selector: 'app-root',  
  imports: [RouterOutlet, AsyncPipe],  
  templateUrl: './app.html',  
  styleUrl: './app.scss'  
})  
export class App {  
  title = 'Angular-services';  
  characterService = inject(CharacterService);  
  characters$: Observable<Character[]> = this.characterService
		.getCharacters(); // El dolar al final significa que es una operacion asincrona
}
```
El problema con este es que en HTML se hace, y ademas toca agregar cosas como el async. 
```html5
@let characters = characters$ | async;
```

#### Opción 4:

Mediante Signals:
```typescript: 
@Component({  
  standalone: true,  
  selector: 'app-root',  
  imports: [RouterOutlet],  
  templateUrl: './app.html',  
  styleUrl: './app.scss'  
})  
export class App {  
  title = 'Angular-services';  
  characterService = inject(CharacterService);  
  characters: Signal<Character[] | undefined> = toSignal(  
    this.characterService.getCharacters(),  
  )  
  
  
}
```

***
#### Opción 4.1: 
Esta opción lo que hace es que la aplicación sea totalmente reactiva, es decir, que a cada cambio como update, delete. Se recalculan los componentes que utilizan el servicio. 
```typescript
  
import {Injectable, signal} from '@angular/core';  
import {of} from 'rxjs';  
import {Character} from '../models';  
import {characterAdapter} from '../adapters';  
  
@Injectable({  
  providedIn: 'root'  
})  
export class CharacterService {  
  state = signal({  
    characters: new Map<number, Character>()  
  })  
  
  getFormattedCharacters() {  
    return [...this.state().characters.values()] /*Array.from(this.state().characters.value)*/  
  }  
  
  getCharacterById(id: number): Character | undefined {  
    return this.state().characters.get(id);  
  }  
  
  getCharacters(): void {  
    const mockData: Character[] = [  
      {id: 1, name: 'Luke', lastName: 'Skywalker', age: 25},  
      {id: 2, name: 'Leia', lastName: 'Organa', age: 25},  
      {id: 3, name: 'Han', lastName: 'Solo', age: 30},  
      {id: 4, name: 'Darth', lastName: 'Vader', age: 45},  
      {id: 5, name: 'Obi-Wan', lastName: 'Kenobi', age: 57}  
    ];  
  
  
    of(mockData).subscribe((result) => {  
      result.forEach((character) =>  
        this.state().characters.set(character.id, character)  
      );  
      this.state.set({characters: this.state().characters});  
    });  
  
  }  
  
  updateCharacters(character: Character): void {  
    const updatedCharacter = characterAdapter(character);  
    of(updatedCharacter).subscribe((result) => {  
      this.state.update((state) => {  
        state.characters.set(result.id, result);  
        return {characters: state.characters}  
      })  
    });  
    this.getCharacters();  
  }  
  
  deleteCharacter(id: number): void {  
    of({status: 200})  
      .subscribe(() => {  
        this.state.update((state) => {  
          state.characters.delete(id);  
          return {characters: state.characters}  
        })  
      })  
  }  
  
}
```
Y en el componente que usa este servicio:
```typescript
@Component({  
  standalone: true,  
  selector: 'app-root',  
  imports: [],  
  templateUrl: './app.html',  
  styleUrl: './app.scss',  
  changeDetection: ChangeDetectionStrategy.OnPush  
})  
export class App {  
  title = 'Angular-services';  
  characterService = inject(CharacterService);  
  characters: Signal<Character[] | undefined> =  
    computed(() =>  
      this  
      .characterService  
      .getFormattedCharacters()); // Computed lo que hace es obtener las señales o signlas que si alguna cambia, el se vuelve a recalcular  
  
}
```
Mientras que de la forma anterior necesitaba signals cuando se llamaba el servicio, o un signal más directo.

## Formularios - Reactive forms

Primero entremos en que son los formularios: 

---
Los formularios son de los principales puntos de interacción entre un usuario que ingresa a una aplicación web que permite que estos usuarios pueda ingresar datos para realizar una acción ya sea en la interfaz gráfica o en el servicio back-end. 
Las etiquetas para los formularios: 
```html
<forms>
</forms>
```
nos permite marcar el formulario, ¿qué elementos tiene?: 
- **action**: permite indicar la acción que realizara el formulario al enviarse
- **method**: indica que método HTTP se va a realizar
Tenemos otra etiqueta: 
```html
<label></label>
```
Esta es una apertura y cierre para una etiqueta de un elemento dentro del formulario
dentro de esta tiene elementos: 
- **for**: se utiliza para indicar a qué input hace referencia la etiqueta
Tenemos la etiqueta input: 
```html
<input>
```
son cuadros de texto que tenemos características como:
- **type**: Que nos dice el tipo de input que tenemos
- **id**: permite asignar una identificación única para cada elemento
***
```html
<form>
	<p><label for="nombre"> Nombre: <input type="text" id="nombre"></label></p>
	<p><label for="ape"> Apellido: <input type="text" id="ape"></label></p>
		<p><label for="edad"> Edad: <input type="text" id="edad "></label></p>
	<p><label for="observacion"> Observación: <textarea></textarea></label></p>
</form>
```
Para enviar formulario se usa el elemento `button`  con la propiedad `submit` .
```html
<form>
	<p><label for="nombre"> Nombre: <input type="text" id="nombre"></label></p>
	<p><label for="ape"> Apellido: <input type="text" id="ape"></label></p>
		<p><label for="edad"> Edad: <input type="text" id="edad "></label></p>
	<p><label for="observacion"> Observación: <textarea></textarea></label></p>
	<button type= "submit"> Enviar </button>
</form>
```
---
En angular hay dos maneras de crear formularios, tenemos los formularios mediante `Template-driven` y los `Reactive-Forms`. 
#### `Template Driven`

En la TypeScript lo importante vendría siendo: 
```typescript
crearUsuario(usuario: any) {
  this.http.post("http://localhost:8080/usuarios", usuario).subscribe();
}

```
y en el HTML
``` html
<form #usuarioForm="ngForm" (ngSubmit)="crearUsuario(usuarioForm.value)">
  <input name="nombre" ngModel placeholder="Nombre" />
  <input name="apellido" ngModel placeholder="Apellido" />
  <button type="submit">Enviar</button>
</form>
```

#### `Reactive Forms`
En el TypeScript tenemos: 
```typescript
form = this.fb.group({
  nombre: [''],
  apellido: ['']
});

constructor(private fb: FormBuilder, private http: HttpClient) {}

onSubmit() {
  this.http.post("http://localhost:8080/usuarios", this.form.value).subscribe();
}
```
y en el HTML: 
```html
<form [formGroup]="form" (ngSubmit)="onSubmit()">
  <input formControlName="nombre" placeholder="Nombre" />
  <input formControlName="apellido" placeholder="Apellido" />
  <button type="submit">Enviar</button>
</form>
```
Aqui ahondaremos mucho más, entonces: 
- `FormControl` = un input.
- `FormGroup` = un conjunto de inputs o incluso un `FromGroup`.
- `FormBuilder` = una manera más rápida de crear `FormGroup` y `FormControl`.
Con estas ideas identificamos dos patrones de diseño aqui: 
1. Composite
2. Builder
ahondaremos más aqui. Podemos realizar esto: 

```typescript
import {Component} from '@angular/core';
import {
  FormArray,
  FormBuilder,
  FormControl,
  FormGroup,
  ReactiveFormsModule
} from '@angular/forms';

export interface ItemForm {
  id: FormControl<number>;
  name: FormControl<string>;
  value: FormControl<number>;
}

export type CustomFormGroup = FormGroup<ItemForm>;

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [ReactiveFormsModule],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  form: FormGroup<{ items: FormArray<CustomFormGroup> }>;

  constructor(private fb: FormBuilder) {
    this.form = this.fb.group({
      items: this.fb.array<CustomFormGroup>([
        this.createItem(1, 'Item 1', 100),
        this.createItem(2, 'Item 2', 200),
        this.createItem(3, 'Item 3', 300),
      ])
    });
  }

  get items(): FormArray<CustomFormGroup> {
    return this.form.get('items') as FormArray<CustomFormGroup>;
  }

  createItem(id: number, name: string, value: number): CustomFormGroup {
    return this.fb.group<ItemForm>({
      id: this.fb.control(id, { nonNullable: true }),
      name: this.fb.control(name, { nonNullable: true }),
      value: this.fb.control(value, { nonNullable: true })
    });
  }

  addItem() {
    this.items.push(this.createItem(Date.now(), 'Nuevo', 0));
  }

  removeItem(index: number) {
    this.items.removeAt(index);
  }
}

```
y usarlo: 
```html
<form [formGroup]="form">
  <div formArrayName="items">
    <div *ngFor="let item of items.controls; let i = index" [formGroupName]="i">
      <input formControlName="id" placeholder="ID" type="number" />
      <input formControlName="name" placeholder="Nombre" />
      <input formControlName="value" placeholder="Valor" type="number" />
      <button type="button" (click)="removeItem(i)">Eliminar</button>
    </div>
  </div>
</form>

<button type="button" (click)="addItem()">Agregar</button>

<pre>{{ form.value | json }}</pre>

```
También está:
< Aqui iba algo demaciado largo y no tan legible, esta en las carpetas de Angular > Bigote>. 

***

## Interceptors: 
Antes que nada, toca hacer esta configuración: 
```typescript
import {ApplicationConfig, provideBrowserGlobalErrorListeners, provideZonelessChangeDetection} from '@angular/core';  
import {provideRouter} from '@angular/router';  
  
import {routes} from './app.routes';  
import {provideClientHydration, withEventReplay} from '@angular/platform-browser';  
import {provideHttpClient, withFetch, withInterceptors} from '@angular/common/http';  
import {authInterceptor} from './interceptors/auth-interceptor';  
  
export const appConfig: ApplicationConfig = {  
  providers: [  
    provideHttpClient(  
      withFetch(),  
      withInterceptors([  
        authInterceptor  
      ])  
    ),  
    provideBrowserGlobalErrorListeners(),  
    provideZonelessChangeDetection(),  
    provideRouter(routes), provideClientHydration(withEventReplay()),  
  
  ]  
};
```
donde `authInterceptor` es el interceptor que creamos con: 
```cmd
ng g interceptor <name>
```


---

# Entendiendo signal, observables, rxJS, etc. 

|Concepto|Qué es|Para qué sirve|Ejemplo|
|---|---|---|---|
|**Subject**|Un "emisor y receptor" de eventos|Comunicación entre componentes|`mensajes$.next('Hola')`|
|**Subscription**|La "suscripción" a un observable|Escuchar eventos|`sub = observable$.subscribe()`|
|**Observable**|Un "flujo de datos"|Manejar datos asíncronos|`datos$ = this.service.getData()`|
|**Observer**|El "que escucha"|Reaccionar a los datos|`{ next: (), error: () }`|
|**Operators**|"Transformadores" de datos|Modificar flujos|`map()`, `filter()`, `mergeMap()`|
## Operadores: 

```typescript
import { map, filter, tap, take } from 'rxjs/operators';

observable$.pipe(
  tap(val => console.log('Debug:', val)),    // Efecto secundario
  filter(val => val > 10),                   // Filtrar
  map(val => val * 2),                       // Transformar
  take(5)                                    // Tomar solo 5 valores
).subscribe();
```

## Los Observers: 
### **Comparativa de tipos de "Observers" y Reactividad en Angular**

| Tipo                | Pertenece a         | Retiene último valor          | Emite al nuevo suscriptor el último valor | Puede emitir manualmente (`.next()`)               | Ideal para...                                      | Ejemplo típico                              |
| ------------------- | ------------------- | ----------------------------- | ----------------------------------------- | -------------------------------------------------- | -------------------------------------------------- | ------------------------------------------- |
| **Observable**      | RxJS                | ❌ No                          | ❌ No                                      | ⚠️ No directamente (lo hace un `Subject`)          | Datos asíncronos (HTTP, sockets, streams)          | `http.get('/api')`                          |
| **Subject**         | RxJS                | ❌ No                          | ❌ No                                      | ✅ Sí                                               | Difundir eventos (botones, señales puntuales)      | Notificar clicks, logs, etc.                |
| **BehaviorSubject** | RxJS                | ✅ Sí                          | ✅ Sí                                      | ✅ Sí                                               | Estado compartido (carritos, sesiones, config)     | `carritoService.items$`                     |
| **ReplaySubject**   | RxJS                | ✅ (n valores)                 | ✅ Sí (repite últimos n)                   | ✅ Sí                                               | Repetir histórico de eventos a nuevos suscriptores | “Reenviar” mensajes de chat                 |
| **AsyncSubject**    | RxJS                | ✅ (último valor al completar) | ✅ Al completar                            | ✅ Sí                                               | Emitir el resultado final de un proceso largo      | Cálculos o procesos de una sola salida      |
| **Signal**          | Angular (desde v16) | ✅ Sí                          | ✅ Sí (reactivo por lectura)               | ⚠️ No con `.next()`, se usa `.set()` o `.update()` | Estado reactivo local, sin RxJS                    | Estado en componentes (`count = signal(0)`) |
| **WritableSignal**  | Angular             | ✅ Sí                          | ✅ Sí                                      | ✅ Con `.set()` o `.update()`                       | Estados modificables (similar a BehaviorSubject)   | `user = signal<User                         |
| **ComputedSignal**  | Angular             | ✅ (derivado)                  | ✅ Automático                              | ❌ No                                               | Derivar valores de otros signals                   | `total = computed(() => items().length)`    |
| **Effect**          | Angular             | ⚠️ (no almacena valor)        | ⚠️ (reacciona a changes)                  | ⚠️ (solo side effects)                             | Reaccionar a cambios en signals                    | `effect(() => console.log(items()))`        |
