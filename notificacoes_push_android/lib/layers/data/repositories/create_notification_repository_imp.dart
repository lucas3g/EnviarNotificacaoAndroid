import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/create_notification_repository.dart';

class CreateNotificationRepositoryImp implements CreateNotificationRepository {
  @override
  Future<bool> call({required NotificationEntity notificationEntity}) async {
    return true;
  }
}
