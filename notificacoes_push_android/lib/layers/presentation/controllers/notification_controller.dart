import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/delete_notification/delete_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase.dart';

class NotificationController {
  final GetAllNotificationUseCase _getAllNotificationUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;

  NotificationController(
    this._getAllNotificationUseCase,
    this._createNotificationUseCase,
    this._deleteNotificationUseCase,
  );

  late List<NotificationEntity> listNotificationEntity = [];
  late NotificationEntity notificationEntity =
      NotificationEntity(id: 0, title: '', description: '');

  copyWith({String? title, String? description}) {
    notificationEntity =
        notificationEntity.copyWith(title: title, description: description);
  }

  Future<List<NotificationEntity>> getAllNotifications() async {
    final result = await _getAllNotificationUseCase();
    result.fold(
      (error) => print(error.toString()),
      (success) => listNotificationEntity = success,
    );

    return listNotificationEntity;
  }

  Future<bool> createNotification() async {
    final result = await _createNotificationUseCase(
        notificationEntity: notificationEntity);
    return result.fold(
      (error) => false,
      (success) => success,
    );
  }

  Future<bool> deleteNotification({required int id}) async {
    final result = await _deleteNotificationUseCase(id: id);
    return result.fold(
      (error) => false,
      (success) => success,
    );
  }
}
