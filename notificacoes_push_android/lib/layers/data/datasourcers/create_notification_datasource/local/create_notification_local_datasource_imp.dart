import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/create_notification_datasource/create_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/services/local_storage/helpers/filter_entity.dart';

import '../../../../services/local_storage/helpers/local_storage_tables.dart';
import '../../../../services/local_storage/helpers/params.dart';
import '../../../../services/local_storage/local_storage_service.dart';

class CreateNotificationLocalDataSourceImp
    implements CreateNotificationDataSource {
  final LocalStorageService _localStorageService;

  CreateNotificationLocalDataSourceImp({
    required LocalStorageService localStorageService,
  }) : _localStorageService = localStorageService;

  @override
  Future<Either<Exception, bool>> call({
    required NotificationEntity notificationEntity,
  }) async {
    try {
      final param = LocalStorageGetAllParam(
        table: LocalStorageTables.notifications,
        filters: {
          FilterEntity(
            name: 'title',
            value: notificationEntity.title,
            type: FilterType.equal,
          ),
          FilterEntity(
            name: 'description',
            value: notificationEntity.description,
            type: FilterType.equal,
          ),
        },
      );

      final response = await _localStorageService.getAll(param);

      if (response.isEmpty) {
        final param = LocalStorageCreateParam(
          table: LocalStorageTables.notifications,
          data: {
            'title': notificationEntity.title,
            'description': notificationEntity.description,
          },
        );
        await _localStorageService.create(param);
      }

      return Right(true);
    } catch (e) {
      print('GET NOTIFICATIONS ERROR $e');
      return Left(Exception('Error datasource'));
    }
  }
}
