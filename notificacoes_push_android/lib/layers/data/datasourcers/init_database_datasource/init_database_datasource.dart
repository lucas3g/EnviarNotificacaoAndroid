import 'package:dartz/dartz.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class InitDatabaseDataSource {
  Future<Either<Exception, Database>> call();
}
