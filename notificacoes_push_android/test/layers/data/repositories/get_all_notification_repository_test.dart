import 'package:flutter_test/flutter_test.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource/get_all_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource/local/get_all_notification_local_datasource_imp.dart';
import 'package:notificacoes_push_android/layers/data/repositories/get_all_notification_repository_imp.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/get_all_notification_repository.dart';

main() {
  GetAllNotificationDataSource dataSource =
      GetAllNotificationLocalDataSourceImp();
  GetAllNotificationRepository repository =
      GetAllNotificationRepositoryImp(dataSource);

  test('Devolva uma lista de notificaçao', () async {
    var result = await repository();

    expect(result, isNotNull);
  });
}
