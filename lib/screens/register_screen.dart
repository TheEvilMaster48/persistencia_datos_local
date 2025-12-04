import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'verify_code_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authService = AuthService();

  bool _loading = false;
  bool _passObscure = true;
  bool _confirmObscure = true;

  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // RED - REGISTRO
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Las contraseñas no coinciden');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final result = await _authService.register(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      telefono: _telefonoController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() => _loading = false);

    if (!result['success']) {
      setState(() => _errorMessage = result['message']);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyCodeScreen(
          email: _emailController.text.trim(),
        ),
      ),
    );
  }

  // RED - UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF003366), Color(0xFF004488), Color(0xFF002244)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Crear Cuenta",
                        style: TextStyle(
                          color: Color(0xFF003366),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // RED - USUARIO
                      _buildField(
                        controller: _usernameController,
                        label: "Usuario",
                        icon: Icons.person,
                      ),

                      const SizedBox(height: 16),

                      // RED - EMAIL
                      _buildField(
                        controller: _emailController,
                        label: "Correo Electrónico",
                        icon: Icons.email,
                        type: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 16),

                      // RED - TELÉFONO
                      _buildField(
                        controller: _telefonoController,
                        label: "Teléfono",
                        icon: Icons.phone,
                        type: TextInputType.phone,
                      ),

                      const SizedBox(height: 16),

                      // RED - CONTRASEÑA
                      _buildPasswordField(
                        controller: _passwordController,
                        label: "Contraseña",
                        obscure: _passObscure,
                        toggle: () =>
                            setState(() => _passObscure = !_passObscure),
                      ),

                      const SizedBox(height: 16),

                      // RED - CONFIRMAR CONTRASEÑA
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        label: "Confirmar Contraseña",
                        obscure: _confirmObscure,
                        toggle: () =>
                            setState(() => _confirmObscure = !_confirmObscure),
                      ),

                      const SizedBox(height: 24),

                      if (_errorMessage != null)
                        _buildError(_errorMessage!),

                      const SizedBox(height: 12),

                      // RED - BOTÓN REGISTRAR
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003366),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "Registrarse",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Ya tengo cuenta",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003366),
                          ),
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

  // RED - COMPONENTES
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: (v) => v == null || v.isEmpty ? "Campo requerido" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (v) => v == null || v.isEmpty ? "Campo requerido" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: toggle,
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: Colors.red, width: 4),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.red.shade900),
      ),
    );
  }
}
