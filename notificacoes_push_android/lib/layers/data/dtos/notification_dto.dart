import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';

class NotificationDto extends NotificationEntity {
  int id;
  String title;
  String description;

  NotificationDto({
    required this.id,
    required this.title,
    required this.description,
  }) : super(id: id, title: title, description: description);

  Map toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'description': this.description,
    };
  }

  static NotificationDto fromMap(Map map) {
    return NotificationDto(
        id: map['id'], title: map['title'], description: map['description']);
  }
}
