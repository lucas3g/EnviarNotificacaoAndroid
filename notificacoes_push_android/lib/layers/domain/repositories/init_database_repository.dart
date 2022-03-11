import 'package:sqflite/sqflite.dart';

abstract class InitDatabaseRepository {
  Future<Database> call();
}
