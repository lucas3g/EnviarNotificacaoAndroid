import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';

abstract class InitDatabaseRepository {
  Future<Either<Exception, Database>> call();
}
