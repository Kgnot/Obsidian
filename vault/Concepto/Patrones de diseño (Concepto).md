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
    
2. Código Java

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
    
2. Código en Java: 
    
    ```python
    
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

    public void remove(MenuComponent component) {
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

# Bibliografía:

[Patrones de diseño bien - Erich Gamma.pdf](Patrones_de_diseo_bien_-_Erich_Gamma.pdf)