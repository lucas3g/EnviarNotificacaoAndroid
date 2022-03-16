import 'package:flutter_test/flutter_test.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource/get_all_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource/local/get_all_notification_local_datasource_imp.dart';
import 'package:notificacoes_push_android/layers/data/repositories/get_all_notification_repository_imp.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/get_all_notification_repository%20copy.dart';
import 'package:notificacoes_push_android/layers/services/local_storage/local_storage_service.dart';
import 'package:notificacoes_push_android/layers/services/local_storage/sqflite/sqflite_local_storage_service_imp.dart';

main() {
  LocalStorageService service = SqfliteLocalStorageServiceImp();

  GetAllNotificationDataSource dataSource =
      GetAllNotificationLocalDataSourceImp(localStorageService: service);
  GetAllNotificationRepository repository =
      GetAllNotificationRepositoryImp(dataSource);

  test('Devolva uma lista de notificaçao', () async {
    var result = await repository();

    expect(result, isNotNull);
  });
}
