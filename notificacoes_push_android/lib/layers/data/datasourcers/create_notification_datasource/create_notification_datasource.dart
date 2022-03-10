import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';

abstract class CreateNotificationDataSource {
  Future<Either<Exception, bool>> call(
      {required NotificationEntity notificationEntity});
}
