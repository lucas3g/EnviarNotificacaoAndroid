import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/create_notification_datasource/create_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/create_notification_repository.dart';

class CreateNotificationRepositoryImp implements CreateNotificationRepository {
  final CreateNotificationDataSource _createNotificationDataSource;

  CreateNotificationRepositoryImp(this._createNotificationDataSource);

  @override
  Future<Either<Exception, bool>> call(
      {required NotificationEntity notificationEntity}) async {
    return await _createNotificationDataSource(
      notificationEntity: notificationEntity,
    );
  }
}
