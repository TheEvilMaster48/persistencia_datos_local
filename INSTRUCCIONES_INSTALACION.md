# Sistema de Persistencia de Datos Local
## Instrucciones de Instalación y Uso

### Descripción
Este sistema demuestra el almacenamiento local de datos utilizando:
- **React + Next.js**: localStorage (equivalente a SharedPreferences en Flutter)
- **Verificación por email**: Envío de códigos a correo con asunto "Persistencia de Datos Local"
- **Autenticación completa**: Registro, login y menú principal

---

## Instalación

### 1. Instalar dependencias
\`\`\`bash
npm install
\`\`\`

### 2. Configurar variables de entorno
Crea un archivo `.env.local` en la raíz del proyecto con:

\`\`\`env
# SMTP GMAIL
SMTP_GMAIL_HOST=smtp.gmail.com
SMTP_GMAIL_PORT=587
SMTP_GMAIL_SECURE=false

# SMTP CREDENTIALS - Reemplaza con tus credenciales
EMAIL_USER=tu_email@gmail.com
EMAIL_PASSWORD=tu_contraseña_de_aplicacion
\`\`\`

**Importante**: Para Gmail, necesitas generar una "Contraseña de aplicación":
1. Ve a tu cuenta de Google → Seguridad
2. Activa la verificación en dos pasos
3. Genera una contraseña de aplicación
4. Usa esa contraseña en `EMAIL_PASSWORD`

### 3. Ejecutar el proyecto
\`\`\`bash
npm run dev
\`\`\`

Abre [http://localhost:3000](http://localhost:3000) en tu navegador.

---

## Flujo de Uso

### 1. Registro de Usuario
1. Abre la aplicación → "Regístrate aquí"
2. Completa el formulario:
   - Usuario
   - Email (recibirás el código aquí)
   - Teléfono
   - Contraseña (con botón ojo para visualizar)
   - Confirmar contraseña (con botón ojo para visualizar)
3. Haz clic en "Registrarse"
4. Se enviará un email con asunto "Persistencia de Datos Local - Código de Verificación"

### 2. Verificación de Email
1. Revisa tu correo y copia el código de 6 dígitos
2. Ingresa el código en la pantalla de verificación
3. Si el código es correcto, serás redirigido al login
4. Opciones adicionales:
   - "Reenviar Código" si no recibiste el email
   - "Volver" para cambiar los datos del registro

### 3. Inicio de Sesión
1. Ingresa tu usuario y contraseña
2. Puedes visualizar la contraseña con el icono del ojo
3. Si no verificaste tu email, verás un error
4. Al iniciar sesión correctamente, irás al menú principal

### 4. Menú Principal
El menú muestra:
- **Tu información**: Usuario y email
- **4 botones principales**:
  1. Base de Datos (azul)
  2. Documentos (verde)
  3. Configuración (morado)
  4. Cerrar Sesión (rojo)

---

## Características Técnicas

### Almacenamiento Local
El sistema utiliza **localStorage** del navegador para:
- Guardar usuarios registrados (`users_db`)
- Mantener sesiones activas (`sessionToken`)
- Persistir datos entre recargas de página

**Equivalencia con Flutter/Dart:**
\`\`\`javascript
// React/Next.js
localStorage.setItem('key', value)
localStorage.getItem('key')
localStorage.removeItem('key')
\`\`\`

\`\`\`dart
// Flutter
final prefs = await SharedPreferences.getInstance();
await prefs.setString('key', value);  // + commit()
prefs.getString('key');
prefs.remove('key');
\`\`\`

### Seguridad
- Contraseñas hasheadas con **bcryptjs**
- Tokens de sesión únicos
- Validación de email obligatoria
- Visualización opcional de contraseñas (Eye/EyeOff)

### Envío de Emails
- Utiliza **nodemailer** con SMTP de Gmail
- Asunto: "Persistencia de Datos Local - Código de Verificación"
- Código de 6 dígitos aleatorios
- Opción para reenviar código

---

## Estructura del Proyecto

\`\`\`
app/
├── api/auth/          # Endpoints de autenticación
│   ├── login/         # POST - Iniciar sesión
│   ├── register/      # POST - Registrar usuario
│   ├── verify-code/   # POST - Verificar código de email
│   ├── resend-code/   # POST - Reenviar código
│   ├── validate/      # POST - Validar token de sesión
│   └── logout/        # POST - Cerrar sesión
├── login/             # Página de inicio de sesión
├── register/          # Página de registro
├── menu/              # Menú principal (protegido)
├── page.tsx           # Redirección inicial
└── layout.tsx         # Layout con AuthProvider

lib/
├── auth-context.tsx   # Contexto de autenticación
└── query.ts           # Funciones de base de datos (localStorage)
\`\`\`

---

## Datos de Prueba

Puedes crear un usuario de prueba:
- **Usuario**: `demo_user`
- **Email**: Tu email real (para recibir el código)
- **Teléfono**: `+593 999999999`
- **Contraseña**: `123456`

---

## Próximos Pasos

Los 4 botones del menú están listos para agregar funcionalidad:
1. **Base de Datos**: CRUD de datos locales
2. **Documentos**: Gestión de archivos
3. **Configuración**: Preferencias del usuario
4. **Cerrar Sesión**: Ya funcional

---

## Notas Importantes

1. **localStorage** solo funciona en el navegador (lado del cliente)
2. Los datos se guardan en el navegador y persisten entre sesiones
3. Si borras los datos del navegador, perderás todos los usuarios registrados
4. El email debe ser válido para recibir el código de verificación
5. Las contraseñas se pueden visualizar haciendo clic en el ícono del ojo

---

## Diseño Visual

- **Fondo**: Azul marino degradado (estilo SERCOP)
- **Efectos**: Círculos de luz difuminados
- **Colores**: Azul marino (#003366), amarillo (#FFCC00)
- **Tipografía**: Clara y profesional
- **Interacciones**: Hover effects en botones

---

## Comparación React vs Flutter

| Característica | React + Next.js | Flutter |
|----------------|-----------------|---------|
| Almacenamiento | localStorage | SharedPreferences |
| Persistencia | Automática | Requiere commit() |
| Tipo de datos | String (JSON) | String, int, bool, etc. |
| Ámbito | Solo navegador | Dispositivo móvil |
| Límite | ~5-10MB | Sin límite específico |

---

Para cualquier duda o problema, revisa los logs en la consola del navegador (F12).
