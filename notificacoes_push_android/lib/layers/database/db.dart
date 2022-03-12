import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DB {
  DB._();

  static DB? _instance;

  static Database? _db;

  static DB get instance {
    _instance ??= DB._();
    return _instance!;
  }

  Future<Database> get db => openDatabase();

  Future<Database> openDatabase() async {
    sqfliteFfiInit();
    String databasePath = await databaseFactoryFfi.getDatabasesPath();
    String path = join(databasePath, 'notification.db');
    DatabaseFactory databaseFactory = databaseFactoryFfi;

    if (_db == null) {
      _db = await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          onCreate: _onCreate,
          version: 1,
        ),
      );
    }

    return _db!;
  }

  FutureOr<void> _onCreate(Database db, int version) {
    db.transaction((txn) async {
      txn.execute(_notifications);
    });
  }

  String get _notifications => '''
    CREATE TABLE notifications(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT
    )
  ''';
}
