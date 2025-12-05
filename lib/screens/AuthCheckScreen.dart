import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _startAuthProcess();
  }

  Future<void> _startAuthProcess() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString('saved_username');
    final savedPass = prefs.getString('saved_password');

    // NO HAY DATOS GUARDADOS → IR AL LOGIN
    if (savedUser == null || savedPass == null) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }

    // VERIFICAR BIOMETRÍA DISPONIBLE
    final canBio = await _localAuth.canCheckBiometrics;
    final supported = await _localAuth.isDeviceSupported();

    if (canBio && supported) {
      final didAuth = await _localAuth.authenticate(
        localizedReason: "Confirma tu identidad para continuar",
      );

      if (didAuth) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/menu');
        return;
      }
    }

    // SI FALLA → LOGIN
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
