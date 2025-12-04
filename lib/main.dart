import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PersistenciaDatosApp());
}

class PersistenciaDatosApp extends StatelessWidget {
  const PersistenciaDatosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistencia de Datos Local',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF003366),
        scaffoldBackgroundColor: const Color(0xFF003366),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003366),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const AuthCheckScreen(),
    );
  }
}

// VERIFICAR SI EXISTE SESIÓN
class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // OBTENER TOKEN GUARDADO
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('sessionToken');

    // VALIDAR TOKEN
    if (token != null && token.isNotEmpty) {
      final authService = AuthService();
      final isValid = await authService.validateToken(token);

      if (isValid && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MenuScreen()),
        );
        return;
      }
    }

    // IR A LOGIN SI NO HAY SESIÓN
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
