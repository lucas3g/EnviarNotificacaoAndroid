import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/send_notification_datasource/send_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/send_notification_repository.dart';

class SendNotificationRepositoryImp implements SendNotificationRepository {
  final SendNotificationDataSource _sendNotificationDataSource;

  SendNotificationRepositoryImp(this._sendNotificationDataSource);

  @override
  Future<Either<Exception, bool>> call(
      {required NotificationEntity notificationEntity}) async {
    return await _sendNotificationDataSource(
        notificationEntity: notificationEntity);
  }
}
