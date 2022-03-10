import 'package:notificacoes_push_android/layers/data/dtos/notification_dto.dart';

abstract class GetAllNotificationDataSource {
  Future<List<NotificationDto>> call();
}
