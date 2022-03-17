import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';

abstract class NotificationEvents {}

class GetAllNotificationEvent extends NotificationEvents {}

class CreateNotificationEvent extends NotificationEvents {
  final NotificationEntity notificationEntity;

  CreateNotificationEvent({
    required this.notificationEntity,
  });
}

class DeleteNotificationEvent extends NotificationEvents {
  final int id;

  DeleteNotificationEvent({
    required this.id,
  });
}
