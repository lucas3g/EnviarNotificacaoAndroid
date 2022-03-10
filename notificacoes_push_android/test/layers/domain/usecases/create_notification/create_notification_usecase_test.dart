import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/create_notification_repository.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase_imp.dart';

class CreateNotificationRepositoryImp implements CreateNotificationRepository {
  @override
  Future<Either<Exception, bool>> call(
      {required NotificationEntity notificationEntity}) async {
    return Right(true);
  }
}

void main() {
  test('Deve retorna true quando salvar o carro', () async {
    final CreateNotificationUseCase useCase =
        CreateNotificationUseCaseImp(CreateNotificationRepositoryImp());

    var notification =
        NotificationEntity(id: 0, title: 'Teste', description: 'teste');

    var result = await useCase(notificationEntity: notification);

    late bool resulExpect;

    result.fold((l) => false, (r) => resulExpect = r);

    expect(resulExpect, true);
  });
}
