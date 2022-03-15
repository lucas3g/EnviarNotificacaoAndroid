import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_notification_per_filter_datasource/get_notification_per_filter_datasource.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/get_notification_per_filter_repository.dart';

class GetNotificationPerFilterRepositoryImp
    implements GetNotificationPerFilterRepository {
  final GetNotificationPerFilterDataSource _getNotificationPerFilterDataSource;

  GetNotificationPerFilterRepositoryImp(
      this._getNotificationPerFilterDataSource);

  @override
  Future<Either<Exception, List<NotificationEntity>>> call() async {
    return await _getNotificationPerFilterDataSource();
  }
}
