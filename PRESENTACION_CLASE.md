# 🎓 Presentación en Clase: Persistencia de Datos

## Guía para Exponer el Proyecto

---

## 📋 Estructura de la Presentación (15-20 minutos)

### 1. Introducción (3 min)

**Qué presentar:**
- "Hoy vamos a ver dos implementaciones del mismo sistema de almacenamiento local"
- "Una en React + Next.js (web) y otra en Flutter (móvil)"
- "El ejemplo: una app que guarda el email del usuario"

**Mostrar:**
- Las dos apps corriendo lado a lado
- Guardar un email en ambas
- Cerrar y reabrir: el email sigue ahí

---

### 2. Conceptos Fundamentales (4 min)

#### ¿Qué es el Almacenamiento Local?

**Explica:**
- Es como una "caja de memoria" en el dispositivo
- Guarda información simple (texto, números)
- Persiste incluso después de cerrar la app
- No necesita internet

#### Ejemplos Cotidianos:
- "Recordar mi usuario" en login
- Tema oscuro/claro que elegiste
- Idioma de la app
- Tutorial que ya completaste

---

### 3. Demostración Práctica (5 min)

#### Demo en Vivo:

**Paso 1: React + Next.js**
\`\`\`javascript
// MOSTRAR EN VIVO (DevTools del navegador)
localStorage.setItem('userEmail', 'estudiante@ejemplo.com');
// Ver en Application > Local Storage

localStorage.getItem('userEmail');
// Muestra: "estudiante@ejemplo.com"

localStorage.removeItem('userEmail');
// Ya no existe
\`\`\`

**Paso 2: Flutter**
- Correr la app en un emulador
- Guardar email
- Mostrar en el log: `print('Email guardado: $email')`
- Detener la app completamente
- Volver a abrir: el email sigue ahí

---

### 4. Comparación Técnica (5 min)

#### Tabla Comparativa en Pizarra/Slides:

\`\`\`
┌─────────────────┬──────────────────┬─────────────────┐
│   Característica │  React/Next.js  │     Flutter     │
├─────────────────┼──────────────────┼─────────────────┤
│   API           │  localStorage    │ SharedPref...   │
│   Plataforma    │  Solo Web        │ iOS + Android   │
│   Sintaxis      │  Síncrona        │ Asíncrona       │
│   Velocidad     │  <1ms            │ ~10ms           │
└─────────────────┴──────────────────┴─────────────────┘
\`\`\`

#### Código Lado a Lado:

**Guardar:**
\`\`\`javascript
// React
localStorage.setItem('key', 'value');
\`\`\`

\`\`\`dart
// Flutter
final prefs = await SharedPreferences.getInstance();
await prefs.setString('key', 'value');
\`\`\`

**Recuperar:**
\`\`\`javascript
// React
const value = localStorage.getItem('key');
\`\`\`

\`\`\`dart
// Flutter
final value = prefs.getString('key');
\`\`\`

---

### 5. Ventajas y Desventajas (3 min)

#### localStorage (React/Next.js)

**✅ Ventajas:**
- Super simple de usar
- No necesita configuración
- Inmediato (síncrono)
- Perfecto para web

**❌ Desventajas:**
- Solo para navegadores web
- Vulnerable a XSS si no tienes cuidado
- Solo guarda strings
- ~5MB de límite

#### SharedPreferences (Flutter)

**✅ Ventajas:**
- Funciona en iOS, Android y Web
- Más seguro (aislado por app)
- Mejor arquitectura
- Performance nativa

**❌ Desventajas:**
- Más código (async/await)
- Requiere dependencia externa
- Curva de aprendizaje mayor

---

## 💡 Ejemplos Claros para la Clase

### Ejemplo 1: App de Música

**Escenario:** Spotify guarda tu volumen preferido

\`\`\`javascript
// Al cambiar volumen
localStorage.setItem('volume', '75');

// Al abrir la app
const savedVolume = localStorage.getItem('volume') || '50';
setVolume(savedVolume);
\`\`\`

### Ejemplo 2: App de Tareas

**Escenario:** Todoist recuerda tu última lista

\`\`\`dart
// Al cambiar de lista
await prefs.setString('lastList', 'Trabajo');

// Al abrir
final lastList = prefs.getString('lastList') ?? 'Personal';
\`\`\`

### Ejemplo 3: App de Noticias

**Escenario:** NO usar para guardar contraseñas

\`\`\`javascript
// ❌ NUNCA HAGAS ESTO
localStorage.setItem('password', '123456'); // INSEGURO

// ✅ Mejor: solo email/username
localStorage.setItem('username', 'usuario123');
\`\`\`

---

## 🎯 Preguntas Frecuentes (Anticipa estas)

### 1. "¿Por qué no usar base de datos?"

**Respuesta:**
- SharedPreferences/localStorage: datos simples (configuraciones)
- Base de datos (SQLite): datos complejos (listado de 1000 productos)

**Analogía:**
- Almacenamiento local = Post-it en tu escritorio
- Base de datos = Archivo Excel completo

---

### 2. "¿Los datos son seguros?"

**Respuesta:**
- No están encriptados por defecto
- En web: cualquier script puede leer
- En móvil: aislado por app (más seguro)
- **Nunca guardes contraseñas sin encriptar**

---

### 3. "¿Cuánto puedo guardar?"

**Respuesta:**
- Web (localStorage): ~5-10 MB
- Móvil (SharedPreferences): depende del dispositivo, pero no para datos grandes
- **Regla:** Si son más de 50 items complejos, usa base de datos

---

### 4. "¿Funciona sin internet?"

**Respuesta:**
- ¡Sí! Es 100% local
- No necesita conexión
- Ideal para apps offline-first

---

## 🛠️ Demostración Interactiva (Bonus)

### Actividad en Clase (5 min):

1. **Mostrar DevTools del navegador**
   - F12 > Application > Local Storage
   - Dejar que vean cómo se guardan los datos

2. **Experimento:**
   \`\`\`javascript
   // Pedir a la clase que abra la consola
   localStorage.setItem('miNombre', 'TuNombre');
   localStorage.getItem('miNombre'); // Ver su nombre
   \`\`\`

3. **Desafío:**
   - "Cierren el navegador completamente"
   - "Ábrelo de nuevo y ejecuten getItem()"
   - "¿Sigue ahí? ¡Eso es persistencia!"

---

## 📊 Cuándo Usar Cada Tecnología

### Usa localStorage si:
- App web
- Datos simples (preferencias)
- Desarrollo rápido
- Audiencia en computadoras

### Usa SharedPreferences si:
- App móvil (iOS/Android)
- Mejor arquitectura
- Performance nativa
- Multiplataforma

---

## 🎬 Cierre de la Presentación

### Resumen (2 min):

**Puntos Clave:**
1. Almacenamiento local = guardar datos simples en el dispositivo
2. React usa localStorage (web, síncrono, simple)
3. Flutter usa SharedPreferences (móvil, asíncrono, estructurado)
4. Ambos persisten entre sesiones
5. NO usar para datos sensibles sin encriptar

**Frase Final:**
"El almacenamiento local es perfecto para hacer que tu app 'recuerde' preferencias del usuario, pero para datos complejos o sensibles, necesitarás soluciones más robustas como bases de datos o almacenamiento en la nube."

---

## 📝 Checklist para la Presentación

- [ ] Código de ambos proyectos funcionando
- [ ] Slides con comparaciones
- [ ] DevTools abierto para demo en vivo
- [ ] Emulador de Flutter listo
- [ ] Ejemplos claros preparados
- [ ] Preguntas frecuentes memorizadas
- [ ] Backup: capturas de pantalla si algo falla

---

## 💻 Código para Demo Rápida

### En la Consola del Navegador:

\`\`\`javascript
// 1. Guardar
localStorage.setItem('demo', 'Hola Clase!');

// 2. Leer
console.log(localStorage.getItem('demo'));

// 3. Ver todos
for (let i = 0; i < localStorage.length; i++) {
  const key = localStorage.key(i);
  console.log(`${key}: ${localStorage.getItem(key)}`);
}

// 4. Eliminar
localStorage.removeItem('demo');

// 5. Limpiar todo
// localStorage.clear(); // ¡Cuidado!
\`\`\`

---

**Tiempo Total:** 15-20 minutos  
**Nivel:** Intermedio  
**Requiere:** Conocimientos básicos de React y Flutter  
**Material:** Código fuente, slides, navegador, emulador
