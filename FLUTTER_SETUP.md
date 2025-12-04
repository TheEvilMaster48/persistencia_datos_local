# Configuración de la Aplicación Flutter

## Sistema de Persistencia de Datos Local

Esta aplicación Flutter implementa un sistema completo de autenticación con almacenamiento local (SharedPreferences), Firebase y PostgreSQL.

## Requisitos Previos

1. **Flutter SDK** (versión 3.0.0 o superior)
2. **Firebase Project** configurado
3. **PostgreSQL** instalado y corriendo
4. **Android Studio** o **VS Code** con extensiones de Flutter

## Configuración de Firebase

### 1. Crear proyecto en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto llamado "Persistencia de Datos Local"
3. Habilita Firebase Authentication

### 2. Configurar Firebase para Android

\`\`\`bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase en el proyecto
flutterfire configure
\`\`\`

Esto creará automáticamente los archivos de configuración necesarios.

### 3. Configuración Manual (Alternativa)

Si prefieres configurar manualmente, crea el archivo `android/app/google-services.json` con tu configuración de Firebase.

## Configuración de PostgreSQL

### 1. Crear la base de datos

\`\`\`sql
CREATE DATABASE persistencia_local_db;
\`\`\`

### 2. Crear la tabla de usuarios

\`\`\`sql
CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  telefono VARCHAR(20),
  codigo_verificacion VARCHAR(6),
  email_verificado BOOLEAN DEFAULT FALSE,
  token_sesion VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
\`\`\`

### 3. Configurar credenciales

Las credenciales están en `lib/services/database_service.dart`:

\`\`\`dart
static const String host = 'localhost';
static const int port = 5432;
static const String database = 'persistencia_local_db';
static const String username = 'postgres';
static const String password = 'FfSantdmm,44';
\`\`\`

**IMPORTANTE:** En producción, usa variables de entorno para las credenciales.

## Configuración de Email (Gmail SMTP)

Las credenciales están en `lib/services/email_service.dart`:

\`\`\`dart
static const String emailUser = 'estkubiantiago16@gmail.com';
static const String emailPassword = 'lfwz taqk zbit qkkv';
\`\`\`

**Nota:** Necesitas habilitar "Aplicaciones menos seguras" o usar "Contraseñas de aplicación" en tu cuenta de Gmail.

## Instalación y Ejecución

### 1. Instalar dependencias

\`\`\`bash
flutter pub get
\`\`\`

### 2. Ejecutar la aplicación

\`\`\`bash
# Android
flutter run

# iOS
flutter run -d ios

# Web (no soportado por postgres package)
# flutter run -d chrome
\`\`\`

## Estructura del Proyecto

\`\`\`
lib/
├── main.dart                      # Punto de entrada
├── screens/
│   ├── login_screen.dart          # Pantalla de login
│   ├── register_screen.dart       # Pantalla de registro
│   ├── verify_code_screen.dart    # Verificación de email
│   └── menu_screen.dart           # Menú principal
└── services/
    ├── auth_service.dart          # Servicio de autenticación
    ├── database_service.dart      # Conexión PostgreSQL
    └── email_service.dart         # Envío de emails
\`\`\`

## Funcionalidades Implementadas

✅ Login con usuario y contraseña
✅ Registro de usuarios
✅ Verificación por email con código de 6 dígitos
✅ Visualización de contraseñas (eye/eyeoff)
✅ Almacenamiento local con SharedPreferences
✅ Conexión a PostgreSQL
✅ Envío de emails con Gmail SMTP
✅ Menú principal con 4 botones
✅ Cerrar sesión
✅ Diseño azul marino estilo SERCOP

## Flujo de Autenticación

1. **Registro:**
   - Usuario llena formulario
   - Se crea cuenta en PostgreSQL
   - Se envía código de verificación por email
   - Usuario ingresa código
   - Email queda verificado

2. **Login:**
   - Usuario ingresa credenciales
   - Se valida contra PostgreSQL
   - Se genera token de sesión
   - Se guarda en SharedPreferences
   - Acceso al menú principal

3. **Persistencia:**
   - Token guardado localmente
   - Auto-login en próximas aperturas
   - Validación de token al iniciar

## Notas de Seguridad

⚠️ **IMPORTANTE:**
- Las credenciales están hardcodeadas solo para desarrollo
- En producción, usa variables de entorno
- Implementa HTTPS para todas las conexiones
- Usa bcrypt o argon2 para hashear contraseñas
- Implementa rate limiting para prevenir ataques
- Agrega JWT con expiración para tokens

## Troubleshooting

### Error de conexión a PostgreSQL

\`\`\`bash
# Verificar que PostgreSQL esté corriendo
pg_isready

# Verificar credenciales
psql -U postgres -d persistencia_local_db
\`\`\`

### Error al enviar emails

1. Verifica que las credenciales de Gmail sean correctas
2. Habilita "Aplicaciones menos seguras" o usa "Contraseñas de aplicación"
3. Verifica tu conexión a internet

### Error de Firebase

\`\`\`bash
# Reconfigurar Firebase
flutterfire configure

# Verificar google-services.json existe
ls android/app/google-services.json
\`\`\`

## Próximos Pasos

- Implementar funcionalidades de los 4 botones del menú
- Agregar gestión de datos locales
- Agregar sincronización con la nube
- Implementar configuraciones de usuario
- Agregar recuperación de contraseña
- Implementar refresh tokens
