import 'package:notificacoes_push_android/layers/services/local_storage/helpers/params.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../helpers/table_entity.dart';
import '../local_storage_service.dart';
import 'helpers.dart';

class SqfliteLocalStorageServiceImp implements LocalStorageService {
  late Set<TableEntity> _tables;
  static Database? _db;

  SqfliteLocalStorageServiceImp();

  @override
  Future<void> create(LocalStorageCreateParam param) async {
    await _db!.transaction((txn) async {
      await txn.insert(param.table.name, param.data);
    });
  }

  @override
  Future<void> delete(LocalStorageDeleteParam param) async {
    await _db!.transaction((txn) async {
      await txn.delete(
        param.table.name,
        where: 'id = ?',
        whereArgs: [param.id],
      );
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(
      LocalStorageGetAllParam param) async {
    try {
      List<Map<String, dynamic>> result = [];

      await _db!.transaction((txn) async {
        result = await txn.query(
          param.table.name,
        );
      });

      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPerFilter(
      LocalStorageGetPerFilterParam param) async {
    late List<Map<String, dynamic>> result;

    final where = param.filters
        ?.map(SqFliteHelpers.convertFilterToSqlWhere)
        .join(' and ');

    await _db!.transaction((txn) async {
      result = await txn.query(
        param.table.name,
        where: where,
        whereArgs: param.filters
            ?.map(SqFliteHelpers.convertFilterToSqlWhereArgs)
            .toList(),
      );
    });

    return List<Map<String, dynamic>>.from(result);
  }

  @override
  Future<void> init(LocalStorageInitParam param) async {
    _tables = param.tables;

    sqfliteFfiInit();
    String databasePath = await databaseFactoryFfi.getDatabasesPath();
    String path = join(databasePath, param.fileName);
    DatabaseFactory databaseFactory = databaseFactoryFfi;

    if (_db == null) {
      _db = await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (Database db, int version) {
            return SqFliteHelpers.onCreate(_tables, db, version);
          },
        ),
      );
    }
  }
}
