import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/get_notification_per_filter_repository.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_notification_per_filter/get_notificatin_per_filter_usecase.dart';

class GetNotificationPerFilterUseCaseImp
    implements GetNotificationPerFilterUseCase {
  final GetNotificationPerFilterRepository _getNotificationPerFilterRepository;

  GetNotificationPerFilterUseCaseImp(this._getNotificationPerFilterRepository);

  @override
  Future<Either<Exception, List<NotificationEntity>>> call() async {
    return await _getNotificationPerFilterRepository();
  }
}
