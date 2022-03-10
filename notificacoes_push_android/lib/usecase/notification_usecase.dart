import 'package:notificacoes_push_android/database/db.dart';
import 'package:notificacoes_push_android/models/notification_model.dart';
import 'package:notificacoes_push_android/repositories/notification_repository.dart';
import 'package:sqflite/sqflite.dart';

class NotificationUseCase extends NotificationRepository {
  late Database db;

  @override
  Future<bool> create(
      {required String title, required String description}) async {
    try {
      db = await DB.instance.db;

      await db.transaction((txn) async {
        await txn.insert('notifications', {
          'title': title,
          'description': description,
        });
      });
      return true;
    } catch (e) {
      print('GET NOTIFICATIONS ERROR $e');
      return false;
    }
  }

  @override
  Future<bool> delete({required int id}) async {
    try {
      db = await DB.instance.db;

      await db.transaction((txn) async {
        await txn.delete('notifications', where: 'id = ?', whereArgs: [id]);
      });
      return true;
    } catch (e) {
      print('DELETE NOTIFICATIONS ERROR $e');
      return false;
    }
  }

  @override
  Future<void> list({required List<NotificationModel> notifications}) async {
    try {
      db = await DB.instance.db;

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
    } catch (e) {}
  }
}
