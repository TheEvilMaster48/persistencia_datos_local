# 📧 Email Storage App - Flutter

## Ejemplo Práctico 1: Almacenamiento Local

Esta aplicación demuestra el uso de **SharedPreferences** en Flutter para almacenamiento local persistente, similar a **localStorage** en aplicaciones web.

## 🎯 Características

- ✅ Guardar email en almacenamiento local
- ✅ Recuperar email automáticamente al abrir la app
- ✅ Eliminar email del almacenamiento
- ✅ Interfaz moderna y atractiva
- ✅ Mensajes de feedback al usuario

## 🏗️ Estructura del Proyecto

\`\`\`
lib/
├── main.dart                    # Punto de entrada de la app
├── screens/
│   └── home_screen.dart        # Pantalla principal
├── services/
│   └── storage_service.dart    # Servicio de almacenamiento local
└── widgets/
    └── custom_button.dart      # Botón personalizado reutilizable
\`\`\`

## 📊 Análisis Técnico

### SharedPreferences vs localStorage

| Flutter (SharedPreferences) | Web (localStorage) | Descripción |
|----------------------------|-------------------|-------------|
| `setString(key, value)` | `setItem(key, value)` | Guardar dato |
| `getString(key)` | `getItem(key)` | Recuperar dato |
| `remove(key)` | `removeItem(key)` | Eliminar dato |
| `clear()` | `clear()` | Limpiar todo |

### Ventajas de SharedPreferences

- ✅ Persistencia entre sesiones
- ✅ Fácil de usar y configurar
- ✅ No requiere permisos especiales
- ✅ Ideal para datos simples (strings, ints, bools, doubles)
- ✅ Multiplataforma (iOS, Android, Web)

### Limitaciones

- ❌ No apto para datos grandes
- ❌ No encripta datos por defecto
- ❌ Solo tipos de datos primitivos
- ❌ No tiene búsqueda avanzada

## 🚀 Instalación y Uso

### 1. Instalar dependencias

\`\`\`bash
flutter pub get
\`\`\`

### 2. Ejecutar la aplicación

\`\`\`bash
flutter run
\`\`\`

## 📦 Dependencias

- **shared_preferences**: ^2.2.2 - Almacenamiento de preferencias clave-valor

## 🔍 Casos de Uso Ideales

1. **Preferencias de usuario** (tema, idioma, notificaciones)
2. **Datos de sesión** (email, nombre de usuario)
3. **Configuraciones de la app**
4. **Flags de primera vez** (tutorial completado, bienvenida)
5. **Cachés simples** (última fecha de sincronización)

## 📝 Notas Importantes

- Los datos se guardan localmente en el dispositivo
- Persisten incluso después de cerrar la app
- Se pierden al desinstalar la aplicación
- No usar para datos sensibles sin encriptación