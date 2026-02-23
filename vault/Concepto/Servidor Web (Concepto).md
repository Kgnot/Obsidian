Para entender lo que son los servidores web debemos entrar en el apartado de la comunicación entre máquinas, es decir, todo lo relacionado con redes informáticas. Todo en redes sigue estrictamente el **modelo OSI** o la versión práctica: **TCP/IP**.


# Modelo OSI:
![Capas-modelo-OSI.png](images/Capas-modelo-OSI.png)
Aqui vemos el modelo OSI explicado por cada capa.
## Capa 1 - Fisica | Electrónica Analógica
La capa física no existen protocolos de software, solo existen lo que son las señales:
- electricidad (Ethernet)
- luz (fibra óptica)
- Radio (Wifi, 4G, 5G)
- Ondas electromagnéticas
Aqui no hay paquetes, no hay puerto tampoco hay bits semanticos. Aquí encontramos algunos protocolos fisicos para trasmitir la información
## Capa 2 - Enlace | Electrónica Dígital
Aquí aparecen protocolos de enlace. Esta es la responsable de:
- Encapsular datos en tramas
- Detectar errores
- Direcciones físicas (MAC address)
- Controlar el acceso al medio
- Formar redes locales
### Ehternet: 
Este es el estandar más usado en el mundo para LAN. 
#### **¿Qué es lo que define?** :
- Estructura de la trama
- Direcciones MAC
- Tipo de tráfico (campo Ethertype)
- Detección de colisiones
- Velocidades 10/100/1G/10G/40G/100G/400G
#### Ethernet frame: 
```raw
| Dest MAC | Src MAC | EtherType | DATA | FCS |
```
En Ethernet **siempre** se usa:
- **MAC source**
- **MAC destination**
Las tramas **no cruzan routers**.
## Capa3 - RED 
Aquí aparece **IP (Internet Protocol)**.
Es la capa más importante en Internet.
### Protocolos principales:
- **IPv4**
- **IPv6**

Pero hay más:
### Otros protocolos capa 3 reales
-  ICMP → mensajes de control (ping, time exceeded…)  
-  IGMP → multicast management  
- IPSec AH/ESP → cifrado de paquetes  
- Routing protocols (OSPF, RIP, BGP) → _también son capa 3_

IP ofrece:
- direccionamiento global
- ruteo entre redes
- fragmentación

Pero **no entrega datos confiables**
Por eso existe la capa superior: transporte.