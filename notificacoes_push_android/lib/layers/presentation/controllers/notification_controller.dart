import 'package:fluent_ui/fluent_ui.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase.dart';

class NotificationController extends ChangeNotifier {
  final GetAllNotificationUseCase _getAllNotificationUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;

  NotificationController(
    this._getAllNotificationUseCase,
    this._createNotificationUseCase,
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
    notifyListeners();
    return listNotificationEntity;
  }

  Future<bool> createNotification() async {
    final result = await _createNotificationUseCase(
        notificationEntity: notificationEntity);
    notifyListeners();
    return result.fold(
      (error) => false,
      (success) => success,
    );
  }
}
