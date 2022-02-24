import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'package:notificacoes_push_android/controllers/notification/get_notification_status.dart';
import 'dart:convert';

import 'package:notificacoes_push_android/controllers/notification/notification_status.dart';
import 'package:notificacoes_push_android/database/db.dart';
import 'package:notificacoes_push_android/models/notification_model.dart';
import 'package:sqflite/sqflite.dart';

class NotificationController extends ChangeNotifier {
  late Database db;
  late String titulo = '';
  late String descricao = '';

  List<NotificationModel> notifications = [];

  NotificationStatus status = NotificationStatus.empty;
  GetNotificationStatus getStatus = GetNotificationStatus.empty;

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
        await addNotification();
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

  Future<void> getAllNotifications() async {
    try {
      getStatus = GetNotificationStatus.loading;
      db = await DB.instance.db;

      notifications.clear();

      await db.transaction((txn) async {
        final List allNotification = await txn.query(
          'notifications',
        );

        if (allNotification.isNotEmpty) {
          for (var item in allNotification) {
            notifications.add(
              NotificationModel(
                id: item['id'],
                title: item['title'],
                description: item['description'],
              ),
            );
          }
        }
      });
      getStatus = GetNotificationStatus.success;
    } catch (e) {
      getStatus = GetNotificationStatus.error;
    }
  }

  Future<void> addNotification() async {
    try {
      db = await DB.instance.db;

      await db.transaction((txn) async {
        await txn.insert('notifications', {
          'title': titulo,
          'description': descricao,
        });
      });

      await getAllNotifications();
    } catch (e) {
      print('GET NOTIFICATIONS ERROR $e');
    }
  }

  Future<void> deleteNotification({required int id}) async {
    try {
      db = await DB.instance.db;

      await db.transaction((txn) async {
        await txn.delete('notifications', where: 'id = ?', whereArgs: [id]);
      });

      await getAllNotifications();

      notifyListeners();
    } catch (e) {
      print('DELETE NOTIFICATIONS ERROR $e');
      notifyListeners();
    }
  }
}
