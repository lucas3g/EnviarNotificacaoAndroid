import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/delete_notification_datasource/delete_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/database/db.dart';
import 'package:sqflite/sqflite.dart';

class DeleteNotificationLocalDataSourceImp
    implements DeleteNotificationDataSource {
  late Database db;

  @override
  Future<Either<Exception, bool>> call({required int id}) async {
    try {
      db = await DB.instance.db;

      await db.transaction((txn) async {
        await txn.delete('notifications', where: 'id = ?', whereArgs: [id]);
      });

      return Right(true);
    } catch (e) {
      return Left(Exception('error delete'));
    }
  }
}
