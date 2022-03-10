import 'package:get_it/get_it.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/create_notification_datasource/create_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/create_notification_datasource/local/create_notification_local_datasource_imp.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource/get_all_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource/local/get_all_notification_local_datasource_imp.dart';
import 'package:notificacoes_push_android/layers/data/repositories/create_notification_repository_imp.dart';
import 'package:notificacoes_push_android/layers/data/repositories/get_all_notification_repository_imp.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/create_notification_repository.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/get_all_notification_repository.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase_imp.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase_imp.dart';
import 'package:notificacoes_push_android/layers/presentation/controllers/notification_controller.dart';

class Inject {
  static void init() {
    GetIt getIt = GetIt.instance;

    //DATASOURCES
    getIt.registerLazySingleton<GetAllNotificationDataSource>(
      () => GetAllNotificationLocalDataSourceImp(),
    );
    getIt.registerLazySingleton<CreateNotificationDataSource>(
      () => CreateNotificationLocalDataSourceImp(),
    );

    //REPOSITORIES
    getIt.registerLazySingleton<GetAllNotificationRepository>(
      () => GetAllNotificationRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<CreateNotificationRepository>(
      () => CreateNotificationRepositoryImp(getIt()),
    );

    //USECASES
    getIt.registerLazySingleton<GetAllNotificationUseCase>(
      () => GetAllNotificationUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<CreateNotificationUseCase>(
      () => CreateNotificationUseCaseImp(getIt()),
    );

    //CONTROLLERS
    getIt.registerSingleton<NotificationController>(
      NotificationController(getIt(), getIt()),
    );
  }
}


// final controller = NotificationController(
//     GetAllNotificationUseCaseImp(
//       GetAllNotificationRepositoryImp(
//         GetAllNotificationLocalDataSourceImp(),
//       ),
//     ),
//     CreateNotificationUseCaseImp(
//       CreateNotificationRepositoryImp(),
//     ),
//   );
