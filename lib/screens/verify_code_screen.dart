import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _codeController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // RED - VERIFICAR CÓDIGO DE CORREO
  Future<void> _handleVerify() async {
    if (_codeController.text.isEmpty) {
      setState(() => _errorMessage = 'Por favor ingresa el código');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final result = await _authService.verifyCode(
      email: widget.email,
      code: _codeController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success']) {
      setState(() => _successMessage = 'Email verificado correctamente');

      await Future.delayed(const Duration(seconds: 2));

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } else {
      setState(() => _errorMessage = result['message']);
    }
  }

  // RED - REENVIAR CÓDIGO
  Future<void> _handleResend() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final result = await _authService.resendCode(widget.email);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success']) {
      setState(() => _successMessage = 'Código reenviado correctamente');
    } else {
      setState(() => _errorMessage = result['message']);
    }
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.email_outlined,
                        size: 64, color: Color(0xFF003366)),

                    const SizedBox(height: 16),

                    const Text(
                      'Verifica tu Email',
                      style: TextStyle(
                        color: Color(0xFF003366),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Se envió un código a ${widget.email}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue.shade900),
                    ),

                    const SizedBox(height: 24),

                    // RED - CAMPO CÓDIGO
                    TextField(
                      controller: _codeController,
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 24,
                        letterSpacing: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(counterText: ''),
                    ),

                    const SizedBox(height: 24),

                    if (_errorMessage != null)
                      _buildMessage(_errorMessage!, Colors.red),

                    if (_successMessage != null)
                      _buildMessage(_successMessage!, Colors.green),

                    const SizedBox(height: 12),

                    // RED - BOTÓN VERIFICAR
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleVerify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003366),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Verificar Código'),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // RED - BOTÓN REENVIAR
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _handleResend,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFF003366), width: 2),
                        ),
                        child: const Text('Reenviar Código'),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Volver',
                        style: TextStyle(color: Color(0xFF003366)),
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

  // RED - WIDGET MENSAJE
  Widget _buildMessage(String msg, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 4)),
        color: color.withOpacity(0.1),
      ),
      child: Text(
        msg,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
