import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/delete_notification_repository.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/delete_notification/delete_notification_usecase.dart';

class DeleteNotificationUseCaseImp implements DeleteNotificationUseCase {
  final DeleteNotificationRepository _deleteNotificationRepository;

  DeleteNotificationUseCaseImp(this._deleteNotificationRepository);

  @override
  Future<Either<Exception, bool>> call({required int id}) async {
    return await _deleteNotificationRepository(id: id);
  }
}
