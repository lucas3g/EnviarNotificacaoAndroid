class NotificationEntity {
  final int id;
  final String title;
  final String description;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.description,
  });

  NotificationEntity copyWith({
    String? title,
    String? description,
  }) {
    return NotificationEntity(
      id: 0,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
