import 'package:postgres/postgres.dart';

class DatabaseService {
  static const String host = 'localhost';
  static const int port = 5432;
  static const String database = 'persistencia_local_db';
  static const String username = 'postgres';
  static const String password = 'FfSantdmm,44';

  Future<Connection> _getConnection() async {
    final conn = await Connection.open(
      Endpoint(
        host: host,
        port: port,
        database: database,
        username: username,
        password: password,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
    return conn;
  }

  Future<void> createUser({
    required String username,
    required String email,
    required String passwordHash,
    required String telefono,
    required String verificationCode,
  }) async {
    final conn = await _getConnection();

    await conn.execute(
      '''
      INSERT INTO usuarios (username, email, password_hash, telefono, codigo_verificacion, email_verificado)
      VALUES (\$1, \$2, \$3, \$4, \$5, false)
      ''',
      parameters: [username, email, passwordHash, telefono, verificationCode],
    );

    await conn.close();
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final conn = await _getConnection();

    final result = await conn.execute(
      'SELECT * FROM usuarios WHERE email = \$1',
      parameters: [email],
    );

    await conn.close();

    if (result.isEmpty) return null;
    final row = result.first;

    return {
      'id': row[0],
      'username': row[1],
      'email': row[2],
      'password_hash': row[3],
      'telefono': row[4],
      'codigo_verificacion': row[5],
      'email_verificado': row[6],
      'token_sesion': row[7],
    };
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final conn = await _getConnection();

    final result = await conn.execute(
      'SELECT * FROM usuarios WHERE username = \$1',
      parameters: [username],
    );

    await conn.close();

    if (result.isEmpty) return null;
    final row = result.first;

    return {
      'id': row[0],
      'username': row[1],
      'email': row[2],
      'password_hash': row[3],
      'telefono': row[4],
      'codigo_verificacion': row[5],
      'email_verificado': row[6],
      'token_sesion': row[7],
    };
  }

  Future<Map<String, dynamic>?> getUserByToken(String token) async {
    final conn = await _getConnection();

    final result = await conn.execute(
      'SELECT * FROM usuarios WHERE token_sesion = \$1',
      parameters: [token],
    );

    await conn.close();

    if (result.isEmpty) return null;
    final row = result.first;

    return {
      'id': row[0],
      'username': row[1],
      'email': row[2],
    };
  }

  Future<void> saveUserToken(int userId, String token) async {
    final conn = await _getConnection();

    await conn.execute(
      'UPDATE usuarios SET token_sesion = \$1 WHERE id = \$2',
      parameters: [token, userId],
    );

    await conn.close();
  }

  Future<void> markEmailAsVerified(String email) async {
    final conn = await _getConnection();

    await conn.execute(
      'UPDATE usuarios SET email_verificado = true WHERE email = \$1',
      parameters: [email],
    );

    await conn.close();
  }

  Future<void> updateVerificationCode(String email, String code) async {
    final conn = await _getConnection();

    await conn.execute(
      'UPDATE usuarios SET codigo_verificacion = \$1 WHERE email = \$2',
      parameters: [code, email],
    );

    await conn.close();
  }

  Future<void> clearUserToken(String token) async {
    final conn = await _getConnection();

    await conn.execute(
      'UPDATE usuarios SET token_sesion = NULL WHERE token_sesion = \$1',
      parameters: [token],
    );

    await conn.close();
  }
}
