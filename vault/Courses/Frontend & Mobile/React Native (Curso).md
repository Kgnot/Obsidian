---
type: course
status: en_progreso
tags: [course, React Native (Curso)]
date_started: 2024-05-20
---


# ¿Qué es React Native?

React Native es una plataforma de desarrollo (completa) para aplicaciones de escritorio, de celular o web. Está desarrollado por Meta (antes Facebook) en 2015.
React Native usa la misma biblioteca de React. La diferencia entre React Native y React es que React Native no usa el "React DOM", además de que React Native transforma el código de React a nativo con ciertos matices. https://reactnative.dev/

# ¿Qué es Expo?

Expo es el framework el cual recomienda el equipo de React Native, haciendo una comparativa, es el Next.js de React Native. https://expo.dev/

# Iniciar proyecto: 

Para hacer un proyecto debemos empezar con
```bash
npx create-expo-app@latest
```

Esto nos genera un proyecto de expo el cual es fácil de entender ya que es similar a react, o Next.js.

Debemos usar Android studio para usar un simulador virtual de android o usando el celular activando el depuracion de usb (que se encuentra dentro de las herramientas de desarrollador).

Sin embargo, creemos un proyecto desde cero: 

```bash
npx create-expo-app@ latest curso-react-native --template blank
```
Esto genera una carpeta mucho más limpia.

Sin `--template blank`: 
![Pasted image 20260127102819.png](images/Pasted%20image%2020260127102819.png)
Con `--template blank`:
![Pasted image 20260127102919.png](images/Pasted%20image%2020260127102919.png)
***
Como observamos es un lugar mucho más limpio para diseñar directamente. (Aunque tiene JS). 

Como dato importante, aqui en React Native no podemos usar las etiquetas HTML, es decir, no existe `div`, `a`, `head`, `body`, etc.

Dentro de la estructura y los contenedores (Layout)

| HTML (React Web) | React Native (Mobile) | Descripción |
| :--- | :--- | :--- |
| `<div>` | `<View>` | El contenedor universal. Se usa para agrupar elementos, dar padding, margins, colores de fondo, etc. Es como un `div` sin estilos por defecto. |
| `<span>` | `<Text>` | Se usa para envolver texto en línea o fragmentos de texto que necesitan estilos diferentes (como negritas o colores dentro de una frase). |
| `<section>`, `<article>`, `<header>`, `<footer>` | `<View>` | React Native no tiene componentes semánticos nativos equivalentes. Se usan `<View>` para todo, pero se les puede dar `accessibilityLabel` para mantener la semántica. |

Dentro del texto y la tipografía: 

| HTML (React Web) | React Native (Mobile) | Descripción |
| :--- | :--- | :--- |
| `<h1>` a `<h6>` | `<Text style={{fontSize: 30, fontWeight: 'bold'}}>` | No existen etiquetas de encabezado. Se usa `<Text>` con estilos de `fontSize` y `fontWeight`. |
| `<p>` | `<Text>` | Párrafo normal. |
| `<strong>` / `<b>` | `<Text style={{fontWeight: 'bold'}}>` | Texto en negrita. |
| `<i>` / `<em>` | `<Text style={{fontStyle: 'italic'}}>` | Texto en cursiva. |
| `<a>` | `<Text onPress={handlePress}>` | Para enlaces. En móvil no se usan URLs del mismo modo. Generalmente se usa `onPress` para navegar a otra pantalla o abrir el navegador. |
| `<label>` | `<Text>` | Generalmente un `<Text>` colocado antes de un input o usando `accessibilityLabel`. |

Con las imagenes y media: 

| HTML (React Web) | React Native (Mobile) | Descripción |
| :--- | :--- | :--- |
| `<img>` | `<Image />` | En Web la imagen es autocontenida. En Native, el componente `<Image />` requiere un estilo con `width` y `height` definidos explícitamente, o no se verá. |
| `<picture>` | `<ImageBackground>` | Se usa cuando quieres poner contenido encima de una imagen. |
| `<video>` | `<Video>` | Requiere librería externa (`react-native-video`). No viene en el core. |
| `<iframe>` | `<WebView>` | Requiere librería externa (`react-native-webview`). |

En formularios e inputs: 

| HTML (React Web) | React Native (Mobile) | Descripción |
| :--- | :--- | :--- |
| `<input type="text">` | `<TextInput />` | Caja de entrada de texto. Soporta propiedades como `placeholder`, `keyboardType`, `secureTextEntry` (para contraseñas). |
| `<textarea>` | `<TextInput multiline={true} />` | No existe etiqueta separada. Se usa el mismo `TextInput` con la propiedad `multiline`. |
| `<button>` | `<Button />` (o `<Pressable>`) | El `<Button />` de RN es muy básico y limitado visualmente. Lo común es usar `<Pressable>`, `<TouchableOpacity>` o `<TouchableHighlight>` para crear botones personalizados. |
| `<input type="checkbox">` | `<CheckBox />` (O `<Switch />`) | React Native **no** tiene un `CheckBox` en el núcleo actualmente. Se suele usar un Switch (de On/Off) o instalar una librería de terceros para checkboxes clásicos. |
| `<input type="radio">` | No existe | No hay componente nativo "radio button". Se suelen implementar manualmente usando Views y Touchables, o con librerías. |
| `<select>` / `<option>` | `<Picker />` | El `Picker` fue movido fuera del core. Ahora se usa la librería `@react-native-picker/picker`. O se usa un Modal con una lista personalizada. |
| `<form>` | `<View>` | No existe el tag form. Se utiliza un `<View>` contenedor y se maneja la lógica de envío presionando un botón con `onPress`. |
| `<hr>` | `<View style={styles.separator} />` | Se crea una View con una altura pequeña (ej. 1px) y un color de fondo. |

Con Listas y scroll:

| HTML (React Web) | React Native (Mobile) | Descripción |
| :--- | :--- | :--- |
| `<ul>`, `<ol>` | `<FlatList />` | Para listas largas o dinámicas. `FlatList` se encarga de renderizar solo lo que se ve en pantalla (virtualization) para no gastar memoria. |
| `<li>` | No existe | En `FlatList` se define la prop `renderItem` que devuelve cómo se ve cada ítem. |
| `<div style="overflow: scroll">` | `<ScrollView />` | Permite hacer scroll si el contenido supera la pantalla. **Ojo:** `ScrollView` renderiza TODO a la vez, así que si tienes 1000 items, usa `FlatList`. |
| - | `<SectionList />` | Similar a `FlatList` pero para listas agrupadas por secciones (con headers), algo muy común en apps iOS/Android que no tiene un equivalente directo en simple HTML. |

En temas de la navegación: 

| HTML (React Web) | React Native (Mobile) | Descripción |
| :--- | :--- | :--- |
| `<a href="...">` | `navigation.navigate(...)` | En Web se usa una URL. En Native se usa una biblioteca de navegación (como React Navigation) que apila pantallas. |
| `<Link>` | `<Link>` (de react-navigation) | Si usas la librería de navegación, existe un componente Link, pero la base es imperativa (funciones). |

*** 
Tal como observamos encontramos que React Native genera contenido de formas quizá más simple. Una comparativa de código: 
HTML: 
```jsx
<div className="card">
  <h2>Título</h2>
  <p>Descripción del producto.</p>
  <img src="logo.png" />
  <button onClick={handleClick}>Comprar</button>
</div>
```
React Native: 
```tsx
<View style={styles.card}>
  <Text style={styles.title}>Título</Text>
  <Text style={styles.description}>Descripción del producto.</Text>
  <Image source={require('./logo.png')} style={styles.image} />
  <Pressable style={styles.button} onPress={handlePress}>
    <Text style={styles.buttonText}>Comprar</Text>
  </Pressable>
</View>
```

***

>- LOS ELEMENTOS DE REACT NATIVE SON `FLEX` POR DEFECTO
>-  LOS ESTILOS SON DIRECTAMENTE EN `tsx` O `jsx`
>- PARA OBTENER IMÁGENES DE NUESTRO DIRECTORIO DEBEMOS IMPORTARLA, POR EJEMPLO:  `const icon = require('./assets/icon.png');` 
>- HAY PROPIEDADES ESPECÍFICAS PARA CADA DISPOSITIVO

El tema de los estilos llega a ser un poco molesto así que agregamos el linter de la siguiente manera: 
```bash
npx expo lint
npx expo install -- --save-dev prettier eslint-config-prettier eslint-plugin-prettier
```

# Rutas dinamicas y navegación


# Utilidades

## Scrolling

En estas primeras utilidades hablamos sobre el problema del `view`  y el `scroll` que no se puede realizar de forma inmediata, es decir: 
![Pasted image 20260127135810.png](images/Pasted%20image%2020260127135810.png)
Aqui observamos que el «Título» aparece en toda la zona superior y no hay scroll. 
Para el apartado del scroll tenemos el componente

```tsx
<ScrollView>
	<...>
		...
	</...>
</ScrollView>
```

Sin embargo, hay una mejor forma para ello, ya que no genera un buen rendimiento debido a que este componente es más para scroll en componentes más chicos, un carousel, etc.

El componente el cual es mejor es `<FlatList>`
### FlatList: 
https://reactnative.dev/docs/flatlist

Para utilizar el componente `<FlatList/>` debemos colocar los parámetros que recibe, los básicos son: 
```tsx
<FlatList
	data = {...datos}
	keyExtractor = {..por defecto busca el dato+id, o el dato+key, pero podemos pasarle una funcion lambda de como se extrae}
	renderItem={({item}) => <GameCard game ={item} />} // aqui debemos colocar el cómo se renderizará
/>
```

## Ajustar tamaño

Para arreglar el contenido "mal diseñado" hay un componente llamado `<SafeAreaView>`; sin embargo, este ya fue deprecado. El problema es que solo funciona en iOS, y no en Android.  Una mejor forma sería usando constantes de expo (que sigue sin ser la mejor). Instalamos: 
```bash
npx expo install expo-constants
```

Expo Constants es una dependencia que proporciona acceso a información clave de la aplicación, como la versión y los detalles del dispositivo. Esto es fundamental porque incluye constantes específicas que nos permiten obtener los datos necesarios que se muestran a continuación:
![Pasted image 20260127141704.png](images/Pasted%20image%2020260127141704.png)

Y lo que debemos hacer en código: 
```tsx
const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "start",
    paddingTop: Constants.statusBarHeight, // !IMPORTANTE!!!
  },
  ...
});
```

Y la tercera que es la que se suele utilizar es: 
```bash
npx expo install react-native-safe-area-context
```
Así que debemos envolver nuestra aplicación en un `provider` por lo que necesitamos un "Main" el cual será nuestro `App.js`: 

```tsx
import { StatusBar } from "expo-status-bar";
import { SafeAreaProvider } from "react-native-safe-area-context";
import { View, StyleSheet } from "react-native";
import { Main } from "./components/Main";

export default function App() {
  return (
    <SafeAreaProvider>
      <View style={styles.container}>
        <StatusBar style="dark" />
        <Main />
      </View>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#F5F7FA", // Coincide con el fondo de Main
  },
});

```

Aqui como podemos ver usamos el `<SafeAreaProvider>` Con este provider todos los componentes internos pueden usar `useSafeAreaInsets()` asi pues, podemos crear el componente `<Main/>` de la siguiente forma: 
```tsx
import {
  StyleSheet,
  Text,
  View,
  Image,
  Pressable,
} from "react-native";
import Constants from "expo-constants";
import { useSafeAreaInsets } from "react-native-safe-area-context";

const icon = require("../assets/icon.png");

export function Main() {
  const insets = useSafeAreaInsets();
    
  const handlePress = () => {
    console.log("Comprar");
  };

  return (
    <View style={[styles.container, { paddingTop: insets.top , paddingBottom: insets.bottom}]}>
      <View style={styles.card}>
        <View style={styles.imageContainer}>
             <Image source={icon} style={styles.image} resizeMode="contain" />
        </View>
        <Text style={styles.title}>Producto Premium</Text>
        <Text style={styles.description}>
          Disfruta de la máxima calidad con nuestro diseño minimalista y moderno. Perfecto para ti.
        </Text>
        
        <Pressable 
            style={({ pressed }) => [
              styles.button,
              pressed && styles.buttonPressed
            ]} 
            onPress={handlePress}
        >
          <Text style={styles.buttonText}>Comprar Ahora</Text>
        </Pressable>
      </View>
    </View>
  );
}
```
Y nuestro aplicativo termina viendose: 
![Pasted image 20260127152923.png](images/Pasted%20image%2020260127152923.png)

## Usar SVG: 

Primero que nada vamos a usar la siguiente página: https://react-svgr.com/playground/?native=true
Esto nos ayuda a pasar de SVG normal a componente de React Native : 
![Pasted image 20260127154815.png](images/Pasted%20image%2020260127154815.png)
Con esto ya entonces creamos el componente.

> Nota:
> Es necesario instalar `npx expo install react-native-svg`

## Animated: 
https://reactnative.dev/docs/animated

Un ejemplo del `animated` lo encontramos a la hora de querer ir para abjo y se "rendericen" mientras vamos avanzando, el código sería: 
```tsx
import { useEffect, useRef } from "react";
import { View, StyleSheet, Text, Image, Animated } from "react-native";

export function GameCard({ game }) {
  return (
    <View key={game.slug} style={styles.card}>
      <Image source={{ uri: game.image }} style={styles.image} />
      <Text style={styles.title}>{game.title}</Text>
      <Text style={styles.score}>{game.score}</Text>
      <Text style={styles.description}>{game.description}</Text>
    </View>
  );
}

export function AnimatedGameCard({ game, index }) {
  const opacity = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.timing(opacity, {
      toValue: 1,
      duration: 1000,
      delay: index * 250,
      useNativeDriver: true,
    }).start();
  }, [opacity, index]);

  return (
    <Animated.View style={{ opacity }}>
      <GameCard game={game} />
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: 42,
  },
  image: {
    width: 107,
    height: 147,
    borderRadius: 10,
  },
  title: {
    fontSize: 20,
    fontWeight: "bold",
    color: "#fff",
    marginTop: 10,
  },
  description: {
    fontSize: 16,
    color: "#eee",
  },
  score: {
    fontSize: 20,
    fontWeight: "bold",
    color: "green",
    marginBottom: 10,
  },
});
```

Lo especial lo encontramos en: 
```tsx
export function AnimatedGameCard({ game, index }) {
  const opacity = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.timing(opacity, {
      toValue: 1,
      duration: 1000,
      delay: index * 250,
      useNativeDriver: true,
    }).start();
  }, [opacity, index]);

  return (
    <Animated.View style={{ opacity }}>
      <GameCard game={game} />
    </Animated.View>
  );
}
```

Aqui le damos una duración, un delay, usamos el driver nativo para mayor eficiencia y usamos los efectos para renderizar. 