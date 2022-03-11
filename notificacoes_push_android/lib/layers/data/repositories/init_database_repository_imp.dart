import 'package:notificacoes_push_android/layers/data/datasourcers/init_database_datasource/init_database_datasource.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/init_database_repository.dart';
import 'package:sqflite/sqlite_api.dart';

class InitDatabaseRepositoryImp implements InitDatabaseRepository {
  final InitDatabaseDataSource _initDatabaseDataSource;

  InitDatabaseRepositoryImp(this._initDatabaseDataSource);

  @override
  Future<Database> call() async {
    return await _initDatabaseDataSource();
  }
}
