import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/delete_notification_datasource/delete_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/delete_notification_repository.dart';

class DeleteNotificationRepositoryImp implements DeleteNotificationRepository {
  final DeleteNotificationDataSource _deleteNotificationDataSource;

  DeleteNotificationRepositoryImp(this._deleteNotificationDataSource);

  @override
  Future<Either<Exception, bool>> call({required int id}) async {
    return await _deleteNotificationDataSource(id: id);
  }
}
