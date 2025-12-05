import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import 'register_screen.dart';
import 'menu_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _hasSavedCredentials = false;
  String? _errorMessage;

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

  // Verifica si existen credenciales guardadas
  Future<void> _checkSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString('saved_username');
    final savedPass = prefs.getString('saved_password');

    setState(() {
      _hasSavedCredentials = savedUser != null && savedPass != null;
    });
  }

  // BIOMETRÍA
  Future<void> _loginWithBiometrics() async {
    try {
      if (!_hasSavedCredentials) return;

      final canBio = await _localAuth.canCheckBiometrics;
      final supported = await _localAuth.isDeviceSupported();

      if (!canBio || !supported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Biometría no disponible")),
        );
        return;
      }

      final didAuth = await _localAuth.authenticate(
        localizedReason: "Usa tu huella o rostro para iniciar sesión",
      );

      if (!didAuth) return;

      final prefs = await SharedPreferences.getInstance();
      final savedUser = prefs.getString('saved_username');
      final savedPass = prefs.getString('saved_password');

      if (savedUser == null || savedPass == null) return;

      final result = await _authService.login(
        username: savedUser,
        password: savedPass,
      );

      if (result['success']) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MenuScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo usar biometría")),
      );
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

    setState(() => _isLoading = false);

    if (result['success']) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_username', username);
      await prefs.setString('saved_password', password);

      if (!mounted) return;
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
            colors: [
              Color(0xFF003366),
              Color(0xFF004488),
              Color(0xFF002244),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 10,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset("assets/icono/tech.gif",
                          height: 120, width: 120),

                      const SizedBox(height: 20),

                      const Text(
                        "Persistencia de Datos",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // USUARIO
                      TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        onTap: () {
                          _loginWithBiometrics(); // activa biometría al tocar
                        },
                        decoration: const InputDecoration(
                          labelText: "Usuario",
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.person, color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyanAccent, width: 2),
                          ),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "Ingresa tu usuario" : null,
                      ),

                      const SizedBox(height: 16),

                      // CONTRASEÑA
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white),
                          suffixIcon: IconButton(
                            color: Colors.white,
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.cyanAccent, width: 2),
                          ),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "Ingresa tu contraseña" : null,
                      ),

                      const SizedBox(height: 20),

                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),

                      const SizedBox(height: 20),

                      // BOTÓN LOGIN
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "Iniciar Sesión",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // BOTÓN BIOMÉTRICO (solo si existe usuario guardado)
                      if (_hasSavedCredentials)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _loginWithBiometrics,
                            icon: const Icon(Icons.fingerprint,
                                color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            label: const Text(
                              "Ingresar con Huella / Rostro",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: const Text(
                          "¿No tienes cuenta? Regístrate",
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
