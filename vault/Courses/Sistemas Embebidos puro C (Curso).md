# 1. Fundamentos eléctricos y de señal
Una señal se define como la variación temporal de una magnitud física que se utiliza para codificar información. En el caso de una señal electrónica esa magnitud puede ser una corriente eléctrica, tensión o intensidad luminosa. 

La tensión o voltaje es la magnitud física que cuantifica la diferencia de potencial eléctrico entre dos puntos, y se mide en voltios(V).
La corriente o intensidad eléctrica es la cantidad de carga eléctrica que pasa por un conductor por unidad de tiempo y se mide en amperios (A).

Las señales pueden ser analógicas o digitales.
![[Pasted image 20260219143421.png]]
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
***

Detalles importantes

# STM32N6...
Vamos a hablar de esto. 

Primero hablemos de un proyecto generico, porque necesitamos entender cosas, puede esto ir por partes. 
![[Pasted image 20260219214622.png]]

Esto es una arquitectura con separación de seguridad que nosotros obtenemos al generar el código de la placa que deseamos (STM32N657X0HxQ).

Primero: 
# Partes de un proyecto:
## .IOC
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
### Que es TrustZone?
Es una tecnologia de segurodad que divide el microcontrolador en dos mundos de ejecución aislados por hardware: 
```text
Secure World
Non-Secure world
```
Esto no es software, esto es una separación implementada en arquitectura CPU (Cortex-M)
Y según el datasheets: 
![[Pasted image 20260219215120.png]]
## Drivers



# Bibliografia de STM32N6...:

- [Datasheet](https://www.st.com/resource/en/datasheet/stm32n657a0.pdf)
- [Manual de programación](https://www.st.com/resource/en/programming_manual/pm0273-stm32-cortexm55-mcus-programming-manual-stmicroelectronics.pdf)
- 