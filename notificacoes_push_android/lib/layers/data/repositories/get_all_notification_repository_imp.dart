import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource/get_all_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/get_all_notification_repository%20copy.dart';

class GetAllNotificationRepositoryImp implements GetAllNotificationRepository {
  final GetAllNotificationDataSource _getAllNotificationDataSource;

  GetAllNotificationRepositoryImp(this._getAllNotificationDataSource);

  @override
  Future<Either<Exception, List<NotificationEntity>>> call() async {
    return await _getAllNotificationDataSource();
  }
}
