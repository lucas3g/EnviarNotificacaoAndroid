import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:notificacoes_push_android/controllers/notification/notification_status.dart';

class NotificationController extends ChangeNotifier {
  late String titulo = '';
  late String descricao = '';

  NotificationStatus status = NotificationStatus.empty;

  Future<void> enviarNotificacao() async {
    try {
      if (titulo.isEmpty || descricao.isEmpty) {
        status = NotificationStatus.camposVazios;
        notifyListeners();
        return;
      }

      status = NotificationStatus.loading;
      notifyListeners();
      final postUrl = 'https://fcm.googleapis.com/fcm/send';

      final apiKey =
          'AAAAN83oFLA:APA91bFKuxMQfbd97SYgJivNR3x8HHRedDi70_9_POimnNzZl5wZeSud85eehNjVpf2u1cSj6_aVs0qvBfikxbeyc1a5LBa5yAHffwMcRiTl6e4kI2F5xClANTQHMBH1RE5oUCRJNIiQ';

      final headers = {
        'content-type': 'application/json',
        'Authorization': 'key=$apiKey',
      };

      final data = {
        "to": "/topics/all",
        "notification": {"title": titulo, "body": descricao}
      };

      final response = await http.post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        // on success do sth
        print('Notificação enviada!');
        status = NotificationStatus.success;
        notifyListeners();
      } else {
        print('Erro ao Enviar Notificação');
        status = NotificationStatus.error;
        notifyListeners();
        // on failure do sth
      }
    } catch (e) {
      print('EU SOU ERRO $e');
      status = NotificationStatus.error;
      notifyListeners();
    }
  }
}
