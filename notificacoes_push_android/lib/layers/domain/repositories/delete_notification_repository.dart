import 'package:dartz/dartz.dart';

abstract class DeleteNotificationRepository {
  Future<Either<Exception, bool>> call({required int id});
}
