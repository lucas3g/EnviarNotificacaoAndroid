import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_notification_per_filter_datasource/get_notification_per_filter_datasource.dart';
import 'package:notificacoes_push_android/layers/data/dtos/notification_dto.dart';

import '../../../../services/local_storage/helpers/local_storage_tables.dart';
import '../../../../services/local_storage/helpers/params.dart';
import '../../../../services/local_storage/local_storage_service.dart';

class GetNotificationPerFilterLocalDataSourceImp
    implements GetNotificationPerFilterDataSource {
  final LocalStorageService _localStorageService;

  GetNotificationPerFilterLocalDataSourceImp({
    required LocalStorageService localStorageService,
  }) : _localStorageService = localStorageService;

  @override
  Future<Either<Exception, List<NotificationDto>>> call() async {
    try {
      final param = LocalStorageGetPerFilterParam(
        table: LocalStorageTables.notifications,
      );

      final response = await _localStorageService.getPerFilter(param);

      final notificationDto = response.map(NotificationDto.fromMap).toList();

      return Right(notificationDto);
    } catch (e) {
      return Left(Exception('error get $e'));
    }
  }
}
