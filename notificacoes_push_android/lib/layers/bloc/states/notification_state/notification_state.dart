import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';

abstract class NotificationState {}

class EmptyNotificationState extends NotificationState {}

class LoadingNotifcationState extends NotificationState {}

class SuccessNotificationState extends NotificationState {
  final List<NotificationEntity> notifications;

  SuccessNotificationState({
    required this.notifications,
  });
}

class ErrorNotificationState extends NotificationState {
  final String message;
  final StackTrace? stackTrace;

  ErrorNotificationState({
    required this.message,
    this.stackTrace,
  });
}
