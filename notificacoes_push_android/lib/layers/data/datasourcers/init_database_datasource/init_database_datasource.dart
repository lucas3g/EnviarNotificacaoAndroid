import 'package:sqflite/sqlite_api.dart';

abstract class InitDatabaseDataSource {
  Future<Database> call();
}
