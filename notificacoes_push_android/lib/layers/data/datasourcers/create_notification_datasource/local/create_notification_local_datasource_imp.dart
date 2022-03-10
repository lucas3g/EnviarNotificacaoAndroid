import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/create_notification_datasource/create_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/database/db.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:sqflite/sqflite.dart';

class CreateNotificationLocalDataSourceImp
    implements CreateNotificationDataSource {
  late Database db;

  @override
  Future<Either<Exception, bool>> call(
      {required NotificationEntity notificationEntity}) async {
    try {
      db = await DB.instance.db;

      await db.transaction((txn) async {
        await txn.insert('notifications', {
          'title': notificationEntity.title,
          'description': notificationEntity.description,
        });
      });
      return Right(true);
    } catch (e) {
      print('GET NOTIFICATIONS ERROR $e');
      return Left(Exception('Error datasource'));
    }
  }
}
