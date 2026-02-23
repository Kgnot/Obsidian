# 1. Fundamentos eléctricos y de señal
Una señal se define como la variación temporal de una magnitud física que se utiliza para codificar información. En el caso de una señal electrónica esa magnitud puede ser una corriente eléctrica, tensión o intensidad luminosa. 

La tensión o voltaje es la magnitud física que cuantifica la diferencia de potencial eléctrico entre dos puntos, y se mide en voltios(V).
La corriente o intensidad eléctrica es la cantidad de carga eléctrica que pasa por un conductor por unidad de tiempo y se mide en amperios (A).

Las señales pueden ser analógicas o digitales.
![Pasted image 20260219143421.png](images/Pasted%20image%2020260219143421.png)
Mientras la primera existe un valor infito  de valores en el tiempo (entre -1 y 1) la segunda esta restringida a solo 2 valores {1,-1}.
## Señal digital (push-pull, open-drain)
Las señales digitales push-pull y open drain son configuraciones comunes de los pines GPIO de microcontroladores para manjear salidas lógicas (alto/bajo). Push-pull usa dos transistores activos para "empujar" y "tirar" activamente la señal, mientras que open drain solo "tira" hacie tierra y necesita ayuda externa para el nivel alto.
***
Que es GPIO: Más adelante en el curso se va a ver [[#4. GPIO]] , Pero una introducción rápida es:
GPIO son pines de entrada/salida. Imagina que tu microcontrolador necesita "hablar" con el entorno: un GPIO en modo entrada lee si un botón está presionado (alto/bajo) o mide un sensor simple. En modo salida, enciende un LED (alto) o lo apaga (bajo), como un interruptor controlado por código.

### Push-pull

Esta configuración emplea un par de transistores complementarios (P-MOS arriba y N-MOS abajo). Cuando la entrada manda un nivel bajo, el P-MOS se activa y "empuja" corriente desde VDD hacia la salida (nivel alto activo). Para nivel alto en entrada el N-MOS "tira" la salida hacia GND (nivel bajo activo), con el otro transistor apagado

Fenomenológicamente, genera transiciones rápidas y fuertes porque ambos niveles son impulsados activamente, sin depender de resistencias externas. Esto evita flancos lentos por capacitancia.

Imagina un balde de agua (VDD, el voltaje alto) conectado por un tubo superior y un desagüe inferior. El "totem pole" es dos válvulas complementarias:

- Para encender un LED (salida "1"): cierras el desagüe (N-MOS off) y abres la válvula superior (P-MOS on). El agua fluye fuerte y rápida del balde al LED, iluminándolo al instante.    
- Para apagar el LED (salida "0"): cierras la válvula superior (P-MOS off) y abres el desagüe (N-MOS on). Todo drena a tierra (GND) velozmente, sin residuos.
    
No hay manguera floja o resistencia: la fuerza viene directa de los transistores, por eso los cambios son "rápidos y fuertes" (flancos limpios, sin lentitud por capacitancia del cable).

Es decir, sirve para mandar señales mediante bits, 1,0 de manera rapida e inmediata [Es solo para enviar, el microcontrolador hablando fuerte].
### Open-drain

A diferencia de push-pull, opendrain es el pin GPIO que solo puede bajar la señal a 0 (tirrar a tierra), pero para subirla a 1 necesita una resistencia externa que la jala hacia arriba.

Push-pull tiene **dos músculos** (subir y bajar). Open-drain tiene **uno solo** (bajar) + ayuda externa para subir.

#### Por Qué Existe Esta Rarura

Porque permite que **varios cables se conecten en un solo punto** sin pelearse:
- Todos sueltos = todos en 1 (pull-up gana)
- Cualquiera tira = todos ven 0
***
Un protocolo que se usa es I2C que se verá más adelante en este curso[[#I2C]]. Pero a ciencia rapida: 
Este es un protocolo de comunicacion que conecta un "maestro" (el microcontrolador) con varios "esclavos" (sensores/dispositivos) usando dos cables:  SCL (reloj) y SDA (datos). Todos comparten los cables, el maestro "llama por nombre" y el elegido responde. Algo como: 
```text
1. Micro dice: "¡0x48! Dame temperatura"  → Solo sensor 0x48 escucha
2. Sensor 0x48: "Sí maestro" (ACK, baja SDA)
3. Micro: pulsos reloj, sensor mete bits: 0b00110010 = 25°C
4. Micro: "¡0x68! Dame aceleración"     → Solo MPU6050 responde
5. MPU6050: "Sí" → manda 0b01100101 = 1.2g
6. Repite...
```
## Señal analógica
Las señales analógicas son variaciones continuas de voltaje que representan el mundo real (temperatura, luz, sonido), no son solo 0s y 1s discretos como las digitales.

Las señales analógicas no tienen push-pull ni open-drain. Esos son trucos de salida digital. Lo analógico vive en pines ADC (entrada) o DAC (salida), que son amplificadores lineales sin saltos. 

**ADC (Analógico → Digital)**: "Fotografía" rápida del voltaje continuo.
```text
Voltaje real: 1.234V
ADC 10-bit:  "más cercano" → 503 (1.65V máx=1023 → 503/1023 * 3.3V = 1.62V)
Pérdida: 0.006V por redondeo (cuantización)
```
**DAC (Digital → Analógico)**: Reconstruye con resistores o capacitores.
```text
503 digital → DAC → 1.62V (aprox)
Filtro pasa-bajos suaviza saltos → onda "parecida"
```
## Pull-up / Pull-down
Pull-up y pull-down son **resistores** (físicos o internos del micro) que fijan un estado **por defecto** en un pin GPIO cuando no hay señal clara, evitando lecturas "flotantes" (ruido aleatorio).

**Pull-Up (Jala Arriba)**
==**resistencia conectada a VDD** para mantener el pin en **alto (1)** por defecto==.
Evita que el pin quede "flotando" y detecte ruido. Cuando presionas un botón, el pin baja a **GND (0)**.
```text
`VDD (5V) ──[10kΩ]─── Pin GPIO ──[Botón]── GND`
```
- **Reposo** (botón suelto): Pin ve 5V = **HIGH** (1).
- **Pulsado**: Botón cierra → Pin a 0V = **LOW** (0).
- **Arduino**: `pinMode(pin, INPUT_PULLUP);` activa interno.

**Pull-Down (Jala abajo)**
Es una ==**resistencia conectada a GND** para mantener el pin en **bajo (0)** por defecto==.
Evita estados falsos. Al meterle voltaje (ej. un botón), el pin sube a **alto (1)**.
```text
VDD ──[Botón]── Pin GPIO ──[10kΩ]── GND
```
- **Reposo**: Pin ve 0V = **LOW** (0).
- **Pulsado**: Botón cierra → Pin a 5V = **HIGH** (1).
- **Menos común**: Pull-up es estándar.

Pull-up = **90% casos**. Evita "fantasmas" en entradas.
## Niveles lógicos 3.3V

Los niveles lógicos de 3.3V son el estándar moderno para micros como ESP32, Raspberry Pi o STM32: **HIGH = 3.3V**, **LOW = 0V**. Más eficientes y seguros que 5V, pero no compatibles directo con lógica vieja.

```text
ENTRADA:
- LOW:  0V a 0.99V  (hasta 30% de 3.3V)
- HIGH: 2.31V a 3.3V (desde 70% de 3.3V)
- Zona muerta: 1.0V-2.3V (indefinido)

SALIDA:
- LOW:  0V a 0.3V máx
- HIGH: 3.0V mín (casi 3.3V)
```
## Impedancia
Impedancia es la "resistencia total" que un circuito ofrece a la corriente alterna (CA), combinando resistencia real (R) más efectos de capacitores (Xc) e inductores (XL) que dependen de la frecuencia.

## Resistencia vs Impedancia (Simple)
```text
RESISTENCIA (DC): Solo frena electrones. Fija: 100Ω siempre.
IMPEDANCIA (AC): Frena + "desfasa". Cambia con Hz:
  Baja freq: Capacitor "frena poco" (alta Xc)
  Alta freq: Capacitor "deja pasar" (baja Xc)

```
Fórmula: Z=R+j(XL−XC)Z=R+j(XL−XC), pero piensa vectorial: R horizontal, reactancia vertical.

## Ruido y filtrado
Ruido son señales no deseadas que corrompen tus lecturas o comunicaciones. Filtrado las bloquea selectivamente.
### Tipos Principales de Ruido
- **Térmico (Johnson)**: Electrones vibrando por calor en resistores/cables. Blanco, inevitable, peor a alta T° y ancho banda.
- **Disparo (shot)**: Corriente "granular" en transistores/diodos. Como granos arena cayendo.
- **1/f (parpadeo)**: Ruido rosa, fuerte en bajas frecuencias. Dominante en MOSFETs y contactos sucios.
- **Impulsivo**: Picos de motores, relés, rayos. Daña ADC instantáneo.
- **EMI**: Inducido por cables cercanos, WiFi, motores. Acoplamiento capacitivo/inductivo.

### Cómo filtrar? : 
```text
RC PASA-BAJOS (90% casos):
Sensor ──[R 1k]───[C 100nF]─── ADC
Corta >1.6kHz. Simple, analógico.

PASA-ALTOS:
Bloquea DC offset: [C]───[R]─── entrada

SW (software):
int suma=0; for(i=0;i<16;i++) suma+=analogRead(A0); media=suma/16;
Promedia térmico/disparo.

Media móvil: buffer[10], saca viejo, mete nuevo, divide.
```
**Regla**: Filtra **hardware primero** (RC), software después (promedio). ¿Tu sensor luz? RC 1k/100 nF antes ADC mata 95% ruido. ¿Qué señal específica?

## Conversión nivel lógico (level shifting)
Level shifting convierte señales lógicas entre distintos voltajes (ej. 3.3 V ↔ 5 V) para que micros y sensores "hablen" sin quemarse.

Conversión de nivel lógico permite unir mundos incompatibles: ESP32 (3.3 V) no tolera 5 V directo, Arduino 5 V lee 3.3 V pero débil.

(Hay muchas cosas que solo colocaré concepto porque la parte electrónica no es lo mío, y solo quiero entender la fenomenología del asunto, en temas más específicos a nivel de software, si entraré en más detalle)
## Temporización básica

La temporización básica en microcontroladores como STM32 es el "corazón" que dicta qué tan rápido piensa y actúa todo: relojes generan pulsos rítimicos para sincronizar CPU, timers, periféricos. Si no se entiende cómo funciona el tiempo interno, el resto (GPIO, comunicación, PWM, ADC, etc.) queda incompleto.


### ¿Qué es la temporización en un microcontrolador?
Un microcontrolador ejecuta instrucciones sincronizadas por un reloj (clock). Este reloj lo que hace es determinar: 
- Cada cuánto se ejecuta una instrucción
- Cada cuánto se incrementa un contador
- Cuándo se genera una interrupción
- La velocidad de los buses internos
En un STM32 el reloj puede venir de:
- Oscilador interno (HSI)
- Oscilador externo (HSE)
- PLL (multiplicador de frecuencia)
### Temporizadores (Timers) en STM32

Los STM32 tienen periféricos llamados **TIMx**.

Ejemplos típicos:
- TIM1, TIM2, TIM3…
- Basic timers (TIM6, TIM7)
- General purpose timers
- Advanced timers (para PWM complejo, motores, etc.)

Un timer básicamente es:
> Un contador que incrementa (o decrementa) con el reloj.

Cuando el contador llega a cierto valor:
- Se reinicia
- Puede generar una interrupción
- Puede cambiar el estado de un pin (PWM)
- Puede disparar ADC
- Puede sincronizar otros periféricos

### Entonces, ¿qué es la temporización básica?

Es usar un timer solo para:

- Generar retardos precisos
- Ejecutar tareas periódicas
- Generar interrupciones periódicas

Ejemplo clásico:  
Ejecutar una función cada 1 ms.

Eso es la base de:
- Sistemas en tiempo real
- Schedulers
- Control PID
- Sistemas embebidos industriales

### ¿Qué se debe tener en cuenta en microcontroladores? 
Es importante:
#### Frecuencia del sistema
Se debe saber: 
- A que frecuencia corre el MCU
- Que buses existen (AHB,APB1,APB2)
- Que timer esta conectado a que bus
#### Interruptores:
Cuando usas timers con interrupciones:
- Debes configurar NVIC
- Debes entender prioridades
- Debes evitar ISR pesadas

### Sensores / esclavos

Cada sensor tiene:
- Datasheet
- Protocolo (I2C, SPI, UART)
- Timing requirements

Por ejemplo:  
Un sensor I2C puede requerir:
- Máxima frecuencia de clock
- Tiempo mínimo entre lecturas
Eso no lo abstrae el microcontrolador automáticamente. Debemos de revisar
***
Luiego revisaremos esot en código, por ahora mucho texto jaja
# 2. Arquitectura ARM Cortex-M

Para empezar, vamos a empezar con que es la arquitectura ARM, y esta es un diseño de procesadores basado en la filosofía RISC (REduced Instruction Set Computer). A diferencia de la arquitectura x86 que es común en PC's de intel y AMD, ARM se centra en la eficiencia energética y la simplicidad, lo que permite que dispositivos funcionen con menos calor y consuman menos batería. 
- **Filosofía RISC:** Utiliza instrucciones simples que se ejecutan en pocos ciclos de reloj, lo que agiliza el procesamiento.
- **Bajo consumo:** Es ideal para dispositivos móviles, ya que requiere poca energía y refrigeración en comparación con los diseños tradicionales.
- **Modelo de licenciamiento:** La empresa [Arm Holdings](https://www.arm.com/architecture) no fabrica los chips físicos, sino que vende los "planos" (licencias) a empresas como **Apple, Qualcomm, Samsung y Huawei**, quienes personalizan el diseño para sus propios productos.

| Característica    | ARM (RISC)                     | x86 (CISC)                             |
| ----------------- | ------------------------------ | -------------------------------------- |
| **Instrucciones** | Simples y de tamaño fijo       | Complejas y de tamaño variable         |
| **Consumo**       | Muy bajo (ideal para baterías) | Elevado (requiere más refrigeración)   |
| **Uso común**     | Móviles, IoT, Laptops modernas | PCs de escritorio, servidores potentes |
Y ahora ¿qué es **cortex**? Esta es la marca bajo la cual la empresa ARM comercializa sus diseños de procesadores listos para ser usados, se divide en 4 familias: 
- **Cortex-A (Application):** Máxima potencia para apps y sistemas operativos (celulares y laptops).
- **Cortex-R (Real-time):** Respuesta instantánea y crítica (frenos de autos y módems).
- **Cortex-M (Microcontroller):** Ultra bajo consumo para tareas simples (sensores y relojes).
- **Cortex-X (eXtreme):** Máximo rendimiento puro, por encima de la serie A (gama alta premium).
## Arquitectura ARM Cortex-M
 

## Registros CPU (R0–R15)

## Stack pointer (MSP vs PSP)

## Vector table

## Excepciones

## NVIC

## Modos de operación

## SysTick

## Prioridades de interrupción

## Memoria Flash vs SRAM

## Mapa de memoria

# 3. Sistema de reloj

## HSI

## HSE

## PLL

## Prescalers

## AHB / APB buses

## Clock tree
Bibliografía:
https://www.youtube.com/watch?v=_oZTNCZbQ_M
## Frecuencia del core

## Frecuencia de periféricos

## Latencia de Flash

# 4. GPIO

## Input

## Output

## Alternate Function

## Analog mode

## Push-pull vs Open-drain

## Speed configuration

## EXTI (interrupciones externas)

# 5. Timers

## Timer básico

## Timer general

## Timer avanzado

## Prescaler

## Auto-reload register (ARR)

## Compare match

## PWM

## Input capture

## Output compare

## Encoder mode

# 6. Comunicación

## UART

## Baudrate

## Oversampling

## Frame format

## Parity

## Stop bits

## Blocking vs Interrupt vs DMA

## Buffer circular

## SPI

## Master / Slave

## CPOL / CPHA

## Full duplex

## Chip select

## I2C

## Addressing

## ACK/NACK

## Open-drain

## Pull-ups

## CAN

## Arbitration

## ID estándar / extendido

# 7. ADC / DAC

## ADC

## Resolución

## Sampling time

## Conversión continua

## Trigger externo

## DMA

## Calibración

## DAC

## Salida analógica

## Trigger

## Buffer interno

# 8. DMA

## Transferencias memoria-periférico

## Circular mode

## Prioridades

## Interacción con UART/ADC

# 9. Interrupciones

## Vector table

## NVIC

## Prioridades

## Latencia

## ISR bien escrita

## Problemas comunes (bloqueos)

# 10. HAL vs LL vs Bare Metal

## Qué es HAL

## Qué es LL

## Acceso directo a registros

## Ventajas y costos

## Overhead

# 11. Memoria y linker

## Stack vs Heap

## .data

## .bss

## .text

## Startup code

## Linker script

## Secciones de memoria

# 12. Ethernet

## MAC vs PHY

## RMII vs MII

## ARP

## IP

## TCP

## UDP

## DHCP

## lwIP

## Socket API

## MQTT encima de TCP

# 13. RTOS

## FreeRTOS

## Tasks

## Queues

## Mutex

## Semaphores

## Scheduling

# 14. Debug real

## SWD

## Breakpoints

## Watchpoints

## ITM

## Segger RTT

## Analizador lógico

## Osciloscopio

# 15. Consumo y modos de bajo consumo

## Sleep

## Stop

## Standby

## Wake-up sources

# 16. Buenas prácticas embedded

## No usar delay en producción

## Sistemas no bloqueantes

## State machines

## Diseño modular

## Gestión de errores

# Glosario:


| Palabra      | Descripción                                                                                                                                    |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| GPIO         | Pines de entrada y salida para señal digital (1,0)                                                                                             |
| P-MOS, N-MOS | Son **transistores** que funcionan como interruptores electrónicos controlados por el voltaje de tu GPIO                                       |
| VDD          | Pin de alimentación positiva                                                                                                                   |
| GND          | Tierra                                                                                                                                         |
| push-pull    | 1,0                                                                                                                                            |
| open-drain   | 0                                                                                                                                              |
| I2C          | Permite conectar **varios dispositivos** al mismo bus usando solo esos dos pines (protocolo de comunicación)                                   |
| ACK          | acknowledge, bit que dice "mensaje recibido"                                                                                                   |
| SDA          | cable de datos (serial data) bidireccional (maestro<->esclavos)                                                                                |
| ADC          | Convertidor analógico-digital (generalmente entrada)                                                                                           |
| DAC          | Convertidor digital-analógico (generalmente salida)                                                                                            |
| PULL-UP      | Mantiene entrada en **1** contra ruido y falsos positivos.                                                                                     |
| PULL-DOWN    | Mantiene entrada en **0** para evitar ruidos.                                                                                                  |
| HIGH         | 3.3V                                                                                                                                           |
| LOW          | 0V                                                                                                                                             |
| PWM          | Simula voltaje variable encendiendo y apagando el pin rápido                                                                                   |
| PID          | Algoritmo que **corrige errores** automáticamente para estabilizar una variable                                                                |
| MCU          | Velocidad del **reloj interno** que dicta cuántas instrucciones ejecuta por segundo.                                                           |
| BUS          | Autopista de datos para conectar procesador con periféricos                                                                                    |
| AHB          | Bus de alta velocidad (Memoria, DMA)                                                                                                           |
| DMA          | Es una técnica informática que permite a los dispositivos de hardware eludir la CPU al transferir datos directamente hacia y desde la memoria. |
| APB2         | Bus de periféricos rápidos (ADC, Timers avanzados)                                                                                             |
| APB1         | Bus periféricos lentos (I2C, UART, Timers básicos)                                                                                             |
| UART         | Comunicación serial simple y asíncrono de solo dos cables (tx/rx) \| sin timers como I2C                                                       |
| FPU          | Unidad de hardware para procesar números decimales velozmente                                                                                  |
| HAL          | Libreria de alto nivel para programar periféricos                                                                                              |
| CMSIS        | Estándar de bajo nivel para procesadores ARM.                                                                                                  |
| firmware     | programa que se ejecuta directamente sobre el hardware de un dispositivo embebido. \| software de bajo nivel que controla el hardware.         |
***

Detalles importantes

# STM32N6...
Vamos a hablar de esto. 

Primero hablemos de un proyecto generico, porque necesitamos entender cosas, puede esto ir por partes. 
![Pasted image 20260219214622.png](images/Pasted%20image%2020260219214622.png)

Esto es una arquitectura con separación de seguridad que nosotros obtenemos al generar el código de la placa que deseamos (STM32N657X0HxQ).

Primero: 
## Partes de un proyecto:
### .IOC
Este es el archivo de confituración de STM32CubeIDE / CubeMX

Ahi está: 
- Configuración de clocks
- Periféricos activados
- Pines
- Middleware
- TrustZone on/off
- Particionamiento Secure / NonSecure
Regla: 
 NO EDITAR A MANO, EDITAR DESDE EL EDITOR GRAFICO
#### Que es TrustZone?
Es una tecnologia de seguridad que divide el microcontrolador en dos mundos de ejecución aislados por hardware: 
```text
Secure World
Non-Secure world
```
Esto no es software, esto es una separación implementada en arquitectura CPU (Cortex-M)
Y según el datasheets: 
![Core_crotex.png](images/Core_crotex.png)
### Drivers
Aquí vive:
- HAL
- CMSIS
- Archivos del fabricante

Aquí nada se toca ya que es código generado o del fabricante
### FSBL
Esto significa First Stage Boot Loader

En STM32N6 con TrustZone: 
```text
ROM interna →  
FSBL →  (main)
Secure Application → (main)  
NonSecure Application (main)
```
El FSBL:
- Inicializa memoria
- Configura seguridad
- Define regiones Secure / NonSecure
- Salta a la aplicación Secure

Tampoco se debe tocar

### AppliSecure

Esta es la aplicación que corre en el mundo secure.

Aquí vive: 
- Código crítico
- Claves
- Configuración sensible
- Control de acceso a periféricos protegidos
Este código: 
- Puede llamar a funcionas NonSecure
- Decide qué expone.
### AppliNonSecure

Esta es la aplicación normal.
Aqui vive: 
- La lógica general
- Comunicación
- UI
- Sensores comunes
No puede acceder directamente a:
- Recursos marcados como Secure
- Memoria Secure
Al intentar hacerlo genera `HardFault.`

### Secure_nsclib:

NSC = Non Secure Callable

Es una libería puente.

Sirve para: 

Permitir que el mundo NonSecure llame funciones Secure.
Por ejemplo: 
Secure: 
```c
__attribute__((cmse_nonsecure_entry))
void Secure_DoSomething(void)
{
   // código protegido
}
```
Eso expone vía NSC. Sin esta liberaría no hay comunicación controlada entre mundos

### Resumen en forma de tabla: 
|Carpeta|Nivel de peligro|¿Tocar?|
|---|---|---|
|Drivers|Alto|No|
|FSBL|Muy alto|No|
|Secure_nsclib|Medio|Solo si sabes|
|AppliSecure|Medio|Si usas TrustZone|
|AppliNonSecure|Bajo|Sí|
|.ioc|Seguro|Desde GUI|
## Cómo corre El programa?

Tal como vimos existe dos main:
![Pasted image 20260220100354.png](images/Pasted%20image%2020260220100354.png)

El sistema siempre arranca en modo Secure. 
Segun la documentación podemos decir: 
El sistema arranca en el `main` de la aplicación segura, la cual prepara el entorno de seguridad y luego "lanza" la aplicación no segura, que comienza su propia ejecución desde su respectivo `main`

La secuencia real es: 
```text
Reset →
Vector table Secure →
main() de AppliSecure →
configuración →
salto a NonSecure →
main() de AppliNonSecure
```
Entonces:
- El `main()` de **AppliSecure es el primero y obligatorio**.
- El `main()` de **AppliNonSecure solo corre si el Secure lo permite**.
No hay ambigüedad.

Nosotros vemos en el código lo siguiente: 
```c fold=main.h
#include "secure_nsc.h" /* For export Non-secure callable APIs */
```
Luego vemos 
```c fold=main.c
static void NonSecure_Init(void)
{
  funcptr_NS NonSecure_ResetHandler;

  SCB_NS->VTOR = VTOR_TABLE_NS_START_ADDR;

  /* Set non-secure main stack (MSP_NS) */
  __TZ_set_MSP_NS((*(uint32_t *)VTOR_TABLE_NS_START_ADDR));

  /* Get non-secure reset handler */
  NonSecure_ResetHandler = (funcptr_NS)(*((uint32_t *)((VTOR_TABLE_NS_START_ADDR) + 4U)));

  /* Start non-secure state software application */
  NonSecure_ResetHandler();
}
```
Aqui observamos como se inicializa desde el Secure el NonSecure, y nuestro ayudante es el archivo en Secure_nsclib: 
```c fold=secure_nsc.h
#ifndef SECURE_NSC_H
#define SECURE_NSC_H

/* Includes ------------------------------------------------------------------*/
#include <stdint.h>

typedef enum
{
SECURE_FAULT_CB_ID     = 0x00U, /*!< System secure fault callback ID */
  IAC_ERROR_CB_ID       = 0x01U  /*!< Illegal access secure error callback ID */
} SECURE_CallbackIDTypeDef;
/* Exported constants --------------------------------------------------------*/
/* Exported macro ------------------------------------------------------------*/
/* Exported functions ------------------------------------------------------- */
void SECURE_RegisterCallback(SECURE_CallbackIDTypeDef CallbackId, void *func);

```
## PINES: 
Ya hablando más a detalle y según la documentación debemos mirar los pines, nosotros contamos con una distribución: VFBGA264 ballout, que es básicamente:
![Pasted image 20260220192024.png](images/Pasted%20image%2020260220192024.png)

De aqui tenemos una tabla que nos dice la descripción de los pines (ahora hablaremos de nombres): 

Entonces temos diferentes tipos de pines: 

|Abreviación|Significa|En palabras simples|
|---|---|---|
|S|Supply pin|Pin de alimentación (VDD, VSS). No programable.|
|I|Input only|Solo entrada. No puede sacar señal.|
|O|Output only|Solo salida.|
|I/O|Input/Output|Puede leer o escribir.|
|A|Analog|Conectado a ADC/DAC o función analógica.|
|TT|3.3V tolerant|Soporta 3.3V aunque el núcleo trabaje a menos.|
|RST|Reset|Pin de reinicio del chip.|

Estas abreviaciones  ...

Luego tenemos la estructura eléctrica del pin, una I/O structure:

|Sufijo|Qué significa|
|---|---|
|_a|Tiene switch analógico interno (conectado a VDDA)|
|_c|Puede manejar USB Type-C power delivery|
|_f|Soporta I2C Fast Mode+|
|_t|Función tamper activa en modo batería|
**Nota importante**

> “All I/Os are set as analog inputs during and after reset”

Esto es clave.
Cuando el micro arranca:
Todos los pines están en modo analógico.

¿Por qué?

- Menor consumo
- Evita corrientes indeseadas
- Evita conflicto eléctrico

Luego tú los configuras como:

- GPIO
- I2C
- SPI
- UART
- ADC
***
***
## Funciones del pin 

Ahora vamos a ver las funciones de pin: 

¿Qué significa?, por ejemplo, un pin físico PH8 no está conectado a una sola consta internamente. Tiene un multiplexor interno, esto significa: 
> El pin puede conectarse a distintos bloques del microcontrolador.
> Tú eliges cuál usar.

Qué tipos de funciones puede tener un pin?, hay 3 categorías reales a nivel práctico

### Funciones básicas
Estas son las que no conectan el pin a un periférico especial, es decir, todas las de GPIO: 
- **GPIO Input**
- **GPIO Output**
- **GPIO Analog**
- **GPIO Interrupt (EXTI)**

### Funciones alternativas

Luego tenemos las funciones Alternativas que se dividen en 16, F0 - F15. 
Estas funciones alternativas es un sistema cuyo mecanismo permite que un solo pin físico del microcontrolador STM32N6 se conecte internamente a diferentes módulos o bloques periféricos. Hay 16 posibles selecciones

Nos preguntamos: ¿Cómo funcionan las funciones alternativas?
Cada pin de entrada/salida (GPIO) tiene un multiplexor interno. Mediante la programación, puedes "enrutar" la señal del pin hacia un bloque específico (como un temporizador, una interfaz de comunicación o el sistema de depuración)

**Selección por hardware:** Para cada pin, se eligen 4 bits en los registros de configuración para decidir cuál de las 16 funciones estará activa.
**Independencia:** Si un pin no se usa para una función alterna, puede usarse como un GPIO estándar (entrada o salida digital)

#### Conexión por bloques (AF0 - AF15)

La documentación organiza las funciones según el bloque o periférico al que se conectan. Aquí podemos observar un pequeño resumen según la documentación: 
- **AFO - Sistema y control:** Se usa principalmente para funciones del sistema (SYS), señales de depuración (JTAG,SWD) y temporizadores básicos como el TIM1,TIM2,TIM16 y TIM17.
- **AF1 al AF3 - Temporizadores y Low Power:** Conectan con una amplia gama de temporizadores (TIM3,TIM4,TIM5,TIM8,TIM12,TIM15) y periféricos de bajo consumo como LPTIM1/2/3
- **AF4 al AF6 - Interfaces seriales (I2C/SPI/USART):** Estos bloques están dedicados a la comunicación. Permiten conecta los pines a módulos SPI (1 al 6), interfaces de audio I2S, y puertos USART/UART
- **AF7 al AF8 - Comunicación Avanzada y Audio:** Aquí se encuentran puertos USART adicionales (1,2,3,6,10), interfaces de audio serie (SAI2), y receptores de audio digital (SPDIFRX)
- **AF9 al AF12 - Almacenamiento, Gráficos y Memoria:** Estos se conectan a bloques de alto rendimiento como: 
	    ◦ **FDCAN1/2/3** (Redes industriales).
	    ◦ **SDMMC1/2** (Tarjetas SD/eMMC).
	    ◦ **FMC** (Controlador de memoria flexible para RAM/Flash externa).
	    ◦ **LCD-TFT** (Controlador de pantalla).
- **AF13 al AF14 - Multimedia:** Reservado para la interfaz de cámara digital (DCMI/PSSI) y señales adicionales del controlador de pantalla (LCD).
- **AF15 - Eventos del Sistema:** Generalmente se asocia con señales de salida de eventos (**EVENTOUT**) y funciones de monitoreo del sistema.

#### ¿Cómo se programa a nivel de registros?

Para configurar estas funciones en el código, se utilizan dos registros específicos por cada puerto de GPIO (puerto A, B, C, etc.):
1. **GPIOx_AFRL** **(Alternate Function Register Low):** Controla la selección de los pines **0 al 7** del puerto.
2. **GPIOx_AFRH** **(Alternate Function Register High):** Controla la selección de los pines **8 al 15** del puerto.

Cada pin tiene asignados **4 bits** en estos registros. Por ejemplo, si quieres que el pin PA0 funcione como la señal del temporizador TIM2_CH1, debes escribir el valor binario correspondiente a la **AF1** en los primeros 4 bits del registro `GPIOA_AFRL`.

#### Consideración de Seguridad

Dado que este microcontrolador soporta **TrustZone**, la configuración de estas funciones alternas puede restringirse. Es decir, puedes programar el sistema para que solo la aplicación segura (**AppliSecure**) tenga permiso para cambiar la función de ciertos pines críticos, protegiendo así el hardware contra modificaciones no autorizadas por parte del software no seguro

## Tipos de configuraciones de los PIN: 

### Multimedia y Pantalla (LTDC / DSI / DCMI / VENC / JPEG)

#### Controlador de Pantalla LTDC (LCD-TFT Display Controller)

|Señal|Función|Descripción Detallada|
|---|---|---|
|**LCD_CLK**|Reloj de píxel|Genera el reloj para sincronizar la transferencia de píxeles. Típicamente entre 5-33 MHz según resolución.|
|**LCD_HSYNC**|Sincronización horizontal|Indica el inicio de una nueva línea de píxeles. Permite resetear el contador horizontal del panel.|
|**LCD_VSYNC**|Sincronización vertical|Indica el inicio de un nuevo cuadro/fotograma. Resetea el contador vertical para comenzar una nueva imagen.|
|**LCD_DE**|Habilitación de datos|Activo durante la transmisión válida de píxeles. Distingue entre el área visible y los periodos de blanking.|
|**LCD_R[7:0]**|Canal Rojo|Hasta 8 bits por color (24 bits total) para paneles RGB888. Compatible con paneles RGB565 y RGB666.|
|**LCD_G[7:0]**|Canal Verde|El ojo humano es más sensible al verde, por eso suele tener más resolución en algunos formatos.|
|**LCD_B[7:0]**|Canal Azul|Completa la gama de colores de 16.7 millones de colores en modo 24 bits.|
**Características adicionales del LTDC:**

- Soporta múltiples capas (Layer 1 y Layer 2) con mezcla alpha blending por hardware
- Formatos de píxel: ARGB8888, RGB888, RGB565, ARGB1555, ARGB4444
- Look-Up Tables (LUTs) para paletas de color
- Interrupción por sincronización vertical (Vsync) para actualización sin tearing


#### Interfaz de Cámara DCMI / DCMIPP (Digital Camera Interface)
|Señal|Función|Detalles Técnicos|
|---|---|---|
|**DCMIPP_PIXCLK**|Reloj de píxel|Generado por el sensor de cámara. Captura datos en cada flanco (programable por flanco ascendente/descendente).|
|**DCMIPP_HSYNC**|Sincronización horizontal|Indica el inicio/fin de una línea de la imagen. Activo bajo o alto configurable.|
|**DCMIPP_VSYNC**|Sincronización vertical|Indica el inicio/fin de un cuadro completo. Fundamental para reconstruir la imagen.|
|**DCMI_D[13:0] / DCMIPP_D[13:0]**|Bus de datos|Modos de 8, 10, 12 o 14 bits. Soporta formatos YCbCr, RGB, RAW Bayer.|
**Novedades de DCMIPP (Pixel Pipeline):**

- Procesamiento en tiempo real: recorte, escalado, conversión de formato
- Estadísticas automáticas de imagen (histograma, balance de blancos)
- Detección de movimiento por hardware

#### Interfaz Paralela Sincrónica PSSI
| Señal            | Función               | Aplicación                                                                         |
| ---------------- | --------------------- | ---------------------------------------------------------------------------------- |
| **PSSI_PDCK**    | Reloj de datos        | Reloj para sincronizar la transferencia de datos paralelos. Hasta 50 MHz.          |
| **PSSI_DE**      | Habilitación de datos | Señal de control para indicar datos válidos en el bus.                             |
| **PSSI_RDY**     | Listo                 | Handshake para control de flujo. Indica que el receptor está listo para más datos. |
| **PSSI_D[15:0]** | Datos paralelos       | Bus de 8 o 16 bits para comunicación rápida con FPGAs, ADCs paralelos, o sensores. |

### Audio Digital (I2S / SAI / SPDIF / ADF / DFSDM)
#### Interfaz I2S (Inter-IC Sound)

|Señal|Función|Detalles|
|---|---|---|
|**I2Sx_CK**|Reloj serie (SCK)|Reloj continuo que sincroniza los bits. Frecuencia = frecuencia de muestreo × bits por canal × 2.|
|**I2Sx_WS**|Selección de palabra|Identifica el canal (izquierdo = 0, derecho = 1). Conmutación a la frecuencia de muestreo.|
|**I2Sx_SDI**|Entrada de datos serie|Recibe audio desde códecs, micrófonos digitales o DSPs.|
|**I2Sx_SDO**|Salida de datos serie|Transmite audio a amplificadores, DACs o auriculares.|
|**I2Sx_MCK**|Reloj maestro|Reloj de alta precisión (256× o 384× frecuencia de muestreo) para códecs que lo requieren.|
**Formatos I2S soportados:**

- Estándar I2S Philips (MSB justificado con desplazamiento de 1 bit)
- MSB Justificado (dato alineado con WS)
- LSB Justificado (alineación al final)
- PCM (sin WS, solo reloj y datos)

#### Interfaz SAI (Serial Audio Interface) - La más avanzada
|Señal|Función|Características|
|---|---|---|
|**SAIx_SCK_y**|Reloj serie|Reloj independiente para cada bloque A o B. Hasta 12.288 MHz.|
|**SAIx_FS_y**|Frame Sync|Sincronización de cuadro. Puede ser onda cuadrada o pulso.|
|**SAIx_SD_y**|Datos serie|Línea de datos para audio. Hasta 16 canales por bloque.|
|**SAIx_MCLK_y**|Reloj maestro|Salida de reloj para códecs externos. Múltiplo de la frecuencia de muestreo.|

**Flexibilidad del SAI:**

- Dos bloques independientes (A y B) que pueden trabajar en modo maestro/esclavo
- Soporta TDM (Time Division Multiplexing) hasta 16 canales
- Interfaces con I2S, AC'97, SPDIF, PCM
- Compatibilidad con DSP y procesamiento en coma flotante
#### Receptor SPDIF (Sony/Philips Digital Interface)

|Señal|Función|Descripción|
|---|---|---|
|**SPDIFRX1_INy**|Entrada SPDIF|Recibe audio digital óptico (TOSLINK) o coaxial. Soporta hasta 192 kHz/24 bits.|
|**SPDIFRX1_INVALID**|Invalid Frame|Indica errores en la trama recibida (opcional según implementación).|
**Datos transmitidos por SPDIF:**

- Audio digital codificado en biphase-mark (BMC)
- Información de canal (derechos de copia, énfasis, frecuencia de muestreo)
- Soporte para audio comprimido (Dolby Digital, DTS)

#### Filtro Digital de Audio ADF / MDF / DFSDM

| Señal                     | Función          | Aplicación                                                            |
| ------------------------- | ---------------- | --------------------------------------------------------------------- |
| **ADF1_SDIy / MDF1_SDIy** | Entrada de datos | Para micrófonos PDM (Pulse Density Modulation) de móviles y MEMS.     |
| **ADF1_CCKx**             | Reloj de salida  | Reloj configurable para micrófonos digitales (típicamente 1-3.2 MHz). |
| **DFSDM_CKOUT**           | Reloj maestro    | Control de múltiples micrófonos digitales.                            |
| **DFSDM_DATINy**          | Datos PDM        | Entrada de moduladores sigma-delta externos.                          |
**Procesamiento en DFSDM:**

- Filtros Sinc (CIC) configurables
- Decimación programable (de 16 a 128)
- Salida PCM de 16/24 bits
- Soporte para hasta 8 canales simultáneos

### Conectividad y Redes (Ethernet / USB / CAN / FDCAN)
#### Controlador Ethernet (MAC)

| Señal         | Función          | Detalles                                                                |
| ------------- | ---------------- | ----------------------------------------------------------------------- |
| **ETH1_MDC**  | Management Clock | Reloj para la interfaz de gestión MDIO. Máximo 2.5 MHz.                 |
| **ETH1_MDIO** | Management Data  | Línea de datos bidireccional para configurar el PHY. Pull-up requerido. |
**Modos MII (Media Independent Interface):**

|Señal MII|Función|
|---|---|
|**ETH1_MII_TX_CLK**|Reloj de transmisión (25 MHz para 100 Mbps, 2.5 MHz para 10 Mbps)|
|**ETH1_MII_TX_EN**|Habilitación de transmisión|
|**ETH1_MII_TXD[3:0]**|Datos de transmisión (nibble)|
|**ETH1_MII_RX_CLK**|Reloj de recepción|
|**ETH1_MII_RX_DV**|Datos válidos en recepción|
|**ETH1_MII_RXD[3:0]**|Datos de recepción|
|**ETH1_MII_CRS**|Carrier Sense - Detección de portadora|
|**ETH1_MII_COL**|Collision Detect - Detección de colisión|

**Modo RMII (Reduced MII) - El más usado:**

|Señal RMII|Función|
|---|---|
|**ETH1_RMII_REF_CLK**|Reloj de referencia de 50 MHz único|
|**ETH1_RMII_CRS_DV**|Carrier Sense + Data Valid combinados|
|**ETH1_RMII_TXD[1:0]**|Datos de transmisión (2 bits)|
|**ETH1_RMII_RXD[1:0]**|Datos de recepción (2 bits)|
|**ETH1_RMII_TX_EN**|Habilitación de transmisión|
|**ETH1_RMII_RX_ER**|Error de recepción|

**Modo RGMII (Reduced Gigabit MII) - Alta velocidad:**

|Señal RGMII|Función|
|---|---|
|**ETH1_RGMII_TX_CTL**|Control de transmisión (TX_EN + TX_ER combinados)|
|**ETH1_RGMII_RX_CTL**|Control de recepción (RX_DV + RX_ER combinados)|
|**ETH1_RGMII_TXD[3:0]**|Datos de transmisión (doble tasa de datos: rising/falling edge)|
|**ETH1_RGMII_RXD[3:0]**|Datos de recepción (doble tasa de datos)|
|**ETH1_RGMII_CLK**|Reloj de 125 MHz (para Gigabit)|

#### USB 2.0 High Speed / OTG

|Señal|Función|Características|
|---|---|---|
|**USB_OTGx_HS_DP**|D+ positivo|Línea diferencial positiva. Pull-up interno para identificar velocidad.|
|**USB_OTGx_HS_DM**|D- negativo|Línea diferencial negativa.|
|**USB_OTGx_ID**|Identification|Para modo OTG: corto a GND = Host, flotante = Device.|
|**USB_OTGx_VBUS**|Voltaje bus|Detección de 5V en el bus USB. Protección contra sobrevoltaje.|
|**USB_OTGx_SOF**|Start of Frame|Pulso de sincronización de 1 kHz para isócrono.|
**Modos USB soportados:**

- Full Speed (12 Mbps)
- High Speed (480 Mbps) - requiere PHY externo
- OTG (On-The-Go): puede actuar como Host o Device
- Soporte para 8 endpoints bidireccionales

#### USB Type-C Power Delivery (UCPD)
| Señal           | Función                 | Protocolo                                                            |
| --------------- | ----------------------- | -------------------------------------------------------------------- |
| **UCPD1_CC1**   | Configuration Channel 1 | Detecta orientación del cable y negocia voltajes (5V, 9V, 15V, 20V). |
| **UCPD1_CC2**   | Configuration Channel 2 | Igual que CC1 para el otro lado del conector.                        |
| **UCPD1_VCONN** | Voltaje para cable      | Alimenta chips en cables electrónicos (hasta 1W).                    |
**Capacidades PD:**

- Negociación bidireccional de potencia (Source/Sink)
- Mensajes estructurados por BMC (Biphase Mark Coding)
- Roles intercambiables dinámicamente (DRP - Dual Role Power)

#### CAN FD (Controller Area Network Flexible Data-Rate)

|Señal|Función|Diferencias con CAN clásico|
|---|---|---|
|**FDCANx_TX**|Transmisión|Salida al transceptor CAN (como PCA82C251, TJA1040).|
|**FDCANx_RX**|Recepción|Entrada desde el transceptor. Diferencial en el bus.|

**Mejoras de CAN FD:**

- **Datos más rápidos:** Hasta 8 Mbps en fase de datos (vs 1 Mbps clásico)
- **Payload mayor:** Hasta 64 bytes por trama (vs 8 bytes clásico)
- **Mejor integridad:** CRC más robusto
- Retrocompatible con CAN 2.0 (puede coexistir en la misma red)

### Memorias y Almacenamiento (FMC / XSPI / SDMMC / OSPI)
#### FMC (Flexible Memory Controller) - El más versátil

|Señal|Función|Dispositivos Soportados|
|---|---|---|
|**FMC_A[25:0]**|Bus de direcciones|Hasta 64MB por banco de memoria.|
|**FMC_D[31:0]**|Bus de datos|8, 16 o 32 bits según dispositivo.|
|**FMC_AD[15:0]**|Address/Data mux|Dirección y datos multiplexados para ahorrar pines.|
|**FMC_NE[4:1]**|Chip Select|Hasta 4 bancos independientes.|
|**FMC_NWE**|Write Enable|Estrobos de escritura (activo bajo).|
|**FMC_NOE**|Output Enable|Estrobos de lectura (activo bajo).|
|**FMC_NBL[3:0]**|Byte Enable|Habilita bytes específicos en bus de 32 bits.|

**Señales específicas para NOR/PSRAM:**

|Señal|Función|
|---|---|
|**FMC_NL (NADV)**|Address Latch - Dirección válida en bus mux|
|**FMC_NWAIT**|Wait - Extiende ciclos de acceso|

**Señales específicas para NAND:**

|Señal|Función|
|---|---|
|**FMC_NCE**|Chip Enable para NAND|
|**FMC_NWP**|Write Protect - Protección contra escritura|
|**FMC_INT**|Ready/Busy - Estado del dispositivo|

**Señales específicas para SDRAM:**

|Señal|Función|Timing Típico|
|---|---|---|
|**FMC_SDCLK**|Reloj SDRAM|Hasta 100-133 MHz|
|**FMC_SDNWE**|Write Enable para SDRAM|DQM (Data Mask)|
|**FMC_SDCKE[1:0]**|Clock Enable|Activa/desactiva reloj para ahorro energía|
|**FMC_NRAS**|Row Address Strobe|Activa dirección de fila|
|**FMC_NCAS**|Column Address Strobe|Activa dirección de columna|
|**FMC_BA[1:0]**|Bank Address|Selecciona banco interno (4 bancos típicos)|
#### Interfaz XSPI / Octo-SPI (eXpanded SPI)

| Señal                | Función               | Velocidad                                           |
| -------------------- | --------------------- | --------------------------------------------------- |
| **XSPIM_Px_CLK**     | Reloj serie           | Hasta 200 MHz (DDR - Double Data Rate)              |
| **XSPIM_Px_NCLK**    | Reloj inverso         | Para señales diferenciales en alta velocidad        |
| **XSPIM_Px_IO[7:0]** | Datos bidireccionales | 8 líneas de datos (de ahí "Octo" SPI)               |
| **XSPIM_Px_DQS**     | Data Strobe           | Señal de sincronización para DDR (como en HyperBus) |
| **XSPIM_Px_NCS**     | Chip Select           | Selección de dispositivo                            |

**Rendimiento XSPI:**

- Modo SDR (Single Data Rate): 1 bit/cycle × 8 líneas × 200 MHz = **200 MB/s**
- Modo DDR (Double Data Rate): 2 bits/cycle × 8 líneas × 200 MHz = **400 MB/s**
- Soporta memoria Flash, PSRAM, HyperRAM, MRAM

#### SDMMC (SD/MMC Card Interface)
| Señal             | Función       | Modo 1-bit           | Modo 4-bit    | eMMC              |
| ----------------- | ------------- | -------------------- | ------------- | ----------------- |
| **SDMMCx_CK**     | Reloj         | 0-50 MHz             | 0-50 MHz      | 0-200 MHz (HS200) |
| **SDMMCx_CMD**    | Comandos      | Bidireccional        | Bidireccional | Bidireccional     |
| **SDMMCx_D[7:0]** | Datos         | D0 solo              | D0-D3         | D0-D7             |
| **SDMMCx_CD**     | Card Detect   | Detección mecánica   | -             | -                 |
| **SDMMCx_WP**     | Write Protect | Protección escritura | -             | -                 |
**ipos soportados:**

- SDSC (hasta 2GB)
- SDHC (hasta 32GB)
- SDXC (hasta 2TB)
- eMMC 4.5/5.0/5.1
- MMCplus

### Temporizadores y PWM (TIM / LPTIM / HRTIM)

#### Temporizadores Avanzados (TIM1, TIM8, TIM20)

|Señal|Función|Capacidades|
|---|---|---|
|**TIMx_CH[1:4]**|Capture/Compare|PWM, medición de frecuencia, generación de ondas. Resolución de 16 bits.|
|**TIMx_CH[1:4]N**|Salidas complementarias|Para drivers de MOSFET/IGBT con dead-time programable.|
|**TIMx_BKIN**|Break Input|Entrada de fallo. Desactiva salidas en <100 ns.|
|**TIMx_BKIN2**|Segundo Break|Doble seguridad para aplicaciones críticas.|
|**TIMx_ETR**|External Trigger|Clock externo o reset por hardware.|
|**TIMx_COMB**|Combinación de canales|Para PWM trifásico o múltiples fases.|
#### Temporizadores de Bajo Consumo (LPTIM)

| Señal              | Función         | Consumo Típico                  |
| ------------------ | --------------- | ------------------------------- |
| **LPTIMx_IN[1:2]** | Entradas        | Pueden funcionar en STOP mode   |
| **LPTIMx_OUT**     | Salida PWM      | Mantiene señal en bajo consumo  |
| **LPTIMx_ETR**     | Trigger externo | Despierta el sistema desde STOP |
#### Temporizadores de Alta Resolución (HRTIM)
- **Resolución:** 217 ps (picosegundos)
- **Canales:** Hasta 6 canales con 10 salidas
- **Aplicaciones:** Fuentes conmutadas (SMPS), inversores solares, control motor avanzado


### Conversores Analógico-Digital (ADC / DAC / COMP / OPAMP)

#### ADC de 12/16 bits
| Señal                     | Función                | Características                                     |
| ------------------------- | ---------------------- | --------------------------------------------------- |
| **ADCx_IN[0:19]**         | Entradas analógicas    | Hasta 20 canales externos                           |
| **ADCx_INPy / ADCx_INNy** | Entradas diferenciales | Para mediciones de alta precisión                   |
| **VREF+ / VREF-**         | Referencia de voltaje  | Precisión determinada por estabilidad de referencia |
| **ADCx_EXT**              | Trigger externo        | Inicia conversión por hardware                      |
**Características ADC:**

- Resolución configurable: 6, 8, 10, 12, 14, 16 bits
- Modo scan: múltiples canales automáticos
- Inyectado: canales prioritarios
- DMA: transferencia automática a memoria
- Sobremuestreo: mejora SNR hasta 16 bits

#### DAC de 12 bits

| Señal             | Función            |                                   |
| ----------------- | ------------------ | --------------------------------- |
| **DACx_OUT[1:2]** | Salidas analógicas | Generación de formas de onda      |
| **DACx_TRIG**     | Trigger            | Sincronización con temporizadores |

#### Comparadores (COMP)
| Señal         | Función          |                                |
| ------------- | ---------------- | ------------------------------ |
| **COMPx_INP** | Entrada positiva | Voltaje a comparar             |
| **COMPx_INN** | Entrada negativa | Voltaje de referencia          |
| **COMPx_OUT** | Salida digital   | 0 si INP < INN, 1 si INP > INN |

#### Amplificadores Operacionales (OPAMP)

| Señal           | Función              | Modos                          |
| --------------- | -------------------- | ------------------------------ |
| **OPAMPx_VINP** | Entrada no inversora | PGA (amplificador programable) |
| **OPAMPx_VINM** | Entrada inversora    | Follower (seguidor)            |
| **OPAMPx_VOUT** | Salida               | Filtro activo                  |
### Interfaces de Comunicación Serial (I2C / SPI / USART / I3C)
#### I2C / I3C (Inter-Integrated Circuit)

| Señal            | I2C Estándar          | I3C (Mejorado)                   |
| ---------------- | --------------------- | -------------------------------- |
| **SCL**          | Reloj hasta 1 MHz     | Reloj hasta 12.5 MHz             |
| **SDA**          | Datos bidireccionales | Datos bidireccionales HDR        |
| **SMBA**         | SMBus Alert           | -                                |
| **SCL**, **SDA** | Pull-up requerido     | Push-pull en modo alta velocidad |
**Ventajas I3C:**

- Compatible con dispositivos I2C legacy
- In-band interrupts (sin línea extra)
- Hot-join: dispositivos pueden unirse dinámicamente
- Menor consumo (1.8V compatible)

#### SPI (Serial Peripheral Interface)
|Señal|Función|Modo Dúplex|
|---|---|---|
|**SPIx_SCK**|Reloj serie|Hasta 50 MHz (SDR) o 100 MHz (DDR)|
|**SPIx_MISO**|Master In Slave Out|Datos desde periférico|
|**SPIx_MOSI**|Master Out Slave In|Datos hacia periférico|
|**SPIx_NSS**|Chip Select|Selección de dispositivo|
#### USART / UART / LPUART
|Señal|USART|UART|LPUART|
|---|---|---|---|
|**TX**|Transmisión|Transmisión|Transmisión|
|**RX**|Recepción|Recepción|Recepción|
|**CK**|Reloj síncrono|-|-|
|**CTS**|Clear to Send|-|-|
|**RTS**|Request to Send|-|-|
|**SW**|SmartCard|-|-|
### Sistema y Depuración (SYS / DBG / RCC / PWR)
#### Depuración JTAG / SWD
| Señal          | JTAG             | SWD (Serial Wire)           |
| -------------- | ---------------- | --------------------------- |
| **JTMS/SWDIO** | JTAG Mode Select | Datos serie bidireccionales |
| **JTCK/SWCLK** | JTAG Clock       | Reloj serie                 |
| **JTDI**       | Datos entrada    | -                           |
| **JTDO**       | Datos salida     | -                           |
| **NJTRST**     | Reset TAP        | -                           |
#### Traza ETM (Embedded Trace Macrocell)
|eñal|Función|Ancho de banda|
|---|---|---|
|**TRACECLK**|Reloj de traza|Hasta 200 MHz|
|**TRACED[3:0]**|Datos de traza|Hasta 4 bits|
#### Relojes del Sistema
| Señal            | Función         | Frecuencia                 |
| ---------------- | --------------- | -------------------------- |
| **OSC_IN/OUT**   | Cristal HSE     | 4-26 MHz                   |
| **OSC32_IN/OUT** | Cristal LSE     | 32.768 kHz                 |
| **MCO1**         | Salida de reloj | HSI, HSE, LSI, LSE, SYSCLK |
| **MCO2**         | Salida de reloj | PLL, HSE, SYSCLK, PLLI2S   |
#### Control de Potencia y Seguridad

|Señal|Función|Uso|
|---|---|---|
|**WKUP[1:5]**|Wake-up|Despiertan desde STOP/STANDBY|
|**TAMP_IN**|Tamper input|Detecta manipulaciones físicas|
|**TAMP_OUT**|Tamper output|Borra RTC backup registers|
|**PVD_IN**|Power Voltage Detect|Monitor de voltaje|
#### Puertos de Depuración Avanzada
| Señal        | Función               |                                          |
| ------------ | --------------------- | ---------------------------------------- |
| **HDP[0:7]** | High-speed Debug Port | Observa señales internas en tiempo real  |
| **EVENTOUT** | Salida de eventos     | Sincronización entre cores o periféricos |

### RESUMEN GENERAL: 

1. Multimedia y Pantalla (LTDC / PSSI / DCMI / VENC)

Estas señales gestionan la salida de gráficos y la entrada de video:

• **LCD_CLK, LCD_HSYNC, LCD_VSYNC, LCD_DE**: Señales de reloj, sincronización y habilitación de datos para el controlador de pantalla LTDC.

• **LCD_Ry, LCD_Gy, LCD_By**: Canales de color (Rojo, Verde, Azul) para paneles de hasta 24 bits.

• **PSSI_PDCK, PSSI_DE, PSSI_RDY**: Reloj, habilitación de datos y señal de listo para la interfaz paralela sincrónica PSSI.

• **DCMIPP_PIXCLK, DCMIPP_HSYNC, DCMIPP_VSYNC**: Señales de la tubería de píxeles de la cámara digital para sincronización de imagen.

• **DCMI_Dx / DCMIPP_Dx**: Bus de datos de la interfaz de cámara (de 8 a 16 bits).

2. Audio Digital (I2S / SAI / SPDIF / ADF)

Señales especializadas en la transmisión y captura de audio:

• **I2Sx_CK, I2Sx_WS**: Reloj y selección de palabra (Word Select) para interfaces I2S.

• **I2Sx_SDI, I2Sx_SDO**: Entrada y salida de datos serie de audio.

• **I2Sx_MCK**: Reloj maestro de audio.

• **SAIx_SCK_y, SAIx_FS_y, SAIx_SD_y**: Reloj serie, sincronización de cuadro y datos serie para los bloques de la interfaz de audio SAI.

• **SAIx_MCLK_y**: Reloj maestro para periféricos de audio externos.

• **SPDIFRX1_INy**: Entradas para el receptor de audio digital SPDIF.

• **ADF1_SDIy, ADF1_CCKx**: Datos y reloj para el filtro de audio digital (micrófonos PDM).

3. Conectividad y Redes (Ethernet / USB / CAN)

• **ETH1_MDC, ETH1_MDIO**: Interfaz de gestión para el transceptor Ethernet (PHY).

• **ETH1_RMII_REF_CLK, ETH1_RGMII_TX_CTL, ETH1_MII_TX_EN**: Señales de control y reloj para los distintos modos físicos de Ethernet (RMII, MII, RGMII).

• **USB_OTGx_HS_DP, USB_OTGx_HS_DM**: Líneas de datos diferenciales de alta velocidad.

• **UCPD1_CC1, UCPD1_CC2**: Pines de configuración de canal para USB Type-C Power Delivery.

• **FDCANx_TX, FDCANx_RX**: Transmisión y recepción para redes CAN de alta velocidad.

4. Memorias y Almacenamiento (FMC / XSPI / SDMMC)

• **FMC_Ax, FMC_Dx / FMC_ADx**: Direcciones y bus de datos (multiplexado o no) para memorias externas.

• **FMC_NEx, FMC_NWE, FMC_NOE, FMC_NBLx**: Señales de habilitación de chip, escritura, lectura y máscara de bytes.

• **FMC_SDCLK, FMC_SDNWE, FMC_SDCKE, FMC_NRAS, FMC_NCAS**: Señales de control específicas para memorias SDRAM.

• **XSPIM_Px_IOy, XSPIM_Px_CLK, XSPIM_Px_DQSx**: Datos, reloj y estrobo de datos para interfaces Octo-SPI.

• **SDMMCx_Dx, SDMMCx_CK, SDMMCx_CMD**: Bus de datos, reloj y comandos para tarjetas SD y eMMC.

5. Control del Sistema y Depuración (SYS / RCC / PWR)

• **MCO1, MCO2**: Salidas de reloj maestro para monitoreo o para proveer reloj a otros chips.

• **JTMS-SWDIO, JTCK-SWCLK, JTDI, JTDO, NJTRST**: Pines para depuración mediante JTAG y Serial Wire Debug.

• **TRACEDx, TRACECLK**: Señales de traza de instrucción en tiempo real.

• **WKUPx**: Pines de despertar desde modos de ultra bajo consumo.

• **TAMP_INx, TAMP_OUTx**: Entradas y salidas de detección de intrusiones (Tamper).

• **EVENTOUT**: Salida de señales de eventos internos hacia pines externos.

• **HDPx**: Puertos de depuración de alta velocidad (**High-speed Debug Port**) para observar señales internas del SoC.


## Configuración de ethernet : 
El funcionamiento del Ethernet en este microcontrolador no consiste en una conexión directa al puerto RJ45, sino en una interfaz digital que comunica el controlador interno con un componente externo llamado **PHY (Physical Layer Transceiver)**. Es este chip PHY externo el que realiza la conversión eléctrica necesaria para conectarse físicamente al cable y al conector RJ45.

A continuación veremos cómo operan estos pines y por qué son necesarios:

1. El rol de los pines de Ethernet

El periférico interno del STM32N6 es un **Gigabit Media Access Control (GMAC)**, que gestiona el protocolo de datos (Capa 2 del modelo OSI). Para que los datos salgan al exterior, el microcontrolador utiliza sus pines para enviar y recibir señales digitales hacia el PHY mediante protocolos estandarizados:

• **MII (Media Independent Interface)**: Interfaz estándar para 10/100 Mbit/s que utiliza una mayor cantidad de pines.

• **RMII (Reduced MII)**: Una versión reducida que ahorra pines, muy común en diseños de 10/100 Mbit/s.

• **RGMII (Reduced Gigabit MII)**: La interfaz necesaria para alcanzar velocidades de **1 Gbit/s (Gigabit Ethernet)**.

2. Tipos de pines y sus funciones

Dentro de las configuraciones de pines que verás en las tablas de funciones alternas (como PF0, PF1, PG11, etc.), existen señales críticas:

• **Pines de Gestión (SMI):** Los pines **ETH1_MDC** y **ETH1_MDIO** se utilizan para que el microcontrolador configure y lea el estado del chip PHY externo (por ejemplo, para saber si el cable está conectado o a qué velocidad está operando).

• **Pines de Datos y Reloj:** Dependiendo del modo (RMII o RGMII), encontrarás pines como **ETH1_TXD[0:3]** para transmitir, **ETH1_RXD[0:3]** para recibir, y pines de reloj como **ETH1_RMII_REF_CLK** o **ETH1_RGMII_GTX_CLK**.

3. ¿Por qué usarías estas configuraciones?

Usarías los pines de Ethernet para integrar el microcontrolador en redes locales o industriales que requieran:

• **Alta velocidad:** Soporte de hasta **1000 Mbit/s** para transferencias masivas de datos.

• **Redes Sensibles al Tiempo (TSN):** El controlador soporta estándares TSN para aplicaciones industriales que requieren una sincronización extremadamente precisa.

• **Protocolos de Internet:** A través de middleware como **LwIP**, puedes implementar pilas completas de TCP/IP sobre esta interfaz física.

4. Configuración en Programación

Desde el punto de vista del software, la configuración se suele realizar en herramientas como **STM32CubeMX**, donde seleccionas el modo de interfaz (MII, RMII o RGMII). Esto asigna automáticamente los pines necesarios en los puertos GPIO con la función alterna correspondiente y permite configurar parámetros como la dirección MAC y los descriptores de DMA para que el periférico mueva datos directamente entre la memoria RAM y la red sin cargar excesivamente al procesador

# Bibliografia de STM32N6...:

- [Datasheet](https://www.st.com/resource/en/datasheet/stm32n657a0.pdf)
- [Manual de programación](https://www.st.com/resource/en/programming_manual/pm0273-stm32-cortexm55-mcus-programming-manual-stmicroelectronics.pdf)
- [ARM-Cortex-M (pg 109 -> )](https://www.disca.upv.es/aperles/arm_cortex_m3/llibre/libro-ARM-Cortex-M.pdf)
- 