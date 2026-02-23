

# Patrones de diseño:

Como elegir que patrón usar? : 

![1000000537.png](045fcb65-59a7-4e57-8245-4f3e7f760db8.png)

DEL LIBRO DE GoF:

# Patrones de creación

## Abstract Factory

El Abstract Factory proporciona una interfaz para crear familias de objetos relacionados o que dependen entre sí, sin especificar sus clases concretas

### Aplicabilidad

Use el patrón Abstract Factory cuando:

- Un sistema debe ser independiente de cómo se crean, componen y representan sus productos
- Un sistema debe ser configurado con una familia de productos de entre varias
- Una familia de objetos producto relacionados está diseñada para ser usada conjuntamente , y es necesario hacer cumplir esta restricción.
- Quiere proporcionar una biblioteca de clase de productos, y sólo quiere revelar sus interfaces, no sus implementaciones

### Estructura

![image.png](Concepto/src/Patrones%20de%20diseño/image.png)

### Participantes

- **Fabrica Abstracta:** Declara una interfaz para operaciones que crean objetos abstractos
- **Fabrica Concreta1, Fabrica Concreta2:** Implementa las operaciones para crear los objetos concretos del producto.
- **Producto Abstracto:** Declara una interfaz para un tipo de producto.
- **Producto Concreto:** Implementa la interfaz de producto Abstracto

### Código

El código va a constar de dos partes, la primera en python y la segunda en java :D

---

1. Código Python
    
    ```python
    #Aquí en el codigo, primero iran las interfaces normales
    from abc import ABC, abstractmethod
    
    class Weapon(ABC):
        def __init__(self, name: str, damage: float,life:float):
            self.__name:str = name
            self.__damage:float = damage
            self.__life:float = life
        @abstractmethod
        def attack(self) -> str:
            pass
        @abstractmethod
        def wear(self)->float:
            pass
        #Aqui van los metodos de get y set.
        def get_damage(self) -> float:
            return self.__damage
        def set_damage(self, damage: float):
            self.__damage = damage
        def get_life(self) -> float:
            return self.__life
        def set_life(self, life:float):
            self.__life = life
    
    class Armor(ABC):
        def __init__(self,name:str,armor:float):
            self.__name = name
            self.__armor:float = armor
        @abstractmethod
        def protect(self)->float:
            pass
        @abstractmethod
        def damageReturned(self)->float:
            pass
    
        #Aqui getters y setters
        def get_name(self)->str:
            return self.__name
        def get_armor(self)->float:
            return self.__armor
            
     ## Ahora haremos las concretas de estas dos: 
     
    class Bow(Weapon):
        def __init__(self,name,damage,life):
            super().__init__(name,damage+8,life)
        def attack(self)->float:
            super().set_life(self.wear())
            return self.get_damage()
        def wear(self)->float:
            return -2
            
    class Sword(Weapon):
        def __init__(self,name,damage,life):
            super().__init__(name,damage+5,life)
    
        def attack(self)->float:
            super().set_life(self.wear())
            return self.get_damage()
    
        def wear(self)->float:
            return -5
          
    class Breastplate(Armor):
        def __init__(self,name,armor):
            super().__init__(name,armor)
        def protect(self)->float:
            return super().get_armor() * 0.01
        def damageReturned(self)->float:
            return 5
            
     class Helmet(Armor):
        def __init__(self, name, armor):
            super().__init__(name, armor)
    
        def protect(self) -> float:
            return super().get_armor() * 0.01
    
        def damageReturned(self) -> float:
            return 15       
            
    #ahora las fabricas abstractas: 
    class ChampsFactory(ABC):
        @abstractmethod
        def createArmor(self)->Armor:
            pass
        def createWeapon(self)->Weapon:
            pass
    
    class MeleFactory(ChampsFactory):
    
        def createArmor(self)->Armor:
            return Breastplate("Casco de Madera",5)
        def createWeapon(self)->Weapon:
            return Sword("Espada de Halmet",50,120)
    
    class RangedFactory(ChampsFactory):
        def __init__(self):
            super().__init__(self)
    
        def createArmor(self)->Armor:
            return Helmet("Casco de Madera",5)
        def createWeapon(self)->Weapon:
            return Bow("Espada de Halmet",50,120)
        
     #El main quedaria de la siguiente forma: 
     
    from logica.factory.MeleFactory import MeleFactory
    
    mele_factory = MeleFactory()
    mele_armor = mele_factory.createArmor()
    mele_weapon = mele_factory.createWeapon()
    
    #y :
    mele_armor.protect()
    print(mele_weapon.attack())
    
    #puedo implementar las cosas que deseo
           
    ```
    
1. Código Java
```java
// Primero haremos el abtract : 
public abstract class CanalComunicacionFactory {  
  
    public abstract Mensajero crearMensaje();  
  
    public abstract FormateadorMensaje formateadorMensaje();  
  
    public abstract GestorPrioridad gestorPrioridad();  
  
  
}

// Luego haremos las interfaces, abran 3 familias
  
public interface FormateadorMensaje {  
}
  
public interface GestorPrioridad {  
}
public interface Mensajero {  
}

// ----- Luego implementaciones de las familias: 
  
public class EmailFormato implements FormateadorMensaje {  
}  
public class SlackFormato implements FormateadorMensaje {  
} 
public class SMSFormato implements FormateadorMensaje {  
}
// gestorPrioridad: 
  
public class EmailManejadorPrioridad implements GestorPrioridad {  
}
  
public class SlackManejadorPrioridad implements GestorPrioridad {  
}
public class SMSManejadorPrioridad implements GestorPrioridad {  
}

// Mensajero
public class EmailMensaje implements Mensajero {  
}
public class SlackMensaje implements Mensajero {  
}
public class SMSMensaje implements Mensajero {  
}

// ---- Ahora una vez creada las implementaciones creamos la implementación dle factory: 
public class CanalComunicacionEmail extends CanalComunicacionFactory {  
  
    @Override  
    public Mensajero crearMensaje() {  
        return new EmailMensaje();  
    }  
    @Override  
    public FormateadorMensaje formateadorMensaje() {  
        return new EmailFormato();  
    }  
    @Override  
    public GestorPrioridad gestorPrioridad() {  
        return new EmailManejadorPrioridad();  
    }
}

// Este seria una sola, para Mensaje, se implementaría las demas 
// En el main encontrariamos algo como: 
public class Main {  
    public static void main(String[] args) {  
  
        CanalComunicacionFactory canalEmail = new CanalComunicacionEmail();  
  
        var mensajero = canalEmail.crearMensaje();  
        var gestorPrioridad = canalEmail.gestorPrioridad();  
        var formateador = canalEmail.formateadorMensaje();  
                  
  
  
    }  
}
    
 

// y lueog implementariamos los metodos   
    
```

3. Código Typescript:
	```typescript
	
	```
## Factory Method

Define una interfaz para crear  un objeto, pero deja que sean las subclases quienes decidan que clases instanciar. Permite que una clase delegue en sus subclases la creación de objetos.

Tambien es conocido como Constructor Virtual o *virtual constructor.*

### Aplicabilidad

Úsese el patrón Factory Method cuando:

- Una clase no puede prever la clase de objetos que deba crear
- Una clase quiere que sean sus subclases quienes especifiquen los objetos que ésta crea.
- Las clases delegan la responsabilidad en una de entre varias clases auxiliares, y queremos localizar qué subclase de auxiliar concreta es en la que se delega

### Estructura

![image.png](Concepto/src/Patrones%20de%20diseño/image%201.png)

### Participantes

### Código
```java
// En este hay varias formas de implementarse, podría ser solo implementable en la misma clase como una variable estatica que diga como crearse y que crear, y ya xd. O con todo el formato de clases que sabemos, el primero es tan simple que no lo abordaré. El otro es el siguiente: 

// interfaz:; 
public interface Conexion {  
}

//conexion concreta: 
public class ConexionPostgresql implements Conexion {  
}

// creador abstracto: 
public abstract class ConnectionFactory {  
  
    public abstract Conexion createConnection();  
  
  
}

// creador concreto: 
public class PostgreSQLConnectionFactory extends ConnectionFactory {  
  
    @Override  
    public Conexion createConnection() {  
        return new ConexionPostgresql();  
    }
}

```

## Builder

Este patrón de diseño separa lo que es la construcción de un objeto de su representación, de forma que el mismo proceso de construcción pueda crear diferentes representaciones

### Aplicabilidad

Úsese el patrón Builder cuando: 

- El algoritmo para crear un objeto complejo debería ser independente de las partes de que se componen dicho objeto y de como se ensamblan
- El proceso de construcción debe permitir diferentes representaciones del objeto que está siendo construido.

### Estructura

![image.png](Concepto/src/Patrones%20de%20diseño/image%202.png)

### Participantes

- **Constructor:** Especifica las partes de un objeto producto [ es abstracta ]
- **ConstructorConcreto:** Son las diferentes clases que implementan la abstracción de Constructor; define la representación a crear; proporciona una interfaz para crear un producto
- **Director:** Construye el objeto usando la interfaz Constructor
- **Producto:**  Es la representación del objeto completo.

### Código

1. Código en Python:
    
    ```python
    #Lo primeor es , que queremos construir, nosotros? PIZZA :D
    class Pizza:
        def __init__(self):
            self.__nombre:str = ""
            self.__masa:str=""
            self.__ingredient:str = ""
    
        @property
        def nombre(self):
            return self.__nombre
    
        @nombre.setter
        def nombre(self,nombre):
            self.__nombre = nombre
    
        @property
        def masa(self):
            return self.__masa
        @masa.setter
        def masa(self,masa):
            self.__masa = masa
    
        @property
        def ingredient(self):
            return self.__ingredient
    
        @ingredient.setter
        def ingredient(self,ingredient):
            self.__ingredient = ingredient
    
    #El constructor [abstracto]
    
    class ConstructorPizza(ABC):
        def __init__(self):
            self._pizza:Pizza = None # Aqui solo mandamos la referencia :D
    
        @abstractmethod
        def construirMasa(self):
            pass
        @abstractmethod
        def construirIngrediente(self):
            pass
    
        @property
        def pizza(self):
            return self._pizza
    
    #Clases proppias de constructor
    
    class ConstructorPizzaPepperoni(ConstructorPizza):
    
        def __init__(self):
            super().__init__()
            self._pizza = Pizza()  # Asigna una nueva instancia de Pizza al 
            #atributo _pizza
            self._pizza.nombre = "Pizza de Pepperoni"
    
        def construirMasa(self):
           self._pizza.masa = "Masa de Pepperoni"
    
        def construirIngrediente(self):
            self._pizza.ingredient = "Salami y pepperoni"
            
    class ConstructorPizzaVegetariana(ConstructorPizza):
    
        def __init__(self):
            super().__init__()
            self._pizza = Pizza()  # Asigna una nueva instancia de Pizza al
            # atributo _pizza
            self._pizza.nombre = "Pizza Vegetariana"
    
        def construirMasa(self):
           self._pizza.masa = "Masa Normal"
    
        def construirIngrediente(self):
            self._pizza.ingredient = "Cesped"
            
    #Ahora el director: 
    class Director:
        def __init__(self,constructor:ConstructorPizza = None):
            self.__constructor:ConstructorPizza = constructor
    
        @property
        def constructor(self):
            return self.__constructor
    
        @constructor.setter
        def constructor(self,constructor:ConstructorPizza):
            self.__constructor = constructor
    
        def construirPizza(self):
            self.__constructor.construirMasa()
            self.__constructor.construirIngrediente()
    
        def get_Pizza(self)->Pizza:
            return self.__constructor.pizza
        
    # El main se veria: 
    
    cocina = Director()
    pizzaPepperoni:ConstructorPizza = ConstructorPizzaPepperoni()
    cocina.constructor = pizzaPepperoni
    cocina.construirPizza()
    
    pizza:Pizza = cocina.get_Pizza()
    
    print(pizza)              
    
    ##### Lombok usa un builder diferente, que puede ser creado de esta forma: 
    
    class Persona:
        def __init__(self, nombre=None, edad=None, direccion=None):
            self.nombre = nombre
            self.edad = edad
            self.direccion = direccion
    
        def __str__(self):
            return f"Persona(nombre={self.nombre}, edad={self.edad}, direccion={self.direccion})"
    
        class Builder:
            def __init__(self):
                self.nombre = None
                self.edad = None
                self.direccion = None
    
            def set_nombre(self, nombre):
                self.nombre = nombre
                return self  # Retorna self para permitir encadenamiento
    
            def set_edad(self, edad):
                self.edad = edad
                return self
    
            def set_direccion(self, direccion):
                self.direccion = direccion
                return self
    
            def build(self):
                return Persona(self.nombre, self.edad, self.direccion)
    
    # Uso del Builder
    persona = Persona.Builder() \
        .set_nombre("Juan") \
        .set_edad(30) \
        .set_direccion("Calle 123") \
        .build()
    
    print(persona)
    ```
    
    Como no tenemos un toString, entonces se ve : 
    
    ![image.png](Concepto/src/Patrones%20de%20diseño/image%203.png)
    
    ---
    
1. Código en Java: 
```java
    
```
    IMPORTANTE: 
    > Muchas veces lo que construye el constructor es un Composite.
    > 

## Prototype

Especifica los tipos de objetos a crear por medio de una instancia prototípica y crea nuevos objetos copiando dicho prototipo

### Aplicabilidad

Úsese el patrón Prototype cuando un sistema deba ser independiente de cómo se crean, se componen y representan sus productos; y: 

- Cuando las clases a instanciar sean especificas en tiempo de ejecución
- Para evitar construir una jerarquía de clases de fábricas paralela a la jerarquía de clases de productos
- Cuando las instancias de una clase puedan tener uno de entre sólo unos pocos estados diferentes. Puede ser más adecuado tener un número equivalente de prototipos y clonarlos, en vez de crear manualmente instancias de la clase cada vez con el estado apropiado.

### Estructura

![image.png](Concepto/src/Patrones%20de%20diseño/image%204.png)

### Participantes

- **Prototipo:** Declara una interfaz para clonarse
- **PrototipoConcreto:** Implementa una operación para clonarse
- **Cliente:**  Crea un nuevo objeto pidiéndole a un prototipo que se clone

### Código

1. Python
    
    ```python
    Vamos a ver dos cuestiones diferentes
    #En java encontramos la interfaz prototype de una vez y en python tenemos:
    #copy:
    import copy
    
    class Prototype:
    	def clone(self):
    		return copy.deepcopy(self)
    		
    #Aqui la subclase: 
    
    class Personaje(Prototype):
    	def __init__(self, nombre, nivel, habilidades):
            self.nombre = nombre
            self.nivel = nivel
            self.habilidades = habilidades  # Lista de habilidades
    
        def __str__(self):
            return f"Personaje(nombre={self.nombre}, nivel={self.nivel}, habilidades={self.habilidades})"
            
    # Crear un personaje prototipo
    prototipo_personaje = Personaje("Guerrero", 1, ["Ataque básico", "Bloqueo"])
    
    # Clonar el personaje prototipo
    personaje1 = prototipo_personaje.clone()
    personaje1.nombre = "Arquero"
    personaje1.habilidades.append("Disparo preciso")
    
    personaje2 = prototipo_personaje.clone()
    personaje2.nombre = "Mago"
    personaje2.nivel = 5
    personaje2.habilidades = ["Bola de fuego", "Escudo mágico"]
    
    # Mostrar los personajes creados
    print(prototipo_personaje)
    print(personaje1)
    print(personaje2)
    ```
    
    ---
    
2. Java

```python

```

## Singleton

Garantiza que una clase sólo tenga una sola instancia, y proporciona un acceso global a ella.

### Aplicabilidad

Usaremos el patrón singleton cuando:

- Deba haber exactamente una instancia de una clase, y ésta debe ser accesible a los clientes desde un punto de acceso conocido.
- La única instancia debería ser extensible mediante herencia, y los clientes deberían ser capaces de usar una instancia extendida sin modificar su código.

### Estructura

![image.png](Concepto/src/Patrones%20de%20diseño/image%205.png)

### Participantes

### Código

```python
class SingletonMeta(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super().__call__(*args, **kwargs)
        return cls._instances[cls]

class Singleton(metaclass=SingletonMeta):
    def __init__(self, nombre):
        self.nombre = nombre

    def mostrar(self):
        print(f"Soy una instancia Singleton con nombre: {self.nombre}")

# Uso
singleton1 = Singleton("Instancia 1")
singleton2 = Singleton("Instancia 2")

print(singleton1 is singleton2)  # Salida: True
singleton1.mostrar()  # Salida: Soy una instancia Singleton con nombre: Instancia 1
```

# Patrones estructurales:

Los patrones estructurales explican cómo ensamblar objetos y clases en estructuras más grandes, a la vez que se mantiene la flexibilidad y eficiencia de estas estructuras.

## Patrón Adapter:

El patrón adapter convierte la interfaz de una clase en otra interfaz que es la que esperan los clientes. Permite que cooperen clases que de otra forma no podrían por tener interfaces incompatibles. También es conocido como un Wrapper o envoltorio.

### Aplicabilidad:

El patrón debe usarse  cuando: 

- Se quiere usar una clase existente pero su interfaz no es compatible.
- Se quiere crear una clase reutilizable que coopere con clases no relacionadas o que no han sido previstas , es decir, clases que no tienen porque tener interfaces compatibles

### Estructura:

![image.png](Concepto/src/Patrones%20de%20diseño/image%206.png)

### Participantes:

- **Objetivo:** Define la interfaz especifica del dominio que usa el cliente.
- **Cliente:** Colabora con los objetos que se ajustan a la interfaz Objetivo.
- **Adaptable:** Define una interfaz existente que necesita ser adaptada
- **Adaptador:** Adapta la interfaz de Adaptable a la interfaz Objetivo

### Codigo

```java
// El codigo se ve limpio en este caso: 

//Tenemos una interfaz que nosotros usamos que se llama conectable

public interface Conectable
{
	boolean encender();
	boolean apagar();
	String estaEncendida();
}

// Ahora las que la implementan: 

public class Lampara implements Connectable{
	
	private boolean encendida = false; 
	
	@Override
	public boolean encender(){
		encendida = true;
	}
	
	@Override boolean apagar(){
		encendida = false;
	}
	
	@Override String estaEncendida(){
		return encendida;
	}
}

public class Ordenador implements Connectable{
	
	private boolean encendida = false; 
	
	@Override
	public boolean encender(){
		encendida = true;
	}
	
	@Override boolean apagar(){
		encendida = false;
	}
	
	@Override String estaEncendida(){
		return encendida;
	}
}

// Las clases pueden ser iguales no pasa nada. Ahora bien: 
// Si tuvieramos una clase externa como por ejemplo: 

public class LamparaInglesa {
  private boolean isOn;
  
  public boolean isOn() {
    return isOn;
  }
  public void on () {
    
    isOn=true;
  }
  
  public void off() {
    
    isOn=false;
  }
}

// Necesitamos ADAPTARLA, y lo hacemos de esta siguiente forma: 

// Ahora creamos el adaptador: 

public class AdaptadorLampara implements Conectable 
{
	
	private LamparaInglesa lampara = new LamparaInglesa();

	@Override
	public boolean encender(){
		lampara.on();
	}
		
	@Override boolean apagar(){
		lampara.off();
	}
		
	@Override String estaEncendida(){
		return lampara.getIsOn();
	}

}

// de esta manera adaptamos la lampara jiji y podemos hacer: 

public class Principal {
  public static void main(String[] args) {
    
    Conectable l1= new Lampara();
    encenderAparato(l1);
    
    Conectable o1= new Ordenador();
    encenderAparato(o1);
    Conectable l2= new AdaptadorLampara();
    encenderAparato(l2);
  }
  private static void encenderAparato(Conectable l1) {
    l1.encender();
    System.out.println(l1.estaEncendida());
  }
}
```

## Patrón Bridge:

Desacopla una abstracción de su implementación , de modo que ambas pueden variar de forma independiente: 

### Aplicabilidad

- Cuando se quiera evitar un enlace permanente entra una abstracción y una implementación. Por ejemplo, cuando debe seleccionarse o cambiarse la implementación en tiempo de ejecución.
- Tanto abstracciones como implementaciones deberían ser extensibles mediante subclases.  El patrón permite extenderlas independientemente.

### Estructura

![image.png](Concepto/src/Patrones%20de%20diseño/image%207.png)

### Participantes

- **Abstracción:** Define la interfaz de la abstracción y mantiene la referencia a un objeto del implementador
- **Abstracción Refinada:** Extiende la interfaz definida por Abstracción
- **Implementador:** Define la interfaz de las clases de implementación. Esta interfaz no tiene porque corresponderse a la abstracción, pueden ser muy diferentes
- **Implementador Concreto:**  Implementa la interfaz y define una implementación concreta.

### Código:

Una táctica para saber cual es el implementador y cual es la abstracción: 

- **Pregunta "¿Qué quiero hacer?"**
    
    → Respuesta: Notificar usuarios. (Esto es la **abstracción**).
    
- **Pregunta "¿Cómo quiero hacerlo?"**
    
    → Respuesta: Usar correo o SMS. (Esto es el **implementador**).
    

```java
//Emepzaremos por la parte de la implementación

interface NotificationSender 
{
	void send(String message);
}

// Las clases concretas de la implementacion son: 
class SmsSender implements NotificationSender 
{
	@Override
	public void send(String message)
	{
		System.out.println("Enviando mensaje SMS: "+ message);
	}
}
// clase dos
class EmailSender implements NotificationSender 
{
	@Override
	public void send(String message)
	{
		System.out.println("Enviando correo electronico: "+ message);
	}
}
```

Ahora la abstracción que es ¿Qué deseo hacer?

```java
abstract class Notification
{

	protected NotificationSender sender;
	
	public Notification(NotificationSender sender)
	{
		this.sender = sender;
	}
	
	public abstract void notifyUser(String message);

}

// Ahora las abstracciones concretas: 

class HighPriorityNotification extends Notification {
    public HighPriorityNotification(NotificationSender sender) {
        super(sender);
    }

    @Override
    public void notifyUser(String message) {
        System.out.println("[Alta Prioridad]");
        sender.send(message);
    }
}
	// la otra clase
class LowPriorityNotification extends Notification {
    public LowPriorityNotification(NotificationSender sender) {
        super(sender);
    }

    @Override
    public void notifyUser(String message) {
        System.out.println("[Baja Prioridad]");
        sender.send(message);
    }
}
```

Ahora el main que sería el cliente : 

```java
public class BridgePatternExample {
    public static void main(String[] args) {
        // Crear un sender para correo y SMS
        NotificationSender emailSender = new EmailSender();
        NotificationSender smsSender = new SmsSender();

        // Crear notificaciones de alta y baja prioridad
        Notification highPriorityEmail = new HighPriorityNotification(emailSender);
        Notification lowPrioritySms = new LowPriorityNotification(smsSender);

        // Enviar notificaciones
        highPriorityEmail.notifyUser("¡Esto es crítico!");
        lowPrioritySms.notifyUser("Actualización general.");
    }
}
```

## Patrón composite:

Compone objetos en estructura de árbol para representar jerarquias de parte-todo. Permite que los clientes traten de manera uniforme a los objetos individuales y a los compuestos.

### Aplicabilidad:

- Se quiere representar jerarquias de objetos parte-todo
- Quiere que los clientes sean capaces de obviar las diferencias entre composiciones de objetos y los objetos individuales.

### Estructura:

![image.png](Concepto/src/Patrones%20de%20diseño/image%208.png)

### Participantes:

- **Componente:** Declara la interfaz de los objetos de la composición, implementa el comportamiento predeterminado de la interfaz, declara una interfaz para acceder a sus componentes hijos y gestionarlos y de forma opcional: define una interfaz para acceder al padre de in componente en la estructura recursiva, y si es necesario, la implementa
- **Hoja:** Representa objetos hoja en la composición, pues una hoja no tiene hijos. Define el comportamiento de los objetos primitivos de la composición.
- **Compuesto:** Define el comportamiento de los componentes que tienen hijos. Almacena componentes hijo
- **Cliente:** Manipula objetos en la composición a través de la interfaz Componente.

### Código:

Como código pondremos un restaurante, en la que cada combo tiene por dentro un producto, y los productos serian semejantes a las hojas. 

```java
public interface MenuComponent 
{
	double getPrice();
	void show();
}
```

Ahora necesitamos dos que hereden de el, dos minimo, pueden ser más claramente. 

```java
public class MenuItem implements MenuComponent
{
	private String name;
	private double price;
	
	
	public MenuItem(String name, double price) 
	{
		this.name = name;
		this.price = price;
	}
	
	@Override 
	public double getPrice()
	{
	return price;
	}
	
	
	@Override 
	public void show()
	{
		System.out.println(name + ": $"+price);
	}
}
```

```java
public class MenuComposite implements MenuComponent {
    private String name;
    private List<MenuComponent> components;

		public MenuComposite()
		{
			this.components = new ArrayList<>();
		}

    public MenuComposite(String name) {
        this.name = name;
    }

    public void add(MenuComponent component) {
        components.add(component);
    }

    public void remo
    ve(MenuComponent component) {
        components.remove(component);
    }

    @Override
    public double getPrice() {
        return components.stream()
                .mapToDouble(MenuComponent::getPrice)
                .sum();
    }

    @Override
    public void show() {
        System.out.println(name + " (Combo):");
        for (MenuComponent component : components) {
            component.show();
        }
        System.out.println("Total: $" + getPrice());
    }
}
```

Ahora vamos a usar el patrón composite en el main (cliente):

```java
public class RestaurantMenuExample {
    public static void main(String[] args) {
        // Platos individuales
        MenuComponent burger = new MenuItem("Burger", 5.99);
        MenuComponent fries = new MenuItem("Fries", 2.99);
        MenuComponent soda = new MenuItem("Soda", 1.99);

        // Combo 1
        MenuComposite combo1 = new MenuComposite("Combo 1");
        combo1.add(burger);
        combo1.add(fries);
        combo1.add(soda);

        // Combo 2 (Combo dentro de otro combo)
        MenuComposite combo2 = new MenuComposite("Combo 2");
        combo2.add(combo1);
        combo2.add(new MenuItem("Ice Cream", 3.49));

        // Mostrar combos
        System.out.println("Individual Items:");
        burger.show();
        fries.show();

        System.out.println("\nCombo 1:");
        combo1.show();

        System.out.println("\nCombo 2:");
        combo2.show();
    }
}

```

## Patrón decorator:

Asigna responsabilidades adicionales a un objeto dinámicamente, proporcionando una alternativa flexible a la herencia para extender la funcionalidad :D.

Wrapper (envoltorio)

### Aplicabilidad

- Para añadir objetos individuales de forma dinámica y transparente, es decir, sin afectar a otros objetos
- Para responsabilidades que puede ser retiradas
- Cuando la extensión mediante la herencia no es viable

### Estructura

![image.png](Concepto/src/Patrones%20de%20diseño/image%209.png)

### Participantes:

- **Componente:** Define la interfaz para objetos a los que puede añadir responsabilidades dinamicamente
- **Componente Concreto:**  Define un objeto al que se pueden añadir responsabilidades adicoinales.
- **Decorador:** Mantiene una rerferencia a un objeto Componente y define una interfaz que se ajusta a la interfaz del componente.
- **Decorador Concreto:** Añade responsabilidades al componente

### Código:

En el código vamos a crear la bebida o cafe, ya que a este se le pueden añadir muchas cosas, asi quedaría: 

Este es el componente base: 

```java
public interface Beverage 
{
	String getDescription();
	double getPrice();

}
```

La clase concreta: 

```java
public class Coffee implements Beverage {
    @Override
    public String getDescription() {
        return "Coffee";
    }

    @Override
    public double getPrice() {
        return 2.50; // Precio base
    }
}

public class Tea implements Beverage {
    @Override
    public String getDescription() {
        return "Tea";
    }

    @Override
    public double getPrice() {
        return 1.75; // Precio base
    }
}
```

Ahora vamos con el decorador: 

```java
public abstract class BeverageDecorator implements Beverage {
    protected Beverage beverage;

    public BeverageDecorator(Beverage beverage) {
        this.beverage = beverage;
    }

    @Override
    public String getDescription() {
        return beverage.getDescription();
    }

    @Override
    public double getPrice() {
        return beverage.getPrice();
    }
}
```

Ahora vamos con los decoradores: 

```java
public class MilkDecorator extends BeverageDecorator {
    public MilkDecorator(Beverage beverage) {
        super(beverage);
    }

    @Override
    public String getDescription() {
        return beverage.getDescription() + ", Milk";
    }

    @Override
    public double getPrice() {
        return beverage.getPrice() + 0.50;
    }
}

public class SugarDecorator extends BeverageDecorator {
    public SugarDecorator(Beverage beverage) {
        super(beverage);
    }

    @Override
    public String getDescription() {
        return beverage.getDescription() + ", Sugar";
    }

    @Override
    public double getPrice() {
        return beverage.getPrice() + 0.25;
    }
}

public class SyrupDecorator extends BeverageDecorator {
    public SyrupDecorator(Beverage beverage) {
        super(beverage);
    }

    @Override
    public String getDescription() {
        return beverage.getDescription() + ", Syrup";
    }

    @Override
    public double getPrice() {
        return beverage.getPrice() + 0.75;
    }
}
```

Ahora viene la parte del cliente

```java
public class CoffeeShop {
    public static void main(String[] args) {
        Beverage coffee = new Coffee(); // Bebida base
        coffee = new SugarDecorator(coffee); // Añadimos azúcar
        coffee = new MilkDecorator(coffee); // Añadimos leche

        System.out.println(coffee.getDescription() + " - $" + coffee.getPrice());
    }
}
```

## Patrón Proxy:

Proporciona un representante o sustituto de otro objeto para controlar el acceso a éste. Surrogate

### Aplicabilidad

Hay diferentes tipos de proxy, en los que al mismo tiempo se evalúa su aplicabilidad: 

- **Proxy Remoto:** Proporciona un representante local de un objeto situado en otro espacio de direcciones.
- **Proxy virtual:**  Crea objetos costosos por encargo
- **Proxy de protección:** Controla el acceso al objeto original. Los proxies de protección son útiles cuando los objetos deberían tener diferentes permisos de acceso.
- **Proxy referencia inteligente:** Es un sustituto de un simple puntero que lleva a cabo operaciones adicionales cuando se accede a un objeto. Tambien es conocido por punteros inteligentes.

### Estructura

![image.png](Concepto/src/Patrones%20de%20diseño/image%2010.png)

### Participantes

- **Proxy:**  Mantiene una referencia que permite al proxy acceder al objeto real. Proporciona una interfaz idéntica a la del sujeto, de manera que un proxy pueda ser sustituido por el sujeto real. Controla el acceso al sujeto real, y puede ser responsable de su creación y borrado. Otras responsabilidades depende del tipo de proxy:
    - *Proxy remoto:* Son responsables de codificar una petición y sus argumentos para enviar la petición codificada al sujeto real que se encuentra en un espacio de direcciones diferentes.
    - *Proxies virutales:* Pueden guardar información adicional sobre el sujeto real, por lo que pueden retardar el acceso al mismo.
    - *Proxies de protección:* Comprueban que el llamador tenga los permisos de acceso necesarios para realizar una petición.
- **Sujeto:** Define la interfaz común para el SujetoReal y el Proxy, de modo que pueda usarse un Proxy en cualquier sitio en el que se espere un SujetoReal.
- **SujetoReal:** Define el objeto real representado.

### Código

Primero haremos lo que es crear la interfaz de lo que deseamos: 

```java
public interface Image 
{
	void display();
}
```

Ahora crearemos el objeto real y su referencia: 

```java
public class RealImage implements Image {
    private String fileName;

    public RealImage(String fileName) {
        this.fileName = fileName;
        loadFromDisk(); // Carga la imagen al crearla
    }

    private void loadFromDisk() {
        System.out.println("Loading " + fileName + " from disk...");
    }

    @Override
    public void display() {
        System.out.println("Displaying " + fileName);
    }
}

////// 

public class ProxyImage implements Image {
    private String fileName;
    private RealImage realImage; // Referencia al objeto real

    public ProxyImage(String fileName) {
        this.fileName = fileName;
    }

    @Override
    public void display() {
        if (realImage == null) {
            realImage = new RealImage(fileName); // Carga perezosa
        }
        realImage.display(); // Delega la llamada al objeto real
    }
}
```

Y en el cliente: 

```java
public class Main {
    public static void main(String[] args) {
        Image image1 = new ProxyImage("photo1.jpg");
        Image image2 = new ProxyImage("photo2.jpg");

        // La primera vez que se muestra, se carga desde el disco
        System.out.println("Accessing image1...");
        image1.display();

        System.out.println("\nAccessing image2...");
        image2.display();

        // Si intentamos mostrar nuevamente, ya no se carga del disco
        System.out.println("\nAccessing image1 again...");
        image1.display();
    }
}
```

## Patrón Flyweight:

Usa compartimiento para permitir un gran numero de objetos de grano fino de forma eficiente. 

### Aplicabilidad

Se debería aplicar el patrón cuando se cumpla *TODO* lo siguiente: 

- Una aplicación utiliza un gran número de objetos
- Los costes de almacenamiento son elevados debido a la gran cantidad de objetos
- La mayor parte del estado del objeto puede hacerse extrínseco
- Muchos grupos de objetos pueden reemplazarse por relativamente pocos objetos compartidos, una vez que se ha eliminado el estado extrínseco.
- La aplicación no depende de la identidad de un objeto. Puesto que los objetos peso ligero pueden ser compartidos, las comprobaciones de identidad devolverán verdadero para objetos conceptualmente distintos.

### Estructura

![image.png](Concepto/src/Patrones%20de%20diseño/image%2011.png)

### Participantes

- **Peso Ligero:** Declara una interfaz a través de la cual los pesos ligeros pueden recibir un estado extrínseco y actuar sobre él.
- **Peso ligero concreto:** Implementa la interfaz de PesoLigero y permite almacenar el estado intrínseco, en caso de que lo haya. Un objeto PesoLigeroConcreto debe poder ser compoartido, por lo que cualquier estado que almacene debe ser intrínseco, esto es, debe ser independiente del contexto del objeto PesoLigeroConcreto
- **Peso Ligero No Compartido:** La interfaz de Peso Ligero permite el compartimiento, no fuerza a él. Los objetos PesoLigeroNoCompartido suelen tener objetos PesoLigeroConcreto como hijos en algún nivel de la estructura de objetos.
- **Fabrica de Pesos Ligeros:**  Crea y controla objetos peso ligeros, garantiza que los peso ligero se compartan de manera adecuada.
- **Cliente:** Mantiene una referencia a los pesos ligeros. Calcula o guarda el estado extrínseco de los pesos ligeros

### Código

```java
import java.util.HashMap;
import java.util.Map;

// Flyweight: Almacena los datos intrínsecos (compartidos)
class LibroFlyweight {
    private final String titulo;
    private final String autor;
    private final String genero;

    public LibroFlyweight(String titulo, String autor, String genero) {
        this.titulo = titulo;
        this.autor = autor;
        this.genero = genero;
    }

    public String getTitulo() {
        return titulo;
    }

    public String getAutor() {
        return autor;
    }

    public String getGenero() {
        return genero;
    }

    @Override
    public String toString() {
        return "LibroFlyweight{" +
                "titulo='" + titulo + '\'' +
                ", autor='" + autor + '\'' +
                ", genero='" + genero + '\'' +
                '}';
    }
}

// Contexto: Almacena los datos extrínsecos (únicos)
class Libro {
    private final LibroFlyweight libroFlyweight; // Datos compartidos
    private final int numeroCopia; // Dato único

    public Libro(LibroFlyweight libroFlyweight, int numeroCopia) {
        this.libroFlyweight = libroFlyweight;
        this.numeroCopia = numeroCopia;
    }

    public void mostrarInformacion() {
        System.out.println("Libro: " + libroFlyweight.getTitulo() +
                ", Autor: " + libroFlyweight.getAutor() +
                ", Género: " + libroFlyweight.getGenero() +
                ", Copia #" + numeroCopia);
    }
}

// Flyweight Factory: Gestiona la creación y reutilización de los Flyweights
class FabricaDeLibros {
    private final Map<String, LibroFlyweight> flyweights = new HashMap<>();

    public LibroFlyweight obtenerLibroFlyweight(String titulo, String autor, String genero) {
        String clave = titulo + "-" + autor + "-" + genero; // Clave única para identificar el Flyweight
        if (!flyweights.containsKey(clave)) {
            flyweights.put(clave, new LibroFlyweight(titulo, autor, genero));
        }
        return flyweights.get(clave);
    }

    public int getTotalFlyweights() {
        return flyweights.size();
    }
}

// Cliente
public class Main {
    public static void main(String[] args) {
        FabricaDeLibros fabrica = new FabricaDeLibros();

        // Crear libros compartiendo Flyweights
        Libro libro1 = new Libro(fabrica.obtenerLibroFlyweight("Cien años de soledad", "Gabriel García Márquez", "Novela"), 1);
        Libro libro2 = new Libro(fabrica.obtenerLibroFlyweight("Cien años de soledad", "Gabriel García Márquez", "Novela"), 2);
        Libro libro3 = new Libro(fabrica.obtenerLibroFlyweight("1984", "George Orwell", "Ciencia Ficción"), 1);

        // Mostrar información de los libros
        libro1.mostrarInformacion();
        libro2.mostrarInformacion();
        libro3.mostrarInformacion();

        // Mostrar el total de Flyweights creados
        System.out.println("Total de Flyweights creados: " + fabrica.getTotalFlyweights());
    }
}
```

## Patrón Facade:

Proporciona una interfaz unificada para un conjunto de interfaces de un subsistema. Define una interfaz de alto nivel que hace que el subsistema sea mas fácil de usar.

### Aplicabilidad

- Queremos proporcionar una interfaz simple para un subsistema complejo, por lo general sucede cuando se aplican muchos patrones, estos generan que haya demasiada personalización y un facade es lo mejor para usuarios que no necesitan tanto nivel de personalización.
- Queramos dividir en capas nuestros subsistemas. Se usa fachada para definir un punto de entrada en cada nivel del subsistema

### Estructura

![image.png](Concepto/src/Patrones%20de%20diseño/image%2012.png)

### Participantes

- **Fachada:** Sabe que clases del subsistema son las responsables ante una petición. Delega las peticiones de los clientes en los objetos apropiados del subsistema.
- **Clases del subsistema:** Estas implementan la funcionalidad del subsistema. Realizan las labores encomendadas por el objeto Fachada

### Código

```java
// Subsistemas
class Pedido {
    public void tomarPedido(String pizza) {
        System.out.println("Pedido tomado: " + pizza);
    }
}

class Cocina {
    public void prepararPizza(String pizza) {
        System.out.println("Preparando pizza: " + pizza);
    }

    public void cocinarPizza(String pizza) {
        System.out.println("Cocinando pizza: " + pizza);
    }
}

class Entrega {
    public void entregarPizza(String pizza) {
        System.out.println("Entregando pizza: " + pizza);
    }
}

// Fachada
class SistemaEntregaPizzaFacade {
    private Pedido pedido;
    private Cocina cocina;
    private Entrega entrega;

    public SistemaEntregaPizzaFacade() {
        this.pedido = new Pedido();
        this.cocina = new Cocina();
        this.entrega = new Entrega();
    }

    public void realizarPedido(String pizza) {
        System.out.println("Iniciando proceso de entrega...");
        pedido.tomarPedido(pizza);
        cocina.prepararPizza(pizza);
        cocina.cocinarPizza(pizza);
        entrega.entregarPizza(pizza);
        System.out.println("Pizza entregada con éxito.");
    }
}

// Cliente
public class Main {
    public static void main(String[] args) {
        // Usando la fachada para simplificar el proceso
        SistemaEntregaPizzaFacade facade = new SistemaEntregaPizzaFacade();
        facade.realizarPedido("Hawaiana");
    }
}
```

# Patrones de comportamiento:

Los patrones de comportamiento tiene que ver con algoritmos y con la asignación de responsabilidades  a objetos. Describe tambien patrones de comunicación entre las clases y los objetos. 

## Chain of Responsability ( Cadena de responsabilidades)

Evita acoplar el emisor con una petición a su receptor, dando a mas de un objeto poder responder esa petición, como si fuera un montón de if pero intercalando las clases. 

### Aplicabilidad:

Usar el patrón de Chain of responsability cuando:

- Hay más de un objeto que puede manejar una petición, y el maneador no se conoce a priori, si no que debería determinarse automáticamente
- Se quiere enviar una petición a un objeto entre varios sin especificar explícitamente el receptor
- El conjunto de objetos que pueden tratar una petición debería ser especificado dinámicamente

### Estructura:

![image.png](Concepto/src/Patrones%20de%20diseño/image%2013.png)

La cula podria verse tambien:

![image.png](Concepto/src/Patrones%20de%20diseño/image%2014.png)

### Participantes:

- **Manejador:** Define la interfaz para tratar las peticiones, [opcional] implementa los enlaces al sucesor
- **Manejador-concreto:**  Trata las peticiones de las que es responsable; puede acceder a su sucesor; si el manejador concreto puede manejar la petición lo hace si no, lo pasa a su sucesor
- **Cliente:** Inicializa la petición a un objeto ManejadorConcreto de la cadena.

### Codigo

![Imagen de WhatsApp 2025-01-28 a las 13.16.05_489cfc12.jpg](Imagen_de_WhatsApp_2025-01-28_a_las_13.16.05_489cfc12.jpg)

```java
// Una parte del codigo luciría de esta forma: 

public abstract class Aprobador 
{
	protected Aprobador sucesor;
	
	public void setSucesor(Aprobador sucesor){
		this.sucesor = sucesor;
	}
	public abstract void atenderSolicitud(int monto);
	public Aprobador getSucesor()
	{
		return sucesor;
	}
}

// Luego de Hacer la clase abstracta harémos dos clases que son concretas
public class Banco extends Aprobador {
	@Override
	public void atenderSolicitud(int monto)
	{
		if(monto > 10000)
		{
			System.out.print("haz algo");
		}
		else if(sucesor != null)
		{
			sucesor.atenderSolicitur(amount);
		}
	}
}

// Otra clase: 
public class EjecutivoCuenta extends Aprobador {
	@Override
	public void atenderSolicitud(int monto)
	{
		if(monto < 5000)
		{
			System.out.print("haz algo");
		}
		else if(sucesor != null)
		{
			sucesor.atenderSolicitur(amount);
		}
	}
}

// Otra clase: 
public class Gerente extends Aprobador {
	@Override
	public void atenderSolicitud(int monto)
	{
		if(monto < 10000 && monto > 5000)
		{
			System.out.print("haz algo");
		}
		else if(sucesor != null)
		{
			System.out.print("Ya ni modo" );
		}
	}
}

// Y ahora el main: 

public class ChainOfResponsibilityExample {
    public static void main(String[] args) {
        // Crear manejadores
        Approver banco= new Banco();
        Approver gerente= new Gerente();
        Approver ejecutivo= new EjecutivoCuenta();
        
        banco.setSucesor(gerente);
        gerente.setSucesor(ejectuvito);
        
        
        banco.atenderSolicitur(10005); // lo atiende el banco
        banco.atenderSolicitud(8500); // lo atiende el ejecutivo
        banco.atenderSolicitud(2000); // lo atiende el gerente
    }
}

```

## Command:

Encapsula una petición en un objeto, permitiendo así parametrizar a los clientes con diferentes peticiones, hacer cola o llevar un registro de las peticiones. 

### Aplicabilidad:

Use el patron command cuando se quiera: 

- Parametrizar objetos con una acción a realizar, los objetos Command son una alternativa orientada a objetos de las funciones callback
- Especificar, poner en cola y ejecutar peticiones en diferentes instantes
de tiempo
- estructurar un sistema alrededor de operaciones de alto nivel construidas sobre operaciones básicas. Dicha estructura es común en los sistemas de información que permiten **transacciones**

### Estructura:

![image.png](Concepto/src/Patrones%20de%20diseño/image%2015.png)

### Participantes:

- **Orden:** Declara una interfaz para ejecutar una operación
- **Orden Concreta:**  Define un enlace para un objeto receptor y una acción
- **Cliente:** Crea un objeto OrdenConcreta y establece su receptor
- **Invocador:**  Le pude a la orden que ejecute la petición.
- **Receptor:** Sabe como llevar a cabo las operaciones asociadas a una petición

### Código:

```java
// creamos primero la interfaz de comando: // que seria Orden
public interface Comando{
	
	public void ejecutar();
}

// Ahora haremos las ordenes concretas: 
public class ComandoApagarLuz implements Comando {
	private Luz luz;
	
	public ComandoApagarLuz(Luz luz)
	{
		this.luz = luz;
	}
	
	@Override
	public void ejectuar()
	{
		luz.apagar();
	}

}

public class ComandoPrenderLuz implements Comando {
	private Luz luz;
	
	public ComandoPrenderLuz (Luz luz)
	{
		this.luz = luz;
	}
	
	@Override
	public void ejectuar()
	{
		luz.encender();
	}
}

// Ahora vamos a hacer al invocador y al receptor: 
// En este caso receptor es luz: 

public class Luz 
{
	public Estado objEstado ; 
	
		public Estado encender()
		{
			objEstado.estado = "luz Encendida";
			return objEstado;
		}
		public Estado apagar()
		{
			objEstado.estado = "luz apagada";
			return objEstado;
		}
}

// y en el caso del invocador seria un control :

public class ControlRemoto {

	private	Comando comando;
	
	public ControlRemoto (){}
	
	public void asignarComando(Comando comando)
	{
		this.comando = comando;	
	}
	
	public void botonPresionado()
	{
		comando.ejecutar();
	}
}

// El apartado del main se vería algo de esta forma

public class TestRemoto
{
	
	public static void main(String... args) 
	{
		ControlRemoto control = new ControlRemoto();
		Luz luz = new Luz();
		
		ComandoEncenderLuz luzEncendida = new ComandoEncenderLuz(Luz);
		ComandoApagarLuz luzApagada= new ComandoApagarLuz (Luz);
		
		control.asignarComando(luzEncendida);
		control.botonPrecionado();
		control.asignarComando(luzApagada);
		control.botonPrecionado();		
	}

}
```

## Iterator:

Proporciona un modo de acceder secuencialmente a los elementos de un
objeto agregado sin exponer su representación interna.

### Aplicabilidad:

Úsese el patrón iterador cuando:

- Para acceder al contenido de un objeto agregado sin exponer su representación interna
- Para permitir varios recorridos sobre objetos agregados
- Para proporcionar una interfaz uniforme para recorrer diferentes estructuras agregadas.

### Estructura: x

![image.png](Concepto/src/Patrones%20de%20diseño/image%2016.png)

### Participantes:

- **Iterador:** Define una interfaz para recorrer los elementos y acceder a ellos
- **Iterador Concreto:** Implementa la interfaz Iterador.
- **Agregado:** Define una interfaz para crear un objeto Iterador.
- **Agregado Concreto:**  Implementa la interfaz de creación de iterador para devolver una instancia del iterador concreto apropiado.

### Código:

```java
// Primeor crearemos ambas interfaces: 

public interface Agregado 
{
	Iterador crearIterador();
	// Aqui irian demás metodos que tienen que ver con el agregado
}

public interface Iterador
{
	void primero();
	void siguiente();
	boolean haTerminado();
	Object elementoActual();
}

// Ahora creamos los concretos

public AgregarPila implements Agregado 
{

	@Override
	public Iterador crearIterador()
	{
		return new IteradorPila(this); // Que basicamente es agregar un iterador concreto
	}

	//...
}

public IteradorPila implements Iterador
{
	
	private final Agregado agragado;
	private int acutal;
	
	public InteradorPila(Agregado agregado)
	{
		this.agregado = agregado; 
		//logica del actual
	}
	
	
	// resto de la logica de la implementación
		
}

// Aqui lo importante es tambien el main: 

public class Clase {

    public static void main(String[] args) {

        // Ya teniendo el ejemplo podemos hacer une ejemplo con un Hotel.
        // podemos realizar validaciones con el tipo haciendo la lista de tipo generico
        Persona persona1 = new Persona("Luis", "120055412", 15);
        Persona persona2 = new Persona("Juan", "2343434", 25);
        Persona persona3 = new Persona("Melo", "1222221", 55);

        Hotel hotelMaz = new Hotel();
        hotelMaz.addReserva(new Reserva(persona1, 0));
        hotelMaz.addReserva(new Reserva(persona2, 10));
        hotelMaz.addReserva(new Reserva(persona3, 20));

        var listaReservas = hotelMaz.getReservas();

        Iterator<Reserva> it = listaReservas.crearIterador();

        while (!it.haTerminado()) {
            Reserva elemReserva = it.elementoActual();
            System.out.println(elemReserva.getidHabitacion() + " - " + 
            elemReserva.getPersona().getName());
            it.siguiente();
        }

    }

}

```

## Mediador:

Define un objeto que encapsula cómo interactúan una serie de objetos.

### Aplicabilidad:

Usar el patron Mediador cuando: 

- Un conjunto de objetos se comunican de forma bien definida pero compleja
- Es dificil reutilizar un objeto ya que este se refiere a muchos otros objetos
- Un comportamiento que está distribuido entre varias clases debería
poder ser adaptado sin necesidad de una gran cantidad de subclases

### Estructura:

![image.png](Concepto/src/Patrones%20de%20diseño/image%2017.png)

### Participantes

- **Mediador:**  Define una interfaz para comunicarse con sus objetos Colega.
- **MediadorConcreto:** implemente el comportamiento cooperativo coordinando objetos Colega; Tambien conoce a los colegas.
- **Clases Colega:** Cada uno de las clases colega conoce a su objeto mediador; Cada colega se comunica con su mediador

### Código:

```java
// Entonces la sala del chat entra como un mediador : 
interface ChatMediator {
    void sendMessage(String message, User sender);
    void addUser(User user);
}

// Implementación concreta del Mediador
class ChatMediatorImpl implements ChatMediator {
    private List<User> users = new ArrayList<>();

    @Override
    public void addUser(User user) {
        users.add(user);
    }

    @Override
    public void sendMessage(String message, User sender) {
        for (User user : users) {
            if (user != sender) { // No enviarse el mensaje a sí mismo
                user.receiveMessage(message);
            }
        }
    }
}

// Ahora creamos la clase colega: 
abstract class User {
    protected ChatMediator mediator;
    protected String name;

    public User(ChatMediator mediator, String name) {
        this.mediator = mediator;
        this.name = name;
    }

    public abstract void sendMessage(String message);
    public abstract void receiveMessage(String message);
}

class ConcreteUser extends User {
    public ConcreteUser(ChatMediator mediator, String name) {
        super(mediator, name);
    }

    @Override
    public void sendMessage(String message) {
        System.out.println(name + " envía: " + message);
        mediator.sendMessage(message, this);
    }

    @Override
    public void receiveMessage(String message) {
        System.out.println(name + " recibe: " + message);
    }
}

// La clase princiapl se veria algo como: 

public class MediatorPatternExample {
    public static void main(String[] args) {
        ChatMediator chat = new ChatMediatorImpl();

        User user1 = new ConcreteUser(chat, "Alice");
        User user2 = new ConcreteUser(chat, "Bob");
        User user3 = new ConcreteUser(chat, "Charlie");

        chat.addUser(user1);
        chat.addUser(user2);
        chat.addUser(user3);

        user1.sendMessage("¡Hola a todos!");
    }
}
```

## Memento

Representa y externaliza el estado interno de un objeto sin violar, la
encapsulación, de forma que éste puede volver a dicho estado más tarde.

### Aplicabilidad

Úsese el memento  cuando : 

- Hay que guardar  una instantánea del estado de un objeto para que pueda volver posteriormente a un estado

### Estructura:

![image.png](Concepto/src/Patrones%20de%20diseño/image%2018.png)

### Participantes:

- **Memento:** Guarda el estado interno del objeto Originador. Guarda tanta información como sea necesario; protege el acceso de otros objetos que no sea el creador.
- **Originador:** Crea un memento que contiene una instantanea de su estado actual; usa el memento para voler al estado anterior.
- **Conserje:** Es responsable de guardar en un lugar seguro el memento.

### Código:

```java
// vamos a crear primero el memento: 
public class Memento 
{
	private String estado; // esto es lo que guardaremos: 
	
	public Memento(String estado)
	{
		this.estado = estado;
	}
	
	public String getSavedState()
	{
		return estado;
	}
}

//Ahora la clase persona que es la que usa el memento, sería en nuestro caso Originador

public class Persona {

	private String nombre; 
	
	public Memento saveMemento() {
		System.out.println("Originador: Guardando Memento");
		return new Memento(nombre);
	}
	
	public void restoreOfMemento(Memento m)
	{
		nombre = m.getSavedState();
	}
	
	public String getNombre()
	{
		return nombre;
	}
	public void setNombre(String nombre)
	{
		this.nombre = nomrbe;
	}

}

// Ahora vamos a Crear la clase del conserje en este caso se llamara CareTaker como cuidador

public class CreateTaker
{
	private List<Memento> estados = new ArrayList<>();
	
	public void addMemento(Memento m)
	{
		estados.add(m);
	}
	public Memento getMemento(int index)
	{
		return estados.get(index);
	}
}

// De esta forma nosotros podemos Guardar en el main :

public class TestMemento {

	public static void main(String... args)
	{
			CareTaker caretaker = new CareTaker();
			
			Persona p = new Peronsa();
			p.setNombre("juan");
			p.setNombre("maxi");
			
			createtaker.addMemento(p.saveToMemento()); // y aqui estamos guardando a maxi
			
			p.setNombre("luna");
			
			Memento m1 = caretaker.getMemento(0);
			
			System.out.println(m1.getSavedState()); // aqui dira maxi
			System.out.println(p.getNombre()); // aqui dira luna xdd
			p.restoreOfMemento(m1);
			System.out.println(p.getNombre()); // aqui dira maxi	
	}
}
```

## Observer

Define una dependencia de uno-a-muchos entre objetos, de forma que cuando un
objeto cambie de estado se notifique y se actualicen automáticamente todos los
objetos que dependen de él.

### Aplicabilidad:

Úsese el patrón observer en cualquiera de las siguientes situaciones:

- Cuando una abstracción tiene dos aspectos y uno depende del otro.
Encapsular estos aspectos en objetos separados permite modificarlos y
reutilizarlos de forma independiente.
- Cuando un cambio en un objeto requiere cambiar otros, y no sabemos
cuántos objetos necesitan cambiarse
- Cuando un objeto debería ser capaz de notificar a otros sin hacer
suposiciones sobre quiénes son dichos objetos. En otras palabras, cuando
no queremos que estos objetos estén fuertemente acoplados.

### Estructura:

![image.png](Concepto/src/Patrones%20de%20diseño/image%2019.png)

### Participantes:

- **Sujeto:** Conoce a sus observadores. Un sujeto puede ser observado por varios Observadores; proporciona una interfaz para asignar y quitar objetos Observador
- **Observador:** define una interfaz para actualizar los objetos que deben ser
notificados ante cambios en un sujeto.
- **SujetoConcreto: A**lmacena el estado de interés para los objetos
ObservadorConcreto; envia una notifiación a sus observadores cuando cambia el estado.
- **ObservadorConcreto:** Mantiene una referencia a un objeto SujetoConcreto; guarda un estado que debería ser consistente con el del sujeto.

### Código:

```java
// Primero tenemos una interfaz  de sujeto: 
public interface Channel {
		void subscribe(Subscriber subscriber);
    void unsubscribe(Subscriber subscriber);
    void notifySubscribers(String videoTitle);
}

// Implementación del Canal de YouTube
class YouTubeChannel implements Channel {
    private List<Subscriber> subscribers = new ArrayList<>();
    private String name;

    public YouTubeChannel(String name) {
        this.name = name;
    }

    @Override
    public void subscribe(Subscriber subscriber) {
        subscribers.add(subscriber);
    }

    @Override
    public void unsubscribe(Subscriber subscriber) {
        subscribers.remove(subscriber);
    }

    @Override
    public void notifySubscribers(String videoTitle) {
        System.out.println(name + " ha subido un nuevo video: " + videoTitle);
        for (Subscriber s : subscribers) {
            s.update(videoTitle);
        }
    }
}

// Aqui implementamos el observable: 
interface Subscriber {
    void update(String videoTitle);
}

// Implementación de Suscriptor
class YouTubeUser implements Subscriber {
    private String name;

    public YouTubeUser(String name) {
        this.name = name;
    }

    @Override
    public void update(String videoTitle) {
        System.out.println("📺 " + name + " ha recibido la notificación del video: " 
        + videoTitle);
    }
}

// El test: 

public class ObserverPatternExample {
    public static void main(String[] args) {
        YouTubeChannel channel = new YouTubeChannel("TechWorld");

        Subscriber user1 = new YouTubeUser("Alice");
        Subscriber user2 = new YouTubeUser("Bob");
        Subscriber user3 = new YouTubeUser("Charlie");

        channel.subscribe(user1);
        channel.subscribe(user2);
        channel.subscribe(user3);

        channel.notifySubscribers("Patrón Observer en Java");
    }
}
```

## Template Method

Define en una operación el esqueleto de un algoritmo, delegando en las subclases algunos de sus pasos. Permite que las subclases redefinan ciertos pasos de un algoritmo sin cambiar su estructura.

### Aplicabilidad.

El patrón Template method debería usarse:

- Cuando el comportamiento repetido de varias subclases debería
factorizarse y ser localizado en una clase común para evitar el código
duplicado
- Para implementar las partes de un algoritmo que no cambian y dejar
que sean las subclases quienes implementen el comportamiento que
puede variar

### Estructura:

![image.png](Concepto/src/Patrones%20de%20diseño/image%2020.png)

### Participantes

- **Clase abstracta:** Define operaciones primitivas abstractas que son definidas por subclases para implementar los pasos de un algoritmo
- **Clase concreta:** Implementa las operaciones primitivas para implementar los algoritmos

### Código:

```java
// vamos con la clase abstracta : 
public abstract class Automovil {

	protected int velocidad;
	protected int factor;
	
	public Automovil(int factor)
	{
		this.factor = factor;
	}
	
	final public void desplazar()
	{
		acelerar();
		cambiarMarcha();
		frenar();
	}
	
	private void acelerar(){
		velocidad = velocidad + factor;
	}
	private void frenar(){
		velocidad = 0;
	}
	
	protected abstract void cambiarMarcha();
}

// ahora las clases concretas: 

public class AutomovilManual extends Automovil 
{

	public AutomovilManual(int factor)
	{
		super(factor);
	}
	
	@Override
	protected void cambiarMarcha(){
		// combustion....
	}
}

public class AutomovilAutomatico extends Automovil 
{

	public AutomovilAutomatico (int factor)
	{
		super(factor);
	}
	
	@Override
	protected void cambiarMarcha(){
		// generar relacion potencia/velocidad
	}
}

// El main: 

public class Main {
    public static void main(String[] args) {
        // Creamos un automóvil manual y automático
        Automovil autoManual = new AutomovilManual(10);
        Automovil autoAutomatico = new AutomovilAutomatico(15);

        System.out.println("Automóvil Manual en movimiento:");
        autoManual.desplazar();
        
        System.out.println("\nAutomóvil Automático en movimiento:");
        autoAutomatico.desplazar();
    }
}
```

```java
// codigo numero dos que es mas aplicable: 
// Clase base con el Template Method
abstract class Authenticator {
    public final void authenticate(String user, String password) {
        if (validateCredentials(user, password)) {
            System.out.println("Autenticación exitosa para " + user);
        } else {
            System.out.println("Fallo en la autenticación para " + user);
        }
    }

    // Método abstracto que cambia según la fuente de datos
    abstract boolean validateCredentials(String user, String password);
}

// Subclase: Autenticación desde Base de Datos
class DatabaseAuthenticator extends Authenticator {
    @Override
    boolean validateCredentials(String user, String password) {
        System.out.println("Verificando usuario en la base de datos...");
        return "admin".equals(user) && "1234".equals(password);
    }
}

// Subclase: Autenticación desde API
class ApiAuthenticator extends Authenticator {
    @Override
    boolean validateCredentials(String user, String password) {
        System.out.println("Consultando credenciales en API...");
        return "user".equals(user) && "pass".equals(password);
    }
}

// Prueba del Patrón Template Method
public class TemplateMethodAuthExample {
    public static void main(String[] args) {
        Authenticator dbAuth = new DatabaseAuthenticator();
        Authenticator apiAuth = new ApiAuthenticator();

        System.out.println("Autenticando con Base de Datos:");
        dbAuth.authenticate("admin", "1234");

        System.out.println("\nAutenticando con API:");
        apiAuth.authenticate("user", "pass");
    }
}

```

## Strategy:

El patrón estrategia define una familia de algoritmos, encapsula cad auno de ellos y los hace intercambiables. Permite que un algoritmo varie independientemente de los clientes que lo usan. 

Tambien conocido como Policy

### Aplicabilidad:

Úsese el patrón Strategy cuando: 

- Muchas clases relacionadas difieren solo en su comportamiento . Las estrategias permiten configurar una clase con n determinado comportamiento de entre muchos posibles.
- Se necesitan distintas variantes de un algoritmo
- Un algoritmo usa datos que los clientes no deben conocer
- Una clase define muchos comportamientos, y éstos se representan
como múltiples sentencias condicionales en sus operaciones. En vez
de tener muchos condicionales, podemos mover las ramas de éstos a
su propia clase Estrategia.

### Estructura:

![image.png](Concepto/src/Patrones%20de%20diseño/image%2021.png)

### Participantes:

- **Estrategia:** Declara una interfaz común a los algoritmos permitidos
- **Estrategia Concreta:** Implementa el algoritmos usando la estrategia concreta
- **Contexto:** Se configura con objeto de EstrategiaConcreta; mantiene una referncia a un objeto Estrategia; puede crear una interfaz que permita a estrategia ingresar a sus datos .

### Código

```java
// Entonces vamos a ver un ejemplo de etrategia: 

// Interfaz Estrategia
interface PaymentStrategy {
    void pay(int amount);
}

// Estrategias concretas
class CreditCardPayment implements PaymentStrategy {
    private String cardNumber;

    public CreditCardPayment(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    @Override
    public void pay(int amount) {
        System.out.println("💳 Pagando $" + amount + " con tarjeta de crédito: " + cardNumber);
    }
}

class PayPalPayment implements PaymentStrategy {
    private String email;

    public PayPalPayment(String email) {
        this.email = email;
    }

    @Override
    public void pay(int amount) {
        System.out.println("📧 Pagando $" + amount + " con PayPal: " + email);
    }
}

class CryptoPayment implements PaymentStrategy {
    private String walletAddress;

    public CryptoPayment(String walletAddress) {
        this.walletAddress = walletAddress;
    }

    @Override
    public void pay(int amount) {
        System.out.println("🔗 Pagando $" + amount + " con criptomonedas: " + walletAddress);
    }
}

// Contexto que usa una estrategia de pago
class ShoppingCart {
    private PaymentStrategy paymentStrategy;

    public void setPaymentStrategy(PaymentStrategy paymentStrategy) {
        this.paymentStrategy = paymentStrategy;
    }

    public void checkout(int amount) {
        if (paymentStrategy == null) {
            System.out.println("⚠️ Selecciona un método de pago antes de proceder.");
        } else {
            paymentStrategy.pay(amount);
        }
    }
}

// Prueba del Patrón Strategy
public class StrategyPatternExample {
    public static void main(String[] args) {
        ShoppingCart cart = new ShoppingCart();

        // Cliente elige pagar con tarjeta de crédito
        cart.setPaymentStrategy(new CreditCardPayment("1234-5678-9876-5432"));
        cart.checkout(250);

        // Cliente cambia a PayPal
        cart.setPaymentStrategy(new PayPalPayment("usuario@email.com"));
        cart.checkout(100);

        // Cliente cambia a criptomonedas
        cart.setPaymentStrategy(new CryptoPayment("0xABC123XYZ789"));
        cart.checkout(500);
    }
}

```

# Otros patrones de diseño:

## Pipeline:

Permite procesar los datos en una serie de etapas, introduciendo una entrada inicial y pasando la salida procesada para que la utilicen las etapas siguientes.

### Explicación:

El patrón Pipeline utiliza etapas ordenadas para procesar una secuencia de valores de entrada. Cada tarea implementada está representada por una etapa de la tubería. Puede pensar en las canalizaciones como algo similar a las líneas de ensamblaje de una fábrica, donde cada elemento de la línea de ensamblaje se construye por etapas. El artículo parcialmente ensamblado pasa de una etapa de ensamblaje a otra. Las salidas de la cadena de montaje se producen en el mismo orden que las entradas.

### Código:

```java
// Creamos la clase: 
interface Handler<I, O> {
  O process(I input);
}
// Aqui extendemos a 3 hanlders diferentes: 
class RemoveAlphabetsHandler implements Handler<String, String> {
  ...
}

class RemoveDigitsHandler implements Handler<String, String> {
  ...
}

class ConvertToCharArrayHandler implements Handler<String, char[]> {
  ...
}

// Aquí esta el pipeline que recogerá y ejecutara uno a uno: 
class Pipeline<I, O> {

  private final Handler<I, O> currentHandler;

  Pipeline(Handler<I, O> currentHandler) {
    this.currentHandler = currentHandler;
  }

  <K> Pipeline<I, K> addHandler(Handler<O, K> newHandler) {
    return new Pipeline<>(input -> newHandler.process(currentHandler.process(input)));
  }

  O execute(I input) {
    return currentHandler.process(input);
  }
}

// Y el pipeline en proceso: 

 var filters = new Pipeline<>(new RemoveAlphabetsHandler())
        .addHandler(new RemoveDigitsHandler())
        .addHandler(new ConvertToCharArrayHandler());
    filters.execute("GoYankees123!");

```

***

## CQRS
https://www.youtube.com/watch?v=7W4lyeZcZ1w
### Aplicabilidad:
### Estrucura:
### Participantes:
### Código: 

## Transactional Outbox

Es un mecanismo para catualizar la base de datos y le agrega valor ya que asegura la confiabilidad y eficiencia de esa actualización. Es decir, la data que estamos leyendo y escribiendo es efectivamente la que estamos buscando y en el menor tiempo posible. Entonces, se actualiza la base de datos y se envian eventos a esa misma transacción. Esta no requiere del protocolo 2PC -> (Commit de dos fases), es decir, no necesita que un emisor y un receptor confirmen un evento entre recibido y publicado.
El link que vamos a seguir para esta descripción será: 
https://medium.com/@syedharismasood4/building-reliable-microservices-with-the-transactional-outbox-pattern-in-spring-boot-952d96f8b534

Este está hecho en Spring Boot, pero encontraremos otra para Python.

Aquí integraremos RabbitMQ para el proceso y una base de datos en PostgreSQL.

Otras referencias posibles: 
- https://www.decodable.co/blog/revisiting-the-outbox-pattern

### Aplicabilidad:

Describe la salida de mensajes o eventos desde un componente hacia el exterior garantizando consistencia transaccional entre la operación local y la publicación de mensajes. Se usa cuando un componente persiste datos y debe publicar eventos de forma fiable. (Por ejemplo: event sourcing, microservicios, cola de eventos).
### Estrucura:
1. Entidad principal / Agregado
2. Tabla / Estructura de outbox que guarda eventos a publicar
3. Transaccipón átomica: persistencia + registro en outbox
4. Dispatcher / Publicador que: 
	1. Lee eventos pendientes
	2. Publica a cola/event bus
	3. Marca como publicados
### Participantes:

|Rol|Descripción|
|---|---|
|**Componente de dominio**|Genera eventos por cambios en estado|
|**Outbox Store**|Almacena eventos dentro de la misma transacción de la operación de negocio|
|**Publicador/Dispatcher**|Lee de outbox y envía a sistemas externos (Kafka, Rabbit, etc.)|

### Código: 
#### Spring boot: 
La estructura de carpetas que usaremos será la siguiente: 
![Pasted image 20251230150840.png](images/Pasted%20image%2020251230150840.png)
Esta es algo simple y sencillo. Lo importante es las dos entidades que tenemos: Outbox y User.
Cómo primeras configuraciones tendremos: 
**application.yaml**
```yml title=application.yaml
spring:  
  application:  
    name: obx  
  
  
  datasource:  
    username: postgres  
    password: 1234  
    url: jdbc:postgresql://localhost:5432/outboxdb  
  jpa:  
    hibernate:  
      ddl-auto: create  
  
  rabbitmq:  
    host: localhost  
    port: 5672  
    username: guest  
    password: guest
```

**main**
```java title:ObxApplication.java
package pattern.obx;  
  
import org.springframework.boot.SpringApplication;  
import org.springframework.boot.autoconfigure.SpringBootApplication;  
import org.springframework.scheduling.annotation.EnableScheduling;  
  
@SpringBootApplication  
@EnableScheduling  
public class ObxApplication {  
  
    public static void main(String[] args) {  
       SpringApplication.run(ObxApplication.class, args);  
    }  
  
}
```

**RabbitMQ Configuración**
```java title=RabbitMQConfig.java
package pattern.obx.configuration;  
  
import org.springframework.amqp.core.DirectExchange;  
import org.springframework.context.annotation.Bean;  
import org.springframework.context.annotation.Configuration;  
  
@Configuration  
public class RabbitMQConfig {  
  
    @Bean  
    public DirectExchange direct(){  
        return new DirectExchange("outbox");  
    }  
}
```

**Enum Aggregate**

```java title=Aggregate.java
package pattern.obx.enm;  
  
public enum Aggregate {  
    USER  
}
```

**Gradle**
```yml
plugins {  
    id 'java'  
    id 'org.springframework.boot' version '4.0.1'  
    id 'io.spring.dependency-management' version '1.1.7'  
}  
  
group = 'pattern'  
version = '0.0.1-SNAPSHOT'  
description = 'Estudio del patron outbox'  
  
java {  
    toolchain {  
        languageVersion = JavaLanguageVersion.of(21)  
    }  
}  
  
repositories {  
    mavenCentral()  
}  
  
dependencies {  
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'  
    implementation 'org.springframework.boot:spring-boot-starter-webmvc'  
    implementation 'jakarta.validation:jakarta.validation-api:3.1.1'  
    implementation 'org.springframework.boot:spring-boot-starter-amqp'  
    implementation 'org.springframework.boot:spring-boot-starter-validation'  
  
    compileOnly 'org.projectlombok:lombok'  
    annotationProcessor 'org.projectlombok:lombok'  
  
    testCompileOnly 'org.projectlombok:lombok'  
    testAnnotationProcessor 'org.projectlombok:lombok'  
  
    runtimeOnly 'org.postgresql:postgresql'  
  
    testImplementation 'org.springframework.boot:spring-boot-starter-data-jpa-test'  
    testImplementation 'org.springframework.boot:spring-boot-starter-webmvc-test'  
    testRuntimeOnly 'org.junit.platform:junit-platform-launcher'  
}  
  
  
tasks.named('test') {  
    useJUnitPlatform()  
}
```

Ahora entrando en las entidades: 

```java title=User.java
@Entity  
@Table(name = "users")  
@Data  
@EntityListeners(AuditingEntityListener.class)  
public class User {  
    @Id  
    @GeneratedValue(strategy = GenerationType.IDENTITY)  
    @Column(name = "id", nullable = false)  
    private Long id;  
  
    @Column(name = "firstname", nullable = false, length = 45)  
    private String firstname;  
    @Column(name = "lastname", length = 45)  
    private String lastname;  
    @Column(name = "dob", nullable = false)  
    private LocalDate dob;  
    @Column(name = "address", nullable = true, length = 100)  
    private String address;  
    @Column(name = "email", nullable = false, unique = true)  
    private String email;  
    @CreatedDate  
    @Column(name = "created_date")  
    private LocalDateTime createdDate;  
    @LastModifiedDate  
    @Column(name = "last_modified_date")  
    private LocalDateTime lastModifiedDate;  
  
    // todo, maybe pueda ir a un enum.  
    private static final String USER_AGREGATE = "USER";  
  
    public User(String firstname, String lastname, LocalDate dob, String address, String email) {  
        this.firstname = firstname;  
        this.lastname = lastname;  
        this.dob = dob;  
        this.address = address;  
        this.email = email;  
    }  
  
    public User() {  
  
    }  
}
```

**Outbox Entity**

```java title=Outbox.java
@Entity  
@Data  
@NoArgsConstructor  
@EntityListeners(AuditingEntityListener.class)  
public class Outbox {  
    @Id  
    @GeneratedValue(strategy = GenerationType.IDENTITY)  
    @Column(name = "id", nullable = false)  
    private Long id;  
  
    @Enumerated(EnumType.STRING)  
    @Column(name = "aggregate")  
    private Aggregate aggregate;  
    @Column(name = "message", length = 500)  
    private String message;  
    @Column(name = "is_delivered", nullable = false)  
    private Boolean isDelivered = false;  
    @CreatedDate  
    @Column(name = "created_date")  
    private LocalDateTime createdDate;  
    @LastModifiedDate  
    @Column(name = "last_modified_date")  
    private LocalDateTime lastModifiedDate;  
  
    public Outbox(Aggregate aggregate, String message, Boolean isDelivered) {  
        this.aggregate = aggregate;  
        this.message = message;  
        this.isDelivered = isDelivered;  
    }  
  
}
```

Los repositorios: 
```java
@Repository  
public interface OutboxRepository extends JpaRepository<Outbox, Long> {  
    // Este es para crear el trabajo  
    List<Outbox> findTop10ByIsDelivered(boolean status);  
}

//

@Repository  
public interface UserRepository extends JpaRepository<User, Long> {  
}
```

El servicio es la parte en donde SOLO ponemos el outbox, hagamos la comparación. La forma que NO se debería hacer:
Esto es debido a que hacemos más de una operación que depende de que la primera se haga bien, y si en algún punto falla ... no se puede retroceder o, es complicado hacerlo.
```java title=NoHacer
@Transactional  
    public User createUser(UserRequestDto userRequestDto) {  
        User user = userRequestDtoMapper.mapToUserEntity(userRequestDto);  
  
        user = userRepository.save(user); // Write to the database  
  
        kafkaTemplate.send(topic, user); // Write to the message queue  
  
        return user;  
    }
```

La mejor forma es solo usando el servicio que se quiere: 
```java title=UserService.java
@Service  
public class UserService {  
  
    private final UserRepository userRepository;  
    private final OutboxRepository outboxRepository;  
    private final UserRequestDtoMapper userRequestDtoMapper;  
    private final UserMapper userMapper;  
  
    public UserService(UserRepository userRepository, OutboxRepository outboxRepository,  
                       UserRequestDtoMapper userRequestDtoMapper, UserMapper userMapper) {  
        this.userRepository = userRepository;  
        this.outboxRepository = outboxRepository;  
        this.userRequestDtoMapper = userRequestDtoMapper;  
        this.userMapper = userMapper;  
    }  
  
    // aqui usamos el method que es con unchecked, por lo que  
    // si falla automaticamente hace el rollback    @Transactional  
    public User createUser(UserRequestDto userRequestDto) {  
        User user = userRequestDtoMapper.mapToUserEntity(userRequestDto);  
        user = userRepository.save(user);  
        Outbox outbox = userMapper.mapToOutBoxEntity(user);  
        outboxRepository.save(outbox);  
  
        return user;  
  
    }  
  
  
}
```

En el código de arriba observamos que se hacen dos transacciones, pero ambas son de bases de datos que pueden tener `rollback`.

El controlador para realizar el tema del evento: 
```java title=UserController.java
@RestController  
@RequestMapping("api/v1/users")  
public class UserController {  
    private final UserService userService;  
  
  
    public UserController(UserService userService) {  
        this.userService = userService;  
    }  
  
    @PostMapping  
    public User createUser(@RequestBody @Valid UserRequestDto userRequestDto) {  
        return userService.createUser(userRequestDto);  
    }  
}
```

Aqui claramente necesitamos mappers y necesitamos los dto: 
```java
@Data  
@AllArgsConstructor  
@NoArgsConstructor  
public class UserRequestDto {  
  
    @NotNull  
    private String firstName;  
    private String lastName;  
    private String address;  
    @NotNull  
    private LocalDate dob;  
    @Email  
    private String email;  
  
}

//

@Component  
public class UserMapper {  
  
    private final ObjectMapper objectMapper;  
  
    public UserMapper(ObjectMapper objectMapper) {  
        this.objectMapper = objectMapper;  
    }  
    // Este es un error unchecked  
    public Outbox mapToOutBoxEntity(User user){  
        if (user == null)  
            throw new NoUserToMapOutbox("No se puede agregar el usuario");  
        return new Outbox(  
                Aggregate.USER,  
                objectMapper.writeValueAsString(user),  
                false  
        );  
    }  
  
}

// 

@Component  
public class UserRequestDtoMapper {  
  
    public User mapToUserEntity(UserRequestDto userRequestDto) {  
        return new User(  
                userRequestDto.getFirstName(),  
                userRequestDto.getLastName(),  
                userRequestDto.getDob(),  
                userRequestDto.getAddress(),  
                userRequestDto.getEmail()  
        );  
    }  
  
}

// El error: 

public class NoUserToMapOutbox extends RuntimeException {  
    public NoUserToMapOutbox(String message) {  
        super(message);  
    }  
}
```

Y viene algo importante que es para generar los eventos: 
```java title=OutboxProcessorTask.java
@Slf4j  
@Component  
public class OutboxProcessorTask {  
  
    private final OutboxRepository outboxRepository;  
    private final RabbitTemplate rabbitTemplate;  
    private final DirectExchange directExchange;  
  
    public OutboxProcessorTask(OutboxRepository outboxRepository,  
                               RabbitTemplate rabbitTemplate, DirectExchange directExchange,  
                               ObjectMapper objectMapper) {  
        this.outboxRepository = outboxRepository;  
        this.rabbitTemplate = rabbitTemplate;  
        this.directExchange = directExchange;  
    }  
  
    @Scheduled(fixedRate = 5000)  
    @Transactional  
    public void process() {  
        log.info("Task executed");  
  
        List<Outbox> outboxes = outboxRepository.findTop10ByIsDelivered(false);  
        outboxes.forEach(  
                outbox -> {  
                    rabbitTemplate.convertAndSend(  
                            directExchange.getName(),  
                            "user.created",  
                            outbox.getMessage()  
                    );  
                    outbox.setIsDelivered(true);  
                }  
        );  
    }  
}
```

Ahora vamos a ver el otro programa
```java title=Cliente-Recibidor
public class Main {  
  
    private static final String EXCHANGE = "outbox";  
    private static final String ROUTING_KEY = "user.created";  
  
    public static void main(String[] args) throws Exception {  
  
        ConnectionFactory factory = new ConnectionFactory();  
        factory.setHost("localhost");  
  
        Connection connection = factory.newConnection();  
        Channel channel = connection.createChannel();  
  
        // IMPORTANTE: mismas propiedades que Spring  
        channel.exchangeDeclare(EXCHANGE, BuiltinExchangeType.DIRECT, true);  
  
        // Queue temporal (ok para pruebas)  
        String queueName = channel.queueDeclare().getQueue();  
  
        channel.queueBind(queueName, EXCHANGE, ROUTING_KEY);  
  
        System.out.println("[*] Esperando mensajes...");  
  
        DeliverCallback callback = (tag, delivery) -> {  
            String message = new String(delivery.getBody(), StandardCharsets.UTF_8);  
            System.out.println("[x] Recibido: " + message);  
        };  
  
        channel.basicConsume(queueName, true, callback, tag -> {});  
    }  
}
```

Con ello ya estamos generando este lindo patrón de diseño en Spring Boot.
Aunque hay algo que es muy importante y que el artículo nos da. Bueno, varias cosas en primera un dibujo del sistema :
![Pasted image 20251230203116.png](images/Pasted%20image%2020251230203116.png)
Luego nos comenta sobre soluciones a implementar, nosotros implementamos un `Sheduled`.
```java title=Scheduled
   @Scheduled(fixedRate = 5000)  
    @Transactional  
    public void process() {  
        log.info("Task executed");  
  
        List<Outbox> outboxes = outboxRepository.findTop10ByIsDelivered(false);  
        outboxes.forEach(  
                outbox -> {  
                    rabbitTemplate.convertAndSend(  
                            directExchange.getName(),  
                            "user.created",  
                            outbox.getMessage()  
                    );  
                    outbox.setIsDelivered(true);  
                }  
        );  
    } 
```
Pero hay una solución más y tiene que ver con un tema llamado =={orange}**Message Relay Service (MRS)**== donde textualmente nos da dos soluciones: 
- Create a job that will run periodically and poll the outbox table for undelivered messages and deliver them in batches.
- Use CDC (change data capture) tools like [Debezium](https://debezium.io/) to automatically publish messages whenever data is inserted in the outbox table.
Podemos ver algo de Debezium, aunque, será en otro curso.
## Lazy Loading

La carga diferida (Lazy Loading en inglés) es un patrón de diseño comúnmente usado para diferir la inicialización de un objeto hasta el punto en que se necesita. Puede contribuir a la eficiencia en la operación del programa si se usa de manera adecuada.
### Aplicabilidad:
Utilice el modelo de Carga Diferida cuando:

- La carga anticipada es costosa o el objeto a cargar podría no ser necesario en absoluto
### Estrucura:
El diagrama de clases en java se puede observar de esta forma: 
![Pasted image 20260101082535.png](images/Pasted%20image%2020260101082535.png)
Imagen dada por: https://java-design-patterns.com/es/patterns/lazy-loading/
### Participantes:
### Código: 
#### Python: 
Aquí vamos a tocar un tema un poco más complejo, la información dada aqui estará en un curso de Python, aunque puede saltarse al `código python` para solo observar el código.

Para el código a continuación vamos a establercer tres concepts que suelen aparecer juntos: 
- Generadores (`Generator`)
	- No calculan todo de una vez, producen valores cuando se necesitan
- Caché (`@cache`)
	- Evita recalcular resultados ya calculados
- Decoradores personalizados
	- Permiten envolver funciones y modificar su comportamiento (por ejemplo, agregar caché con lógica propia).

¿Qué son los Generadores?
Un generador es una funci´´on que produce valores uno por uno, en lugar de devolverlos todos juntos, para ello usamos la palabra reservada `yield` el cual es una orden muy similar a `return`, con la gran diferencia de que `yield` pausará la ejecucuón de tu función y guardará el estado de la misma hasta que decidas usarla de nuevo, por ejemplo:
```python
# Queremos calcular los cuadrados de una lista de números que se pasan como parametro.
# Una solución puede ser: 
def squares(numbers):
	return [number*number for number in numbers]

squares([1,2,3,4,5])

# El resultado será [1,4,9,16,25]
```
Aqui vemos que tenemos un pequeño problema y es que todos los resultados se generan de una vez. Si la lista `numbers` fuese muy grande, el tiempo de ejecucuón podría ser considerable. Para ello ahora hacemos: 
```python
import time  
  
def squares(numbers):  
    for number in numbers:  
        yield number * number  
  
def squaresSinGenerator(numbers):  
    return [number * number for number in numbers]  
  
n = 100_000_000  
  
print("Obtener solo los primeros 2 elementos:\n")  
  
# Con generador - solo calcula los primeros que necesites  
start = time.time()  
resultado = []  
for i, x in enumerate(squares(range(n))):  
    resultado.append(x)  
    if i >= 19:  # después del elemento 19 (índice 0-19 = 20 elementos)  
        break  
tiempo_yield = (time.time() - start) * 1000  
print(f"Con yield: {tiempo_yield:.4f} ms")  
print(f"Resultado: {resultado}\n")  
  
# Sin generador - calcula los 100 millones primero  
start = time.time()  
lista = squaresSinGenerator(range(n))  
resultado = lista[:2]  
print(f"Sin yield: {time.time() - start:.4f} seg")  
print(f"Resultado: {resultado}")
```
Con esto que nos genera de resultado?:
![Pasted image 20260101122947.png](images/Pasted%20image%2020260101122947.png)

Ahora vamos a ver lo que es `Generator`. El cual se puede ver como: 
```python
from typing import Generator  
  
  
def contador() -> Generator[int, None, None]:  
    yield 1
```
El significado es: `Generator[valor_yield,valor_send,valor_return]` y en la practica generalmente es `Generator[T, None, None]`.

¿Qué es `Callable`?
Esto describe funciones como objetos, por ejemplo:
```python
from typing import Callable  
  
def ejecutar(f:Callable[[int],int])->int:  
    return f(10)
```
Esto significa: 
- Recibe una función
- Esa función recibe un `int`
- Devuelve un `int`
***
Ahora hablemos del cache, lo básico:
¿Qué hace `@cache`?
```python
from functools import cache  
  
  
@cache  
def fib(n):  
    if n < 2:  
        return n  
    return fib(n - 1) + fib(n - 2)  
  
  
print(fib(1000))
```

Esto internamente nos dice. 
- Guarda un diccionario de tipo `{argumentos: resultado}`
- Si llamas con los argumentos, no recalcula
***
¿Y a todas estas qué es un decorador?
Un decorador es basicamente: 
```python
f = decorador(f)
```
que en terminos de decorador es: 
```python
@decorador
def f():
	pass
```

Para darle sentido una manera muy básica de crear un decorador es: 
```python
def miDecoradorImprimir(func):  
    resultado= func()  
    print(resultado)  
  
@miDecoradorImprimir  
def saludar():  
    return "hola"
```
Ahora que son los `*args` y los `*kwargs`
Normalmente definimos funciones así:
```python
def suma(a,b):
	return a+b
```
¿Pero que pasa si no sabes cuantos argumentos recibirá la función?, pues haces: 
```python
def f(*args): # aqui lo especial es *
	print(args) 
```
Por lo general en decoradores no sabemos cuantos argumentos tiene la función decorada, entonces: 
```python
def decoradro(func):
	def wrapper(*args):
		return func(*args)
	return wrapper
```
Ahora los `**kwargs` son argumentos con nombre variables. ¿Cómo así?
imaginemos lo siguiente: 
```python
def decorador(func):  
    def wrapper(*args, **kwargs):  
        print(f"Ejecutando {func.__name__}")  
        print("Argumento args: ",args, "\n Argumento kwargs: ",kwargs)  
        print("resultado funcion: ",func(*args, **kwargs))  
        return func(*args, **kwargs)  
    return wrapper  
  
  
@decorador  
def suma(a, b):  
    return a + b  
  
  
@decorador  
def sumaTriple(a, b, c) -> int:  
    return a + b + c  
  
  
suma(2, 3)           # kwargs vacío  
suma(a=2, b=3)       # kwargs={'a': 2, 'b': 3}  
sumaTriple(2, 3, c=4) # args=(2, 3), kwargs={'c': 4}
```
La salida de esto es: 
![Pasted image 20260101151249.png](images/Pasted%20image%2020260101151249.png)
Así que `kwargs` es un diccionario `clave : valor`
***
¿Por qué estos son clave en los decoradores? Pues un decorador envuelve funciones arbitrarias, la unica forma general es: 
```python
def wrapper(*args, **kwargs):
    return func(*args, **kwargs)
```
Junto a este, un tema importante es el uso de `@wraps(func)` porque uno copia los metadatos de la función para recrear la función, es decir, imaginemos el siguiente escenario: 
```python
def suma(a, b):  
    """Suma dos numeros"""  
    return a + b  
  
  
print(suma.__name__)  
print(suma.__doc__)
```
Aqui todo está bien, esto nos genera
![Pasted image 20260101151926.png](images/Pasted%20image%2020260101151926.png)
Ahora, usamos el decorador sin `@wraps`.
Entonces que sucede?: 
```python
from functools import wraps  
  
  
def decorador(func):  
    # @wraps(func)  
    def wrapper(*args, **kwargs):  
        print(f"Ejecutando {func.__name__}")  
        print("Argumento args: ",args, "\n Argumento kwargs: ",kwargs)  
        print("resultado funcion: ",func(*args, **kwargs))  
        return func(*args, **kwargs)  
    return wrapper  
  
  
@decorador  
def suma(a, b):  
    """Suma dos numeros"""  
    return a + b  
  
  
print(suma.__name__)  
print(suma.__doc__)
```
![Pasted image 20260101152011.png](images/Pasted%20image%2020260101152011.png)
Ese es el resultado, si agregamos `@wraps`: 
![Pasted image 20260101152033.png](images/Pasted%20image%2020260101152033.png)
Volvemos a tener identidad y metadatos de la función, recordemos que el decorador lo que hace es para la función suma: `suma = decorador(suma)` como ven, vuelve a crear una función suma

Con esta información vamos a el código:

#### Código Python
Aquí el caché es para **evitar llamadas repetidas** a algo lento (APIs, bases de datos, cálculos costosos).
```python
import csv  
import time  
from functools import wraps  
from typing import Any, Callable, Generator  
  
  
def ttl_cache(seconds: int) -> Callable[[Callable[..., Any]], Callable[..., Any]]:  
    def decorator(func: Callable[..., Any]) -> Callable[..., Any]:  
        cache_data = {}  
        cache_time = {}  
  
        @wraps(func)  
        def wrapper(*args: Any, **kwargs: Any):  
            key = (args, tuple(kwargs.items()))  
            now = time.time()  
            if key in cache_data and (now - cache_time[key]) < seconds:  
                return cache_data[key]  
  
            result = func(*args, **kwargs)  
            cache_data[key] = result  
            cache_time[key] = now  
            return result  
  
        return wrapper  
    return decorator  
  
  
def load_sales(path: str) -> Generator[dict[str, str], None, None]:  
    print("Loading CSV data ...")  
    with open(path, 'r') as f:  
        reader = csv.DictReader(f)  # ← DictReader en vez de reader  
        for row in reader:  
            yield row  
  
  
@ttl_cache(seconds=60)  
def get_conversion_rates() -> dict[str, float]:  
    print("fetching conversion rate...")  
    time.sleep(2)  
    return {"USD": 1.0, "EUR": 1.1, "JPY": 150.0, "CHF": 0.9}  
  
  
def count_sales(sales: Generator[dict[str, str], None, None]) -> int:  
    return sum(1 for _ in sales)  # ← Cuenta elementos del generador  
  
  
def analyze_sales(path: str, currency: str) -> float:  
    total = 0.0  
    for i, s in enumerate(load_sales(path), start=1):  
        total += float(s["amount"])  
        if i >= 10_000:  
            break  
  
    rate = get_conversion_rates().get(currency, 1.0)  
    return total * rate  
  
  
def main() -> None:  
    while True:  
        print("\nElige una opción:")  
        print("1. Analizar los datos")  
        print("2. Contar el total de ventas")  
        print("3. Salir")  
  
        choice = input("> ")  
  
        if choice == "1":  
            currency = input("Ingresa una currency (USD/EUR/JPY/CHF): ").upper() or "USD"  
            total = analyze_sales("sales.csv", currency)  
            print(f"El total de ventas es: {total:.2f} {currency}")  
        elif choice == "2":  
            sales = load_sales("sales.csv")  
            count = count_sales(sales)  
            print(f"El total de ventas es: {count}")  
        elif choice == "3":  
            print("Adiós")  
            break  # ← Este break sí sale del while  
        else:  
            print("Opción inválida")  
  
  
if __name__ == "__main__":  
    main()
```


#### Java
```java
// Aqui hay varias maneras de hacerlo pero la "pro" es la siguiente, vamos a pintar dos escenarios, el main: 
public class Main {  
    public static void main(String[] args) {  
        //Config config = new Config();  
        Config2 config = new Config2();  
  
        System.out.println("Inicializado");  
  
        // aqui lo necesitamos  
        System.out.println("llamamos a lineas: ");  
        var lineas = config.getLineas();  
        System.out.println("Lineas: \n" + lineas);  
        System.out.println("volvemos a llamar a lineas: ");  
        var lineas2 = config.getLineas();  
        System.out.println("Lineas: \n" + lineas2);  
    }  
  
}

// aqui vemos dos Config, Config es para normal, sin nada y el config2 es con lazyload+cache:
public class Config {  
  
    private final List<String> lineas;  
  
    public Config() {  
        List<String> lineas1;  
        System.out.println("cargando archivo");  
        try {  
            lineas1 = cargarArchivo();  
        } catch (InterruptedException e) {  
            e.printStackTrace();  
            lineas1 = new ArrayList<>();  
        }  
        this.lineas = lineas1;  
    }  
  
    private List<String> cargarArchivo() throws InterruptedException {  
        Thread.sleep(5000);  
        return List.of("linera1|", "linea2", "linea3");  
    }  
  
    public List<String> getLineas() {  
        return this.lineas;  
    }  
  
  
}
// Ahi vemos que es todo muy normal, el constructor es quein hace toda la inicialización y se demora un monton.
public class Config2 {  
  
    private final Supplier<List<String>> lineas =  
            new Supplier<>() {  
                private List<String> cache;  
  
                @Override  
                public List<String> get() {  
                    if (cache == null) {  
                        try {  
                            cache = cargarArchivo();  
                            return cache;  
                        } catch (InterruptedException e) {  
                            throw new RuntimeException(e);  
                        }  
                    }  
                    return cache;  
                }  
            };  
  
    private List<String> cargarArchivo() throws InterruptedException {  
        Thread.sleep(5000);  
        return List.of("linera1|", "linea2", "linea3");  
    }  
  
    public List<String> getLineas() {  
        return this.lineas.get();  
    }  
}

// De la segunda forma se usa un supplier para no cargar todo de golpe y usamos un cache jeje, y ya. Ahi termina
```
```java title=SpringBoot
// En spring ha anotaciones para ello, está @Lazy  y @Cachable
// En el siguiente bean se crea de forma Eager
@Bean
public RestTemplate restTemplate() {
    return new RestTemplate();
}

// para cargar de forma Lazy usamos: 
@Bean
@Lazy
public RestTemplate restTemplate() {
    return new RestTemplate();
}

// Asi solo se usa cuando se vaya a utilizar
// También se usa en dependencias

@Service
public class MiServicio {

    private final RestTemplate restTemplate;

    public MiServicio(@Lazy RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }
}
// Aqui crea el servcio pero RestTemplate solo se inyecta un proxy
// Y Cachable? : 
@Cacheable("usuarios")
public Usuario buscarUsuario(Long id) { ... }
//- Eso ejecuta la primera vez y el resultado se guarda, las siguientes usan caché
///// Otras formas de usar el lazy: 
@Autowired
ObjectProvider<RestTemplate> provider;

public void usar() {
    RestTemplate rt = provider.getObject(); // lazy
}

```
## Specification
### Aplicabilidad:
### Estrucura:
### Participantes:
### Código: 

## RPC
### Aplicabilidad:
### Estructura:
### Participantes:
### Código: 

## State
State es un patrón de diseño de comportamiento que permite a un objet alterar su comportamiento cuando su estado interno cambia. Parece como si el objeto cambiara su clase.
### Aplicabilidad:
La idea principal es que, en cualquier momento dado, un programa puede encontrarse en un número _finito_ de _estados_. Dentro de cada estado único, el programa se comporta de forma diferente y puede cambiar de un estado a otro instantáneamente. Sin embargo, dependiendo de un estado actual, el programa puede cambiar o no a otros estados. Estas normas de cambio llamadas _transiciones_ también son finitas y predeterminadas.

También puedes aplicar esta solución a los objetos. Imagina que tienes una clase `Documento`. Un documento puede encontrarse en uno de estos tres estados: `Borrador`, `Moderación` y `Publicado`. El método `publicar` del documento funciona de forma ligeramente distinta en cada estado:

- En `Borrador`, mueve el documento a moderación.
- En `Moderación`, hace público el documento, pero sólo si el usuario actual es un administrador.
- En `Publicado`, no hace nada en absoluto.
![Pasted image 20260117073422.png](images/Pasted%20image%2020260117073422.png)
### Estructura:
![Pasted image 20260117073609.png](images/Pasted%20image%2020260117073609.png)
### Participantes:
En los participantes encontramos:

1. Contexto: Almacena una referencia a uno de los objetos de estado concreto y le delega todo el trabajo especifico del estado. El contexto se comunica con el objeto de estado a tráves de la interfaz de etado
2. Interfaz de estado: Declara los métodos específicos del estado. Estos métodos deben tener sentido para todos los estados concretos, porque no querrás que uno de tus estados tenga métodos inútiles que nunca serán invocados.
3. Los estados concretos: Proporcionan implementaciones para los métodos específicos del estado. Evita duplicación de código y puede incluir clases abstractas intermedias que encapsulen algún comportamiento común.
### Código: 
#### Java:
```java
// primero hacemos el estado
public abstract class State {
	Player player;
	
	public abstract String onLock();
    public abstract String onPlay();
    public abstract String onNext();
    public abstract String onPrevious();

}

// Ahora hacemos la implementación 
public class LockedState extends State {

    LockedState(Player player) {
        super(player);
        player.setPlaying(false);
    }

    @Override
    public String onLock() {
        if (player.isPlaying()) {
            player.changeState(new ReadyState(player));
            return "Stop playing";
        } else {
            return "Locked...";
        }
    }

    @Override
    public String onPlay() {
        player.changeState(new ReadyState(player));
        return "Ready";
    }

    @Override
    public String onNext() {
        return "Locked...";
    }

    @Override
    public String onPrevious() {
        return "Locked...";
    }
}

// Otra implementación
public class ReadyState extends State {

    public ReadyState(Player player) {
        super(player);
    }

    @Override
    public String onLock() {
        player.changeState(new LockedState(player));
        return "Locked...";
    }

    @Override
    public String onPlay() {
        String action = player.startPlayback();
        player.changeState(new PlayingState(player));
        return action;
    }

    @Override
    public String onNext() {
        return "Locked...";
    }

    @Override
    public String onPrevious() {
        return "Locked...";
    }
}

// ultima implementación: 

public class PlayingState extends State {

    PlayingState(Player player) {
        super(player);
    }

    @Override
    public String onLock() {
        player.changeState(new LockedState(player));
        player.setCurrentTrackAfterStop();
        return "Stop playing";
    }

    @Override
    public String onPlay() {
        player.changeState(new ReadyState(player));
        return "Paused...";
    }

    @Override
    public String onNext() {
        return player.nextTrack();
    }

    @Override
    public String onPrevious() {
        return player.previousTrack();
    }
}

// Ahora nuestro "contexto"
public class Player {
    private State state;
    private boolean playing = false;
    private List<String> playlist = new ArrayList<>();
    private int currentTrack = 0;

    public Player() {
        this.state = new ReadyState(this);
        setPlaying(true);
        for (int i = 1; i <= 12; i++) {
            playlist.add("Track " + i);
        }
    }

    public void changeState(State state) {
        this.state = state;
    }

    public State getState() {
        return state;
    }

    public void setPlaying(boolean playing) {
        this.playing = playing;
    }

    public boolean isPlaying() {
        return playing;
    }

    public String startPlayback() {
        return "Playing " + playlist.get(currentTrack);
    }

    public String nextTrack() {
        currentTrack++;
        if (currentTrack > playlist.size() - 1) {
            currentTrack = 0;
        }
        return "Playing " + playlist.get(currentTrack);
    }

    public String previousTrack() {
        currentTrack--;
        if (currentTrack < 0) {
            currentTrack = playlist.size() - 1;
        }
        return "Playing " + playlist.get(currentTrack);
    }

    public void setCurrentTrackAfterStop() {
        this.currentTrack = 0;
    }
}
```
#### typescript:
```ts
class Context {
    /**
     * @type {State} A reference to the current state of the Context.
     */
    private state: State;

    constructor(state: State) {
        this.transitionTo(state);
    }

    /**
     * The Context allows changing the State object at runtime.
     */
    public transitionTo(state: State): void {
        console.log(`Context: Transition to ${(<any>state).constructor.name}.`);
        this.state = state;
        this.state.setContext(this);
    }

    /**
     * The Context delegates part of its behavior to the current State object.
     */
    public request1(): void {
        this.state.handle1();
    }

    public request2(): void {
        this.state.handle2();
    }
}

/**
 * The base State class declares methods that all Concrete State should
 * implement and also provides a backreference to the Context object, associated
 * with the State. This backreference can be used by States to transition the
 * Context to another State.
 */
abstract class State {
    protected context: Context;

    public setContext(context: Context) {
        this.context = context;
    }

    public abstract handle1(): void;

    public abstract handle2(): void;
}

/**
 * Concrete States implement various behaviors, associated with a state of the
 * Context.
 */
class ConcreteStateA extends State {
    public handle1(): void {
        console.log('ConcreteStateA handles request1.');
        console.log('ConcreteStateA wants to change the state of the context.');
        this.context.transitionTo(new ConcreteStateB());
    }

    public handle2(): void {
        console.log('ConcreteStateA handles request2.');
    }
}

class ConcreteStateB extends State {
    public handle1(): void {
        console.log('ConcreteStateB handles request1.');
    }

    public handle2(): void {
        console.log('ConcreteStateB handles request2.');
        console.log('ConcreteStateB wants to change the state of the context.');
        this.context.transitionTo(new ConcreteStateA());
    }
}

/**
 * The client code.
 */
const context = new Context(new ConcreteStateA());
context.request1();
context.request2();
```

## Interprete
Este patrón de diseño es utilizado para evaluar un lenguaje definido como «expresiones», este patrón nos permite interpretar un lenguaje como Java,C#, SQL o incluso un lenguaje inventado por nosotros el cual tiene un significado; y darnos respuestas tras evaluar dicho lenguaje
### Aplicabilidad:
Se aplica a Lenguajes de dominio específico como expresiones matemáticas, fórmulas empresariales, etc. (Un sistema que evalúes expresiones como `"precio * impuesto + envío"`)
También a procesamiento de comandos o scripts, análisis de expresiones regulares o lógicas o compiladores e intérpretes educativos.
### Estructura:
![Pasted image 20260117074818.png](images/Pasted%20image%2020260117074818.png)
### Participantes:
- **Client**: Actor que dispara la ejecución del intérprete
- **Context**: Objeto con información global que será utilizada por el intérprete para leer y almacenar información global entre todas las clases que conforman el patrón, este es enviado a interpeter el cual lo replica por toda la estructura.
- **AbstractionExpression**: Interface que define la estructura mínima de una expresión.
- **TerminalExpression**: Se refiere a expresiones que no tienen más continuidad y al ser evaluadas o interpretadas terminan la ejecución de esa rama. Estas expresiones marcan el final de la ejecucion de un sub-árbol de la expresión
- **NonTerminalExpression**: Son expresiones compuestas y dentro de ellas existen más expresiones que deben ser evaluadas. Estas estructuras son interpretadas utilizada recursividad hasta llegar a una expresión Terminal. 


### Código: 
# Bibliografía:

[Patrones de diseño bien - Erich Gamma.pdf](Patrones_de_diseo_bien_-_Erich_Gamma.pdf)