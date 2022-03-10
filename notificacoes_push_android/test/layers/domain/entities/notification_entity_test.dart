import 'package:flutter_test/flutter_test.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';

void main() {
  test('Espero que a entity não seja nula', () {
    NotificationEntity notificationEntity =
        NotificationEntity(id: 0, title: 'Teste', description: 'teste');

    expect(notificationEntity, isNotNull);
  });

  test('Espero que a entity não seja nula', () {
    NotificationEntity notificationEntity =
        NotificationEntity(id: 0, title: 'Teste', description: 'teste');

    expect(notificationEntity, isNotNull);
  });
}
