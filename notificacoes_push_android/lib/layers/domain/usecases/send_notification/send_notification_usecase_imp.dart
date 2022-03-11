import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/send_notification_repository.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/send_notification/send_notification_usecase.dart';

class SendNotificationUseCaseImp implements SendNotificationUseCase {
  final SendNotificationRepository _sendNotificationRepository;

  SendNotificationUseCaseImp(this._sendNotificationRepository);

  @override
  Future<Either<Exception, bool>> call(
      {required NotificationEntity notificationEntity}) async {
    return await _sendNotificationRepository(
        notificationEntity: notificationEntity);
  }
}
