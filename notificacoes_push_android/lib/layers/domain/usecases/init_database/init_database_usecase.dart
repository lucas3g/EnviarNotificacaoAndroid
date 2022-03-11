import 'package:sqflite/sqflite.dart';

abstract class InitDatabaseUseCase {
  Future<Database> call();
}
