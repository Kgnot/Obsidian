---
type: course
status: en_progreso
tags: [course, Python (Curso)]
date_started: 2024-05-20
---

# Python

# Tipos:

En python al igual que en otros lenguajes hay diferentes tipos de variables, en java pueden verse como String, int, float, double y su contraparte de Objeto. En python son: 

| `int` | `int` (Java), `int` (C++) | Representa números enteros. En Python, el tamaño es ilimitado (arbitrario). |
| --- | --- | --- |
| `float` | `double` (Java), `float` (C++) | Representa números de punto flotante (decimales). En Python, es equivalente a un `double` en C++. |
| `complex` | `Complex` (Java), N/A (C++) | Representa números complejos (con parte real e imaginaria). No tiene equivalente directo en C++. |
| `str` | `String` (Java), `std::string` (C++) | Representa cadenas de texto. En Python, las cadenas son inmutables. |
| `bool` | `boolean` (Java), `bool` (C++) | Representa valores booleanos (`True` o `False`). |
| `list` | `ArrayList` (Java), `std::vector` (C++) | Representa una colección ordenada y mutable de elementos. |
| `tuple` | N/A (Java), `std::tuple` (C++) | Representa una colección ordenada e inmutable de elementos. |
| `set` | `HashSet` (Java), `std::set` (C++) | Representa una colección desordenada de elementos únicos. |
| `frozenset` | N/A (Java), `std::set` (C++) | Representa un conjunto inmutable (similar a `set`, pero no se puede modificar). |
| `dict` | `HashMap` (Java), `std::map` (C++) | Representa un diccionario (colección de pares clave-valor). |
| `NoneType` | `null` (Java), `nullptr` (C++) | Representa la ausencia de valor. En Python, el único valor posible es `None`. |
| `bytes` | `byte[]` (Java), `std::vector<uint8_t>` (C++) | Representa una secuencia inmutable de bytes. |
| `bytearray` | `byte[]` (Java), `std::vector<uint8_t>` (C++) | Representa una secuencia mutable de bytes. |

---

```python
# int
numero = 42

# float
decimal = 3.14

# str
texto = "Hola, mundo"

# bool
verdadero = True

# list
lista = [1, 2, 3]

# tuple
tupla = (1, 2, 3)

# set
conjunto = {1, 2, 3}

# dict
diccionario = {"clave": "valor"}

# NoneType
nulo = None

# bytes
bytes_data = b"datos"

# bytearray
bytearray_data = bytearray(b"datos")
```

# Variables

A la hora de crear variables es de lo mas increible de este lenguaje, debido a que es simplemente: 

```python
var1 = "hola"
var2 = 17
var3 = 3.15
```

# Operadores:

Hay diferentes tipos de operadores en python los mas comunes son: + , - , * , / , ** ; que son suma, resta, multiplicación, división y potenciación respectivamente . Tambien hay otro que es // la cual significa la división entera que puede funcionar similar a un trunc() de la librería math.

---

## Para inputs:

Usamos la función `input()` de tal manera que:

```python
inp = input()
# tambien: 
inp = input("Digite su nombre: \n") #Funciona de la misma forma
#No olvidar que existen maneras para obligar que un dato sea un tipo: 
#tanto como: 
int()
float()
str()
bool()
list()
tuple()
set()
dict()
complex()
bytes() # Secuencia inmutable de bits
bytearray() #Secuencia mutable de bits

#Hay ocaciones que necesitamos o debemos pasar un "3.15" a entero, quien sabe
#Lo mejor que podemos hacer es combinar tipos
int(float("3.14"))
#Así podemos combinar estos dos tipo y crear el entero
```

---

# Condicionales:

Los booleanos condicionales en expresiones de verdadero y falso tinene los siguientes modos: 

```python
x!=y # x no es igual a y
x>y # x es mayor a y
x<y # x es menor a y
x>=y # x es mayor o igual a y
x<=y # x es menor o igual a y
x is y # x es el mismo que y
x is not y # x no es el mismo que y
x==y # x es igual a y
isinstance(*valor,tipo_dato*) # Si el valor es instancia de un tipo de dato
```

# Indentación:

Se pueden usar de igual forma las funciones, condicionales, for, etc. Con la diferencia de que en vez de usar corchetes {} , usamos la indentación:

 

```python
if a> b:
	print("xd")

#Tambien como funciona el if: 
if *condicion:
	...*
elif *condicion_2:
	...*
else:
	...
```

## Try-catch

El try-catch es muy conocido, ademas de que sirve para capturar errores luego de intentar un código que puede generar error:

```python
inp = input('Ingrese una temperatura para calcularla en farentheit')
try: 
	fahr = float(inp)
	cel = (fahr - 32.0)*5.0/9.0
	print(cel)
except:
	print('Ingrese un numero')
```

## Funciones:

En python existen muchas funciones para cada uno de los datos que nosotros damos, como el `max` o `min` en una cadena, o el `len` para longitud. Las funciones de conversión que vimos anteriormente entra tambien en este catalogo. 

### Funciones Matemáticas:

Las funciones que nacen al hacer un `import math` , esta es un modulo que contiene una serie de funciones que podemos encontrar: https://docs.python.org/3/library/math.html

De las funciones matemáticas mas usadas tenemos: `floor()` ,`log(*e,base*)` ,`cos(),` ,`sin()` ,`tan()` , constantes como  `pi` ,`e` ,`tau` .

### Random

También tenemos para random una libreria `import random` , la cual nos da una gran cantidad de funciones. Consultar: https://docs.python.org/es/3.10/library/random.html

para hacer un numero random basta con: 

```python
import random

for i in range(10):
	x = random.random()
	print(x)

```

De esta forma sacamos 10 números random aleatoriamente entre 0 y 1 ; tambien hay funciones como `randint(*min*,*max*)` que espera dos números de entre que y que generar números aleatorios  

### Nuevas funciones

Para adicionar nuevas funciones o funciones creadas por uno basta con usar la palabra reservada `def` con esto creamos cualquier función como por ejemplo: 

```python
def consumirAlcohol():
	print("consumiendo alcohol")
	
consumirAlcohol()

# esto nos da en pantalla "consumiendo alcohol" 
# y si hacemos: 
print(consumirAlcohol) 
#nos deberia mandar algo como: 
# <function consumirAlcohol at 0x7ba153c>
# ya que nos dice donde se guarda la función, es decir, se la pasamos por referencia
```

# Iteración:

Dentro de las iteraciones de python existen las mismas iteraciones de toda la vida, tenemos el while y el for:  

```python
while True:
	line = input('> ')
	if line[0]== '#':
		break
#aqui recibe inputs hasta que se le asigne la almohadilla. 

for x in range(5):
	print(x)

#En este usamos el range para crear una lista ya que la forma en que el for
# es creado : 

for *variable* in *secuencia:
	...*
# Esa es la forma mas normal de crear un for en python, entonces: 

lista = ['arbol','pera','celular',5]

for item in lista:
	print(item)
	
# nos da como output: 
'''
 arbol
 pera
 celular
 5 
'''

# también podemos combinar dos varibales diferentes: 

for index, item in enumerate(lista):
	print("posicion ",index," valor: ",item)
	
#Esto lo podemos hacer con la funcion ' enumerate() ' que tiene dos variables
# un iterable y un start que recorre el arreglo 

#Con for no solamente recorremos una lista si no cualquier cosa que pueda ser interable
# asi como un MAPA o Diccionario: 

diccionario ={
    'clave':'valor',
    'clave2':5,
    'clave3':'un objeto'
}
print("-------------- Clave: -------------")

for clave in diccionario:
    print(clave)
print("-------------- Valor: -------------")

for clave in diccionario:
    valor = diccionario[clave]
    print(valor)
print("-------------- Clave: -------------")

for clave in diccionario.keys():
    print(clave)
print("-------------- Valores: -------------")
for valor in diccionario.values():
    print(valor)
    
    
#El output es el siguiente: 
```

![image.png](src/Python/image.png)

```python
largest = None
print('Before:', largest)
for itervar in [3, 41, 12, 9, 74, 15]:
    if largest is None or itervar > largest :
        largest = itervar
    print('Loop:', itervar, largest)
print('Largest:', largest)

#podemos hacer tambien, como todo lenguaje de programación, combinaciones con if en for
# etc. También está las palabras continue y break
```

# Strings:

Los strings son secuencias de caracteres y se pueden acceder como si un arreglo fuese: 

```python
fruit = 'banana'
letter = fruit[2]
```

Al igual que los arreglos, podemos usar funciones como `len(*string*)` , una cosa que podemos hacer es usar negativos para retroceder del último.

También podemos hacer un loop con este: 

 

```python
index = 0
while index < len(fruit):
	letter = fruit[index]
	print(letter)
	index = index +1 
	
# Otro de los loops sería el for: 

for char in fruit: 
	print(char)
```

Los segmentos de un String son llamados **Slice**. El cual consta de seleccionar un espacio de caracteres: 

```python
s = 'Monty Python'
print(s[0:5])
#Esto mumestra: Monty | el slice funciona =>  [inicio:fin]
#Tambien podemos hacer [:3] para indicar que va de 0 a 3 caracteres .
#o usar [3:] Para inidicar que será de 3 en adelante. 
```

Aquí incluye el primero pero omite el último, por esa razón es que metemos 0:5 y no 0:4 :D

### Los String son inmutables

Los tipos de datos String son inmutables, esto quiero decir que no podemos cambiar los caracteres de un String ya definido, por ejemplo, el siguiente código quedaría en error: 

![image.png](src/Python/image%201.png)

Por esa razón es que nosotros, si queremos cambiar un string lo que debemos hacer es: ‘

```python
greeting = 'Hello, world!'
new_greeting = 'J' + greeting[1:]
print(new_greeting)
# >> Jellow, world!
```

### Podemos usar el operador ‘in’  en strings

Que es el operador in? : 
El operador `in` en Python es un operador de pertenencia que se utiliza para verificar si un valor 
está presente en una secuencia (como una lista, tupla, cadena, conjunto o diccionario). Devuelve un valor booleano (`True` o `False`) dependiendo de si el valor buscado existe en la secuencia.

Por ende podemos hacer: 

```python
'a' in 'banana'
#>> TRUE | sería la respuesta
```

### **Comparación de cadenas en Python**

En Python, las cadenas se pueden comparar utilizando operadores como `<`, `>`, `<=`, `>=`, `==` y `!=`. Estas comparaciones se realizan **letra por letra** , basándose en el valor numérico de cada carácter según su **orden Unicode**  (que es similar al orden alfabético para letras).

Ejemplo:

```python
print("apple" < "banana")  # True, porque "apple" viene antes que "banana"
print("banana" < "apple")  # False, porque "banana" no viene antes que "apple"
print("banana" == "banana")  # True, porque son exactamente iguales
```

El orden alfabético se determina comparando los caracteres uno por uno:

- Primero se compara el primer carácter de ambas palabras.
- Si son iguales, se pasa al siguiente carácter.
- Si difieren, el carácter con menor valor Unicode determina qué palabra va primero.

Por ejemplo:

- `"apple"` vs `"banana"`: `'a'` es igual en ambos, pero `'p'` (de "apple") es menor que `'b'` (de "banana"), así que `"apple"` es menor.

# Programación orientada a Objetos:

Primero tomaremos pequeñas cosas que son necesarias para aprender la OOP que son: 

1. Herencia
2. Cohesión
3. Abstracción
4. Polimorfismo
5. Acoplamiento
6. Encapsulamiento

## Como se definen clases en Python?:

Para definir una clase tendremos el código simple de : 

```python
#Se crea una clase vacía
class Perro:
	pass

# El pass que significa? : solamente se usa para indicar que es una clase vacia sin
# nada adentro, sin metodos o sin atributos. :D

#También se usa para clase abstractas parciales: 
class Perro: 
	def metodo(self):
		pass
#Que significa el self?: 
```

## A tener muy en cuenta:

# **Dunder methods**