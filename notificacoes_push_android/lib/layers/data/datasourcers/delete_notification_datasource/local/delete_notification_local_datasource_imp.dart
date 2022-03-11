import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/delete_notification_datasource/delete_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/init_database/init_database_usecase.dart';
import 'package:sqflite/sqflite.dart';

class DeleteNotificationLocalDataSourceImp
    implements DeleteNotificationDataSource {
  InitDatabaseUseCase _initDatabaseUseCase;

  DeleteNotificationLocalDataSourceImp(this._initDatabaseUseCase);

  @override
  Future<Either<Exception, bool>> call({required int id}) async {
    try {
      final Database db = await _initDatabaseUseCase();

      await db.transaction((txn) async {
        await txn.delete('notifications', where: 'id = ?', whereArgs: [id]);
      });

      return Right(true);
    } catch (e) {
      return Left(Exception('error delete'));
    }
  }
}
