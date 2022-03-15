import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/dtos/notification_dto.dart';

abstract class GetNotificationPerFilterDataSource {
  Future<Either<Exception, List<NotificationDto>>> call();
}
