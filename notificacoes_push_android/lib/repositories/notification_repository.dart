import 'package:notificacoes_push_android/models/notification_model.dart';

abstract class NotificationRepository {
  Future<bool> create({required String title, required String description});
  Future<void> list({required List<NotificationModel> notifications});
  Future<bool> delete({required int id});
}
