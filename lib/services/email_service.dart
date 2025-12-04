import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static const String smtpHost = 'smtp.gmail.com';
  static const int smtpPort = 587;
  static const String emailUser = 'estkubiantiago16@gmail.com';
  static const String emailPassword = 'lfwz taqk zbit qkkv';

  Future<void> sendVerificationEmail({
    required String email,
    required String code,
  }) async {
    final smtpServer = gmail(emailUser, emailPassword);

    final message = Message()
      ..from = Address(emailUser, 'Persistencia de Datos Local')
      ..recipients.add(email)
      ..subject = 'Persistencia de Datos Local - Código de Verificación'
      ..html = '''
        <div style="font-family: Arial, sans-serif; padding: 20px; background-color: #f4f4f4;">
          <div style="max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px;">
            <h1 style="color: #003366; text-align: center;">Persistencia de Datos Local</h1>
            <p style="font-size: 16px; color: #333;">Hola,</p>
            <p style="font-size: 16px; color: #333;">Tu código de verificación es:</p>
            <div style="text-align: center; margin: 30px 0;">
              <span style="font-size: 32px; font-weight: bold; color: #003366; letter-spacing: 5px;">$code</span>
            </div>
            <p style="font-size: 14px; color: #666;">Este código es válido por 15 minutos.</p>
            <p style="font-size: 14px; color: #666;">Si no solicitaste este código, puedes ignorar este mensaje.</p>
          </div>
        </div>
      ''';

    try {
      await send(message, smtpServer);
    } catch (e) {
      print('Error al enviar email: $e');
      rethrow;
    }
  }
}
