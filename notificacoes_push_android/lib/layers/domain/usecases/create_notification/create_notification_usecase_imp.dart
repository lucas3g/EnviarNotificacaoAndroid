import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/create_notification_repository.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase.dart';

class CreateNotificationUseCaseImp implements CreateNotificationUseCase {
  final CreateNotificationRepository _createNotificationRepository;

  CreateNotificationUseCaseImp(this._createNotificationRepository);

  @override
  Future<Either<Exception, bool>> call(
      {required NotificationEntity notificationEntity}) async {
    return await _createNotificationRepository(
        notificationEntity: notificationEntity);
  }
}
