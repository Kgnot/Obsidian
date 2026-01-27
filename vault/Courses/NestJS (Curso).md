**NestJS** es un framework progresista para construir aplicaciones del lado del servidor eficientes y escalables con **Node.js**.

***
# Instalación

Para instalar se corre en la terminal:
```bash
npm i -g @nestjs/cli
# Para un nuevo proyecto:
nest new project-name
```

Al usar el comando `nest` podemos observar una tabla: 
![[Pasted image 20260111185222.png]]
Que son una forma en la que podemos crear o generar código fácilmente.

# Estructura del proyecto

La estructura del proyecto es la siguiente: 
![[Pasted image 20260111191708.png]]

En NESTJS nosotros encontramos: 
![[Pasted image 20260113074114.png]]
Lo importante es el apartado del módulo, ¿qué es un módulo?: 
# Modulo

En NestJS, un módulo es una clase anotada con el decorador `@Module`. Es el bloque fundamental de consturcción de una aplicación NestJS.

Para entenderlo de forma sencilla: una aplicación NestJS es básicamente un grafo de módulos, donde cada módulo organiza un conjunto de funcionalidades relacionadas. 

Aqií tenemos los puntos clave para entenderlo: 
## El propósito principal: Organización
Los módulos sirven para agrupar código que pertenece a la misma capacidad o dominio. Por ejemplo, en una aplicación de e-commerce, podrías tener un módulo para`Usuario`, otro para `Productos` y otro para `Pedidos`. Esto ayuda a mantener el código ordenado y aplica el principio de separación de intereses. 

## Estructura del decorador `@Module`

Para que una clase sea un módulo, debes decorarla y pasarle un objeto de metadatos con cuatro propiedades principales: 

- `providers`: Son los servicios (o lógica de negocio) que pertenece a ese módulo. NestJS los instancia y los hace disponibles para inyectarlos en otras clases dentro de ese módulo.
- `controllers`: Son los controladores que manejan las peticiones HTTP (rutas) y entran dentro de ese módulo.
- `imports`: Lista otros módulos que necesita para funcionar. Si el módulo 'A' necesita usar un servicio del módulo B, debe importar al módulo B.
- `exports`: Hace visibles ciertos `providers` de este módulo para que puedan ser usados por otros módulos que lo importen. Por defecto, todo es privado
## El módulo raíz (`AppModule`)

Toda aplicación NestJS tiene al menos un módulo, llamado módulo raíz. Este es el punto de partida desde el cual NestJS arma el árbol de dependencias de la aplicación. Normalmente, se encuentra en `app.module.ts`.

## Tipos de Módulos:
- feature Módulos (Módulos de funcionalidad): Agrupan código específico (ej. `UsersModule`,`AuthModule`).
- Shared Módulos (Módulos compartidos): Si creas un módulo que provee un servicio útil (ej: Un servicio de Base de Datos o de Email), puedes exportarlo para que otros módulos lo usen.
- Global Módulos (Módulos Globales): Si declara un módulo como global (`@global`), no necesitas importarlo en otros módulos; sus `providers` estarán disponibles en todas aprtes automáticamente. Se debe usar con cautela.

## Gráfico de ejemplo
![[Pasted image 20260113075256.png]]

Los módulos tienen el siguiente aspecto
```ts
import { Module } from '@nestjs/common';
import { TaskController } from './task.controller';
import { TasksService } from './tasks.service';


@Module({
    imports: [], // aquí es para los @Module de otro lado
    controllers: [TaskController], // aquí es para los @Controller
    providers: [TasksService], // aquí es para los @Injectable
})

export class TasksModule { }
```
# Controladores: 
 
El proposito de un controlador es gestionar solicitudes específicas para la aplicación. El mecanismo de enrutamiento determina qué controlador gestionará cada solicitud. A menudo, un controlador tiene múltiples rutas, y cada una puede realizar una acción diferente
## Enrutamiento:
```ts

import { Controller, Get } from '@nestjs/common';

@Controller('cats')
export class CatsController {
  @Get()
  findAll(): string {
    return 'This action returns all cats';
  }
}

```

## Parametros en NestJS
Dentro de aqui tenemos diferentes parametros, tenemos: 
### `@Request()` | `@Req()`
Esto nos da el objeto `req` completo, Podemos acceder a `req.body`, `req.params`, `req.headers`, etc.

Estos decoradores te dan acceso **directo y completo** al objeto de solicitud y respuesta del nodo subyacente (que por defecto es Express).

- **`@Req()` (o `@Request()`):** Inyecta el objeto `request`. Contiene toda la info de la petición: cabeceras, URL, método, body, etc.
- **`@Res()` (o `@Response()`):** Inyecta el objeto `response`. Te permite controlar manualmente la respuesta que se envía al cliente (códigos de estado, redirecciones, etc.).

```ts
@Get()
test(@Req() req){
	console.log(req.body);
	console.log(req.params);
}
```
Aquí nosotros debemos importar objetos de `express`:
```ts
import { Controller, Get, Post, Req, Res } from '@nestjs/common';
import type { Request, Response } from 'express';

@Controller({})
export class TaskController {

    constructor() { }

    @Get("/tasks")
    getAllTasks(@Req() req: Request, @Res() res: Response) {
        console.log("getAllTasks")
        res.status(200).json({ message: "getAllTasks" })
    }
  
    @Post("/tasks")
    createTask() {
        return "create task"
    }
}
```

### `@Body()` (El cuerpo de la petición)
Este es el más usado para crear o editar datos. Se utiliza para extraer los datos enviados en el cuerpo de una petición (Generalmente `POST` o `PUT`).
Por ejemplo: 
```ts
import { Post, Body } from '@nestjs/common';

// Crear un DTO (Data Transfer Object) para tipar los datos
class CreateUserDto {
  nombre: string;
  email: string;
}

@Post()
create(@Body() createUserDto: CreateUserDto) {
  // NestJS automáticamente mapea el JSON recibido a esta clase
  console.log(createUserDto.nombre); 
  return 'Usuario creado';
}
```

### `@Param()` (Parametros de la ruta)

Se usa para capturar variables que estan dentro de una URL. Se definen con dos puntos `:` en el decorador del controlador.
Ejemplo: 
```ts
import {Get,Param} from '@nestjs/common';

@Get(':id')
findOne(@Param() params){
	console.log(params.id)
	return `Buscando al usuario con ID ${params.id}`;
}
```
Una mejor practica sería: 
```ts
@Get(':id')
findOne(@Param('id') id: string) {
  return `Buscando al usuario con ID ${id}`;
}
```

### `@Query()` (Parámetros de consulta / URL String).

Sirve para capturar los parámetros que van después del símbolo `?` en la URL (también conocidos como query strings). Útil para filtros, paginación o búsquedas.

URL: `users?role=admin&page=1`
```ts
import { Get, Query } from '@nestjs/common';

@Get()
findAll(@Query() query: any) {
  console.log(query.role); // 'admin'
  console.log(query.page); // '1'
  return 'Lista de usuarios filtrados';
}
```
También se puede seleccionar solo uno:
```ts
@Get()
findAll(@Query('role') role: string) {
  return `Usuarios con rol: ${role}`;
}
```

### `@Headers` (Cabeceras)
Si necesitas leer información de las cabeceras HTTP (Cómo es el token de autorización o el tipo de contenido)
```ts
import {Get, Headers} from '@nestjs/common';

@Get()
getHeaders(@Headers() headers:any){
	console.log(headers.authorizartion); // Token Bearer ...
	return 'Cabeceras leídas';
}
```
### `@Ip()` y `@HostParam()`

- **`@Ip()`:** Obtiene la dirección IP del cliente.
- **`@HostParam()`:** Se usa cuando tienes rutas que dependen del dominio/host (ejemplo: `admin.misitio.com`).

# Decoradores

Crear decoradores personalizados en NestJS es una de sus características más potentes. Te permite encapsular lógica reutilizable (como verificación de roles, validación, logging, etc.) para mantener tu código limpio.

## Decoradores de Método: 
Estos se aplican encima de los métodos de tus controladores. Se usan mucho para agregar emtadatos o ejecutar lógica antes de que el controlador maneje la petición.

Por ejemplo:
```ts
import { SetMetadata } from '@nestjs/common';

// 'ROLES_KEY' es una clave constante para identificar nuestro metadato
export const ROLES_KEY = 'roles';
// Recibimos roles como parámetros dinámicos (...args)
export const Roles = (...roles: string[]) => SetMetadata(ROLES_KEY, roles);
```
Y su uso: 
```ts
import { Controller, Get } from '@nestjs/common';

@Controller('users')
export class UsersController {
  
  @Get()
  @Roles('admin', 'superadmin') // Usamos nuestro decorador
  findAll() {
    return 'Esta acción requiere rol de admin';
  }
}
```
_(Nota: Para que esto funcione realmente y bloquee el acceso, necesitarías un **Guard** que lea ese metadato, pero el decorador es el que "etiqueta" el método)._

## Decoradores de parametro 

Estos son los más útiles para simplificar tus controladores. Imagina que siempre estás extrayendo el usuario del objeto `request` para saber quién está logueado. En lugar de repetir `@Req() req: Request` y luego `req.user` en cada función, creas un decorador `@User()`.

Para esto usamos la función `createParamDecorator`.

**Escenario:** El Middleware o un Guard ya ha inyectado el objeto `user` en el `request`. Queremos recuperarlo fácilmente.

```ts
import { createParamDecorator, ExecutionContext } from '@nestjs/common';

// 'data' es el argumento que le pasas al decorador (opcional)
// 'ctx' es el contexto de ejecución que nos da acceso a Request/Response
export const User = createParamDecorator(
  (data: string | undefined, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    const user = request.user; // Asumimos que el request ya tiene el user

    // Si pasamos un argumento, ej: @User('email'), devolvemos esa propiedad
    // Si no pasamos nada, ej: @User(), devolvemos todo el objeto
    return data ? user?.[data] : user;
  },
);
```
uso: 
```ts
import { Controller, Get } from '@nestjs/common';
import { User } from './decorators/user.decorator'; // Supuesta importación

@Controller('profile')
export class ProfileController {

  @Get()
  getProfile(@User() user: any) { // Obtenemos todo el objeto usuario
    return user;
  }

  @Get('email')
  getEmail(@User('email') email: string) { // Obtenemos solo el email
    return email;
  }
}
```

## Decoradores de clase o propiedad
Aunque en NestJS usamos mucho los decoradores nativos de TypeScript (como `@Controller` o `@Injectable`), a veces quieres crear los tuyos propios para modificar el comportamiento de una clase o agregar propiedades estáticas.

**Ejemplo:** Un decorador simple que agrega una información de versión a la clase.

```ts
// Recibimos la versión como argumento
export function Version(version: string) {
  // 'target' hace referencia a la clase donde se pone el decorador
  return function(target: any) {
    Reflect.defineMetadata('version', version, target);
  };
}
```
Uso: 
```ts
@Version('1.0.0')
@Controller('items')
export class ItemsController {
  // ...
}
```

Otra manera de declarar un decorador es: 
```ts
export const Roles = (...roles: string[]) => {
  return (target: any, key?: string, descriptor?: PropertyDescriptor) => {
    Reflect.defineMetadata('roles', roles, descriptor?.value || target);
  };
};
```

Si el decorador va a un método:
```ts
class UsersController {
  @Roles('admin')
  findAll() {}
}

```
Tenemos resultados como

```ts
target === UsersController.prototype
key === 'findAll'
descriptor === {
  value: findAll,
  writable: true,
  enumerable: false,
  configurable: true
}
```
# Servicio
`nest g service <nombre>`
Un servicio en NestJS es una **clase con lógica de negocio reutilizable**, diseñada siguiendo el principio de **responsabilidad única**. Es el "cerebro" de tu aplicación donde resides la lógica principal.

**Propósito principal:**

- Contener la **lógica de negocio** (no lógica HTTP o de UI)
    
- Ser **inyectable** en cualquier parte de la aplicación
    
- **Compartir funcionalidad** entre diferentes controladores

```ts
@Injectable()  // ← Esto lo hace un servicio
export class UserService {
  // Su responsabilidad ES la lógica de usuarios
  // NO se preocupa por rutas HTTP o autenticación
}
```

# Pipes
`nest g pipe <link-nombre>`

**Definición conceptual:**  
Un pipe es un **transformador/validador** que procesa datos de entrada ANTES de que lleguen al manejador de ruta. Su trabajo es **transformar o validar** datos.

Al usar el comando lo que genera es el siguiente código: 
```ts
import { ArgumentMetadata, Injectable, PipeTransform } from '@nestjs/common';

  

@Injectable()

export class ValidateUserPipe implements PipeTransform {

  transform(value: any, metadata: ArgumentMetadata) {

    return value;

  }

}
```

A lo que nosotros podemos usar el value (que es el que llega) de cualquier forma. Por ejemplo:
```ts
import { ArgumentMetadata, BadRequestException, Injectable, PipeTransform } from '@nestjs/common';

  

@Injectable()

export class ValidateUserPipe implements PipeTransform {

  transform(value: any, metadata: ArgumentMetadata) {

    const ageNumber = parseInt(value.age.toString());

    if (isNaN(ageNumber)) throw new BadRequestException('Age is not a number');

  

    return { ...value, age: ageNumber };

  }

} 
```

Y la manera en la que se puede usar es: 
```ts
...

@Get('greet')
saludar(@Query(ValidateUserPipe) query: {name:string, age:number}){
	return `Hello ${query.name}, you are ${query.age+30} years old`;
}

...
```
# Interceptores

Un interceptor es un intermediario inteligente que se coloca entre la petición HTTP y el controlador (o el controlador y la respuesta).
Sus caracteristicas claves son: 
1. Puede modificar tanto la entrada como la salida
2. Puede interrumpir el flujo (cómo un guard, pero más poderoso)
3. Trabaja con observables RxJS
4. Se ejecuta en orden especifico en el ciclo de vida

![[Pasted image 20260116093447.png]]
Cuales son sus usos comunes?: 
1. Transformar respuestas (formato estandar)
2. Logging/auditoria (registrar todo)
3. Manejo de errores centralizado
4. Transformar datos antes de llegar al controlador
5. Cache de respuestas
6. Timeout de  peticiones largar
7. Medir el tiempo de ejecución

El código de un interceptor basico: 
```ts
import { 
  Injectable, 
  NestInterceptor, 
  ExecutionContext, 
  CallHandler 
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {

	intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
		console.log('Interceptor: Antes de la petición ...');
		
		const now = Date.now();
		const request = context.switchToHttp().getRequest();
		
		return next
		.handle() // Pasa al controlador
		.pipe(
			tap(() => { // Se ejecuta DESPUÉS del controlador
				console.log(`Interceptor: DESPUÉS... ${Date.now() - now}ms`);
		        console.log(`Ruta: ${request.method} ${request.url}`);
			})
		)
	}
}
```

Ejemplos, digamos para generar el formato de respuesta: 
```ts
import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

export interface ResponseFormat<T> {
	success: boolean;
	timestamp: string;
	path: string;
	data: T;
	message?: string;
}

@Injectable()
export class TransformInterceptor<T> implements NestInterceptor<T, ResponseFormat<T>> {

	intercept(context: ExecutionContext, next: CallHandler): Observable<ResponseFormat<T>> {
		const request = context.switchToHttp().getRequest();
		
		return next.handle.pipe(
			map(data => ({
				success: true,
				timestamp: new Date().toISOString(),
				path: request.url,
				data: data,
				message: data?.message || undefined,
			}))
		);
	}
}
```
Esto nos genera un resultado como: 
```json
// TODOS los endpoints ahora devuelven:
{
  "success": true,
  "timestamp": "2024-01-15T10:30:00.000Z",
  "path": "/api/users/1",
  "data": { "id": 1, "name": "Juan" }
}
```

Ahora interceptores para el manejo de errores: 
```ts
import { 
  Injectable, 
  NestInterceptor, 
  ExecutionContext, 
  CallHandler,
  HttpException,
  HttpStatus 
} from '@nestjs/common';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';

@Injectable()
export class ErrorInterceptor implements NestInterceptor {

	intercept(context: ExecutionContext, next: CallHandler):Observable<any> {
		return next.handle.pipe(
			catchError(error => {
				//Determinamos el error
				const status = error instacenof HttpException
				? error.getStatus()
				: HttpStatus.INTERNAL_SERVER_ERROR;
				// obtenemos el mensaje
				const message = error.response?.message || error.message;
				
				// Logeamos en produccion usando un loggerService
				
				//Formateamos la respuesta de error
				return throwError(() => new HttpException(
				{
					success:false,
					timestamp: new Date().toISOString(),
					path: context.switchToHttp().getRequest().url,
					message: message,
					error: error.name,
					...(process.env.NODE_ENV === 'development' && {stack: error.stack})
				},
				status
				));
			})
		);
	}
}
```

Ahora u interceptor para `timeout`: 
```ts
import { Injectable, NestInterceptor, ExecutionContext, CallHandler, RequestTimeoutException } from '@nestjs/common';
import { Observable, throwError, TimeoutError } from 'rxjs';
import { catchError, timeout } from 'rxjs/operators';

@Injectable()
export class TimeoutInterceptor implements NestInterceptor {
  constructor(private readonly timeoutMs: number = 5000) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      timeout(this.timeoutMs),  // ← Si tarda más, lanza TimeoutError
      catchError(err => {
        if (err instanceof TimeoutError) {
          return throwError(() => new RequestTimeoutException(
            `La petición excedió el tiempo límite de ${this.timeoutMs}ms`
          ));
        }
        return throwError(() => err);
      })
    );
  }
}
```

Interceptores para caché: 
```ts
import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable, of } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class CacheInterceptor implements NestInterceptor {
  private cache = new Map<string, any>();

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    
    // Solo cachear GET
    if (request.method !== 'GET') {
      return next.handle();
    }
    
    const key = `${request.url}-${JSON.stringify(request.query)}`;
    
    // 1. Verificar si existe en cache
    const cachedResponse = this.cache.get(key);
    if (cachedResponse) {
      console.log(`Cache HIT para: ${key}`);
      return of(cachedResponse);  // ← Devuelve desde cache
    }
    
    // 2. Si no existe, ejecutar y guardar
    return next.handle().pipe(
      tap(response => {
        console.log(`Cache MISS, guardando: ${key}`);
        this.cache.set(key, response);
        
        // Limpiar cache después de 5 minutos
        setTimeout(() => {
          this.cache.delete(key);
        }, 5 * 60 * 1000);
      })
    );
  }
}
```
## ¿Cómo usar los interceptores? 

A nivel glopbal se usa en `main.ts`:
```ts
// main.ts o app.module.ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { TransformInterceptor } from './interceptors/transform.interceptor';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Aplica a TODAS las rutas
  app.useGlobalInterceptors(new TransformInterceptor());
  
  await app.listen(3000);
}
```
O también se puede usar a nivel de controlador: 
```ts
import { Controller, UseInterceptors } from '@nestjs/common';
import { TransformInterceptor } from './interceptors/transform.interceptor';

@Controller('users')
@UseInterceptors(TransformInterceptor)  // ← Solo este controlador
export class UsersController {
  // ...
}
```
O a nivel de ruta: 
```ts
@Controller('users')
export class UsersController {
  
  @Get()
  @UseInterceptors(CacheInterceptor)  // ← Solo esta ruta
  findAll() {
    return this.usersService.findAll();
  }
  
  @Post()
  @UseInterceptors(LoggingInterceptor)  // ← Solo esta ruta  
  create() {
    // ...
  }
}
```

## Interceptor de auditoría
Este interceptor se ve importante: 
```ts
import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { AuditService } from './audit.service';

@Injectable()
export class AuditInterceptor implements NestInterceptor {
  constructor(private auditService: AuditService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const startTime = Date.now();
    
    // Datos de auditoría
    const auditData = {
      userId: request.user?.id || 'anonymous',
      ip: request.ip,
      method: request.method,
      url: request.url,
      userAgent: request.headers['user-agent'],
      startTime: new Date(startTime),
    };
    
    return next.handle().pipe(
      tap({
        next: (response) => {
          // Éxito
          this.auditService.log({
            ...auditData,
            status: 'success',
            durationMs: Date.now() - startTime,
            endTime: new Date(),
          });
        },
        error: (error) => {
          // Error
          this.auditService.log({
            ...auditData,
            status: 'error',
            durationMs: Date.now() - startTime,
            endTime: new Date(),
            error: error.message,
            statusCode: error.status,
          });
        }
      })
    );
  }
}
```
## Interceptor con configuración: 
```ts
import { Injectable } from '@nestjs/common';

// 1. Crear decorador para configuración
export const SetInterceptorConfig = (config: any) => {
  return (target: any, key?: string, descriptor?: PropertyDescriptor) => {
    if (descriptor) {
      Reflect.defineMetadata('interceptorConfig', config, descriptor.value);
    }
    return descriptor;
  };
};

// 2. Interceptor que lee configuración
@Injectable()
export class ConfigurableInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const handler = context.getHandler();
    const config = Reflect.getMetadata('interceptorConfig', handler);
    
    console.log('Configuración del interceptor:', config);
    
    return next.handle();
  }
}

// 3. Uso en controlador
@Controller('users')
export class UsersController {
  @Get()
  @SetInterceptorConfig({ cache: true, timeout: 10000 }) // ← Configuración
  @UseInterceptors(ConfigurableInterceptor)
  findAll() {
    return this.usersService.findAll();
  }
}
```
# Guards
`nest g guard <nombre>`

Un guard es un **vigilante/guardián** que decide SI UNA PETICIÓN PUEDE PASAR O NO a un controlador. Su único trabajo es **autorización y autenticación**.

Básicamente, responde a la pregunta: `¿Puedo entrar aqui? Es una desición binaria`.

Un flujo de datos es: 
![[Pasted image 20260116102828.png]]

Los guards por defecto tienen esta forma: 
```ts
import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';

import { Observable } from 'rxjs';

  

@Injectable()

export class AuthGuard implements CanActivate {

  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    return true;

  }

}
```
## Autenticación simple
```ts
import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common';

@Injectable()
export class AuthGuard implements CanActive {

	canActive(context:ExecutionContext):boolean{
	
	// Obtendremos la request HTTP: 
	const request = context.switchToHttp().getRequest();
	//extraemos el token
	const token = request.headers['authorization'];
	//Validamos (simplifado):
	if(!token){
		throw new UnauthorizedException('No token provider');
	}
	
	if(token !== 'Bearer mi-token'){
	throw new UnauthorizedException('Invalid token');
	}
	
	return true;
	}

}
```

## Guards con Roles: 
```ts
import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';

// Decorador personalizado (lo creamos nosotros)
export const Roles = (...roles: string[]) => {
  return (target: any, key?: string, descriptor?: PropertyDescriptor) => {
    Reflect.defineMetadata('roles', roles, descriptor?.value || target);
  };
};

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    // Obtener roles requeridos del decorador
    const requiredRoles = this.reflector.get<string[]>(
      'roles', // buscamos la metadata, y abajo nos dice en donde
      context.getHandler() // esta es la referencia a la función 
    );
    
    // Si no hay roles requeridos, cualquier puede acceder
    if (!requiredRoles) {
      return true;
    }
    
    // Obtener usuario de la request (asumimos que AuthGuard ya lo puso)
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    
    // Verificar si usuario tiene al menos uno de los roles
    const hasRole = requiredRoles.some(role => user.roles?.includes(role));
    
    if (!hasRole) {
      throw new ForbiddenException(
        `Requires one of these roles: ${requiredRoles.join(', ')}`
      );
    }
    
    return true;
  }
}
```

## Guards para rutas públicas/privadas
```ts
import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';

// Primero usamos el decorador
export const IS_PUBLIC_KEY = 'isPublic';
export const Public = () => {
	return (target: any, key?: string, descriptor?: PropertyDescriptor) => {
		Reflect.defineMetadata(IS_PUBLIC_KEY,descriptor?.value | target );
	}
}

@Injectable()
export class JwtAuthGuard implements CanActive {

	constructor(
		private reflector: Reflector,
		private jwtService: JwtService
	){}
	
	async canActive(context: ExecutionContext){
		const isPublic = this,reflector.getAllAndOverride<boolean>(
		IS_PUBLIC_KEY,
		[context.getHandler(),context.getClass()]
		);
	
		if(isPublic){
			 return true; // las rutas publicas no necesitan autenticaciónreturn true;
		}
		
		const request = context.switchToHttp().getRequest();
		const token = this.extractToken(request);
		
		if(!token){
			throw new UnauthorizedException('Token not found');
		}
		
		try{
			const payload = await this.jwtService.verify(token);
			request.user = payload; // adjuntamos usuario a la request
			return true; 
		} catch {
			throw new UnauthorizedException('Invalid token');
		}
	}
	
	private extractToken(request: Request): string | null {
		const [typee, token] = request.headers['authentication']?.split(' ') || [];
		return type === 'Bearer' ? token : null;
	}
}
```
Su uso en los controladores se vería: 
```ts
import { Controller, Get, UseGuards } from '@nestjs/common';
import { AuthGuard } from './auth.guard';
import { RolesGuard } from './roles.guard';
import { Roles } from './roles.decorator';

@Controller('profile')
@UseGuards(AuthGuard) // Aplica a todas las rutas del controlador
export class ProfileController {
  
  @Get()
  getProfile(@Req() request: Request) {
    // El guard ya verificó el token y adjuntó el usuario
    return { user: request['user'] };
  }
  
  @Get('admin')
  @UseGuards(RolesGuard) // Guard adicional para esta ruta
  @Roles('admin') // ← Metadata para el RolesGuard
  getAdminData() {
    return { message: 'Solo administradores' };
  }
}
```

# Middlewares

`nest g middleware <nombre>

Sigamos recordando esta imagen: 

![[Pasted image 20260116163438.png]]


`
En pocas palabras es una función que hace de intermediario, es decir, una función que no deja continuar con determinado url siempre que nosotros cumplamos con cierta lógica, o hacer alguna tarea. 

La definición más concreta dice que es un software intermedio que se ejecuta entre la recepcion de una petición HTTP y la ejecución del controlador. Es como un filtro o proceso intermedio

Al crearlo aparece: 
```ts
import { Injectable, NestMiddleware } from '@nestjs/common';

  
@Injectable()

export class LoggerMiddleware implements NestMiddleware {
  use(req: any, res: any, next: () => void) {
    next();
  }
}
```
podemos añadirlo un apartado sencillo como: 
```ts
    console.log("request", req.originalUrl);
```
Con el código final (usando algo de `express`):
```ts
import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response } from 'express';

  

@Injectable()

export class LoggerMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: () => void) {
    console.log("request", req.originalUrl);
    next();
  }
}
```
Eso, al ir a la URL, nos aparece: 
![[Pasted image 20260114121707.png]]
# Class-validator

Este es una librería poderosa para typescript y JavaScript que nos ayuda a usar decoradores y no decoradores basados en la validación. Un ejemplo rápido de cómo funciona es: 
```ts
import { validate } from 'class-validator';
import { Length, Contains, IsInt, Min, Max, IsEmail } from 'class-validator';

export class Post {
    @Length(10, 20)
    title: string;

    @Contains('hello')
    text: string;

    @IsInt()
    @Min(0)
    @Max(10)
    rating: number;

    @IsEmail()
    email: string;
}

let post = new Post();
post.title = 'Hello'; // too short
post.text = 'this is a great post about hell world'; // doesn't contain "hello"
post.rating = 11; // too high
post.email = 'google.com'; // not an email

validate(post).then(errors => {
    if (errors.length > 0) {
        console.log('validation failed. errors: ', errors);
    } else {
        console.log('validation succeed');
    }
});
```

Para mayor información la encontramos en: https://class-validator.sonicar.tech/ 

# Tener en cuenta

| **Quiero...**                    | **¿QUÉ USO?** | **¿POR QUÉ?**                                           |
| -------------------------------- | ------------- | ------------------------------------------------------- |
| **Loggear TODAS las peticiones** | MIDDLEWARE    | Porque se ejecuta PRIMERO, capta TODO                   |
| **Loggear SOLO ciertas rutas**   | INTERCEPTOR   | Porque sabe a QUÉ ruta va y QUÉ retorna                 |
| **Bloquear acceso**              | GUARD         | Porque eso es SU TRABAJO (permitir/negar)               |
| **Transformar datos de entrada** | PIPE          | Porque eso es SU TRABAJO (transformar)                  |
| **Transformar respuesta**        | INTERCEPTOR   | Porque intercepta la SALIDA                             |
| **Medir tiempo de ejecución**    | INTERCEPTOR   | Porque rodea la ejecución (sabe cuándo empieza/termina) |
| **Modificar headers**            | MIDDLEWARE    | Porque está al inicio, antes que todo                   |
| **Autenticación**                | GUARD         | Porque decide si pasa o no                              |
| **Validar datos**                |  PIPE         | Porque es su propósito específico                       |
## **Pregúntate esto:**

### **1. "¿Quiero hacer algo ANTES que se decida la ruta?"**

- **Sí** → MIDDLEWARE
    
- **No** → Sigue...
    

### **2. "¿Quiero PERMITIR o BLOQUEAR el acceso?"**

- **Sí** → GUARD
    
- **No** → Sigue...
    

### **3. "¿Quiero TRANSFORMAR/VALIDAR los datos de entrada?"**

- **Sí** → PIPE
    
- **No** → Sigue...
    

### **4. "¿Quiero hacer algo CON LA RESPUESTA o manejar errores?"**

- **Sí** → INTERCEPTOR
    
- **No** → ¿Entonces qué carajos quieres hacer?
# Comandos

Cuando nosotros necesitamos "generar" ciertas cosas predeterminadas podemos hacerlo mediante comandos, para saber que podemos generar usamos `nest generate --help`. Y esto nos da el siguiente resultado: 
![[Pasted image 20260113080357.png]]

Por ejemplo, podemos usar:
![[Pasted image 20260113080557.png]]
(`nest g mo <nombre_modulo>`)
(`nest g co <nombre_controlador>`) | (`nest g co <nombre_de_la_carpeta`) | (`nest g co <nombre> --no-espec`)
(``)


***

# Infraestructuras: 

## Clean Architecture

### 1.
Cogido de: [Medium](https://medium.com/@jonathan.pretre91/clean-architecture-with-nestjs-e089cef65045)

Necesitamos las 3 carpetas principales: `domain`,`infrastructure`,`usecases`. A veces podemos poner la de `application`, pero en este caso usaremos las 3. Luego haremos: 
```ts
nest g mo /infrastructure/config/environment-config  
nest g s /infrastructure/config/environment-config
```

(Debemos notar que el articulo tiene unos errores que iremos corrigiendo aqui según vamos leyendo).

Debemos crear la interfaz de configuración de la base de datos, así que continuamos: 
```ts
export interface DatabaseConfig {

  getDatabaseHost(): string;

  getDatabasePort(): number;

  getDatabaseUser(): string;

  getDatabasePassword(): string;

  getDatabaseName(): string;

  getDatabaseSchema(): string;

  getDatabaseSync(): boolean;

}
```

Esta configuración es una interfaz que conecta directamente con la infraestructura, asi que si hubiera una carpeta de aplicación ahi estaría y su implementación en infraestructura de la siguiente forma: 
```ts
import { Injectable } from '@nestjs/common';

import { DatabaseConfig } from '../database-config';

import { ConfigService } from '@nestjs/config';

  

@Injectable()

export class EnvironmentConfigService implements DatabaseConfig {

  constructor(private configService: ConfigService) { }

  

  getDatabaseHost(): string {

    return this.getString('environment.host');

  }

  

  getDatabasePort(): number {

    const port = this.configService.get<number>('DATABASE_PORT');

    return port ? port : 5432;

  }

  

  getDatabaseUser(): string {

    return this.getString('DATABASE_USER');

  }

  

  getDatabasePassword(): string {

    return this.getString('DATABASE_PASSWORD');

  }

  

  getDatabaseName(): string {

    return this.getString('DATABASE_NAME');

  }

  

  getDatabaseSchema(): string {

    return this.getString('DATABASE_SCHEMA');

  }

  

  getDatabaseSync(): boolean {

    const sync = this.configService.get<boolean>('DATABASE_SYNC');

    return sync ? sync : false;

  }

  

  private getString(key: string): string {

    const value = this.configService.get<string>(key);

    if (!value) {

      throw new Error(`Environment configuration error: variable ${key} is missing`);

    }

    return value;

  }

}
```

Ya con esto nos aseguramos de un pequeño manejo de errores, que podría haber un archivo separado para manejar errores dependiendo de la capa

Algo que debemos anotar es tener instalado: 
`npm install @nestjs/config`
Y además de esto, vamos a instalar `TypeORM` como ORM a utilizar.
`npm install @nestjs/typeorm`

Y creamos el módulo: `nest g mo /infrastructure/config/typeorm`, ya que se configurará.

creamos un apartado para las opciones: 
```ts
import { TypeOrmModuleOptions } from "@nestjs/typeorm";
import { EnvironmentConfigService } from "../enviroment-config/environment-config.service";

  
export const typeOrmOptions = (config: EnvironmentConfigService): TypeOrmModuleOptions => ({
    type: 'postgres',
    host: config.getDatabaseHost(),
    port: config.getDatabasePort(),
    username: config.getDatabaseUser(),
    password: config.getDatabasePassword(),
    database: config.getDatabaseName(),
    entities: [__dirname + '/**/*.entity{.ts,.js}'],
    synchronize: config.getDatabaseSync(),

})
```
Y otro apartado que es quien lo usa, el `TypeORM`.
```ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EnviromentConfigModule } from '../enviroment-config/enviroment-config.module';
import { EnvironmentConfigService } from '../enviroment-config/environment-config.service';
import { typeOrmOptions } from './typeorm-options';

  

@Module({
    imports: [TypeOrmModule.forRootAsync({
        imports: [EnviromentConfigModule],
        inject: [EnvironmentConfigService],
        useFactory: typeOrmOptions,
    })],

})

export class TypeormModule { }
```

Luego de esto ahora vamos al apartado del ORM, entonces creamos la entidad: 
```ts
import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";


@Entity()
export class TodoEntity {

    @PrimaryGeneratedColumn({ type: 'integer' })
    id: number;


    @Column('varchar', { length: 255, nullable: true })
    content: string;


    @Column('boolean', { default: false })
    isDone: boolean;


    @CreateDateColumn({ name: 'createdate' })
    createdate: Date;
  

    @UpdateDateColumn({ name: 'updateddate' })
    updateddate: Date;
}
```

Y por consiguiente creamos lo que es el modelo. 
```ts
export class TodoModel {
    id: number;
    content: string;
    isDone: boolean;
    createdate: Date;
    updateddate: Date;
}
```

Luego decidimos crear un `Logger`:
```bash
nest g mo /infrastructure/logger  
nest g s /infrastructure/logger
```

```ts
export interface LoggerModel {
    debug(context: string, message: string): void;
    log(context: string, message: string): void;
    error(context: string, message: string, trace?: string): void;
    warn(context: string, message: string): void;
    verbose(context: string, message: string): void;
}
```
Y su implementación: 
```ts
import { Injectable, Logger } from '@nestjs/common';
import { LoggerModel } from 'src/domain/interfaces/Logger';

@Injectable()
export class LoggerService extends Logger implements LoggerModel {

    constructor(context: string) {
        super(context);
    }

    debug(context: string, message: string) {
        if (process.env.NODE_ENV !== 'production') {
            super.debug(`[DEBUG] ${message}`, context);
        }
    }
    log(context: string, message: string) {
        super.log(`[INFO] ${message}`, context);
    }
    error(context: string, message: string, trace?: string) {
        super.error(`[ERROR] ${message}`, trace, context);
    }
    warn(context: string, message: string) {
        super.warn(`[WARN] ${message}`, context);
    }
    verbose(context: string, message: string) {
        if (process.env.NODE_ENV !== 'production') {
            super.verbose(`[VERBOSE] ${message}`, context);
        }
    }
}
```
