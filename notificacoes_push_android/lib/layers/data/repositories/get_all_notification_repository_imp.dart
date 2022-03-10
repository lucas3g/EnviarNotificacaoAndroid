import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/data/dtos/notification_dto.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/get_all_notification_repository.dart';

class GetAllNotificationRepositoryImp implements GetAllNotificationRepository {
  final GetAllNotificationDataSource _getAllNotificationDataSource;

  GetAllNotificationRepositoryImp(this._getAllNotificationDataSource);

  @override
  Future<List<NotificationEntity>> call() async {
    var json = {
      'id': 0,
      'title': 'Teste',
      'description': 'teste',
    };

    final List<NotificationEntity> list = [];

    list.add(NotificationDto.fromMap(json));

    return await Future.delayed(Duration(milliseconds: 500)).then((value) {
      return list;
    });
  }
}
