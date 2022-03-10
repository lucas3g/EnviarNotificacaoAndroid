import 'package:notificacoes_push_android/database/db.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/data/dtos/notification_dto.dart';
import 'package:sqflite/sqflite.dart';

class GetAllNotificationLocalDataSourceImp
    implements GetAllNotificationDataSource {
  late Database db;
  @override
  Future<List<NotificationDto>> call() async {
    try {
      db = await DB.instance.db;

      final List<NotificationDto> notificationDto = [];

      await db.transaction((txn) async {
        final List allNotification = await txn.query(
          'notifications',
        );

        if (allNotification.isNotEmpty) {
          for (var item in allNotification) {
            notificationDto.add(
              NotificationDto(
                id: item['id'],
                title: item['title'],
                description: item['description'],
              ),
            );
          }
        }
      });

      return notificationDto;
    } catch (e) {
      return [];
    }
  }
}
