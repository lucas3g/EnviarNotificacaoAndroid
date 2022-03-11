import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';

abstract class InitDatabaseUseCase {
  Future<Either<Exception, Database>> call();
}
