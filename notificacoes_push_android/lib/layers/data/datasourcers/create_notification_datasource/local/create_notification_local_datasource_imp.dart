import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/create_notification_datasource/create_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/init_database/init_database_usecase.dart';
import 'package:sqflite/sqflite.dart';

class CreateNotificationLocalDataSourceImp
    implements CreateNotificationDataSource {
  late Database db;

  InitDatabaseUseCase _initDatabaseUseCase;

  CreateNotificationLocalDataSourceImp(this._initDatabaseUseCase);

  @override
  Future<Either<Exception, bool>> call(
      {required NotificationEntity notificationEntity}) async {
    try {
      final result = _initDatabaseUseCase();
      await result.then((value) => db = value.getOrElse(() => db));

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
