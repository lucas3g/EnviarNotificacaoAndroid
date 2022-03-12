import 'package:flutter_test/flutter_test.dart';
import 'package:notificacoes_push_android/layers/services/local_storage/helpers/table_entity.dart';
import 'package:notificacoes_push_android/layers/services/local_storage/sqflite/helpers.dart';

void main() {
  test(
    'SqFliteHelpers convertTableToSql should return a String when receive a TableEntity',
    () {
      final fields = {
        TableFieldEntity(name: 'id', type: FieldType.integer, pk: true),
        TableFieldEntity(name: 'title', type: FieldType.string),
        TableFieldEntity(name: 'description', type: FieldType.string),
      };
      final table = TableEntity(name: 'notifications', fields: fields);

      final sqlTable = SqFliteHelpers.convertTableToSql(table);
      expect(sqlTable, equals(expectResponse));
    },
  );
}

final expectResponse =
    'CREATE TABLE notifications(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT NOT NULL, description TEXT NOT NULL)';
