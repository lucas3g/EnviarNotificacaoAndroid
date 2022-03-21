import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource/get_all_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/data/dtos/notification_dto.dart';

import '../../../../services/local_storage/helpers/local_storage_tables.dart';
import '../../../../services/local_storage/helpers/params.dart';
import '../../../../services/local_storage/local_storage_service.dart';

class GetAllNotificationLocalDataSourceImp
    implements GetAllNotificationDataSource {
  final LocalStorageService _localStorageService;

  GetAllNotificationLocalDataSourceImp({
    required LocalStorageService localStorageService,
  }) : _localStorageService = localStorageService;

  @override
  Future<Either<Exception, List<NotificationDto>>> call() async {
    try {
      final param = LocalStorageGetAllParam(
        table: LocalStorageTables.notifications,
      );

      await Future.delayed(Duration(seconds: 1));

      final response = await _localStorageService.getAll(param);

      final notificationDto = response.map(NotificationDto.fromMap).toList();

      return Right(notificationDto);
    } catch (e) {
      return Left(Exception('error get $e'));
    }
  }
}
