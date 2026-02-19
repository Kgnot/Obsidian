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

## Señal analógica

## Pull-up / Pull-down

## Niveles lógicos 3.3V

## Impedancia

## Ruido y filtrado

## Conversión nivel lógico (level shifting)

## Temporización básica

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

# Orden recomendado de estudio

1. Arquitectura Cortex-M
2. Relojes
3. GPIO
4. Timers
5. UART
6. Interrupciones
7. ADC
8. DMA
9. Memoria / linker
10. Ethernet