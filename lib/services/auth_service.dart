import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_service.dart';
import 'email_service.dart';

class AuthService {
  final DatabaseService _db = DatabaseService.instance;
  final EmailService _emailService = EmailService();

  // REGISTRO
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String telefono,
    required String password,
  }) async {
    try {
      final exist = await _db.getUserByEmail(email);
      if (exist != null) {
        return {'success': false, 'message': 'El correo ya está registrado'};
      }

      final code = _generateVerificationCode();
      final hash = _hash(password);

      await _db.createUser(
        username: username,
        email: email,
        passwordHash: hash,
        telefono: telefono,
        verificationCode: code,
      );

      await _emailService.sendVerificationEmail(email: email, code: code);

      return {
        'success': true,
        'message': 'Registro exitoso. Revisa tu correo.',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // LOGIN
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final user = await _db.getUserByUsername(username);

    if (user == null) {
      return {'success': false, 'message': 'Usuario o contraseña incorrectos'};
    }

    if (user['email_verificado'] == 0) {
      return {'success': false, 'message': 'Debes verificar tu correo'};
    }

    if (_hash(password) != user['password_hash']) {
      return {'success': false, 'message': 'Usuario o contraseña incorrectos'};
    }

    final token = _generateToken();
    await _db.saveUserToken(user['id'], token);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sessionToken', token);
    prefs.setString('username', user['username']);
    prefs.setString('email', user['email']);

    return {'success': true, 'token': token};
  }

  // VERIFICACIÓN DE CÓDIGO
  Future<Map<String, dynamic>> verifyCode({
    required String email,
    required String code,
  }) async {
    final user = await _db.getUserByEmail(email);

    if (user == null) {
      return {'success': false, 'message': 'Usuario no encontrado'};
    }

    if (user['codigo_verificacion'] != code) {
      return {'success': false, 'message': 'Código incorrecto'};
    }

    await _db.markEmailAsVerified(email);

    return {'success': true, 'message': 'Correo verificado'};
  }

  // REENVIAR CODIGO
  Future<Map<String, dynamic>> resendCode(String email) async {
    final user = await _db.getUserByEmail(email);

    if (user == null) {
      return {'success': false, 'message': 'Usuario no encontrado'};
    }

    final newCode = _generateVerificationCode();
    await _db.updateVerificationCode(email, newCode);

    await _emailService.sendVerificationEmail(email: email, code: newCode);

    return {'success': true, 'message': 'Código reenviado correctamente'};
  }

  // VALIDAR TOKEN
  Future<bool> validateToken(String token) async {
    final user = await _db.getUserByToken(token);
    return user != null;
  }

  // LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("sessionToken");

    if (token != null) {
      await _db.clearUserToken(token);
    }

    await prefs.clear();
  }

  // UTILIDADES
  String _hash(String value) {
    return sha256.convert(utf8.encode(value)).toString();
  }

  String _generateToken() {
    return sha256
        .convert(utf8.encode(DateTime.now().millisecondsSinceEpoch.toString()))
        .toString();
  }

  String _generateVerificationCode() {
    return (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
  }
}
