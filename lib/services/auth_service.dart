import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_service.dart';
import 'email_service.dart';

class AuthService {
  final DatabaseService _db = DatabaseService();
  final EmailService _emailService = EmailService();

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String telefono,
    required String password,
  }) async {
    try {
      // Verificar si el email ya existe
      final existingUser = await _db.getUserByEmail(email);
      if (existingUser != null) {
        return {'success': false, 'message': 'El correo ya está registrado'};
      }

      // Generar código de verificación
      final code = _generateVerificationCode();
      
      // Hash de la contraseña
      final passwordHash = _hashPassword(password);
      
      // Crear usuario en la base de datos
      await _db.createUser(
        username: username,
        email: email,
        passwordHash: passwordHash,
        telefono: telefono,
        verificationCode: code,
      );

      // Enviar email con código de verificación
      await _emailService.sendVerificationEmail(
        email: email,
        code: code,
      );

      return {
        'success': true,
        'message': 'Registro exitoso. Revisa tu correo.',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error interno: $e'};
    }
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final user = await _db.getUserByUsername(username);
      
      if (user == null) {
        return {'success': false, 'message': 'Usuario o contraseña incorrectos'};
      }

      if (user['email_verificado'] != true) {
        return {
          'success': false,
          'message': 'Debes verificar tu correo antes de iniciar sesión'
        };
      }

      // Verificar contraseña
      final passwordMatch = _verifyPassword(password, user['password_hash']);
      if (!passwordMatch) {
        return {'success': false, 'message': 'Usuario o contraseña incorrectos'};
      }

      // Generar o recuperar token
      final token = user['token_sesion'] ?? _generateToken();
      await _db.saveUserToken(user['id'], token);

      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sessionToken', token);
      await prefs.setString('username', user['username']);
      await prefs.setString('email', user['email']);

      return {
        'success': true,
        'token': token,
        'username': user['username'],
        'email': user['email'],
        'message': 'Sesión iniciada correctamente',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error interno: $e'};
    }
  }

  Future<Map<String, dynamic>> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      final user = await _db.getUserByEmail(email);
      
      if (user == null) {
        return {'success': false, 'message': 'Usuario no encontrado'};
      }

      if (user['codigo_verificacion'] != code) {
        return {'success': false, 'message': 'Código incorrecto'};
      }

      await _db.markEmailAsVerified(email);

      return {'success': true, 'message': 'Email verificado correctamente'};
    } catch (e) {
      return {'success': false, 'message': 'Error interno: $e'};
    }
  }

  Future<Map<String, dynamic>> resendCode(String email) async {
    try {
      final user = await _db.getUserByEmail(email);
      
      if (user == null) {
        return {'success': false, 'message': 'Usuario no encontrado'};
      }

      final newCode = _generateVerificationCode();
      await _db.updateVerificationCode(email, newCode);
      await _emailService.sendVerificationEmail(email: email, code: newCode);

      return {'success': true, 'message': 'Código reenviado correctamente'};
    } catch (e) {
      return {'success': false, 'message': 'Error interno: $e'};
    }
  }

  Future<bool> validateToken(String token) async {
    try {
      final user = await _db.getUserByToken(token);
      return user != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('sessionToken');
    
    if (token != null) {
      await _db.clearUserToken(token);
    }
    
    await prefs.clear();
  }

  // Utilidades privadas
  String _generateVerificationCode() {
    return (100000 + (999999 - 100000) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).floor().toString();
  }

  String _generateToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final bytes = utf8.encode(timestamp);
    return sha256.convert(bytes).toString();
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  bool _verifyPassword(String password, String hash) {
    return _hashPassword(password) == hash;
  }
}
