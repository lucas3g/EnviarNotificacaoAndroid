import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource/get_all_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/data/dtos/notification_dto.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/init_database/init_database_usecase.dart';
import 'package:sqflite/sqflite.dart';

class GetAllNotificationLocalDataSourceImp
    implements GetAllNotificationDataSource {
  InitDatabaseUseCase _initDatabaseUseCase;

  GetAllNotificationLocalDataSourceImp(this._initDatabaseUseCase);

  @override
  Future<Either<Exception, List<NotificationDto>>> call() async {
    try {
      final Database db = await _initDatabaseUseCase();

      final List<NotificationDto> notificationDto = [];

      await db.transaction((txn) async {
        final List allNotification = await txn.query(
          'notifications',
        );

        if (allNotification.isNotEmpty) {
          for (var item in allNotification) {
            notificationDto.add(
              NotificationDto.fromMap(item),
            );
          }
        }
      });

      return Right(notificationDto);
    } catch (e) {
      return Left(Exception('error get'));
    }
  }
}
