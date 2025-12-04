import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  final TextEditingController _emailController = TextEditingController();
  
  String? _savedEmail;
  bool _isLoading = true;
  String _message = '';
  Color _messageColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  // Cargar email guardado al iniciar la app
  // Equivalente al useEffect en React
  Future<void> _loadSavedEmail() async {
    setState(() => _isLoading = true);
    
    final email = await _storageService.getEmail();
    
    setState(() {
      _savedEmail = email;
      if (email != null) {
        _emailController.text = email;
      }
      _isLoading = false;
    });
  }

  // Guardar email en SharedPreferences
  Future<void> _saveEmail() async {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      _showMessage('Por favor ingresa un email', Colors.white);
      return;
    }

    final success = await _storageService.saveEmail(email);
    
    if (success) {
      setState(() => _savedEmail = email);
      _showMessage('¡Email guardado exitosamente!', Colors.white);
    } else {
      _showMessage('Error al guardar email', Colors.white);
    }
  }

  // Eliminar email del almacenamiento
  Future<void> _clearEmail() async {
    final success = await _storageService.removeEmail();
    
    if (success) {
      setState(() {
        _savedEmail = null;
        _emailController.clear();
      });
      _showMessage('Email eliminado del almacenamiento', Colors.white);
    } else {
      _showMessage('Error al eliminar email', Colors.white);
    }
  }

  // Mostrar mensaje temporal
  void _showMessage(String message, Color color) {
    setState(() {
      _message = message;
      _messageColor = color;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _message = '');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                color: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header con icono
                      _buildHeader(),
                      const SizedBox(height: 24),
                      
                      // Mensaje de email guardado
                      if (_savedEmail != null) _buildSavedEmailBanner(),
                      
                      // Mensaje de estado
                      if (_message.isNotEmpty) _buildMessageBanner(),
                      
                      const SizedBox(height: 24),
                      
                      // Campo de email
                      _buildEmailField(),
                      
                      const SizedBox(height: 24),
                      
                      // Botones
                      _buildActionButtons(),
                      
                      const SizedBox(height: 32),
                      
                      // Análisis técnico
                      _buildTechnicalAnalysis(),
                      
                      const SizedBox(height: 16),
                      
                      // Footer
                      _buildFooter(),
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

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.email,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Almacenamiento Local',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'App de Correo con SharedPreferences',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8),
            border: const Border(
              left: BorderSide(
                color: Colors.white,
                width: 4,
              ),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📌 Ejemplo Práctico 1: SharedPreferences',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Esta app guarda tu correo localmente y lo muestra automáticamente al abrir.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSavedEmailBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(
            color: Colors.white,
            width: 4,
          ),
        ),
      ),
      child: Text(
        '✓ Email recuperado del almacenamiento local:\n$_savedEmail',
        style: const TextStyle(
          fontSize: 13,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMessageBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(
            color: Colors.white,
            width: 4,
          ),
        ),
      ),
      child: Text(
        _message,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Correo Electrónico',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'tu@correo.com',
            hintStyle: const TextStyle(color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.cyanAccent,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tu email se guardará en el almacenamiento local del dispositivo',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Guardar Email',
            icon: Icons.save,
            color: Colors.white,
            onPressed: _saveEmail,
            gradient: const LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
            ),
          ),
        ),
        if (_savedEmail != null) ...[
          const SizedBox(width: 12),
          CustomButton(
            text: 'Limpiar',
            icon: Icons.delete,
            color: Colors.white,
            onPressed: _clearEmail,
            isOutline: true,
          ),
        ],
      ],
    );
  }

  Widget _buildTechnicalAnalysis() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 Análisis Técnico',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _buildTechPoint(
            'setString() + await',
            'Guarda datos (equivale a commit())',
          ),
          _buildTechPoint(
            'getString()',
            'Recupera datos guardados',
          ),
          _buildTechPoint(
            'remove()',
            'Elimina un dato específico',
          ),
          _buildTechPoint(
            'Persistencia',
            'Datos permanecen entre sesiones',
          ),
          _buildTechPoint(
            'Uso ideal',
            'Configuraciones y preferencias simples',
          ),
        ],
      ),
    );
  }

  Widget _buildTechPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: ' = $description',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const Text(
      'Ejemplo Práctico de Persistencia Local - Flutter',
      style: TextStyle(
        fontSize: 11,
        color: Colors.white70,
      ),
      textAlign: TextAlign.center,
    );
  }
}
