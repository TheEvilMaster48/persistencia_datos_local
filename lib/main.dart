import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SCREENS
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/brujula_screen.dart';
import 'screens/clima_screen.dart';
import 'screens/alertas_screen.dart';
import 'screens/altitud_screen.dart';

// SERVICES
import 'services/auth_service.dart';
import 'services/compass_service.dart';
import 'services/clima_service.dart';
import 'services/alertas_service.dart';
import 'services/altitud_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PersistenciaDatosApp());
}

class PersistenciaDatosApp extends StatelessWidget {
  const PersistenciaDatosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => CompassService()),
        Provider(create: (_) => ClimaService()),
        Provider(create: (_) => AlertasService()),
        Provider(create: (_) => AltitudService()),
      ],
      child: MaterialApp(
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

        routes: {
          '/login': (_) => const LoginScreen(),
          '/menu': (_) => const MenuScreen(),
          '/brujula': (_) => const BrujulaScreen(),
          '/clima': (_) => const ClimaScreen(),
          '/alertas': (_) => const AlertasScreen(),
          '/altitud': (_) => const AltitudScreen(),
        },
      ),
    );
  }
}

// VERIFICA SESIÓN ACTIVA
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('sessionToken');

    if (token != null && token.isNotEmpty) {
      final authService = AuthService();
      final isValid = await authService.validateToken(token);

      if (isValid && mounted) {
        Navigator.of(context).pushReplacementNamed('/menu');
        return;
      }
    }

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
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
