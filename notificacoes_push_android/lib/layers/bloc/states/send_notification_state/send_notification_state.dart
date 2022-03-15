abstract class SendNotificationState {}

class EmptySendNotificationState extends SendNotificationState {}

class LoadingSendNotifcationState extends SendNotificationState {}

class SucessSendNotificationState extends SendNotificationState {}

class ErrorSendNotificationState extends SendNotificationState {
  final String message;
  final StackTrace? stackTrace;

  ErrorSendNotificationState({
    required this.message,
    this.stackTrace,
  });
}
