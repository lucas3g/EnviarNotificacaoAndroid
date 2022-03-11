import 'package:fluent_ui/fluent_ui.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/delete_notification/delete_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/send_notification/send_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/presentation/controllers/notification_status.dart';

class NotificationController extends ChangeNotifier {
  final GetAllNotificationUseCase _getAllNotificationUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  final SendNotificationUseCase _sendNotificationUseCase;

  NotificationController(
    this._getAllNotificationUseCase,
    this._createNotificationUseCase,
    this._deleteNotificationUseCase,
    this._sendNotificationUseCase,
  );

  NotificationStatus status = NotificationStatus.empty;

  List<NotificationEntity> listNotificationEntity = [];

  NotificationEntity notificationEntity =
      NotificationEntity(id: 0, title: '', description: '');

  void copyWith({String? title, String? description}) {
    notificationEntity =
        notificationEntity.copyWith(title: title, description: description);
  }

  Future<List<NotificationEntity>> getAllNotifications() async {
    status = NotificationStatus.loading;
    notifyListeners();
    final result = await _getAllNotificationUseCase();
    result.fold(
      (error) {
        status = NotificationStatus.error;
      },
      (success) {
        listNotificationEntity = success;
        status = NotificationStatus.success;
      },
    );
    notifyListeners();
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

  Future<bool> sendNotification({required BuildContext context}) async {
    status = NotificationStatus.loading;
    notifyListeners();
    final result =
        await _sendNotificationUseCase(notificationEntity: notificationEntity);
    return result.fold(
      (error) {
        status = NotificationStatus.error;
        notifyListeners();
        mostraAlerta(
          titulo: 'Atenção',
          descricao: 'Não foi possível enviar a notificação. Tente novamente.',
          context: context,
        );

        return false;
      },
      (success) async {
        await createNotification();
        status = NotificationStatus.success;
        notifyListeners();
        mostraAlerta(
          titulo: 'Sucesso',
          descricao: 'Notificação enviada!',
          context: context,
        );
        return success;
      },
    );
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
}
