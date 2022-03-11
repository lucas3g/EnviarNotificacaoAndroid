import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/create_notification_datasource/create_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/init_database/init_database_usecase.dart';
import 'package:sqflite/sqflite.dart';

class CreateNotificationLocalDataSourceImp
    implements CreateNotificationDataSource {
  InitDatabaseUseCase _initDatabaseUseCase;

  CreateNotificationLocalDataSourceImp(this._initDatabaseUseCase);

  @override
  Future<Either<Exception, bool>> call(
      {required NotificationEntity notificationEntity}) async {
    try {
      final Database db = await _initDatabaseUseCase();

      await db.transaction((txn) async {
        final result = await txn.query('notifications',
            where: 'title = ? and description = ?',
            whereArgs: [
              notificationEntity.title,
              notificationEntity.description
            ]);
        if (result.isEmpty) {
          await txn.insert('notifications', {
            'title': notificationEntity.title,
            'description': notificationEntity.description,
          });
        }
      });
      return Right(true);
    } catch (e) {
      print('GET NOTIFICATIONS ERROR $e');
      return Left(Exception('Error datasource'));
    }
  }
}
