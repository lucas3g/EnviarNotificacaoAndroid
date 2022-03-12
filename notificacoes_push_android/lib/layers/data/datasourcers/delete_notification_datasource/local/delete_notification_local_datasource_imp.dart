import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/delete_notification_datasource/delete_notification_datasource.dart';

import '../../../../services/local_storage/helpers/local_storage_tables.dart';
import '../../../../services/local_storage/helpers/params.dart';
import '../../../../services/local_storage/local_storage_service.dart';

class DeleteNotificationLocalDataSourceImp
    implements DeleteNotificationDataSource {
  final LocalStorageService _localStorageService;

  DeleteNotificationLocalDataSourceImp({
    required LocalStorageService localStorageService,
  }) : _localStorageService = localStorageService;

  @override
  Future<Either<Exception, bool>> call({required int id}) async {
    try {
      final param = LocalStorageDeleteParam(
        table: LocalStorageTables.notifications,
        id: id,
      );
      await _localStorageService.delete(param);

      return Right(true);
    } catch (e) {
      return Left(Exception('error delete'));
    }
  }
}
