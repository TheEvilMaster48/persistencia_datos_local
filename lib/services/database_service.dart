import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _db;

  DatabaseService._internal();

  Future<Database> _getDB() async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'persistencia_local.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password_hash TEXT NOT NULL,
            telefono TEXT,
            codigo_verificacion TEXT,
            email_verificado INTEGER DEFAULT 0,
            token_sesion TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  // CRUD

  Future<void> createUser({
    required String username,
    required String email,
    required String passwordHash,
    required String telefono,
    required String verificationCode,
  }) async {
    final db = await _getDB();
    await db.insert("usuarios", {
      'username': username,
      'email': email,
      'password_hash': passwordHash,
      'telefono': telefono,
      'codigo_verificacion': verificationCode,
      'email_verificado': 0,
    });
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await _getDB();
    final result =
        await db.query("usuarios", where: "email = ?", whereArgs: [email]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await _getDB();
    final result =
        await db.query("usuarios", where: "username = ?", whereArgs: [username]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserByToken(String token) async {
    final db = await _getDB();
    final result = await db
        .query("usuarios", where: "token_sesion = ?", whereArgs: [token]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> saveUserToken(int userId, String token) async {
    final db = await _getDB();
    await db.update(
      "usuarios",
      {'token_sesion': token},
      where: "id = ?",
      whereArgs: [userId],
    );
  }

  Future<void> markEmailAsVerified(String email) async {
    final db = await _getDB();
    await db.update(
      "usuarios",
      {'email_verificado': 1},
      where: "email = ?",
      whereArgs: [email],
    );
  }

  Future<void> updateVerificationCode(String email, String code) async {
    final db = await _getDB();
    await db.update(
      "usuarios",
      {'codigo_verificacion': code},
      where: "email = ?",
      whereArgs: [email],
    );
  }

  Future<void> clearUserToken(String token) async {
    final db = await _getDB();
    await db.update(
      "usuarios",
      {'token_sesion': null},
      where: "token_sesion = ?",
      whereArgs: [token],
    );
  }
}
