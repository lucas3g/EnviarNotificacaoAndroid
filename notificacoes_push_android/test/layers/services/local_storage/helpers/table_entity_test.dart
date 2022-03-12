import 'package:flutter_test/flutter_test.dart';
import 'package:notificacoes_push_android/layers/services/local_storage/helpers/table_entity.dart';

void main() {
  test('TableEntity should be created', () {
    final fields = {
      TableFieldEntity(name: 'id', type: FieldType.integer, pk: true),
      TableFieldEntity(name: 'title', type: FieldType.string),
      TableFieldEntity(name: 'description', type: FieldType.string),
    };
    final table = TableEntity(name: 'notifications', fields: fields);

    expect(table, isA<TableEntity>());
  });

  test(
    'TableEntity should throws AssertionError when receive 2+ pk fields',
    () {
      final fields = {
        TableFieldEntity(name: 'id', type: FieldType.integer, pk: true),
        TableFieldEntity(name: 'title', type: FieldType.string, pk: true),
        TableFieldEntity(name: 'description', type: FieldType.string),
      };

      expect(
        () => TableEntity(name: 'notifications', fields: fields),
        throwsA(isA<AssertionError>()),
      );
    },
  );

  test(
    'TableEntity should throws AssertionError when dont receive any pk field',
    () {
      final fields = {
        TableFieldEntity(name: 'id', type: FieldType.integer),
        TableFieldEntity(name: 'title', type: FieldType.string),
        TableFieldEntity(name: 'description', type: FieldType.string),
      };

      expect(
        () => TableEntity(name: 'notifications', fields: fields),
        throwsA(isA<AssertionError>()),
      );
    },
  );

  test('TableEntity should has 2 fields when name fields is same', () {
    final fields = {
      TableFieldEntity(name: 'id', type: FieldType.integer, pk: true),
      TableFieldEntity(name: 'title', type: FieldType.string),
      TableFieldEntity(name: 'title', type: FieldType.integer),
    };
    final table = TableEntity(name: 'notifications', fields: fields);

    expect(table.fields.length, equals(2));
  });
}
