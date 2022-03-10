import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'package:notificacoes_push_android/controllers/notification/get_notification_status.dart';
import 'dart:convert';

import 'package:notificacoes_push_android/controllers/notification/notification_status.dart';
import 'package:notificacoes_push_android/models/notification_model.dart';
import 'package:notificacoes_push_android/usecase/notification_usecase.dart';

class NotificationController extends ChangeNotifier {
  late String title = '';
  late String description = '';

  List<NotificationModel> notifications = [];

  NotificationStatus status = NotificationStatus.empty;
  GetNotificationStatus getStatus = GetNotificationStatus.empty;

  final NotificationUseCase notificationUseCase = NotificationUseCase();

  Future<void> enviarNotificacao() async {
    try {
      if (title.isEmpty || description.isEmpty) {
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
        "notification": {"title": title, "body": description}
      };

      final response = await http.post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        print('Notificação enviada!');
        status = NotificationStatus.success;
        await createNotification();
      } else {
        print('Erro ao Enviar Notificação');
        status = NotificationStatus.error;
        notifyListeners();
      }
    } catch (e) {
      print('EU SOU ERRO $e');
      status = NotificationStatus.error;
      notifyListeners();
    }
  }

  Future<void> getAllNotifications() async {
    getStatus = GetNotificationStatus.loading;
    notifications.clear();
    await notificationUseCase.list(notifications: notifications);
    getStatus = GetNotificationStatus.success;
  }

  Future<void> createNotification() async {
    status = NotificationStatus.loading;
    if (await notificationUseCase.create(
        title: title, description: description)) {
      await getAllNotifications();
      status = NotificationStatus.success;
    } else {
      status = NotificationStatus.error;
    }
    notifyListeners();
  }
}
