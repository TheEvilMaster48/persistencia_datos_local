import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para manejar el almacenamiento local con SharedPreferences
/// Equivalente a localStorage en React/Next.js
class StorageService {
  static const String _emailKey = 'userEmail';

  /// Guardar email en SharedPreferences
  /// Equivalente a: localStorage.setItem('userEmail', email)
  Future<bool> saveEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // putString() + await actúa como putString() + commit() en Android nativo
      return await prefs.setString(_emailKey, email);
    } catch (e) {
      print('Error al guardar email: $e');
      return false;
    }
  }

  /// Recuperar email desde SharedPreferences
  /// Equivalente a: localStorage.getItem('userEmail')
  Future<String?> getEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // getString() recupera el valor guardado, null si no existe
      return prefs.getString(_emailKey);
    } catch (e) {
      print('Error al recuperar email: $e');
      return null;
    }
  }

  /// Eliminar email del almacenamiento
  /// Equivalente a: localStorage.removeItem('userEmail')
  Future<bool> removeEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_emailKey);
    } catch (e) {
      print('Error al eliminar email: $e');
      return false;
    }
  }

  /// Limpiar todo el almacenamiento
  /// Equivalente a: localStorage.clear()
  Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      print('Error al limpiar almacenamiento: $e');
      return false;
    }
  }

  /// Verificar si existe un email guardado
  Future<bool> hasEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_emailKey);
    } catch (e) {
      print('Error al verificar email: $e');
      return false;
    }
  }
}
