import 'filter_entity.dart';
import 'local_storage_tables.dart';
import 'table_entity.dart';

class LocalStorageCreateParam {
  final LocalStorageTables table;
  final Map<String, dynamic> data;

  LocalStorageCreateParam({
    required this.table,
    required this.data,
  });
}

class LocalStorageDeleteParam {
  final LocalStorageTables table;
  final int id;

  LocalStorageDeleteParam({
    required this.table,
    required this.id,
  });
}

class LocalStorageGetAllParam {
  final LocalStorageTables table;

  LocalStorageGetAllParam({
    required this.table,
  });
}

class LocalStorageGetPerFilterParam {
  final LocalStorageTables table;
  final Set<FilterEntity>? filters;

  LocalStorageGetPerFilterParam({
    required this.table,
    this.filters,
  });
}

class LocalStorageInitParam {
  final String fileName;
  final Set<TableEntity> tables;

  LocalStorageInitParam({
    required this.fileName,
    required this.tables,
  });
}
