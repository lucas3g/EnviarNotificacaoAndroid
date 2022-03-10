import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';

abstract class CreateNotificationRepository {
  Future<bool> call({required NotificationEntity notificationEntity});
}
