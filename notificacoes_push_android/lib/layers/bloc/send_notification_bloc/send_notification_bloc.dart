import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notificacoes_push_android/layers/bloc/events/notification_events/notification_events.dart';
import 'package:notificacoes_push_android/layers/bloc/states/send_notification_state/send_notification_state.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/send_notification/send_notification_usecase.dart';

class SendNotificationBloc
    extends Bloc<SendNotificationEvent, SendNotificationState> {
  final SendNotificationUseCase _sendNotificationUseCase;
  SendNotificationBloc(this._sendNotificationUseCase)
      : super(EmptySendNotificationState()) {
    on(_sendNotification);
  }

  NotificationEntity notificationEntity =
      NotificationEntity(id: 0, title: '', description: '');

  Future<bool> _sendNotification(SendNotificationEvent event, emit) async {
    emit(LoadingSendNotifcationState());
    final result =
        await _sendNotificationUseCase(notificationEntity: notificationEntity);
    return result.fold(
      (error) {
        emit(ErrorSendNotificationState(
            message: 'Error ao enviar a notificação'));

        return false;
      },
      (success) async {
        emit(SucessSendNotificationState());
        return success;
      },
    );
  }

  void copyWith({String? title, String? description}) {
    notificationEntity =
        notificationEntity.copyWith(title: title, description: description);
  }
}
