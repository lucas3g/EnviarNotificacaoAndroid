import 'package:get_it/get_it.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/create_notification_datasource/create_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/create_notification_datasource/local/create_notification_local_datasource_imp.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/delete_notification_datasource/delete_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/delete_notification_datasource/local/delete_notification_local_datasource_imp.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource/get_all_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource/local/get_all_notification_local_datasource_imp.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/init_database_datasource/init_database_datasource.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/init_database_datasource/local/init_database_local_datasource_imp.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/send_notification_datasource/firebase/send_notification_firebase_datasource_imp.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/send_notification_datasource/send_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/data/repositories/create_notification_repository_imp.dart';
import 'package:notificacoes_push_android/layers/data/repositories/delete_notification_repository_imp.dart';
import 'package:notificacoes_push_android/layers/data/repositories/get_all_notification_repository_imp.dart';
import 'package:notificacoes_push_android/layers/data/repositories/init_database_repository_imp.dart';
import 'package:notificacoes_push_android/layers/data/repositories/send_notification_repository_imp.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/create_notification_repository.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/delete_notification_repository.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/get_all_notification_repository.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/init_database_repository.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/send_notification_repository.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase_imp.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/delete_notification/delete_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/delete_notification/delete_notification_usecase_imp.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase_imp.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/init_database/init_database_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/init_database/init_database_usecase_imp.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/send_notification/send_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/send_notification/send_notification_usecase_imp.dart';
import 'package:notificacoes_push_android/layers/presentation/controllers/notification_controller.dart';

import '../../layers/services/local_storage/helpers/params.dart';
import '../../layers/services/local_storage/helpers/table_entity.dart';
import '../../layers/services/local_storage/local_storage_service.dart';
import '../../layers/services/local_storage/sqflite/sqflite_local_storage_service_imp.dart';

class Inject {
  static void init() {
    GetIt getIt = GetIt.instance;

    // LOCAL STORAGE SERVICE
    getIt.registerLazySingleton<LocalStorageService>(
      () {
        final service = SqfliteLocalStorageServiceImp();
        final fields = {
          TableFieldEntity(name: 'id', type: FieldType.integer, pk: true),
          TableFieldEntity(name: 'title', type: FieldType.string),
          TableFieldEntity(name: 'description', type: FieldType.string),
        };
        final table = TableEntity(name: 'notifications', fields: fields);

        final param = LocalStorageInitParam(
          fileName: 'notifications.db',
          tables: {table},
        );
        service.init(param);

        return service;
      },
    );

    //DATASOURCES
    getIt.registerLazySingleton<InitDatabaseDataSource>(
      () => InitDatabaseDataSourceImp(),
    );
    getIt.registerLazySingleton<GetAllNotificationDataSource>(
      () => GetAllNotificationLocalDataSourceImp(localStorageService: getIt()),
    );
    getIt.registerLazySingleton<CreateNotificationDataSource>(
      () => CreateNotificationLocalDataSourceImp(localStorageService: getIt()),
    );
    getIt.registerLazySingleton<DeleteNotificationDataSource>(
      () => DeleteNotificationLocalDataSourceImp(localStorageService: getIt()),
    );
    getIt.registerLazySingleton<SendNotificationDataSource>(
      () => SendNotificationFireBaseDataSourceImp(),
    );

    //REPOSITORIES
    getIt.registerLazySingleton<GetAllNotificationRepository>(
      () => GetAllNotificationRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<CreateNotificationRepository>(
      () => CreateNotificationRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<DeleteNotificationRepository>(
      () => DeleteNotificationRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<SendNotificationRepository>(
      () => SendNotificationRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<InitDatabaseRepository>(
      () => InitDatabaseRepositoryImp(getIt()),
    );

    //USECASES
    getIt.registerLazySingleton<GetAllNotificationUseCase>(
      () => GetAllNotificationUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<CreateNotificationUseCase>(
      () => CreateNotificationUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<DeleteNotificationUseCase>(
      () => DeleteNotificationUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<SendNotificationUseCase>(
      () => SendNotificationUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<InitDatabaseUseCase>(
      () => InitDatabaseUseCaseImp(getIt()),
    );

    //CONTROLLERS
    getIt.registerSingleton<NotificationController>(
      NotificationController(getIt(), getIt(), getIt(), getIt()),
    );
  }
}
