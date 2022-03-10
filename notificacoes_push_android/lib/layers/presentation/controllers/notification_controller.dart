import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase.dart';

class NotificationController {
  final GetAllNotificationUseCase _getAllNotificationUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;

  NotificationController(
    this._getAllNotificationUseCase,
    this._createNotificationUseCase,
  );

  late List<NotificationEntity> notificationEntity = [];

  Future<List<NotificationEntity>> getAllNotifications() async {
    notificationEntity = await _getAllNotificationUseCase();
    return notificationEntity;
  }

  Future<bool> createNotification(
      {required NotificationEntity notificationEntity}) async {
    return await _createNotificationUseCase(
        notificationEntity: notificationEntity);
  }
}
