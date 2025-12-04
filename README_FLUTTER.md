# Sistema de Persistencia de Datos Local - Flutter

## Próxima Fase: Implementación en Flutter

Este documento describe cómo implementar el mismo sistema en Flutter usando Dart y SharedPreferences.

---

## Estructura del Proyecto Flutter

\`\`\`
lib/
├── main.dart                          # Punto de entrada
├── models/
│   └── user_model.dart                # Modelo de usuario
├── services/
│   ├── storage_service.dart           # SharedPreferences
│   ├── auth_service.dart              # Autenticación
│   └── email_service.dart             # Envío de emails (API)
├── providers/
│   └── auth_provider.dart             # Estado de autenticación
├── screens/
│   ├── login_screen.dart              # Pantalla de login
│   ├── register_screen.dart           # Pantalla de registro
│   ├── verify_code_screen.dart        # Verificación de código
│   └── menu_screen.dart               # Menú principal
└── widgets/
    ├── custom_button.dart             # Botón personalizado
    ├── custom_input.dart              # Input personalizado
    └── password_input.dart            # Input con eye/eyeoff
\`\`\`

---

## Dependencias Necesarias

\`\`\`yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
  provider: ^6.1.1
  http: ^1.2.0
  crypto: ^3.0.3  # Para hashear contraseñas
\`\`\`

---

## Implementación de SharedPreferences

### storage_service.dart

\`\`\`dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  // Singleton
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Guardar usuario
  Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Obtener usuarios existentes
    List<Map<String, dynamic>> users = await getUsers();
    
    // Agregar nuevo usuario
    users.add(user);
    
    // Guardar en SharedPreferences
    await prefs.setString('users_db', jsonEncode(users));
  }

  // Obtener todos los usuarios
  Future<List<Map<String, dynamic>>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('users_db');
    
    if (usersJson == null) return [];
    
    List<dynamic> decoded = jsonDecode(usersJson);
    return decoded.cast<Map<String, dynamic>>();
  }

  // Guardar token de sesión
  Future<void> saveSessionToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sessionToken', token);
  }

  // Obtener token de sesión
  Future<String?> getSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionToken');
  }

  // Eliminar sesión
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionToken');
  }
}
\`\`\`

---

## Widget de Input con Eye/EyeOff

### password_input.dart

\`\`\`dart
import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String placeholder;

  const PasswordInput({
    Key? key,
    required this.controller,
    required this.label,
    required this.placeholder,
  }) : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF003366), width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: const Color(0xFF6B7280),
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
\`\`\`

---

## Pantalla de Login

### login_screen.dart (Vista previa)

\`\`\`dart
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF003366),
              Color(0xFF004488),
              Color(0xFF002244),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Persistencia de Datos Local',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sistema de Almacenamiento Local',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Inputs aquí...
                    
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Login logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
\`\`\`

---

## Diferencias Clave: React vs Flutter

### 1. Almacenamiento

**React (localStorage):**
\`\`\`javascript
localStorage.setItem('key', JSON.stringify(value));
const value = JSON.parse(localStorage.getItem('key'));
\`\`\`

**Flutter (SharedPreferences):**
\`\`\`dart
final prefs = await SharedPreferences.getInstance();
await prefs.setString('key', jsonEncode(value));
final value = jsonDecode(prefs.getString('key') ?? '');
\`\`\`

### 2. Gestión de Estado

**React (Context API):**
\`\`\`javascript
const { user, login, logout } = useAuth();
\`\`\`

**Flutter (Provider):**
\`\`\`dart
final authProvider = Provider.of<AuthProvider>(context);
authProvider.login(user);
\`\`\`

### 3. Navegación

**React (useRouter):**
\`\`\`javascript
const router = useRouter();
router.push('/menu');
\`\`\`

**Flutter (Navigator):**
\`\`\`dart
Navigator.pushReplacementNamed(context, '/menu');
\`\`\`

---

## Próximos Pasos para Flutter

1. Crear el proyecto Flutter: `flutter create persistence_app`
2. Instalar dependencias en `pubspec.yaml`
3. Implementar `StorageService` con SharedPreferences
4. Crear las pantallas (Login, Register, Verify, Menu)
5. Implementar el AuthProvider con Provider
6. Conectar con API para envío de emails
7. Probar en Android/iOS

---

## Recursos Adicionales

- [SharedPreferences Documentation](https://pub.dev/packages/shared_preferences)
- [Provider State Management](https://pub.dev/packages/provider)
- [Flutter HTTP Package](https://pub.dev/packages/http)

---

Este README será tu guía para implementar la versión Flutter del sistema.
