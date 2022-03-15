import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';

abstract class NotificationState {}

class EmptyNotifcationState extends NotificationState {}

class LoadingNotifcationState extends NotificationState {}

class LoadingMoreNotifcationState extends NotificationState {}

class DeleteNotifcationState extends NotificationState {}

class SucessNotifcationState extends NotificationState {
  final List<NotificationEntity> notifications;

  SucessNotifcationState({
    required this.notifications,
  });
}

class ErrorNotifcationState extends NotificationState {
  final String message;
  final StackTrace? stackTrace;

  ErrorNotifcationState({
    required this.message,
    this.stackTrace,
  });
}
