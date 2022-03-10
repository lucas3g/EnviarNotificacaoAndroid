import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/get_all_notification_repository.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase.dart';

class GetAllNotificationUseCaseImp implements GetAllNotificationUseCase {
  final GetAllNotificationRepository _getAllNotificationRepository;

  GetAllNotificationUseCaseImp(this._getAllNotificationRepository);

  @override
  Future<Either<Exception, List<NotificationEntity>>> call() async {
    return await _getAllNotificationRepository();
  }
}
