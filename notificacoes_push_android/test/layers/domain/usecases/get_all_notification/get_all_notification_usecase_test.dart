import 'package:flutter_test/flutter_test.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource/local/get_all_notification_local_datasource_imp.dart';
import 'package:notificacoes_push_android/layers/data/repositories/get_all_notification_repository_imp.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase_imp.dart';

main() {
  test('Deve retornar uma lista de notifications', () async {
    GetAllNotificationUseCase useCase = GetAllNotificationUseCaseImp(
        GetAllNotificationRepositoryImp(
            GetAllNotificationLocalDataSourceImp()));

    var result = await useCase();

    late List<NotificationEntity> resultExpect;

    result.fold((l) => null, (r) => resultExpect = r);

    expect(resultExpect, isInstanceOf<List<NotificationEntity>>());
  });
}
