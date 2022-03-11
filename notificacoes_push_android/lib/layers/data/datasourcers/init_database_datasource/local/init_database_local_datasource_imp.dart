import 'package:notificacoes_push_android/layers/data/datasourcers/init_database_datasource/init_database_datasource.dart';
import 'package:notificacoes_push_android/layers/database/db.dart';
import 'package:sqflite/sqflite.dart';

class InitDatabaseDataSourceImp implements InitDatabaseDataSource {
  @override
  Future<Database> call() async {
    try {
      final Database db = await DB.instance.db;

      return db;
    } catch (e) {
      rethrow;
    }
  }
}
