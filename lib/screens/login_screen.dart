import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'menu_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  final LocalAuthentication _localAuth = LocalAuthentication(); 

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  bool _hasSavedCredentials = false;

  @override
  void initState() {
    super.initState();
    _checkSavedCredentials();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ← AÑADIDO: Revisar si hay credenciales guardadas
  Future<void> _checkSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString('saved_username');
    final savedPass = prefs.getString('saved_password');

    setState(() {
      _hasSavedCredentials = (savedUser != null && savedPass != null);
    });
  }

  // ← AÑADIDO: Autenticación biométrica
  Future<void> _loginWithBiometrics() async {
    final canAuthenticate = await _localAuth.canCheckBiometrics;

    if (!canAuthenticate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometría no disponible')),
      );
      return;
    }

    final didAuthenticate = await _localAuth.authenticate(
      localizedReason: "Usa tu huella o rostro para iniciar sesión",
    );

    if (didAuthenticate) {
      final prefs = await SharedPreferences.getInstance();
      final savedUser = prefs.getString('saved_username');
      final savedPass = prefs.getString('saved_password');

      if (savedUser != null && savedPass != null) {
        final result =
            await _authService.login(username: savedUser, password: savedPass);

        if (result['success']) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MenuScreen()),
          );
        }
      }
    }
  }

  // LOGIN NORMAL
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final result = await _authService.login(
      username: username,
      password: password,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success']) {
      // ← AÑADIDO: Guardar credenciales para biometría
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_username', username);
      await prefs.setString('saved_password', password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MenuScreen()),
      );
    } else {
      setState(() => _errorMessage = result['message']);
    }
  }

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
              elevation: 8,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/icono/tech.gif",
                          height: 120, width: 120),

                      const SizedBox(height: 16),

                      const Text(
                        'Persistencia de Datos',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 32),

                      TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Usuario',
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(Icons.person, color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.cyanAccent),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Ingresa tu usuario' : null,
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(Icons.lock, color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyanAccent),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Ingresa tu contraseña' : null,
                      ),

                      const SizedBox(height: 24),

                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ← AÑADIDO: Botón biometría si existen credenciales
                      if (_hasSavedCredentials)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _loginWithBiometrics,
                            icon: const Icon(Icons.fingerprint, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            label: const Text(
                              "Ingresar con Huella / Rostro",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                      const SizedBox(height: 8),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: const Text(
                          "¿No tienes cuenta? Regístrate aquí",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
