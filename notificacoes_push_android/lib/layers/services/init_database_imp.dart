import 'package:notificacoes_push_android/layers/database/db.dart';
import 'package:notificacoes_push_android/layers/services/init_database.dart';
import 'package:sqflite_common/sqlite_api.dart';

class InitDatabaseImp implements InitDatabase {
  @override
  Future<Database> call() async {
    final Database db = await DB.instance.db;
    return db;
  }
}
