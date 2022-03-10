import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';

abstract class GetAllNotificationRepository {
  Future<List<NotificationEntity>> call();
}
