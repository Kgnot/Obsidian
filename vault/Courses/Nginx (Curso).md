Encontramos a Nginx como un tipo de servidor web que nos manda o nos "sirve" información a nuestro navegador, si nosotros entramos a una página web como lo es Airbnb.
![Pasted image 20251026124608.png](images/Pasted%20image%2020251026124608.png)
Encontramos que el servidor web que nos ayuda a nosotros a obtener y visualizar todo ello es `nginx`, este servidor web actúa mediante un `reverse proxy` que es un servidor que se sitúa entre los clientes e Internet, interceptando las solicitudes y reenviándolas a los servidores web de origen. Pero también cumple el papel de ser un balanceador de cargas, es decir, redirigir las peticiones a diferentes servidores iguales cuyo propósito es mejorar el cuello de botella que generaría un solo servidor.

Otro propósito para `nginx` es la encriptación, es decir, cuando tenemos un servidor nosotros necesitamos que este tenga el protocolo de encriptación web `https`; sin embargo, al tener muchos servidores esto se vuelve algo tedioso, pero como `nginx` ya se comunica con cada uno de ellos solo es necesario que se use el `https` con `nginx`.

# Bibliografía: 
- [Curso YouTube](https://www.youtube.com/watch?v=9t9Mp0BGnyI)
