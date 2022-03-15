import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notificacoes_push_android/layers/bloc/events/notification_events/notification_events.dart';
import 'package:notificacoes_push_android/layers/bloc/states/notification_state/notification_state.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/delete_notification/delete_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase.dart';

class NotificationBloc extends Bloc<NotificationEvents, NotificationState> {
  final GetAllNotificationUseCase _getAllNotificationUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;

  NotificationBloc(
    this._getAllNotificationUseCase,
    this._createNotificationUseCase,
    this._deleteNotificationUseCase,
  ) : super(EmptyNotificationState()) {
    on<GetAllNotificationEvent>(_getAllNotifications);
    on<CreateNotificationEvent>(_createNotification);
    on<DeleteNotificationEvent>(_deleteNotification);
  }

  Future<void> _getAllNotifications(event, emit) async {
    emit(LoadingNotifcationState());
    final result = await _getAllNotificationUseCase();
    result.fold(
      (error) {
        emit(
            ErrorNotificationState(message: 'Error ao buscar as notificações'));
      },
      (success) {
        if (success.isNotEmpty) {
          emit(SuccessNotificationState(notifications: success));
        } else {
          emit(EmptyNotificationState());
        }
      },
    );
  }

  Future<bool> _createNotification(CreateNotificationEvent event, emit) async {
    final result = await _createNotificationUseCase(
        notificationEntity: event.notificationEntity);
    return result.fold(
      (error) {
        emit(ErrorNotificationState(message: 'Error ao criar a notificação'));
        return false;
      },
      (success) async {
        add(GetAllNotificationEvent());
        return success;
      },
    );
  }

  Future<bool> _deleteNotification(DeleteNotificationEvent event, emit) async {
    emit(LoadingNotifcationState());
    final result = await _deleteNotificationUseCase(id: event.id);
    return result.fold(
      (error) {
        emit(ErrorNotificationState(
            message: 'Erro ao tentar excluir a notificação'));
        return false;
      },
      (success) {
        add(GetAllNotificationEvent());
        return success;
      },
    );
  }
}
