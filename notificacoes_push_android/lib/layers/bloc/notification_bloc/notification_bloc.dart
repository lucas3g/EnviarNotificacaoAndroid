import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notificacoes_push_android/layers/bloc/events/notification_events.dart';
import 'package:notificacoes_push_android/layers/bloc/states/notification_state.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/delete_notification/delete_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/send_notification/send_notification_usecase.dart';

class NotificationBloc extends Bloc<NotificationEvents, NotificationState> {
  final GetAllNotificationUseCase _getAllNotificationUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  final SendNotificationUseCase _sendNotificationUseCase;
  NotificationBloc(
      this._getAllNotificationUseCase,
      this._createNotificationUseCase,
      this._deleteNotificationUseCase,
      this._sendNotificationUseCase)
      : super(EmptyNotifcationState()) {
    on<GetAllNotificationEvent>(_getAllNotifications);
    on<CreateNotificationEvent>(_createNotification);
    on<DeleteNotificationEvent>(_deleteNotification);
    on<SendNotificationEvent>(_sendNotification);
  }

  NotificationEntity notificationEntity =
      NotificationEntity(id: 0, title: '', description: '');

  Future<void> _getAllNotifications(event, emit) async {
    final result = await _getAllNotificationUseCase();
    result.fold(
      (error) {
        emit(ErrorNotifcationState(message: 'Error ao buscar as notificações'));
      },
      (success) {
        emit(SucessNotifcationState(notifications: success));
      },
    );
  }

  Future<bool> _createNotification(CreateNotificationEvent event, emit) async {
    final result = await _createNotificationUseCase(
        notificationEntity: event.notificationEntity);
    return result.fold(
      (error) {
        emit(ErrorNotifcationState(message: 'Error ao criar a notificação'));
        return false;
      },
      (success) async {
        emit(LoadingMoreNotifcationState());
        add(GetAllNotificationEvent());
        return success;
      },
    );
  }

  Future<bool> _deleteNotification(DeleteNotificationEvent event, emit) async {
    final result = await _deleteNotificationUseCase(id: event.id);
    return result.fold(
      (error) {
        emit(ErrorNotifcationState(
            message: 'Erro ao tentar excluir a notificação'));
        return false;
      },
      (success) {
        emit(DeleteNotifcationState());
        add(GetAllNotificationEvent());
        return success;
      },
    );
  }

  Future<bool> _sendNotification(SendNotificationEvent event, emit) async {
    emit(LoadingNotifcationState());
    final result =
        await _sendNotificationUseCase(notificationEntity: notificationEntity);
    return result.fold(
      (error) {
        emit(ErrorNotifcationState(message: 'Error ao enviar a notificação'));

        // mostraAlerta(
        //   titulo: 'Atenção',
        //   descricao: 'Não foi possível enviar a notificação. Tente novamente.',
        //   context: context,
        // );

        return false;
      },
      (success) async {
        add(CreateNotificationEvent(notificationEntity: notificationEntity));

        // mostraAlerta(
        //   titulo: 'Sucesso',
        //   descricao: 'Notificação enviada!',
        //   context: context,
        // );
        return success;
      },
    );
  }

  void copyWith({String? title, String? description}) {
    notificationEntity =
        notificationEntity.copyWith(title: title, description: description);
  }
}

void mostraAlerta(
    {required String titulo,
    required String descricao,
    required BuildContext context,
    String textBotao = 'Entendido'}) {
  showDialog(
    context: context,
    builder: (context) {
      return ContentDialog(
        title: Text(
          titulo,
          style: TextStyle(fontSize: 14),
        ),
        content: Text(descricao),
        actions: [
          Button(
            style: ButtonStyle(
              backgroundColor: ButtonState.all(Colors.blue),
              elevation: ButtonState.all(5),
              shadowColor: ButtonState.all(Colors.blue),
            ),
            child: Center(
              child: Text(
                textBotao,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}
