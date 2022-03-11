import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/send_notification_datasource/send_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/domain/entities/notification_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class SendNotificationFireBaseDataSourceImp
    implements SendNotificationDataSource {
  late Database db;

  @override
  Future<Either<Exception, bool>> call(
      {required NotificationEntity notificationEntity}) async {
    try {
      final postUrl = 'https://fcm.googleapis.com/fcm/send';

      final apiKey =
          'AAAAN83oFLA:APA91bFKuxMQfbd97SYgJivNR3x8HHRedDi70_9_POimnNzZl5wZeSud85eehNjVpf2u1cSj6_aVs0qvBfikxbeyc1a5LBa5yAHffwMcRiTl6e4kI2F5xClANTQHMBH1RE5oUCRJNIiQ';

      final headers = {
        'content-type': 'application/json',
        'Authorization': 'key=$apiKey',
      };

      final data = {
        "to": "/topics/all",
        "notification": {
          "title": notificationEntity.title,
          "body": notificationEntity.description
        }
      };

      final response = await http.post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        return Right(true);
      } else {
        return Left(Exception('Error send notification'));
      }
    } catch (e) {
      return Left(Exception('Error send notification'));
    }
  }
}
