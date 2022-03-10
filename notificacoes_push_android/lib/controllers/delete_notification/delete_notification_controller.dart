import 'package:fluent_ui/fluent_ui.dart';
import 'package:notificacoes_push_android/controllers/notification/notification_controller.dart';
import 'package:notificacoes_push_android/usecase/notification_usecase.dart';

import 'delete_notification_status.dart';

class DeleteNotificationController extends ChangeNotifier {
  DeleteNotificationStatus status = DeleteNotificationStatus.empty;

  final NotificationUseCase notificationUseCase = NotificationUseCase();

  Future<void> deleteNotification(
      {required int id, required NotificationController controller}) async {
    status = DeleteNotificationStatus.loading;
    if (await notificationUseCase.delete(id: id)) {
      await controller.getAllNotifications();
      status = DeleteNotificationStatus.success;
    } else {
      status = DeleteNotificationStatus.error;
    }
    notifyListeners();
  }
}
